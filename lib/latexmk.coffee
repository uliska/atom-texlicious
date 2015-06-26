{exec, spawn} = require 'child_process'
fs = require 'fs'
path = require 'path'

module.exports =
class Latexmk
  constructor: (params) ->
    @texliciousCore = params.texliciousCore

  make: (args, options, callback) ->
    command = "latexmk #{args.join(' ')}"
    proc = exec command, options, (error, stdout, stderr) ->
      if error?
        console.log error
        callback(error.code)
      else
        callback(0)
    proc

  args: (texFile) ->
    latexmkArgs = {
      default: '-interaction=nonstopmode -f -cd -pdf -file-line-error'
    }

    bibtexEnabled = atom.config.get('texlicious.bibtexEnabled')
    shellEscapeEnabled = atom.config.get('texlicious.shellEscapeEnabled')
    synctexEnabled = atom.config.get('texlicious.synctexEnabled')
    program = atom.config.get('texlicious.texFlavor')
    outputDirectory = atom.config.get('texlicious.outputDirectory')
    console.log latexmkArgs
    latexmkArgs.bibtex = '-bibtex' if bibtexEnabled
    console.log latexmkArgs
    latexmkArgs.shellEscape = '-shell-escape' if shellEscapeEnabled
    console.log latexmkArgs
    latexmkArgs.synctex = '-synctex=1' if synctexEnabled
    console.log latexmkArgs
    latexmkArgs.program = "-#{program}" if program? and program isnt 'pdflatex'
    console.log latexmkArgs
    latexmkArgs.outdir = "-outdir=\"#{path.join(@texliciousCore.getTexProjectRoot(), outputDirectory)}\"" if outputDirectory isnt ''
    console.log latexmkArgs
    latexmkArgs.root = "\"#{texFile}\""
    console.log latexmkArgs

    latexmkArgs

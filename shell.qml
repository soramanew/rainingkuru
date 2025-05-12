pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Particles

Scope {
    id: root

    property point cursor

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: win

            required property ShellScreen modelData

            screen: modelData
            aboveWindows: false
            color: "transparent"

            anchors.top: true
            anchors.left: true
            anchors.bottom: true
            anchors.right: true

            ParticleSystem {
                anchors.fill: parent

                ImageParticle {
                    groups: ["kuru"]
                    sprites: Sprite {
                        source: "kuru.png"
                        frameCount: 6
                        frameDuration: 80
                    }
                    spritesInterpolate: false

                    rotationVariation: 360
                    rotationVelocityVariation: 360
                }

                ImageParticle {
                    groups: ["trail"]
                    source: "qrc:///particleresources/glowdot.png"
                    color: "#00333333"
                    z: -2
                }

                ImageParticle {
                    groups: ["fire"]
                    source: "qrc:///particleresources/glowdot.png"
                    color: "#00ff400f"
                    colorVariation: 0.1
                    z: -1
                }

                Emitter {
                    anchors.bottom: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right

                    group: "kuru"
                    emitRate: 200
                    lifeSpan: 2000
                    lifeSpanVariation: 1000

                    size: 60
                    endSize: 50
                    sizeVariation: 30

                    velocity: AngleDirection {
                        angleVariation: 360
                        magnitude: 80
                        magnitudeVariation: 100
                    }
                }

                TrailEmitter {
                    follow: "kuru"
                    group: "trail"
                    emitRatePerParticle: 20

                    size: 36
                    sizeVariation: 8
                    endSize: 16

                    velocity: AngleDirection {
                        angleVariation: 360
                        magnitude: 20
                        magnitudeVariation: 10
                    }
                }

                TrailEmitter {
                    follow: "kuru"
                    group: "fire"
                    emitRatePerParticle: 20

                    size: 36
                    sizeVariation: 8
                    endSize: 16

                    velocity: AngleDirection {
                        angleVariation: 360
                        magnitude: 20
                        magnitudeVariation: 10
                    }
                }

                Gravity {
                    groups: ["kuru"]
                    magnitude: 500
                }

                Turbulence {
                    groups: ["trail"]
                    strength: 32
                }

                Attractor {
                    pointX: root.cursor.x
                    pointY: root.cursor.y
                    groups: ["kuru"]
                    strength: 0.005
                    proportionalToDistance: Attractor.Quadratic
                }
            }
        }
    }

    Process {
        id: cursorProc

        command: ["hyprctl", "cursorpos"]
        stdout: SplitParser {
            onRead: data => root.cursor = data
        }
    }

    FrameAnimation {
        running: true
        onTriggered: cursorProc.running = true
    }
}

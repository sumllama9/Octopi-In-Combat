function love.load ()

    --collisions

    windf = require 'Librarys/windfield'
    world = windf.newWorld(0,0)


    --player


    plr = {}
    plr.x = 800
    plr.y = 800
    plr.speed = 500
    plr.sidespeed = 400
    plr.ScaleSize = 3

    plr.User = "Player"
    plr.Health = 100

    --plr collider

    plr.collider = world:newBSGRectangleCollider(800, 800, 90, 60, 20)
    plr.collider:setFixedRotation(true)


    --map and collisions


    Sti = require 'Librarys/sti'
    desertmap = Sti('Maps/DesertMap.lua')

    collisionHitboxes = {}

    if desertmap.layers["Walls"] then
        for i, v in pairs(desertmap.layers["Walls"].objects) do
            local wall = world:newRectangleCollider(v.x, v.y, v.width, v.height)
            wall:setType('static')

            table.insert(collisionHitboxes, wall)
        end    
    end

    if desertmap.layers["Objects"] then
        for i, g in pairs(desertmap.layers["Objects"].objects) do
            local wall = world:newRectangleCollider(g.x, g.y, g.width, g.height)
            wall:setType('static')

            table.insert(collisionHitboxes, wall)
        end    
    end


   -- plr animate

    anim8 = require 'Librarys/anim8'

    plr.image = love.graphics.newImage("Images/OctoPlr.png")
    plr.grid = anim8.newGrid(32, 32, plr.image:getWidth(), plr.image:getHeight())

    plr.animation =  {}
    plr.animation.right = anim8.newAnimation(plr.grid('1-5', 1), 0.1)
    plr.animation.left = anim8.newAnimation(plr.grid('1-5', 2), 0.1)

    plr.anim = plr.animation.right


    --gun

    gunangle = 0
    gunImage = love.graphics.newImage("Images/Gun.jpg")

    --camera

    camera = require 'Librarys.camera'
    cam = camera()

    cam:zoom(0.5)


    --sfx

    sounds = {}

    sounds.click = love.audio.newSource("SFX/Click.mp3", "static")

end



function love.update (dt)

    local moving = false
    
    local velx = 0
    local vely = 0


    if love.keyboard.isDown("w") then

        moving = true

        if love.keyboard.isDown("d") then
            plr.anim = plr.animation.right

            vely = (plr.sidespeed) * -1
            velx = plr.sidespeed

        elseif love.keyboard.isDown("a") then
            plr.anim = plr.animation.left

            vely = (plr.sidespeed) * -1
            velx = (plr.sidespeed) * -1
        end

        vely = plr.speed * -1

    elseif love.keyboard.isDown("s") then

        moving = true

        vely = (plr.speed)

        
        if love.keyboard.isDown("d") then
            plr.anim = plr.animation.right

            vely = (plr.sidespeed)
            velx = (plr.sidespeed)

        elseif love.keyboard.isDown("a") then
            plr.anim = plr.animation.left

            vely = (plr.sidespeed) 
            velx = (plr.sidespeed) * -1
        end

    elseif love.keyboard.isDown("d") then

        moving = true


    plr.anim = plr.animation.right

        velx = plr.speed

     elseif love.keyboard.isDown("a") then
    plr.anim = plr.animation.left

        moving = true


       velx = plr.speed * -1
    end

    world:update(dt)

    plr.collider:setLinearVelocity(velx, vely)

    plr.x = plr.collider:getX()
    plr.y = plr.collider:getY()



    local gunX = plr.x + 45
    local gunY = plr.y + 30

    local MouseY = love.mouse.getY()
    local MouseX = love.mouse.getX()

    gunangle = math.atan2(MouseY - gunY, MouseX - gunX)

    cam:lookAt(plr.x, plr.y)

    local ScreenWidth = love.graphics.getWidth()
    local ScreenHeight = love.graphics.getHeight()

    local desertWidth = desertmap.width * desertmap.tilewidth
    local desertHeight = desertmap.height * desertmap.tileheight

    --screen borders

    if cam.x < ScreenWidth then

        cam.x = ScreenWidth 

    end
    if cam.y < ScreenHeight then

        cam.y = ScreenHeight

    end

    if cam.x > (desertWidth - ScreenWidth) then
        
        cam.x = (desertWidth - ScreenWidth)

    end
        if cam.y > (desertHeight - ScreenHeight) then
        
        cam.y = (desertHeight - ScreenHeight)

    end



    plr.anim:update(dt)


    if moving == false then
        plr.anim:gotoFrame(1)
    end
end

function love.draw ()


    cam:attach()

        love.graphics.setBackgroundColor(1,1,0)

        desertmap:drawLayer(desertmap.layers["Bottom"])
        desertmap:drawLayer(desertmap.layers["BottomObj"])
        desertmap:drawLayer(desertmap.layers["Middle"])
        desertmap:drawLayer(desertmap.layers["MiddleObj"])
        desertmap:drawLayer(desertmap.layers["Top"])
        desertmap:drawLayer(desertmap.layers["TopObj"])


        love.graphics.setColor(0, 1, 0)

        --world:draw()

        love.graphics.setColor(1,1,1,1)
        
        plr.anim:draw(plr.image, plr.x, plr.y, nil, plr.ScaleSize, plr.ScaleSize, 16, 16)


        UserText = love.graphics.print(plr.User, plr.x, plr.y - 60)
        HealthText = love.graphics.print(plr.Health, plr.x, plr.y - 50)

        love.graphics.setColor(1,1,1)


        gun = love.graphics.draw(gunImage, 
        plr.x + 60, plr.y + 50, 
        gunangle, 
        0.04, 0.04, 
        gunImage:getWidth() / 2, gunImage:getHeight() / 2
        )   

    cam:detach() 

    --love.graphics.print("Gamecode:".. )
end


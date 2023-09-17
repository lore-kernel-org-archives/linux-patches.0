Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2C76FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D966C433C7;
	Sun, 17 Sep 2023 20:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981077;
	bh=Wol+DELWex9HdLbw+G93WqCqoGDohPzsMLbJIPM68s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hKYQiNXm9BFnpjjviH28yWOaiOwCkcqthMru8tIfmxf8u2AmQzGNz5k9f/8fmqtCu
	 z8hu76ut7WKzIX+3s9ddG111lB4KSbi8LA40bOb2GG5z6EccAzaVwCQiuZTxt8CZWx
	 hN+2M61H9Xn4mIfB/1qmdfo11/A+7WTM6Nz/ysWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/219] Input: tca6416-keypad - always expect proper IRQ number in i2c client
Date: Sun, 17 Sep 2023 21:13:17 +0200
Message-ID: <20230917191043.524768673@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 687fe7dfb736b03ab820d172ea5dbfc1ec447135 ]

Remove option having i2c client contain raw gpio number instead of proper
IRQ number. There are no users of this facility in mainline and it will
allow cleaning up the driver code with regard to wakeup handling, etc.

Link: https://lore.kernel.org/r/20230724053024.352054-1-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Stable-dep-of: cc141c35af87 ("Input: tca6416-keypad - fix interrupt enable disbalance")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/tca6416-keypad.c | 27 +++++++++----------------
 include/linux/tca6416_keypad.h          |  1 -
 2 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/input/keyboard/tca6416-keypad.c b/drivers/input/keyboard/tca6416-keypad.c
index afcdfbb002ff3..b48adec8fe2e7 100644
--- a/drivers/input/keyboard/tca6416-keypad.c
+++ b/drivers/input/keyboard/tca6416-keypad.c
@@ -148,7 +148,7 @@ static int tca6416_keys_open(struct input_dev *dev)
 	if (chip->use_polling)
 		schedule_delayed_work(&chip->dwork, msecs_to_jiffies(100));
 	else
-		enable_irq(chip->irqnum);
+		enable_irq(chip->client->irq);
 
 	return 0;
 }
@@ -160,7 +160,7 @@ static void tca6416_keys_close(struct input_dev *dev)
 	if (chip->use_polling)
 		cancel_delayed_work_sync(&chip->dwork);
 	else
-		disable_irq(chip->irqnum);
+		disable_irq(chip->client->irq);
 }
 
 static int tca6416_setup_registers(struct tca6416_keypad_chip *chip)
@@ -266,12 +266,7 @@ static int tca6416_keypad_probe(struct i2c_client *client,
 		goto fail1;
 
 	if (!chip->use_polling) {
-		if (pdata->irq_is_gpio)
-			chip->irqnum = gpio_to_irq(client->irq);
-		else
-			chip->irqnum = client->irq;
-
-		error = request_threaded_irq(chip->irqnum, NULL,
+		error = request_threaded_irq(client->irq, NULL,
 					     tca6416_keys_isr,
 					     IRQF_TRIGGER_FALLING |
 					     IRQF_ONESHOT | IRQF_NO_AUTOEN,
@@ -279,7 +274,7 @@ static int tca6416_keypad_probe(struct i2c_client *client,
 		if (error) {
 			dev_dbg(&client->dev,
 				"Unable to claim irq %d; error %d\n",
-				chip->irqnum, error);
+				client->irq, error);
 			goto fail1;
 		}
 	}
@@ -298,8 +293,8 @@ static int tca6416_keypad_probe(struct i2c_client *client,
 
 fail2:
 	if (!chip->use_polling) {
-		free_irq(chip->irqnum, chip);
-		enable_irq(chip->irqnum);
+		free_irq(client->irq, chip);
+		enable_irq(client->irq);
 	}
 fail1:
 	input_free_device(input);
@@ -312,8 +307,8 @@ static void tca6416_keypad_remove(struct i2c_client *client)
 	struct tca6416_keypad_chip *chip = i2c_get_clientdata(client);
 
 	if (!chip->use_polling) {
-		free_irq(chip->irqnum, chip);
-		enable_irq(chip->irqnum);
+		free_irq(client->irq, chip);
+		enable_irq(client->irq);
 	}
 
 	input_unregister_device(chip->input);
@@ -324,10 +319,9 @@ static void tca6416_keypad_remove(struct i2c_client *client)
 static int tca6416_keypad_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	struct tca6416_keypad_chip *chip = i2c_get_clientdata(client);
 
 	if (device_may_wakeup(dev))
-		enable_irq_wake(chip->irqnum);
+		enable_irq_wake(client->irq);
 
 	return 0;
 }
@@ -335,10 +329,9 @@ static int tca6416_keypad_suspend(struct device *dev)
 static int tca6416_keypad_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	struct tca6416_keypad_chip *chip = i2c_get_clientdata(client);
 
 	if (device_may_wakeup(dev))
-		disable_irq_wake(chip->irqnum);
+		disable_irq_wake(client->irq);
 
 	return 0;
 }
diff --git a/include/linux/tca6416_keypad.h b/include/linux/tca6416_keypad.h
index b0d36a9934ccd..5cf6f6f82aa70 100644
--- a/include/linux/tca6416_keypad.h
+++ b/include/linux/tca6416_keypad.h
@@ -25,7 +25,6 @@ struct tca6416_keys_platform_data {
 	unsigned int rep:1;	/* enable input subsystem auto repeat */
 	uint16_t pinmask;
 	uint16_t invert;
-	int irq_is_gpio;
 	int use_polling;	/* use polling if Interrupt is not connected*/
 };
 #endif
-- 
2.40.1




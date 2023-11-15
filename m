Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292553A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vI6K2ute"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77EFC433C9;
	Wed, 15 Nov 2023 19:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077620;
	bh=fsajHMMaFKnQYJgvp2ZPQ/HXC7VLFxqW/sSGM0B5AUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vI6K2uteSqzvhn7oglXywCEyCjAuGvoGOGECyfZEE+TXHB94QijwrrOjS7ODZanzU
	 KLENQ1A8zjYobGJ8K8FkWISYt2WoPjxjbIwVdQR5P7+ueaFpa02arR70ZrTmaz5GOT
	 Oh+73SGhbrs4TeNYTbtd7Wld/kI2aInE8QvUD9Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 414/603] leds: turris-omnia: Do not use SMBUS calls
Date: Wed, 15 Nov 2023 14:15:59 -0500
Message-ID: <20231115191641.609203062@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 6de283b96b31b4890e3ee8c86caca2a3a30d1011 ]

The leds-turris-omnia driver uses three function for I2C access:
- i2c_smbus_write_byte_data() and i2c_smbus_read_byte_data(), which
  cause an emulated SMBUS transfer,
- i2c_master_send(), which causes an ordinary I2C transfer.

The Turris Omnia MCU LED controller is not semantically SMBUS, it
operates as a simple I2C bus. It does not implement any of the SMBUS
specific features, like PEC, or procedure calls, or anything. Moreover
the I2C controller driver also does not implement SMBUS, and so the
emulated SMBUS procedure from drivers/i2c/i2c-core-smbus.c is used for
the SMBUS calls, which gives an unnecessary overhead.

When I first wrote the driver, I was unaware of these facts, and I
simply used the first function that worked.

Drop the I2C SMBUS calls and instead use simple I2C transfers.

Fixes: 089381b27abe ("leds: initial support for Turris Omnia LEDs")
Signed-off-by: Marek Behún <kabel@kernel.org>
Link: https://lore.kernel.org/r/20230918161104.20860-2-kabel@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-turris-omnia.c | 54 +++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/drivers/leds/leds-turris-omnia.c b/drivers/leds/leds-turris-omnia.c
index b8a95a917cfa4..b13a547e72c49 100644
--- a/drivers/leds/leds-turris-omnia.c
+++ b/drivers/leds/leds-turris-omnia.c
@@ -2,7 +2,7 @@
 /*
  * CZ.NIC's Turris Omnia LEDs driver
  *
- * 2020 by Marek Behún <kabel@kernel.org>
+ * 2020, 2023 by Marek Behún <kabel@kernel.org>
  */
 
 #include <linux/i2c.h>
@@ -41,6 +41,37 @@ struct omnia_leds {
 	struct omnia_led leds[];
 };
 
+static int omnia_cmd_write_u8(const struct i2c_client *client, u8 cmd, u8 val)
+{
+	u8 buf[2] = { cmd, val };
+
+	return i2c_master_send(client, buf, sizeof(buf));
+}
+
+static int omnia_cmd_read_u8(const struct i2c_client *client, u8 cmd)
+{
+	struct i2c_msg msgs[2];
+	u8 reply;
+	int ret;
+
+	msgs[0].addr = client->addr;
+	msgs[0].flags = 0;
+	msgs[0].len = 1;
+	msgs[0].buf = &cmd;
+	msgs[1].addr = client->addr;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len = 1;
+	msgs[1].buf = &reply;
+
+	ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
+	if (likely(ret == ARRAY_SIZE(msgs)))
+		return reply;
+	else if (ret < 0)
+		return ret;
+	else
+		return -EIO;
+}
+
 static int omnia_led_brightness_set_blocking(struct led_classdev *cdev,
 					     enum led_brightness brightness)
 {
@@ -64,7 +95,7 @@ static int omnia_led_brightness_set_blocking(struct led_classdev *cdev,
 	if (buf[2] || buf[3] || buf[4])
 		state |= CMD_LED_STATE_ON;
 
-	ret = i2c_smbus_write_byte_data(leds->client, CMD_LED_STATE, state);
+	ret = omnia_cmd_write_u8(leds->client, CMD_LED_STATE, state);
 	if (ret >= 0 && (state & CMD_LED_STATE_ON))
 		ret = i2c_master_send(leds->client, buf, 5);
 
@@ -114,9 +145,9 @@ static int omnia_led_register(struct i2c_client *client, struct omnia_led *led,
 	cdev->brightness_set_blocking = omnia_led_brightness_set_blocking;
 
 	/* put the LED into software mode */
-	ret = i2c_smbus_write_byte_data(client, CMD_LED_MODE,
-					CMD_LED_MODE_LED(led->reg) |
-					CMD_LED_MODE_USER);
+	ret = omnia_cmd_write_u8(client, CMD_LED_MODE,
+				 CMD_LED_MODE_LED(led->reg) |
+				 CMD_LED_MODE_USER);
 	if (ret < 0) {
 		dev_err(dev, "Cannot set LED %pOF to software mode: %i\n", np,
 			ret);
@@ -124,8 +155,8 @@ static int omnia_led_register(struct i2c_client *client, struct omnia_led *led,
 	}
 
 	/* disable the LED */
-	ret = i2c_smbus_write_byte_data(client, CMD_LED_STATE,
-					CMD_LED_STATE_LED(led->reg));
+	ret = omnia_cmd_write_u8(client, CMD_LED_STATE,
+				 CMD_LED_STATE_LED(led->reg));
 	if (ret < 0) {
 		dev_err(dev, "Cannot set LED %pOF brightness: %i\n", np, ret);
 		return ret;
@@ -158,7 +189,7 @@ static ssize_t brightness_show(struct device *dev, struct device_attribute *a,
 	struct i2c_client *client = to_i2c_client(dev);
 	int ret;
 
-	ret = i2c_smbus_read_byte_data(client, CMD_LED_GET_BRIGHTNESS);
+	ret = omnia_cmd_read_u8(client, CMD_LED_GET_BRIGHTNESS);
 
 	if (ret < 0)
 		return ret;
@@ -179,8 +210,7 @@ static ssize_t brightness_store(struct device *dev, struct device_attribute *a,
 	if (brightness > 100)
 		return -EINVAL;
 
-	ret = i2c_smbus_write_byte_data(client, CMD_LED_SET_BRIGHTNESS,
-					(u8)brightness);
+	ret = omnia_cmd_write_u8(client, CMD_LED_SET_BRIGHTNESS, brightness);
 
 	return ret < 0 ? ret : count;
 }
@@ -237,8 +267,8 @@ static void omnia_leds_remove(struct i2c_client *client)
 	u8 buf[5];
 
 	/* put all LEDs into default (HW triggered) mode */
-	i2c_smbus_write_byte_data(client, CMD_LED_MODE,
-				  CMD_LED_MODE_LED(OMNIA_BOARD_LEDS));
+	omnia_cmd_write_u8(client, CMD_LED_MODE,
+			   CMD_LED_MODE_LED(OMNIA_BOARD_LEDS));
 
 	/* set all LEDs color to [255, 255, 255] */
 	buf[0] = CMD_LED_COLOR;
-- 
2.42.0




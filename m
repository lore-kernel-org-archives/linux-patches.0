Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE3835CB71;
	Fri,  9 Jan 2026 12:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962718; cv=none; b=teKigQHZtreL24px97KWMC9W5lvqN2UbxUoM5Lr/FdezrLUma7A6E7e8zNiHuF/K9LRyts6+MvDnTUkhyR6iMEOzjAzYIHgn88sPYlcJD4CpCU8QqasNoVcJpIPYkxv1TKovn17ubX3oKpCkd8kSROrWVGQfQb5LHkG1cfPmsJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962718; c=relaxed/simple;
	bh=h5O9Ph7+aznAyu/Sdw7qyUOfD4JtJk5N5LZDRKK/9/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CykKpvgF9w8gHd3hHaTbqK8RcF5RzHqYD/pj7ymRc8mn9s/Dsh2YH8rNJv7HGTW6kb44/NBMFeBEbI5vN35l16GY8k7KxebPnKvxPxKR7CHwwp/AsQo0fgEu7GLu+ztMReG/SSI3uV7DEUKuzoWfeXXO5qYlbXpJaDIR8EoJwxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcksKq2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcksKq2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B102C19421;
	Fri,  9 Jan 2026 12:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962718;
	bh=h5O9Ph7+aznAyu/Sdw7qyUOfD4JtJk5N5LZDRKK/9/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcksKq2YwYqZRQt25NL7znFRdaRBPXXJH/lRo3g3XzPutlE7Lq7f5JMYwDm0/EKqm
	 BG9aOo+L2pU+tIKk5RT63kAWqxVVqeesgYIXfp+KCy86wcKJd4bg0z+lvS56VEn7s7
	 Qpid6u2lPI93SD5A/oA4QiEWtNO9GDpllyMNoomQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hitz <christian.hitz@bbv.ch>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.1 464/634] leds: leds-lp50xx: Enable chip before any communication
Date: Fri,  9 Jan 2026 12:42:22 +0100
Message-ID: <20260109112135.009652066@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Hitz <christian.hitz@bbv.ch>

commit 434959618c47efe9e5f2e20f4a850caac4f6b823 upstream.

If a GPIO is used to control the chip's enable pin, it needs to be pulled
high before any i2c communication is attempted.

Currently, the enable GPIO handling is not correct.

Assume the enable GPIO is low when the probe function is entered. In this
case the device is in SHUTDOWN mode and does not react to i2c commands.

During probe the following sequence happens:
 1. The call to lp50xx_reset() on line 548 has no effect as i2c is not
    possible yet.
 2. Then - on line 552 - lp50xx_enable_disable() is called. As
    "priv->enable_gpio“ has not yet been initialized, setting the GPIO has
    no effect. Also the i2c enable command is not executed as the device
    is still in SHUTDOWN.
 3. On line 556 the call to lp50xx_probe_dt() finally parses the rest of
    the DT and the configured priv->enable_gpio is set up.

As a result the device is still in SHUTDOWN mode and not ready for
operation.

Split lp50xx_enable_disable() into distinct enable and disable functions
to enforce correct ordering between enable_gpio manipulations and i2c
commands.
Read enable_gpio configuration from DT before attempting to manipulate
enable_gpio.
Add delays to observe correct wait timing after manipulating enable_gpio
and before any i2c communication.

Cc: stable@vger.kernel.org
Fixes: 242b81170fb8 ("leds: lp50xx: Add the LP50XX family of the RGB LED driver")
Signed-off-by: Christian Hitz <christian.hitz@bbv.ch>
Link: https://patch.msgid.link/20251028155141.1603193-1-christian@klarinett.li
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp50xx.c |   55 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 15 deletions(-)

--- a/drivers/leds/leds-lp50xx.c
+++ b/drivers/leds/leds-lp50xx.c
@@ -52,6 +52,12 @@
 
 #define LP50XX_SW_RESET		0xff
 #define LP50XX_CHIP_EN		BIT(6)
+#define LP50XX_CHIP_DISABLE	0x00
+#define LP50XX_START_TIME_US	500
+#define LP50XX_RESET_TIME_US	3
+
+#define LP50XX_EN_GPIO_LOW	0
+#define LP50XX_EN_GPIO_HIGH	1
 
 /* There are 3 LED outputs per bank */
 #define LP50XX_LEDS_PER_MODULE	3
@@ -374,19 +380,42 @@ static int lp50xx_reset(struct lp50xx *p
 	return regmap_write(priv->regmap, priv->chip_info->reset_reg, LP50XX_SW_RESET);
 }
 
-static int lp50xx_enable_disable(struct lp50xx *priv, int enable_disable)
+static int lp50xx_enable(struct lp50xx *priv)
 {
 	int ret;
 
-	ret = gpiod_direction_output(priv->enable_gpio, enable_disable);
+	if (priv->enable_gpio) {
+		ret = gpiod_direction_output(priv->enable_gpio, LP50XX_EN_GPIO_HIGH);
+		if (ret)
+			return ret;
+
+		udelay(LP50XX_START_TIME_US);
+	}
+
+	ret = lp50xx_reset(priv);
 	if (ret)
 		return ret;
 
-	if (enable_disable)
-		return regmap_write(priv->regmap, LP50XX_DEV_CFG0, LP50XX_CHIP_EN);
-	else
-		return regmap_write(priv->regmap, LP50XX_DEV_CFG0, 0);
+	return regmap_write(priv->regmap, LP50XX_DEV_CFG0, LP50XX_CHIP_EN);
+}
 
+static int lp50xx_disable(struct lp50xx *priv)
+{
+	int ret;
+
+	ret = regmap_write(priv->regmap, LP50XX_DEV_CFG0, LP50XX_CHIP_DISABLE);
+	if (ret)
+		return ret;
+
+	if (priv->enable_gpio) {
+		ret = gpiod_direction_output(priv->enable_gpio, LP50XX_EN_GPIO_LOW);
+		if (ret)
+			return ret;
+
+		udelay(LP50XX_RESET_TIME_US);
+	}
+
+	return 0;
 }
 
 static int lp50xx_probe_leds(struct fwnode_handle *child, struct lp50xx *priv,
@@ -453,6 +482,10 @@ static int lp50xx_probe_dt(struct lp50xx
 		return dev_err_probe(priv->dev, PTR_ERR(priv->enable_gpio),
 				     "Failed to get enable GPIO\n");
 
+	ret = lp50xx_enable(priv);
+	if (ret)
+		return ret;
+
 	priv->regulator = devm_regulator_get(priv->dev, "vled");
 	if (IS_ERR(priv->regulator))
 		priv->regulator = NULL;
@@ -559,14 +592,6 @@ static int lp50xx_probe(struct i2c_clien
 		return ret;
 	}
 
-	ret = lp50xx_reset(led);
-	if (ret)
-		return ret;
-
-	ret = lp50xx_enable_disable(led, 1);
-	if (ret)
-		return ret;
-
 	return lp50xx_probe_dt(led);
 }
 
@@ -575,7 +600,7 @@ static void lp50xx_remove(struct i2c_cli
 	struct lp50xx *led = i2c_get_clientdata(client);
 	int ret;
 
-	ret = lp50xx_enable_disable(led, 0);
+	ret = lp50xx_disable(led);
 	if (ret)
 		dev_err(led->dev, "Failed to disable chip\n");
 



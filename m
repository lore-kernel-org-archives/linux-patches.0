Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ECE3D331E;
	Thu, 15 Jan 2026 17:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499949; cv=none; b=lQnqbVVCm0u2b2TZd061tau7TVel7N3aZtvn55rDKitIWuk1qXJ3Pc7fsWZzCQi+XTlMBmNfb7vSKLVDP6uIXfwysGpJc/ZzW1lddBEZp7lyX6f0SllDoZLifwQw+fo+98/vGFoM8CHTtck3ukN98QKl+PlG8xrFNsL5gTmQKB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499949; c=relaxed/simple;
	bh=VwhL7cbtuK1spvcuoHE6Pys2TXUQ0ZLSbwNlm5vhwv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o/meLReNxlF1PsZtLiqpDYsVM+0cDkWwEusCnfTYyKk5R2ospBwjsQnw9LsQY29hGCpEwYWpXFvmFvGwHQYhvai5AARXcLmlI1xcxLI9USCs8WZBRAAdoeSxTorvxJwRzo+QJxKIK/XracgZh9iZU0pGm3dqw2m6oBOvzuboGhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s1r6VpD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s1r6VpD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D82C116D0;
	Thu, 15 Jan 2026 17:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499949;
	bh=VwhL7cbtuK1spvcuoHE6Pys2TXUQ0ZLSbwNlm5vhwv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1r6VpD0zvhWOmE3PvSSq/ZC6cBkG2qrUHcgXDvHWlFvlPbEhuh2KpVcvRJEJQ3t0
	 bCObolYG4BONE66oKmMfGjx+08tGdv8Q2HyyHJO2syZd8l4jQmiRQXHAFNdKUZvi60
	 Rox5zyA+x/pKZNSS1PmXU4VpqDFuczhwGsDGnzig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hitz <christian.hitz@bbv.ch>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 404/451] leds: leds-lp50xx: Enable chip before any communication
Date: Thu, 15 Jan 2026 17:50:05 +0100
Message-ID: <20260115164245.555304596@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Hitz <christian.hitz@bbv.ch>

[ Upstream commit 434959618c47efe9e5f2e20f4a850caac4f6b823 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/leds-lp50xx.c |   55 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 15 deletions(-)

--- a/drivers/leds/leds-lp50xx.c
+++ b/drivers/leds/leds-lp50xx.c
@@ -53,6 +53,12 @@
 
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
@@ -376,19 +382,42 @@ static int lp50xx_reset(struct lp50xx *p
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
@@ -458,6 +487,10 @@ static int lp50xx_probe_dt(struct lp50xx
 		return ret;
 	}
 
+	ret = lp50xx_enable(priv);
+	if (ret)
+		return ret;
+
 	priv->regulator = devm_regulator_get(priv->dev, "vled");
 	if (IS_ERR(priv->regulator))
 		priv->regulator = NULL;
@@ -565,14 +598,6 @@ static int lp50xx_probe(struct i2c_clien
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
 
@@ -581,7 +606,7 @@ static int lp50xx_remove(struct i2c_clie
 	struct lp50xx *led = i2c_get_clientdata(client);
 	int ret;
 
-	ret = lp50xx_enable_disable(led, 0);
+	ret = lp50xx_disable(led);
 	if (ret)
 		dev_err(led->dev, "Failed to disable chip\n");
 



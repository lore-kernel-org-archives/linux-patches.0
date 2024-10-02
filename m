Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123151D0DD5;
	Wed,  2 Oct 2024 14:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879935; cv=none; b=b0NUatS3trCz9EFknkRYJlQM5s8TjpE+3XKsFLMwt3W4ik6lxzk7sGg25HDOubDp3w5HAK28ZFw6h16NrkY/O8DI2ygoNiubnp6Bkgb/zz3uoUfUydrU8SdAURrxG/BetYXncZzGK+B2cG4CSA/cLKL2XxANrtCJFvOEea7LRr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879935; c=relaxed/simple;
	bh=knTjt9gLy6ZfJ+SjXJtCs+KzwAjteYRPQ4fcs4KJweM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYLlyZBGTpCikTU1iUXCjQgcwmVqUJuDJoEmkqz6BCWkCM8FRz956ZhvKEFVrcIf64jGnDuEwdm7xEq+bayiBf9pqplNIyMj8uS5zmmc1dLDX0ts3I+2Ob6jzrye6HN++/HqWX5HJUjIUJlknLCfOXXD67pS2ImGvUSW5TPdTdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dypIj4C/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dypIj4C/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF88C4CEC5;
	Wed,  2 Oct 2024 14:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879934;
	bh=knTjt9gLy6ZfJ+SjXJtCs+KzwAjteYRPQ4fcs4KJweM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dypIj4C/wD2OySzKm7H2/L0tn5aP8Bbzi7YrzfaoOdcYo1/coTfuSwVQ/LFQnVdEo
	 t7YEFCv5B22F+A5xoaPwgKDZE68cPGQz583Eofmiws3SjJTS8vY/PpA4Z7jmLeYu2G
	 x0pEEuNAA7RzDwQNCzSseG5nrM7AauQeEj1QHhVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Pieterjan Camerlynck <pieterjanca@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 288/538] leds: leds-pca995x: Add support for NXP PCA9956B
Date: Wed,  2 Oct 2024 14:58:47 +0200
Message-ID: <20241002125803.624242401@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pieterjan Camerlynck <pieterjanca@gmail.com>

[ Upstream commit 68d6520d2e76998cdea58f6dd8782de5ab5b28af ]

Add support for PCA9956B chip, which belongs to the same family.

This chip features 24 instead of 16 outputs, so add a chipdef struct to
deal with the different register layouts.

Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Pieterjan Camerlynck <pieterjanca@gmail.com>
Link: https://lore.kernel.org/r/20240711-pca995x-v4-2-702a67148065@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 82c5ada1f9d0 ("leds: pca995x: Fix device child node usage in pca995x_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-pca995x.c | 59 ++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 20 deletions(-)

diff --git a/drivers/leds/leds-pca995x.c b/drivers/leds/leds-pca995x.c
index 78215dff14997..686b77772ccec 100644
--- a/drivers/leds/leds-pca995x.c
+++ b/drivers/leds/leds-pca995x.c
@@ -19,10 +19,6 @@
 #define PCA995X_MODE1			0x00
 #define PCA995X_MODE2			0x01
 #define PCA995X_LEDOUT0			0x02
-#define PCA9955B_PWM0			0x08
-#define PCA9952_PWM0			0x0A
-#define PCA9952_IREFALL			0x43
-#define PCA9955B_IREFALL		0x45
 
 /* Auto-increment disabled. Normal mode */
 #define PCA995X_MODE1_CFG		0x00
@@ -34,17 +30,38 @@
 #define PCA995X_LDRX_MASK		0x3
 #define PCA995X_LDRX_BITS		2
 
-#define PCA995X_MAX_OUTPUTS		16
+#define PCA995X_MAX_OUTPUTS		24
 #define PCA995X_OUTPUTS_PER_REG		4
 
 #define PCA995X_IREFALL_FULL_CFG	0xFF
 #define PCA995X_IREFALL_HALF_CFG	(PCA995X_IREFALL_FULL_CFG / 2)
 
-#define PCA995X_TYPE_NON_B		0
-#define PCA995X_TYPE_B			1
-
 #define ldev_to_led(c)	container_of(c, struct pca995x_led, ldev)
 
+struct pca995x_chipdef {
+	unsigned int num_leds;
+	u8 pwm_base;
+	u8 irefall;
+};
+
+static const struct pca995x_chipdef pca9952_chipdef = {
+	.num_leds	= 16,
+	.pwm_base	= 0x0a,
+	.irefall	= 0x43,
+};
+
+static const struct pca995x_chipdef pca9955b_chipdef = {
+	.num_leds	= 16,
+	.pwm_base	= 0x08,
+	.irefall	= 0x45,
+};
+
+static const struct pca995x_chipdef pca9956b_chipdef = {
+	.num_leds	= 24,
+	.pwm_base	= 0x0a,
+	.irefall	= 0x40,
+};
+
 struct pca995x_led {
 	unsigned int led_no;
 	struct led_classdev ldev;
@@ -54,7 +71,7 @@ struct pca995x_led {
 struct pca995x_chip {
 	struct regmap *regmap;
 	struct pca995x_led leds[PCA995X_MAX_OUTPUTS];
-	int btype;
+	const struct pca995x_chipdef *chipdef;
 };
 
 static int pca995x_brightness_set(struct led_classdev *led_cdev,
@@ -62,10 +79,11 @@ static int pca995x_brightness_set(struct led_classdev *led_cdev,
 {
 	struct pca995x_led *led = ldev_to_led(led_cdev);
 	struct pca995x_chip *chip = led->chip;
+	const struct pca995x_chipdef *chipdef = chip->chipdef;
 	u8 ledout_addr, pwmout_addr;
 	int shift, ret;
 
-	pwmout_addr = (chip->btype ? PCA9955B_PWM0 : PCA9952_PWM0) + led->led_no;
+	pwmout_addr = chipdef->pwm_base + led->led_no;
 	ledout_addr = PCA995X_LEDOUT0 + (led->led_no / PCA995X_OUTPUTS_PER_REG);
 	shift = PCA995X_LDRX_BITS * (led->led_no % PCA995X_OUTPUTS_PER_REG);
 
@@ -104,11 +122,12 @@ static int pca995x_probe(struct i2c_client *client)
 	struct fwnode_handle *led_fwnodes[PCA995X_MAX_OUTPUTS] = { 0 };
 	struct fwnode_handle *np, *child;
 	struct device *dev = &client->dev;
+	const struct pca995x_chipdef *chipdef;
 	struct pca995x_chip *chip;
 	struct pca995x_led *led;
-	int i, btype, reg, ret;
+	int i, reg, ret;
 
-	btype = (unsigned long)device_get_match_data(&client->dev);
+	chipdef = device_get_match_data(&client->dev);
 
 	np = dev_fwnode(dev);
 	if (!np)
@@ -118,7 +137,7 @@ static int pca995x_probe(struct i2c_client *client)
 	if (!chip)
 		return -ENOMEM;
 
-	chip->btype = btype;
+	chip->chipdef = chipdef;
 	chip->regmap = devm_regmap_init_i2c(client, &pca995x_regmap);
 	if (IS_ERR(chip->regmap))
 		return PTR_ERR(chip->regmap);
@@ -170,21 +189,21 @@ static int pca995x_probe(struct i2c_client *client)
 		return ret;
 
 	/* IREF Output current value for all LEDn outputs */
-	return regmap_write(chip->regmap,
-			    btype ? PCA9955B_IREFALL : PCA9952_IREFALL,
-			    PCA995X_IREFALL_HALF_CFG);
+	return regmap_write(chip->regmap, chipdef->irefall, PCA995X_IREFALL_HALF_CFG);
 }
 
 static const struct i2c_device_id pca995x_id[] = {
-	{ "pca9952", .driver_data = (kernel_ulong_t)PCA995X_TYPE_NON_B },
-	{ "pca9955b", .driver_data = (kernel_ulong_t)PCA995X_TYPE_B },
+	{ "pca9952", .driver_data = (kernel_ulong_t)&pca9952_chipdef },
+	{ "pca9955b", .driver_data = (kernel_ulong_t)&pca9955b_chipdef },
+	{ "pca9956b", .driver_data = (kernel_ulong_t)&pca9956b_chipdef },
 	{}
 };
 MODULE_DEVICE_TABLE(i2c, pca995x_id);
 
 static const struct of_device_id pca995x_of_match[] = {
-	{ .compatible = "nxp,pca9952",  .data = (void *)PCA995X_TYPE_NON_B },
-	{ .compatible = "nxp,pca9955b", .data = (void *)PCA995X_TYPE_B },
+	{ .compatible = "nxp,pca9952", .data = &pca9952_chipdef },
+	{ .compatible = "nxp,pca9955b", . data = &pca9955b_chipdef },
+	{ .compatible = "nxp,pca9956b", .data = &pca9956b_chipdef },
 	{},
 };
 MODULE_DEVICE_TABLE(of, pca995x_of_match);
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E3E221D92;
	Mon,  2 Jun 2025 14:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873008; cv=none; b=UQrPxPZ/wSf9pLK4PAZfj7ZAwN2Ki15V87BPcvOWqPPjOLYouqRvB4BiT8jM+Q3jKxLRVKIun2LSBS6Di5nflJbtxqiGVNQNDiR1z4Hc3l8Z5dC4mteDTsLIDOx2jSHTSKsDGZBpOTn1GrLlYi3d1jzKM5XVfjHcOZ4gdOTfCvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873008; c=relaxed/simple;
	bh=EyuFIeeV9QcfOFXLZbSdguvHl/yql8TdgdXreM2NIo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXuR2tn4Bc/Ys3tpwXrSTnTXNN5QhZW//Ay3D9exwXRyeETTuv+mX9K//3girRdrEDy8b4guDg4m4NPf9r8RAdesFWs2gnZq+TvKGP9silevxX9XN4TBi890+u5XkCJwqwKpakzFeU8jSvC41lOyZXXbVgijJxPWmQsUFbUEgqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yu60Atm3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yu60Atm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4ADC4CEEB;
	Mon,  2 Jun 2025 14:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873008;
	bh=EyuFIeeV9QcfOFXLZbSdguvHl/yql8TdgdXreM2NIo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yu60Atm3JihWsUxhNVRPr98w5NaFP6ZuCfX/nfv/jyjJqJWM8YGKx4QR4ivaXBE5Y
	 Piq0GPwMkRkQoxecEK6/rRNYpPn7WzhcTYBor5igdpPo4VEcL6ETPuS0A+Z+l3nnkX
	 uqPgDBv7icJjUhNEU8mTIRr6CWF13Eh6sRq2WwgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/444] gpio: pca953x: Simplify code with cleanup helpers
Date: Mon,  2 Jun 2025 15:41:06 +0200
Message-ID: <20250602134341.010198933@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 8e471b784a720f6f34f9fb449ba0744359dcaccb ]

Use macros defined in linux/cleanup.h to automate resource lifetime
control in gpio-pca953x.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 3e38f946062b ("gpio: pca953x: fix IRQ storm on system wake up")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 77 ++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 48 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index fddf0cf031007..a39c8ebd410e4 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -10,6 +10,7 @@
 
 #include <linux/acpi.h>
 #include <linux/bitmap.h>
+#include <linux/cleanup.h>
 #include <linux/gpio/consumer.h>
 #include <linux/gpio/driver.h>
 #include <linux/i2c.h>
@@ -519,12 +520,10 @@ static int pca953x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
 	struct pca953x_chip *chip = gpiochip_get_data(gc);
 	u8 dirreg = chip->recalc_addr(chip, chip->regs->direction, off);
 	u8 bit = BIT(off % BANK_SZ);
-	int ret;
 
-	mutex_lock(&chip->i2c_lock);
-	ret = regmap_write_bits(chip->regmap, dirreg, bit, bit);
-	mutex_unlock(&chip->i2c_lock);
-	return ret;
+	guard(mutex)(&chip->i2c_lock);
+
+	return regmap_write_bits(chip->regmap, dirreg, bit, bit);
 }
 
 static int pca953x_gpio_direction_output(struct gpio_chip *gc,
@@ -536,17 +535,15 @@ static int pca953x_gpio_direction_output(struct gpio_chip *gc,
 	u8 bit = BIT(off % BANK_SZ);
 	int ret;
 
-	mutex_lock(&chip->i2c_lock);
+	guard(mutex)(&chip->i2c_lock);
+
 	/* set output level */
 	ret = regmap_write_bits(chip->regmap, outreg, bit, val ? bit : 0);
 	if (ret)
-		goto exit;
+		return ret;
 
 	/* then direction */
-	ret = regmap_write_bits(chip->regmap, dirreg, bit, 0);
-exit:
-	mutex_unlock(&chip->i2c_lock);
-	return ret;
+	return regmap_write_bits(chip->regmap, dirreg, bit, 0);
 }
 
 static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
@@ -557,9 +554,8 @@ static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
 	u32 reg_val;
 	int ret;
 
-	mutex_lock(&chip->i2c_lock);
-	ret = regmap_read(chip->regmap, inreg, &reg_val);
-	mutex_unlock(&chip->i2c_lock);
+	scoped_guard(mutex, &chip->i2c_lock)
+		ret = regmap_read(chip->regmap, inreg, &reg_val);
 	if (ret < 0)
 		return ret;
 
@@ -572,9 +568,9 @@ static void pca953x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
 	u8 outreg = chip->recalc_addr(chip, chip->regs->output, off);
 	u8 bit = BIT(off % BANK_SZ);
 
-	mutex_lock(&chip->i2c_lock);
+	guard(mutex)(&chip->i2c_lock);
+
 	regmap_write_bits(chip->regmap, outreg, bit, val ? bit : 0);
-	mutex_unlock(&chip->i2c_lock);
 }
 
 static int pca953x_gpio_get_direction(struct gpio_chip *gc, unsigned off)
@@ -585,9 +581,8 @@ static int pca953x_gpio_get_direction(struct gpio_chip *gc, unsigned off)
 	u32 reg_val;
 	int ret;
 
-	mutex_lock(&chip->i2c_lock);
-	ret = regmap_read(chip->regmap, dirreg, &reg_val);
-	mutex_unlock(&chip->i2c_lock);
+	scoped_guard(mutex, &chip->i2c_lock)
+		ret = regmap_read(chip->regmap, dirreg, &reg_val);
 	if (ret < 0)
 		return ret;
 
@@ -604,9 +599,8 @@ static int pca953x_gpio_get_multiple(struct gpio_chip *gc,
 	DECLARE_BITMAP(reg_val, MAX_LINE);
 	int ret;
 
-	mutex_lock(&chip->i2c_lock);
-	ret = pca953x_read_regs(chip, chip->regs->input, reg_val);
-	mutex_unlock(&chip->i2c_lock);
+	scoped_guard(mutex, &chip->i2c_lock)
+		ret = pca953x_read_regs(chip, chip->regs->input, reg_val);
 	if (ret)
 		return ret;
 
@@ -621,16 +615,15 @@ static void pca953x_gpio_set_multiple(struct gpio_chip *gc,
 	DECLARE_BITMAP(reg_val, MAX_LINE);
 	int ret;
 
-	mutex_lock(&chip->i2c_lock);
+	guard(mutex)(&chip->i2c_lock);
+
 	ret = pca953x_read_regs(chip, chip->regs->output, reg_val);
 	if (ret)
-		goto exit;
+		return;
 
 	bitmap_replace(reg_val, reg_val, bits, mask, gc->ngpio);
 
 	pca953x_write_regs(chip, chip->regs->output, reg_val);
-exit:
-	mutex_unlock(&chip->i2c_lock);
 }
 
 static int pca953x_gpio_set_pull_up_down(struct pca953x_chip *chip,
@@ -638,7 +631,6 @@ static int pca953x_gpio_set_pull_up_down(struct pca953x_chip *chip,
 					 unsigned long config)
 {
 	enum pin_config_param param = pinconf_to_config_param(config);
-
 	u8 pull_en_reg = chip->recalc_addr(chip, PCAL953X_PULL_EN, offset);
 	u8 pull_sel_reg = chip->recalc_addr(chip, PCAL953X_PULL_SEL, offset);
 	u8 bit = BIT(offset % BANK_SZ);
@@ -651,7 +643,7 @@ static int pca953x_gpio_set_pull_up_down(struct pca953x_chip *chip,
 	if (!(chip->driver_data & PCA_PCAL))
 		return -ENOTSUPP;
 
-	mutex_lock(&chip->i2c_lock);
+	guard(mutex)(&chip->i2c_lock);
 
 	/* Configure pull-up/pull-down */
 	if (param == PIN_CONFIG_BIAS_PULL_UP)
@@ -661,17 +653,13 @@ static int pca953x_gpio_set_pull_up_down(struct pca953x_chip *chip,
 	else
 		ret = 0;
 	if (ret)
-		goto exit;
+		return ret;
 
 	/* Disable/Enable pull-up/pull-down */
 	if (param == PIN_CONFIG_BIAS_DISABLE)
-		ret = regmap_write_bits(chip->regmap, pull_en_reg, bit, 0);
+		return regmap_write_bits(chip->regmap, pull_en_reg, bit, 0);
 	else
-		ret = regmap_write_bits(chip->regmap, pull_en_reg, bit, bit);
-
-exit:
-	mutex_unlock(&chip->i2c_lock);
-	return ret;
+		return regmap_write_bits(chip->regmap, pull_en_reg, bit, bit);
 }
 
 static int pca953x_gpio_set_config(struct gpio_chip *gc, unsigned int offset,
@@ -883,10 +871,8 @@ static irqreturn_t pca953x_irq_handler(int irq, void *devid)
 
 	bitmap_zero(pending, MAX_LINE);
 
-	mutex_lock(&chip->i2c_lock);
-	ret = pca953x_irq_pending(chip, pending);
-	mutex_unlock(&chip->i2c_lock);
-
+	scoped_guard(mutex, &chip->i2c_lock)
+		ret = pca953x_irq_pending(chip, pending);
 	if (ret) {
 		ret = 0;
 
@@ -1221,26 +1207,21 @@ static int pca953x_restore_context(struct pca953x_chip *chip)
 {
 	int ret;
 
-	mutex_lock(&chip->i2c_lock);
+	guard(mutex)(&chip->i2c_lock);
 
 	regcache_cache_only(chip->regmap, false);
 	regcache_mark_dirty(chip->regmap);
 	ret = pca953x_regcache_sync(chip);
-	if (ret) {
-		mutex_unlock(&chip->i2c_lock);
+	if (ret)
 		return ret;
-	}
 
-	ret = regcache_sync(chip->regmap);
-	mutex_unlock(&chip->i2c_lock);
-	return ret;
+	return regcache_sync(chip->regmap);
 }
 
 static void pca953x_save_context(struct pca953x_chip *chip)
 {
-	mutex_lock(&chip->i2c_lock);
+	guard(mutex)(&chip->i2c_lock);
 	regcache_cache_only(chip->regmap, true);
-	mutex_unlock(&chip->i2c_lock);
 }
 
 static int pca953x_suspend(struct device *dev)
-- 
2.39.5




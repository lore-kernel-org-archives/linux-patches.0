Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC7B253944;
	Tue, 11 Nov 2025 01:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822922; cv=none; b=j7aM+f+HuAvYNQWc4fM/NE34ENUgqVkSvH4Zl+GNYVCk03iNbPQMXXvYcO9Jkx70KSvj4e16AvHw5jNE8054jb+ZN9cX3KIZz0I6ygicUB9jjpUdZlpqkIaH6Jf89eCOTCAmXlZUD+o9deUXCZy80+87YPs5dAOS0eoo5lgc5e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822922; c=relaxed/simple;
	bh=JsFQPXA9Txw30GGYybIM7TaQkCQD0xtGyNHrnI+EGX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GNdEnkkHiEF5EmSAMFeiUFTXLx1h41TQFoG90Hlel3R8utL0SvI06CUpA6SxlNg5r9NhoXhoFzMcpapfxpcOhQmxRVdo63mzTTNpZEaO/aCMSCaQkcEnFCGDoaySsSlaH8ptDcy8SdpaP8WsY7XuAQPx54I6lXPDFXLtWafavJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=asXqTwXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="asXqTwXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECEEC19422;
	Tue, 11 Nov 2025 01:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822922;
	bh=JsFQPXA9Txw30GGYybIM7TaQkCQD0xtGyNHrnI+EGX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asXqTwXwpXhlvOTH9iEYOPzdSMuQhZcmAwDn2JtiNVTVuBTfd3pZ7ixGAmPCZ7Ebu
	 263BYGuXnzilKgRyQtezCEWhIxpM1MYeYecGE+ZfOx/VAoMIdQ40jBxwxTUQZ52j4r
	 OZ5HUrkiomxVj4OGjSea54TDm3qi2ZwHX5zuSF3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/565] pwm: pca9685: Use bulk write to atomicially update registers
Date: Tue, 11 Nov 2025 09:39:50 +0900
Message-ID: <20251111004529.962811081@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit de5855613263b426ee697dd30224322f2e634dec ]

The output of a PWM channel is configured by four register values. Write
them in a single i2c transaction to ensure glitch free updates.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://lore.kernel.org/r/bfa8c0267c9ec059d0d77f146998d564654c75ca.1753784092.git.u.kleine-koenig@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-pca9685.c | 46 ++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/pwm/pwm-pca9685.c b/drivers/pwm/pwm-pca9685.c
index 1298b29183e55..e1b60756bb485 100644
--- a/drivers/pwm/pwm-pca9685.c
+++ b/drivers/pwm/pwm-pca9685.c
@@ -62,6 +62,8 @@
 #define MODE1_SUB2		BIT(2)
 #define MODE1_SUB1		BIT(3)
 #define MODE1_SLEEP		BIT(4)
+#define MODE1_AI		BIT(5)
+
 #define MODE2_INVRT		BIT(4)
 #define MODE2_OUTDRV		BIT(2)
 
@@ -132,6 +134,19 @@ static int pca9685_write_reg(struct pwm_chip *chip, unsigned int reg, unsigned i
 	return err;
 }
 
+static int pca9685_write_4reg(struct pwm_chip *chip, unsigned int reg, u8 val[4])
+{
+	struct pca9685 *pca = to_pca(chip);
+	struct device *dev = pwmchip_parent(chip);
+	int err;
+
+	err = regmap_bulk_write(pca->regmap, reg, val, 4);
+	if (err)
+		dev_err(dev, "regmap_write to register 0x%x failed: %pe\n", reg, ERR_PTR(err));
+
+	return err;
+}
+
 /* Helper function to set the duty cycle ratio to duty/4096 (e.g. duty=2048 -> 50%) */
 static void pca9685_pwm_set_duty(struct pwm_chip *chip, int channel, unsigned int duty)
 {
@@ -144,12 +159,10 @@ static void pca9685_pwm_set_duty(struct pwm_chip *chip, int channel, unsigned in
 		return;
 	} else if (duty >= PCA9685_COUNTER_RANGE) {
 		/* Set the full ON bit and clear the full OFF bit */
-		pca9685_write_reg(chip, REG_ON_H(channel), LED_FULL);
-		pca9685_write_reg(chip, REG_OFF_H(channel), 0);
+		pca9685_write_4reg(chip, REG_ON_L(channel), (u8[4]){ 0, LED_FULL, 0, 0 });
 		return;
 	}
 
-
 	if (pwm->state.usage_power && channel < PCA9685_MAXCHAN) {
 		/*
 		 * If usage_power is set, the pca9685 driver will phase shift
@@ -164,12 +177,9 @@ static void pca9685_pwm_set_duty(struct pwm_chip *chip, int channel, unsigned in
 
 	off = (on + duty) % PCA9685_COUNTER_RANGE;
 
-	/* Set ON time (clears full ON bit) */
-	pca9685_write_reg(chip, REG_ON_L(channel), on & 0xff);
-	pca9685_write_reg(chip, REG_ON_H(channel), (on >> 8) & 0xf);
-	/* Set OFF time (clears full OFF bit) */
-	pca9685_write_reg(chip, REG_OFF_L(channel), off & 0xff);
-	pca9685_write_reg(chip, REG_OFF_H(channel), (off >> 8) & 0xf);
+	/* implicitly clear full ON and full OFF bit */
+	pca9685_write_4reg(chip, REG_ON_L(channel),
+			   (u8[4]){ on & 0xff, (on >> 8) & 0xf, off & 0xff, (off >> 8) & 0xf });
 }
 
 static unsigned int pca9685_pwm_get_duty(struct pwm_chip *chip, int channel)
@@ -543,9 +553,8 @@ static int pca9685_pwm_probe(struct i2c_client *client)
 
 	mutex_init(&pca->lock);
 
-	ret = pca9685_read_reg(chip, PCA9685_MODE2, &reg);
-	if (ret)
-		return ret;
+	/* clear MODE2_OCH */
+	reg = 0;
 
 	if (device_property_read_bool(&client->dev, "invert"))
 		reg |= MODE2_INVRT;
@@ -561,16 +570,19 @@ static int pca9685_pwm_probe(struct i2c_client *client)
 	if (ret)
 		return ret;
 
-	/* Disable all LED ALLCALL and SUBx addresses to avoid bus collisions */
+	/*
+	 * Disable all LED ALLCALL and SUBx addresses to avoid bus collisions,
+	 * enable Auto-Increment.
+	 */
 	pca9685_read_reg(chip, PCA9685_MODE1, &reg);
 	reg &= ~(MODE1_ALLCALL | MODE1_SUB1 | MODE1_SUB2 | MODE1_SUB3);
+	reg |= MODE1_AI;
 	pca9685_write_reg(chip, PCA9685_MODE1, reg);
 
 	/* Reset OFF/ON registers to POR default */
-	pca9685_write_reg(chip, PCA9685_ALL_LED_OFF_L, 0);
-	pca9685_write_reg(chip, PCA9685_ALL_LED_OFF_H, LED_FULL);
-	pca9685_write_reg(chip, PCA9685_ALL_LED_ON_L, 0);
-	pca9685_write_reg(chip, PCA9685_ALL_LED_ON_H, LED_FULL);
+	ret = pca9685_write_4reg(chip, PCA9685_ALL_LED_ON_L, (u8[]){ 0, LED_FULL, 0, LED_FULL });
+	if (ret < 0)
+		return dev_err_probe(&client->dev, ret, "Failed to reset ON/OFF registers\n");
 
 	chip->ops = &pca9685_pwm_ops;
 
-- 
2.51.0




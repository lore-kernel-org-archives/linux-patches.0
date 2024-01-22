Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7900364CDA;
	Tue, 23 Jan 2024 00:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971355; cv=none; b=Qz7Lve+/XUsYJT0wJ86yw69lQeWHgZ0nbUoDpHQ21B6bC1Xe4hPWbbZoNXHz8j0E8qblFv4Z91iW61wBFrP/OD7cwbArQqVdSn/CGp77P1g/Eci9DshDoldPEkWjVPkjNp1w758xJZG6wJ+NUS9Rd1j0WB96Ayo7bZ82aj7MR0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971355; c=relaxed/simple;
	bh=guq6HyedpCgIMgbeWJjX+56YacbzZKuIb8d86CRC+FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o+gy5wrjALiqGmfJ1aoibiEF/n7H/rWi1CeESZ+KJ2ykcXZnhOmX/Q4HSm4ob9IHxiCBWLZqxhUd36syXLBqR67oI2UNtrVzKrzbjOzp4ZTvKBRY/IBNKd0dSBK1UiuVExijwoC4SiCgR/Vyxg9vjAWagPpCHivWE66mQZF6lNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3MSp6nM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3MSp6nM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF71C433C7;
	Tue, 23 Jan 2024 00:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971355;
	bh=guq6HyedpCgIMgbeWJjX+56YacbzZKuIb8d86CRC+FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3MSp6nMJo20ItR54lsxQm1rItBgqtFDp8bG2QlsQc0jgvQ2+QH8IdZKU7ZwMSfSe
	 BrW9be2nK10bpxuTFJW+ZxC54tC4CA26WWEm4/mQAp4nd1mQn0B+ouVLnHyRSf15kS
	 /S5jVkTYkp52TayYO3jkFeoGxDjzl+i+kZQJ0Sl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 228/417] pwm: stm32: Use regmap_clear_bits and regmap_set_bits where applicable
Date: Mon, 22 Jan 2024 15:56:36 -0800
Message-ID: <20240122235759.802957845@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 632ae5d7eb348b3ef88552ec0999260b6f9d6ab1 ]

Found using coccinelle and the following semantic patch:

@@
expression map, reg, bits;
@@

- regmap_update_bits(map, reg, bits, bits)
+ regmap_set_bits(map, reg, bits)

@@
expression map, reg, bits;
@@

- regmap_update_bits(map, reg, bits, 0)
+ regmap_clear_bits(map, reg, bits)

Tested-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20221115111347.3705732-6-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Stable-dep-of: 19f1016ea960 ("pwm: stm32: Fix enable count for clk in .probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-stm32.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/pwm/pwm-stm32.c b/drivers/pwm/pwm-stm32.c
index 794ca5b02968..21e4a34dfff3 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -115,14 +115,14 @@ static int stm32_pwm_raw_capture(struct stm32_pwm *priv, struct pwm_device *pwm,
 	int ret;
 
 	/* Ensure registers have been updated, enable counter and capture */
-	regmap_update_bits(priv->regmap, TIM_EGR, TIM_EGR_UG, TIM_EGR_UG);
-	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_CEN, TIM_CR1_CEN);
+	regmap_set_bits(priv->regmap, TIM_EGR, TIM_EGR_UG);
+	regmap_set_bits(priv->regmap, TIM_CR1, TIM_CR1_CEN);
 
 	/* Use cc1 or cc3 DMA resp for PWM input channels 1 & 2 or 3 & 4 */
 	dma_id = pwm->hwpwm < 2 ? STM32_TIMERS_DMA_CH1 : STM32_TIMERS_DMA_CH3;
 	ccen = pwm->hwpwm < 2 ? TIM_CCER_CC12E : TIM_CCER_CC34E;
 	ccr = pwm->hwpwm < 2 ? TIM_CCR1 : TIM_CCR3;
-	regmap_update_bits(priv->regmap, TIM_CCER, ccen, ccen);
+	regmap_set_bits(priv->regmap, TIM_CCER, ccen);
 
 	/*
 	 * Timer DMA burst mode. Request 2 registers, 2 bursts, to get both
@@ -160,8 +160,8 @@ static int stm32_pwm_raw_capture(struct stm32_pwm *priv, struct pwm_device *pwm,
 	}
 
 stop:
-	regmap_update_bits(priv->regmap, TIM_CCER, ccen, 0);
-	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_CEN, 0);
+	regmap_clear_bits(priv->regmap, TIM_CCER, ccen);
+	regmap_clear_bits(priv->regmap, TIM_CR1, TIM_CR1_CEN);
 
 	return ret;
 }
@@ -359,7 +359,7 @@ static int stm32_pwm_config(struct stm32_pwm *priv, int ch,
 
 	regmap_write(priv->regmap, TIM_PSC, prescaler);
 	regmap_write(priv->regmap, TIM_ARR, prd - 1);
-	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE, TIM_CR1_ARPE);
+	regmap_set_bits(priv->regmap, TIM_CR1, TIM_CR1_ARPE);
 
 	/* Calculate the duty cycles */
 	dty = prd * duty_ns;
@@ -377,7 +377,7 @@ static int stm32_pwm_config(struct stm32_pwm *priv, int ch,
 	else
 		regmap_update_bits(priv->regmap, TIM_CCMR2, mask, ccmr);
 
-	regmap_update_bits(priv->regmap, TIM_BDTR, TIM_BDTR_MOE, TIM_BDTR_MOE);
+	regmap_set_bits(priv->regmap, TIM_BDTR, TIM_BDTR_MOE);
 
 	return 0;
 }
@@ -411,13 +411,13 @@ static int stm32_pwm_enable(struct stm32_pwm *priv, int ch)
 	if (priv->have_complementary_output)
 		mask |= TIM_CCER_CC1NE << (ch * 4);
 
-	regmap_update_bits(priv->regmap, TIM_CCER, mask, mask);
+	regmap_set_bits(priv->regmap, TIM_CCER, mask);
 
 	/* Make sure that registers are updated */
-	regmap_update_bits(priv->regmap, TIM_EGR, TIM_EGR_UG, TIM_EGR_UG);
+	regmap_set_bits(priv->regmap, TIM_EGR, TIM_EGR_UG);
 
 	/* Enable controller */
-	regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_CEN, TIM_CR1_CEN);
+	regmap_set_bits(priv->regmap, TIM_CR1, TIM_CR1_CEN);
 
 	return 0;
 }
@@ -431,11 +431,11 @@ static void stm32_pwm_disable(struct stm32_pwm *priv, int ch)
 	if (priv->have_complementary_output)
 		mask |= TIM_CCER_CC1NE << (ch * 4);
 
-	regmap_update_bits(priv->regmap, TIM_CCER, mask, 0);
+	regmap_clear_bits(priv->regmap, TIM_CCER, mask);
 
 	/* When all channels are disabled, we can disable the controller */
 	if (!active_channels(priv))
-		regmap_update_bits(priv->regmap, TIM_CR1, TIM_CR1_CEN, 0);
+		regmap_clear_bits(priv->regmap, TIM_CR1, TIM_CR1_CEN);
 
 	clk_disable(priv->clk);
 }
@@ -568,10 +568,9 @@ static void stm32_pwm_detect_complementary(struct stm32_pwm *priv)
 	 * If complementary bit doesn't exist writing 1 will have no
 	 * effect so we can detect it.
 	 */
-	regmap_update_bits(priv->regmap,
-			   TIM_CCER, TIM_CCER_CC1NE, TIM_CCER_CC1NE);
+	regmap_set_bits(priv->regmap, TIM_CCER, TIM_CCER_CC1NE);
 	regmap_read(priv->regmap, TIM_CCER, &ccer);
-	regmap_update_bits(priv->regmap, TIM_CCER, TIM_CCER_CC1NE, 0);
+	regmap_clear_bits(priv->regmap, TIM_CCER, TIM_CCER_CC1NE);
 
 	priv->have_complementary_output = (ccer != 0);
 }
@@ -585,10 +584,9 @@ static int stm32_pwm_detect_channels(struct stm32_pwm *priv)
 	 * If channels enable bits don't exist writing 1 will have no
 	 * effect so we can detect and count them.
 	 */
-	regmap_update_bits(priv->regmap,
-			   TIM_CCER, TIM_CCER_CCXE, TIM_CCER_CCXE);
+	regmap_set_bits(priv->regmap, TIM_CCER, TIM_CCER_CCXE);
 	regmap_read(priv->regmap, TIM_CCER, &ccer);
-	regmap_update_bits(priv->regmap, TIM_CCER, TIM_CCER_CCXE, 0);
+	regmap_clear_bits(priv->regmap, TIM_CCER, TIM_CCER_CCXE);
 
 	if (ccer & TIM_CCER_CC1E)
 		npwm++;
-- 
2.43.0




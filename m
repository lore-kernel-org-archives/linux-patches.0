Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A6565193;
	Tue, 23 Jan 2024 01:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971637; cv=none; b=bbw2fVyIv7L2vS1qQo3mO+drvWQD3IbYBDJklPGOcaI242kLyyK8yrh+TfWLow6Fyl8qm5teVK/XywrCaNpUEWIXKwyQmm9kjT8jHUEqPVsTrlFCpJiya3SBAVaZvUxoilJJrpmlsmP/J6Y/6WACQb2b2MNtqKn05Kuh24UvjL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971637; c=relaxed/simple;
	bh=tYIBEByn7LomKA+iDkLl1urdIC8tXmegm1DbGMjDo7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jV/jfwTkJnlfGLpbuMi7TkdJFanenhjtf3PqSbKfjBBqUfypTGgE2PWyd2Myt0I5tcVPFfNVgzwvIAOO0rpe12vBT8gFsq/oBFggTQtJ1UDYAQnjmZuIzaiVgqgVLuy5LN2W+ekPLNb4DmNnB8RmDFHks5C/rg8HhJNAJWAAEzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pY/Oqb9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pY/Oqb9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB29C433F1;
	Tue, 23 Jan 2024 01:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971636;
	bh=tYIBEByn7LomKA+iDkLl1urdIC8tXmegm1DbGMjDo7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pY/Oqb9OkUc+6wfGc1IPkCHv0/hWcBShPMluNdNirZIXWc2VUfws5e6kMMPG4zsqS
	 /YbRitj87oik34ue1UhYCk93Uq8DQr9TFHRaDCoAuN7xaDcXm2REX8dV1k/lg57ajY
	 v5WJxWNDXQoE8Bl4y3nOZPBc1wNrHBml94i8FLPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/286] pwm: stm32: Fix enable count for clk in .probe()
Date: Mon, 22 Jan 2024 15:58:17 -0800
Message-ID: <20240122235739.470979003@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Zabel <p.zabel@pengutronix.de>

[ Upstream commit 19f1016ea9600ed89bc24247c36ff5934ad94fbb ]

Make the driver take over hardware state without disabling in .probe()
and enable the clock for each enabled channel.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
[ukleinek: split off from a patch that also implemented .get_state()]
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Fixes: 7edf7369205b ("pwm: Add driver for STM32 plaftorm")
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-stm32.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/pwm/pwm-stm32.c b/drivers/pwm/pwm-stm32.c
index 31843cc4ca76..69b7bc604946 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -575,17 +575,21 @@ static void stm32_pwm_detect_complementary(struct stm32_pwm *priv)
 	priv->have_complementary_output = (ccer != 0);
 }
 
-static unsigned int stm32_pwm_detect_channels(struct stm32_pwm *priv)
+static unsigned int stm32_pwm_detect_channels(struct stm32_pwm *priv,
+					      unsigned int *num_enabled)
 {
-	u32 ccer;
+	u32 ccer, ccer_backup;
 
 	/*
 	 * If channels enable bits don't exist writing 1 will have no
 	 * effect so we can detect and count them.
 	 */
+	regmap_read(priv->regmap, TIM_CCER, &ccer_backup);
 	regmap_set_bits(priv->regmap, TIM_CCER, TIM_CCER_CCXE);
 	regmap_read(priv->regmap, TIM_CCER, &ccer);
-	regmap_clear_bits(priv->regmap, TIM_CCER, TIM_CCER_CCXE);
+	regmap_write(priv->regmap, TIM_CCER, ccer_backup);
+
+	*num_enabled = hweight32(ccer_backup & TIM_CCER_CCXE);
 
 	return hweight32(ccer & TIM_CCER_CCXE);
 }
@@ -596,6 +600,8 @@ static int stm32_pwm_probe(struct platform_device *pdev)
 	struct device_node *np = dev->of_node;
 	struct stm32_timers *ddata = dev_get_drvdata(pdev->dev.parent);
 	struct stm32_pwm *priv;
+	unsigned int num_enabled;
+	unsigned int i;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -621,7 +627,11 @@ static int stm32_pwm_probe(struct platform_device *pdev)
 	priv->chip.base = -1;
 	priv->chip.dev = dev;
 	priv->chip.ops = &stm32pwm_ops;
-	priv->chip.npwm = stm32_pwm_detect_channels(priv);
+	priv->chip.npwm = stm32_pwm_detect_channels(priv, &num_enabled);
+
+	/* Initialize clock refcount to number of enabled PWM channels. */
+	for (i = 0; i < num_enabled; i++)
+		clk_enable(priv->clk);
 
 	ret = pwmchip_add(&priv->chip);
 	if (ret < 0)
-- 
2.43.0




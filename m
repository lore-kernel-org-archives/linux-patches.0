Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C5D6A354;
	Tue, 23 Jan 2024 02:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975355; cv=none; b=F46vILv4lNVrezzADoCQ57CPNaD8Ops6PxPM+fPJetSOuK26+Opm1rqaj4D0/IWszTnnuzqT64JqZ8zcM8SnLGexqY1jwpxYdqw4GlIq0A382NBNcZVgdngDP2Ej6xYg2whI7C7dDAw3bvCJWh2Ck6Habcal1Cxq/5a9JhQ9jMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975355; c=relaxed/simple;
	bh=et0oL1IOcslLAEbQs0YlCWqn85zSzII0E/nusRw08jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ejDt8MEDseJ/EtB1WKHSeP3LdUgeq07HAyYaUArg6R7Bqn6Cp9IklgTKoIuijx+k4yvrQn2vnPIywYRBMtuJj4GgvVVozUPQ3vO/DcKHUGtemcxbLUD/buTftmNWDQ/pdOa3B6gF+WMgUnIRj01scsA1vVo+25R7FBmXdy7wOPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x90JDowZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x90JDowZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E7DC43394;
	Tue, 23 Jan 2024 02:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975354;
	bh=et0oL1IOcslLAEbQs0YlCWqn85zSzII0E/nusRw08jQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x90JDowZwmJ/Co13VWvArY6yovXEfEuHdt4mfHzqiAWSqKC6bvcV7o2v/STNByy5d
	 DTIKHROizfTqilHm7kfu33Wj7EPAwdhkx8Jp+x70NrNwS6dawaMXXtBmxeRBnEgWs2
	 btzKlZ2MdWfnFvKkSGypF3U+KKIvnFSyYFNzenEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 317/583] pwm: stm32: Fix enable count for clk in .probe()
Date: Mon, 22 Jan 2024 15:56:08 -0800
Message-ID: <20240122235821.740433530@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index 0c7781f17805..dd2ee5d9ca06 100644
--- a/drivers/pwm/pwm-stm32.c
+++ b/drivers/pwm/pwm-stm32.c
@@ -579,17 +579,21 @@ static void stm32_pwm_detect_complementary(struct stm32_pwm *priv)
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
@@ -600,6 +604,8 @@ static int stm32_pwm_probe(struct platform_device *pdev)
 	struct device_node *np = dev->of_node;
 	struct stm32_timers *ddata = dev_get_drvdata(pdev->dev.parent);
 	struct stm32_pwm *priv;
+	unsigned int num_enabled;
+	unsigned int i;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -622,7 +628,11 @@ static int stm32_pwm_probe(struct platform_device *pdev)
 
 	priv->chip.dev = dev;
 	priv->chip.ops = &stm32pwm_ops;
-	priv->chip.npwm = stm32_pwm_detect_channels(priv);
+	priv->chip.npwm = stm32_pwm_detect_channels(priv, &num_enabled);
+
+	/* Initialize clock refcount to number of enabled PWM channels. */
+	for (i = 0; i < num_enabled; i++)
+		clk_enable(priv->clk);
 
 	ret = devm_pwmchip_add(dev, &priv->chip);
 	if (ret < 0)
-- 
2.43.0




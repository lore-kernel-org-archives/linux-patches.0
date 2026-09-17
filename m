Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7F05172F0;
	Thu, 17 Sep 2026 16:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664290; cv=none; b=rhDSbX92RKunQ9X/UXmBF6W1eB/gKDhnPOVkfrm07WzUNvk+I6w36obMCSpC+G4fYqpHN7+VhGy/GH/8/fhxo+GGnfhYzGujc7DG2SbXrQEvOd+7/3Cooh2T1IaShgtKHwCVkLna1L6GkoZSlhIy7crj5HAQbgK9BVPuDXwJBG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664290; c=relaxed/simple;
	bh=V6C2D10cwV33LwS4v1BoW0k0J9+IdDJmuitKy5hhTu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DP92TmDV42SEUVLVZ6/J62xrT4D+m+0OLxcITKEI/GOdXYmZHU5OoLkuK1U5Xqi2oDcAEEuDXdUkmDyb2mbYzr9wJpdWNKa+Nbl9+J+R6JEba10HR2r3jMqCYVucXAq4i7i0JDfhwM6O/JAuQbeDox57vdNdr7rRBzUVNQSTSpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwiD5Lh4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwiD5Lh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD411F000FF;
	Thu, 17 Sep 2026 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664288;
	bh=gZlevP+J4up6lSEnNIiww26hQsBEXrRcgoqHY8YIZoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rwiD5Lh4bvSFUYBBmx3e/yB1M/PZh/CelylX0KTpWaqniU9Bj2YHKKv7d2B13VDYI
	 blsGWzE4l5urcl4OhCaEJ5SOIalvkMNEKVGlG8PcfuwmONpS47Y9mvwzSjoBS4BFFV
	 hwB3kvsUNbMB8HMYw/pC8YIcWHZ6K+ARVw8R1dZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0295/1250] ASoC: codecs: rk3328: Use managed GPIO and clock helpers
Date: Thu, 17 Sep 2026 16:01:30 +0100
Message-ID: <20260917151600.120302583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 0cf3489bba9ad13aae052232e223e19a620fe7a7 ]

rk3328_platform_probe() acquires the mute GPIO with gpiod_get_optional()
but never releases it. It also enables mclk and pclk manually while
relying on probe error labels for unwind, and the driver has no platform
remove callback to disable those clocks after a successful unbind.

This path has already needed fixes for missing clock unwinds on probe
errors. Use devm_gpiod_get_optional() and devm_clk_get_enabled() so the
GPIO and enabled clock lifetimes are tied to the device. This removes the
manual error labels and makes both probe failure and driver unbind follow
the normal devres cleanup path.

Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260525-asoc-rk3328-devm-resources-v1-1-2abde0006f89@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rk3328_codec.c | 54 ++++++++-------------------------
 1 file changed, 13 insertions(+), 41 deletions(-)

diff --git a/sound/soc/codecs/rk3328_codec.c b/sound/soc/codecs/rk3328_codec.c
index 9697aefc6e030..5871b5a819757 100644
--- a/sound/soc/codecs/rk3328_codec.c
+++ b/sound/soc/codecs/rk3328_codec.c
@@ -425,7 +425,6 @@ static int rk3328_platform_probe(struct platform_device *pdev)
 	struct rk3328_codec_priv *rk3328;
 	struct regmap *grf;
 	void __iomem *base;
-	int ret = 0;
 
 	rk3328 = devm_kzalloc(&pdev->dev, sizeof(*rk3328), GFP_KERNEL);
 	if (!rk3328)
@@ -441,14 +440,13 @@ static int rk3328_platform_probe(struct platform_device *pdev)
 	regmap_write(grf, RK3328_GRF_SOC_CON2,
 		     (BIT(14) << 16 | BIT(14)));
 
-	ret = of_property_read_u32(rk3328_np, "spk-depop-time-ms",
-				   &rk3328->spk_depop_time);
-	if (ret < 0) {
+	if (of_property_read_u32(rk3328_np, "spk-depop-time-ms",
+				 &rk3328->spk_depop_time)) {
 		dev_info(&pdev->dev, "spk_depop_time use default value.\n");
 		rk3328->spk_depop_time = 200;
 	}
 
-	rk3328->mute = gpiod_get_optional(&pdev->dev, "mute", GPIOD_OUT_HIGH);
+	rk3328->mute = devm_gpiod_get_optional(&pdev->dev, "mute", GPIOD_OUT_HIGH);
 	if (IS_ERR(rk3328->mute))
 		return PTR_ERR(rk3328->mute);
 	/*
@@ -461,57 +459,31 @@ static int rk3328_platform_probe(struct platform_device *pdev)
 		regmap_write(grf, RK3328_GRF_SOC_CON10, BIT(17) | BIT(1));
 	}
 
-	rk3328->mclk = devm_clk_get(&pdev->dev, "mclk");
+	rk3328->mclk = devm_clk_get_enabled(&pdev->dev, "mclk");
 	if (IS_ERR(rk3328->mclk))
 		return PTR_ERR(rk3328->mclk);
 
-	ret = clk_prepare_enable(rk3328->mclk);
-	if (ret)
-		return ret;
 	clk_set_rate(rk3328->mclk, INITIAL_FREQ);
 
-	rk3328->pclk = devm_clk_get(&pdev->dev, "pclk");
-	if (IS_ERR(rk3328->pclk)) {
-		dev_err(&pdev->dev, "can't get acodec pclk\n");
-		ret = PTR_ERR(rk3328->pclk);
-		goto err_unprepare_mclk;
-	}
-
-	ret = clk_prepare_enable(rk3328->pclk);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "failed to enable acodec pclk\n");
-		goto err_unprepare_mclk;
-	}
+	rk3328->pclk = devm_clk_get_enabled(&pdev->dev, "pclk");
+	if (IS_ERR(rk3328->pclk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(rk3328->pclk),
+				     "failed to get or enable acodec pclk\n");
 
 	base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(base)) {
-		ret = PTR_ERR(base);
-		goto err_unprepare_pclk;
-	}
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	rk3328->regmap = devm_regmap_init_mmio(&pdev->dev, base,
 					       &rk3328_codec_regmap_config);
-	if (IS_ERR(rk3328->regmap)) {
-		ret = PTR_ERR(rk3328->regmap);
-		goto err_unprepare_pclk;
-	}
+	if (IS_ERR(rk3328->regmap))
+		return PTR_ERR(rk3328->regmap);
 
 	platform_set_drvdata(pdev, rk3328);
 
-	ret = devm_snd_soc_register_component(&pdev->dev, &soc_codec_rk3328,
+	return devm_snd_soc_register_component(&pdev->dev, &soc_codec_rk3328,
 					       rk3328_dai,
 					       ARRAY_SIZE(rk3328_dai));
-	if (ret)
-		goto err_unprepare_pclk;
-
-	return 0;
-
-err_unprepare_pclk:
-	clk_disable_unprepare(rk3328->pclk);
-
-err_unprepare_mclk:
-	clk_disable_unprepare(rk3328->mclk);
-	return ret;
 }
 
 static const struct of_device_id rk3328_codec_of_match[] __maybe_unused = {
-- 
2.53.0




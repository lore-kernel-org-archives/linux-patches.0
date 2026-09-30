Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF15551123D;
	Wed, 30 Sep 2026 17:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790890; cv=none; b=l7okcyK+TmhJE5esoyeIMIeFToBQnWe8iqpph4ny08HlbG2v01uVo3oI+XcRU5M+Xg+raxkD0wEQuUyETnG4K72Ijjf/h7msxm5/v84wsRVyjjsu2M7S5LsqSDXGsGGkWgDA2ylZbYWxPFMv4EXQGv7v4lB7NWaCeALrBjHVbyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790890; c=relaxed/simple;
	bh=5NhjQ6dgJS9ViMaNiNIiorHVCLrYzQlcII7dOoSKJoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n4//179lU7d0kPKxr+uTaNT9Vv+nCseuluDd4xoVPLPNkWfGz+yGNH8vg0zkjx3TldKoNdguLM2wa5vwpQfbc7O9ecS3Kkc7X9nOO1Zvz0FY7SD3BnLG2ojqfyl0s/Nrgt1bEE2TQA4uQWDshhYzf9nVB2n+tE1AAZP7yCAcsu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIkCfNXo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIkCfNXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165F01F000FF;
	Wed, 30 Sep 2026 17:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790889;
	bh=0ZkOrEd7sXdSVV2u0TcXd8ktr1pWSozg+/ziShn/pJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HIkCfNXotHv/DJ3Dt5yHR7cQnQBoa05TnK8yVpTPUvi6lLNnJ5lHedhbae03gEAiW
	 PwODLFm4+64Qyoqj6BLdknX/kGKNLV7X9bbU2RHCdSOn50stZKgT26MMz7cZbdNwSY
	 4n9KK4Vxg8zHZzTtK36pZ4gMA/2B/PXMuscfIJYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/752] ASoC: codecs: rk3328: Use managed GPIO and clock helpers
Date: Wed, 30 Sep 2026 17:19:39 +0200
Message-ID: <20260930152400.528181510@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 86b679cf7aef9..69aad07f96ccf 100644
--- a/sound/soc/codecs/rk3328_codec.c
+++ b/sound/soc/codecs/rk3328_codec.c
@@ -426,7 +426,6 @@ static int rk3328_platform_probe(struct platform_device *pdev)
 	struct rk3328_codec_priv *rk3328;
 	struct regmap *grf;
 	void __iomem *base;
-	int ret = 0;
 
 	rk3328 = devm_kzalloc(&pdev->dev, sizeof(*rk3328), GFP_KERNEL);
 	if (!rk3328)
@@ -442,14 +441,13 @@ static int rk3328_platform_probe(struct platform_device *pdev)
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
@@ -462,57 +460,31 @@ static int rk3328_platform_probe(struct platform_device *pdev)
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




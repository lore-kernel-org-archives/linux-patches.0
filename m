Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033E53370E1;
	Fri, 17 Oct 2025 15:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713352; cv=none; b=sS1fLQg97Vtr/qO08Y9gQ8yENTHzTd6zNf1aZ1oqJvdnL+WiJ19kWsKB+3N2xasqLSHnHE66i2Tviz9htVtGRipESEjhz4M2ZjGahdEzEgvfF78+5C6acHIFQcCTrB9MQrhmK472CHivle4GM9DXLul3FV0QZR+tnFOnDR2Iqn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713352; c=relaxed/simple;
	bh=WkMIyHhbIPjXp9sAdW0Ftm3jKs6gLaXCG1Kry0VitoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzQ0O/j4AxGDDh5gKd81mU9HoyiqWsobrV5H8Q0EziCvP4LSwnkGrBA1kiB/HEHDrk7I1oRpwS98OmozeoIavW63KiJzNy6JyjsEeMBq7Wd08gNj1Xv0eksqFUSPCiQ9lX4tWZxw/zNcSIuuUlwXJ39GY2YWUqqd9lwoIxQsRdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0yO1wiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0yO1wiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A91C4CEF9;
	Fri, 17 Oct 2025 15:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713351;
	bh=WkMIyHhbIPjXp9sAdW0Ftm3jKs6gLaXCG1Kry0VitoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0yO1wivUxJ0KUXNrN8MDlmtFiFu8aB0Po5BW0CjcrJA1lpoIQ5i2bGNzbnPhhRhy
	 9AAxAF+EgBOvcY9LQZ8rvNE40uBHrj7sec9hHjhxlg/ihNZ8cDJg95RyfwRi+BKn54
	 ME+CTi6FP+MCK8KJVZFot1/VWIy5ssysXl8yQKGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/168] ASoC: codecs: wcd934x: Simplify with dev_err_probe
Date: Fri, 17 Oct 2025 16:53:35 +0200
Message-ID: <20251017145134.036562769@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit fa92f4294283cc7d1f29151420be9e9336182518 ]

Replace dev_err() in probe() path with dev_err_probe() to:
1. Make code a bit simpler and easier to read,
2. Do not print messages on deferred probe.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230418074630.8681-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 4e65bda8273c ("ASoC: wcd934x: fix error handling in wcd934x_codec_parse_data()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd934x.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -5884,10 +5884,9 @@ static int wcd934x_codec_parse_data(stru
 	slim_get_logical_addr(wcd->sidev);
 	wcd->if_regmap = regmap_init_slimbus(wcd->sidev,
 				  &wcd934x_ifc_regmap_config);
-	if (IS_ERR(wcd->if_regmap)) {
-		dev_err(dev, "Failed to allocate ifc register map\n");
-		return PTR_ERR(wcd->if_regmap);
-	}
+	if (IS_ERR(wcd->if_regmap))
+		return dev_err_probe(dev, PTR_ERR(wcd->if_regmap),
+				     "Failed to allocate ifc register map\n");
 
 	of_property_read_u32(dev->parent->of_node, "qcom,dmic-sample-rate",
 			     &wcd->dmic_sample_rate);
@@ -5939,19 +5938,15 @@ static int wcd934x_codec_probe(struct pl
 	memcpy(wcd->tx_chs, wcd934x_tx_chs, sizeof(wcd934x_tx_chs));
 
 	irq = regmap_irq_get_virq(data->irq_data, WCD934X_IRQ_SLIMBUS);
-	if (irq < 0) {
-		dev_err(wcd->dev, "Failed to get SLIM IRQ\n");
-		return irq;
-	}
+	if (irq < 0)
+		return dev_err_probe(wcd->dev, irq, "Failed to get SLIM IRQ\n");
 
 	ret = devm_request_threaded_irq(dev, irq, NULL,
 					wcd934x_slim_irq_handler,
 					IRQF_TRIGGER_RISING | IRQF_ONESHOT,
 					"slim", wcd);
-	if (ret) {
-		dev_err(dev, "Failed to request slimbus irq\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to request slimbus irq\n");
 
 	wcd934x_register_mclk_output(wcd);
 	platform_set_drvdata(pdev, wcd);



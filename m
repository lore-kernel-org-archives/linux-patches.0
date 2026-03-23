Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587D33B9DBE;
	Mon, 23 Mar 2026 13:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274395; cv=none; b=DFUOrc0PQHMrxkY5UEYE/VyJgdU4vkbiOCwqYgzf8clxmSpJ+WRIxtlQyHEfW3oqnvfSNcfQbdULHHkUgtphELlTjpXYL3IwlboLC29tDBFf6v+zlR6EJx1ptGPNuyb/w9o9+gA+vwecxqNlViaj2EYh5T0o2or2srmWRauxNkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274395; c=relaxed/simple;
	bh=nppihnrzhvY+HKjBhkzHv30Q24csl7+hhp0LfQ41bdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0c3pnFRbfOgQCAFnUUXILjxPCnaBRZdjBhe7Hs+2A3lbC3qWYJ6iNTkfBcDBXqUdgZShIZ2yhmeSNYUcstOLSbjM3i1VDJZfEWXNQh97PaDJpgJfcoj1IFoUbPhCnRVUbnuD4+2w6OGH7oX3TBOk6UBz3Gq6Zsp8O7TCDwWrgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jN1RhCWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jN1RhCWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00EEC4CEF7;
	Mon, 23 Mar 2026 13:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274395;
	bh=nppihnrzhvY+HKjBhkzHv30Q24csl7+hhp0LfQ41bdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jN1RhCWo4mzJnlRVnAZWjtBB+LmLZR7RuAxFGQuLjVJhpCo2w+hD5+t/GGFHHY032
	 b21c68swpocWNHf7GOsrCSAdnuQVQK7wKkmRJ52FqvluJZnNBiai9CNNKMhs6A8put
	 N9f3FdR4lvg64TKf48biJLKTmbcUcBee9mwu7+MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 203/220] spi: amlogic: spifc-a4: Remove redundant clock cleanup
Date: Mon, 23 Mar 2026 14:46:20 +0100
Message-ID: <20260323134510.990018429@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit a00da54d06f435dbbeacb84f9121dbbe6d6eda74 ]

The driver uses devm_clk_get_enabled() which enables the clock and
registers a callback to automatically disable it when the device
is unbound.

Remove the redundant aml_sfc_disable_clk() call in the error paths
and remove callback.

Fixes: 4670db6f32e9 ("spi: amlogic: add driver for Amlogic SPI Flash Controller")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260308-spifc-a4-1-v1-1-77e286c26832@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-amlogic-spifc-a4.c | 46 +++++-------------------------
 1 file changed, 7 insertions(+), 39 deletions(-)

diff --git a/drivers/spi/spi-amlogic-spifc-a4.c b/drivers/spi/spi-amlogic-spifc-a4.c
index f324aa39a8976..b2589fe2425cc 100644
--- a/drivers/spi/spi-amlogic-spifc-a4.c
+++ b/drivers/spi/spi-amlogic-spifc-a4.c
@@ -1083,14 +1083,6 @@ static int aml_sfc_clk_init(struct aml_sfc *sfc)
 	return clk_set_rate(sfc->core_clk, SFC_BUS_DEFAULT_CLK);
 }
 
-static int aml_sfc_disable_clk(struct aml_sfc *sfc)
-{
-	clk_disable_unprepare(sfc->core_clk);
-	clk_disable_unprepare(sfc->gate_clk);
-
-	return 0;
-}
-
 static int aml_sfc_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -1141,16 +1133,12 @@ static int aml_sfc_probe(struct platform_device *pdev)
 
 	/* Enable Amlogic flash controller spi mode */
 	ret = regmap_write(sfc->regmap_base, SFC_SPI_CFG, SPI_MODE_EN);
-	if (ret) {
-		dev_err(dev, "failed to enable SPI mode\n");
-		goto err_out;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to enable SPI mode\n");
 
 	ret = dma_set_mask(sfc->dev, DMA_BIT_MASK(32));
-	if (ret) {
-		dev_err(sfc->dev, "failed to set dma mask\n");
-		goto err_out;
-	}
+	if (ret)
+		return dev_err_probe(sfc->dev, ret, "failed to set dma mask\n");
 
 	sfc->ecc_eng.dev = &pdev->dev;
 	sfc->ecc_eng.integration = NAND_ECC_ENGINE_INTEGRATION_PIPELINED;
@@ -1158,10 +1146,8 @@ static int aml_sfc_probe(struct platform_device *pdev)
 	sfc->ecc_eng.priv = sfc;
 
 	ret = nand_ecc_register_on_host_hw_engine(&sfc->ecc_eng);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register Aml host ecc engine.\n");
-		goto err_out;
-	}
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret, "failed to register Aml host ecc engine.\n");
 
 	ret = of_property_read_u32(np, "amlogic,rx-adj", &val);
 	if (!ret)
@@ -1177,24 +1163,7 @@ static int aml_sfc_probe(struct platform_device *pdev)
 	ctrl->min_speed_hz = SFC_MIN_FREQUENCY;
 	ctrl->num_chipselect = SFC_MAX_CS_NUM;
 
-	ret = devm_spi_register_controller(dev, ctrl);
-	if (ret)
-		goto err_out;
-
-	return 0;
-
-err_out:
-	aml_sfc_disable_clk(sfc);
-
-	return ret;
-}
-
-static void aml_sfc_remove(struct platform_device *pdev)
-{
-	struct spi_controller *ctlr = platform_get_drvdata(pdev);
-	struct aml_sfc *sfc = spi_controller_get_devdata(ctlr);
-
-	aml_sfc_disable_clk(sfc);
+	return devm_spi_register_controller(dev, ctrl);
 }
 
 static const struct of_device_id aml_sfc_of_match[] = {
@@ -1212,7 +1181,6 @@ static struct platform_driver aml_sfc_driver = {
 		.of_match_table = aml_sfc_of_match,
 	},
 	.probe = aml_sfc_probe,
-	.remove = aml_sfc_remove,
 };
 module_platform_driver(aml_sfc_driver);
 
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A6446E005;
	Tue, 21 Jul 2026 17:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656179; cv=none; b=epejVpEBc3ytgBjFFNMWH3TfsbXZA9MN+QMS0XiXGIfnDohuyHdQ9p57mLOrTIlOUk4Fc0L7JbVVES21NWkiB66FmGfXKabb3Agc5/C9sp/QxtcxZZ53hF6dt+wwWc30SuZkobICPpmtYdz8Q6VwgwbZXmQ55bpY0UULgbXqc2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656179; c=relaxed/simple;
	bh=fgy73uReUS0Rzu4PhIjC8EJTYK+nyRSaOejBprEE4xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaaeHBMcpY6RRFi2SDEeQa3kvnyv1NBbzMeIL9Uybauh2Gb22DZOVP3X+gIfvSLU3HvUpz6Osbn5alxmbDH5O2Q8uq0GkXhmrv+cak+C700bH4LfOF/CWGI3yI5Jr2qwhZV/YgWJXmCEdf5MOeQc27+O1m2YA5tx1YWc5pBuyMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyspVRoK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyspVRoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5531F000E9;
	Tue, 21 Jul 2026 17:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656178;
	bh=XYfAZu2m3XAafBT0OHdVXExd8b+qyGnWn1e3A/zv5iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jyspVRoKutlkaSBusEAw8eiwJfmh+Gu7RvHWJi1WKF/MFfaZRFmSYM1ZIcxFSRq+l
	 xQclYJQVJR+vKj+kpvhjylvCszf4e3P8t+xjyEfNuCiSHYxpx797ajFZwd+Nk/dLrq
	 k2VkEYxPwfJuMuzTj4U/J7LgkZGUV3ZzNJSVi02w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0290/1611] spi: atmel: fix DMA channel and bounce buffer leaks
Date: Tue, 21 Jul 2026 17:06:46 +0200
Message-ID: <20260721152521.586425016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit bd7e9843ec95bffe2643c901dd625f0bab32e639 ]

The original code set use_dma to false when dma_alloc_coherent() for
bounce buffers failed, but DMA channels acquired earlier via
atmel_spi_configure_dma() were never freed.

When devm_request_irq() or clk_prepare_enable() failed later in probe,
the driver also did not release DMA channels or bounce buffers already
allocated.

The out_free_dma error path released DMA channels but did not free the
bounce buffers.

Fix by moving bounce buffer allocation into atmel_spi_configure_dma()
and registering the devres cleanup for DMA channels and bounce buffers.

Fixes: a9889ed62d06 ("spi: atmel: Implements transfers with bounce buffer")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260522-atmel-v3-1-23f8c6e6aa43@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-atmel.c | 133 ++++++++++++++++++++--------------------
 1 file changed, 68 insertions(+), 65 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 586e2fd357ed9d..a9499b51b8cc23 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -559,6 +559,38 @@ static int atmel_spi_dma_slave_config(struct atmel_spi *as, u8 bits_per_word)
 	return err;
 }
 
+static void atmel_spi_release_dma(void *data)
+{
+	struct spi_controller *host = data;
+	struct atmel_spi *as = spi_controller_get_devdata(host);
+	struct device *dev = &as->pdev->dev;
+
+	if (host->dma_tx) {
+		dma_release_channel(host->dma_tx);
+		host->dma_tx = NULL;
+	}
+
+	if (host->dma_rx) {
+		dma_release_channel(host->dma_rx);
+		host->dma_rx = NULL;
+	}
+
+	if (IS_ENABLED(CONFIG_SOC_SAM_V4_V5)) {
+		if (as->addr_tx_bbuf) {
+			dma_free_coherent(dev, SPI_MAX_DMA_XFER,
+					  as->addr_tx_bbuf,
+					  as->dma_addr_tx_bbuf);
+			as->addr_tx_bbuf = NULL;
+		}
+		if (as->addr_rx_bbuf) {
+			dma_free_coherent(dev, SPI_MAX_DMA_XFER,
+					  as->addr_rx_bbuf,
+					  as->dma_addr_rx_bbuf);
+			as->addr_rx_bbuf = NULL;
+		}
+	}
+}
+
 static int atmel_spi_configure_dma(struct spi_controller *host,
 				   struct atmel_spi *as)
 {
@@ -569,7 +601,8 @@ static int atmel_spi_configure_dma(struct spi_controller *host,
 	if (IS_ERR(host->dma_tx)) {
 		err = PTR_ERR(host->dma_tx);
 		dev_dbg(dev, "No TX DMA channel, DMA is disabled\n");
-		goto error_clear;
+		host->dma_tx = NULL;
+		return err;
 	}
 
 	host->dma_rx = dma_request_chan(dev, "rx");
@@ -580,26 +613,45 @@ static int atmel_spi_configure_dma(struct spi_controller *host,
 		 * requested tx channel.
 		 */
 		dev_dbg(dev, "No RX DMA channel, DMA is disabled\n");
-		goto error;
+		host->dma_rx = NULL;
+		goto err_release_dma;
 	}
 
 	err = atmel_spi_dma_slave_config(as, 8);
 	if (err)
-		goto error;
+		goto err_release_dma;
+
+	if (IS_ENABLED(CONFIG_SOC_SAM_V4_V5)) {
+		as->addr_tx_bbuf = dma_alloc_coherent(dev, SPI_MAX_DMA_XFER,
+						      &as->dma_addr_tx_bbuf,
+						      GFP_KERNEL | GFP_DMA);
+		if (!as->addr_tx_bbuf) {
+			err = -ENOMEM;
+			goto err_release_dma;
+		}
+
+		as->addr_rx_bbuf = dma_alloc_coherent(dev, SPI_MAX_DMA_XFER,
+						      &as->dma_addr_rx_bbuf,
+						      GFP_KERNEL | GFP_DMA);
+		if (!as->addr_rx_bbuf) {
+			err = -ENOMEM;
+			goto err_release_dma;
+		}
+	}
+
+	err = devm_add_action_or_reset(dev, atmel_spi_release_dma, host);
+	if (err)
+		return err;
 
 	dev_info(&as->pdev->dev,
-			"Using %s (tx) and %s (rx) for DMA transfers\n",
-			dma_chan_name(host->dma_tx),
-			dma_chan_name(host->dma_rx));
+		 "Using %s (tx) and %s (rx) for DMA transfers\n",
+		 dma_chan_name(host->dma_tx), dma_chan_name(host->dma_rx));
 
 	return 0;
-error:
-	if (!IS_ERR(host->dma_rx))
-		dma_release_channel(host->dma_rx);
-	if (!IS_ERR(host->dma_tx))
-		dma_release_channel(host->dma_tx);
-error_clear:
-	host->dma_tx = host->dma_rx = NULL;
+
+err_release_dma:
+	atmel_spi_release_dma(host);
+
 	return err;
 }
 
@@ -611,18 +663,6 @@ static void atmel_spi_stop_dma(struct spi_controller *host)
 		dmaengine_terminate_all(host->dma_tx);
 }
 
-static void atmel_spi_release_dma(struct spi_controller *host)
-{
-	if (host->dma_rx) {
-		dma_release_channel(host->dma_rx);
-		host->dma_rx = NULL;
-	}
-	if (host->dma_tx) {
-		dma_release_channel(host->dma_tx);
-		host->dma_tx = NULL;
-	}
-}
-
 /* This function is called by the DMA driver from tasklet context */
 static void dma_callback(void *data)
 {
@@ -1586,30 +1626,6 @@ static int atmel_spi_probe(struct platform_device *pdev)
 		as->use_pdc = true;
 	}
 
-	if (IS_ENABLED(CONFIG_SOC_SAM_V4_V5)) {
-		as->addr_rx_bbuf = dma_alloc_coherent(&pdev->dev,
-						      SPI_MAX_DMA_XFER,
-						      &as->dma_addr_rx_bbuf,
-						      GFP_KERNEL | GFP_DMA);
-		if (!as->addr_rx_bbuf) {
-			as->use_dma = false;
-		} else {
-			as->addr_tx_bbuf = dma_alloc_coherent(&pdev->dev,
-					SPI_MAX_DMA_XFER,
-					&as->dma_addr_tx_bbuf,
-					GFP_KERNEL | GFP_DMA);
-			if (!as->addr_tx_bbuf) {
-				as->use_dma = false;
-				dma_free_coherent(&pdev->dev, SPI_MAX_DMA_XFER,
-						  as->addr_rx_bbuf,
-						  as->dma_addr_rx_bbuf);
-			}
-		}
-		if (!as->use_dma)
-			dev_info(host->dev.parent,
-				 "  can not allocate dma coherent memory\n");
-	}
-
 	if (as->caps.has_dma_support && !as->use_dma)
 		dev_info(&pdev->dev, "Atmel SPI Controller using PIO only\n");
 
@@ -1669,13 +1685,10 @@ static int atmel_spi_probe(struct platform_device *pdev)
 out_free_dma:
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
-
-	if (as->use_dma)
-		atmel_spi_release_dma(host);
-
 	spi_writel(as, CR, SPI_BIT(SWRST));
 	spi_writel(as, CR, SPI_BIT(SWRST)); /* AT91SAM9263 Rev B workaround */
-	clk_disable_unprepare(as->gclk);
+	if (as->gclk)
+		clk_disable_unprepare(as->gclk);
 out_disable_clk:
 	clk_disable_unprepare(clk);
 out_free_irq:
@@ -1696,18 +1709,8 @@ static void atmel_spi_remove(struct platform_device *pdev)
 	spi_unregister_controller(host);
 
 	/* reset the hardware and block queue progress */
-	if (as->use_dma) {
+	if (as->use_dma)
 		atmel_spi_stop_dma(host);
-		atmel_spi_release_dma(host);
-		if (IS_ENABLED(CONFIG_SOC_SAM_V4_V5)) {
-			dma_free_coherent(&pdev->dev, SPI_MAX_DMA_XFER,
-					  as->addr_tx_bbuf,
-					  as->dma_addr_tx_bbuf);
-			dma_free_coherent(&pdev->dev, SPI_MAX_DMA_XFER,
-					  as->addr_rx_bbuf,
-					  as->dma_addr_rx_bbuf);
-		}
-	}
 
 	spin_lock_irq(&as->lock);
 	spi_writel(as, CR, SPI_BIT(SWRST));
-- 
2.53.0




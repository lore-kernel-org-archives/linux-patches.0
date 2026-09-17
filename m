Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7684F4EDCC6;
	Thu, 17 Sep 2026 16:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664148; cv=none; b=vC1R/X5iVrsn4FEnnxtQBWyA2fmXG5Txie+PIUmAGuKAZZVi3fnLu0FpbE24FwU9lgZ0/1GZEIc+vfdMKfwcHkmBRaNZwPVZHxJzW1oeVMCXtbjmeP/cyBJBkXV9MGpUMmBgyKnHdGjzRA21kLRBbKy/lH+qZEJ/pu0PVi7zmTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664148; c=relaxed/simple;
	bh=rCuEMUIiOnSJ26hHdLuOYk6j+GuqHIH+KPwbY/ww2p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWg/o3c+73nrPdR/QJLDBu3klIJ2ffG+jicQF7vurwSnt9g6k66TaV9zRcNv5WXyPt5n/I4HfKjCxb2hStXQZI3MxHQQwQcCiO3W4q/vysvlM7V5lxE3N3vcxl0lwcPzr8jhJjz8SaWoTq+fS4VvXZTbQlmOS0dOzpGm1H9ud7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfQ2AzjA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfQ2AzjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965591F000FF;
	Thu, 17 Sep 2026 16:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664147;
	bh=m3crK8fUNHhKeCaGEYCUoEULaqFC52eUl6wxAKrX1JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FfQ2AzjAn5q8hPW+m5CIkR1aMTbQ3Z//hXN9KQRnWKNful8X9hidaKBIPvz2yJQRR
	 Zm69hVxG+kBjRARTRj17q4g72+d2Lxy43Kx5J+qTrziMu0hgotRBvsbxgne17DrDoD
	 k3CNnnJ263KibNQZ/ckMZ+Y+nhWmtKh+LKmsSjUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thierry Reding <treding@nvidia.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0275/1250] spi: tegra210-quad: Allocate DMA memory for DMA engine
Date: Thu, 17 Sep 2026 16:01:10 +0100
Message-ID: <20260917151559.592115917@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit f469138a77ac5ab685dfe15dfed7dccb9d5c33e5 ]

When the SPI controllers are running in DMA mode, it is the DMA engine
that performs the memory accesses rather than the SPI controller. Pass
the DMA engine's struct device pointer to the DMA API to make sure the
correct DMA operations are used.

Suggested-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://patch.msgid.link/20260525-tegra194-qspi-iommu-v2-1-a11c53f804b2@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 83def82fe48c1..543f13503df3d 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -226,11 +226,13 @@ struct tegra_qspi {
 	struct completion			xfer_completion;
 	struct spi_transfer			*curr_xfer;
 
+	struct device				*rx_dma_dev;
 	struct dma_chan				*rx_dma_chan;
 	u32					*rx_dma_buf;
 	dma_addr_t				rx_dma_phys;
 	struct dma_async_tx_descriptor		*rx_dma_desc;
 
+	struct device				*tx_dma_dev;
 	struct dma_chan				*tx_dma_chan;
 	u32					*tx_dma_buf;
 	dma_addr_t				tx_dma_phys;
@@ -574,15 +576,15 @@ static int tegra_qspi_dma_map_xfer(struct tegra_qspi *tqspi, struct spi_transfer
 	len = DIV_ROUND_UP(tqspi->curr_dma_words * tqspi->bytes_per_word, 4) * 4;
 
 	if (t->tx_buf) {
-		t->tx_dma = dma_map_single(tqspi->dev, (void *)tx_buf, len, DMA_TO_DEVICE);
-		if (dma_mapping_error(tqspi->dev, t->tx_dma))
+		t->tx_dma = dma_map_single(tqspi->tx_dma_dev, (void *)tx_buf, len, DMA_TO_DEVICE);
+		if (dma_mapping_error(tqspi->tx_dma_dev, t->tx_dma))
 			return -ENOMEM;
 	}
 
 	if (t->rx_buf) {
-		t->rx_dma = dma_map_single(tqspi->dev, (void *)rx_buf, len, DMA_FROM_DEVICE);
-		if (dma_mapping_error(tqspi->dev, t->rx_dma)) {
-			dma_unmap_single(tqspi->dev, t->tx_dma, len, DMA_TO_DEVICE);
+		t->rx_dma = dma_map_single(tqspi->rx_dma_dev, (void *)rx_buf, len, DMA_FROM_DEVICE);
+		if (dma_mapping_error(tqspi->rx_dma_dev, t->rx_dma)) {
+			dma_unmap_single(tqspi->tx_dma_dev, t->tx_dma, len, DMA_TO_DEVICE);
 			return -ENOMEM;
 		}
 	}
@@ -597,9 +599,9 @@ static void tegra_qspi_dma_unmap_xfer(struct tegra_qspi *tqspi, struct spi_trans
 	len = DIV_ROUND_UP(tqspi->curr_dma_words * tqspi->bytes_per_word, 4) * 4;
 
 	if (t->tx_buf)
-		dma_unmap_single(tqspi->dev, t->tx_dma, len, DMA_TO_DEVICE);
+		dma_unmap_single(tqspi->tx_dma_dev, t->tx_dma, len, DMA_TO_DEVICE);
 	if (t->rx_buf)
-		dma_unmap_single(tqspi->dev, t->rx_dma, len, DMA_FROM_DEVICE);
+		dma_unmap_single(tqspi->rx_dma_dev, t->rx_dma, len, DMA_FROM_DEVICE);
 }
 
 static int tegra_qspi_start_dma_based_transfer(struct tegra_qspi *tqspi, struct spi_transfer *t)
@@ -745,7 +747,7 @@ static int tegra_qspi_start_cpu_based_transfer(struct tegra_qspi *qspi, struct s
 static void tegra_qspi_deinit_dma(struct tegra_qspi *tqspi)
 {
 	if (tqspi->tx_dma_buf) {
-		dma_free_coherent(tqspi->dev, tqspi->dma_buf_size,
+		dma_free_coherent(tqspi->tx_dma_dev, tqspi->dma_buf_size,
 				  tqspi->tx_dma_buf, tqspi->tx_dma_phys);
 		tqspi->tx_dma_buf = NULL;
 	}
@@ -756,7 +758,7 @@ static void tegra_qspi_deinit_dma(struct tegra_qspi *tqspi)
 	}
 
 	if (tqspi->rx_dma_buf) {
-		dma_free_coherent(tqspi->dev, tqspi->dma_buf_size,
+		dma_free_coherent(tqspi->rx_dma_dev, tqspi->dma_buf_size,
 				  tqspi->rx_dma_buf, tqspi->rx_dma_phys);
 		tqspi->rx_dma_buf = NULL;
 	}
@@ -782,6 +784,7 @@ static int tegra_qspi_init_dma(struct tegra_qspi *tqspi)
 		}
 
 		tqspi->rx_dma_chan = dma_chan;
+		tqspi->rx_dma_dev = dmaengine_get_dma_device(tqspi->rx_dma_chan);
 
 		dma_chan = dma_request_chan(tqspi->dev, "tx");
 		if (IS_ERR(dma_chan)) {
@@ -790,15 +793,19 @@ static int tegra_qspi_init_dma(struct tegra_qspi *tqspi)
 		}
 
 		tqspi->tx_dma_chan = dma_chan;
+		tqspi->tx_dma_dev = dmaengine_get_dma_device(tqspi->tx_dma_chan);
 	} else {
 		if (!device_iommu_mapped(tqspi->dev)) {
 			dev_warn(tqspi->dev,
 				 "IOMMU not enabled in device-tree, falling back to PIO mode\n");
 			return 0;
 		}
+
+		tqspi->rx_dma_dev = tqspi->dev;
+		tqspi->tx_dma_dev = tqspi->dev;
 	}
 
-	dma_buf = dma_alloc_coherent(tqspi->dev, tqspi->dma_buf_size, &dma_phys, GFP_KERNEL);
+	dma_buf = dma_alloc_coherent(tqspi->rx_dma_dev, tqspi->dma_buf_size, &dma_phys, GFP_KERNEL);
 	if (!dma_buf) {
 		err = -ENOMEM;
 		goto err_out;
@@ -807,7 +814,7 @@ static int tegra_qspi_init_dma(struct tegra_qspi *tqspi)
 	tqspi->rx_dma_buf = dma_buf;
 	tqspi->rx_dma_phys = dma_phys;
 
-	dma_buf = dma_alloc_coherent(tqspi->dev, tqspi->dma_buf_size, &dma_phys, GFP_KERNEL);
+	dma_buf = dma_alloc_coherent(tqspi->tx_dma_dev, tqspi->dma_buf_size, &dma_phys, GFP_KERNEL);
 	if (!dma_buf) {
 		err = -ENOMEM;
 		goto err_out;
-- 
2.53.0




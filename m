Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABCC5102D;
	Mon, 11 Dec 2023 18:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwepdCfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34A0C433C8;
	Mon, 11 Dec 2023 18:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319061;
	bh=puEfbKJ1S+bQpS/fz3EJIYwpzdRO9ypSfxpzHZn8hto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwepdCfNNZhfEucxBqNgc0CCA3S+dEmfrcjiLNrF9mRQuhCUcYOgS2KUi7TIDd3Qs
	 oXxi/nAt1uxT3RMVx47qGgjwgiID/CuFrk0/8lnP0JqXkDmb7M3JqoyK6A7xSL8SW2
	 xnP8NrJrVtxd5RPtwqoaAfpyFhp/U/zi7cve6UVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Gong <yibin.gong@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/55] spi: imx: correct wml as the last sg length
Date: Mon, 11 Dec 2023 19:21:13 +0100
Message-ID: <20231211182012.375843644@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182012.263036284@linuxfoundation.org>
References: <20231211182012.263036284@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Gong <yibin.gong@nxp.com>

[ Upstream commit 5ba5a3730639caddf42af11c60f3f3d99d9a5f00 ]

Correct wml as the last rx sg length instead of the whole transfer
length. Otherwise, mtd_stresstest will be failed as below:

insmod mtd_stresstest.ko dev=0
=================================================
mtd_stresstest: MTD device: 0
mtd_stresstest: not NAND flash, assume page size is 512 bytes.
mtd_stresstest: MTD device size 4194304, eraseblock size 65536, page size 512, count of eraseblocks 64, pa0
mtd_stresstest: doing operations
mtd_stresstest: 0 operations done
mtd_test: mtd_read from 1ff532, size 880
mtd_test: mtd_read from 20c267, size 64998
spi_master spi0: I/O Error in DMA RX
m25p80 spi0.0: SPI transfer failed: -110
spi_master spi0: failed to transfer one message from queue
mtd_test: error: read failed at 0x20c267
mtd_stresstest: error -110 occurred
=================================================
insmod: ERROR: could not insert module mtd_stresstest.ko: Connection timed out

Signed-off-by: Robin Gong <yibin.gong@nxp.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 00b80ac93553 ("spi: imx: mx51-ecspi: Move some initialisation to prepare_message hook.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 686251e05edfe..139127e27a147 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -218,7 +218,6 @@ static bool spi_imx_can_dma(struct spi_master *master, struct spi_device *spi,
 			 struct spi_transfer *transfer)
 {
 	struct spi_imx_data *spi_imx = spi_master_get_devdata(master);
-	unsigned int bytes_per_word, i;
 
 	if (!master->dma_rx)
 		return false;
@@ -226,14 +225,6 @@ static bool spi_imx_can_dma(struct spi_master *master, struct spi_device *spi,
 	if (spi_imx->slave_mode)
 		return false;
 
-	bytes_per_word = spi_imx_bytes_per_word(transfer->bits_per_word);
-
-	for (i = spi_imx->devtype_data->fifo_size / 2; i > 0; i--) {
-		if (!(transfer->len % (i * bytes_per_word)))
-			break;
-	}
-
-	spi_imx->wml = i;
 	spi_imx->dynamic_burst = 0;
 
 	return true;
@@ -612,7 +603,7 @@ static void mx51_setup_wml(struct spi_imx_data *spi_imx)
 	 * and enable DMA request.
 	 */
 
-	writel(MX51_ECSPI_DMA_RX_WML(spi_imx->wml) |
+	writel(MX51_ECSPI_DMA_RX_WML(spi_imx->wml - 1) |
 		MX51_ECSPI_DMA_TX_WML(spi_imx->wml) |
 		MX51_ECSPI_DMA_RXT_WML(spi_imx->wml) |
 		MX51_ECSPI_DMA_TEDEN | MX51_ECSPI_DMA_RXDEN |
@@ -1330,12 +1321,30 @@ static int spi_imx_dma_transfer(struct spi_imx_data *spi_imx,
 	unsigned long timeout;
 	struct spi_master *master = spi_imx->bitbang.master;
 	struct sg_table *tx = &transfer->tx_sg, *rx = &transfer->rx_sg;
+	struct scatterlist *last_sg = sg_last(rx->sgl, rx->nents);
+	unsigned int bytes_per_word, i;
 	int ret;
 
+	/* Get the right burst length from the last sg to ensure no tail data */
+	bytes_per_word = spi_imx_bytes_per_word(transfer->bits_per_word);
+	for (i = spi_imx->devtype_data->fifo_size / 2; i > 0; i--) {
+		if (!(sg_dma_len(last_sg) % (i * bytes_per_word)))
+			break;
+	}
+	/* Use 1 as wml in case no available burst length got */
+	if (i == 0)
+		i = 1;
+
+	spi_imx->wml =  i;
+
 	ret = spi_imx_dma_configure(master);
 	if (ret)
 		return ret;
 
+	if (!spi_imx->devtype_data->setup_wml) {
+		dev_err(spi_imx->dev, "No setup_wml()?\n");
+		return -EINVAL;
+	}
 	spi_imx->devtype_data->setup_wml(spi_imx);
 
 	/*
-- 
2.42.0




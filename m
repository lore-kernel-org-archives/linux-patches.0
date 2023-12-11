Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D624F212;
	Mon, 11 Dec 2023 18:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgqktxda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B35C433C7;
	Mon, 11 Dec 2023 18:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319050;
	bh=wszyAsbNLwP5GKixuEdhJfXEkNorm2l8bOfiKMk1BB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgqktxda8++CYyy+STZnHVVIXPadDo4+6wwv1wwx+cutu0Sxo1pCFv4op5iwA6U7d
	 HnplmIICGKuWKEpxkShHzB8KBpS68iADDQLA1fJToFE+Hz+FrvRHN4b6rIcmeV6P5O
	 gkgBYDMIaQhcbtxkG6WjC2u8jYSdnskMRMkacKY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Gong <yibin.gong@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/55] spi: imx: move wml setting to later than setup_transfer
Date: Mon, 11 Dec 2023 19:21:12 +0100
Message-ID: <20231211182012.344555680@linuxfoundation.org>
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

[ Upstream commit 987a2dfe3f0485a82d87106e7e1c43f35c1d3b09 ]

Current dynamic burst length is based on the whole transfer length,
that's ok if there is only one sg, but is not right in case multi sgs
in one transfer,because the tail data should be based on the last sg
length instead of the whole transfer length. Move wml setting for DMA
to the later place, thus, the next patch could get the right last sg
length for wml setting. This patch is a preparation one, no any
function change involved.

Signed-off-by: Robin Gong <yibin.gong@nxp.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 00b80ac93553 ("spi: imx: mx51-ecspi: Move some initialisation to prepare_message hook.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index eb27f47578eb9..686251e05edfe 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -64,6 +64,7 @@ struct spi_imx_devtype_data {
 	void (*trigger)(struct spi_imx_data *);
 	int (*rx_available)(struct spi_imx_data *);
 	void (*reset)(struct spi_imx_data *);
+	void (*setup_wml)(struct spi_imx_data *);
 	void (*disable)(struct spi_imx_data *);
 	bool has_dmamode;
 	bool has_slavemode;
@@ -601,6 +602,11 @@ static int mx51_ecspi_config(struct spi_device *spi)
 	else			/* SCLK is _very_ slow */
 		usleep_range(delay, delay + 10);
 
+	return 0;
+}
+
+static void mx51_setup_wml(struct spi_imx_data *spi_imx)
+{
 	/*
 	 * Configure the DMA register: setup the watermark
 	 * and enable DMA request.
@@ -611,8 +617,6 @@ static int mx51_ecspi_config(struct spi_device *spi)
 		MX51_ECSPI_DMA_RXT_WML(spi_imx->wml) |
 		MX51_ECSPI_DMA_TEDEN | MX51_ECSPI_DMA_RXDEN |
 		MX51_ECSPI_DMA_RXTDEN, spi_imx->base + MX51_ECSPI_DMA);
-
-	return 0;
 }
 
 static int mx51_ecspi_rx_available(struct spi_imx_data *spi_imx)
@@ -973,6 +977,7 @@ static struct spi_imx_devtype_data imx51_ecspi_devtype_data = {
 	.trigger = mx51_ecspi_trigger,
 	.rx_available = mx51_ecspi_rx_available,
 	.reset = mx51_ecspi_reset,
+	.setup_wml = mx51_setup_wml,
 	.fifo_size = 64,
 	.has_dmamode = true,
 	.dynamic_burst = true,
@@ -1181,7 +1186,6 @@ static int spi_imx_setupxfer(struct spi_device *spi,
 				 struct spi_transfer *t)
 {
 	struct spi_imx_data *spi_imx = spi_master_get_devdata(spi->master);
-	int ret;
 
 	if (!t)
 		return 0;
@@ -1222,12 +1226,6 @@ static int spi_imx_setupxfer(struct spi_device *spi,
 	else
 		spi_imx->usedma = 0;
 
-	if (spi_imx->usedma) {
-		ret = spi_imx_dma_configure(spi->master);
-		if (ret)
-			return ret;
-	}
-
 	if (is_imx53_ecspi(spi_imx) && spi_imx->slave_mode) {
 		spi_imx->rx = mx53_ecspi_rx_slave;
 		spi_imx->tx = mx53_ecspi_tx_slave;
@@ -1332,6 +1330,13 @@ static int spi_imx_dma_transfer(struct spi_imx_data *spi_imx,
 	unsigned long timeout;
 	struct spi_master *master = spi_imx->bitbang.master;
 	struct sg_table *tx = &transfer->tx_sg, *rx = &transfer->rx_sg;
+	int ret;
+
+	ret = spi_imx_dma_configure(master);
+	if (ret)
+		return ret;
+
+	spi_imx->devtype_data->setup_wml(spi_imx);
 
 	/*
 	 * The TX DMA setup starts the transfer, so make sure RX is configured
-- 
2.42.0




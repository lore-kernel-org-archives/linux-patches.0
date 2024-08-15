Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C20B1714AE;
	Thu, 15 Aug 2024 13:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728962; cv=none; b=s++XeXvA6C5cTe2UQOpfoVzC39Xg53OFVSpOMSWnUCyDIZU4g9B6wmtq5Gd809slj/gcy4gN2TbPyc4lZ2iKgeMiBuI/M1EFpX6rPT4/MWmAik+MBIcIp1gHeo67cnh8/BUNRYuVad849JavxzpfEEipMIFpqpfdbRIs2iIzgXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728962; c=relaxed/simple;
	bh=ogNiaaBB0iwwJFINP1CeoJO4jkKBVSkHFOwLYxt39UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXilAiT3KprJFbj56dCvTFD04NEHErHm+mAKGNc0VO0kihp7YBp8O8SGs7wnd4/8jVI5T3Yfv27GxETgy9UryxtKirz4jVb1trANMlymwbJENZjLIWgX/Sq3zTt79KEBLZC7sz4VMWPW0RlXUWjQIKiehzwJh/cscJq6b8rZXWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDaCNkY+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDaCNkY+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DEAC4AF0D;
	Thu, 15 Aug 2024 13:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728962;
	bh=ogNiaaBB0iwwJFINP1CeoJO4jkKBVSkHFOwLYxt39UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDaCNkY+ZdoKhroKjiYUlpuWPIxYACEPuTEaJOM011ReaMPqHR55mXvCqsdNLP6x8
	 PzSWdobQDy5P8wCW6pUQJSCW74tk552DMtQ97PHh5KLYLh6snEF+YSNFZ+0AN3gDAf
	 gfYLMNovxXHDl5oxetndmGWxSt+3viHIJxiHmcLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 166/196] spi: lpspi: Add slave mode support
Date: Thu, 15 Aug 2024 15:24:43 +0200
Message-ID: <20240815131858.424851184@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

From: Clark Wang <xiaoning.wang@nxp.com>

[ Upstream commit bcd87317aae26b9ac497cbc1232783aaea1aeed4 ]

Add slave mode support to the fsl-lpspi driver, only in PIO mode.

For now, there are some limitations for slave mode transmission:
1. The stale data in RXFIFO will be dropped when the Slave does any new
   transfer.
2. One transfer can be finished only after all transfer->len data been
   transferred to master device
3. Slave device only accepts transfer->len data. Any data longer than
   this from master device will be dropped. Any data shorter than this
   from master will cause LPSPI to stuck due to mentioned limitation 2.
4. Only PIO transfer is supported in Slave Mode.

Wire connection:
GND, SCK, MISO(to MISO of slave), MOSI(to MOSI of slave), SCS

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 730bbfaf7d48 ("spi: spi-fsl-lpspi: Fix scldiv calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 107 ++++++++++++++++++++++++++----------
 1 file changed, 79 insertions(+), 28 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 725d6ac5f814d..cbf165e7bd17b 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -55,6 +55,7 @@
 #define IER_RDIE	BIT(1)
 #define IER_TDIE	BIT(0)
 #define CFGR1_PCSCFG	BIT(27)
+#define CFGR1_PINCFG	(BIT(24)|BIT(25))
 #define CFGR1_PCSPOL	BIT(8)
 #define CFGR1_NOSTALL	BIT(3)
 #define CFGR1_MASTER	BIT(0)
@@ -80,6 +81,7 @@ struct fsl_lpspi_data {
 	struct device *dev;
 	void __iomem *base;
 	struct clk *clk;
+	bool is_slave;
 
 	void *rx_buf;
 	const void *tx_buf;
@@ -92,6 +94,8 @@ struct fsl_lpspi_data {
 
 	struct lpspi_config config;
 	struct completion xfer_done;
+
+	bool slave_aborted;
 };
 
 static const struct of_device_id fsl_lpspi_dt_ids[] = {
@@ -206,21 +210,22 @@ static void fsl_lpspi_set_cmd(struct fsl_lpspi_data *fsl_lpspi,
 	u32 temp = 0;
 
 	temp |= fsl_lpspi->config.bpw - 1;
-	temp |= fsl_lpspi->config.prescale << 27;
 	temp |= (fsl_lpspi->config.mode & 0x3) << 30;
-	temp |= (fsl_lpspi->config.chip_select & 0x3) << 24;
-
-	/*
-	 * Set TCR_CONT will keep SS asserted after current transfer.
-	 * For the first transfer, clear TCR_CONTC to assert SS.
-	 * For subsequent transfer, set TCR_CONTC to keep SS asserted.
-	 */
-	temp |= TCR_CONT;
-	if (is_first_xfer)
-		temp &= ~TCR_CONTC;
-	else
-		temp |= TCR_CONTC;
-
+	if (!fsl_lpspi->is_slave) {
+		temp |= fsl_lpspi->config.prescale << 27;
+		temp |= (fsl_lpspi->config.chip_select & 0x3) << 24;
+
+		/*
+		 * Set TCR_CONT will keep SS asserted after current transfer.
+		 * For the first transfer, clear TCR_CONTC to assert SS.
+		 * For subsequent transfer, set TCR_CONTC to keep SS asserted.
+		 */
+		temp |= TCR_CONT;
+		if (is_first_xfer)
+			temp &= ~TCR_CONTC;
+		else
+			temp |= TCR_CONTC;
+	}
 	writel(temp, fsl_lpspi->base + IMX7ULP_TCR);
 
 	dev_dbg(fsl_lpspi->dev, "TCR=0x%x\n", temp);
@@ -273,13 +278,18 @@ static int fsl_lpspi_config(struct fsl_lpspi_data *fsl_lpspi)
 	writel(temp, fsl_lpspi->base + IMX7ULP_CR);
 	writel(0, fsl_lpspi->base + IMX7ULP_CR);
 
-	ret = fsl_lpspi_set_bitrate(fsl_lpspi);
-	if (ret)
-		return ret;
+	if (!fsl_lpspi->is_slave) {
+		ret = fsl_lpspi_set_bitrate(fsl_lpspi);
+		if (ret)
+			return ret;
+	}
 
 	fsl_lpspi_set_watermark(fsl_lpspi);
 
-	temp = CFGR1_PCSCFG | CFGR1_MASTER;
+	if (!fsl_lpspi->is_slave)
+		temp = CFGR1_MASTER;
+	else
+		temp = CFGR1_PINCFG;
 	if (fsl_lpspi->config.mode & SPI_CS_HIGH)
 		temp |= CFGR1_PCSPOL;
 	writel(temp, fsl_lpspi->base + IMX7ULP_CFGR1);
@@ -322,6 +332,37 @@ static void fsl_lpspi_setup_transfer(struct spi_device *spi,
 	fsl_lpspi_config(fsl_lpspi);
 }
 
+static int fsl_lpspi_slave_abort(struct spi_controller *controller)
+{
+	struct fsl_lpspi_data *fsl_lpspi =
+				spi_controller_get_devdata(controller);
+
+	fsl_lpspi->slave_aborted = true;
+	complete(&fsl_lpspi->xfer_done);
+	return 0;
+}
+
+static int fsl_lpspi_wait_for_completion(struct spi_controller *controller)
+{
+	struct fsl_lpspi_data *fsl_lpspi =
+				spi_controller_get_devdata(controller);
+
+	if (fsl_lpspi->is_slave) {
+		if (wait_for_completion_interruptible(&fsl_lpspi->xfer_done) ||
+			fsl_lpspi->slave_aborted) {
+			dev_dbg(fsl_lpspi->dev, "interrupted\n");
+			return -EINTR;
+		}
+	} else {
+		if (!wait_for_completion_timeout(&fsl_lpspi->xfer_done, HZ)) {
+			dev_dbg(fsl_lpspi->dev, "wait for completion timeout\n");
+			return -ETIMEDOUT;
+		}
+	}
+
+	return 0;
+}
+
 static int fsl_lpspi_transfer_one(struct spi_controller *controller,
 				  struct spi_device *spi,
 				  struct spi_transfer *t)
@@ -335,13 +376,13 @@ static int fsl_lpspi_transfer_one(struct spi_controller *controller,
 	fsl_lpspi->remain = t->len;
 
 	reinit_completion(&fsl_lpspi->xfer_done);
+	fsl_lpspi->slave_aborted = false;
+
 	fsl_lpspi_write_tx_fifo(fsl_lpspi);
 
-	ret = wait_for_completion_timeout(&fsl_lpspi->xfer_done, HZ);
-	if (!ret) {
-		dev_dbg(fsl_lpspi->dev, "wait for completion timeout\n");
-		return -ETIMEDOUT;
-	}
+	ret = fsl_lpspi_wait_for_completion(controller);
+	if (ret)
+		return ret;
 
 	ret = fsl_lpspi_txfifo_empty(fsl_lpspi);
 	if (ret)
@@ -380,10 +421,12 @@ static int fsl_lpspi_transfer_one_msg(struct spi_controller *controller,
 	}
 
 complete:
-	/* de-assert SS, then finalize current message */
-	temp = readl(fsl_lpspi->base + IMX7ULP_TCR);
-	temp &= ~TCR_CONTC;
-	writel(temp, fsl_lpspi->base + IMX7ULP_TCR);
+	if (!fsl_lpspi->is_slave) {
+		/* de-assert SS, then finalize current message */
+		temp = readl(fsl_lpspi->base + IMX7ULP_TCR);
+		temp &= ~TCR_CONTC;
+		writel(temp, fsl_lpspi->base + IMX7ULP_TCR);
+	}
 
 	msg->status = ret;
 	spi_finalize_current_message(controller);
@@ -421,8 +464,13 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 	int ret, irq;
 	u32 temp;
 
-	controller = spi_alloc_master(&pdev->dev,
+	if (of_property_read_bool((&pdev->dev)->of_node, "spi-slave"))
+		controller = spi_alloc_slave(&pdev->dev,
+					sizeof(struct fsl_lpspi_data));
+	else
+		controller = spi_alloc_master(&pdev->dev,
 					sizeof(struct fsl_lpspi_data));
+
 	if (!controller)
 		return -ENOMEM;
 
@@ -433,6 +481,8 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 
 	fsl_lpspi = spi_controller_get_devdata(controller);
 	fsl_lpspi->dev = &pdev->dev;
+	fsl_lpspi->is_slave = of_property_read_bool((&pdev->dev)->of_node,
+						    "spi-slave");
 
 	controller->transfer_one_message = fsl_lpspi_transfer_one_msg;
 	controller->prepare_transfer_hardware = lpspi_prepare_xfer_hardware;
@@ -441,6 +491,7 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 	controller->flags = SPI_MASTER_MUST_RX | SPI_MASTER_MUST_TX;
 	controller->dev.of_node = pdev->dev.of_node;
 	controller->bus_num = pdev->id;
+	controller->slave_abort = fsl_lpspi_slave_abort;
 
 	init_completion(&fsl_lpspi->xfer_done);
 
-- 
2.43.0




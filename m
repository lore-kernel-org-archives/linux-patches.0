Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2266F1BDEC;
	Wed,  3 Jan 2024 17:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MciN7R+1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425E1C433C8;
	Wed,  3 Jan 2024 17:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301961;
	bh=xA72vAq+iRE9IRIF9XLQVRuq3ZcizrhQc+Hcj673dbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MciN7R+1sZeHVoHMNC3CMLR+W5Iptrjvl1q1QU97yPltFDLzeDMc1HKzzikN+ugU5
	 g98brsgshslphB/60lgPX9jmdI4ftDiFyatSVkc6gYZQ8tjIn4LOWNEn2EmzJGoGPu
	 xmp4JiUt+5aW0MOYD9GuoPX1uvidr2j9JIDzvl3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Sneddon <dan.sneddon@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 60/75] spi: atmel: Switch to transfer_one transfer method
Date: Wed,  3 Jan 2024 17:55:41 +0100
Message-ID: <20240103164852.196748907@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
References: <20240103164842.953224409@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Sneddon <dan.sneddon@microchip.com>

[ Upstream commit 5fa5e6dec762305a783e918a90a05369fc10e346 ]

Switch from using our own transfer_one_message routine to using the one
provided by the SPI core.

Signed-off-by: Dan Sneddon <dan.sneddon@microchip.com>
Link: https://lore.kernel.org/r/20210602160816.4890-1-dan.sneddon@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: fc70d643a2f6 ("spi: atmel: Fix clock issue when using devices with different polarities")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-atmel.c | 124 +++++++++++-----------------------------
 1 file changed, 33 insertions(+), 91 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 1db43cbead575..2dba2089f2b7e 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -867,7 +867,6 @@ static int atmel_spi_set_xfer_speed(struct atmel_spi *as,
  * lock is held, spi irq is blocked
  */
 static void atmel_spi_pdc_next_xfer(struct spi_master *master,
-					struct spi_message *msg,
 					struct spi_transfer *xfer)
 {
 	struct atmel_spi	*as = spi_master_get_devdata(master);
@@ -883,12 +882,12 @@ static void atmel_spi_pdc_next_xfer(struct spi_master *master,
 	spi_writel(as, RPR, rx_dma);
 	spi_writel(as, TPR, tx_dma);
 
-	if (msg->spi->bits_per_word > 8)
+	if (xfer->bits_per_word > 8)
 		len >>= 1;
 	spi_writel(as, RCR, len);
 	spi_writel(as, TCR, len);
 
-	dev_dbg(&msg->spi->dev,
+	dev_dbg(&master->dev,
 		"  start xfer %p: len %u tx %p/%08llx rx %p/%08llx\n",
 		xfer, xfer->len, xfer->tx_buf,
 		(unsigned long long)xfer->tx_dma, xfer->rx_buf,
@@ -902,12 +901,12 @@ static void atmel_spi_pdc_next_xfer(struct spi_master *master,
 		spi_writel(as, RNPR, rx_dma);
 		spi_writel(as, TNPR, tx_dma);
 
-		if (msg->spi->bits_per_word > 8)
+		if (xfer->bits_per_word > 8)
 			len >>= 1;
 		spi_writel(as, RNCR, len);
 		spi_writel(as, TNCR, len);
 
-		dev_dbg(&msg->spi->dev,
+		dev_dbg(&master->dev,
 			"  next xfer %p: len %u tx %p/%08llx rx %p/%08llx\n",
 			xfer, xfer->len, xfer->tx_buf,
 			(unsigned long long)xfer->tx_dma, xfer->rx_buf,
@@ -1277,12 +1276,28 @@ static int atmel_spi_setup(struct spi_device *spi)
 	return 0;
 }
 
+static void atmel_spi_set_cs(struct spi_device *spi, bool enable)
+{
+	struct atmel_spi *as = spi_master_get_devdata(spi->master);
+	/* the core doesn't really pass us enable/disable, but CS HIGH vs CS LOW
+	 * since we already have routines for activate/deactivate translate
+	 * high/low to active/inactive
+	 */
+	enable = (!!(spi->mode & SPI_CS_HIGH) == enable);
+
+	if (enable) {
+		cs_activate(as, spi);
+	} else {
+		cs_deactivate(as, spi);
+	}
+
+}
+
 static int atmel_spi_one_transfer(struct spi_master *master,
-					struct spi_message *msg,
+					struct spi_device *spi,
 					struct spi_transfer *xfer)
 {
 	struct atmel_spi	*as;
-	struct spi_device	*spi = msg->spi;
 	u8			bits;
 	u32			len;
 	struct atmel_spi_device	*asd;
@@ -1291,11 +1306,8 @@ static int atmel_spi_one_transfer(struct spi_master *master,
 	unsigned long		dma_timeout;
 
 	as = spi_master_get_devdata(master);
-
-	if (!(xfer->tx_buf || xfer->rx_buf) && xfer->len) {
-		dev_dbg(&spi->dev, "missing rx or tx buf\n");
-		return -EINVAL;
-	}
+	/* This lock was orignally taken in atmel_spi_trasfer_one_message */
+	atmel_spi_lock(as);
 
 	asd = spi->controller_state;
 	bits = (asd->csr >> 4) & 0xf;
@@ -1309,13 +1321,13 @@ static int atmel_spi_one_transfer(struct spi_master *master,
 	 * DMA map early, for performance (empties dcache ASAP) and
 	 * better fault reporting.
 	 */
-	if ((!msg->is_dma_mapped)
+	if ((!master->cur_msg_mapped)
 		&& as->use_pdc) {
 		if (atmel_spi_dma_map_xfer(as, xfer) < 0)
 			return -ENOMEM;
 	}
 
-	atmel_spi_set_xfer_speed(as, msg->spi, xfer);
+	atmel_spi_set_xfer_speed(as, spi, xfer);
 
 	as->done_status = 0;
 	as->current_transfer = xfer;
@@ -1324,7 +1336,7 @@ static int atmel_spi_one_transfer(struct spi_master *master,
 		reinit_completion(&as->xfer_completion);
 
 		if (as->use_pdc) {
-			atmel_spi_pdc_next_xfer(master, msg, xfer);
+			atmel_spi_pdc_next_xfer(master, xfer);
 		} else if (atmel_spi_use_dma(as, xfer)) {
 			len = as->current_remaining_bytes;
 			ret = atmel_spi_next_xfer_dma_submit(master,
@@ -1332,7 +1344,8 @@ static int atmel_spi_one_transfer(struct spi_master *master,
 			if (ret) {
 				dev_err(&spi->dev,
 					"unable to use DMA, fallback to PIO\n");
-				atmel_spi_next_xfer_pio(master, xfer);
+				as->done_status = ret;
+				break;
 			} else {
 				as->current_remaining_bytes -= len;
 				if (as->current_remaining_bytes < 0)
@@ -1385,90 +1398,18 @@ static int atmel_spi_one_transfer(struct spi_master *master,
 		} else if (atmel_spi_use_dma(as, xfer)) {
 			atmel_spi_stop_dma(master);
 		}
-
-		if (!msg->is_dma_mapped
-			&& as->use_pdc)
-			atmel_spi_dma_unmap_xfer(master, xfer);
-
-		return 0;
-
-	} else {
-		/* only update length if no error */
-		msg->actual_length += xfer->len;
 	}
 
-	if (!msg->is_dma_mapped
+	if (!master->cur_msg_mapped
 		&& as->use_pdc)
 		atmel_spi_dma_unmap_xfer(master, xfer);
 
-	spi_transfer_delay_exec(xfer);
-
-	if (xfer->cs_change) {
-		if (list_is_last(&xfer->transfer_list,
-				 &msg->transfers)) {
-			as->keep_cs = true;
-		} else {
-			cs_deactivate(as, msg->spi);
-			udelay(10);
-			cs_activate(as, msg->spi);
-		}
-	}
-
-	return 0;
-}
-
-static int atmel_spi_transfer_one_message(struct spi_master *master,
-						struct spi_message *msg)
-{
-	struct atmel_spi *as;
-	struct spi_transfer *xfer;
-	struct spi_device *spi = msg->spi;
-	int ret = 0;
-
-	as = spi_master_get_devdata(master);
-
-	dev_dbg(&spi->dev, "new message %p submitted for %s\n",
-					msg, dev_name(&spi->dev));
-
-	atmel_spi_lock(as);
-	cs_activate(as, spi);
-
-	as->keep_cs = false;
-
-	msg->status = 0;
-	msg->actual_length = 0;
-
-	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-		trace_spi_transfer_start(msg, xfer);
-
-		ret = atmel_spi_one_transfer(master, msg, xfer);
-		if (ret)
-			goto msg_done;
-
-		trace_spi_transfer_stop(msg, xfer);
-	}
-
 	if (as->use_pdc)
 		atmel_spi_disable_pdc_transfer(as);
 
-	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-		dev_dbg(&spi->dev,
-			"  xfer %p: len %u tx %p/%pad rx %p/%pad\n",
-			xfer, xfer->len,
-			xfer->tx_buf, &xfer->tx_dma,
-			xfer->rx_buf, &xfer->rx_dma);
-	}
-
-msg_done:
-	if (!as->keep_cs)
-		cs_deactivate(as, msg->spi);
-
 	atmel_spi_unlock(as);
 
-	msg->status = as->done_status;
-	spi_finalize_current_message(spi->master);
-
-	return ret;
+	return as->done_status;
 }
 
 static void atmel_spi_cleanup(struct spi_device *spi)
@@ -1558,7 +1499,8 @@ static int atmel_spi_probe(struct platform_device *pdev)
 	master->num_chipselect = 4;
 	master->setup = atmel_spi_setup;
 	master->flags = (SPI_MASTER_MUST_RX | SPI_MASTER_MUST_TX);
-	master->transfer_one_message = atmel_spi_transfer_one_message;
+	master->transfer_one = atmel_spi_one_transfer;
+	master->set_cs = atmel_spi_set_cs;
 	master->cleanup = atmel_spi_cleanup;
 	master->auto_runtime_pm = true;
 	master->max_dma_len = SPI_MAX_DMA_XFER;
-- 
2.43.0




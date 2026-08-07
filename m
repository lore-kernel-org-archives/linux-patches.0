Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4EA3876A0;
	Fri,  7 Aug 2026 14:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113872; cv=none; b=L4Cok6VbSXxB9o/2Rt8+ckO5mVeqwtlq5CcQvv0F2pzopMX1O8XQEolWvzW2PF9ipLCB6dupkTSWAMdxLBuWPs9ocwdWV8Tt2P2vYfHzz1YhsHoXtvReaVpex0Bei7lnbF9gnjrGoDZBlU8NpiphY1nTl/oyjhhDxFCRg9wEcWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113872; c=relaxed/simple;
	bh=PbaO06GWL0RfkXxQNOE8gdRZpAKopask85xATn5h6iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3jOAXNnTZA0Y0Vmwn4FUtouvSdBBh6+rcSfpafRPhUcJWk7jNr2gu5AssI2aiAvfZrKbCzHUctGy5us25vuG26kJB7qTMzPYxmbmpBZi7KfDmlP0rVjur5HpBux7a1dqwX5qsh4usX/o2vd+pN8MjWAPEVCqWOkEPxbnxJnA+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQ7wQD6j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQ7wQD6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3251F00AC4;
	Fri,  7 Aug 2026 14:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113857;
	bh=8EO0eFPqV7OPjvTDNAsVHrP2t+1pcLJ7q8gG5FIQums=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQ7wQD6jFtrKU7ll3+MDzAhVC7My1mXEuh2HVasPmGhEj4QoiEDKaqBNvfkQAaS+P
	 grmr1gEmcwOfeI4yBNsFG01NK3JJ+tFJNboG7wZAroezko5ePF9ucPviXn6YhrtHMi
	 kGtf1/WAPNitcfblK/tNWNiibF+vwPJpbo540oeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jun Guo <jun.guo@cixtech.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/337] spi: spi-cadence: supports transmission with bits_per_word of 16 and 32
Date: Fri,  7 Aug 2026 16:34:21 +0200
Message-ID: <20260807143419.770007704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jun Guo <jun.guo@cixtech.com>

[ Upstream commit 4e00135b2dd1d7924a58bffa551b6ceb3bd836f2 ]

The default FIFO data width of the Cadence SPI IP is 8 bits, but
the hardware supports configurations of 16 bits and 32 bits.
This patch enhances the driver to support communication with both
16-bits and 32-bits FIFO data widths.

Signed-off-by: Jun Guo <jun.guo@cixtech.com>
Link: https://patch.msgid.link/20251031073003.3289573-3-jun.guo@cixtech.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: d9eadfce2fac ("spi: spi-cadence: Move TX FIFO full busy-wait into FIFO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence.c | 106 +++++++++++++++++++++++++++++++++-----
 1 file changed, 93 insertions(+), 13 deletions(-)

diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index 914384348448d..fee908b7f327e 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -109,6 +109,7 @@
  * @rxbuf:		Pointer to the RX buffer
  * @tx_bytes:		Number of bytes left to transfer
  * @rx_bytes:		Number of bytes requested
+ * @n_bytes:		Number of bytes per word
  * @dev_busy:		Device busy flag
  * @is_decoded_cs:	Flag for decoder property set or not
  * @tx_fifo_depth:	Depth of the TX FIFO
@@ -120,16 +121,24 @@ struct cdns_spi {
 	struct clk *pclk;
 	unsigned int clk_rate;
 	u32 speed_hz;
-	const u8 *txbuf;
-	u8 *rxbuf;
+	const void *txbuf;
+	void *rxbuf;
 	int tx_bytes;
 	int rx_bytes;
+	u8 n_bytes;
 	u8 dev_busy;
 	u32 is_decoded_cs;
 	unsigned int tx_fifo_depth;
 	struct reset_control *rstc;
 };
 
+enum cdns_spi_frame_n_bytes {
+	CDNS_SPI_N_BYTES_NULL = 0,
+	CDNS_SPI_N_BYTES_U8 = 1,
+	CDNS_SPI_N_BYTES_U16 = 2,
+	CDNS_SPI_N_BYTES_U32 = 4
+};
+
 /* Macros for the SPI controller read/write */
 static inline u32 cdns_spi_read(struct cdns_spi *xspi, u32 offset)
 {
@@ -305,6 +314,78 @@ static int cdns_spi_setup_transfer(struct spi_device *spi,
 	return 0;
 }
 
+static u8 cdns_spi_n_bytes(struct spi_transfer *transfer)
+{
+	if (transfer->bits_per_word <= 8)
+		return CDNS_SPI_N_BYTES_U8;
+	else if (transfer->bits_per_word <= 16)
+		return CDNS_SPI_N_BYTES_U16;
+	else
+		return CDNS_SPI_N_BYTES_U32;
+}
+
+static inline void cdns_spi_reader(struct cdns_spi *xspi)
+{
+	u32 rxw = 0;
+
+	if (xspi->rxbuf && !IS_ALIGNED((uintptr_t)xspi->rxbuf, xspi->n_bytes)) {
+		pr_err("%s: rxbuf address is not aligned for %d bytes\n",
+		       __func__, xspi->n_bytes);
+		return;
+	}
+
+	rxw = cdns_spi_read(xspi, CDNS_SPI_RXD);
+	if (xspi->rxbuf) {
+		switch (xspi->n_bytes) {
+		case CDNS_SPI_N_BYTES_U8:
+			*(u8 *)xspi->rxbuf = rxw;
+			break;
+		case CDNS_SPI_N_BYTES_U16:
+			*(u16 *)xspi->rxbuf = rxw;
+			break;
+		case CDNS_SPI_N_BYTES_U32:
+			*(u32 *)xspi->rxbuf = rxw;
+			break;
+		default:
+			pr_err("%s invalid n_bytes %d\n", __func__,
+			       xspi->n_bytes);
+			return;
+		}
+		xspi->rxbuf = (u8 *)xspi->rxbuf + xspi->n_bytes;
+	}
+}
+
+static inline void cdns_spi_writer(struct cdns_spi *xspi)
+{
+	u32 txw = 0;
+
+	if (xspi->txbuf && !IS_ALIGNED((uintptr_t)xspi->txbuf, xspi->n_bytes)) {
+		pr_err("%s: txbuf address is not aligned for %d bytes\n",
+		       __func__, xspi->n_bytes);
+		return;
+	}
+
+	if (xspi->txbuf) {
+		switch (xspi->n_bytes) {
+		case CDNS_SPI_N_BYTES_U8:
+			txw = *(u8 *)xspi->txbuf;
+			break;
+		case CDNS_SPI_N_BYTES_U16:
+			txw = *(u16 *)xspi->txbuf;
+			break;
+		case CDNS_SPI_N_BYTES_U32:
+			txw = *(u32 *)xspi->txbuf;
+			break;
+		default:
+			pr_err("%s invalid n_bytes %d\n", __func__,
+			       xspi->n_bytes);
+			return;
+		}
+		cdns_spi_write(xspi, CDNS_SPI_TXD, txw);
+		xspi->txbuf = (u8 *)xspi->txbuf + xspi->n_bytes;
+	}
+}
+
 /**
  * cdns_spi_process_fifo - Fills the TX FIFO, and drain the RX FIFO
  * @xspi:	Pointer to the cdns_spi structure
@@ -321,23 +402,14 @@ static void cdns_spi_process_fifo(struct cdns_spi *xspi, int ntx, int nrx)
 
 	while (ntx || nrx) {
 		if (nrx) {
-			u8 data = cdns_spi_read(xspi, CDNS_SPI_RXD);
-
-			if (xspi->rxbuf)
-				*xspi->rxbuf++ = data;
-
+			cdns_spi_reader(xspi);
 			nrx--;
 		}
 
 		if (ntx) {
-			if (xspi->txbuf)
-				cdns_spi_write(xspi, CDNS_SPI_TXD, *xspi->txbuf++);
-			else
-				cdns_spi_write(xspi, CDNS_SPI_TXD, 0);
-
+			cdns_spi_writer(xspi);
 			ntx--;
 		}
-
 	}
 }
 
@@ -454,6 +526,10 @@ static int cdns_transfer_one(struct spi_controller *ctlr,
 	if (cdns_spi_read(xspi, CDNS_SPI_ISR) & CDNS_SPI_IXR_TXFULL)
 		udelay(10);
 
+	xspi->n_bytes = cdns_spi_n_bytes(transfer);
+	xspi->tx_bytes = DIV_ROUND_UP(xspi->tx_bytes, xspi->n_bytes);
+	xspi->rx_bytes = DIV_ROUND_UP(xspi->rx_bytes, xspi->n_bytes);
+
 	cdns_spi_process_fifo(xspi, xspi->tx_fifo_depth, 0);
 
 	cdns_spi_write(xspi, CDNS_SPI_IER, CDNS_SPI_IXR_DEFAULT);
@@ -654,6 +730,9 @@ static int cdns_spi_probe(struct platform_device *pdev)
 	ctlr->mode_bits = SPI_CPOL | SPI_CPHA;
 	ctlr->bits_per_word_mask = SPI_BPW_MASK(8);
 
+	if (of_device_is_compatible(pdev->dev.of_node, "cix,sky1-spi-r1p6"))
+		ctlr->bits_per_word_mask |= SPI_BPW_MASK(16) | SPI_BPW_MASK(32);
+
 	if (!spi_controller_is_target(ctlr)) {
 		ctlr->mode_bits |=  SPI_CS_HIGH;
 		ctlr->set_cs = cdns_spi_chipselect;
@@ -809,6 +888,7 @@ static const struct dev_pm_ops cdns_spi_dev_pm_ops = {
 
 static const struct of_device_id cdns_spi_of_match[] = {
 	{ .compatible = "xlnx,zynq-spi-r1p6" },
+	{ .compatible = "cix,sky1-spi-r1p6" },
 	{ .compatible = "cdns,spi-r1p6" },
 	{ /* end of table */ }
 };
-- 
2.53.0




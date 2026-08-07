Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0B438F626;
	Fri,  7 Aug 2026 14:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113874; cv=none; b=rk7xqJ6Izswpl2yfQSHfC0i4Hh/69ENSZZke7DCoqTVLzT6Ea3kz3vcXnc2gkqU1oFJVlVNOp/S41seVtS/eecjslSqWYA2NgrNwYueSVSfhqgvtGDgw0WMUyruc1lJA58Sl0nSAMsLEgYlVVq+M3n4xBNbVLpxF2zhs5kOveNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113874; c=relaxed/simple;
	bh=LsrpOLRqnUnOgH3OhrroG8cTHuABlpDB7SjqXw1oWzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OGKDqmntPPBv6m20bjAgiEhMyO4omGMXLDWqI3C6W2TKOPvXPJHvHevFZRM6YjmENxrR5qp2fV5BvYkCR0S0kYaCq2heJv2scFEu8K0QvGVI0mH5spa1a+f4d33lCBAMK3BSYsIKA4eVcxPF66Z0/3cYx2pUZOOIkBiQBqBpHq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDILcnDA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDILcnDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7860B1F00A3D;
	Fri,  7 Aug 2026 14:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113860;
	bh=799aolc3UL0MI7u7xUKxY0YWCThVmpoFRWZOYafUGgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tDILcnDATamubhVzbbNTO916afwjR/GKPY0Tul076Q/Z41W5Ub02Nrz3sVcwIDMfV
	 U3R92ckkO5wxzWvxKsoEg0erHTHvKc1b4dRsGSUu0V2OrJvZp6RSnlnZ+Oux859i6F
	 wSfBm6Qdsrg2RVVdOMQQfcblxQox/WIaVoZmwvwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srikanth Boyapally <srikanth.boyapally@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/337] spi: spi-cadence: Move TX FIFO full busy-wait into FIFO
Date: Fri,  7 Aug 2026 16:34:22 +0200
Message-ID: <20260807143419.791917288@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srikanth Boyapally <srikanth.boyapally@amd.com>

[ Upstream commit d9eadfce2fac49445db40808fe4d8259f20a9d2b ]

SPI host transfers could intermittently stall with spi_transfer timeouts.
The TXFULL condition was checked only once in cdns_transfer_one() before
cdns_spi_process_fifo(), so if the FIFO became full again during refill,
writes could be dropped and the transfer would never complete.

Move the TXFULL busy-wait into the TX path of cdns_spi_process_fifo() so
the 10µs back-off is applied per FIFO entry during filling, ensuring
forward progress and eliminating spurious timeouts.

Restrict the delay to host mode using spi_controller_is_target(), the
controller is passed into cdns_spi_process_fifo() so the check is made at
the point of use. In target mode this delay must not run as it causes the
target to miss its transfer window and corrupt data.

Fixes: 49530e641178 ("spi: cadence: Add usleep_range() for cdns_spi_fill_tx_fifo()")
Signed-off-by: Srikanth Boyapally <srikanth.boyapally@amd.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/20260720125510.60166-1-srikanth.boyapally@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index fee908b7f327e..015dce7fc9d81 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -388,11 +388,13 @@ static inline void cdns_spi_writer(struct cdns_spi *xspi)
 
 /**
  * cdns_spi_process_fifo - Fills the TX FIFO, and drain the RX FIFO
+ * @ctlr:	Pointer to the spi_controller structure
  * @xspi:	Pointer to the cdns_spi structure
  * @ntx:	Number of bytes to pack into the TX FIFO
  * @nrx:	Number of bytes to drain from the RX FIFO
  */
-static void cdns_spi_process_fifo(struct cdns_spi *xspi, int ntx, int nrx)
+static void cdns_spi_process_fifo(struct spi_controller *ctlr,
+				  struct cdns_spi *xspi, int ntx, int nrx)
 {
 	ntx = clamp(ntx, 0, xspi->tx_bytes);
 	nrx = clamp(nrx, 0, xspi->rx_bytes);
@@ -407,6 +409,16 @@ static void cdns_spi_process_fifo(struct cdns_spi *xspi, int ntx, int nrx)
 		}
 
 		if (ntx) {
+			/* When xspi in busy condition, bytes may send failed,
+			 * then spi control didn't work thoroughly, add one byte
+			 * delay. Only in host mode; in target mode this delay
+			 * causes data corruption as the target fails to prepare
+			 * data in time.
+			 */
+			if (!spi_controller_is_target(ctlr) &&
+			    (cdns_spi_read(xspi, CDNS_SPI_ISR) & CDNS_SPI_IXR_TXFULL))
+				udelay(10);
+
 			cdns_spi_writer(xspi);
 			ntx--;
 		}
@@ -460,14 +472,14 @@ static irqreturn_t cdns_spi_irq(int irq, void *dev_id)
 			cdns_spi_write(xspi, CDNS_SPI_THLD, 1);
 
 		if (xspi->tx_bytes) {
-			cdns_spi_process_fifo(xspi, trans_cnt, trans_cnt);
+			cdns_spi_process_fifo(ctlr, xspi, trans_cnt, trans_cnt);
 		} else {
 			/* Fixed delay due to controller limitation with
 			 * RX_NEMPTY incorrect status
 			 * Xilinx AR:65885 contains more details
 			 */
 			udelay(10);
-			cdns_spi_process_fifo(xspi, 0, trans_cnt);
+			cdns_spi_process_fifo(ctlr, xspi, 0, trans_cnt);
 			cdns_spi_write(xspi, CDNS_SPI_IDR,
 				       CDNS_SPI_IXR_DEFAULT);
 			spi_finalize_current_transfer(ctlr);
@@ -520,17 +532,11 @@ static int cdns_transfer_one(struct spi_controller *ctlr,
 			cdns_spi_write(xspi, CDNS_SPI_THLD, xspi->tx_fifo_depth >> 1);
 	}
 
-	/* When xspi in busy condition, bytes may send failed,
-	 * then spi control didn't work thoroughly, add one byte delay
-	 */
-	if (cdns_spi_read(xspi, CDNS_SPI_ISR) & CDNS_SPI_IXR_TXFULL)
-		udelay(10);
-
 	xspi->n_bytes = cdns_spi_n_bytes(transfer);
 	xspi->tx_bytes = DIV_ROUND_UP(xspi->tx_bytes, xspi->n_bytes);
 	xspi->rx_bytes = DIV_ROUND_UP(xspi->rx_bytes, xspi->n_bytes);
 
-	cdns_spi_process_fifo(xspi, xspi->tx_fifo_depth, 0);
+	cdns_spi_process_fifo(ctlr, xspi, xspi->tx_fifo_depth, 0);
 
 	cdns_spi_write(xspi, CDNS_SPI_IER, CDNS_SPI_IXR_DEFAULT);
 	return transfer->len;
-- 
2.53.0




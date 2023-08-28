Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4F011C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1083DC433C8;
	Mon, 28 Aug 2023 10:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217983;
	bh=h/pXnaQoBae982MUchWK4WuHKla4CHCPMjb+Eowuy/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBhUXBgJ2KFZFPSHwBahDzRPiAdx6o+w5K33LG0y3x2/t3ekNqDqKWXXY6oelVUcK
	 eduwbKkgZmqBwogNL2/3R+l3yRMkAuJgPVkSQwVbKtEXe23jIDGjnx+8XaRL5DlQxU
	 jFDFaOXcb1Gnu8aCyHl0/HMxgSBwLs/2WToYsuAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Goud <srinivas.goud@amd.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.4 053/129] spi: spi-cadence: Fix data corruption issues in slave mode
Date: Mon, 28 Aug 2023 12:12:12 +0200
Message-ID: <20230828101159.135174810@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Goud <srinivas.goud@amd.com>

commit 627d05a41ca1fbb9d390f9513af262f001f261f7 upstream.

Remove 10us delay in cdns_spi_process_fifo() (called from cdns_spi_irq())
to fix data corruption issue on Master side when this driver
configured in Slave mode, as Slave is failed to prepare the date
on time due to above delay.

Add 10us delay before processing the RX FIFO as TX empty doesn't
guarantee valid data in RX FIFO.

Signed-off-by: Srinivas Goud <srinivas.goud@amd.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Tested-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/1692610216-217644-1-git-send-email-srinivas.goud@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -316,12 +316,6 @@ static void cdns_spi_process_fifo(struct
 	xspi->rx_bytes -= nrx;
 
 	while (ntx || nrx) {
-		/* When xspi in busy condition, bytes may send failed,
-		 * then spi control did't work thoroughly, add one byte delay
-		 */
-		if (cdns_spi_read(xspi, CDNS_SPI_ISR) & CDNS_SPI_IXR_TXFULL)
-			udelay(10);
-
 		if (ntx) {
 			if (xspi->txbuf)
 				cdns_spi_write(xspi, CDNS_SPI_TXD, *xspi->txbuf++);
@@ -391,6 +385,11 @@ static irqreturn_t cdns_spi_irq(int irq,
 		if (xspi->tx_bytes) {
 			cdns_spi_process_fifo(xspi, trans_cnt, trans_cnt);
 		} else {
+			/* Fixed delay due to controller limitation with
+			 * RX_NEMPTY incorrect status
+			 * Xilinx AR:65885 contains more details
+			 */
+			udelay(10);
 			cdns_spi_process_fifo(xspi, 0, trans_cnt);
 			cdns_spi_write(xspi, CDNS_SPI_IDR,
 				       CDNS_SPI_IXR_DEFAULT);
@@ -438,12 +437,18 @@ static int cdns_transfer_one(struct spi_
 		cdns_spi_setup_transfer(spi, transfer);
 	} else {
 		/* Set TX empty threshold to half of FIFO depth
-		 * only if TX bytes are more than half FIFO depth.
+		 * only if TX bytes are more than FIFO depth.
 		 */
 		if (xspi->tx_bytes > xspi->tx_fifo_depth)
 			cdns_spi_write(xspi, CDNS_SPI_THLD, xspi->tx_fifo_depth >> 1);
 	}
 
+	/* When xspi in busy condition, bytes may send failed,
+	 * then spi control didn't work thoroughly, add one byte delay
+	 */
+	if (cdns_spi_read(xspi, CDNS_SPI_ISR) & CDNS_SPI_IXR_TXFULL)
+		udelay(10);
+
 	cdns_spi_process_fifo(xspi, xspi->tx_fifo_depth, 0);
 	spi_transfer_delay_exec(transfer);
 



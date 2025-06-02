Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6078E229B1E;
	Mon,  2 Jun 2025 14:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875810; cv=none; b=oIY3Lw/p18/hU1znWx7+GrUTTX4jdYezFF84Hk5aKc2SKSABmaAwH1lzxqSgLZWGEbQpKmtVYtFulm1uDVwLuWfr92ryAxQcKs1VvxBRKSlMtB2xBmJv1ibFwjoIrajjBMi0beGGb902iNU14myPR2L56xZYyMDSsViERrhmMMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875810; c=relaxed/simple;
	bh=dhCqnB+gDY3SVl2vkokWSoGYK2MwrUSFxcP+WuVS2tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7eIMkd8zepA+cbnVWFiL6LJjPJRwriZG+HLy4Kx9i+K5oD2h3xdPuufV2wNRd+PeVdxeQsTmXgD1SLAqkJ2b2iYEvlsYDH62OdSV4n7YSTG9mitCYL0fj1WxMRnnQ+P5AL/aSuU/JdyA5kGuTSZ20zpbALIrcezbtnB5khULhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFPB/BWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFPB/BWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74F7C4CEEB;
	Mon,  2 Jun 2025 14:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875809;
	bh=dhCqnB+gDY3SVl2vkokWSoGYK2MwrUSFxcP+WuVS2tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFPB/BWMxyVYUPc8ecXTSZXrs4a0xzwJty5Qy3lKux9YFm/ohXQtOLYn+taoWoVhF
	 yLNh/1lPNJ+Kr3gF1+hC20Fk9R/MokbVEtKDwif6BUyOb7PJAm9iyq8jWlz044V3lf
	 NZfBUHQ+DaSKyqOXQXO5T9YulrFdBk0UiYieDDmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bogdan-Gabriel Roman <bogdan-gabriel.roman@nxp.com>,
	Larisa Grigore <larisa.grigore@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 250/270] spi: spi-fsl-dspi: Halt the module after a new message transfer
Date: Mon,  2 Jun 2025 15:48:55 +0200
Message-ID: <20250602134317.549341824@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Bogdan-Gabriel Roman <bogdan-gabriel.roman@nxp.com>

[ Upstream commit 8a30a6d35a11ff5ccdede7d6740765685385a917 ]

The XSPI mode implementation in this driver still uses the EOQ flag to
signal the last word in a transmission and deassert the PCS signal.
However, at speeds lower than ~200kHZ, the PCS signal seems to remain
asserted even when SR[EOQF] = 1 indicates the end of a transmission.
This is a problem for target devices which require the deassertation of
the PCS signal between transfers.

Hence, this commit 'forces' the deassertation of the PCS by stopping the
module through MCR[HALT] after completing a new transfer. According to
the reference manual, the module stops or transitions from the Running
state to the Stopped state after the current frame, when any one of the
following conditions exist:
- The value of SR[EOQF] = 1.
- The chip is in Debug mode and the value of MCR[FRZ] = 1.
- The value of MCR[HALT] = 1.

This shouldn't be done if the last transfer in the message has cs_change
set.

Fixes: ea93ed4c181b ("spi: spi-fsl-dspi: Use EOQ for last word in buffer even for XSPI mode")
Signed-off-by: Bogdan-Gabriel Roman <bogdan-gabriel.roman@nxp.com>
Signed-off-by: Larisa Grigore <larisa.grigore@nxp.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Link: https://patch.msgid.link/20250522-james-nxp-spi-v2-2-bea884630cfb@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 7c26eef0570e7..fdfd104fde9e2 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -61,6 +61,7 @@
 #define SPI_SR_TFIWF			BIT(18)
 #define SPI_SR_RFDF			BIT(17)
 #define SPI_SR_CMDFFF			BIT(16)
+#define SPI_SR_TXRXS			BIT(30)
 #define SPI_SR_CLEAR			(SPI_SR_TCFQF | \
 					SPI_SR_TFUF | SPI_SR_TFFF | \
 					SPI_SR_CMDTCF | SPI_SR_SPEF | \
@@ -907,9 +908,20 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 	struct spi_device *spi = message->spi;
 	struct spi_transfer *transfer;
 	int status = 0;
+	u32 val = 0;
+	bool cs_change = false;
 
 	message->actual_length = 0;
 
+	/* Put DSPI in running mode if halted. */
+	regmap_read(dspi->regmap, SPI_MCR, &val);
+	if (val & SPI_MCR_HALT) {
+		regmap_update_bits(dspi->regmap, SPI_MCR, SPI_MCR_HALT, 0);
+		while (regmap_read(dspi->regmap, SPI_SR, &val) >= 0 &&
+		       !(val & SPI_SR_TXRXS))
+			;
+	}
+
 	list_for_each_entry(transfer, &message->transfers, transfer_list) {
 		dspi->cur_transfer = transfer;
 		dspi->cur_msg = message;
@@ -934,6 +946,7 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 				dspi->tx_cmd |= SPI_PUSHR_CMD_CONT;
 		}
 
+		cs_change = transfer->cs_change;
 		dspi->tx = transfer->tx_buf;
 		dspi->rx = transfer->rx_buf;
 		dspi->len = transfer->len;
@@ -966,6 +979,15 @@ static int dspi_transfer_one_message(struct spi_controller *ctlr,
 		spi_transfer_delay_exec(transfer);
 	}
 
+	if (status || !cs_change) {
+		/* Put DSPI in stop mode */
+		regmap_update_bits(dspi->regmap, SPI_MCR,
+				   SPI_MCR_HALT, SPI_MCR_HALT);
+		while (regmap_read(dspi->regmap, SPI_SR, &val) >= 0 &&
+		       val & SPI_SR_TXRXS)
+			;
+	}
+
 	message->status = status;
 	spi_finalize_current_message(ctlr);
 
@@ -1206,6 +1228,8 @@ static int dspi_init(struct fsl_dspi *dspi)
 	if (!spi_controller_is_slave(dspi->ctlr))
 		mcr |= SPI_MCR_MASTER;
 
+	mcr |= SPI_MCR_HALT;
+
 	regmap_write(dspi->regmap, SPI_MCR, mcr);
 	regmap_write(dspi->regmap, SPI_SR, SPI_SR_CLEAR);
 
-- 
2.39.5




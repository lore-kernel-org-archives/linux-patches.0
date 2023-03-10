Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843C6847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9F5C433D2;
	Fri, 10 Mar 2023 13:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456272;
	bh=N+HUng+xE/p296+jmkFRdadb5vaHhs3k+RX5H/kAlks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usEOgHwOxYtd2prrQKRMp0llXf2v4GTIXjMT8vSD35IUz+NWTcEHs2Ypgt4YEmYlc
	 /PjM1AlnovaFR+EBZx++eA7ueKd3EccOUfgr9IBA7WCYR3xTWhKlKnbz/0bz8aBQc6
	 H+bicP0cT0g6Ot9T2twI5cDw4yFiV7ca6eafgSEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Zhang <william.zhang@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 097/193] spi: bcm63xx-hsspi: Fix multi-bit mode setting
Date: Fri, 10 Mar 2023 14:37:59 +0100
Message-Id: <20230310133714.469678191@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: William Zhang <william.zhang@broadcom.com>

[ Upstream commit 811ff802aaf878ebbbaeac0307a0164fa21e7d40 ]

Currently the driver always sets the controller to dual data bit mode
for both tx and rx data in the profile mode control register even for
single data bit transfer. Luckily the opcode is set correctly according
to SPI transfer data bit width so it does not actually cause issues.

This change fixes the problem by setting tx and rx data bit mode field
correctly according to the actual SPI transfer tx and rx data bit width.

Fixes: 142168eba9dc ("spi: bcm63xx-hsspi: add bcm63xx HSSPI driver")
Signed-off-by: William Zhang <william.zhang@broadcom.com>
Link: https://lore.kernel.org/r/20230209200246.141520-11-william.zhang@broadcom.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx-hsspi.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index bc539010f2b98..6071756149ef4 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -160,6 +160,7 @@ static int bcm63xx_hsspi_do_txrx(struct spi_device *spi, struct spi_transfer *t)
 	int step_size = HSSPI_BUFFER_LEN;
 	const u8 *tx = t->tx_buf;
 	u8 *rx = t->rx_buf;
+	u32 val = 0;
 
 	bcm63xx_hsspi_set_clk(bs, spi, t->speed_hz);
 	bcm63xx_hsspi_set_cs(bs, spi->chip_select, true);
@@ -175,11 +176,16 @@ static int bcm63xx_hsspi_do_txrx(struct spi_device *spi, struct spi_transfer *t)
 		step_size -= HSSPI_OPCODE_LEN;
 
 	if ((opcode == HSSPI_OP_READ && t->rx_nbits == SPI_NBITS_DUAL) ||
-	    (opcode == HSSPI_OP_WRITE && t->tx_nbits == SPI_NBITS_DUAL))
+	    (opcode == HSSPI_OP_WRITE && t->tx_nbits == SPI_NBITS_DUAL)) {
 		opcode |= HSSPI_OP_MULTIBIT;
 
-	__raw_writel(1 << MODE_CTRL_MULTIDATA_WR_SIZE_SHIFT |
-		     1 << MODE_CTRL_MULTIDATA_RD_SIZE_SHIFT | 0xff,
+		if (t->rx_nbits == SPI_NBITS_DUAL)
+			val |= 1 << MODE_CTRL_MULTIDATA_RD_SIZE_SHIFT;
+		if (t->tx_nbits == SPI_NBITS_DUAL)
+			val |= 1 << MODE_CTRL_MULTIDATA_WR_SIZE_SHIFT;
+	}
+
+	__raw_writel(val | 0xff,
 		     bs->regs + HSSPI_PROFILE_MODE_CTRL_REG(chip_select));
 
 	while (pending > 0) {
-- 
2.39.2




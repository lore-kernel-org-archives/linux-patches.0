Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D182E2EFF;
	Tue, 15 Jul 2025 13:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586510; cv=none; b=FKEKu3BHk49mY30yIqQzssZsJH0WXThioUu7JJFBob0cSxmszvHSgrtm7MMiIya/rOzfNDZv8rbxVSO4rJsWsxqAd98en+HKbVh0y5xMfd+UDlAX62/nt+uuSL8gIlf/8y96YegB9EyOAwp4wFGOPUhR+ehUh6GY/E7B0dS2MJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586510; c=relaxed/simple;
	bh=b9KepwfolTcVZNsk9HbUbi84mDb/1ZQSyYtE0Qu2wGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCCA9qU4tlIS6ef2fXc565ml7q69jfSJp/4g6lyouaehxDIagLY/BYcMSKkI04Uay2knngLObrcQ80EG9iO68hsdBehRim3q9RYzzcpzhqJlfXH9ctD7cprzfR6yE9p5y1kH/+Gpu18wRiE0icCLvBz88jec5pn5OJ/UiXy+ITs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kR9Y6fqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kR9Y6fqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CB9C4CEE3;
	Tue, 15 Jul 2025 13:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586510;
	bh=b9KepwfolTcVZNsk9HbUbi84mDb/1ZQSyYtE0Qu2wGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kR9Y6fqCWGPkEDEcKrp3PwnbIqZZErvOgTOVIwRfGGyJvB5lP9V9BiU5go+66Snuv
	 CWAi0q7sL68FOPR+c8zMHj8Efvz2CVE9VkyHXxiWXzXPl5ER3HkHZLtWFbEKAWFjn/
	 pr+mvq4dFrSdZ2oJv3wDR/WTCwqct4S6Wvr9CgC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/148] spi: spi-fsl-dspi: Rename fifo_{read,write} and {tx,cmd}_fifo_write
Date: Tue, 15 Jul 2025 15:13:34 +0200
Message-ID: <20250715130803.997444990@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 547248fbed23f3cd2f6a5937b44fad60993640c4 ]

These function names are very generic and it is easy to get confused.
Rename them after the hardware register that they are accessing.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20200304220044.11193-6-olteanv@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: fa60c094c19b ("spi: spi-fsl-dspi: Clear completion counter before initiating transfer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-dspi.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 1d94fc89602f2..99d048acca29e 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -560,12 +560,12 @@ static void ns_delay_scale(char *psc, char *sc, int delay_ns,
 	}
 }
 
-static void fifo_write(struct fsl_dspi *dspi)
+static void dspi_pushr_write(struct fsl_dspi *dspi)
 {
 	regmap_write(dspi->regmap, SPI_PUSHR, dspi_pop_tx_pushr(dspi));
 }
 
-static void cmd_fifo_write(struct fsl_dspi *dspi)
+static void dspi_pushr_cmd_write(struct fsl_dspi *dspi)
 {
 	u16 cmd = dspi->tx_cmd;
 
@@ -574,7 +574,7 @@ static void cmd_fifo_write(struct fsl_dspi *dspi)
 	regmap_write(dspi->regmap_pushr, PUSHR_CMD, cmd);
 }
 
-static void tx_fifo_write(struct fsl_dspi *dspi, u16 txdata)
+static void dspi_pushr_txdata_write(struct fsl_dspi *dspi, u16 txdata)
 {
 	regmap_write(dspi->regmap_pushr, PUSHR_TX, txdata);
 }
@@ -590,18 +590,18 @@ static void dspi_tcfq_write(struct fsl_dspi *dspi)
 		 */
 		u32 data = dspi_pop_tx(dspi);
 
-		cmd_fifo_write(dspi);
-		tx_fifo_write(dspi, data & 0xFFFF);
-		tx_fifo_write(dspi, data >> 16);
+		dspi_pushr_cmd_write(dspi);
+		dspi_pushr_txdata_write(dspi, data & 0xFFFF);
+		dspi_pushr_txdata_write(dspi, data >> 16);
 	} else {
 		/* Write one entry to both TX FIFO and CMD FIFO
 		 * simultaneously.
 		 */
-		fifo_write(dspi);
+		dspi_pushr_write(dspi);
 	}
 }
 
-static u32 fifo_read(struct fsl_dspi *dspi)
+static u32 dspi_popr_read(struct fsl_dspi *dspi)
 {
 	u32 rxdata = 0;
 
@@ -611,7 +611,7 @@ static u32 fifo_read(struct fsl_dspi *dspi)
 
 static void dspi_tcfq_read(struct fsl_dspi *dspi)
 {
-	dspi_push_rx(dspi, fifo_read(dspi));
+	dspi_push_rx(dspi, dspi_popr_read(dspi));
 }
 
 static void dspi_eoq_write(struct fsl_dspi *dspi)
@@ -629,7 +629,7 @@ static void dspi_eoq_write(struct fsl_dspi *dspi)
 		if (fifo_size == (DSPI_FIFO_SIZE - 1))
 			dspi->tx_cmd |= SPI_PUSHR_CMD_CTCNT;
 		/* Write combined TX FIFO and CMD FIFO entry */
-		fifo_write(dspi);
+		dspi_pushr_write(dspi);
 	}
 }
 
@@ -639,7 +639,7 @@ static void dspi_eoq_read(struct fsl_dspi *dspi)
 
 	/* Read one FIFO entry and push to rx buffer */
 	while ((dspi->rx < dspi->rx_end) && fifo_size--)
-		dspi_push_rx(dspi, fifo_read(dspi));
+		dspi_push_rx(dspi, dspi_popr_read(dspi));
 }
 
 static int dspi_rxtx(struct fsl_dspi *dspi)
-- 
2.39.5




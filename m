Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACF285954;
	Mon,  8 Apr 2024 13:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583308; cv=none; b=fuG1VsIRE87JlyH4kZOilot0ivJW6qrtDsEhMcSuyMYPKmbX8+4yr26OhDD8BTe/D7LDUbkm2qSLC7FlWNkocjbTxdyNWxdfNPNFd9R/Yx/uYUL/1iG9WmNYN3B8B22jVTC8SgmqqvJsLOZxMk4iib+U+Bj2DoaCPe1iDRdYh8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583308; c=relaxed/simple;
	bh=76jSRDjt/gUpQCD1SP2SVdeI+vQetbnk/Rfu8KpmGFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItMZA4Q+WUCB7IYK8pufLwviuBfZPjsiNhIzfDiq9/ZPLnHJyX+GlFHhMv5celcRP8uGu3sbzznWEvx7BUn1uFjt8MIECZnmDiW4e6eRxsjLrnXpIlA00mvC7EngOzBQZU75ZHbqcksMFTj6dfZiOtBc5PAsEZqgeHm2xx2KzIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ls5OZfqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ls5OZfqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5BAAC433C7;
	Mon,  8 Apr 2024 13:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583308;
	bh=76jSRDjt/gUpQCD1SP2SVdeI+vQetbnk/Rfu8KpmGFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ls5OZfqtcT0WXE2j++B1u6Bm4iQ9EQxBkrIIysWr9olMxyzf6K8xwCmFVk9cpo/KH
	 5YQtvPPXaBYkZf3mpPmwBu/30HqwdDNZUopShGB3r4N5cWa5uGhe3xUaqUTVGJnQre
	 KIeXrqanZ0YpoMXlxeTQZXdGC5R0ixjL6gADMmu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/252] spi: s3c64xx: determine the fifo depth only once
Date: Mon,  8 Apr 2024 14:57:59 +0200
Message-ID: <20240408125312.244304572@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit c6e776ab6abdfce5a1edcde7a22c639e76499939 ]

Determine the FIFO depth only once, at probe time.
``sdd->fifo_depth`` can be set later on with the FIFO depth
specified in the device tree.

Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://msgid.link/r/20240216070555.2483977-5-tudor.ambarus@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: a3d3eab627bb ("spi: s3c64xx: Use DMA mode from fifo size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-s3c64xx.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 688b8fad9e2fd..e059fb9db1da1 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -189,6 +189,7 @@ struct s3c64xx_spi_port_config {
  * @tx_dma: Local transmit DMA data (e.g. chan and direction)
  * @port_conf: Local SPI port configuartion data
  * @port_id: Port identification number
+ * @fifo_depth: depth of the FIFO.
  * @rx_fifomask: SPI_STATUS.RX_FIFO_LVL mask. Shifted mask defining the field's
  *               length and position.
  * @tx_fifomask: SPI_STATUS.TX_FIFO_LVL mask. Shifted mask defining the field's
@@ -212,6 +213,7 @@ struct s3c64xx_spi_driver_data {
 	struct s3c64xx_spi_dma_data	tx_dma;
 	const struct s3c64xx_spi_port_config	*port_conf;
 	unsigned int			port_id;
+	unsigned int			fifo_depth;
 	u32				rx_fifomask;
 	u32				tx_fifomask;
 };
@@ -422,7 +424,7 @@ static bool s3c64xx_spi_can_dma(struct spi_controller *host,
 	struct s3c64xx_spi_driver_data *sdd = spi_controller_get_devdata(host);
 
 	if (sdd->rx_dma.ch && sdd->tx_dma.ch)
-		return xfer->len > FIFO_DEPTH(sdd);
+		return xfer->len > sdd->fifo_depth;
 
 	return false;
 }
@@ -509,7 +511,7 @@ static u32 s3c64xx_spi_wait_for_timeout(struct s3c64xx_spi_driver_data *sdd,
 	void __iomem *regs = sdd->regs;
 	unsigned long val = 1;
 	u32 status;
-	u32 max_fifo = FIFO_DEPTH(sdd);
+	u32 max_fifo = sdd->fifo_depth;
 
 	if (timeout_ms)
 		val = msecs_to_loops(timeout_ms);
@@ -616,7 +618,7 @@ static int s3c64xx_wait_for_pio(struct s3c64xx_spi_driver_data *sdd,
 	 * For any size less than the fifo size the below code is
 	 * executed atleast once.
 	 */
-	loops = xfer->len / FIFO_DEPTH(sdd);
+	loops = xfer->len / sdd->fifo_depth;
 	buf = xfer->rx_buf;
 	do {
 		/* wait for data to be received in the fifo */
@@ -753,7 +755,7 @@ static int s3c64xx_spi_transfer_one(struct spi_controller *host,
 				    struct spi_transfer *xfer)
 {
 	struct s3c64xx_spi_driver_data *sdd = spi_controller_get_devdata(host);
-	const unsigned int fifo_len = FIFO_DEPTH(sdd);
+	const unsigned int fifo_len = sdd->fifo_depth;
 	const void *tx_buf = NULL;
 	void *rx_buf = NULL;
 	int target_len = 0, origin_len = 0;
@@ -1220,6 +1222,8 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 		sdd->port_id = pdev->id;
 	}
 
+	sdd->fifo_depth = FIFO_DEPTH(sdd);
+
 	s3c64xx_spi_set_fifomask(sdd);
 
 	sdd->cur_bpw = 8;
@@ -1311,7 +1315,7 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "Samsung SoC SPI Driver loaded for Bus SPI-%d with %d Targets attached\n",
 					sdd->port_id, host->num_chipselect);
 	dev_dbg(&pdev->dev, "\tIOmem=[%pR]\tFIFO %dbytes\n",
-					mem_res, FIFO_DEPTH(sdd));
+		mem_res, sdd->fifo_depth);
 
 	pm_runtime_mark_last_busy(&pdev->dev);
 	pm_runtime_put_autosuspend(&pdev->dev);
-- 
2.43.0




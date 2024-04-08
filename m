Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2917C0B2;
	Mon,  8 Apr 2024 13:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583250; cv=none; b=e9yeGhc4mrDWYj/zTF3VFavLdqKQ11357GBt3c8hHZXcUiq8noStS7KrvZ6dZgC1MNMqgoi7zGWlwQbiwjp10EGjQUTJxdjZNBwFiHPEEUZKCUtmfKr/jxoHaPjVkJ+r4x2btTsFwJ+UBdDFy40lEmPxFZBpukNZxk2CLaTttuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583250; c=relaxed/simple;
	bh=Oo3MysJF7VW2QYafkBHl8sWwoOvgIYjMLAaZoPoX1DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YH7yYDyPpbdrcMuFzgM6jV1sOVB5+U/76xhOYkLYWqEGUFsinqJ3H5i9u7D52G7a/KDzL5MoQhR1Qy1Y/S14YaJrENskFTTSXGG8JsvxntoQezhwBa5GH1ksjtRXgYWt7UvAazVtUXabWqgUeAlkHU640qtut4+dZ6FOO6t694A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjQ3BN2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjQ3BN2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3B9C433F1;
	Mon,  8 Apr 2024 13:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583250;
	bh=Oo3MysJF7VW2QYafkBHl8sWwoOvgIYjMLAaZoPoX1DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjQ3BN2eC+/2OjHZ1ntt6ycahQegteRC6ExIuNHwOuQv5JtO1TADFZGipk65N6bfD
	 mxuuOg46J6LpJ8N7J4YjkKtqWaFek0Fmy/4BZsjgwo+ZdtpMkBP2i7xLvg7TV+Ta95
	 6HYk4naFQ12iJvq87Ftu2+kd1mPGwXwyzNCJ5whQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Protsenko <semen.protsenko@linaro.org>,
	Andi Shyti <andi.shyti@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/252] spi: s3c64xx: Extract FIFO depth calculation to a dedicated macro
Date: Mon,  8 Apr 2024 14:57:53 +0200
Message-ID: <20240408125312.057606572@linuxfoundation.org>
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

From: Sam Protsenko <semen.protsenko@linaro.org>

[ Upstream commit 460efee706c2b6a4daba62ec143fea29c2e7b358 ]

Simplify the code by extracting all cases of FIFO depth calculation into
a dedicated macro. No functional change.

Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://msgid.link/r/20240120170001.3356-1-semen.protsenko@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: a3d3eab627bb ("spi: s3c64xx: Use DMA mode from fifo size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-s3c64xx.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 0e48ffd499b9f..432ec60d35684 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -109,6 +109,7 @@
 #define TX_FIFO_LVL(v, i) (((v) >> 6) & FIFO_LVL_MASK(i))
 #define RX_FIFO_LVL(v, i) (((v) >> (i)->port_conf->rx_lvl_offset) & \
 					FIFO_LVL_MASK(i))
+#define FIFO_DEPTH(i) ((FIFO_LVL_MASK(i) >> 1) + 1)
 
 #define S3C64XX_SPI_MAX_TRAILCNT	0x3ff
 #define S3C64XX_SPI_TRAILCNT_OFF	19
@@ -406,7 +407,7 @@ static bool s3c64xx_spi_can_dma(struct spi_controller *host,
 	struct s3c64xx_spi_driver_data *sdd = spi_controller_get_devdata(host);
 
 	if (sdd->rx_dma.ch && sdd->tx_dma.ch) {
-		return xfer->len > (FIFO_LVL_MASK(sdd) >> 1) + 1;
+		return xfer->len > FIFO_DEPTH(sdd);
 	} else {
 		return false;
 	}
@@ -495,9 +496,7 @@ static u32 s3c64xx_spi_wait_for_timeout(struct s3c64xx_spi_driver_data *sdd,
 	void __iomem *regs = sdd->regs;
 	unsigned long val = 1;
 	u32 status;
-
-	/* max fifo depth available */
-	u32 max_fifo = (FIFO_LVL_MASK(sdd) >> 1) + 1;
+	u32 max_fifo = FIFO_DEPTH(sdd);
 
 	if (timeout_ms)
 		val = msecs_to_loops(timeout_ms);
@@ -604,7 +603,7 @@ static int s3c64xx_wait_for_pio(struct s3c64xx_spi_driver_data *sdd,
 	 * For any size less than the fifo size the below code is
 	 * executed atleast once.
 	 */
-	loops = xfer->len / ((FIFO_LVL_MASK(sdd) >> 1) + 1);
+	loops = xfer->len / FIFO_DEPTH(sdd);
 	buf = xfer->rx_buf;
 	do {
 		/* wait for data to be received in the fifo */
@@ -741,7 +740,7 @@ static int s3c64xx_spi_transfer_one(struct spi_controller *host,
 				    struct spi_transfer *xfer)
 {
 	struct s3c64xx_spi_driver_data *sdd = spi_controller_get_devdata(host);
-	const unsigned int fifo_len = (FIFO_LVL_MASK(sdd) >> 1) + 1;
+	const unsigned int fifo_len = FIFO_DEPTH(sdd);
 	const void *tx_buf = NULL;
 	void *rx_buf = NULL;
 	int target_len = 0, origin_len = 0;
@@ -1280,7 +1279,7 @@ static int s3c64xx_spi_probe(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "Samsung SoC SPI Driver loaded for Bus SPI-%d with %d Targets attached\n",
 					sdd->port_id, host->num_chipselect);
 	dev_dbg(&pdev->dev, "\tIOmem=[%pR]\tFIFO %dbytes\n",
-					mem_res, (FIFO_LVL_MASK(sdd) >> 1) + 1);
+					mem_res, FIFO_DEPTH(sdd));
 
 	pm_runtime_mark_last_busy(&pdev->dev);
 	pm_runtime_put_autosuspend(&pdev->dev);
-- 
2.43.0




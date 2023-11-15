Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEC03FE20
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LcCy4lht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BC8C433C7;
	Wed, 15 Nov 2023 19:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076335;
	bh=V+/hCRI+lo6vTILmgt4oUJIW4yMsmdTYJ90+iKKcQ7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LcCy4lhtXD7G0Xe0SAk2NHeqqTrtiqjvs/gVKceZ3cB3tw4g0EoC2qjSEQQKA4PvD
	 RVLn4LARUYmQB++cO6Y3soPqG5tWv7GO4u+B82EL6vbYwF4aXdMW48j6hdzsCFwo1b
	 C7MRvJNtbt9F46hC7mLYcntzGqBt8/Nmzz2XyeL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaishnav Achath <vaishnav.a@ti.com>,
	Dhruva Gole <d-gole@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 201/550] spi: omap2-mcspi: Fix hardcoded reference clock
Date: Wed, 15 Nov 2023 14:13:05 -0500
Message-ID: <20231115191614.710986117@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaishnav Achath <vaishnav.a@ti.com>

[ Upstream commit 2d9f4877988f64f0f336983de65c365b6a7debfb ]

A hardcoded reference clock of 48 MHz is used to calculate the
clock divisor values, but the reference clock frequency can be
different across devices and can be configured which can cause
a mismatch between the reported frequency and actual SPI clock
frequency observed. Fix this by fetching the clock rate from
the clock provider and falling back to hardcoded reference only
if the clock is not supplied.

Fixes: 2cd7d393f461 ("arm64: dts: ti: k3-am654: Add McSPI DT nodes")

Signed-off-by: Vaishnav Achath <vaishnav.a@ti.com>
Reviewed-by: Dhruva Gole <d-gole@ti.com>
Link: https://lore.kernel.org/r/20230926113812.30692-1-vaishnav.a@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 79888e6c54c25..ddf1c684bcc7d 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -125,10 +125,12 @@ struct omap2_mcspi {
 	struct omap2_mcspi_dma	*dma_channels;
 	struct device		*dev;
 	struct omap2_mcspi_regs ctx;
+	struct clk		*ref_clk;
 	int			fifo_depth;
 	bool			target_aborted;
 	unsigned int		pin_dir:1;
 	size_t			max_xfer_len;
+	u32			ref_clk_hz;
 };
 
 struct omap2_mcspi_cs {
@@ -880,12 +882,12 @@ omap2_mcspi_txrx_pio(struct spi_device *spi, struct spi_transfer *xfer)
 	return count - c;
 }
 
-static u32 omap2_mcspi_calc_divisor(u32 speed_hz)
+static u32 omap2_mcspi_calc_divisor(u32 speed_hz, u32 ref_clk_hz)
 {
 	u32 div;
 
 	for (div = 0; div < 15; div++)
-		if (speed_hz >= (OMAP2_MCSPI_MAX_FREQ >> div))
+		if (speed_hz >= (ref_clk_hz >> div))
 			return div;
 
 	return 15;
@@ -897,7 +899,7 @@ static int omap2_mcspi_setup_transfer(struct spi_device *spi,
 {
 	struct omap2_mcspi_cs *cs = spi->controller_state;
 	struct omap2_mcspi *mcspi;
-	u32 l = 0, clkd = 0, div, extclk = 0, clkg = 0;
+	u32 ref_clk_hz, l = 0, clkd = 0, div, extclk = 0, clkg = 0;
 	u8 word_len = spi->bits_per_word;
 	u32 speed_hz = spi->max_speed_hz;
 
@@ -911,14 +913,15 @@ static int omap2_mcspi_setup_transfer(struct spi_device *spi,
 	if (t && t->speed_hz)
 		speed_hz = t->speed_hz;
 
-	speed_hz = min_t(u32, speed_hz, OMAP2_MCSPI_MAX_FREQ);
-	if (speed_hz < (OMAP2_MCSPI_MAX_FREQ / OMAP2_MCSPI_MAX_DIVIDER)) {
-		clkd = omap2_mcspi_calc_divisor(speed_hz);
-		speed_hz = OMAP2_MCSPI_MAX_FREQ >> clkd;
+	ref_clk_hz = mcspi->ref_clk_hz;
+	speed_hz = min_t(u32, speed_hz, ref_clk_hz);
+	if (speed_hz < (ref_clk_hz / OMAP2_MCSPI_MAX_DIVIDER)) {
+		clkd = omap2_mcspi_calc_divisor(speed_hz, ref_clk_hz);
+		speed_hz = ref_clk_hz >> clkd;
 		clkg = 0;
 	} else {
-		div = (OMAP2_MCSPI_MAX_FREQ + speed_hz - 1) / speed_hz;
-		speed_hz = OMAP2_MCSPI_MAX_FREQ / div;
+		div = (ref_clk_hz + speed_hz - 1) / speed_hz;
+		speed_hz = ref_clk_hz / div;
 		clkd = (div - 1) & 0xf;
 		extclk = (div - 1) >> 4;
 		clkg = OMAP2_MCSPI_CHCONF_CLKG;
@@ -1448,8 +1451,6 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 	ctlr->cleanup = omap2_mcspi_cleanup;
 	ctlr->target_abort = omap2_mcspi_target_abort;
 	ctlr->dev.of_node = node;
-	ctlr->max_speed_hz = OMAP2_MCSPI_MAX_FREQ;
-	ctlr->min_speed_hz = OMAP2_MCSPI_MAX_FREQ >> 15;
 	ctlr->use_gpio_descriptors = true;
 
 	platform_set_drvdata(pdev, ctlr);
@@ -1519,6 +1520,14 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 		goto free_ctlr;
 	}
 
+	mcspi->ref_clk = devm_clk_get_optional_enabled(&pdev->dev, NULL);
+	if (mcspi->ref_clk)
+		mcspi->ref_clk_hz = clk_get_rate(mcspi->ref_clk);
+	else
+		mcspi->ref_clk_hz = OMAP2_MCSPI_MAX_FREQ;
+	ctlr->max_speed_hz = mcspi->ref_clk_hz;
+	ctlr->min_speed_hz = mcspi->ref_clk_hz >> 15;
+
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, SPI_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_enable(&pdev->dev);
-- 
2.42.0




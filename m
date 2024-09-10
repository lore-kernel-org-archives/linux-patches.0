Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EAB218C025;
	Tue, 10 Sep 2024 10:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964464; cv=none; b=oUmJCS6avClPpDSNvimSE0ZsGTJboYhMj+G6Jd0GHno2ofrjYz8TWppN07Wtt9trr7+c4yjaZpS0e4B6i0xau3rzxdDqcW95upjGl7mqsn5ZrZTgJKPapbWN3mkFekDZe1bG+wHHxSjtdiTY7mGDJilyRgnHk1AL0UyN6dwuA9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964464; c=relaxed/simple;
	bh=Mt2jpgOre4scmoo5pwiXfbhryrHTL1rAM/RMw0hPWsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ys2f5SibByyqVd/3ID3GUbkKgCxZYD6bgO4NDQm5kkJfBGO1TnptXdR6M1KawYGc3cKkJ2ZVYLQOE0KZDQfWI2t8bWtFaVn1rR18+6XICeZLfvP97gkrt1Kj2/IpszMLgZP7W0vJSQHCaWwHy8u+WItJGYfs0GhFxOH4YrTUI2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLnlEtVS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLnlEtVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1A2C4CEC3;
	Tue, 10 Sep 2024 10:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964463;
	bh=Mt2jpgOre4scmoo5pwiXfbhryrHTL1rAM/RMw0hPWsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLnlEtVSjzQsYi1FTuqVpx+9sNsw19oUx41Ll6RsyCW1M4EcKNlpDV8V5y6Cl9UUK
	 yYk8u9UnnfNo9AUWyj9DEO0Aieo1oKOAC6HCAezPJuMq4fKMqfjIZx+wfW/+7WBc3+
	 9NcJ2gh/coJ2lEUrcYZ7ROXEA//mgCMfGo9sTyXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/269] spi: spi-fsl-lpspi: limit PRESCALE bit in TCR register
Date: Tue, 10 Sep 2024 11:32:59 +0200
Message-ID: <20240910092614.958572204@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Carlos Song <carlos.song@nxp.com>

[ Upstream commit 783bf5d09f86b9736605f3e01a3472e55ef98ff8 ]

Referring to the errata ERR051608 of I.MX93, LPSPI TCR[PRESCALE]
can only be configured to be 0 or 1, other values are not valid
and will cause LPSPI to not work.

Add the prescale limitation for LPSPI in I.MX93. Other platforms
are not affected.

Signed-off-by: Carlos Song <carlos.song@nxp.com>
Link: https://patch.msgid.link/20240820070658.672127-1-carlos.song@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 3c0f7dc9614d..f02b2f741681 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -82,6 +82,10 @@
 #define TCR_RXMSK	BIT(19)
 #define TCR_TXMSK	BIT(18)
 
+struct fsl_lpspi_devtype_data {
+	u8 prescale_max;
+};
+
 struct lpspi_config {
 	u8 bpw;
 	u8 chip_select;
@@ -119,10 +123,25 @@ struct fsl_lpspi_data {
 	bool usedma;
 	struct completion dma_rx_completion;
 	struct completion dma_tx_completion;
+
+	const struct fsl_lpspi_devtype_data *devtype_data;
+};
+
+/*
+ * ERR051608 fixed or not:
+ * https://www.nxp.com/docs/en/errata/i.MX93_1P87f.pdf
+ */
+static struct fsl_lpspi_devtype_data imx93_lpspi_devtype_data = {
+	.prescale_max = 1,
+};
+
+static struct fsl_lpspi_devtype_data imx7ulp_lpspi_devtype_data = {
+	.prescale_max = 8,
 };
 
 static const struct of_device_id fsl_lpspi_dt_ids[] = {
-	{ .compatible = "fsl,imx7ulp-spi", },
+	{ .compatible = "fsl,imx7ulp-spi", .data = &imx7ulp_lpspi_devtype_data,},
+	{ .compatible = "fsl,imx93-spi", .data = &imx93_lpspi_devtype_data,},
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, fsl_lpspi_dt_ids);
@@ -297,9 +316,11 @@ static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
 {
 	struct lpspi_config config = fsl_lpspi->config;
 	unsigned int perclk_rate, scldiv, div;
+	u8 prescale_max;
 	u8 prescale;
 
 	perclk_rate = clk_get_rate(fsl_lpspi->clk_per);
+	prescale_max = fsl_lpspi->devtype_data->prescale_max;
 
 	if (!config.speed_hz) {
 		dev_err(fsl_lpspi->dev,
@@ -315,7 +336,7 @@ static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
 
 	div = DIV_ROUND_UP(perclk_rate, config.speed_hz);
 
-	for (prescale = 0; prescale < 8; prescale++) {
+	for (prescale = 0; prescale < prescale_max; prescale++) {
 		scldiv = div / (1 << prescale) - 2;
 		if (scldiv < 256) {
 			fsl_lpspi->config.prescale = prescale;
@@ -822,6 +843,7 @@ static int fsl_lpspi_init_rpm(struct fsl_lpspi_data *fsl_lpspi)
 
 static int fsl_lpspi_probe(struct platform_device *pdev)
 {
+	const struct fsl_lpspi_devtype_data *devtype_data;
 	struct fsl_lpspi_data *fsl_lpspi;
 	struct spi_controller *controller;
 	struct resource *res;
@@ -830,6 +852,10 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 	u32 temp;
 	bool is_target;
 
+	devtype_data = of_device_get_match_data(&pdev->dev);
+	if (!devtype_data)
+		return -ENODEV;
+
 	is_target = of_property_read_bool((&pdev->dev)->of_node, "spi-slave");
 	if (is_target)
 		controller = devm_spi_alloc_target(&pdev->dev,
@@ -848,6 +874,7 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 	fsl_lpspi->is_target = is_target;
 	fsl_lpspi->is_only_cs1 = of_property_read_bool((&pdev->dev)->of_node,
 						"fsl,spi-only-use-cs1-sel");
+	fsl_lpspi->devtype_data = devtype_data;
 
 	init_completion(&fsl_lpspi->xfer_done);
 
-- 
2.43.0




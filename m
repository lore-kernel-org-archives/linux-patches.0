Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D1B335BCD;
	Fri,  9 Jan 2026 12:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962288; cv=none; b=fMN9/Ay0aT3CgdHdNODNycNuw26jZnKEKAH1uIAZRZ0BiRyq/ld/HiHFmjhqBTXYORNT9N80rQ45lAU2RkJpv0hudxd4kSaSifb9BHenxr6T91FcLEUGJ6/m/KiTv35bPO96VA/X4ZPY50pmxG/C2hb7Pq/B/PpV+UZXvdUmYis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962288; c=relaxed/simple;
	bh=47kEer+qvm2o+N771P7A5DOoYnEUXoyHsYWNappaaDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXFnhhrIuDRog7Oot4S16XgRc7IwK5wooDAtDYTxaZBVAs05AVrwd+VAC+Q28VrGwiOczvAXTVvk/5xk6Yrkfhnwfw03z96bGLjvNCq708C/PC0NLQ5IJcdSRjg//etSWL/ptjk4LNFYVT9fh+jdfVeu2t7j5Id1ja5owJALOqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZjKHuGs1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZjKHuGs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F12BC4CEF1;
	Fri,  9 Jan 2026 12:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962287;
	bh=47kEer+qvm2o+N771P7A5DOoYnEUXoyHsYWNappaaDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZjKHuGs1PXh8z3bkf7LzgfbT2e4676I0txcFOqrnw0LcrtnQ9xYygnCKQQKhwaWGe
	 tqXo9RpDraurKlwZW+YgfQJzJ+nQV2ds6GrPY1i7McDKZhtsUZLy3Qny6fHwSPOedn
	 FGPgRBqCCUEpRgNYNJ4n/XZoyCnqYy/HMHF20Fu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Qiu <william.qiu@starfivetech.com>,
	Hal Feng <hal.feng@starfivetech.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 279/634] spi: cadence-quadspi: Add clock configuration for StarFive JH7110 QSPI
Date: Fri,  9 Jan 2026 12:39:17 +0100
Message-ID: <20260109112128.032410556@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Qiu <william.qiu@starfivetech.com>

[ Upstream commit 33f1ef6d4eb6bca726608ed939c9fd94d96ceefd ]

Add JH7110's clock initialization code to the driver.

Signed-off-by: William Qiu <william.qiu@starfivetech.com>
Reviewed-by: Hal Feng <hal.feng@starfivetech.com>
Link: https://lore.kernel.org/r/20230804020254.291239-3-william.qiu@starfivetech.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 1889dd208197 ("spi: cadence-quadspi: Fix clock disable on probe failure path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 67 +++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index ca393f3fcd90..af0ec2a8c647 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -47,6 +47,12 @@
 
 #define CQSPI_OP_WIDTH(part) ((part).nbytes ? ilog2((part).buswidth) : 0)
 
+enum {
+	CLK_QSPI_APB = 0,
+	CLK_QSPI_AHB,
+	CLK_QSPI_NUM,
+};
+
 struct cqspi_st;
 
 struct cqspi_flash_pdata {
@@ -64,6 +70,7 @@ struct cqspi_st {
 	struct platform_device	*pdev;
 	struct spi_master	*master;
 	struct clk		*clk;
+	struct clk		*clks[CLK_QSPI_NUM];
 	unsigned int		sclk;
 
 	void __iomem		*iobase;
@@ -91,6 +98,8 @@ struct cqspi_st {
 	bool			wr_completion;
 	bool			slow_sram;
 	bool			apb_ahb_hazard;
+
+	bool			is_jh7110; /* Flag for StarFive JH7110 SoC */
 };
 
 struct cqspi_driver_platdata {
@@ -99,6 +108,8 @@ struct cqspi_driver_platdata {
 	int (*indirect_read_dma)(struct cqspi_flash_pdata *f_pdata,
 				 u_char *rxbuf, loff_t from_addr, size_t n_rx);
 	u32 (*get_dma_status)(struct cqspi_st *cqspi);
+	int (*jh7110_clk_init)(struct platform_device *pdev,
+			       struct cqspi_st *cqspi);
 };
 
 /* Operation timeout value */
@@ -1592,6 +1603,51 @@ static int cqspi_setup_flash(struct cqspi_st *cqspi)
 	return 0;
 }
 
+static int cqspi_jh7110_clk_init(struct platform_device *pdev, struct cqspi_st *cqspi)
+{
+	static struct clk_bulk_data qspiclk[] = {
+		{ .id = "apb" },
+		{ .id = "ahb" },
+	};
+
+	int ret = 0;
+
+	ret = devm_clk_bulk_get(&pdev->dev, ARRAY_SIZE(qspiclk), qspiclk);
+	if (ret) {
+		dev_err(&pdev->dev, "%s: failed to get qspi clocks\n", __func__);
+		return ret;
+	}
+
+	cqspi->clks[CLK_QSPI_APB] = qspiclk[0].clk;
+	cqspi->clks[CLK_QSPI_AHB] = qspiclk[1].clk;
+
+	ret = clk_prepare_enable(cqspi->clks[CLK_QSPI_APB]);
+	if (ret) {
+		dev_err(&pdev->dev, "%s: failed to enable CLK_QSPI_APB\n", __func__);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(cqspi->clks[CLK_QSPI_AHB]);
+	if (ret) {
+		dev_err(&pdev->dev, "%s: failed to enable CLK_QSPI_AHB\n", __func__);
+		goto disable_apb_clk;
+	}
+
+	cqspi->is_jh7110 = true;
+
+	return 0;
+
+disable_apb_clk:
+	clk_disable_unprepare(cqspi->clks[CLK_QSPI_APB]);
+
+	return ret;
+}
+
+static void cqspi_jh7110_disable_clk(struct platform_device *pdev, struct cqspi_st *cqspi)
+{
+	clk_disable_unprepare(cqspi->clks[CLK_QSPI_AHB]);
+	clk_disable_unprepare(cqspi->clks[CLK_QSPI_APB]);
+}
 static int cqspi_probe(struct platform_device *pdev)
 {
 	const struct cqspi_driver_platdata *ddata;
@@ -1618,6 +1674,7 @@ static int cqspi_probe(struct platform_device *pdev)
 
 	cqspi->pdev = pdev;
 	cqspi->master = master;
+	cqspi->is_jh7110 = false;
 	platform_set_drvdata(pdev, cqspi);
 
 	/* Obtain configuration from OF. */
@@ -1729,6 +1786,12 @@ static int cqspi_probe(struct platform_device *pdev)
 		if (ddata->quirks & CQSPI_NEEDS_APB_AHB_HAZARD_WAR)
 			cqspi->apb_ahb_hazard = true;
 
+		if (ddata->jh7110_clk_init) {
+			ret = cqspi_jh7110_clk_init(pdev, cqspi);
+			if (ret)
+				goto probe_clk_failed;
+		}
+
 		if (of_device_is_compatible(pdev->dev.of_node,
 					    "xlnx,versal-ospi-1.0")) {
 			ret = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
@@ -1793,6 +1856,9 @@ static int cqspi_remove(struct platform_device *pdev)
 
 	clk_disable_unprepare(cqspi->clk);
 
+	if (cqspi->is_jh7110)
+		cqspi_jh7110_disable_clk(pdev, cqspi);
+
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
@@ -1860,6 +1926,7 @@ static const struct cqspi_driver_platdata versal_ospi = {
 
 static const struct cqspi_driver_platdata jh7110_qspi = {
 	.quirks = CQSPI_DISABLE_DAC_MODE,
+	.jh7110_clk_init = cqspi_jh7110_clk_init,
 };
 
 static const struct cqspi_driver_platdata pensando_cdns_qspi = {
-- 
2.51.0




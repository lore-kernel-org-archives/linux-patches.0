Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE2F39734B;
	Fri, 15 May 2026 16:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862248; cv=none; b=WnX9wmlhZn3OPtza/tkItnLWj3a79J4ROyeqoqr3Jg2s3vlgWPbkTro70YbzOQo77QsP1TLmZ/48mIcw8Bd/eE73RaRFc93Tb5c210RoZ+fOhNuKsuEl6jtpPPKWZjH/xTGDiulw3wSx7blXKx6+b1xVd0chpLAmReCcfHYLdLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862248; c=relaxed/simple;
	bh=em3bfIIQG+CavKve+4cmMFfqUmYRNHNCOEzWUb5s1mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oq+nvQ+tm/LoqJgH4woAyoOfE5Lzu9HupybE098ksZHHqlHKX6hkCHATCE05437tDxCuRYYO+3Sj0YZk+ppU1QEf/VxR7u1+D+wyGe1CToK6dJ+yo+L4AGAlXpe+hs75bMXun81Hw4cwJvOhi8mvc2zZsV/e6+dy2wSou+/whOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hzMBcGaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hzMBcGaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47E2C2BCB0;
	Fri, 15 May 2026 16:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862248;
	bh=em3bfIIQG+CavKve+4cmMFfqUmYRNHNCOEzWUb5s1mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzMBcGaYvvGQE7vk5+mvehDI6MgMRdohTVtDlq/vPl1jL3U8ZTDbsayAVVH+7/7Ez
	 8jRe/wWxlGGeW/YbqbjUCWZifmLxLX3oZDWgqqdokCvrTO7M1/bbc3qQQ5DedwU+Z1
	 k6Rd0EioaH6iSZPdDxpf8wIyUNPAOHpjcCoyr5gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 166/188] spi: zynq-qspi: Simplify clock handling with devm_clk_get_enabled()
Date: Fri, 15 May 2026 17:49:43 +0200
Message-ID: <20260515154700.934014109@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 1f8fd9490e3184e9a2394df2e682901a1d57ce71 ]

Replace devm_clk_get() followed by clk_prepare_enable() with
devm_clk_get_enabled() for both "pclk" and "ref_clk". This removes
the need for explicit clock enable and disable calls, as the managed
API automatically disables the clocks on device removal or probe
failure.

Remove the now-unnecessary clk_disable_unprepare() calls from the
probe error paths and the remove callback. Simplify error handling
by jumping directly to the remove_ctlr label.

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/24043625f89376da36feca2408f990a85be7ab36.1775555500.git.xiaopei01@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: c9c012706c9f ("spi: zynq-qspi: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-zynq-qspi.c |   42 ++++++------------------------------------
 1 file changed, 6 insertions(+), 36 deletions(-)

--- a/drivers/spi/spi-zynq-qspi.c
+++ b/drivers/spi/spi-zynq-qspi.c
@@ -381,21 +381,10 @@ static int zynq_qspi_setup_op(struct spi
 {
 	struct spi_controller *ctlr = spi->controller;
 	struct zynq_qspi *qspi = spi_controller_get_devdata(ctlr);
-	int ret;
 
 	if (ctlr->busy)
 		return -EBUSY;
 
-	ret = clk_enable(qspi->refclk);
-	if (ret)
-		return ret;
-
-	ret = clk_enable(qspi->pclk);
-	if (ret) {
-		clk_disable(qspi->refclk);
-		return ret;
-	}
-
 	zynq_qspi_write(qspi, ZYNQ_QSPI_ENABLE_OFFSET,
 			ZYNQ_QSPI_ENABLE_ENABLE_MASK);
 
@@ -661,7 +650,7 @@ static int zynq_qspi_probe(struct platfo
 		goto remove_ctlr;
 	}
 
-	xqspi->pclk = devm_clk_get(&pdev->dev, "pclk");
+	xqspi->pclk = devm_clk_get_enabled(&pdev->dev, "pclk");
 	if (IS_ERR(xqspi->pclk)) {
 		dev_err(&pdev->dev, "pclk clock not found.\n");
 		ret = PTR_ERR(xqspi->pclk);
@@ -670,36 +659,24 @@ static int zynq_qspi_probe(struct platfo
 
 	init_completion(&xqspi->data_completion);
 
-	xqspi->refclk = devm_clk_get(&pdev->dev, "ref_clk");
+	xqspi->refclk = devm_clk_get_enabled(&pdev->dev, "ref_clk");
 	if (IS_ERR(xqspi->refclk)) {
 		dev_err(&pdev->dev, "ref_clk clock not found.\n");
 		ret = PTR_ERR(xqspi->refclk);
 		goto remove_ctlr;
 	}
 
-	ret = clk_prepare_enable(xqspi->pclk);
-	if (ret) {
-		dev_err(&pdev->dev, "Unable to enable APB clock.\n");
-		goto remove_ctlr;
-	}
-
-	ret = clk_prepare_enable(xqspi->refclk);
-	if (ret) {
-		dev_err(&pdev->dev, "Unable to enable device clock.\n");
-		goto clk_dis_pclk;
-	}
-
 	xqspi->irq = platform_get_irq(pdev, 0);
 	if (xqspi->irq < 0) {
 		ret = xqspi->irq;
-		goto clk_dis_all;
+		goto remove_ctlr;
 	}
 	ret = devm_request_irq(&pdev->dev, xqspi->irq, zynq_qspi_irq,
 			       0, pdev->name, xqspi);
 	if (ret != 0) {
 		ret = -ENXIO;
 		dev_err(&pdev->dev, "request_irq failed\n");
-		goto clk_dis_all;
+		goto remove_ctlr;
 	}
 
 	ret = of_property_read_u32(np, "num-cs",
@@ -709,7 +686,7 @@ static int zynq_qspi_probe(struct platfo
 	} else if (num_cs > ZYNQ_QSPI_MAX_NUM_CS) {
 		ret = -EINVAL;
 		dev_err(&pdev->dev, "only 2 chip selects are available\n");
-		goto clk_dis_all;
+		goto remove_ctlr;
 	} else {
 		ctlr->num_chipselect = num_cs;
 	}
@@ -728,15 +705,11 @@ static int zynq_qspi_probe(struct platfo
 	ret = devm_spi_register_controller(&pdev->dev, ctlr);
 	if (ret) {
 		dev_err(&pdev->dev, "devm_spi_register_controller failed\n");
-		goto clk_dis_all;
+		goto remove_ctlr;
 	}
 
 	return ret;
 
-clk_dis_all:
-	clk_disable_unprepare(xqspi->refclk);
-clk_dis_pclk:
-	clk_disable_unprepare(xqspi->pclk);
 remove_ctlr:
 	spi_controller_put(ctlr);
 
@@ -758,9 +731,6 @@ static void zynq_qspi_remove(struct plat
 	struct zynq_qspi *xqspi = platform_get_drvdata(pdev);
 
 	zynq_qspi_write(xqspi, ZYNQ_QSPI_ENABLE_OFFSET, 0);
-
-	clk_disable_unprepare(xqspi->refclk);
-	clk_disable_unprepare(xqspi->pclk);
 }
 
 static const struct of_device_id zynq_qspi_of_match[] = {



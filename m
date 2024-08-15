Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396061714AE;
	Thu, 15 Aug 2024 13:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728968; cv=none; b=JrypX6IygyeUjdmeThh7vulZYZWSqn+1j+WD52xdd+ThBTbZHh3QXhzqZzZ4n6K/QW38VXEFvSnL3F2Tti/ANApW6bkkhb6yT4PRxqBIUjfEEviU6qWJYFWi17CSx3srQS5Q2K3WCH/FWV6sgBoDQd8D4HDzrOrKISjfbq0fW74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728968; c=relaxed/simple;
	bh=peL+1Q3k3Z9ALCP9dbk9D8354m9IoWWFqybpPPu0vVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPKvCdrgp4olF6tKFEqdUV4xcm/RqmzxbW0nL6GE2Q87PWOI+6MGcQusal0jsE+fdTJe+3gOCddijXzF3MXgSwqDZdlfcR7yMm+/qOmCpGNHJX4xR02sLQwESlRbx+XhMgpkyWYXnEovsGz/n2Hda6vvHKLVMSrNg022ogZI044=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REhsQYSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REhsQYSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD45EC4AF0C;
	Thu, 15 Aug 2024 13:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728968;
	bh=peL+1Q3k3Z9ALCP9dbk9D8354m9IoWWFqybpPPu0vVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REhsQYSrJgAGA4KWu65gx9b+dUO+D2XyiNu433wHvJyYQCov8oRa+V/L2LTRtc2is
	 w8UUz7ncSdpuYdJbJIiOiZvCz3BhOxZetz4sDS6ONcBdXQcV46kRtmGeOp+aYvbe6r
	 RcyVt5LC3P1hHJjw7EraG5lbc5cuR7aOOQl03B/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Clark Wang <xiaoning.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 168/196] spi: lpspi: Add i.MX8 boards support for lpspi
Date: Thu, 15 Aug 2024 15:24:45 +0200
Message-ID: <20240815131858.500537367@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clark Wang <xiaoning.wang@nxp.com>

[ Upstream commit f5e5afdb0e56e81123e02b6a64dd32adc19a90d4 ]

Add both ipg and per clock for lpspi to support i.MX8QM/QXP boards.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 730bbfaf7d48 ("spi: spi-fsl-lpspi: Fix scldiv calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 52 +++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 08dcc3c22e883..5802f188051b8 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -80,7 +80,8 @@ struct lpspi_config {
 struct fsl_lpspi_data {
 	struct device *dev;
 	void __iomem *base;
-	struct clk *clk;
+	struct clk *clk_ipg;
+	struct clk *clk_per;
 	bool is_slave;
 
 	void *rx_buf;
@@ -147,8 +148,19 @@ static int lpspi_prepare_xfer_hardware(struct spi_controller *controller)
 {
 	struct fsl_lpspi_data *fsl_lpspi =
 				spi_controller_get_devdata(controller);
+	int ret;
+
+	ret = clk_prepare_enable(fsl_lpspi->clk_ipg);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(fsl_lpspi->clk_per);
+	if (ret) {
+		clk_disable_unprepare(fsl_lpspi->clk_ipg);
+		return ret;
+	}
 
-	return clk_prepare_enable(fsl_lpspi->clk);
+	return 0;
 }
 
 static int lpspi_unprepare_xfer_hardware(struct spi_controller *controller)
@@ -156,7 +168,8 @@ static int lpspi_unprepare_xfer_hardware(struct spi_controller *controller)
 	struct fsl_lpspi_data *fsl_lpspi =
 				spi_controller_get_devdata(controller);
 
-	clk_disable_unprepare(fsl_lpspi->clk);
+	clk_disable_unprepare(fsl_lpspi->clk_ipg);
+	clk_disable_unprepare(fsl_lpspi->clk_per);
 
 	return 0;
 }
@@ -249,7 +262,7 @@ static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
 	unsigned int perclk_rate, scldiv;
 	u8 prescale;
 
-	perclk_rate = clk_get_rate(fsl_lpspi->clk);
+	perclk_rate = clk_get_rate(fsl_lpspi->clk_per);
 	for (prescale = 0; prescale < 8; prescale++) {
 		scldiv = perclk_rate /
 			 (clkdivs[prescale] * config.speed_hz) - 2;
@@ -522,15 +535,30 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 		goto out_controller_put;
 	}
 
-	fsl_lpspi->clk = devm_clk_get(&pdev->dev, "ipg");
-	if (IS_ERR(fsl_lpspi->clk)) {
-		ret = PTR_ERR(fsl_lpspi->clk);
+	fsl_lpspi->clk_per = devm_clk_get(&pdev->dev, "per");
+	if (IS_ERR(fsl_lpspi->clk_per)) {
+		ret = PTR_ERR(fsl_lpspi->clk_per);
+		goto out_controller_put;
+	}
+
+	fsl_lpspi->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
+	if (IS_ERR(fsl_lpspi->clk_ipg)) {
+		ret = PTR_ERR(fsl_lpspi->clk_ipg);
+		goto out_controller_put;
+	}
+
+	ret = clk_prepare_enable(fsl_lpspi->clk_ipg);
+	if (ret) {
+		dev_err(&pdev->dev,
+			"can't enable lpspi ipg clock, ret=%d\n", ret);
 		goto out_controller_put;
 	}
 
-	ret = clk_prepare_enable(fsl_lpspi->clk);
+	ret = clk_prepare_enable(fsl_lpspi->clk_per);
 	if (ret) {
-		dev_err(&pdev->dev, "can't enable lpspi clock, ret=%d\n", ret);
+		dev_err(&pdev->dev,
+			"can't enable lpspi per clock, ret=%d\n", ret);
+		clk_disable_unprepare(fsl_lpspi->clk_ipg);
 		goto out_controller_put;
 	}
 
@@ -538,7 +566,8 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 	fsl_lpspi->txfifosize = 1 << (temp & 0x0f);
 	fsl_lpspi->rxfifosize = 1 << ((temp >> 8) & 0x0f);
 
-	clk_disable_unprepare(fsl_lpspi->clk);
+	clk_disable_unprepare(fsl_lpspi->clk_per);
+	clk_disable_unprepare(fsl_lpspi->clk_ipg);
 
 	ret = devm_spi_register_controller(&pdev->dev, controller);
 	if (ret < 0) {
@@ -560,7 +589,8 @@ static int fsl_lpspi_remove(struct platform_device *pdev)
 	struct fsl_lpspi_data *fsl_lpspi =
 				spi_controller_get_devdata(controller);
 
-	clk_disable_unprepare(fsl_lpspi->clk);
+	clk_disable_unprepare(fsl_lpspi->clk_per);
+	clk_disable_unprepare(fsl_lpspi->clk_ipg);
 
 	return 0;
 }
-- 
2.43.0




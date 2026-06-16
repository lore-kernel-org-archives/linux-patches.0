Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB1D45BD78;
	Tue, 16 Jun 2026 17:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632344; cv=none; b=H0nL+pWodj8Ex/GOdElp2Cg5OKbYCV7Zt35gM74K043n3jg7G4+C7nSgyIZUnjk+76EWco4ya7mP4v0q0V2UO4MCkUWda/kN8zHzx2/0HT+yWCa9FT5jFkze820Rhna1A6blki8e7/LBKn/LtEC22qhvnfH1NHPbH/t20GCxn8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632344; c=relaxed/simple;
	bh=m86AibhHYY/2ti/KV0rbQDtAI7awSBgm0SzsFdpZHzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdDBaVXqY9tjyL+1+6FKYN9jGpTnv6b4ayFn5ei7ydsGIryaI9ZSmlS4qYn9MSEvL1bmJ7QbAaFnkAtdQByH3rV3S29M1ocNP9fXqUThWNG0Tn2cDwoVrLBxHt9XBX6ZTCjOq2RfnIt44MGqZ+67ttQNlQ89qm4KtqWC97t6QqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ePbo34HF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ePbo34HF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481651F000E9;
	Tue, 16 Jun 2026 17:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632341;
	bh=gtbHPRg96AYk48B5h8Kost19nkS0GqN5jS94AIwsTY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ePbo34HFosO6vz0r8TIm7fizUSWuId2sbmEXd5AG4IjLf2R9Ya7cA8VRUcM2770qe
	 iGOWSxLn8bQ7xvQyt9hRR0eOHcXNz9cPrdeAmNKM2RHSE1pMgMveKJvJWfrj7uhL+w
	 zaTlpGo4BcGN7UAypnzj+Msxu24nLTcpwaT1DPtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 392/522] spi: zynq-qspi: Simplify clock handling with devm_clk_get_enabled()
Date: Tue, 16 Jun 2026 20:28:59 +0530
Message-ID: <20260616145144.147028794@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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
@@ -379,21 +379,10 @@ static int zynq_qspi_setup_op(struct spi
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
 
@@ -659,7 +648,7 @@ static int zynq_qspi_probe(struct platfo
 		goto remove_ctlr;
 	}
 
-	xqspi->pclk = devm_clk_get(&pdev->dev, "pclk");
+	xqspi->pclk = devm_clk_get_enabled(&pdev->dev, "pclk");
 	if (IS_ERR(xqspi->pclk)) {
 		dev_err(&pdev->dev, "pclk clock not found.\n");
 		ret = PTR_ERR(xqspi->pclk);
@@ -668,36 +657,24 @@ static int zynq_qspi_probe(struct platfo
 
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
@@ -707,7 +684,7 @@ static int zynq_qspi_probe(struct platfo
 	} else if (num_cs > ZYNQ_QSPI_MAX_NUM_CS) {
 		ret = -EINVAL;
 		dev_err(&pdev->dev, "only 2 chip selects are available\n");
-		goto clk_dis_all;
+		goto remove_ctlr;
 	} else {
 		ctlr->num_chipselect = num_cs;
 	}
@@ -725,15 +702,11 @@ static int zynq_qspi_probe(struct platfo
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
 
@@ -755,9 +728,6 @@ static void zynq_qspi_remove(struct plat
 	struct zynq_qspi *xqspi = platform_get_drvdata(pdev);
 
 	zynq_qspi_write(xqspi, ZYNQ_QSPI_ENABLE_OFFSET, 0);
-
-	clk_disable_unprepare(xqspi->refclk);
-	clk_disable_unprepare(xqspi->pclk);
 }
 
 static const struct of_device_id zynq_qspi_of_match[] = {



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839DD4DEC26;
	Wed, 30 Sep 2026 18:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792252; cv=none; b=Zldy/9BIfLhSyKuU3oYc5k16NJlQbhw8rdI+e3l/KfsNEheOndL5DhgG8jCAIo7S3OSgC8qG+z3g1TGZx4oolSMtVyDfnkiOt+bUbSuf0c4AMIK1iqbTD6DxKpY4Gj7kTK+iN1dAELNma5058qrRs+vXbEjYXU80gKigum2iDXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792252; c=relaxed/simple;
	bh=2hP42HGIXlA7MwtbQTeYo6stWFzkJTnKmsCQ4AHXRys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXz4h/nvYXgXblFrKTSS21LgtSJgOEpraHqQinHnYlubqBR/QuH5uuAUfrXkhHTW1Hw4FO/SQ7Kgw8whZjLcuKmIyqlHeXGfxooOKlWVuk5wc6FvEEa2JpX6HW8ZGJI3fj9z/nzzKZH7kigktpWmhUTewbyuuhh0VR6oRQrFJxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uq/yRJlq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uq/yRJlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF18C1F000FF;
	Wed, 30 Sep 2026 18:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792251;
	bh=46wLxu8QomGkezRTaFSaAxuU6sAe0KLKMDcuMg83GO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uq/yRJlqZZX68v5IzQl4iYtCQjQ1WdzgmYhtxFPhoA6Ei0RFOurU5kkJuYt5COgBE
	 LpWVu1oUHcG4FLcD7oq1RGSZNTrLbMo6Xk6KT1yHIoBHGV8mvEchBH6dV7+nplEidH
	 PPS+wUfs+i0M9rGBjuHWynurhxyozYXlrlnurBmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 588/752] spi: zynqmp-gqspi: Use devm_spi_alloc_host()
Date: Wed, 30 Sep 2026 17:27:38 +0200
Message-ID: <20260930152411.012730487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 64640f6c972e80f52196416a8d4dc3c0ffcbc82d ]

Use devm_spi_alloc_host() so that there's no need to call
spi_controller_put() in the error path.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://patch.msgid.link/20240826121421.3384792-2-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynqmp-gqspi.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index 590ecd79cb501..b68fa82554d04 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1096,7 +1096,7 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
 
-	ctlr = spi_alloc_master(&pdev->dev, sizeof(*xqspi));
+	ctlr = devm_spi_alloc_master(&pdev->dev, sizeof(*xqspi));
 	if (!ctlr)
 		return -ENOMEM;
 
@@ -1106,29 +1106,25 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, xqspi);
 
 	xqspi->regs = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(xqspi->regs)) {
-		ret = PTR_ERR(xqspi->regs);
-		goto remove_master;
-	}
+	if (IS_ERR(xqspi->regs))
+		return PTR_ERR(xqspi->regs);
 
 	xqspi->pclk = devm_clk_get(&pdev->dev, "pclk");
 	if (IS_ERR(xqspi->pclk)) {
 		dev_err(dev, "pclk clock not found.\n");
-		ret = PTR_ERR(xqspi->pclk);
-		goto remove_master;
+		return PTR_ERR(xqspi->pclk);
 	}
 
 	xqspi->refclk = devm_clk_get(&pdev->dev, "ref_clk");
 	if (IS_ERR(xqspi->refclk)) {
 		dev_err(dev, "ref_clk clock not found.\n");
-		ret = PTR_ERR(xqspi->refclk);
-		goto remove_master;
+		return PTR_ERR(xqspi->refclk);
 	}
 
 	ret = clk_prepare_enable(xqspi->pclk);
 	if (ret) {
 		dev_err(dev, "Unable to enable APB clock.\n");
-		goto remove_master;
+		return ret;
 	}
 
 	ret = clk_prepare_enable(xqspi->refclk);
@@ -1202,8 +1198,6 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 	clk_disable_unprepare(xqspi->refclk);
 clk_dis_pclk:
 	clk_disable_unprepare(xqspi->pclk);
-remove_master:
-	spi_controller_put(ctlr);
 
 	return ret;
 }
-- 
2.53.0




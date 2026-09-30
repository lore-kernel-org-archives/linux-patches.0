Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD583ACEFB;
	Wed, 30 Sep 2026 15:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783666; cv=none; b=Glve+zxqbWcf+PeZCHjRlI5/N8EqVNbBe1avme0ge7SLl0JaSOrmVLr1G2Ju9O1nnn8UFt/3DBijgnKSqElXaG1mdfN+vhz3v7sskg5amZoRlX/9gudoTRrVfgY3ZgUcklfm8jFkQe8AImdPPHw6b45cnYCpPGTTxxcf2YsdtDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783666; c=relaxed/simple;
	bh=VNAZyzBmB4N3xyR8X0af60N9b2GtKqnE0TMUIH9yIhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2TyJF0nhDgwO3r2CulefMomU2Gm+Wbwp55xuVqtboyuMsrCba/m+ReVCmobJGwCinORmilur5KMJqCXN/yZ7JPuU/rx9aXs5dm0HbXrp026Es/o8atG7KrT6Hv0Tm0+MJM7O8M9xjsSaNyjTx4l3hrT7tC3wiorNcQlZKKvU1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1Bh9y0s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1Bh9y0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05C81F000FF;
	Wed, 30 Sep 2026 15:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783662;
	bh=Fmj6TXsoFkZpnlRMNfSUOV7vQi1QEkU6WNkCtyiE/nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e1Bh9y0sindMsj7Jz9aaWZ+xjwEyppXTLzt5+HEGknE3H3zacbsXf2sLq2/X5chOF
	 AOHvBfrJdi01o9OsNBJfRvx62+iWH6vfMX4Y7iq2nlyUY1kLslfUuGkubpxqzQ1sU0
	 wYfUSfSlOjVjeXJ1da0gaLSlv/g/WE0ok+1X/HxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 477/595] spi: zynqmp-gqspi: Use devm_spi_alloc_host()
Date: Wed, 30 Sep 2026 17:26:10 +0200
Message-ID: <20260930152357.944447531@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bbc9188156345..5c470daf9367b 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1094,7 +1094,7 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
 
-	ctlr = spi_alloc_master(&pdev->dev, sizeof(*xqspi));
+	ctlr = devm_spi_alloc_master(&pdev->dev, sizeof(*xqspi));
 	if (!ctlr)
 		return -ENOMEM;
 
@@ -1104,29 +1104,25 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
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
@@ -1189,8 +1185,6 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 	clk_disable_unprepare(xqspi->refclk);
 clk_dis_pclk:
 	clk_disable_unprepare(xqspi->pclk);
-remove_master:
-	spi_controller_put(ctlr);
 
 	return ret;
 }
-- 
2.53.0




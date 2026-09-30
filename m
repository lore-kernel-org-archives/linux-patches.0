Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0804E0B66;
	Wed, 30 Sep 2026 16:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786249; cv=none; b=ELyy425r4u/peZkvAZm08dZb9xWRIA7eHpfmDdPq0mTbslnvMEndq+ayNld5HNDscbqjW5XbDKFawKKcSv2su5x2suy0QYAkd+3SJbrL/HRr2hDpwARDYG0p/5MTFHnq0m6e5TdB03WpT4gy7s8l296ENV0dxkvgUOOkUiDQ/U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786249; c=relaxed/simple;
	bh=Ru4n2vZ6Vr4uYSwWD2+bNwaOXLwDHevhpFCGIVRkgc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T37ytF8iErxij1SIKmL82G4CCTxaCZyXwgrR9C40J0x7ZoBkCEwotfuNqIfkN4qWecn0hU2DwpezcsgyxwCH9mQpVk1CINH1V6+1d5Oin5fRGSlxKu663t4coIdlwtJmYl1AODpLtL9Mww0UcUiLof6+rNi2dZtT+3yiU6ScF1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12enxgnW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12enxgnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9911F000FF;
	Wed, 30 Sep 2026 16:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786248;
	bh=gVQ0pFHss+2zQl7gegsXFRQhbxOvAdC8GcVPIhrTOH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=12enxgnWA65zQQ8oWv25NB5FgAPzKDyhl3IOpdiIDiNKj/JR6l8AV2cOQrydKiv+i
	 7Ppq27lTxPoy3NTeg5cectgBnYH2MWWoNzi1brgyhDonWoMLsq+fgHf41IFVWWXvkW
	 6WMZW3V9wVMVwSn1of6yP/4uSQBYcraiOHk2EIuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 796/982] spi: zynqmp-gqspi: Use devm_spi_alloc_host()
Date: Wed, 30 Sep 2026 17:25:32 +0200
Message-ID: <20260930152433.852004184@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index ab62100f0b987..edcf8d24ad494 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1104,7 +1104,7 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 	struct device_node *np = dev->of_node;
 	u32 num_cs;
 
-	ctlr = spi_alloc_master(&pdev->dev, sizeof(*xqspi));
+	ctlr = devm_spi_alloc_host(&pdev->dev, sizeof(*xqspi));
 	if (!ctlr)
 		return -ENOMEM;
 
@@ -1114,29 +1114,25 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
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
@@ -1221,8 +1217,6 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 	clk_disable_unprepare(xqspi->refclk);
 clk_dis_pclk:
 	clk_disable_unprepare(xqspi->pclk);
-remove_master:
-	spi_controller_put(ctlr);
 
 	return ret;
 }
-- 
2.53.0




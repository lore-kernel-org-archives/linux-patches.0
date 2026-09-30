Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A16383C84;
	Wed, 30 Sep 2026 19:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796622; cv=none; b=SeQgUWMUxJSdNNkcNTwYjh2FXxVa6Uvs9h3FcXc+w0LmusxA8s02WwVpTVwbDHiLDIODFZofayVh3Ps9cxqqvdXcET+r4HtIz43CGk9wpxv7ogIT6gON8o5cvfo42LgUN46Sr3xGXSrUuxVgjE9SVWZCfhrmMQQZsaaIn2Jzbdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796622; c=relaxed/simple;
	bh=UE5V4ncHV4LiymznLv8Y8+aqY2S3BrT+G4PNUlyBkfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsO8Y1bD00C7zDmeRrogb9rhUiINAvcIQjGUjCPlW4CByWZ2AImMq7UVJKT0kWl5fMpQUt+KN0JNHvZEBi1QftndTEiaXKkGgos024v9WJTVeifdJG/cFQgMs+FvkErqzl6WFtTf5pMQfCsh6DJylTFHwwTrCevRHE0yVPrgi80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcpsSK1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcpsSK1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063031F000FF;
	Wed, 30 Sep 2026 19:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796621;
	bh=tCkQd2RJqVpHehE/GBNjdIO2xu9acSDzwlDxoDGU8vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xcpsSK1tTC8d6s4++OXMiKg0vzN9KqnVN+mM7WDFS/X2kB98Vqu0O95aABv4ooSbz
	 qxXfMdREieSX93Wa0toafFUFx1SRY335Pl2xcgJhWBV5Ddgta6zbe1yfp7sZR47LlV
	 sO86Gjv/TCB6e+wuy1HPaSk3DtLG9z9tILdvG1Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Michal Simek <michal.simek@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0951/1193] spi: zynqmp-gqspi: Use devm_spi_alloc_host()
Date: Wed, 30 Sep 2026 17:27:15 +0200
Message-ID: <20260930152455.369991242@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f0710f2924bda..635ff4506b96f 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1220,7 +1220,7 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 	u32 num_cs;
 	const struct qspi_platform_data *p_data;
 
-	ctlr = spi_alloc_master(&pdev->dev, sizeof(*xqspi));
+	ctlr = devm_spi_alloc_master(&pdev->dev, sizeof(*xqspi));
 	if (!ctlr)
 		return -ENOMEM;
 
@@ -1234,29 +1234,25 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 		xqspi->has_tapdelay = true;
 
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
@@ -1343,8 +1339,6 @@ static int zynqmp_qspi_probe(struct platform_device *pdev)
 	clk_disable_unprepare(xqspi->refclk);
 clk_dis_pclk:
 	clk_disable_unprepare(xqspi->pclk);
-remove_master:
-	spi_controller_put(ctlr);
 
 	return ret;
 }
-- 
2.53.0




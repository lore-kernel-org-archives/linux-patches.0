Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD452355803;
	Tue, 12 May 2026 17:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607954; cv=none; b=B1ATGzJTLnWJzpovbBOIKIDuxgxBY6adfewXh/vTxrThFWk+xgHoqkJObcPHAZNzd5MR5XpwQxBFOFg3xcTDbYAAepV1Lgcz2IJz9U8zWdzOPhG/177b12NOQ8PaJcuaNdlQTSRMVExf7QUnGNNTgps1Drru2/JK56g6e7vsXAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607954; c=relaxed/simple;
	bh=18dGtxKcyTgX5F886synthx2USz3lsxkcXqj5maJIXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+CxmWIqqpjPJwf/CoMuB66+3zUnSqKFuO+SloVJnbiEOuy/v3khvS4ko/J+Qit1P+jld9kHsjrHuLaQt6fXEKpk/ZjhyuC07G65iti76bHZ6JMWNw0LBsIzoEv49kcQAZTx4+Fvv3irfpp9iWie50kucNSqjv/cb7ZLHpiQHmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQU/XskQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQU/XskQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440DDC2BCB0;
	Tue, 12 May 2026 17:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607954;
	bh=18dGtxKcyTgX5F886synthx2USz3lsxkcXqj5maJIXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQU/XskQJWviEsxbvhXdvf3l6fgubI8jnRyFMWbL4U92VY92YwdDgusMJQZY0ir7/
	 7bNj6Mpap/+E/+iFAEMLUAOzmBTQ58Yy4Zea5jUk6fW/XjU2jFGOQewq+j4ki5I4J3
	 atErURrdgZEyifJDT37FcTJ+OrgqEPHendMo+9OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naga Sureshkumar Relli <nagasuresh.relli@microchip.com>,
	Johan Hovold <johan@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 098/206] spi: microchip-core-qspi: fix controller deregistration
Date: Tue, 12 May 2026 19:39:10 +0200
Message-ID: <20260512173934.934236869@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit e6464140d439f2d42f072eb422a5b1fec470c5a6 upstream.

Make sure to deregister the controller before disabling underlying
resources like interrupts during driver unbind.

Fixes: 8596124c4c1b ("spi: microchip-core-qspi: Add support for microchip fpga qspi controllers")
Cc: stable@vger.kernel.org	# 6.1
Cc: Naga Sureshkumar Relli <nagasuresh.relli@microchip.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20260409120419.388546-19-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-microchip-core-qspi.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-microchip-core-qspi.c
+++ b/drivers/spi/spi-microchip-core-qspi.c
@@ -512,7 +512,7 @@ static int mchp_coreqspi_probe(struct pl
 				     "unable to allocate host for QSPI controller\n");
 
 	qspi = spi_controller_get_devdata(ctlr);
-	platform_set_drvdata(pdev, qspi);
+	platform_set_drvdata(pdev, ctlr);
 
 	qspi->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(qspi->regs))
@@ -545,7 +545,7 @@ static int mchp_coreqspi_probe(struct pl
 			  SPI_TX_DUAL | SPI_TX_QUAD;
 	ctlr->dev.of_node = np;
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret,
 				     "spi_register_controller failed\n");
@@ -555,9 +555,13 @@ static int mchp_coreqspi_probe(struct pl
 
 static void mchp_coreqspi_remove(struct platform_device *pdev)
 {
-	struct mchp_coreqspi *qspi = platform_get_drvdata(pdev);
-	u32 control = readl_relaxed(qspi->regs + REG_CONTROL);
+	struct spi_controller *ctlr = platform_get_drvdata(pdev);
+	struct mchp_coreqspi *qspi = spi_controller_get_devdata(ctlr);
+	u32 control;
 
+	spi_unregister_controller(ctlr);
+
+	control = readl_relaxed(qspi->regs + REG_CONTROL);
 	mchp_coreqspi_disable_ints(qspi);
 	control &= ~CONTROL_ENABLE;
 	writel_relaxed(control, qspi->regs + REG_CONTROL);



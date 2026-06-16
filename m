Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B85D4779BB;
	Tue, 16 Jun 2026 17:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632600; cv=none; b=Dv0QdjsxNQNiuEpt26xp+afzK9FFdaSfJmOc1Cy3BtTjRNevu5ad8mgUfVtOI7wqqYMfi697rmFb+YolfbTs5tKQv2odJ6VSrys9dfKDNOI4qrHLlZZtm8OvQw1p734mUCZH/+G7/y2+kUiaGpFzo6AP0w/DzTlopLfAdzYL9+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632600; c=relaxed/simple;
	bh=kqB3xQ6tf1K1+2Pl9goqgZEs+yQbtHSjjel6mtj7fLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReHIz57jNvFaN7RYbi1MgVJyWDLLEjBKU9seUzNdXsRb+UYkfDj1g1txY/IWunWBkVqvYgKvAMFuNVlY2FbBHRx+vK3aUMAWqtSCF0Dg1BvXp6trZ3c8h/zLncnT6H2z+UOkGyWfCHPSca2D/GWVCdebaijikMFWVZJ+58brbxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3owaLIa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3owaLIa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5871F000E9;
	Tue, 16 Jun 2026 17:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632599;
	bh=KBeKzmqeFOgaJfyN9gFqtP+00KYUKhRbPWPEF+oHf+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s3owaLIaKT68qXGDcdm/1Efl/VtFwtt8hvHy9TWJxqEJOeSISDDc/ZUmEIuh/AKAP
	 28aFtO6TpXmlWjtgF7PJUr+LiT4L6e3MBgeLBTJftbKo+uFR+I3Dp6Szgj5OJi6bJY
	 6KEhgNZJegq9WoFM50jLDhTJFFwTvpmLOK6Hpxqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naga Sureshkumar Relli <nagasuresh.relli@microchip.com>,
	Johan Hovold <johan@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 409/522] spi: microchip-core-qspi: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:16 +0530
Message-ID: <20260616145145.194041334@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit e6464140d439f2d42f072eb422a5b1fec470c5a6 ]

Make sure to deregister the controller before disabling underlying
resources like interrupts during driver unbind.

Fixes: 8596124c4c1b ("spi: microchip-core-qspi: Add support for microchip fpga qspi controllers")
Cc: stable@vger.kernel.org	# 6.1
Cc: Naga Sureshkumar Relli <nagasuresh.relli@microchip.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20260409120419.388546-19-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-microchip-core-qspi.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-microchip-core-qspi.c
+++ b/drivers/spi/spi-microchip-core-qspi.c
@@ -512,7 +512,7 @@ static int mchp_coreqspi_probe(struct pl
 				     "unable to allocate master for QSPI controller\n");
 
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



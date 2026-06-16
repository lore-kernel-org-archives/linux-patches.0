Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E403DC4D9;
	Tue, 16 Jun 2026 18:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634708; cv=none; b=E4Jhz2IxF+I5qsk4qaJVONfyI5jBTmCPUS9GubpBGIMfYHqruR6ueLA4WmeeHHO6DJCAwejo/Q3IIjMp1DFtyrNBtcbn8JW0+Gl1IwuejABvcU8N2Kr7B2DxCNqeZUuQATINoh8ea2dQcDT6jQVZ+IcydXVrjv+M2QSZqowSHoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634708; c=relaxed/simple;
	bh=ljy0WIt1LEDlqfbrJ2QLAc8ChNs8BFssw61tIiNBZU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpMK5fpHLWMC7efbAzu3IrtBD8FKgp3LBwQhzE+OST1nMcLzeJzFXCqtaWofki4S8y6/n2vFPgvjxqhMzy3VEiLz6URq5ZZlLiHprINRoACs2Ny6qTrKzfHC18mZo4NsxCsg0GtnV/iAYGrbdHwZstd1Ocqs01Wz0MQCE8bN0WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dc9UUkRW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dc9UUkRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC311F000E9;
	Tue, 16 Jun 2026 18:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634707;
	bh=KEpYpY530dsGB9Fy1hIGlnQVyAE078v+8JRC8AEWfm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dc9UUkRWpf/X092E+FqvY8Y3T9M/8q3RHNpTfpvdy0XwqWd2OE856XWeGopXsGjF8
	 a9221QkWMFKWobobwZxor5OhD4AkZghzQaOgNZe+WAfd6nSkVz6rRUnI5AjAcXoshP
	 T9yg+ZrP2AVtElzV1fMHfQ4HCrhpKx5z2r6Pb6zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 316/411] spi: sun6i: fix controller deregistration
Date: Tue, 16 Jun 2026 20:29:14 +0530
Message-ID: <20260616145117.948061890@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit d874a1c33aee0d88fb4ba2f8aeadaa9f1965209a ]

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 3558fe900e8a ("spi: sunxi: Add Allwinner A31 SPI controller driver")
Cc: stable@vger.kernel.org	# 3.15
Cc: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-20-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ renamed spi_controller APIs to spi_master equivalents and kept int return type for sun6i_spi_remove ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-sun6i.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-sun6i.c
+++ b/drivers/spi/spi-sun6i.c
@@ -688,7 +688,7 @@ static int sun6i_spi_probe(struct platfo
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	ret = devm_spi_register_master(&pdev->dev, master);
+	ret = spi_register_master(master);
 	if (ret) {
 		dev_err(&pdev->dev, "cannot register SPI master\n");
 		goto err_pm_disable;
@@ -714,12 +714,19 @@ static int sun6i_spi_remove(struct platf
 {
 	struct spi_master *master = platform_get_drvdata(pdev);
 
+	spi_master_get(master);
+
+	spi_unregister_master(master);
+
 	pm_runtime_force_suspend(&pdev->dev);
 
 	if (master->dma_tx)
 		dma_release_channel(master->dma_tx);
 	if (master->dma_rx)
 		dma_release_channel(master->dma_rx);
+
+	spi_master_put(master);
+
 	return 0;
 }
 



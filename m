Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA423FD956;
	Fri, 15 May 2026 16:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861931; cv=none; b=Kvl5sLvD0tKzT0ig0JcmftIGBsyIrn0e8/gtn8YxDzbzcEtOL1nsc+ZleWH2GfsDRNFj2oCfdK1Ot52WtyHCht9mSRlvvbIXP3O5iOlk5IfuawyrNKGinP5eqhp3wRFzbohHWX2C0UeQuPnRtnASDLArdlMjeNQngi9obvnNjT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861931; c=relaxed/simple;
	bh=7tadXUkqcwhyXrNflpcI+PydhMt5zEuQduqp9/T6oVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rDrUbnKplLybGt1fXdLGFrLBST6F6vFYIFmfMGhYgbW+N+8k3LiwLl8t6GSpwEXxz5nb+6KEaFM/PNHMLvnqXgrNeiVrDNNhA3nL8Ed4l+XpTNR191UM34BS49NLCsP+JfDOnTI43lcUYACSUTqg2SiMEiIafVYszRJXhkkU7Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4m3Nwwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4m3Nwwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E94C2BCB0;
	Fri, 15 May 2026 16:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861931;
	bh=7tadXUkqcwhyXrNflpcI+PydhMt5zEuQduqp9/T6oVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4m3Nwwg1UKmhZHEEUZIoHGa0pJIHUjcvsfDc6V7q8SPgu4HlInkJjELhbmbkGbH2
	 3KrzAX9B0RTH9awEwuHDy3tJiZ0BzPNFZi0byAQELiM57D4hMiy0o5spAjPTR++BVD
	 5UsJG35LKdSU1ul+lmY+X8mxPo2ZqDA+qHCBP0M0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 043/188] spi: aspeed-smc: fix controller deregistration
Date: Fri, 15 May 2026 17:47:40 +0200
Message-ID: <20260515154658.249757992@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 1044e5a4ccd57bf5a64f90100a321b498e0267a2 upstream.

Make sure to deregister the controller before disabling it to allow
SPI device drivers to do I/O during deregistration.

Fixes: e3228ed92893 ("spi: spi-mem: Convert Aspeed SMC driver to spi-mem")
Cc: stable@vger.kernel.org	# 5.19
Cc: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-aspeed-smc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-aspeed-smc.c
+++ b/drivers/spi/spi-aspeed-smc.c
@@ -726,7 +726,7 @@ static int aspeed_spi_probe(struct platf
 		return -ENOMEM;
 
 	aspi = spi_controller_get_devdata(ctlr);
-	platform_set_drvdata(pdev, aspi);
+	platform_set_drvdata(pdev, ctlr);
 	aspi->data = data;
 	aspi->dev = dev;
 
@@ -765,7 +765,7 @@ static int aspeed_spi_probe(struct platf
 	ctlr->num_chipselect = data->max_cs;
 	ctlr->dev.of_node = dev->of_node;
 
-	ret = devm_spi_register_controller(dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret)
 		dev_err(&pdev->dev, "spi_register_controller failed\n");
 
@@ -774,7 +774,10 @@ static int aspeed_spi_probe(struct platf
 
 static void aspeed_spi_remove(struct platform_device *pdev)
 {
-	struct aspeed_spi *aspi = platform_get_drvdata(pdev);
+	struct spi_controller *ctlr = platform_get_drvdata(pdev);
+	struct aspeed_spi *aspi = spi_controller_get_devdata(ctlr);
+
+	spi_unregister_controller(ctlr);
 
 	aspeed_spi_enable(aspi, false);
 }



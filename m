Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E182D060B;
	Tue, 12 May 2026 18:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609318; cv=none; b=r6QytMnJiV0qIRw26F+sYAFmwIrdkUIsQU2mw8rXz5nFjltSdYkHnlhMXPIuKaOAVujBnLgFz7hDVvoY89Q8ioPBEAKYxiYeUKdnIzpifx74okjaqIaat5PuzanGgF2dOXtGp6v8CpkzsFCk5eGr/iGkW8KAKuxXPZlow5bErkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609318; c=relaxed/simple;
	bh=di+MxCzR1DMLr4kCzfmlAjMOAlcvceRzSLlMl9zMtZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7h5nQ74vGh2kmJhDL7S11tRBkuCoVKhOu1zkIZ3fTjR9jQUE02erXd1yHc8Wi/t8PoHPoz5fSPf2wV/5U2G43+6AbzYJEZGvPu7pCC0Y2ULHFjyxqO3lUfdf7h0vfcGqY5mNjgxjlHC1bkCExY3VaVEEkOSNIj1vv0ER/81pQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LU2r5lIE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LU2r5lIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BAAC2BCC7;
	Tue, 12 May 2026 18:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609318;
	bh=di+MxCzR1DMLr4kCzfmlAjMOAlcvceRzSLlMl9zMtZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LU2r5lIERMPfnkcylefQKYozDmu6Us+mGwP6teo4Wae4gLeVRZCw4KLVlCrLProsb
	 Lx7M0PYVfX278sYshalEB7vCnzzXm6QF/p5oyBIIIcIROtqmwEbr87mPD+DEcHexMv
	 /NI8pir4O5wTzU9tWgheJvVYjTBlJwcoj0KfV1/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naga Sureshkumar Relli <nagasuresh.relli@microchip.com>,
	Johan Hovold <johan@kernel.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 148/307] spi: microchip-core-qspi: fix controller deregistration
Date: Tue, 12 May 2026 19:39:03 +0200
Message-ID: <20260512173943.251009316@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -692,7 +692,7 @@ static int mchp_coreqspi_probe(struct pl
 		return -ENOMEM;
 
 	qspi = spi_controller_get_devdata(ctlr);
-	platform_set_drvdata(pdev, qspi);
+	platform_set_drvdata(pdev, ctlr);
 
 	qspi->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(qspi->regs))
@@ -732,7 +732,7 @@ static int mchp_coreqspi_probe(struct pl
 	ctlr->num_chipselect = 2;
 	ctlr->use_gpio_descriptors = true;
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret)
 		return dev_err_probe(&pdev->dev, ret,
 				     "spi_register_controller failed\n");
@@ -742,9 +742,13 @@ static int mchp_coreqspi_probe(struct pl
 
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



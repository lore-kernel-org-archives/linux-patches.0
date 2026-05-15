Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531723FF1A2;
	Fri, 15 May 2026 15:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860276; cv=none; b=Zfz73ucpTYdx9sngs+jlNNjeMlO3W6vFXHpH6mWMTa9Ti57D9DflhzHMBrY3r3aUAi63stOwLFDqnyCdQyfli2COv1XYoP+Pu6m4tU7glrcgpr18Qh/Vlor5X8mprone6ZZ+EfpVrr8WcHTu/swOI7fKxfJuPas7bxwBukMeGuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860276; c=relaxed/simple;
	bh=BXcv2BjeYNkJFe9YzMsdw/OtFmBramiXZlFDuUcprPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8ITd9XvvaCXKf+m3PUZlQD3WpmnKzKKHYztk2yyIyWUh229DMIOXWPWj5wPz3zoge/iBw9JUP1HAOukH7b+FtJocoGcxTsJqqgOP5FfgjCxUs/A41nCg8K1Z7ROIAuOytZF7YiDspqAStYxyZS1KI3qZYNM6BV1kh0uHSE06qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJclXEjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJclXEjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CF0C2BCB0;
	Fri, 15 May 2026 15:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860276;
	bh=BXcv2BjeYNkJFe9YzMsdw/OtFmBramiXZlFDuUcprPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJclXEjKBPuPDm11hzgKzk2okHrD95weD+XZA0HdxhRaGc8idreAjkqq2IjQG6ZfY
	 UHY4ezNdIcSqJUFkJDzDq4lZ9Jud6fRpYyDTnsEMGfeE/Ut3iVBJygsVCB1cazyeVL
	 INdWUiSs4ZkoWXLjG9FkWzPABPPHmoE9b2XpkDa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radu Pirea <radu.pirea@microchip.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 027/144] spi: at91-usart: fix controller deregistration
Date: Fri, 15 May 2026 17:47:33 +0200
Message-ID: <20260515154654.137024532@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

commit 9acecc9bcff058eaef40fd7a4c3650e88b06b220 upstream.

Make sure to deregister the controller before disabling and releasing
underlying resources like clocks and DMA during driver unbind.

Fixes: e1892546ff66 ("spi: at91-usart: Add driver for at91-usart as SPI")
Cc: stable@vger.kernel.org	# 4.20
Cc: Radu Pirea <radu.pirea@microchip.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-4-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-at91-usart.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-at91-usart.c
+++ b/drivers/spi/spi-at91-usart.c
@@ -556,7 +556,7 @@ static int at91_usart_spi_probe(struct p
 	spin_lock_init(&aus->lock);
 	init_completion(&aus->xfer_completion);
 
-	ret = devm_spi_register_controller(&pdev->dev, controller);
+	ret = spi_register_controller(controller);
 	if (ret)
 		goto at91_usart_fail_register_controller;
 
@@ -634,8 +634,14 @@ static void at91_usart_spi_remove(struct
 	struct spi_controller *ctlr = platform_get_drvdata(pdev);
 	struct at91_usart_spi *aus = spi_controller_get_devdata(ctlr);
 
+	spi_controller_get(ctlr);
+
+	spi_unregister_controller(ctlr);
+
 	at91_usart_spi_release_dma(ctlr);
 	clk_disable_unprepare(aus->clk);
+
+	spi_controller_put(ctlr);
 }
 
 static const struct dev_pm_ops at91_usart_spi_pm_ops = {



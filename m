Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0D83E4C76;
	Fri, 15 May 2026 16:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862451; cv=none; b=toyDfUTsLAeJY4hLqoJwxdiUC/EhTFQ+rMDmnq4bO/EqEMEWAcb46IFyKrsMuktQ6Y6Jbq5FTOI0DAgVXNeMVntFRJGppni1H10XgD1slfRY6Ltqi4WAv4+tRXY/MNGLdB7YMhaEDXKvgIeT1YsVhBcTJXVeJDZjdsNdxdyRpLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862451; c=relaxed/simple;
	bh=MKGsjCYZlso+xVTqERugR4OvM8x5P/gJSGlH6VJ8iWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFfZMr0iTNJpXl6Zt+VXeGjsp4i44L8b/e+sdhC0FbMlTZZ4q4JklflYqoI4ivQWBHQgZfG0FjoA+bVi5d0bTVCMcbs/kIkAIFk2cdkE8XQ9RGOA9TfDZJnlsPpiuq/ApVEQoVpimqT1qkzAHL3VQdBpmAslvsxWijJqeWdrJxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KiVNR0Cw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KiVNR0Cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9495CC2BCB0;
	Fri, 15 May 2026 16:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862450;
	bh=MKGsjCYZlso+xVTqERugR4OvM8x5P/gJSGlH6VJ8iWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KiVNR0CwKBBgoLCG27Fs9NGbSdxOxoIWgls9DWoTVYcXWHCLTT++pS4sNeREWqcv+
	 cj63gjyIyruGzyslOsMgxDMvdkLM8e14AQ79W131GSUInmAEXBLCa2V9U5BXF7ns7Z
	 A/L+m3jdAUQfytICl102sYl5pg7SYQS7vKr9jrF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radu Pirea <radu.pirea@microchip.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 054/201] spi: at91-usart: fix controller deregistration
Date: Fri, 15 May 2026 17:47:52 +0200
Message-ID: <20260515154659.707213184@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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



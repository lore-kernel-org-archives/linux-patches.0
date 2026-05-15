Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9943F86E1;
	Fri, 15 May 2026 16:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861397; cv=none; b=qmnl+CtFDfdCYUaEVGqg9z595XkXlfAE93qD9ufZqhXF+7lcLcIDgBnEp0RfJNBK+0gsKKfDl+vn6lnI78FviAI5ym7uozja67dF70jIZaZ6BGHJb1IRMoFNunyV2IsO1spO31y+lZp4i+b8j2Gm2KmTgC5dw5WtWxi6gbLEiHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861397; c=relaxed/simple;
	bh=Q8nhbuuPrkw9PkbIxZW25eF9iu0z6DKJCZUi0jgDiAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpg8rx5TQif8BQTv28YfVAWKOM7DFYK2ElVvQ1DC+YV7vSxVT4Hu9jPFFxS3rWFdGcF3YBH9h5N/+oGh0kTlq6GOLh/R8ExKKsYUo1P1LjgO3pt8YwUtprvluhTdhXorMYRZmjoS+eiF5PO3QblL8EcKTghYhLsityjgXn5lf5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jy7KP8RT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jy7KP8RT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4EEC2BCB0;
	Fri, 15 May 2026 16:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861397;
	bh=Q8nhbuuPrkw9PkbIxZW25eF9iu0z6DKJCZUi0jgDiAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jy7KP8RTxIS10FVKvJ650vALxC+7GS3BHgg4WpaNoCTerjzDNE7mmpwImGM3HK9Rr
	 J3QJJSt4AbXc0JzSUzMe+7YbqT28jIg2sPTSW6tbzuyCFqU9U6pWsbTPHCPICZveY4
	 QqSP2IuuuQ30v127oehdxMsAp0ximrvyUVqle63s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radu Pirea <radu.pirea@microchip.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 313/474] spi: at91-usart: fix controller deregistration
Date: Fri, 15 May 2026 17:47:02 +0200
Message-ID: <20260515154721.783359030@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -570,7 +570,7 @@ static int at91_usart_spi_probe(struct p
 	spin_lock_init(&aus->lock);
 	init_completion(&aus->xfer_completion);
 
-	ret = devm_spi_register_controller(&pdev->dev, controller);
+	ret = spi_register_controller(controller);
 	if (ret)
 		goto at91_usart_fail_register_controller;
 
@@ -648,8 +648,14 @@ static void at91_usart_spi_remove(struct
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



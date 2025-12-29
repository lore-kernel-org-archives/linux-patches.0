Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A91724EF8C;
	Mon, 29 Dec 2025 16:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025645; cv=none; b=Cq5v6wctMt1WeGAZI+y0OqV7TtAr5GVqeiArBdf2lFhQwAlNeVXhmLQ85X01yrx5+7yAFGPEJE0c5BiDjiukYtcO0WTn0aM0k03W7PzLzqFywnvADtmplRItdEaXfmWScdk234OxMUaygLE6vpG30SUkO2WYJSKnXtaPnQTTPEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025645; c=relaxed/simple;
	bh=yVhtL0MP7hEPWmCl0pL0715iRsQH/O2bqZBSe4sjAHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XO0C7GltJkXMC9BRVCJZBRrOZAfBf4o+kbpXnJ70XQpgf/YX6kFczeGsrAoISvwgnVJc6TgKMiu4znCyljSEWNgTSJ04M7emadu6ga0BghmlphTpsKxpyNmFXkRozKCfKQWwJRHcB4bmhzG2brP0d3UmwaTi5KRZm6k4oKTSIOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzNK74g/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzNK74g/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBDCC4CEF7;
	Mon, 29 Dec 2025 16:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025645;
	bh=yVhtL0MP7hEPWmCl0pL0715iRsQH/O2bqZBSe4sjAHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzNK74g//a486RKTLeZfAF8Qj48XMKqxwqDRpQKePC7gE02iqqZ5hMbNCOGuhsO2b
	 +sTvrkt0CupUnqX0BnyRabn0Mk+l8A4Bt/hSyozHJmaoXrIlkcgRmDa/zJ0R/dsJrv
	 Z3VXk45fvY3spSb76oMLaFLdZ8lTIZVVXIpYF7zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ma Ke <make24@iscas.ac.cn>
Subject: [PATCH 6.18 287/430] USB: lpc32xx_udc: Fix error handling in probe
Date: Mon, 29 Dec 2025 17:11:29 +0100
Message-ID: <20251229160734.907215580@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit c84117912bddd9e5d87e68daf182410c98181407 upstream.

lpc32xx_udc_probe() acquires an i2c_client reference through
isp1301_get_client() but fails to release it in both error handling
paths and the normal removal path. This could result in a reference
count leak for the I2C device, preventing proper cleanup and potentially
leading to resource exhaustion. Add put_device() to release the
reference in the probe failure path and in the remove function.

Calling path: isp1301_get_client() -> of_find_i2c_device_by_node() ->
i2c_find_device_by_fwnode(). As comments of i2c_find_device_by_fwnode()
says, 'The user must call put_device(&client->dev) once done with the
i2c client.'

Found by code review.

Cc: stable <stable@kernel.org>
Fixes: 24a28e428351 ("USB: gadget driver for LPC32xx")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://patch.msgid.link/20251215020931.15324-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/lpc32xx_udc.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/usb/gadget/udc/lpc32xx_udc.c
+++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -3020,7 +3020,7 @@ static int lpc32xx_udc_probe(struct plat
 	pdev->dev.dma_mask = &lpc32xx_usbd_dmamask;
 	retval = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (retval)
-		return retval;
+		goto i2c_fail;
 
 	udc->board = &lpc32xx_usbddata;
 
@@ -3038,28 +3038,32 @@ static int lpc32xx_udc_probe(struct plat
 	/* Get IRQs */
 	for (i = 0; i < 4; i++) {
 		udc->udp_irq[i] = platform_get_irq(pdev, i);
-		if (udc->udp_irq[i] < 0)
-			return udc->udp_irq[i];
+		if (udc->udp_irq[i] < 0) {
+			retval = udc->udp_irq[i];
+			goto i2c_fail;
+		}
 	}
 
 	udc->udp_baseaddr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(udc->udp_baseaddr)) {
 		dev_err(udc->dev, "IO map failure\n");
-		return PTR_ERR(udc->udp_baseaddr);
+		retval = PTR_ERR(udc->udp_baseaddr);
+		goto i2c_fail;
 	}
 
 	/* Get USB device clock */
 	udc->usb_slv_clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(udc->usb_slv_clk)) {
 		dev_err(udc->dev, "failed to acquire USB device clock\n");
-		return PTR_ERR(udc->usb_slv_clk);
+		retval = PTR_ERR(udc->usb_slv_clk);
+		goto i2c_fail;
 	}
 
 	/* Enable USB device clock */
 	retval = clk_prepare_enable(udc->usb_slv_clk);
 	if (retval < 0) {
 		dev_err(udc->dev, "failed to start USB device clock\n");
-		return retval;
+		goto i2c_fail;
 	}
 
 	/* Setup deferred workqueue data */
@@ -3161,6 +3165,8 @@ dma_alloc_fail:
 	dma_free_coherent(&pdev->dev, UDCA_BUFF_SIZE,
 			  udc->udca_v_base, udc->udca_p_base);
 i2c_fail:
+	if (udc->isp1301_i2c_client)
+		put_device(&udc->isp1301_i2c_client->dev);
 	clk_disable_unprepare(udc->usb_slv_clk);
 	dev_err(udc->dev, "%s probe failed, %d\n", driver_name, retval);
 
@@ -3189,6 +3195,9 @@ static void lpc32xx_udc_remove(struct pl
 	dma_free_coherent(&pdev->dev, UDCA_BUFF_SIZE,
 			  udc->udca_v_base, udc->udca_p_base);
 
+	if (udc->isp1301_i2c_client)
+		put_device(&udc->isp1301_i2c_client->dev);
+
 	clk_disable_unprepare(udc->usb_slv_clk);
 }
 



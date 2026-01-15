Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828B03B8BC0;
	Thu, 15 Jan 2026 18:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500083; cv=none; b=sho/LEjqsq8FQZgsUa2j6tC9SO3RhL2e4/W2xoQragNKruNbaWnym9mDBx4gfBdozTCVDBrZEy6UExVn59acAHn55d+MqvMGD4ShT/OCTwZwc+tBEEwKqdWAOMxNYtm7wy70MupAUrnI1uI9GvTJw1OmdMvOlTXSvNhKY2tmsDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500083; c=relaxed/simple;
	bh=4vmLit6E7ZQ2S+03y6XVYEzAq3HwxTk3F/Oz6SawP1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNR3Q8k+1Na3S9B/5jOpU7drJDVE4FDJJ48+WqazhHSYubvFl7rkU/TBiDRQXi2RmeWoxWbDIcX1SOkPYJbPmFACRycrwsgXhNSPq1zpdQd2v/bICEk+koNsb0iMG2Vlywvn48gXCwXQGiMqzfy58ylFV8/1JoBKsB01JHHRV40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHe4+1ip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHe4+1ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3750C116D0;
	Thu, 15 Jan 2026 18:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500083;
	bh=4vmLit6E7ZQ2S+03y6XVYEzAq3HwxTk3F/Oz6SawP1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qHe4+1ip8sqrDE2r0Jbm1wghwuQKLtAkwdneAPLJJWE8ovzQe8aBZ6L2EPiLMmHJ3
	 CVpFVUXCITrt/t9f4a6IxvQ5IW2w/cSzzbwCye512Mjl2k8H72JqOREvV0BqVD2jlK
	 5UtGHrnWNDTawwErxamWu8o707n7hjCZg4bV36ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>
Subject: [PATCH 5.10 409/451] usb: gadget: lpc32xx_udc: fix clock imbalance in error path
Date: Thu, 15 Jan 2026 17:50:10 +0100
Message-ID: <20260115164245.736754713@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 782be79e4551550d7a82b1957fc0f7347e6d461f upstream.

A recent change fixing a device reference leak introduced a clock
imbalance by reusing an error path so that the clock may be disabled
before having been enabled.

Note that the clock framework allows for passing in NULL clocks so there
is no risk for a NULL pointer dereference.

Also drop the bogus I2C client NULL check added by the offending commit
as the pointer has already been verified to be non-NULL.

Fixes: c84117912bdd ("USB: lpc32xx_udc: Fix error handling in probe")
Cc: stable@vger.kernel.org
Cc: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Vladimir Zapolskiy <vz@mleia.com>
Link: https://patch.msgid.link/20251218153519.19453-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/lpc32xx_udc.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/drivers/usb/gadget/udc/lpc32xx_udc.c
+++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -3026,7 +3026,7 @@ static int lpc32xx_udc_probe(struct plat
 	pdev->dev.dma_mask = &lpc32xx_usbd_dmamask;
 	retval = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (retval)
-		goto i2c_fail;
+		goto err_put_client;
 
 	udc->board = &lpc32xx_usbddata;
 
@@ -3046,7 +3046,7 @@ static int lpc32xx_udc_probe(struct plat
 		udc->udp_irq[i] = platform_get_irq(pdev, i);
 		if (udc->udp_irq[i] < 0) {
 			retval = udc->udp_irq[i];
-			goto i2c_fail;
+			goto err_put_client;
 		}
 	}
 
@@ -3054,7 +3054,7 @@ static int lpc32xx_udc_probe(struct plat
 	if (IS_ERR(udc->udp_baseaddr)) {
 		dev_err(udc->dev, "IO map failure\n");
 		retval = PTR_ERR(udc->udp_baseaddr);
-		goto i2c_fail;
+		goto err_put_client;
 	}
 
 	/* Get USB device clock */
@@ -3062,14 +3062,14 @@ static int lpc32xx_udc_probe(struct plat
 	if (IS_ERR(udc->usb_slv_clk)) {
 		dev_err(udc->dev, "failed to acquire USB device clock\n");
 		retval = PTR_ERR(udc->usb_slv_clk);
-		goto i2c_fail;
+		goto err_put_client;
 	}
 
 	/* Enable USB device clock */
 	retval = clk_prepare_enable(udc->usb_slv_clk);
 	if (retval < 0) {
 		dev_err(udc->dev, "failed to start USB device clock\n");
-		goto i2c_fail;
+		goto err_put_client;
 	}
 
 	/* Setup deferred workqueue data */
@@ -3171,9 +3171,10 @@ dma_alloc_fail:
 	dma_free_coherent(&pdev->dev, UDCA_BUFF_SIZE,
 			  udc->udca_v_base, udc->udca_p_base);
 i2c_fail:
-	if (udc->isp1301_i2c_client)
-		put_device(&udc->isp1301_i2c_client->dev);
 	clk_disable_unprepare(udc->usb_slv_clk);
+err_put_client:
+	put_device(&udc->isp1301_i2c_client->dev);
+
 	dev_err(udc->dev, "%s probe failed, %d\n", driver_name, retval);
 
 	return retval;
@@ -3198,11 +3199,9 @@ static int lpc32xx_udc_remove(struct pla
 	dma_free_coherent(&pdev->dev, UDCA_BUFF_SIZE,
 			  udc->udca_v_base, udc->udca_p_base);
 
-	if (udc->isp1301_i2c_client)
-		put_device(&udc->isp1301_i2c_client->dev);
-
 	clk_disable_unprepare(udc->usb_slv_clk);
 
+	put_device(&udc->isp1301_i2c_client->dev);
 	return 0;
 }
 



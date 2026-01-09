Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AC72FD699;
	Fri,  9 Jan 2026 12:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961076; cv=none; b=Qob4J/XlvnS/L/VXw6x/31g73eC4giX1XGVMw3/EhxLq2lV+ERasi9+FEH+jNivfZTqSg/zfzwd+h4bY3q8URQZxpFcht9NwyadKbnDsPkBq2O8rz5RidJFGWUUw5D5phAWjdoaosZg1V1TRURnXO/wnPq8SWL6+jvyRO+aW2cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961076; c=relaxed/simple;
	bh=dHHqIDZaScVBm9ibIIH55KrRRl2GkoncUzEyYwCvQWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYp3bQM19iWFvEl6vZGXS3j+BsqOqNwHL/1O3ruvjrhbf5rjNGKNEVYfjOhwRDoCHGj7VuTbbtUTyyBOsAW1mq/STWjoC+48Puxlx4rwVr76SC8UVios698vLDxcxCW8+oFemsQ5IxdenEe1E4DCQA9ftrLzsYJ8OLJdeBzpJUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jW9csi1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jW9csi1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11295C4CEF1;
	Fri,  9 Jan 2026 12:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961076;
	bh=dHHqIDZaScVBm9ibIIH55KrRRl2GkoncUzEyYwCvQWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jW9csi1wJsViwJ6X+bJVdrBeHfThxa5Fb77dD/08PbE0wypaQ0bDL1pLmbLEkN37b
	 6O//6JG1Ughc9dJ2b1ECBUUDPBiMenXEvPGlGaNAkzLSGz+S4LomvzmqnRkYmbVQtE
	 4ia/MT8QDQkxj/iZqWR2XtGozFkjo+C40Gkw8Cfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>
Subject: [PATCH 6.6 626/737] usb: gadget: lpc32xx_udc: fix clock imbalance in error path
Date: Fri,  9 Jan 2026 12:42:45 +0100
Message-ID: <20260109112157.552470079@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
 drivers/usb/gadget/udc/lpc32xx_udc.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/usb/gadget/udc/lpc32xx_udc.c
+++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -3027,7 +3027,7 @@ static int lpc32xx_udc_probe(struct plat
 	pdev->dev.dma_mask = &lpc32xx_usbd_dmamask;
 	retval = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (retval)
-		goto i2c_fail;
+		goto err_put_client;
 
 	udc->board = &lpc32xx_usbddata;
 
@@ -3047,7 +3047,7 @@ static int lpc32xx_udc_probe(struct plat
 		udc->udp_irq[i] = platform_get_irq(pdev, i);
 		if (udc->udp_irq[i] < 0) {
 			retval = udc->udp_irq[i];
-			goto i2c_fail;
+			goto err_put_client;
 		}
 	}
 
@@ -3055,7 +3055,7 @@ static int lpc32xx_udc_probe(struct plat
 	if (IS_ERR(udc->udp_baseaddr)) {
 		dev_err(udc->dev, "IO map failure\n");
 		retval = PTR_ERR(udc->udp_baseaddr);
-		goto i2c_fail;
+		goto err_put_client;
 	}
 
 	/* Get USB device clock */
@@ -3063,14 +3063,14 @@ static int lpc32xx_udc_probe(struct plat
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
@@ -3172,9 +3172,10 @@ dma_alloc_fail:
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
@@ -3199,11 +3200,10 @@ static int lpc32xx_udc_remove(struct pla
 	dma_free_coherent(&pdev->dev, UDCA_BUFF_SIZE,
 			  udc->udca_v_base, udc->udca_p_base);
 
-	if (udc->isp1301_i2c_client)
-		put_device(&udc->isp1301_i2c_client->dev);
-
 	clk_disable_unprepare(udc->usb_slv_clk);
 
+	put_device(&udc->isp1301_i2c_client->dev);
+
 	return 0;
 }
 



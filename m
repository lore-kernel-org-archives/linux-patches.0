Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F983AEF51;
	Sat, 12 Sep 2026 12:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215225; cv=none; b=aXiLJxf4Ep993+WCBhho4emLy/qzZKVgz+k8jZw+JxSuY028exUJPX1sJ9HPBwHsGOWlEGE3tItaq1xBW+5jHa77SpDCqquFZ2imArvnWNOGxEQzDxzw7ZKOvOVRKdSjZP0TfdcikIZzv2mAab14+XnNBvWweBbjlfvO0ygxmsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215225; c=relaxed/simple;
	bh=l4GmOOrpheDtfjS/h04DjlXk0+NVMhj1hqOLl1G/hHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+BH0s5mlRWdZPf+FSk0y4ysZ+vu9VBWKnwDGfJdh1lC/da61OdSP7t3HhWnXot9M00aKJnGmB5JTfrO98fgrYL4k2TeNX6ihm4Qz6UhCVVTZIfQO17XLpzrYRXt2LOPQmxNbkwCFtcaZ1oE7fSDANphNKNVbjvgvdZqvqI29gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odGs7+FW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odGs7+FW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBDF1F000FF;
	Sat, 12 Sep 2026 12:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215221;
	bh=ej0HNcRyZnBxdtJm7duudU694fNoYHMOvrJE/xj3/mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odGs7+FWMWC55xg5a7jXjgmKT2+80uNEpfOfhfwO5SEPycBgKslv6bvtrvyPmCRhb
	 OWKCVuZiqy31kBBkuvDHuGKO3dBdJ9n/B1urj10Uc16G2dirySGHxO5YncaVqgGqVI
	 1SKkQoraRDM3+PtNfzVUMtQAZZhmiD7px5Z/gejo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0487/1376] usb: gadget: aspeed_udc: check endpoint DMA allocation
Date: Sat, 12 Sep 2026 08:48:33 +0200
Message-ID: <20260912065618.391793932@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 97cee53a94be3bd4fd8fbed6071bd2f32dad1ab1 ]

ast_udc_probe() allocates a coherent DMA buffer used as the backing store
for endpoint buffers. ast_udc_init_ep() derives per-endpoint buffer
pointers from udc->ep0_buf, so a failed allocation is dereferenced during
probe.

Check the allocation before endpoint setup. The existing probe error path
called ast_udc_remove(), which unregisters the gadget unconditionally and
is not safe before usb_add_gadget_udc() succeeds. Add a local cleanup
helper for probe failures so pre-registration failures only unwind the
resources that were actually initialized.

This was found by a local static analysis checker for unchecked allocator
returns while scanning Linux 6.16. The change was checked by applying it
to current mainline and by running checkpatch. I do not have access to
Aspeed UDC hardware, so no runtime testing was performed.

Fixes: 055276c13205 ("usb: gadget: add Aspeed ast2600 udc driver")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Link: https://patch.msgid.link/20260610121022.3-1-ruoyuw560@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/aspeed_udc.c | 50 ++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/gadget/udc/aspeed_udc.c b/drivers/usb/gadget/udc/aspeed_udc.c
index f4781e611aaa2..efcceb886bb40 100644
--- a/drivers/usb/gadget/udc/aspeed_udc.c
+++ b/drivers/usb/gadget/udc/aspeed_udc.c
@@ -1434,25 +1434,12 @@ static void ast_udc_init_hw(struct ast_udc_dev *udc)
 	ast_udc_write(udc, 0, AST_UDC_EP0_CTRL);
 }
 
-static void ast_udc_remove(struct platform_device *pdev)
+static void ast_udc_cleanup(struct platform_device *pdev)
 {
 	struct ast_udc_dev *udc = platform_get_drvdata(pdev);
 	unsigned long flags;
 	u32 ctrl;
 
-	usb_del_gadget_udc(&udc->gadget);
-	if (udc->driver) {
-		/*
-		 * This is broken as only some cleanup is skipped, *udev is
-		 * freed and the register mapping goes away. Any further usage
-		 * probably crashes. Also the device is unbound, so the skipped
-		 * cleanup is never catched up later.
-		 */
-		dev_alert(&pdev->dev,
-			  "Driver is busy and still going away. Fasten your seat belts!\n");
-		return;
-	}
-
 	spin_lock_irqsave(&udc->lock, flags);
 
 	/* Disable upstream port connection */
@@ -1472,6 +1459,26 @@ static void ast_udc_remove(struct platform_device *pdev)
 	udc->ep0_buf = NULL;
 }
 
+static void ast_udc_remove(struct platform_device *pdev)
+{
+	struct ast_udc_dev *udc = platform_get_drvdata(pdev);
+
+	usb_del_gadget_udc(&udc->gadget);
+	if (udc->driver) {
+		/*
+		 * This is broken as only some cleanup is skipped, *udev is
+		 * freed and the register mapping goes away. Any further usage
+		 * probably crashes. Also the device is unbound, so the skipped
+		 * cleanup is never catched up later.
+		 */
+		dev_alert(&pdev->dev,
+			  "Driver is busy and still going away. Fasten your seat belts!\n");
+		return;
+	}
+
+	ast_udc_cleanup(pdev);
+}
+
 static int ast_udc_probe(struct platform_device *pdev)
 {
 	enum usb_device_speed max_speed;
@@ -1524,6 +1531,12 @@ static int ast_udc_probe(struct platform_device *pdev)
 					  AST_UDC_NUM_ENDPOINTS,
 					  &udc->ep0_buf_dma, GFP_KERNEL);
 
+	if (!udc->ep0_buf) {
+		clk_disable_unprepare(udc->clk);
+		rc = -ENOMEM;
+		goto err;
+	}
+
 	udc->gadget.speed = USB_SPEED_UNKNOWN;
 	udc->gadget.max_speed = USB_SPEED_HIGH;
 	udc->creq = udc->reg + AST_UDC_SETUP0;
@@ -1553,20 +1566,20 @@ static int ast_udc_probe(struct platform_device *pdev)
 	udc->irq = platform_get_irq(pdev, 0);
 	if (udc->irq < 0) {
 		rc = udc->irq;
-		goto err;
+		goto err_cleanup;
 	}
 
 	rc = devm_request_irq(&pdev->dev, udc->irq, ast_udc_isr, 0,
 			      KBUILD_MODNAME, udc);
 	if (rc) {
 		dev_err(&pdev->dev, "Failed to request interrupt\n");
-		goto err;
+		goto err_cleanup;
 	}
 
 	rc = usb_add_gadget_udc(&pdev->dev, &udc->gadget);
 	if (rc) {
 		dev_err(&pdev->dev, "Failed to add gadget udc\n");
-		goto err;
+		goto err_cleanup;
 	}
 
 	dev_info(&pdev->dev, "Initialized udc in USB%s mode\n",
@@ -1574,9 +1587,10 @@ static int ast_udc_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_cleanup:
+	ast_udc_cleanup(pdev);
 err:
 	dev_err(&pdev->dev, "Failed to udc probe, rc:0x%x\n", rc);
-	ast_udc_remove(pdev);
 
 	return rc;
 }
-- 
2.53.0




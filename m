Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2328A37998A;
	Sat, 12 Sep 2026 07:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198380; cv=none; b=YIP4aNab27iF37Qi4PrEICtXNaRyvjhyQbXrH3P5zMqJxUGg3P0XWTR1wpp5DgfahlIT0OWolFucATBuYX/oVRdC0QAAPbFmaPQg6PBGOLOOpekwqnXEe/WYkZeVwjiusMU+xdZDJDkdVp6LdaWm3j6IVyk7su4EAiP9sLbU52c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198380; c=relaxed/simple;
	bh=OFJse6/vXJtJqhWBW1PTlVM6Ng5+mZsmzHCZJUpJEmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6m9/beJpnzgrqZDS+1vc53Zal2UnQkk+CZOOMGEjArLZgOBYNyN8Qs+kEl5L1kVaUvpX+Zw8iLe6ZONG4Yt1Q4ZrbBvgdyWYcB3MHoWTWMNgcA+kG4K/r/6GmwK4WEtMG6sIBJKg348MICCqHyeUIrcisjawoVz3Ddby0EBf90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTC9dy7S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTC9dy7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B391F000FF;
	Sat, 12 Sep 2026 07:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198379;
	bh=/piRgXN7e6pMMNEX1VlAzRgflDFJfaPWJu+SfR/45r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTC9dy7SOUBh/FVFwAOKtYD6WgPZt7sMFLWt2hcyHidwa8gcMCQ3txqCPUiocfvcv
	 2eNE/sbBG3quum7cXV/fLoi/PktzQeyIGFdfaVoHCDgShk8PDwWT5TGx6ldx/goXSl
	 SLHV7WeDPy9r1Buzg6jrZgCC5bcero3fHZ37pChU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0325/1815] usb: gadget: aspeed_udc: check endpoint DMA allocation
Date: Sat, 12 Sep 2026 08:34:35 +0200
Message-ID: <20260912065656.562360403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 75f9c831b21a6..54f81e6680094 100644
--- a/drivers/usb/gadget/udc/aspeed_udc.c
+++ b/drivers/usb/gadget/udc/aspeed_udc.c
@@ -1431,25 +1431,12 @@ static void ast_udc_init_hw(struct ast_udc_dev *udc)
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
@@ -1469,6 +1456,26 @@ static void ast_udc_remove(struct platform_device *pdev)
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
@@ -1521,6 +1528,12 @@ static int ast_udc_probe(struct platform_device *pdev)
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
@@ -1550,20 +1563,20 @@ static int ast_udc_probe(struct platform_device *pdev)
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
@@ -1571,9 +1584,10 @@ static int ast_udc_probe(struct platform_device *pdev)
 
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




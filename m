Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F99A242D65;
	Sat, 12 Sep 2026 14:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223014; cv=none; b=VtZKLTQtoCDIFHOsjndkXrq8Poq3x6cc5ZWqMkRkv+DfxaowP3BB/SlzHunZJaEorpGNfrAfzXMpHP+tSrzuk5tytzgWuqrm9aECA7Pz28q1iAwMXS1LjGkOEYlcBFnr3Ki0xUNRFi0ejqjJNXN1jLhBLT7i2NM4aepImYEcu8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223014; c=relaxed/simple;
	bh=33zSpP3r82Pn2uNAN2oFq4dBeXCqjmvLUXi2oO8eZE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nj8onhXsEiuzPHGp0oXm0G++DQBLZpRDLK06C3pBXwm9q6ee1+K6PZfYmtTpWSmMUNyc6g8BatEAfz89F9V/q54XkIGd+74N/+hwziysvlMEarhZmYsnh+1dxNxA3qjuPdteL9RxLnP5XBho+osVTn8u5qugFd9SSVKvL4LNdCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JofOJ4aB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JofOJ4aB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41EF1F000FF;
	Sat, 12 Sep 2026 14:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223013;
	bh=rjbJ4uq9avZ86ri9TecpiGKwdAg/ek0Q7DfqLwBdVCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JofOJ4aB8Qsabgj9dL6Wp6kOBmMhT9lLx+Qr8KwDtXhtb4mfNmeLX75ArMYCVyuJ/
	 GXCiF0gGQ0G8TuyuicFazaNuH2IH1cJERmMo1x8PLzZ7VwKlxcuOjN0ApHnmp0DrQ2
	 OXE2uzXFURcz1GVKmhYVOrjD9usXRQRdRVJ8d3Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0703/1424] usb: gadget: aspeed_udc: Convert to platform remove callback returning void
Date: Sat, 12 Sep 2026 08:52:15 +0200
Message-ID: <20260912065623.040989519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 3d56e5aa6727f5055d1ad879342ad1a8acec2134 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

ast_udc_remove() is one of these functions that return an error code
after doing only a partial cleanup. Replace the core's error message by
a more drastic one and still convert the driver to .remove_new().
Note the only semantic change here is the changed error message.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20231026221701.2521483-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 97cee53a94be ("usb: gadget: aspeed_udc: check endpoint DMA allocation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/aspeed_udc.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/udc/aspeed_udc.c b/drivers/usb/gadget/udc/aspeed_udc.c
index 4868286574a1c..f4781e611aaa2 100644
--- a/drivers/usb/gadget/udc/aspeed_udc.c
+++ b/drivers/usb/gadget/udc/aspeed_udc.c
@@ -1434,15 +1434,24 @@ static void ast_udc_init_hw(struct ast_udc_dev *udc)
 	ast_udc_write(udc, 0, AST_UDC_EP0_CTRL);
 }
 
-static int ast_udc_remove(struct platform_device *pdev)
+static void ast_udc_remove(struct platform_device *pdev)
 {
 	struct ast_udc_dev *udc = platform_get_drvdata(pdev);
 	unsigned long flags;
 	u32 ctrl;
 
 	usb_del_gadget_udc(&udc->gadget);
-	if (udc->driver)
-		return -EBUSY;
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
 
 	spin_lock_irqsave(&udc->lock, flags);
 
@@ -1461,8 +1470,6 @@ static int ast_udc_remove(struct platform_device *pdev)
 				  udc->ep0_buf_dma);
 
 	udc->ep0_buf = NULL;
-
-	return 0;
 }
 
 static int ast_udc_probe(struct platform_device *pdev)
@@ -1583,7 +1590,7 @@ MODULE_DEVICE_TABLE(of, ast_udc_of_dt_ids);
 
 static struct platform_driver ast_udc_driver = {
 	.probe			= ast_udc_probe,
-	.remove			= ast_udc_remove,
+	.remove_new		= ast_udc_remove,
 	.driver			= {
 		.name			= KBUILD_MODNAME,
 		.of_match_table		= ast_udc_of_dt_ids,
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC78F317145;
	Sat, 12 Sep 2026 16:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229371; cv=none; b=WXdJnTE6ivCzsTetBwQi8doNIhr42hEH5NtcZLlXZ/wB4/abkj2LSiHp+sSfP+kKcj+zyRP8yEhTD8LlSZRmU+CL776l5CmyeO6+kMgycjdUVmE1kku77DleY5FDQ8WLZOHDBHIXCN68eGTLIb0LbqEAs2B3yCp5scNYDSnrgK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229371; c=relaxed/simple;
	bh=4GB80uasFCGEke7JWZo3rniiEt8aFYOuZLbBVKvSTec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z2oGframjbsxkPWdD04hbAwcHqzsOi/qWt9JsUozqKM8CTQeiCZcsRMwjjs/mEDgCjU/pq0sNo4W/4XUVOQzH8jJoXYy7vLyKoLtqQeJ9eszKO5z0lAp+BfXyjK6R/RN8S7Wqo3YaBHctLlkFbxpBcyDbmzzxnm9uE6NT3ACTqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jidW4T6o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jidW4T6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E7C1F000FF;
	Sat, 12 Sep 2026 16:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229370;
	bh=Ylo2ovx81H+EyVf62mTnI/u5vNZJSh0TVizFD2mD4vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jidW4T6oUv9E7WH9+pEfsMxuNjyzRkUqoaj3AstqUj765tTfDYEdHAK+7llpoNZnQ
	 IOcsEpDQft1faRzc8sP02nz7G7lBZkHAXttXYUVqMQ05sv85EjVyl6c//+JuXjsrvm
	 oC2nR/pM6NkT7EfHMrG70sMAGn+mHfnhy0r6qSho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0576/1191] usb: gadget: aspeed_udc: Convert to platform remove callback returning void
Date: Sat, 12 Sep 2026 08:55:04 +0200
Message-ID: <20260912065601.183133833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1a5a1115c1d96..0e4b84f926bbf 100644
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
@@ -1585,7 +1592,7 @@ MODULE_DEVICE_TABLE(of, ast_udc_of_dt_ids);
 
 static struct platform_driver ast_udc_driver = {
 	.probe			= ast_udc_probe,
-	.remove			= ast_udc_remove,
+	.remove_new		= ast_udc_remove,
 	.driver			= {
 		.name			= KBUILD_MODNAME,
 		.of_match_table		= ast_udc_of_dt_ids,
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD76203719;
	Thu, 13 Feb 2025 14:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458274; cv=none; b=FsWxfNskow31OnQI7j72Zui/11wHmwhNccQmKNU7X0mEYuseH1Cz1VS6oqvUrUNOR9KkhDDwu22/gV5ge6Q8fGska91b/vdQUBTdgsNqPjo1/CE/evfX5qbaW0Wmyfpiu6pxScw2z2qmE1bdwzjo1MAys5YsUN4ZZ1ZvkdKjbQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458274; c=relaxed/simple;
	bh=oDxJRpOsQJjD76Dq/8K/R7Ul1d696PEGSeCFQL0sTF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MirSey4XtQ2IjjO8Q+I8Z1UKM6EIbiilrklSGzUrqtAke1Kk4XE9helcpzba15Vh3wh1pFWg9cESj7+zMGI3h8OwHy+WS+pC5POgWqECi9RyI23JRUqVmMvZvk+2keYQ3NMAHEoQTs4LKDib8nfMDlDm3o7R5EupMyzstH69WgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfuyxNp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfuyxNp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E64C4CED1;
	Thu, 13 Feb 2025 14:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458273;
	bh=oDxJRpOsQJjD76Dq/8K/R7Ul1d696PEGSeCFQL0sTF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfuyxNp6BfmXO+av2qoTelwrkixscUw//GdVUVALMoyMRYzd6/WZKrME7K6GvynA8
	 qL63BuZSLIzUQqz/G+9uBklnXF2NZp/uuctD8O8E1N6RbDOZYfOP6Q9efR2FsZ79hK
	 PaChh8Nj0bJ605WMeR+vpGv3PU+oLo+mbwDFnCBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 334/422] media: uvcvideo: Fix crash during unbind if gpio unit is in use
Date: Thu, 13 Feb 2025 15:28:03 +0100
Message-ID: <20250213142449.442211185@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ricardo Ribalda <ribalda@chromium.org>

commit a9ea1a3d88b7947ce8cadb2afceee7a54872bbc5 upstream.

We used the wrong device for the device managed functions. We used the
usb device, when we should be using the interface device.

If we unbind the driver from the usb interface, the cleanup functions
are never called. In our case, the IRQ is never disabled.

If an IRQ is triggered, it will try to access memory sections that are
already free, causing an OOPS.

We cannot use the function devm_request_threaded_irq here. The devm_*
clean functions may be called after the main structure is released by
uvc_delete.

Luckily this bug has small impact, as it is only affected by devices
with gpio units and the user has to unbind the device, a disconnect will
not trigger this error.

Cc: stable@vger.kernel.org
Fixes: 2886477ff987 ("media: uvcvideo: Implement UVC_EXT_GPIO_UNIT")
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20241106-uvc-crashrmmod-v6-1-fbf9781c6e83@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_driver.c |   28 +++++++++++++++++++++-------
 drivers/media/usb/uvc/uvcvideo.h   |    1 +
 2 files changed, 22 insertions(+), 7 deletions(-)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1280,14 +1280,14 @@ static int uvc_gpio_parse(struct uvc_dev
 	struct gpio_desc *gpio_privacy;
 	int irq;
 
-	gpio_privacy = devm_gpiod_get_optional(&dev->udev->dev, "privacy",
+	gpio_privacy = devm_gpiod_get_optional(&dev->intf->dev, "privacy",
 					       GPIOD_IN);
 	if (IS_ERR_OR_NULL(gpio_privacy))
 		return PTR_ERR_OR_ZERO(gpio_privacy);
 
 	irq = gpiod_to_irq(gpio_privacy);
 	if (irq < 0)
-		return dev_err_probe(&dev->udev->dev, irq,
+		return dev_err_probe(&dev->intf->dev, irq,
 				     "No IRQ for privacy GPIO\n");
 
 	unit = uvc_alloc_entity(UVC_EXT_GPIO_UNIT, UVC_EXT_GPIO_UNIT_ID, 0, 1);
@@ -1313,15 +1313,27 @@ static int uvc_gpio_parse(struct uvc_dev
 static int uvc_gpio_init_irq(struct uvc_device *dev)
 {
 	struct uvc_entity *unit = dev->gpio_unit;
+	int ret;
 
 	if (!unit || unit->gpio.irq < 0)
 		return 0;
 
-	return devm_request_threaded_irq(&dev->udev->dev, unit->gpio.irq, NULL,
-					 uvc_gpio_irq,
-					 IRQF_ONESHOT | IRQF_TRIGGER_FALLING |
-					 IRQF_TRIGGER_RISING,
-					 "uvc_privacy_gpio", dev);
+	ret = request_threaded_irq(unit->gpio.irq, NULL, uvc_gpio_irq,
+				   IRQF_ONESHOT | IRQF_TRIGGER_FALLING |
+				   IRQF_TRIGGER_RISING,
+				   "uvc_privacy_gpio", dev);
+
+	unit->gpio.initialized = !ret;
+
+	return ret;
+}
+
+static void uvc_gpio_deinit(struct uvc_device *dev)
+{
+	if (!dev->gpio_unit || !dev->gpio_unit->gpio.initialized)
+		return;
+
+	free_irq(dev->gpio_unit->gpio.irq, dev);
 }
 
 /* ------------------------------------------------------------------------
@@ -1918,6 +1930,8 @@ static void uvc_unregister_video(struct
 {
 	struct uvc_streaming *stream;
 
+	uvc_gpio_deinit(dev);
+
 	list_for_each_entry(stream, &dev->streams, list) {
 		/* Nothing to do here, continue. */
 		if (!video_is_registered(&stream->vdev))
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -234,6 +234,7 @@ struct uvc_entity {
 			u8  *bmControls;
 			struct gpio_desc *gpio_privacy;
 			int irq;
+			bool initialized;
 		} gpio;
 	};
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFFE2940B;
	Mon, 23 Jun 2025 22:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716730; cv=none; b=fH8fh4EbqFUeSzYNBbqu1TnoxoyU1zaikwJNln5wWMxY9PF2EGyJu3WbNleOVd1E0OtBAxV5wz5ujf6Wb8xozB0zyzx91Un9jSa8yfHcMbtolefiyLioKhVREjP3zp8Bf/FyVUewT7EuNqiLgMv/ETQJYmmMp/EogFBRuq9R1zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716730; c=relaxed/simple;
	bh=fuopPG3iOahIvJvX0/8KlD4VdnjkY5fm1lNPL8/+uOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giFLIgufSDmkRDxGlLhsk/kiPDB5ND8GQCOCJJMPKLWA1vT594oZZt/RTcv5Ux1uzged9MJQYUr3WRP2iQM/NlD3Erx4O9HNDU59HurDC7b8ezTiyzDP4mLIXJivjn5+oZFPHl33hlt7dxD5HcT1Glx4tntA3d4TOAEhVAr0z40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/R9TQgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/R9TQgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B7BC4CEEA;
	Mon, 23 Jun 2025 22:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716730;
	bh=fuopPG3iOahIvJvX0/8KlD4VdnjkY5fm1lNPL8/+uOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/R9TQgqe0hqtLty8WXdNAXpUzGcuiIyY4Dm6uq3XpJiulpuJy36uJVtBJ/c7ppcn
	 uFbSHMIqW53yR0CN4v8/giU6XsI/p43dUP4BMsjPRGNQJklEycSgqwadsSDu4KZSmw
	 COrbNlvkXy6cetoHHlDiaqQF0PjJwj0ra43Ycn+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 324/508] media: uvcvideo: Fix deferred probing error
Date: Mon, 23 Jun 2025 15:06:09 +0200
Message-ID: <20250623130653.300399654@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit 387e8939307192d5a852a2afeeb83427fa477151 upstream.

uvc_gpio_parse() can return -EPROBE_DEFER when the GPIOs it depends on
have not yet been probed. This return code should be propagated to the
caller of uvc_probe() to ensure that probing is retried when the required
GPIOs become available.

Currently, this error code is incorrectly converted to -ENODEV,
causing some internal cameras to be ignored.

This commit fixes this issue by propagating the -EPROBE_DEFER error.

Cc: stable@vger.kernel.org
Fixes: 2886477ff987 ("media: uvcvideo: Implement UVC_EXT_GPIO_UNIT")
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Message-ID: <20250313-uvc-eprobedefer-v3-1-a1d312708eef@chromium.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_driver.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2181,13 +2181,16 @@ static int uvc_probe(struct usb_interfac
 #endif
 
 	/* Parse the Video Class control descriptor. */
-	if (uvc_parse_control(dev) < 0) {
+	ret = uvc_parse_control(dev);
+	if (ret < 0) {
+		ret = -ENODEV;
 		uvc_dbg(dev, PROBE, "Unable to parse UVC descriptors\n");
 		goto error;
 	}
 
 	/* Parse the associated GPIOs. */
-	if (uvc_gpio_parse(dev) < 0) {
+	ret = uvc_gpio_parse(dev);
+	if (ret < 0) {
 		uvc_dbg(dev, PROBE, "Unable to parse UVC GPIOs\n");
 		goto error;
 	}
@@ -2213,24 +2216,32 @@ static int uvc_probe(struct usb_interfac
 	}
 
 	/* Register the V4L2 device. */
-	if (v4l2_device_register(&intf->dev, &dev->vdev) < 0)
+	ret = v4l2_device_register(&intf->dev, &dev->vdev);
+	if (ret < 0)
 		goto error;
 
 	/* Scan the device for video chains. */
-	if (uvc_scan_device(dev) < 0)
+	if (uvc_scan_device(dev) < 0) {
+		ret = -ENODEV;
 		goto error;
+	}
 
 	/* Initialize controls. */
-	if (uvc_ctrl_init_device(dev) < 0)
+	if (uvc_ctrl_init_device(dev) < 0) {
+		ret = -ENODEV;
 		goto error;
+	}
 
 	/* Register video device nodes. */
-	if (uvc_register_chains(dev) < 0)
+	if (uvc_register_chains(dev) < 0) {
+		ret = -ENODEV;
 		goto error;
+	}
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 	/* Register the media device node */
-	if (media_device_register(&dev->mdev) < 0)
+	ret = media_device_register(&dev->mdev);
+	if (ret < 0)
 		goto error;
 #endif
 	/* Save our data pointer in the interface data. */
@@ -2257,7 +2268,7 @@ static int uvc_probe(struct usb_interfac
 error:
 	uvc_unregister_video(dev);
 	kref_put(&dev->ref, uvc_delete);
-	return -ENODEV;
+	return ret;
 }
 
 static void uvc_disconnect(struct usb_interface *intf)



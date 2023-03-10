Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A66882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F145C433EF;
	Fri, 10 Mar 2023 15:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461266;
	bh=z5fsPLbWKWi3AAK77lQApN8quwoSOHOKwBsXUZAMLUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfm7zjnv7oPX2rp9fP8pQXJSE8y9HWMUSW72VDyTnPs72hbUBAt+c4LpBhJYDSLg2
	 NL0mORw5ZvBiLgvHzxDmgfOqSSp6GWDqNAxvDjiZMy44u7VCW3jJLqA13NbAVut8YH
	 roF26qVK+h3zfYFh4xyp1phcf8d+Hf+KA2AIVp2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/136] media: uvcvideo: Remove format descriptions
Date: Fri, 10 Mar 2023 14:43:22 +0100
Message-Id: <20230310133709.585322103@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 50459f103edfe47c9a599d766a850ef6014936c5 ]

The V4L2 core overwrites format descriptions in v4l_fill_fmtdesc(),
there's no need to manually set the descriptions in the driver. This
prepares for removal of the format descriptions from the uvc_fmts table.

Unlike V4L2, UVC makes a distinction between the SD-DV, SDL-DV and HD-DV
formats. It also indicates whether the DV format uses 50Hz or 60Hz. This
information is parsed by the driver to construct a format name string
that is printed in a debug message, but serves no other purpose as V4L2
has a single V4L2_PIX_FMT_DV pixel format that covers all those cases.

As the information is available in the UVC descriptors, and thus
accessible to users with lsusb if they really care, don't log it in a
debug message and drop the format name string to simplify the code.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 24 ++----------------------
 drivers/media/usb/uvc/uvc_v4l2.c   |  2 --
 drivers/media/usb/uvc/uvcvideo.h   |  2 --
 3 files changed, 2 insertions(+), 26 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index ceae2eabc0a1c..57935eb079312 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -531,14 +531,10 @@ static int uvc_parse_format(struct uvc_device *dev,
 		fmtdesc = uvc_format_by_guid(&buffer[5]);
 
 		if (fmtdesc != NULL) {
-			strscpy(format->name, fmtdesc->name,
-				sizeof(format->name));
 			format->fcc = fmtdesc->fcc;
 		} else {
 			dev_info(&streaming->intf->dev,
 				 "Unknown video format %pUl\n", &buffer[5]);
-			snprintf(format->name, sizeof(format->name), "%pUl\n",
-				&buffer[5]);
 			format->fcc = 0;
 		}
 
@@ -549,8 +545,6 @@ static int uvc_parse_format(struct uvc_device *dev,
 		 */
 		if (dev->quirks & UVC_QUIRK_FORCE_Y8) {
 			if (format->fcc == V4L2_PIX_FMT_YUYV) {
-				strscpy(format->name, "Greyscale 8-bit (Y8  )",
-					sizeof(format->name));
 				format->fcc = V4L2_PIX_FMT_GREY;
 				format->bpp = 8;
 				width_multiplier = 2;
@@ -591,7 +585,6 @@ static int uvc_parse_format(struct uvc_device *dev,
 			return -EINVAL;
 		}
 
-		strscpy(format->name, "MJPEG", sizeof(format->name));
 		format->fcc = V4L2_PIX_FMT_MJPEG;
 		format->flags = UVC_FMT_FLAG_COMPRESSED;
 		format->bpp = 0;
@@ -607,17 +600,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 			return -EINVAL;
 		}
 
-		switch (buffer[8] & 0x7f) {
-		case 0:
-			strscpy(format->name, "SD-DV", sizeof(format->name));
-			break;
-		case 1:
-			strscpy(format->name, "SDL-DV", sizeof(format->name));
-			break;
-		case 2:
-			strscpy(format->name, "HD-DV", sizeof(format->name));
-			break;
-		default:
+		if ((buffer[8] & 0x7f) > 2) {
 			uvc_dbg(dev, DESCR,
 				"device %d videostreaming interface %d: unknown DV format %u\n",
 				dev->udev->devnum,
@@ -625,9 +608,6 @@ static int uvc_parse_format(struct uvc_device *dev,
 			return -EINVAL;
 		}
 
-		strlcat(format->name, buffer[8] & (1 << 7) ? " 60Hz" : " 50Hz",
-			sizeof(format->name));
-
 		format->fcc = V4L2_PIX_FMT_DV;
 		format->flags = UVC_FMT_FLAG_COMPRESSED | UVC_FMT_FLAG_STREAM;
 		format->bpp = 0;
@@ -654,7 +634,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 		return -EINVAL;
 	}
 
-	uvc_dbg(dev, DESCR, "Found format %s\n", format->name);
+	uvc_dbg(dev, DESCR, "Found format %p4cc", &format->fcc);
 
 	buflen -= buffer[0];
 	buffer += buffer[0];
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 023412b2a9b93..ab535e5501583 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -657,8 +657,6 @@ static int uvc_ioctl_enum_fmt(struct uvc_streaming *stream,
 	fmt->flags = 0;
 	if (format->flags & UVC_FMT_FLAG_COMPRESSED)
 		fmt->flags |= V4L2_FMT_FLAG_COMPRESSED;
-	strscpy(fmt->description, format->name, sizeof(fmt->description));
-	fmt->description[sizeof(fmt->description) - 1] = 0;
 	fmt->pixelformat = format->fcc;
 	return 0;
 }
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index d7c4f6f5fca92..9051006709fd5 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -405,8 +405,6 @@ struct uvc_format {
 	u32 fcc;
 	u32 flags;
 
-	char name[32];
-
 	unsigned int nframes;
 	struct uvc_frame *frame;
 };
-- 
2.39.2




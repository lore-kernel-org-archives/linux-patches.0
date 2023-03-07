Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263D8BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:19:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A127DC433D2;
	Tue,  7 Mar 2023 18:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213162;
	bh=3Hk0oLE080UUn6XbA/aaTA3N+mz0pW5XSHn6TQK/scs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aBxUsO9MyOtaPbTVKF2YbICUFTii9mZ/4dFpvOCGPOjYSns2B87vYLFM5U2X6+q/f
	 Jxai3esrBlPKWeLT+UFdtjOdtKp2P5nFyB6DY6hdTfZa/qW99+OCxIRYrsKozfJQGh
	 cTZgG7GZRj4I0D85MDsdwYJJRjZkzt2o6xiZ9eTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 419/885] media: uvcvideo: Refactor power_line_frequency_controls_limited
Date: Tue,  7 Mar 2023 17:55:53 +0100
Message-Id: <20230307170020.632220697@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 3aa8628eb78a63d0bf93e159846e9c92bccc8f69 ]

Move the control mapping to uvc_ctrl.c. This way we do not have
references to UVC controls or V4L2 controls in uvc_driver.c.

This also fixes a bug introduced in commit 382075604a68 ("media:
uvcvideo: Limit power line control for Quanta UVC Webcam"). The
offending commit caused the power line control menu entries to have
incorrect indices compared to the V4L2_CID_POWER_LINE_FREQUENCY_*
enumeration. Now that the limited mapping reuses the correct menu_info
array, the indices correctly map to the V4L2 control specification.

Fixes: 382075604a68 ("media: uvcvideo: Limit power line control for Quanta UVC Webcam")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c   | 13 +++++++++++++
 drivers/media/usb/uvc/uvc_driver.c | 18 ------------------
 drivers/media/usb/uvc/uvcvideo.h   |  1 +
 3 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 3c46c33b9e571..44b0cfb8ee1c7 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -723,6 +723,19 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 };
 
+const struct uvc_control_mapping uvc_ctrl_power_line_mapping_limited = {
+	.id		= V4L2_CID_POWER_LINE_FREQUENCY,
+	.entity		= UVC_GUID_UVC_PROCESSING,
+	.selector	= UVC_PU_POWER_LINE_FREQUENCY_CONTROL,
+	.size		= 2,
+	.offset		= 0,
+	.v4l2_type	= V4L2_CTRL_TYPE_MENU,
+	.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
+	.menu_info	= power_line_frequency_controls,
+	.menu_mask	= GENMASK(V4L2_CID_POWER_LINE_FREQUENCY_60HZ,
+				  V4L2_CID_POWER_LINE_FREQUENCY_50HZ),
+};
+
 static const struct uvc_control_mapping uvc_ctrl_power_line_mapping_uvc11 = {
 	.id		= V4L2_CID_POWER_LINE_FREQUENCY,
 	.entity		= UVC_GUID_UVC_PROCESSING,
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index d6dcd78b434ac..abfe735f6ea30 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2374,24 +2374,6 @@ MODULE_PARM_DESC(timeout, "Streaming control requests timeout");
  * Driver initialization and cleanup
  */
 
-static const struct uvc_menu_info power_line_frequency_controls_limited[] = {
-	{ 1, "50 Hz" },
-	{ 2, "60 Hz" },
-};
-
-static const struct uvc_control_mapping uvc_ctrl_power_line_mapping_limited = {
-	.id		= V4L2_CID_POWER_LINE_FREQUENCY,
-	.entity		= UVC_GUID_UVC_PROCESSING,
-	.selector	= UVC_PU_POWER_LINE_FREQUENCY_CONTROL,
-	.size		= 2,
-	.offset		= 0,
-	.v4l2_type	= V4L2_CTRL_TYPE_MENU,
-	.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
-	.menu_info	= power_line_frequency_controls_limited,
-	.menu_mask	=
-		GENMASK(ARRAY_SIZE(power_line_frequency_controls_limited) - 1, 0),
-};
-
 static const struct uvc_device_info uvc_ctrl_power_line_limited = {
 	.mappings = (const struct uvc_control_mapping *[]) {
 		&uvc_ctrl_power_line_mapping_limited,
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index f75e5864bbf72..1227ae63f85b7 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -728,6 +728,7 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags);
 void uvc_status_stop(struct uvc_device *dev);
 
 /* Controls */
+extern const struct uvc_control_mapping uvc_ctrl_power_line_mapping_limited;
 extern const struct v4l2_subscribed_event_ops uvc_ctrl_sub_ev_ops;
 
 int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
-- 
2.39.2




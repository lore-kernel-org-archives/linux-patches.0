Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35387BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAD9C433D2;
	Tue,  7 Mar 2023 18:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213159;
	bh=mH5DrzJOFJmb5we/oLkptg/WQfuYGHhGlfz1otJI/5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUjEKDEtUpXYuadlkI2iDjWHmxVUvErureaaW7nUtS8h+4jWRrnMHVY71+KeSP9gy
	 ElKAP4QIlf0eTVHTMtlSRPvZIRE3oxTzfiFhpp9BnSQXVArEZn1S+wjToVDjP+7lKa
	 IDxkym9tYjTSGpKLz3MA8Mx3toWIK25bh9fb0clE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 418/885] media: uvcvideo: Refactor uvc_ctrl_mappings_uvcXX
Date: Tue,  7 Mar 2023 17:55:52 +0100
Message-Id: <20230307170020.585227453@linuxfoundation.org>
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

[ Upstream commit 96a160b068e09b4ed5a32e2179e5219fc3545eca ]

Convert the array of structs into an array of pointers, that way the
mappings can be reused.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Stable-dep-of: 3aa8628eb78a ("media: uvcvideo: Refactor power_line_frequency_controls_limited")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 74 ++++++++++++++++----------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 32c182987d52c..3c46c33b9e571 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -723,34 +723,40 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 };
 
-static const struct uvc_control_mapping uvc_ctrl_mappings_uvc11[] = {
-	{
-		.id		= V4L2_CID_POWER_LINE_FREQUENCY,
-		.entity		= UVC_GUID_UVC_PROCESSING,
-		.selector	= UVC_PU_POWER_LINE_FREQUENCY_CONTROL,
-		.size		= 2,
-		.offset		= 0,
-		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
-		.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
-		.menu_info	= power_line_frequency_controls,
-		.menu_mask	= GENMASK(V4L2_CID_POWER_LINE_FREQUENCY_60HZ,
-					  V4L2_CID_POWER_LINE_FREQUENCY_DISABLED),
-	},
+static const struct uvc_control_mapping uvc_ctrl_power_line_mapping_uvc11 = {
+	.id		= V4L2_CID_POWER_LINE_FREQUENCY,
+	.entity		= UVC_GUID_UVC_PROCESSING,
+	.selector	= UVC_PU_POWER_LINE_FREQUENCY_CONTROL,
+	.size		= 2,
+	.offset		= 0,
+	.v4l2_type	= V4L2_CTRL_TYPE_MENU,
+	.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
+	.menu_info	= power_line_frequency_controls,
+	.menu_mask	= GENMASK(V4L2_CID_POWER_LINE_FREQUENCY_60HZ,
+				  V4L2_CID_POWER_LINE_FREQUENCY_DISABLED),
 };
 
-static const struct uvc_control_mapping uvc_ctrl_mappings_uvc15[] = {
-	{
-		.id		= V4L2_CID_POWER_LINE_FREQUENCY,
-		.entity		= UVC_GUID_UVC_PROCESSING,
-		.selector	= UVC_PU_POWER_LINE_FREQUENCY_CONTROL,
-		.size		= 2,
-		.offset		= 0,
-		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
-		.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
-		.menu_info	= power_line_frequency_controls,
-		.menu_mask	= GENMASK(V4L2_CID_POWER_LINE_FREQUENCY_AUTO,
-					  V4L2_CID_POWER_LINE_FREQUENCY_DISABLED),
-	},
+static const struct uvc_control_mapping *uvc_ctrl_mappings_uvc11[] = {
+	&uvc_ctrl_power_line_mapping_uvc11,
+	NULL, /* Sentinel */
+};
+
+static const struct uvc_control_mapping uvc_ctrl_power_line_mapping_uvc15 = {
+	.id		= V4L2_CID_POWER_LINE_FREQUENCY,
+	.entity		= UVC_GUID_UVC_PROCESSING,
+	.selector	= UVC_PU_POWER_LINE_FREQUENCY_CONTROL,
+	.size		= 2,
+	.offset		= 0,
+	.v4l2_type	= V4L2_CTRL_TYPE_MENU,
+	.data_type	= UVC_CTRL_DATA_TYPE_ENUM,
+	.menu_info	= power_line_frequency_controls,
+	.menu_mask	= GENMASK(V4L2_CID_POWER_LINE_FREQUENCY_AUTO,
+				  V4L2_CID_POWER_LINE_FREQUENCY_DISABLED),
+};
+
+static const struct uvc_control_mapping *uvc_ctrl_mappings_uvc15[] = {
+	&uvc_ctrl_power_line_mapping_uvc15,
+	NULL, /* Sentinel */
 };
 
 /* ------------------------------------------------------------------------
@@ -2474,8 +2480,7 @@ static void uvc_ctrl_prune_entity(struct uvc_device *dev,
 static void uvc_ctrl_init_ctrl(struct uvc_video_chain *chain,
 			       struct uvc_control *ctrl)
 {
-	const struct uvc_control_mapping *mappings;
-	unsigned int num_mappings;
+	const struct uvc_control_mapping **mappings;
 	unsigned int i;
 
 	/*
@@ -2542,16 +2547,11 @@ static void uvc_ctrl_init_ctrl(struct uvc_video_chain *chain,
 	}
 
 	/* Finally process version-specific mappings. */
-	if (chain->dev->uvc_version < 0x0150) {
-		mappings = uvc_ctrl_mappings_uvc11;
-		num_mappings = ARRAY_SIZE(uvc_ctrl_mappings_uvc11);
-	} else {
-		mappings = uvc_ctrl_mappings_uvc15;
-		num_mappings = ARRAY_SIZE(uvc_ctrl_mappings_uvc15);
-	}
+	mappings = chain->dev->uvc_version < 0x0150
+		 ? uvc_ctrl_mappings_uvc11 : uvc_ctrl_mappings_uvc15;
 
-	for (i = 0; i < num_mappings; ++i) {
-		const struct uvc_control_mapping *mapping = &mappings[i];
+	for (i = 0; mappings[i]; ++i) {
+		const struct uvc_control_mapping *mapping = mappings[i];
 
 		if (uvc_entity_match_guid(ctrl->entity, mapping->entity) &&
 		    ctrl->info.selector == mapping->selector)
-- 
2.39.2




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E3533B6F8;
	Mon, 13 Apr 2026 17:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099744; cv=none; b=SFkgo1xJIbnp3UR+7klGvarRx56DG8Dp1tJLS4GrItnT2y6bIyzVMaw31qPhn7r/TNVgH37N1PAe+PYMNltr9/62BT9tpOv54hcPlcuFB5j2WxpFb37j60H/+bkB+c0n3tUvhGuFF6aYciINiUaWcaK3GmyNDnCLGVv6aJvR0C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099744; c=relaxed/simple;
	bh=oFeih//C+WbFnyNWdGvBtOiYJsRUUG825Rp53DsmG2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kj0yMwwDqwAVCoFWSElCX9Zxq42wKmrnGDwzciHvMUbF5p+iv2igUunLbjGE3fWd6k479TQsX0+cH8JUcs9Mf6sLe7DQ/FY/wiSSkgS/i/KcsYl3j/SM8EeUjtQRJsnJLDA/NfgjrtqaQnzGemfHyt056Pnav0G5fioEB2dGIQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXk6SOSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXk6SOSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B3DC2BCAF;
	Mon, 13 Apr 2026 17:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099744;
	bh=oFeih//C+WbFnyNWdGvBtOiYJsRUUG825Rp53DsmG2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXk6SOSmGVMLd58OHZ6btpeCEf0dvLuQSXXXsxZ9tFMKWofBXC6Wb0nVBZxTiiKCQ
	 Bh7Eopus60CQU3S+Pe7oE/L4b2ec2vJ+x8aHISCrvafBcyjwupAyRX48/JMCtL6d8P
	 DKtxifSzzYouuBqc6mFbzZNsvzn9oBcnmnQDZ14c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 425/491] media: uvcvideo: Move guid to entity
Date: Mon, 13 Apr 2026 18:01:10 +0200
Message-ID: <20260413155834.938796533@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 351509c604dcb065305a165d7552058c2cbc447d ]

Instead of having multiple copies of the entity guid on the code, move
it to the entity structure.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: 0e2ee70291e6 ("media: uvcvideo: Mark invalid entities with id UVC_INVALID_ENTITY_ID")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c   | 30 ++++--------------------------
 drivers/media/usb/uvc/uvc_driver.c | 25 +++++++++++++++++++++++--
 drivers/media/usb/uvc/uvcvideo.h   |  2 +-
 3 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 4f67ba3a7c028..698bf5bb896ec 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -827,31 +827,10 @@ static void uvc_set_le_value(struct uvc_control_mapping *mapping,
  * Terminal and unit management
  */
 
-static const u8 uvc_processing_guid[16] = UVC_GUID_UVC_PROCESSING;
-static const u8 uvc_camera_guid[16] = UVC_GUID_UVC_CAMERA;
-static const u8 uvc_media_transport_input_guid[16] =
-	UVC_GUID_UVC_MEDIA_TRANSPORT_INPUT;
-
 static int uvc_entity_match_guid(const struct uvc_entity *entity,
-	const u8 guid[16])
+				 const u8 guid[16])
 {
-	switch (UVC_ENTITY_TYPE(entity)) {
-	case UVC_ITT_CAMERA:
-		return memcmp(uvc_camera_guid, guid, 16) == 0;
-
-	case UVC_ITT_MEDIA_TRANSPORT_INPUT:
-		return memcmp(uvc_media_transport_input_guid, guid, 16) == 0;
-
-	case UVC_VC_PROCESSING_UNIT:
-		return memcmp(uvc_processing_guid, guid, 16) == 0;
-
-	case UVC_VC_EXTENSION_UNIT:
-		return memcmp(entity->extension.guidExtensionCode,
-			      guid, 16) == 0;
-
-	default:
-		return 0;
-	}
+	return memcmp(entity->guid, guid, sizeof(entity->guid)) == 0;
 }
 
 /* ------------------------------------------------------------------------
@@ -1882,8 +1861,7 @@ static int uvc_ctrl_fill_xu_info(struct uvc_device *dev,
 	if (data == NULL)
 		return -ENOMEM;
 
-	memcpy(info->entity, ctrl->entity->extension.guidExtensionCode,
-	       sizeof(info->entity));
+	memcpy(info->entity, ctrl->entity->guid, sizeof(info->entity));
 	info->index = ctrl->index;
 	info->selector = ctrl->index + 1;
 
@@ -1989,7 +1967,7 @@ int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 
 	if (!found) {
 		uvc_trace(UVC_TRACE_CONTROL, "Control %pUl/%u not found.\n",
-			entity->extension.guidExtensionCode, xqry->selector);
+			entity->guid, xqry->selector);
 		return -ENOENT;
 	}
 
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 419fbdbb7a3b8..15202269194ad 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1032,6 +1032,11 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	return ret;
 }
 
+static const u8 uvc_camera_guid[16] = UVC_GUID_UVC_CAMERA;
+static const u8 uvc_media_transport_input_guid[16] =
+	UVC_GUID_UVC_MEDIA_TRANSPORT_INPUT;
+static const u8 uvc_processing_guid[16] = UVC_GUID_UVC_PROCESSING;
+
 static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
 		unsigned int num_pads, unsigned int extra_size)
 {
@@ -1054,6 +1059,22 @@ static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
 	entity->id = id;
 	entity->type = type;
 
+	/*
+	 * Set the GUID for standard entity types. For extension units, the GUID
+	 * is initialized by the caller.
+	 */
+	switch (type) {
+	case UVC_ITT_CAMERA:
+		memcpy(entity->guid, uvc_camera_guid, 16);
+		break;
+	case UVC_ITT_MEDIA_TRANSPORT_INPUT:
+		memcpy(entity->guid, uvc_media_transport_input_guid, 16);
+		break;
+	case UVC_VC_PROCESSING_UNIT:
+		memcpy(entity->guid, uvc_processing_guid, 16);
+		break;
+	}
+
 	entity->num_links = 0;
 	entity->num_pads = num_pads;
 	entity->pads = ((void *)(entity + 1)) + extra_size;
@@ -1125,7 +1146,7 @@ static int uvc_parse_vendor_control(struct uvc_device *dev,
 		if (unit == NULL)
 			return -ENOMEM;
 
-		memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
+		memcpy(unit->guid, &buffer[4], 16);
 		unit->extension.bNumControls = buffer[20];
 		memcpy(unit->baSourceID, &buffer[22], p);
 		unit->extension.bControlSize = buffer[22+p];
@@ -1376,7 +1397,7 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		if (unit == NULL)
 			return -ENOMEM;
 
-		memcpy(unit->extension.guidExtensionCode, &buffer[4], 16);
+		memcpy(unit->guid, &buffer[4], 16);
 		unit->extension.bNumControls = buffer[20];
 		memcpy(unit->baSourceID, &buffer[22], p);
 		unit->extension.bControlSize = buffer[22+p];
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 60a8749c97a9d..656ab4d9356c2 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -305,6 +305,7 @@ struct uvc_entity {
 	u8 id;
 	u16 type;
 	char name[64];
+	u8 guid[16];
 
 	/* Media controller-related fields. */
 	struct video_device *vdev;
@@ -343,7 +344,6 @@ struct uvc_entity {
 		} selector;
 
 		struct {
-			u8  guidExtensionCode[16];
 			u8  bNumControls;
 			u8  bControlSize;
 			u8  *bmControls;
-- 
2.53.0




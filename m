Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0F423BD0E;
	Mon,  2 Jun 2025 14:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873490; cv=none; b=QikDuBVk/pRaRXr/+ddJLp9hi8gS1p6/6ekCfzjfC4ywVBzcqq1YeRVTWX1VoQAwmYZXeDGH+TCaSJXjfBxMG4QJrnHTutyEYVQRX2J2h3/aPHIXWqSARrvmgLMGMrzdrwAeWdlwXb4yR2R3x/KhvHKuVKfBHJRFk6Ck3PXyu/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873490; c=relaxed/simple;
	bh=2OtinC9Emx/SAF3T+EF+SEhOBwu7Jtr2oylCbCrzuDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnqggXZKE+m67iYbqxoWdvc+DZqfpls/jkge/KyEMMtdPWy5pqKWnFsAV7R2SWKNnz+65vETeHzEDfHRjE8NQMTCCmmTXgCpsxqtpuX2FweJgQmbkB58XQaEGu7MkIVK039dNEUf/c1+2nX2w7n3lzIiXojhvQDmk7PRxKFX3Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwQ9/VjT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwQ9/VjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032F4C4CEEB;
	Mon,  2 Jun 2025 14:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873490;
	bh=2OtinC9Emx/SAF3T+EF+SEhOBwu7Jtr2oylCbCrzuDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwQ9/VjTb8B9lHAShR1FOzHcHBToFXryPiC/6QqISy651yiXqnRjgknE8uG3F4DRo
	 pY9hDzMA0nw3tkZoDWX8w6ZPetnnaMuRED9SMre7cdIlceCyHU0HbB9q3HdRgxJ9GA
	 xOj4xZsI1X1hxGuqKRJ+SuNTvbvaZFXsW4+Bcpk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Yunke Cao <yunkec@google.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/444] media: uvcvideo: Handle uvc menu translation inside uvc_get_le_value
Date: Mon,  2 Jun 2025 15:43:42 +0200
Message-ID: <20250602134347.318905276@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 9109a0b4cb10fd681e9c6e9a4497a6fec5b91c39 ]

map->get() gets a value from an uvc_control in "UVC format" and converts
it to a value that can be consumed by v4l2.

Instead of using a special get function for V4L2_CTRL_TYPE_MENU, we
were converting from uvc_get_le_value in two different places.

Move the conversion to uvc_get_le_value().

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Tested-by: Yunke Cao <yunkec@google.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://lore.kernel.org/r/20250203-uvc-roi-v17-4-5900a9fed613@chromium.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 77 +++++++++++++-------------------
 1 file changed, 32 insertions(+), 45 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 028c4a5049af9..5926a9dfb0b1f 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -815,6 +815,25 @@ static inline void uvc_clear_bit(u8 *data, int bit)
 	data[bit >> 3] &= ~(1 << (bit & 7));
 }
 
+static s32 uvc_menu_to_v4l2_menu(struct uvc_control_mapping *mapping, s32 val)
+{
+	unsigned int i;
+
+	for (i = 0; BIT(i) <= mapping->menu_mask; ++i) {
+		u32 menu_value;
+
+		if (!test_bit(i, &mapping->menu_mask))
+			continue;
+
+		menu_value = uvc_mapping_get_menu_value(mapping, i);
+
+		if (menu_value == val)
+			return i;
+	}
+
+	return val;
+}
+
 /*
  * Extract the bit string specified by mapping->offset and mapping->size
  * from the little-endian data stored at 'data' and return the result as
@@ -849,6 +868,16 @@ static s32 uvc_get_le_value(struct uvc_control_mapping *mapping,
 	if (mapping->data_type == UVC_CTRL_DATA_TYPE_SIGNED)
 		value |= -(value & (1 << (mapping->size - 1)));
 
+	/* If it is a menu, convert from uvc to v4l2. */
+	if (mapping->v4l2_type != V4L2_CTRL_TYPE_MENU)
+		return value;
+
+	switch (query) {
+	case UVC_GET_CUR:
+	case UVC_GET_DEF:
+		return uvc_menu_to_v4l2_menu(mapping, value);
+	}
+
 	return value;
 }
 
@@ -1013,32 +1042,6 @@ static int uvc_ctrl_populate_cache(struct uvc_video_chain *chain,
 	return 0;
 }
 
-static s32 __uvc_ctrl_get_value(struct uvc_control_mapping *mapping,
-				const u8 *data)
-{
-	s32 value = mapping->get(mapping, UVC_GET_CUR, data);
-
-	if (mapping->v4l2_type == V4L2_CTRL_TYPE_MENU) {
-		unsigned int i;
-
-		for (i = 0; BIT(i) <= mapping->menu_mask; ++i) {
-			u32 menu_value;
-
-			if (!test_bit(i, &mapping->menu_mask))
-				continue;
-
-			menu_value = uvc_mapping_get_menu_value(mapping, i);
-
-			if (menu_value == value) {
-				value = i;
-				break;
-			}
-		}
-	}
-
-	return value;
-}
-
 static int __uvc_ctrl_load_cur(struct uvc_video_chain *chain,
 			       struct uvc_control *ctrl)
 {
@@ -1089,8 +1092,8 @@ static int __uvc_ctrl_get(struct uvc_video_chain *chain,
 	if (ret < 0)
 		return ret;
 
-	*value = __uvc_ctrl_get_value(mapping,
-				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
+	*value = mapping->get(mapping, UVC_GET_CUR,
+			      uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
 
 	return 0;
 }
@@ -1240,7 +1243,6 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 {
 	struct uvc_control_mapping *master_map = NULL;
 	struct uvc_control *master_ctrl = NULL;
-	unsigned int i;
 
 	memset(v4l2_ctrl, 0, sizeof(*v4l2_ctrl));
 	v4l2_ctrl->id = mapping->id;
@@ -1283,21 +1285,6 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 		v4l2_ctrl->minimum = ffs(mapping->menu_mask) - 1;
 		v4l2_ctrl->maximum = fls(mapping->menu_mask) - 1;
 		v4l2_ctrl->step = 1;
-
-		for (i = 0; BIT(i) <= mapping->menu_mask; ++i) {
-			u32 menu_value;
-
-			if (!test_bit(i, &mapping->menu_mask))
-				continue;
-
-			menu_value = uvc_mapping_get_menu_value(mapping, i);
-
-			if (menu_value == v4l2_ctrl->default_value) {
-				v4l2_ctrl->default_value = i;
-				break;
-			}
-		}
-
 		return 0;
 
 	case V4L2_CTRL_TYPE_BOOLEAN:
@@ -1580,7 +1567,7 @@ void uvc_ctrl_status_event(struct uvc_video_chain *chain,
 		uvc_ctrl_set_handle(handle, ctrl, NULL);
 
 	list_for_each_entry(mapping, &ctrl->info.mappings, list) {
-		s32 value = __uvc_ctrl_get_value(mapping, data);
+		s32 value = mapping->get(mapping, UVC_GET_CUR, data);
 
 		/*
 		 * handle may be NULL here if the device sends auto-update
-- 
2.39.5




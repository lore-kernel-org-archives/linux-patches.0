Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A279E1714A8;
	Thu, 15 Aug 2024 13:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729043; cv=none; b=GpMmYl1i4PtwRQ3xAtUl9nezBMeW6SgtHsvZRGxZjx41m5CxI8+OrXz8sYz348R4duHiZSIIUUVgBM/Xu8Xmdb8R+l3MAmuGgWwIoG0+5SMB7iJsfVr9frGxcgvm5Q8+CXGIsjDJbBuVc46ndCfVnoxZqLQbd+VRmd7zimWzY9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729043; c=relaxed/simple;
	bh=iqsfW3kpQ+iUgtpokvq7Xj/GZDWJFi2bvQGzyR+68MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EAjF2nveGI6ICwZ6Cail+2RXE7bOXT4BEqrKcwe4vmCgit0MwPgxFaUDapAAPFmrDZSyKp55AvEF38dvAMCuaaRT98/cHX2Xf8mMgiTWg1c5gRUfQhFsQVwZqrhaRdOnB1vGpC8ZcIOlPV5E8PBL3jwsdLZKO0FsOZKKuWpiKtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kb0Vm9jE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kb0Vm9jE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03554C32786;
	Thu, 15 Aug 2024 13:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729043;
	bh=iqsfW3kpQ+iUgtpokvq7Xj/GZDWJFi2bvQGzyR+68MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kb0Vm9jEE7Z/n3MSm/gIJYXdHLRfKyGojp6ENuBbuDFmRBe8PjK3NHHa9N2+9MxZ1
	 S9FhO8P47zNInkKzD0gWD6gVJ9ORJ8c6nyZC1tGl73HP3QCyvyjOLDWQtbhlYVmu/c
	 Q04uZzegoi242jTV/Ssxr/C1HalKKLpDR+xG5eu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunke Cao <yunkec@google.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4.19 193/196] media: uvcvideo: Use entity get_cur in uvc_ctrl_set
Date: Thu, 15 Aug 2024 15:25:10 +0200
Message-ID: <20240815131859.454849950@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunke Cao <yunkec@google.com>

commit 5f36851c36b30f713f588ed2b60aa7b4512e2c76 upstream.

Entity controls should get_cur using an entity-defined function
instead of via a query. Fix this in uvc_ctrl_set.

Fixes: 65900c581d01 ("media: uvcvideo: Allow entity-defined get_info and get_cur")
Signed-off-by: Yunke Cao <yunkec@google.com>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c |   83 +++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 37 deletions(-)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -997,36 +997,56 @@ static s32 __uvc_ctrl_get_value(struct u
 	return value;
 }
 
-static int __uvc_ctrl_get(struct uvc_video_chain *chain,
-	struct uvc_control *ctrl, struct uvc_control_mapping *mapping,
-	s32 *value)
+static int __uvc_ctrl_load_cur(struct uvc_video_chain *chain,
+			       struct uvc_control *ctrl)
 {
+	u8 *data;
 	int ret;
 
-	if ((ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0)
-		return -EACCES;
+	if (ctrl->loaded)
+		return 0;
 
-	if (!ctrl->loaded) {
-		if (ctrl->entity->get_cur) {
-			ret = ctrl->entity->get_cur(chain->dev,
-				ctrl->entity,
-				ctrl->info.selector,
-				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-				ctrl->info.size);
-		} else {
-			ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR,
-				ctrl->entity->id,
-				chain->dev->intfnum,
-				ctrl->info.selector,
-				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-				ctrl->info.size);
-		}
-		if (ret < 0)
-			return ret;
+	data = uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT);
 
+	if ((ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0) {
+		memset(data, 0, ctrl->info.size);
 		ctrl->loaded = 1;
+
+		return 0;
 	}
 
+	if (ctrl->entity->get_cur)
+		ret = ctrl->entity->get_cur(chain->dev, ctrl->entity,
+					    ctrl->info.selector, data,
+					    ctrl->info.size);
+	else
+		ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR,
+				     ctrl->entity->id, chain->dev->intfnum,
+				     ctrl->info.selector, data,
+				     ctrl->info.size);
+
+	if (ret < 0)
+		return ret;
+
+	ctrl->loaded = 1;
+
+	return ret;
+}
+
+static int __uvc_ctrl_get(struct uvc_video_chain *chain,
+			  struct uvc_control *ctrl,
+			  struct uvc_control_mapping *mapping,
+			  s32 *value)
+{
+	int ret;
+
+	if ((ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0)
+		return -EACCES;
+
+	ret = __uvc_ctrl_load_cur(chain, ctrl);
+	if (ret < 0)
+		return ret;
+
 	*value = __uvc_ctrl_get_value(mapping,
 				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT));
 
@@ -1680,21 +1700,10 @@ int uvc_ctrl_set(struct uvc_fh *handle,
 	 * needs to be loaded from the device to perform the read-modify-write
 	 * operation.
 	 */
-	if (!ctrl->loaded && (ctrl->info.size * 8) != mapping->size) {
-		if ((ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) == 0) {
-			memset(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-				0, ctrl->info.size);
-		} else {
-			ret = uvc_query_ctrl(chain->dev, UVC_GET_CUR,
-				ctrl->entity->id, chain->dev->intfnum,
-				ctrl->info.selector,
-				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
-				ctrl->info.size);
-			if (ret < 0)
-				return ret;
-		}
-
-		ctrl->loaded = 1;
+	if ((ctrl->info.size * 8) != mapping->size) {
+		ret = __uvc_ctrl_load_cur(chain, ctrl);
+		if (ret < 0)
+			return ret;
 	}
 
 	/* Backup the current value in case we need to rollback later. */



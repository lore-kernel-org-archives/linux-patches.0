Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0F72EF66C;
	Thu,  3 Jul 2025 15:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555859; cv=none; b=TTDiufcmI6YFPsE+6BKj4H7RJ36I0tz8OF/+o1IcfWpxSxCQCSQBERy9YiBqFacTS3TJG9y7pfysWojcdmnT4n9kbKtxIDuuB3HN6COdh4vX6LmB3Snvd9RIJf4/vxohNP6ErWJapXT/VrGm1klub0PH4tbNW7Thlh+3GXGUfGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555859; c=relaxed/simple;
	bh=7XNXPkZTfd/Cohzlt2ejpA7BZt1agXVYIHcawM3UTu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNW20dCxKtqV48KW9jR6Wh8pdx03wYA5OL1poCN2Je7RctlHp7yMOrTPjzjFzl0qYOSU2cU2r7FwhxFuwrRB30hHKVnEuQxVVrTFvmAJzlFfiKkUyrhvyohYu49zr9UCeEp8dtBgY8BQEad/Lv5rRLMBhTWNytrG/WG40TUCpuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhrkF/xC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhrkF/xC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7215C4CEE3;
	Thu,  3 Jul 2025 15:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555859;
	bh=7XNXPkZTfd/Cohzlt2ejpA7BZt1agXVYIHcawM3UTu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhrkF/xChxM51LXEDGIgeZw7Y/qo5VAlqpR5vb09/q7302JVkBsY986Gv1/sifZg8
	 wwPaUCWR9jTJoJYapCjLHnLF/FHKXhMGz/eRrk3w1Fml5HdczA68OI1ios9kkmL6Zp
	 tbzsdb/vqdeZDNmvGchVCPQhW6BHVGtGAyE6+TeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 131/139] media: uvcvideo: Rollback non processed entities on error
Date: Thu,  3 Jul 2025 16:43:14 +0200
Message-ID: <20250703143946.304013719@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

commit a70705d3c020d0d5c3ab6a5cc93e011ac35e7d48 upstream.

If we fail to commit an entity, we need to restore the
UVC_CTRL_DATA_BACKUP for the other uncommitted entities. Otherwise the
control cache and the device would be out of sync.

Cc: stable@kernel.org
Fixes: b4012002f3a3 ("[media] uvcvideo: Add support for control events")
Reported-by: Hans de Goede <hdegoede@redhat.com>
Closes: https://lore.kernel.org/linux-media/fe845e04-9fde-46ee-9763-a6f00867929a@redhat.com/
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Message-ID: <20250224-uvc-data-backup-v2-3-de993ed9823b@chromium.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c |   39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1801,7 +1801,7 @@ static int uvc_ctrl_commit_entity(struct
 	unsigned int processed_ctrls = 0;
 	struct uvc_control *ctrl;
 	unsigned int i;
-	int ret;
+	int ret = 0;
 
 	if (entity == NULL)
 		return 0;
@@ -1830,8 +1830,6 @@ static int uvc_ctrl_commit_entity(struct
 				dev->intfnum, ctrl->info.selector,
 				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
 				ctrl->info.size);
-		else
-			ret = 0;
 
 		if (!ret)
 			processed_ctrls++;
@@ -1843,17 +1841,25 @@ static int uvc_ctrl_commit_entity(struct
 
 		ctrl->dirty = 0;
 
-		if (ret < 0) {
+		if (!rollback && handle &&
+		    ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
+			uvc_ctrl_set_handle(handle, ctrl, handle);
+
+		if (ret < 0 && !rollback) {
 			if (err_ctrl)
 				*err_ctrl = ctrl;
-			return ret;
+			/*
+			 * If we fail to set a control, we need to rollback
+			 * the next ones.
+			 */
+			rollback = 1;
 		}
 
-		if (!rollback && handle &&
-		    ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
-			uvc_ctrl_set_handle(handle, ctrl, handle);
 	}
 
+	if (ret)
+		return ret;
+
 	return processed_ctrls;
 }
 
@@ -1884,7 +1890,8 @@ int __uvc_ctrl_commit(struct uvc_fh *han
 	struct uvc_video_chain *chain = handle->chain;
 	struct uvc_control *err_ctrl;
 	struct uvc_entity *entity;
-	int ret = 0;
+	int ret_out = 0;
+	int ret;
 
 	/* Find the control. */
 	list_for_each_entry(entity, &chain->entities, chain) {
@@ -1895,17 +1902,23 @@ int __uvc_ctrl_commit(struct uvc_fh *han
 				ctrls->error_idx =
 					uvc_ctrl_find_ctrl_idx(entity, ctrls,
 							       err_ctrl);
-			goto done;
+			/*
+			 * When we fail to commit an entity, we need to
+			 * restore the UVC_CTRL_DATA_BACKUP for all the
+			 * controls in the other entities, otherwise our cache
+			 * and the hardware will be out of sync.
+			 */
+			rollback = 1;
+
+			ret_out = ret;
 		} else if (ret > 0 && !rollback) {
 			uvc_ctrl_send_events(handle, entity,
 					     ctrls->controls, ctrls->count);
 		}
 	}
 
-	ret = 0;
-done:
 	mutex_unlock(&chain->ctrl_mutex);
-	return ret;
+	return ret_out;
 }
 
 int uvc_ctrl_get(struct uvc_video_chain *chain,



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BB92E54AF;
	Tue,  8 Jul 2025 16:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993998; cv=none; b=dpQKwU6LyQMtTQqTqH7vm1c17+jjSu2Dnx2UsmlS2pmnyU4V+NC/lpzdXKywHS+NISqB8MXxBu76nnr+6iY9k5Ii2h5Y4yFNxOila3yhW9sRLPhZzsq8ZEpQk/AaqrLN8J8appGDFXzoBstEpc/v9fIofxJ+POidXY6UJxWaaKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993998; c=relaxed/simple;
	bh=qm7u/YJlranPD+Ad14LqIKYvvY0TGuOPv/wwDRYOcKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fK1YNtUvGL61eJ2lOnSJkpkOJGS15Ok+WgRNvD7GZWQamVRfGSZSTXO9Xs/FZEDBYiP0klUU0+9gghDSE341uTiXQauNFY3n2GfuzkkDWbRyr6T033GxVTlIPa8/t/Vm5qRfhxqBx1s4PKcUp1DC6OwjGGbHg0wPvaejeYQLNd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0B0G3YRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0B0G3YRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA21C4CEF5;
	Tue,  8 Jul 2025 16:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993998;
	bh=qm7u/YJlranPD+Ad14LqIKYvvY0TGuOPv/wwDRYOcKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0B0G3YRfM0Y8SoTuFgo5ItRT/tROIhYO4S08goP9swyne2dCVMrYTgUzp7JWgoWDk
	 kr59KIe/bEAhKtWXJV06yIzr81XeGlby8Z3g5uS++aiZnK01rXwiP+hRJh3uTMb3IJ
	 KfadyS9l0ofN1LeP0H4erigIy7y4UoSSYwCEIzHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 090/160] media: uvcvideo: Rollback non processed entities on error
Date: Tue,  8 Jul 2025 18:22:07 +0200
Message-ID: <20250708162234.002852156@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/usb/uvc/uvc_ctrl.c |   40 +++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1697,7 +1697,7 @@ static int uvc_ctrl_commit_entity(struct
 	unsigned int processed_ctrls = 0;
 	struct uvc_control *ctrl;
 	unsigned int i;
-	int ret;
+	int ret = 0;
 
 	if (entity == NULL)
 		return 0;
@@ -1725,8 +1725,6 @@ static int uvc_ctrl_commit_entity(struct
 				dev->intfnum, ctrl->info.selector,
 				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
 				ctrl->info.size);
-		else
-			ret = 0;
 
 		if (!ret)
 			processed_ctrls++;
@@ -1738,17 +1736,24 @@ static int uvc_ctrl_commit_entity(struct
 
 		ctrl->dirty = 0;
 
-		if (ret < 0) {
+		if (!rollback && handle && !ret &&
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
-
-		if (!rollback && handle &&
-		    ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
-			uvc_ctrl_set_handle(handle, ctrl, handle);
 	}
 
+	if (ret)
+		return ret;
+
 	return processed_ctrls;
 }
 
@@ -1779,7 +1784,8 @@ int __uvc_ctrl_commit(struct uvc_fh *han
 	struct uvc_video_chain *chain = handle->chain;
 	struct uvc_control *err_ctrl;
 	struct uvc_entity *entity;
-	int ret = 0;
+	int ret_out = 0;
+	int ret;
 
 	/* Find the control. */
 	list_for_each_entry(entity, &chain->entities, chain) {
@@ -1790,17 +1796,23 @@ int __uvc_ctrl_commit(struct uvc_fh *han
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



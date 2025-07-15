Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B532D3732;
	Tue, 15 Jul 2025 13:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586623; cv=none; b=TCncrbDzT3eYVnBpfrjqr9FMWPFB3Q2p5DxCUDJW+WxuKl+O5aQTRaPppZDHROogKA0sTgoZZzycI2LgIZTFi9tsMdyBAEYh3gZlK4hE5UskO1OBFNYH0fGYfM5yWEh0NO1iUVZSLlN7Nn7a3TAd7uuc1tD9LHP6lN75eXbAyPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586623; c=relaxed/simple;
	bh=oyABSZCfX16jrXEfHeDx//T+sV1n1Ps4NgVOBeUDYfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/PjvrJVXkaLLiRWd0zfblm49/f4b6QFEOHJF9Q4Cgj6+OlInmrQxZpRTHcwmYSWXIn2+WqojmE6YS4p4Z9iRpcqt3Z8jZwLzhfyQXQXN8VCGTxxHtlM/CPrb7CZeNz29qPjk7vft3ELPNSjapnuniZqopUdhO61sAZ0Gb1GM+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vA/cGV7/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vA/cGV7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353EDC4CEE3;
	Tue, 15 Jul 2025 13:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586623;
	bh=oyABSZCfX16jrXEfHeDx//T+sV1n1Ps4NgVOBeUDYfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vA/cGV7/tilC0nNHBt4CrnCodd4HMyDpk2P08BV6XiK22uGL3IkFdLZtBI5Oth7Qc
	 iNv+nPjVVujaeW2z18DbSRe2ZHZt7C3bpVRi4E2HvJzXeS/4vrnEeqxwMRQKFGR4gV
	 LkJakpCKOF/HCZ3HVLZZdCFH8r4Nr2Auq3lhDxaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.4 104/148] media: uvcvideo: Rollback non processed entities on error
Date: Tue, 15 Jul 2025 15:13:46 +0200
Message-ID: <20250715130804.477540852@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/usb/uvc/uvc_ctrl.c |   42 ++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 14 deletions(-)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1577,7 +1577,7 @@ static int uvc_ctrl_commit_entity(struct
 	unsigned int processed_ctrls = 0;
 	struct uvc_control *ctrl;
 	unsigned int i;
-	int ret;
+	int ret = 0;
 
 	if (entity == NULL)
 		return 0;
@@ -1605,8 +1605,6 @@ static int uvc_ctrl_commit_entity(struct
 				dev->intfnum, ctrl->info.selector,
 				uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
 				ctrl->info.size);
-		else
-			ret = 0;
 
 		if (!ret)
 			processed_ctrls++;
@@ -1618,14 +1616,22 @@ static int uvc_ctrl_commit_entity(struct
 
 		ctrl->dirty = 0;
 
-		if (ret < 0)
-			return ret;
-
-		if (!rollback && handle &&
+		if (!rollback && handle && !ret &&
 		    ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
 			uvc_ctrl_set_handle(handle, ctrl, handle);
+
+		if (ret < 0 && !rollback) {
+			/*
+			 * If we fail to set a control, we need to rollback
+			 * the next ones.
+			 */
+			rollback = 1;
+		}
 	}
 
+	if (ret)
+		return ret;
+
 	return processed_ctrls;
 }
 
@@ -1635,23 +1641,31 @@ int __uvc_ctrl_commit(struct uvc_fh *han
 {
 	struct uvc_video_chain *chain = handle->chain;
 	struct uvc_entity *entity;
-	int ret = 0;
+	int ret_out = 0;
+	int ret;
 
 	/* Find the control. */
 	list_for_each_entry(entity, &chain->entities, chain) {
 		ret = uvc_ctrl_commit_entity(chain->dev, handle, entity,
 					     rollback);
-		if (ret < 0)
-			goto done;
-		else if (ret > 0 && !rollback)
+		if (ret < 0) {
+			/*
+			 * When we fail to commit an entity, we need to
+			 * restore the UVC_CTRL_DATA_BACKUP for all the
+			 * controls in the other entities, otherwise our cache
+			 * and the hardware will be out of sync.
+			 */
+			rollback = 1;
+
+			ret_out = ret;
+		} else if (ret > 0 && !rollback) {
 			uvc_ctrl_send_events(handle, entity, xctrls,
 					     xctrls_count);
+		}
 	}
 
-	ret = 0;
-done:
 	mutex_unlock(&chain->ctrl_mutex);
-	return ret;
+	return ret_out;
 }
 
 int uvc_ctrl_get(struct uvc_video_chain *chain,



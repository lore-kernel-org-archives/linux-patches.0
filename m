Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C489924EAB1;
	Mon, 23 Jun 2025 13:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686201; cv=none; b=F7KveCYTA3GlRkAAy9w5iYlhMr8y+6MwgumK3R0lZomKxYLi0srhphAUg5VMjxyyZUdaxdAe+b/PCpeakBieXTeMoftB3xmqdf32xylr80Uay2OSmthYFafv4viNlmsYiqWkQueCrvql05cWfu4ZTTRAITO2UAuZSm7L+Ghpdmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686201; c=relaxed/simple;
	bh=96J2x41KlZBCYPdxl1+/ZQNafqP17YTEt4dGbs12Gyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iA+fENgk3MfQqdFC5/UqsYpFQXcuv3dqtUwI6JdrRzsYvHxyNzAWYkqMIWArDTYHAvACuEPkAE3w/hFGtncVjo5GVoutGYNlb0qhSsyfyZ4t7bj0gsvg1KU+/rcCv86yeZ8EroDuw3Kj9grJ2E308vPSBwzteuWbf6gPvE2g1P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W38icsHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W38icsHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0055C4CEEA;
	Mon, 23 Jun 2025 13:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686200;
	bh=96J2x41KlZBCYPdxl1+/ZQNafqP17YTEt4dGbs12Gyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W38icsHJYKP0YY8yo05vx8W9fXfCCctXrvQ9yI+E+F4xMDhdscVfhSJGoQ0TsCcjm
	 4klQWuTBWkTDRq2YDTeUUCC5sumRXEeOFwXImoVZd4DBGe+eo0f7SvcNAnj+L/353a
	 oDnadANJ6QjSuhnRinRWrbtNadKeTB2rsOfHVlUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 046/290] media: uvcvideo: Return the number of processed controls
Date: Mon, 23 Jun 2025 15:05:07 +0200
Message-ID: <20250623130628.395004583@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

commit ba4fafb02ad6a4eb2e00f861893b5db42ba54369 upstream.

If we let know our callers that we have not done anything, they will be
able to optimize their decisions.

Cc: stable@kernel.org
Fixes: b4012002f3a3 ("[media] uvcvideo: Add support for control events")
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Message-ID: <20250224-uvc-data-backup-v2-1-de993ed9823b@chromium.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1783,12 +1783,17 @@ int uvc_ctrl_begin(struct uvc_video_chai
 	return mutex_lock_interruptible(&chain->ctrl_mutex) ? -ERESTARTSYS : 0;
 }
 
+/*
+ * Returns the number of uvc controls that have been correctly set, or a
+ * negative number if there has been an error.
+ */
 static int uvc_ctrl_commit_entity(struct uvc_device *dev,
 				  struct uvc_fh *handle,
 				  struct uvc_entity *entity,
 				  int rollback,
 				  struct uvc_control **err_ctrl)
 {
+	unsigned int processed_ctrls = 0;
 	struct uvc_control *ctrl;
 	unsigned int i;
 	int ret;
@@ -1823,6 +1828,9 @@ static int uvc_ctrl_commit_entity(struct
 		else
 			ret = 0;
 
+		if (!ret)
+			processed_ctrls++;
+
 		if (rollback || ret < 0)
 			memcpy(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
 			       uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
@@ -1841,7 +1849,7 @@ static int uvc_ctrl_commit_entity(struct
 			uvc_ctrl_set_handle(handle, ctrl, handle);
 	}
 
-	return 0;
+	return processed_ctrls;
 }
 
 static int uvc_ctrl_find_ctrl_idx(struct uvc_entity *entity,
@@ -1888,6 +1896,7 @@ int __uvc_ctrl_commit(struct uvc_fh *han
 
 	if (!rollback)
 		uvc_ctrl_send_events(handle, ctrls->controls, ctrls->count);
+	ret = 0;
 done:
 	mutex_unlock(&chain->ctrl_mutex);
 	return ret;



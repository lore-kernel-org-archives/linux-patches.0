Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E21A1E51FA;
	Mon, 23 Jun 2025 21:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713891; cv=none; b=FWSd7fOQxHryhrDZCz2n+YHdESbnO17E7QKwdHXEOhLQD8O7v4i3gT0Vs7wnXA4PRivOX3ThbpL+YREDYmAwYiRvr8EzXMejjUIBqaO9gl4aovqN6uSPkxyJvbNrre8pRxtv6cAQ3IRZmTEs6bari46kEOlN0iT9SYiPcmsjdhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713891; c=relaxed/simple;
	bh=PsJLo9Hsqqy7OAPDwv4jCOSj6Kl2+vndjO9JH1hBbAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQI3BDDKVrgCsb9pSMGaR5HUBvKYOZJdLYnAC28FLbFiIMWOvYZ44nbrtufVVoRsgvc2M1PdSTDL4xZi8ZbUaLTDujHXmwrx5F1i7pS3EwNwZf6vqUXVTPqRTk4s+nmBn8tc+Iggzk2UMjnqOgpvjQrfm4MPscuMVev03fI3+SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rbQYJfGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rbQYJfGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176B2C4CEEA;
	Mon, 23 Jun 2025 21:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713891;
	bh=PsJLo9Hsqqy7OAPDwv4jCOSj6Kl2+vndjO9JH1hBbAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rbQYJfGba6iBjzz3I+nPJLzL7O6CYmq2qn9asPs8GV+EnX1p4Rt+Ye50rk1BBrtH9
	 P7/b5Xw/OIWkjnVhZA70E+AIRD5XT/4U26cFxq/kaswNuzHOukjAXIVo19nZteSW9/
	 O/2hdmBs5oDfCYdrAg8fN/ILEB3UkMmlPnBtd4OA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 069/414] media: uvcvideo: Return the number of processed controls
Date: Mon, 23 Jun 2025 15:03:26 +0200
Message-ID: <20250623130643.797256854@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1830,12 +1830,17 @@ int uvc_ctrl_begin(struct uvc_video_chai
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
@@ -1870,6 +1875,9 @@ static int uvc_ctrl_commit_entity(struct
 		else
 			ret = 0;
 
+		if (!ret)
+			processed_ctrls++;
+
 		if (rollback || ret < 0)
 			memcpy(uvc_ctrl_data(ctrl, UVC_CTRL_DATA_CURRENT),
 			       uvc_ctrl_data(ctrl, UVC_CTRL_DATA_BACKUP),
@@ -1888,7 +1896,7 @@ static int uvc_ctrl_commit_entity(struct
 			uvc_ctrl_set_handle(handle, ctrl, handle);
 	}
 
-	return 0;
+	return processed_ctrls;
 }
 
 static int uvc_ctrl_find_ctrl_idx(struct uvc_entity *entity,
@@ -1935,6 +1943,7 @@ int __uvc_ctrl_commit(struct uvc_fh *han
 
 	if (!rollback)
 		uvc_ctrl_send_events(handle, ctrls->controls, ctrls->count);
+	ret = 0;
 done:
 	mutex_unlock(&chain->ctrl_mutex);
 	return ret;



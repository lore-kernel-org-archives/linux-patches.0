Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A672825DD00;
	Tue, 11 Mar 2025 15:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705688; cv=none; b=tICANb7H+1T8sZ9raJWy315E38jTMhCrljAGpoUjyG9XwQ4E7W6ZfYkSrz9eUHOlZ+qP1RDYMWVUO12TKLGpJwCTBrm5od1kTIR3cXKkpAiZhshIn1LNiMXFb38C9h32tm4zvvqAfauJj1d1ZhFxTYVmez/1mopfvTcY73eRpyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705688; c=relaxed/simple;
	bh=9ohtoDRh+b6L7uKZtupF6+iDy8wtV+TKsKUG+aDHK+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnB4kTxUQiHMxBjUyDexD10iwv5fvwJ27znTIJgRWHXlhvnIppdC7xySlVDm/U2VwLen1jXyjqOv4uKTwZjxri+LK4tKUvx9OnKPdBFfI0Tw9yurrrj0SJiAvT6YkLyPkyhgWoVyP15s+/p5Bma/HrENl9yvEEuXtwRIaNGY6WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+f638eU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+f638eU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8906EC4CEE9;
	Tue, 11 Mar 2025 15:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705688;
	bh=9ohtoDRh+b6L7uKZtupF6+iDy8wtV+TKsKUG+aDHK+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+f638eU6tC/mSFD7d2wBtovbUpJw7BmB4smif7nCfTiqDrGFUSSrpN8gRcTJ8KYh
	 vHEsvBcvYx7rp8cebD0TxEwupd9APDapHtleHGo/3pRBMx0qnGgZEY1UGptrvOS53S
	 X0QswAlEecguSOwQjfnDjCGV492VO8n/7xxgL59s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 101/328] media: uvcvideo: Remove dangling pointers
Date: Tue, 11 Mar 2025 15:57:51 +0100
Message-ID: <20250311145718.905962335@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

commit 221cd51efe4565501a3dbf04cc011b537dcce7fb upstream.

When an async control is written, we copy a pointer to the file handle
that started the operation. That pointer will be used when the device is
done. Which could be anytime in the future.

If the user closes that file descriptor, its structure will be freed,
and there will be one dangling pointer per pending async control, that
the driver will try to use.

Clean all the dangling pointers during release().

To avoid adding a performance penalty in the most common case (no async
operation), a counter has been introduced with some logic to make sure
that it is properly handled.

Cc: stable@vger.kernel.org
Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20241203-uvc-fix-async-v6-3-26c867231118@chromium.org
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c |   63 +++++++++++++++++++++++++++++++++++++--
 drivers/media/usb/uvc/uvc_v4l2.c |    2 +
 drivers/media/usb/uvc/uvcvideo.h |    9 ++++-
 3 files changed, 71 insertions(+), 3 deletions(-)

--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1306,6 +1306,40 @@ static void uvc_ctrl_send_slave_event(st
 	uvc_ctrl_send_event(chain, handle, ctrl, mapping, val, changes);
 }
 
+static void uvc_ctrl_set_handle(struct uvc_fh *handle, struct uvc_control *ctrl,
+				struct uvc_fh *new_handle)
+{
+	lockdep_assert_held(&handle->chain->ctrl_mutex);
+
+	if (new_handle) {
+		if (ctrl->handle)
+			dev_warn_ratelimited(&handle->stream->dev->udev->dev,
+					     "UVC non compliance: Setting an async control with a pending operation.");
+
+		if (new_handle == ctrl->handle)
+			return;
+
+		if (ctrl->handle) {
+			WARN_ON(!ctrl->handle->pending_async_ctrls);
+			if (ctrl->handle->pending_async_ctrls)
+				ctrl->handle->pending_async_ctrls--;
+		}
+
+		ctrl->handle = new_handle;
+		handle->pending_async_ctrls++;
+		return;
+	}
+
+	/* Cannot clear the handle for a control not owned by us.*/
+	if (WARN_ON(ctrl->handle != handle))
+		return;
+
+	ctrl->handle = NULL;
+	if (WARN_ON(!handle->pending_async_ctrls))
+		return;
+	handle->pending_async_ctrls--;
+}
+
 void uvc_ctrl_status_event(struct uvc_video_chain *chain,
 			   struct uvc_control *ctrl, const u8 *data)
 {
@@ -1316,7 +1350,8 @@ void uvc_ctrl_status_event(struct uvc_vi
 	mutex_lock(&chain->ctrl_mutex);
 
 	handle = ctrl->handle;
-	ctrl->handle = NULL;
+	if (handle)
+		uvc_ctrl_set_handle(handle, ctrl, NULL);
 
 	list_for_each_entry(mapping, &ctrl->info.mappings, list) {
 		s32 value = __uvc_ctrl_get_value(mapping, data);
@@ -1577,7 +1612,7 @@ static int uvc_ctrl_commit_entity(struct
 
 		if (!rollback && handle &&
 		    ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
-			ctrl->handle = handle;
+			uvc_ctrl_set_handle(handle, ctrl, handle);
 	}
 
 	return 0;
@@ -2378,6 +2413,30 @@ int uvc_ctrl_init_device(struct uvc_devi
 	return 0;
 }
 
+void uvc_ctrl_cleanup_fh(struct uvc_fh *handle)
+{
+	struct uvc_entity *entity;
+
+	mutex_lock(&handle->chain->ctrl_mutex);
+
+	if (!handle->pending_async_ctrls) {
+		mutex_unlock(&handle->chain->ctrl_mutex);
+		return;
+	}
+
+	list_for_each_entry(entity, &handle->chain->dev->entities, list) {
+		unsigned int i;
+		for (i = 0; i < entity->ncontrols; ++i) {
+			if (entity->controls[i].handle != handle)
+				continue;
+			uvc_ctrl_set_handle(handle, &entity->controls[i], NULL);
+		}
+	}
+
+	WARN_ON(handle->pending_async_ctrls);
+	mutex_unlock(&handle->chain->ctrl_mutex);
+}
+
 /*
  * Cleanup device controls.
  */
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -589,6 +589,8 @@ static int uvc_v4l2_release(struct file
 
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_release\n");
 
+	uvc_ctrl_cleanup_fh(handle);
+
 	/* Only free resources if this is a privileged handle. */
 	if (uvc_has_privileges(handle))
 		uvc_queue_release(&stream->queue);
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -447,7 +447,11 @@ struct uvc_video_chain {
 	struct uvc_entity *processing;		/* Processing unit */
 	struct uvc_entity *selector;		/* Selector unit */
 
-	struct mutex ctrl_mutex;		/* Protects ctrl.info */
+	struct mutex ctrl_mutex;		/*
+						 * Protects ctrl.info,
+						 * ctrl.handle and
+						 * uvc_fh.pending_async_ctrls
+						 */
 
 	struct v4l2_prio_state prio;		/* V4L2 priority state */
 	u32 caps;				/* V4L2 chain-wide caps */
@@ -693,6 +697,7 @@ struct uvc_fh {
 	struct uvc_video_chain *chain;
 	struct uvc_streaming *stream;
 	enum uvc_handle_state state;
+	unsigned int pending_async_ctrls;
 };
 
 struct uvc_driver {
@@ -865,6 +870,8 @@ int uvc_ctrl_set(struct uvc_fh *handle,
 int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 		      struct uvc_xu_control_query *xqry);
 
+void uvc_ctrl_cleanup_fh(struct uvc_fh *handle);
+
 /* Utility functions */
 void uvc_simplify_fraction(u32 *numerator, u32 *denominator,
 			   unsigned int n_terms, unsigned int threshold);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD252EF66B;
	Thu,  3 Jul 2025 15:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554812; cv=none; b=dTwdeC9CLLfQxpJynsIupIUA42xQxZJ1c2X4W5dvLu32Hv3ociNo205G3QfjyJnbGfXfMNwAiG8wuRwlemu64qu4vLikvUqXAlegKMT5iTRjLwJuJyz39/heNn2Gg5iYR/xdmXOYk6WMinY2sHvLKBfwXOi6X17H72cBGg+Shxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554812; c=relaxed/simple;
	bh=apBJtU6D0KgXbpBbFIEmxL85GuW1VIXgyHcIHd3+RrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMP7f2v3tNE2jCUQhii/nhIw6q7bKQ5d3K+/nXB9ddWd0MC2adb7dsd7HURMb+2C4Yy5ArSMlWGnvY0heOpttSA6oYyx/wC6gCZKHL0Stwl+Oh59MNg0P8n6Ydwh/TF183w5mepFbC2FO6JbFIGG27kEXrpohrSMpWuO6NePUyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RTYy2L+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RTYy2L+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C090BC4CEE3;
	Thu,  3 Jul 2025 15:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554812;
	bh=apBJtU6D0KgXbpBbFIEmxL85GuW1VIXgyHcIHd3+RrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RTYy2L+yg+zQiMY5QUYBG6Ho/O/4N0mQmRF3oEGJ+96qHg1jCO5ppmFqzfNoRuQ9
	 P8NQwOcT4ti5NMDEYTKS9UssMyEmBWbwxcSX2C7S2+EhoqjJ77yDEb6Ubhmh8R71fE
	 RY5myMJUUtm7L9H5pQXF3YjKO9zh01ZWcRXrIR3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 086/263] media: uvcvideo: Increase/decrease the PM counter per IOCTL
Date: Thu,  3 Jul 2025 16:40:06 +0200
Message-ID: <20250703144007.752903371@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 10acb9101355484c3e4f2625003cd1b6c203cfe4 ]

Now we call uvc_pm_get/put from the device open/close. This low
level of granularity might leave the camera powered on in situations
where it is not needed.

Increase the granularity by increasing and decreasing the Power
Management counter per ioctl. There are two special cases where the
power management outlives the ioctl: async controls and streamon. Handle
those cases as well.

In a future patch, we will remove the uvc_pm_get/put from open/close.

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Message-ID: <20250327-uvc-granpower-ng-v6-3-35a2357ff348@chromium.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Stable-dep-of: a70705d3c020 ("media: uvcvideo: Rollback non processed entities on error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 38 ++++++++++++++++++++++---------
 drivers/media/usb/uvc/uvc_v4l2.c | 39 ++++++++++++++++++++++++++++++--
 2 files changed, 64 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index bc7e2005fc6c7..636ce1eb2a6bf 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1812,38 +1812,49 @@ static void uvc_ctrl_send_slave_event(struct uvc_video_chain *chain,
 	uvc_ctrl_send_event(chain, handle, ctrl, mapping, val, changes);
 }
 
-static void uvc_ctrl_set_handle(struct uvc_fh *handle, struct uvc_control *ctrl,
-				struct uvc_fh *new_handle)
+static int uvc_ctrl_set_handle(struct uvc_fh *handle, struct uvc_control *ctrl,
+			       struct uvc_fh *new_handle)
 {
 	lockdep_assert_held(&handle->chain->ctrl_mutex);
 
 	if (new_handle) {
+		int ret;
+
 		if (ctrl->handle)
 			dev_warn_ratelimited(&handle->stream->dev->udev->dev,
 					     "UVC non compliance: Setting an async control with a pending operation.");
 
 		if (new_handle == ctrl->handle)
-			return;
+			return 0;
 
 		if (ctrl->handle) {
 			WARN_ON(!ctrl->handle->pending_async_ctrls);
 			if (ctrl->handle->pending_async_ctrls)
 				ctrl->handle->pending_async_ctrls--;
+			ctrl->handle = new_handle;
+			handle->pending_async_ctrls++;
+			return 0;
 		}
 
+		ret = uvc_pm_get(handle->chain->dev);
+		if (ret)
+			return ret;
+
 		ctrl->handle = new_handle;
 		handle->pending_async_ctrls++;
-		return;
+		return 0;
 	}
 
 	/* Cannot clear the handle for a control not owned by us.*/
 	if (WARN_ON(ctrl->handle != handle))
-		return;
+		return -EINVAL;
 
 	ctrl->handle = NULL;
 	if (WARN_ON(!handle->pending_async_ctrls))
-		return;
+		return -EINVAL;
 	handle->pending_async_ctrls--;
+	uvc_pm_put(handle->chain->dev);
+	return 0;
 }
 
 void uvc_ctrl_status_event(struct uvc_video_chain *chain,
@@ -2150,15 +2161,15 @@ static int uvc_ctrl_commit_entity(struct uvc_device *dev,
 
 		ctrl->dirty = 0;
 
+		if (!rollback && handle && !ret &&
+		    ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
+			ret = uvc_ctrl_set_handle(handle, ctrl, handle);
+
 		if (ret < 0) {
 			if (err_ctrl)
 				*err_ctrl = ctrl;
 			return ret;
 		}
-
-		if (!rollback && handle &&
-		    ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS)
-			uvc_ctrl_set_handle(handle, ctrl, handle);
 	}
 
 	return processed_ctrls;
@@ -3237,6 +3248,7 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 void uvc_ctrl_cleanup_fh(struct uvc_fh *handle)
 {
 	struct uvc_entity *entity;
+	int i;
 
 	guard(mutex)(&handle->chain->ctrl_mutex);
 
@@ -3251,7 +3263,11 @@ void uvc_ctrl_cleanup_fh(struct uvc_fh *handle)
 		}
 	}
 
-	WARN_ON(handle->pending_async_ctrls);
+	if (!WARN_ON(handle->pending_async_ctrls))
+		return;
+
+	for (i = 0; i < handle->pending_async_ctrls; i++)
+		uvc_pm_put(handle->stream->dev);
 }
 
 /*
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 1d5be045d04ec..8bccf7e17528b 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -697,6 +697,9 @@ static int uvc_v4l2_release(struct file *file)
 	if (uvc_has_privileges(handle))
 		uvc_queue_release(&stream->queue);
 
+	if (handle->is_streaming)
+		uvc_pm_put(stream->dev);
+
 	/* Release the file handle. */
 	uvc_dismiss_privileges(handle);
 	v4l2_fh_del(&handle->vfh);
@@ -862,6 +865,11 @@ static int uvc_ioctl_streamon(struct file *file, void *fh,
 	if (ret)
 		return ret;
 
+	ret = uvc_pm_get(stream->dev);
+	if (ret) {
+		uvc_queue_streamoff(&stream->queue, type);
+		return ret;
+	}
 	handle->is_streaming = true;
 
 	return 0;
@@ -879,7 +887,10 @@ static int uvc_ioctl_streamoff(struct file *file, void *fh,
 	guard(mutex)(&stream->mutex);
 
 	uvc_queue_streamoff(&stream->queue, type);
-	handle->is_streaming = false;
+	if (handle->is_streaming) {
+		handle->is_streaming = false;
+		uvc_pm_put(stream->dev);
+	}
 
 	return 0;
 }
@@ -1378,9 +1389,11 @@ static int uvc_v4l2_put_xu_query(const struct uvc_xu_control_query *kp,
 #define UVCIOC_CTRL_MAP32	_IOWR('u', 0x20, struct uvc_xu_control_mapping32)
 #define UVCIOC_CTRL_QUERY32	_IOWR('u', 0x21, struct uvc_xu_control_query32)
 
+DEFINE_FREE(uvc_pm_put, struct uvc_device *, if (_T) uvc_pm_put(_T))
 static long uvc_v4l2_compat_ioctl32(struct file *file,
 		     unsigned int cmd, unsigned long arg)
 {
+	struct uvc_device *uvc_device __free(uvc_pm_put) = NULL;
 	struct uvc_fh *handle = file->private_data;
 	union {
 		struct uvc_xu_control_mapping xmap;
@@ -1389,6 +1402,12 @@ static long uvc_v4l2_compat_ioctl32(struct file *file,
 	void __user *up = compat_ptr(arg);
 	long ret;
 
+	ret = uvc_pm_get(handle->stream->dev);
+	if (ret)
+		return ret;
+
+	uvc_device = handle->stream->dev;
+
 	switch (cmd) {
 	case UVCIOC_CTRL_MAP32:
 		ret = uvc_v4l2_get_xu_mapping(&karg.xmap, up);
@@ -1423,6 +1442,22 @@ static long uvc_v4l2_compat_ioctl32(struct file *file,
 }
 #endif
 
+static long uvc_v4l2_unlocked_ioctl(struct file *file,
+				    unsigned int cmd, unsigned long arg)
+{
+	struct uvc_fh *handle = file->private_data;
+	int ret;
+
+	ret = uvc_pm_get(handle->stream->dev);
+	if (ret)
+		return ret;
+
+	ret = video_ioctl2(file, cmd, arg);
+
+	uvc_pm_put(handle->stream->dev);
+	return ret;
+}
+
 static ssize_t uvc_v4l2_read(struct file *file, char __user *data,
 		    size_t count, loff_t *ppos)
 {
@@ -1507,7 +1542,7 @@ const struct v4l2_file_operations uvc_fops = {
 	.owner		= THIS_MODULE,
 	.open		= uvc_v4l2_open,
 	.release	= uvc_v4l2_release,
-	.unlocked_ioctl	= video_ioctl2,
+	.unlocked_ioctl	= uvc_v4l2_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl32	= uvc_v4l2_compat_ioctl32,
 #endif
-- 
2.39.5




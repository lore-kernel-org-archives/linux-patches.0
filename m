Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC873D9053;
	Wed,  8 Apr 2026 18:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674087; cv=none; b=XPTOBCWmK6mdmWXetvmx3lecF++b3vpSmvnvWtdlGOX/Ce0ln2aulN5XcfkPSUYSnGz+m8f9zx8WqXZLdPsowMzA9Yllo+cLNPffCTyrlgYh+NKiVp58VE14n4R/XGC38iMEVJ5ubhhKIXG3wzfR26ODG9LmJ1zPbCADCDWGnHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674087; c=relaxed/simple;
	bh=6S7JnAdqSJ35caa8RwDCvQ3KCGnjWN4uuLmHwgJX/xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYTPaghZyw0NjuwnaU+wN3Cc1CrAOF3W8sLziUVY8JPYWHizy+OBByYjdHXN0b+B5TA4swD0AMBrexDlEp23c213oU0iZ3BPyM7DgLQATTCaRMChPOuzqnUU5kfX4He56pcR6R5ogVNVW8u5aqOWHX0yhxk73Xxk2omgugdbFJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zoc53g5J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zoc53g5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4AE8C19421;
	Wed,  8 Apr 2026 18:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674087;
	bh=6S7JnAdqSJ35caa8RwDCvQ3KCGnjWN4uuLmHwgJX/xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zoc53g5Jz6r0YtEOY4CKe/KZTaC7rJwtaHcw+vvEm43Jn6FzxWE4ozmVADE8Bdag1
	 5t+v948pZzdEm/f4s97PQ3TS+SOqJb2tHhoEI6eOhvnFeWLWnnF8XOVIxkgyhtVIV4
	 3/08vrrcOav++0tsqFJb+ofzMeNjywCvuJov57/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Jimmy Hu <hhhuuu@google.com>
Subject: [PATCH 6.12 203/242] usb: gadget: uvc: fix NULL pointer dereference during unbind race
Date: Wed,  8 Apr 2026 20:04:03 +0200
Message-ID: <20260408175934.678871882@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jimmy Hu <hhhuuu@google.com>

commit eba2936bbe6b752a31725a9eb5c674ecbf21ee7d upstream.

Commit b81ac4395bbe ("usb: gadget: uvc: allow for application to cleanly
shutdown") introduced two stages of synchronization waits totaling 1500ms
in uvc_function_unbind() to prevent several types of kernel panics.
However, this timing-based approach is insufficient during power
management (PM) transitions.

When the PM subsystem starts freezing user space processes, the
wait_event_interruptible_timeout() is aborted early, which allows the
unbind thread to proceed and nullify the gadget pointer
(cdev->gadget = NULL):

[  814.123447][  T947] configfs-gadget.g1 gadget.0: uvc: uvc_function_unbind()
[  814.178583][ T3173] PM: suspend entry (deep)
[  814.192487][ T3173] Freezing user space processes
[  814.197668][  T947] configfs-gadget.g1 gadget.0: uvc: uvc_function_unbind no clean disconnect, wait for release

When the PM subsystem resumes or aborts the suspend and tasks are
restarted, the V4L2 release path is executed and attempts to access the
already nullified gadget pointer, triggering a kernel panic:

[  814.292597][    C0] PM: pm_system_irq_wakeup: 479 triggered dhdpcie_host_wake
[  814.386727][ T3173] Restarting tasks ...
[  814.403522][ T4558] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000030
[  814.404021][ T4558] pc : usb_gadget_deactivate+0x14/0xf4
[  814.404031][ T4558] lr : usb_function_deactivate+0x54/0x94
[  814.404078][ T4558] Call trace:
[  814.404080][ T4558]  usb_gadget_deactivate+0x14/0xf4
[  814.404083][ T4558]  usb_function_deactivate+0x54/0x94
[  814.404087][ T4558]  uvc_function_disconnect+0x1c/0x5c
[  814.404092][ T4558]  uvc_v4l2_release+0x44/0xac
[  814.404095][ T4558]  v4l2_release+0xcc/0x130

Address the race condition and NULL pointer dereference by:

1. State Synchronization (flag + mutex)
Introduce a 'func_unbound' flag in struct uvc_device. This allows
uvc_function_disconnect() to safely skip accessing the nullified
cdev->gadget pointer. As suggested by Alan Stern, this flag is protected
by a new mutex (uvc->lock) to ensure proper memory ordering and prevent
instruction reordering or speculative loads. This mutex is also used to
protect 'func_connected' for consistent state management.

2. Explicit Synchronization (completion)
Use a completion to synchronize uvc_function_unbind() with the
uvc_vdev_release() callback. This prevents Use-After-Free (UAF) by
ensuring struct uvc_device is freed after all video device resources
are released.

Fixes: b81ac4395bbe ("usb: gadget: uvc: allow for application to cleanly shutdown")
Cc: stable <stable@kernel.org>
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jimmy Hu <hhhuuu@google.com>
Link: https://patch.msgid.link/20260320065427.1374555-1-hhhuuu@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uvc.c    |   39 ++++++++++++++++++++++++++++++---
 drivers/usb/gadget/function/uvc.h      |    3 ++
 drivers/usb/gadget/function/uvc_v4l2.c |    5 +++-
 3 files changed, 43 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -409,6 +409,12 @@ uvc_function_disconnect(struct uvc_devic
 {
 	int ret;
 
+	guard(mutex)(&uvc->lock);
+	if (uvc->func_unbound) {
+		dev_dbg(&uvc->vdev.dev, "skipping function deactivate (unbound)\n");
+		return;
+	}
+
 	if ((ret = usb_function_deactivate(&uvc->func)) < 0)
 		uvcg_info(&uvc->func, "UVC disconnect failed with %d\n", ret);
 }
@@ -427,6 +433,15 @@ static ssize_t function_name_show(struct
 
 static DEVICE_ATTR_RO(function_name);
 
+static void uvc_vdev_release(struct video_device *vdev)
+{
+	struct uvc_device *uvc = video_get_drvdata(vdev);
+
+	/* Signal uvc_function_unbind() that the video device has been released */
+	if (uvc->vdev_release_done)
+		complete(uvc->vdev_release_done);
+}
+
 static int
 uvc_register_video(struct uvc_device *uvc)
 {
@@ -439,7 +454,7 @@ uvc_register_video(struct uvc_device *uv
 	uvc->vdev.v4l2_dev->dev = &cdev->gadget->dev;
 	uvc->vdev.fops = &uvc_v4l2_fops;
 	uvc->vdev.ioctl_ops = &uvc_v4l2_ioctl_ops;
-	uvc->vdev.release = video_device_release_empty;
+	uvc->vdev.release = uvc_vdev_release;
 	uvc->vdev.vfl_dir = VFL_DIR_TX;
 	uvc->vdev.lock = &uvc->video.mutex;
 	uvc->vdev.device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
@@ -655,6 +670,8 @@ uvc_function_bind(struct usb_configurati
 	int ret = -EINVAL;
 
 	uvcg_info(f, "%s()\n", __func__);
+	scoped_guard(mutex, &uvc->lock)
+		uvc->func_unbound = false;
 
 	opts = fi_to_f_uvc_opts(f->fi);
 	/* Sanity check the streaming endpoint module parameters. */
@@ -984,12 +1001,19 @@ static void uvc_free(struct usb_function
 static void uvc_function_unbind(struct usb_configuration *c,
 				struct usb_function *f)
 {
+	DECLARE_COMPLETION_ONSTACK(vdev_release_done);
 	struct usb_composite_dev *cdev = c->cdev;
 	struct uvc_device *uvc = to_uvc(f);
 	struct uvc_video *video = &uvc->video;
 	long wait_ret = 1;
+	bool connected;
 
 	uvcg_info(f, "%s()\n", __func__);
+	scoped_guard(mutex, &uvc->lock) {
+		uvc->func_unbound = true;
+		uvc->vdev_release_done = &vdev_release_done;
+		connected = uvc->func_connected;
+	}
 
 	if (video->async_wq)
 		destroy_workqueue(video->async_wq);
@@ -1000,7 +1024,7 @@ static void uvc_function_unbind(struct u
 	 * though the video device removal uevent. Allow some time for the
 	 * application to close out before things get deleted.
 	 */
-	if (uvc->func_connected) {
+	if (connected) {
 		uvcg_dbg(f, "waiting for clean disconnect\n");
 		wait_ret = wait_event_interruptible_timeout(uvc->func_connected_queue,
 				uvc->func_connected == false, msecs_to_jiffies(500));
@@ -1011,7 +1035,10 @@ static void uvc_function_unbind(struct u
 	video_unregister_device(&uvc->vdev);
 	v4l2_device_unregister(&uvc->v4l2_dev);
 
-	if (uvc->func_connected) {
+	scoped_guard(mutex, &uvc->lock)
+		connected = uvc->func_connected;
+
+	if (connected) {
 		/*
 		 * Wait for the release to occur to ensure there are no longer any
 		 * pending operations that may cause panics when resources are cleaned
@@ -1023,6 +1050,10 @@ static void uvc_function_unbind(struct u
 		uvcg_dbg(f, "done waiting for release with ret: %ld\n", wait_ret);
 	}
 
+	/* Wait for the video device to be released */
+	wait_for_completion(&vdev_release_done);
+	uvc->vdev_release_done = NULL;
+
 	usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
 	kfree(uvc->control_buf);
 
@@ -1041,6 +1072,8 @@ static struct usb_function *uvc_alloc(st
 		return ERR_PTR(-ENOMEM);
 
 	mutex_init(&uvc->video.mutex);
+	mutex_init(&uvc->lock);
+	uvc->func_unbound = true;
 	uvc->state = UVC_STATE_DISCONNECTED;
 	init_waitqueue_head(&uvc->func_connected_queue);
 	opts = fi_to_f_uvc_opts(fi);
--- a/drivers/usb/gadget/function/uvc.h
+++ b/drivers/usb/gadget/function/uvc.h
@@ -141,6 +141,9 @@ struct uvc_device {
 	enum uvc_state state;
 	struct usb_function func;
 	struct uvc_video video;
+	struct completion *vdev_release_done;
+	struct mutex lock;	/* protects func_unbound and func_connected */
+	bool func_unbound;
 	bool func_connected;
 	wait_queue_head_t func_connected_queue;
 
--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -512,6 +512,8 @@ uvc_v4l2_subscribe_event(struct v4l2_fh
 	if (sub->type < UVC_EVENT_FIRST || sub->type > UVC_EVENT_LAST)
 		return -EINVAL;
 
+	guard(mutex)(&uvc->lock);
+
 	if (sub->type == UVC_EVENT_SETUP && uvc->func_connected)
 		return -EBUSY;
 
@@ -533,7 +535,8 @@ static void uvc_v4l2_disable(struct uvc_
 	uvc_function_disconnect(uvc);
 	uvcg_video_disable(&uvc->video);
 	uvcg_free_buffers(&uvc->video.queue);
-	uvc->func_connected = false;
+	scoped_guard(mutex, &uvc->lock)
+		uvc->func_connected = false;
 	wake_up_interruptible(&uvc->func_connected_queue);
 }
 



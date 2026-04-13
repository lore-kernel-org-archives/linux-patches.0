Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A1523D7E3;
	Mon, 13 Apr 2026 16:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096210; cv=none; b=qapnWCQi072TG0sUwvzgQILFpgdr1KktGZf467S9zssFWlimP0qThpQqFlFw4YdkYxGE2xuMm+3kEpiylu0aZbz58nLpwxjTf412Ip4tnVIbYp4k0w9CahkQz3BqRcqIAFdPzK8KUanVam+/S5HtEAmRfz5K8O4aQ2vUezHBCds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096210; c=relaxed/simple;
	bh=DrPodDri3dOFgT1RoDBeYEe15L7RVpZevOLf4hHcmwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaDA6cS4pxxHTF6hrdYcP3PPiY9aUvKFmKS/2fL7o2jSmyW57kFYURuas0YZGRwAC2l+t74dSwqlJQJpT7sQ8MkQdPU45QLgHM7AqfyJzu6AichWGW/j4PH/79eQm8NmKsX/51WrwVNJD15/AEeTXYAqr0nvpmfXB6Y/NY3kq1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxH+eFkS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxH+eFkS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D41C2BCAF;
	Mon, 13 Apr 2026 16:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096209;
	bh=DrPodDri3dOFgT1RoDBeYEe15L7RVpZevOLf4hHcmwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxH+eFkSVndLmB2+Hl78HJs37rbydhbqfy5whWxgB5tbdgCmez0l9krsjwaz4WuQ+
	 sRvga45qzxVTAr45ESAvUouMXwZkA7+aPB9lBPYa+1agc5GjnE50Q5w4n0mavEs95A
	 e/6aMROonfGI/WSJywgfA2uY3gsA90P3Owa4QAEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.19 10/86] Input: uinput - fix circular locking dependency with ff-core
Date: Mon, 13 Apr 2026 17:59:17 +0200
Message-ID: <20260413155731.958938220@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
References: <20260413155731.568515178@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

commit 4cda78d6f8bf2b700529f2fbccb994c3e826d7c2 upstream.

A lockdep circular locking dependency warning can be triggered
reproducibly when using a force-feedback gamepad with uinput (for
example, playing ELDEN RING under Wine with a Flydigi Vader 5
controller):

  ff->mutex -> udev->mutex -> input_mutex -> dev->mutex -> ff->mutex

The cycle is caused by four lock acquisition paths:

1. ff upload: input_ff_upload() holds ff->mutex and calls
   uinput_dev_upload_effect() -> uinput_request_submit() ->
   uinput_request_send(), which acquires udev->mutex.

2. device create: uinput_ioctl_handler() holds udev->mutex and calls
   uinput_create_device() -> input_register_device(), which acquires
   input_mutex.

3. device register: input_register_device() holds input_mutex and
   calls kbd_connect() -> input_register_handle(), which acquires
   dev->mutex.

4. evdev release: evdev_release() calls input_flush_device() under
   dev->mutex, which calls input_ff_flush() acquiring ff->mutex.

Fix this by introducing a new state_lock spinlock to protect
udev->state and udev->dev access in uinput_request_send() instead of
acquiring udev->mutex.  The function only needs to atomically check
device state and queue an input event into the ring buffer via
uinput_dev_event() -- both operations are safe under a spinlock
(ktime_get_ts64() and wake_up_interruptible() do not sleep).  This
breaks the ff->mutex -> udev->mutex link since a spinlock is a leaf in
the lock ordering and cannot form cycles with mutexes.

To keep state transitions visible to uinput_request_send(), protect
writes to udev->state in uinput_create_device() and
uinput_destroy_device() with the same state_lock spinlock.

Additionally, move init_completion(&request->done) from
uinput_request_send() to uinput_request_submit() before
uinput_request_reserve_slot().  Once the slot is allocated,
uinput_flush_requests() may call complete() on it at any time from
the destroy path, so the completion must be initialised before the
request becomes visible.

Lock ordering after the fix:

  ff->mutex -> state_lock (spinlock, leaf)
  udev->mutex -> state_lock (spinlock, leaf)
  udev->mutex -> input_mutex -> dev->mutex -> ff->mutex (no back-edge)

Fixes: ff462551235d ("Input: uinput - switch to the new FF interface")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/CABXGCsMoxag+kEwHhb7KqhuyxfmGGd0P=tHZyb1uKE0pLr8Hkg@mail.gmail.com/
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Link: https://patch.msgid.link/20260407075031.38351-1-mikhail.v.gavrilov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/uinput.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -57,6 +57,7 @@ struct uinput_device {
 	struct input_dev	*dev;
 	struct mutex		mutex;
 	enum uinput_state	state;
+	spinlock_t		state_lock;
 	wait_queue_head_t	waitq;
 	unsigned char		ready;
 	unsigned char		head;
@@ -146,19 +147,15 @@ static void uinput_request_release_slot(
 static int uinput_request_send(struct uinput_device *udev,
 			       struct uinput_request *request)
 {
-	int retval;
+	int retval = 0;
 
-	retval = mutex_lock_interruptible(&udev->mutex);
-	if (retval)
-		return retval;
+	spin_lock(&udev->state_lock);
 
 	if (udev->state != UIST_CREATED) {
 		retval = -ENODEV;
 		goto out;
 	}
 
-	init_completion(&request->done);
-
 	/*
 	 * Tell our userspace application about this new request
 	 * by queueing an input event.
@@ -166,7 +163,7 @@ static int uinput_request_send(struct ui
 	uinput_dev_event(udev->dev, EV_UINPUT, request->code, request->id);
 
  out:
-	mutex_unlock(&udev->mutex);
+	spin_unlock(&udev->state_lock);
 	return retval;
 }
 
@@ -175,6 +172,13 @@ static int uinput_request_submit(struct
 {
 	int retval;
 
+	/*
+	 * Initialize completion before allocating the request slot.
+	 * Once the slot is allocated, uinput_flush_requests() may
+	 * complete it at any time, so it must be initialized first.
+	 */
+	init_completion(&request->done);
+
 	retval = uinput_request_reserve_slot(udev, request);
 	if (retval)
 		return retval;
@@ -289,7 +293,14 @@ static void uinput_destroy_device(struct
 	struct input_dev *dev = udev->dev;
 	enum uinput_state old_state = udev->state;
 
+	/*
+	 * Update state under state_lock so that concurrent
+	 * uinput_request_send() sees the state change before we
+	 * flush pending requests and tear down the device.
+	 */
+	spin_lock(&udev->state_lock);
 	udev->state = UIST_NEW_DEVICE;
+	spin_unlock(&udev->state_lock);
 
 	if (dev) {
 		name = dev->name;
@@ -366,7 +377,9 @@ static int uinput_create_device(struct u
 	if (error)
 		goto fail2;
 
+	spin_lock(&udev->state_lock);
 	udev->state = UIST_CREATED;
+	spin_unlock(&udev->state_lock);
 
 	return 0;
 
@@ -384,6 +397,7 @@ static int uinput_open(struct inode *ino
 		return -ENOMEM;
 
 	mutex_init(&newdev->mutex);
+	spin_lock_init(&newdev->state_lock);
 	spin_lock_init(&newdev->requests_lock);
 	init_waitqueue_head(&newdev->requests_waitq);
 	init_waitqueue_head(&newdev->waitq);



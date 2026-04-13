Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF6B2D8364;
	Mon, 13 Apr 2026 16:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098468; cv=none; b=sW672d4dIVY3K0iyu0nwrbAqcaVC+fUwerI0FNPfhVFO9YCNYmp5/U2XGi4WB9mSMq2opdopgOqgdeJmXz7MQybWIuVBOpuMLO65df0TLpew6WgyEYtQPNiLhY/SrgxB1n/VXiDbCe1r9mvMKZfrEv1P6r6OttcCaKZXEreQVrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098468; c=relaxed/simple;
	bh=3jgVc+2Uc4Qpg6JvdiNooSHfE8ouVipG7Uf1/t/BnvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UR6kWakExFw5anXvC64BZXnWLyzxgH1cniI7sGS7VD5ahE8LOzMV8cD306KOg8onc3VhD9duZBTFRGSk6Ua4b8XldLYF4pwkLBJBmsSBRaiHba18FlqkJAREDpmZQAb6qWTv6SS+WH7ZErVUDF+k5SwIBaHPbY8c0R3Kne2BeCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+jOvKOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+jOvKOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5251DC2BCAF;
	Mon, 13 Apr 2026 16:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098468;
	bh=3jgVc+2Uc4Qpg6JvdiNooSHfE8ouVipG7Uf1/t/BnvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U+jOvKOiF240cgBUN5L0SQkrIrqC4jiqGXfVPg4YLSfBP2+NfH6tGvQxQezH2v+sd
	 sU2lS8OWXbTvvcgtnmx+x+ukKlQ0nMxCB2+KqjzTm0MA6AdcLFhLJQTx3Q7quLk30n
	 d3vaHcEUfmV8bZdr5vokp4egu51ABVvBGt7K79JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 509/570] Input: uinput - fix circular locking dependency with ff-core
Date: Mon, 13 Apr 2026 18:00:40 +0200
Message-ID: <20260413155849.518647674@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -56,6 +56,7 @@ struct uinput_device {
 	struct input_dev	*dev;
 	struct mutex		mutex;
 	enum uinput_state	state;
+	spinlock_t		state_lock;
 	wait_queue_head_t	waitq;
 	unsigned char		ready;
 	unsigned char		head;
@@ -145,19 +146,15 @@ static void uinput_request_release_slot(
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
@@ -165,7 +162,7 @@ static int uinput_request_send(struct ui
 	uinput_dev_event(udev->dev, EV_UINPUT, request->code, request->id);
 
  out:
-	mutex_unlock(&udev->mutex);
+	spin_unlock(&udev->state_lock);
 	return retval;
 }
 
@@ -174,6 +171,13 @@ static int uinput_request_submit(struct
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
@@ -288,7 +292,14 @@ static void uinput_destroy_device(struct
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
@@ -365,7 +376,9 @@ static int uinput_create_device(struct u
 	if (error)
 		goto fail2;
 
+	spin_lock(&udev->state_lock);
 	udev->state = UIST_CREATED;
+	spin_unlock(&udev->state_lock);
 
 	return 0;
 
@@ -383,6 +396,7 @@ static int uinput_open(struct inode *ino
 		return -ENOMEM;
 
 	mutex_init(&newdev->mutex);
+	spin_lock_init(&newdev->state_lock);
 	spin_lock_init(&newdev->requests_lock);
 	init_waitqueue_head(&newdev->requests_waitq);
 	init_waitqueue_head(&newdev->waitq);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADF635F185;
	Tue, 25 Aug 2026 13:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665398; cv=none; b=pRRBMX6e+G9JSe7Ref/En7w//4dkkXD0O8qJj677vlZLoZKgLKR95BKJ1x0s4zrSrH94defnKa7KeozR0PytpeOOt2qMAMwlOAZl7aAQaf/NrwG6sxPCBpqLCELEISROA5Bepqi/I2jMsOv2MHewjkYC2Oi3Yls2GAe9aQq2EGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665398; c=relaxed/simple;
	bh=yJ0XK2HnSWYh9cRLw2rEsBe8UE67ttIg+aMNi3yk00o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4jsBPqEu96swKL0pZanSqp9EfmSgUv+wVs6IhINHZemyReJKsF6qJlv5ItJ2vRwUXDClzZuSBq2Ea2xAeEgF6w+nQB/2EF7oSY6p4BIsDEGSuk9juo84kZvVE1fy7Ft4jFojVzfd5WYqLxMdgJJ6dq/4Q0P4/ojGFnOXGoW0c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNS/p/t6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNS/p/t6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2781F000E9;
	Tue, 25 Aug 2026 13:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665396;
	bh=oYZTqfnc3omz8BfRv+u/uKrP9aXqGMplSFm9n0xicSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNS/p/t60jVqzQxPvGuYCUil8/sxfxeeu2cYrtIubG0saqzQIGeHuIFR/PRiCtIGR
	 FSRVK0HLAVur/BbtajJjAZbouFq1OM0h8ZO20aRwnaq2rtVEg7bUdXOtlsLQMA3RFH
	 PEVxpEL0l2yw4QAfIzozu7OVTv0qZ43O0HLhRj3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 03/77] ALSA: scarlett2: Use a private URB for the notification endpoint
Date: Tue, 25 Aug 2026 15:25:25 +0200
Message-ID: <20260825132541.703837425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

From: Geoffrey D. Bennett <g@b4.vu>

commit cd17d6ff7b7d2b1dd9bcc80ae7b4a83773f918c6 upstream.

scarlett2_init_notify() used mixer->urb, which
snd_usb_mixer_status_create() allocates for the UAC2 status interrupt
endpoint and mixer.c manages. On a device with that endpoint, the
"already in use" check fires on the status URB and returns 0 for
success without doing anything. No notification URB is submitted, and
cmd_done is left zeroed because it is initialised past that check and
nowhere else. scarlett2_usb_init() then issues SCARLETT2_USB_INIT_1
and wait_for_completion_timeout() would crash adding to the zeroed
wait.head.

Use a separate URB in scarlett2_data, as done for FCP, and initialise
cmd_done in scarlett2_init_private(). mixer.c was also freeing the URB
in snd_usb_mixer_free() and resubmitting it in
snd_usb_mixer_activate(), so scarlett2 must now do both: add
scarlett2_cleanup_urb(), called from private_free and private_suspend,
and a private_resume callback to re-establish the URB after resume.
scarlett2_init_notify() is reached from there, and the URB kill path
in scarlett2_notify() completes cmd_done, leaving a stale count that
would satisfy the next command's wait before the device ACKs. Use
reinit_completion() to clear it.

Also free the URB if the transfer buffer allocation fails, and both if
usb_submit_urb() fails. Move scarlett2_init_notify() up next to
scarlett2_cleanup_urb() so scarlett2_init_private() can reference it
without a forward declaration.

Fixes: 1b65088958ca ("ALSA: scarlett2: Implement handling of the ACK notification")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/ffb8ba37d5d605dfdfd8576949d67098651f9349.1786290885.git.g@b4.vu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c           |    6 ++
 sound/usb/mixer.h           |    2 
 sound/usb/mixer_scarlett2.c |   98 ++++++++++++++++++++++++++++----------------
 3 files changed, 71 insertions(+), 35 deletions(-)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -3736,6 +3736,12 @@ int snd_usb_mixer_resume(struct usb_mixe
 	struct usb_mixer_elem_list *list;
 	int id, err;
 
+	if (mixer->private_resume) {
+		err = mixer->private_resume(mixer);
+		if (err < 0)
+			return err;
+	}
+
 	/* restore cached mixer values */
 	for (id = 0; id < MAX_ID_ELEMS; id++) {
 		for_each_mixer_elem(list, mixer, id) {
--- a/sound/usb/mixer.h
+++ b/sound/usb/mixer.h
@@ -18,6 +18,7 @@ struct usb_mixer_interface {
 	struct usb_host_interface *hostif;
 	struct list_head list;
 	unsigned int ignore_ctl_error;
+	/* UAC2 status interrupt endpoint; owned by mixer.c */
 	struct urb *urb;
 	/* array[MAX_ID_ELEMS], indexed by unit id */
 	struct usb_mixer_elem_list **id_elems;
@@ -42,6 +43,7 @@ struct usb_mixer_interface {
 	void *private_data;
 	void (*private_free)(struct usb_mixer_interface *mixer);
 	void (*private_suspend)(struct usb_mixer_interface *mixer);
+	int (*private_resume)(struct usb_mixer_interface *mixer);
 };
 
 #define MAX_CHANNELS	16	/* max logical channels */
--- a/sound/usb/mixer_scarlett2.c
+++ b/sound/usb/mixer_scarlett2.c
@@ -1259,6 +1259,7 @@ struct scarlett2_data {
 	struct usb_mixer_interface *mixer;
 	struct mutex usb_mutex; /* prevent sending concurrent USB requests */
 	struct completion cmd_done;
+	struct urb *urb;        /* notification endpoint */
 	struct mutex data_mutex; /* lock access to this data */
 	u8 running;
 	u8 hwdep_in_use;
@@ -8641,13 +8642,70 @@ requeue:
 	}
 }
 
-/*** Cleanup/Suspend Callbacks ***/
+/*** Notification URB and Cleanup/Suspend Callbacks ***/
+
+/* Submit a URB to receive notifications from the device */
+static int scarlett2_init_notify(struct usb_mixer_interface *mixer)
+{
+	struct usb_device *dev = mixer->chip->dev;
+	struct scarlett2_data *private = mixer->private_data;
+	unsigned int pipe = usb_rcvintpipe(dev, private->bEndpointAddress);
+	void *transfer_buffer;
+	int err;
+
+	/* Already set up */
+	if (private->urb)
+		return 0;
+
+	if (usb_pipe_type_check(dev, pipe))
+		return -EINVAL;
+
+	private->urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!private->urb)
+		return -ENOMEM;
+
+	transfer_buffer = kmalloc(private->wMaxPacketSize, GFP_KERNEL);
+	if (!transfer_buffer) {
+		usb_free_urb(private->urb);
+		private->urb = NULL;
+		return -ENOMEM;
+	}
+
+	usb_fill_int_urb(private->urb, dev, pipe,
+			 transfer_buffer, private->wMaxPacketSize,
+			 scarlett2_notify, mixer, private->bInterval);
+
+	reinit_completion(&private->cmd_done);
+
+	err = usb_submit_urb(private->urb, GFP_KERNEL);
+	if (err) {
+		kfree(transfer_buffer);
+		usb_free_urb(private->urb);
+		private->urb = NULL;
+	}
+
+	return err;
+}
+
+static void scarlett2_cleanup_urb(struct usb_mixer_interface *mixer)
+{
+	struct scarlett2_data *private = mixer->private_data;
+
+	if (!private->urb)
+		return;
+
+	usb_kill_urb(private->urb);
+	kfree(private->urb->transfer_buffer);
+	usb_free_urb(private->urb);
+	private->urb = NULL;
+}
 
 static void scarlett2_private_free(struct usb_mixer_interface *mixer)
 {
 	struct scarlett2_data *private = mixer->private_data;
 
 	cancel_delayed_work_sync(&private->work);
+	scarlett2_cleanup_urb(mixer);
 	kfree(private);
 	mixer->private_data = NULL;
 }
@@ -8658,6 +8716,8 @@ static void scarlett2_private_suspend(st
 
 	if (cancel_delayed_work_sync(&private->work))
 		scarlett2_config_save(private->mixer);
+
+	scarlett2_cleanup_urb(mixer);
 }
 
 /*** Initialisation ***/
@@ -8778,11 +8838,13 @@ static int scarlett2_init_private(struct
 
 	mutex_init(&private->usb_mutex);
 	mutex_init(&private->data_mutex);
+	init_completion(&private->cmd_done);
 	INIT_DELAYED_WORK(&private->work, scarlett2_config_save_work);
 
 	mixer->private_data = private;
 	mixer->private_free = scarlett2_private_free;
 	mixer->private_suspend = scarlett2_private_suspend;
+	mixer->private_resume = scarlett2_init_notify;
 
 	private->info = entry->info;
 
@@ -8799,40 +8861,6 @@ static int scarlett2_init_private(struct
 	return scarlett2_find_fc_interface(mixer->chip->dev, private);
 }
 
-/* Submit a URB to receive notifications from the device */
-static int scarlett2_init_notify(struct usb_mixer_interface *mixer)
-{
-	struct usb_device *dev = mixer->chip->dev;
-	struct scarlett2_data *private = mixer->private_data;
-	unsigned int pipe = usb_rcvintpipe(dev, private->bEndpointAddress);
-	void *transfer_buffer;
-
-	if (mixer->urb) {
-		usb_audio_err(mixer->chip,
-			      "%s: mixer urb already in use!\n", __func__);
-		return 0;
-	}
-
-	if (usb_pipe_type_check(dev, pipe))
-		return -EINVAL;
-
-	mixer->urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!mixer->urb)
-		return -ENOMEM;
-
-	transfer_buffer = kmalloc(private->wMaxPacketSize, GFP_KERNEL);
-	if (!transfer_buffer)
-		return -ENOMEM;
-
-	usb_fill_int_urb(mixer->urb, dev, pipe,
-			 transfer_buffer, private->wMaxPacketSize,
-			 scarlett2_notify, mixer, private->bInterval);
-
-	init_completion(&private->cmd_done);
-
-	return usb_submit_urb(mixer->urb, GFP_KERNEL);
-}
-
 /* Cargo cult proprietary initialisation sequence */
 static int scarlett2_usb_init(struct usb_mixer_interface *mixer)
 {



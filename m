Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C33247ECF1;
	Tue, 25 Aug 2026 13:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664646; cv=none; b=mbFsz84GbOdQY8cyXHeK947bbjB365RRJUNk2Ei8qMgtDuruorBKZKyJ58ya/z385Tc4JjlVbcf/1HaVNY6sLeh0TFc6vj17CeOrSMXtBXUml5BAesSV6r9Z3443gsmpQxBkX6qGJLgzeV8xjlakUds8ZRCyFtazfippM3PiuUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664646; c=relaxed/simple;
	bh=3LE3QfVU9amSTkUWcDqquYnmPR4a1oK70t4ahzkxskM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxr4vUtZJeh8IlNsMdDPgGfAZlG6WOtgh3uCyi0D/tWSiZYuBaDgafJ/EDnqKEzm9e63bEHQ5DDSODmq1piYTFlJVLeynkVC8M3m5di+8/dae/lWWXWBHl0fAa5LSmS5S7rR4+MkGhMiEnMU+YJGa6Dk9odGSWOBgkIwqAgK2aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0mw8pjL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0mw8pjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9F51F000E9;
	Tue, 25 Aug 2026 13:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664645;
	bh=y5M0tgdm+yuqbZJi8eofVjiwxOajATyDhZSdhxA5zQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K0mw8pjLlK3zrV+QKr0lXnyIbvR8PhW5qsNwn05mf6UI8ImKSmNGgz9G9GBeEYbrL
	 z6HG9JNvp4TyTNwFLqnbq5EbUtvZx2Tt46n/e1IcBHkbH4rDUlWK0cLVkc8S12jIOC
	 KKivZ5uinIFULEp5NjAQlrpPyYAOlJPSDuUDwwTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 05/82] ALSA: FCP: Use a private URB for the notification endpoint
Date: Tue, 25 Aug 2026 15:24:52 +0200
Message-ID: <20260825132541.755643725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

commit 918b8d231c571c50a00efe92ffc8404a537a0490 upstream.

fcp_init_notify() used mixer->urb, which snd_usb_mixer_status_create()
allocates for the optional UAC2 status interrupt endpoint and mixer.c
kills, resubmits and frees. On a device with that endpoint,
fcp_init_notify()'s "already set up" early return fires on the status
URB and returns success without doing anything. No FCP notification
URB is submitted, and cmd_done is left zeroed because it is
initialised past that early return and nowhere else. fcp_init() then
issues init1_opcode and wait_for_completion_timeout() would crash
adding to the zeroed wait.head. fcp_cleanup_urb() would also kill and
free mixer.c's status URB.

Use a separate URB in fcp_data, and initialise cmd_done in
fcp_init_private() where fcp_data is allocated. fcp_init_notify() is
reached again after suspend via fcp_reinit(), and the URB kill path in
fcp_notify() completes cmd_done, leaving a stale count that would
satisfy the next command's wait before the device ACKs. Use
reinit_completion() to clear it.

Fixes: 46757a3e7d50 ("ALSA: FCP: Add Focusrite Control Protocol driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/2cad281e6434024ca48a9ecc94fa19d6777e9be7.1786290885.git.g@b4.vu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/fcp.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

--- a/sound/usb/fcp.c
+++ b/sound/usb/fcp.c
@@ -82,6 +82,7 @@ struct fcp_data {
 	struct mutex mutex;         /* serialise access to the device */
 	struct completion cmd_done; /* wait for command completion */
 	struct file *file;          /* hwdep file */
+	struct urb *urb;            /* FCP notification endpoint */
 
 	struct fcp_notify notify;
 
@@ -190,7 +191,7 @@ static int fcp_usb(struct usb_mixer_inte
 	const int max_retries = 5;
 	int err;
 
-	if (!mixer->urb)
+	if (!private->urb)
 		return -ENODEV;
 
 	struct fcp_usb_packet *req __free(kfree) = NULL;
@@ -305,7 +306,7 @@ static int fcp_reinit(struct usb_mixer_i
 {
 	struct fcp_data *private = mixer->private_data;
 
-	if (mixer->urb)
+	if (private->urb)
 		return 0;
 
 	void *step0_resp __free(kfree) =
@@ -901,13 +902,15 @@ static int fcp_hwdep_init(struct usb_mix
 
 static void fcp_cleanup_urb(struct usb_mixer_interface *mixer)
 {
-	if (!mixer->urb)
+	struct fcp_data *private = mixer->private_data;
+
+	if (!private->urb)
 		return;
 
-	usb_kill_urb(mixer->urb);
-	kfree(mixer->urb->transfer_buffer);
-	usb_free_urb(mixer->urb);
-	mixer->urb = NULL;
+	usb_kill_urb(private->urb);
+	kfree(private->urb->transfer_buffer);
+	usb_free_urb(private->urb);
+	private->urb = NULL;
 }
 
 static void fcp_private_free(struct usb_mixer_interface *mixer)
@@ -978,37 +981,37 @@ static int fcp_init_notify(struct usb_mi
 	int err;
 
 	/* Already set up */
-	if (mixer->urb)
+	if (private->urb)
 		return 0;
 
 	if (usb_pipe_type_check(dev, pipe))
 		return -EINVAL;
 
-	mixer->urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!mixer->urb)
+	private->urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!private->urb)
 		return -ENOMEM;
 
 	transfer_buffer = kmalloc(private->wMaxPacketSize, GFP_KERNEL);
 	if (!transfer_buffer) {
-		usb_free_urb(mixer->urb);
-		mixer->urb = NULL;
+		usb_free_urb(private->urb);
+		private->urb = NULL;
 		return -ENOMEM;
 	}
 
-	usb_fill_int_urb(mixer->urb, dev, pipe,
+	usb_fill_int_urb(private->urb, dev, pipe,
 			 transfer_buffer, private->wMaxPacketSize,
 			 fcp_notify, mixer, private->bInterval);
 
-	init_completion(&private->cmd_done);
+	reinit_completion(&private->cmd_done);
 
-	err = usb_submit_urb(mixer->urb, GFP_KERNEL);
+	err = usb_submit_urb(private->urb, GFP_KERNEL);
 	if (err) {
 		usb_audio_err(mixer->chip,
 			      "%s: usb_submit_urb failed: %d\n",
 			      __func__, err);
 		kfree(transfer_buffer);
-		usb_free_urb(mixer->urb);
-		mixer->urb = NULL;
+		usb_free_urb(private->urb);
+		private->urb = NULL;
 	}
 
 	return err;
@@ -1059,6 +1062,7 @@ static int fcp_init_private(struct usb_m
 		return -ENOMEM;
 
 	mutex_init(&private->mutex);
+	init_completion(&private->cmd_done);
 	init_waitqueue_head(&private->notify.queue);
 	spin_lock_init(&private->notify.lock);
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09873FA5F0;
	Wed, 30 Sep 2026 16:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785845; cv=none; b=f2KYJP2zUlk+VOqGXAKZe0/IrX7Z12wATDQo1a0EGe6/8fcMe3StVNLbIhmXZ20oUgN9Ei/gEacpEScwAL3TcRdwRtXbYYcPGDG6K4SBzFIT1AX3V7cvCX5KDqqci0RsYhGsGzSIkxgc0vgK1khGYkcPHe4kXAAjpw+IPBDUPQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785845; c=relaxed/simple;
	bh=tQiUPvBIYRUfj+mo8FRAMzAHBYVRYKqlHtOjqpcV+1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6JrXNblFv4lfF5sQPKY2/rDPJk/XaaDsQajhvbpCzKztLr6nsm/etklVHdI5zC8d7A8VpEOx1y3gxqCh4y7kElUGQc15KptuWA+7CGLoL3GIX46F58QZJErZkvVtfdT3AW/I8Ik0WLIojc8IY2thr7GN0Iz1tXdHRk6kdgZGfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqAoVLeh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqAoVLeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151A21F000FF;
	Wed, 30 Sep 2026 16:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785844;
	bh=lK5v3dljc8Yhn8djnXgmvG+0v76MmFybBygneujCsHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VqAoVLehxPCx2Knm8EExJatq1/EBCwr4Q/DK2C/JpDAQiWhEzjut0IEcw149ScMtf
	 zDu4hATYg9WfxEufQQEWFzwYywbu97cD4kOR/iLtMWZaHC7L6P25iR3/wBr27J1eLg
	 veoh7q48SCTHW9az/QeAB0gtBQQmw40e75hSFI+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 653/982] ALSA: bcd2000: Fix race between rawmidi and disconnect
Date: Wed, 30 Sep 2026 17:23:09 +0200
Message-ID: <20260930152430.792548273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 221253723dc58bb901c3f27a7659823e63fc598c ]

Although we tried to fix the potential UAF issues at USB disconnect on
bcd2000 driver, there is still an overlooked case -- namely, when a
rawmidi trigger callback has been already running at USB disconnect
handling, the in-flight function (e.g. bcd2000_midi_send()) could
still access the URB, because the previous URB NULL-check & clearance
was considered only for the URB complete callbacks, but not about the
parallel rawmidi operations.

For addressing the race, this patch introduced a new spinlock that
covers each rawmidi operation as well as the rawmidi handling in the
complete callback.  The URB is cleared with the lock, so it guarantees
that the pending rawmidi task already finished or a NULL check is
effective.

Fixes: 459d3a64766f ("ALSA: bcd2000: clear the URB pointers on disconnect")
Link: https://patch.msgid.link/20260910155227.996210-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/bcd2000/bcd2000.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/sound/usb/bcd2000/bcd2000.c b/sound/usb/bcd2000/bcd2000.c
index 407a50f163b08..8be080d33eb0f 100644
--- a/sound/usb/bcd2000/bcd2000.c
+++ b/sound/usb/bcd2000/bcd2000.c
@@ -43,6 +43,7 @@ struct bcd2000 {
 	struct usb_interface *intf;
 	int card_index;
 
+	spinlock_t midi_lock;
 	int midi_out_active;
 	struct snd_rawmidi *rmidi;
 	struct snd_rawmidi_substream *midi_receive_substream;
@@ -90,6 +91,8 @@ static void bcd2000_midi_input_trigger(struct snd_rawmidi_substream *substream,
 						int up)
 {
 	struct bcd2000 *bcd2k = substream->rmidi->private_data;
+
+	guard(spinlock_irqsave)(&bcd2k->midi_lock);
 	bcd2k->midi_receive_substream = up ? substream : NULL;
 }
 
@@ -195,6 +198,8 @@ static void bcd2000_midi_output_trigger(struct snd_rawmidi_substream *substream,
 {
 	struct bcd2000 *bcd2k = substream->rmidi->private_data;
 
+	guard(spinlock_irqsave)(&bcd2k->midi_lock);
+
 	if (up) {
 		bcd2k->midi_out_substream = substream;
 		/* check if there is data userspace wants to send */
@@ -219,6 +224,7 @@ static void bcd2000_output_complete(struct urb *urb)
 		return;
 
 	/* check if there is more data userspace wants to send */
+	guard(spinlock_irqsave)(&bcd2k->midi_lock);
 	bcd2000_midi_send(bcd2k);
 }
 
@@ -234,6 +240,8 @@ static void bcd2000_input_complete(struct urb *urb)
 	if (!bcd2k || urb->status == -ESHUTDOWN)
 		return;
 
+	guard(spinlock_irqsave)(&bcd2k->midi_lock);
+
 	if (urb->actual_length > 0)
 		bcd2000_midi_handle_input(bcd2k, urb->transfer_buffer,
 					urb->actual_length);
@@ -348,16 +356,26 @@ static int bcd2000_init_midi(struct bcd2000 *bcd2k)
 	return 0;
 }
 
+static void bcd2000_midi_free(struct bcd2000 *bcd2k,
+			      struct urb **urb_p)
+{
+	struct urb *urb = *urb_p;
+
+	if (!urb)
+		return;
+
+	usb_poison_urb(urb);
+	scoped_guard(spinlock_irq, &bcd2k->midi_lock)
+		*urb_p = NULL;
+
+	usb_free_urb(urb);
+}
+
 static void bcd2000_free_usb_related_resources(struct bcd2000 *bcd2k,
 						struct usb_interface *interface)
 {
-	usb_poison_urb(bcd2k->midi_out_urb);
-	usb_poison_urb(bcd2k->midi_in_urb);
-
-	usb_free_urb(bcd2k->midi_out_urb);
-	usb_free_urb(bcd2k->midi_in_urb);
-	bcd2k->midi_out_urb = NULL;
-	bcd2k->midi_in_urb = NULL;
+	bcd2000_midi_free(bcd2k, &bcd2k->midi_out_urb);
+	bcd2000_midi_free(bcd2k, &bcd2k->midi_in_urb);
 
 	if (bcd2k->intf) {
 		usb_set_intfdata(bcd2k->intf, NULL);
@@ -397,6 +415,7 @@ static int bcd2000_probe(struct usb_interface *interface,
 	bcd2k->card = card;
 	bcd2k->card_index = card_index;
 	bcd2k->intf = interface;
+	spin_lock_init(&bcd2k->midi_lock);
 
 	snd_card_set_dev(card, &interface->dev);
 
-- 
2.53.0




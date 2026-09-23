Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1C049B1E5;
	Wed, 23 Sep 2026 14:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173135; cv=none; b=C0XbKCz+hj72poFuOoVQeTDkOPCNYomH9ft03mlljCzD8kZ0uUGB6qCxFo2A8iKdbmiRoTU9aU9sdcBNmigamluQ+Ly1B70CDmtBNzKqDRecFPXkpG3A2r5n2LUO3/8BnhUvdt1TmAxRmEws6qsLACvDsBo2XtdCnWkQKid/In8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173135; c=relaxed/simple;
	bh=kO85FsQGwqkvpjn4guJ0+9yUeLf5BYVNWGB1xU1JZaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVlIbGqc72yEP5OrGd4RGwVz7pmmQYr7hd0Fgh1WjajTAE4uLnGrGZQ28Q+/blNa2LJOQTvIDmpBtCJ9DnMPH9BovR30smrkeDxDwFeaMsPjic0IGHe7gSKSzOBF7tIW+l82f7bn1K7vVCzq/7QYZP95wYxUICARXjC/0YuVXpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2yoyPCh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2yoyPCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738561F000FF;
	Wed, 23 Sep 2026 14:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173134;
	bh=NnukRnFKFvxmEm7rdOARrj+/2ybKtYGDf3SNnjEKoZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2yoyPChIgIs/ov/bAf2yGTI4q1biwhUOqtPncDP5WnOUtCSfBIjSRamNOkDi9uWZ
	 tsRNeKb17sopRRKxOyY9umKVWXOHtqhtKGnF4P2OnJwxa925TdaZ27ol4qzDF2qjDE
	 45OS68tIK7UEugtd4iuQJ1n4vAeSpqTMMBHKZ5lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 119/438] ALSA: bcd2000: Fix race between rawmidi and disconnect
Date: Wed, 23 Sep 2026 16:02:20 +0200
Message-ID: <20260923140647.866506818@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
index c5c542d17ccc1..2bd49bf827489 100644
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
@@ -393,6 +411,7 @@ static int bcd2000_probe(struct usb_interface *interface,
 	bcd2k->card = card;
 	bcd2k->card_index = card_index;
 	bcd2k->intf = interface;
+	spin_lock_init(&bcd2k->midi_lock);
 
 	snd_card_set_dev(card, &interface->dev);
 
-- 
2.53.0




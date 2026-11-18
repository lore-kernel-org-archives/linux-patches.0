Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059453;
	b=paC2ADm3cXwrktfPfRe3gP1oPiMZaZrRDu3Bn8OpTWAYBfsqBFFzeSJS/hwj+3kCVd6b
	 cv0gQtWA9DCdj/FxF0v0M/jCQ8a+eTlmJ9oEiCHHWCj6/jnhe9HCZ9W560ZXu4HJtPM/P
	 SFUOu21tlx8lMD42w1LhBMcax7I39U19TBsvipOOlNhy3Zzp8g96FG1Fv7kZZncHdAXtM
	 2geVYrZJR9N6ZcePNYmGJDdgksNdOrfjDQ9dirwJGGPvR7Z8wtmhb3hgvddf37aoPVTbk
	 CSOkfTinahZK81iCNaUkb7rDUR1mEfyGw/j9LlRk29/Csouamrd8DTch7QJ45i5M6mQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Ve2eKwhek0L75gUOiddocGEzzTldTQJy4a+DAt2G9k=;
	b=Tcnhomf3jlM9h4Pjzdx8Fpn0QQUyW5X6bGZRIjq9LPotdb1lo7/JUEp424n4MD/Fedak
	 P4CIvSyNtH/qdCW+8TI2kn8dDoJXZWtQP0q835cdVhj3vtv2SpBVX/XuchDo0ZJh/Za5p
	 oulSF+yDAqhArBSavL4HAyIRCydSB2AHSKaeAlT1hP58jVd8930ClsqlGgYu8JN9wZ2ud
	 Z7sXwSU3UdDBMvDeTw4EZrhL1sVgBicaB5RsryrvCa7F5bFlEdF9xmoPeI4Jf3XnDM8Tm
	 sRL3p2i8tQBYaHVYqYRS7hlmqQt0mMBUyDSM3AV7hSgcJ9RC9F7ga3T2RlpX3uGVQuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fyKn6h+I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8839F606A325;
	Thu, 19 Nov 2026 03:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fyKn6h+I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EA51F000C4;
	Thu, 19 Nov 2026 03:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059453;
	bh=3Ve2eKwhek0L75gUOiddocGEzzTldTQJy4a+DAt2G9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fyKn6h+I0YW7Gshp1CRU+1134M9V0rc4TRBAIToIA6Zm6pTzOQQuaa2LJb7pXnZ58
	 A05he30VcqoixziGLAOP9HzfSkW++MlEx+JNwpw/4fFbupm+mVP6xH+DaDMqMW2LKy
	 U5Edwj0nx85gYN6pR5zz0FSC5+z6p1JljP8VcGyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0805/1848] ALSA: bcd2000: Fix race between rawmidi and disconnect
Date: Wed, 18 Nov 2026 15:47:23 +0100
Message-ID: <20261118145950.041878720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 221253723dc58bb901c3f27a7659823e63fc598c upstream.

The 5.10.y tree is still built with -std=gnu89, so the guard() and
scoped_guard() helpers used by the upstream patch cannot be used
here.  Use explicit spin_lock_irqsave()/spin_unlock_irqrestore()
pairs instead; the locking scope is unchanged.

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
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/bcd2000/bcd2000.c | 45 +++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/sound/usb/bcd2000/bcd2000.c b/sound/usb/bcd2000/bcd2000.c
index c3312b3c46f97..da2c843440d27 100644
--- a/sound/usb/bcd2000/bcd2000.c
+++ b/sound/usb/bcd2000/bcd2000.c
@@ -43,6 +43,7 @@ struct bcd2000 {
 	struct usb_interface *intf;
 	int card_index;
 
+	spinlock_t midi_lock;
 	int midi_out_active;
 	struct snd_rawmidi *rmidi;
 	struct snd_rawmidi_substream *midi_receive_substream;
@@ -90,7 +91,11 @@ static void bcd2000_midi_input_trigger(struct snd_rawmidi_substream *substream,
 						int up)
 {
 	struct bcd2000 *bcd2k = substream->rmidi->private_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bcd2k->midi_lock, flags);
 	bcd2k->midi_receive_substream = up ? substream : NULL;
+	spin_unlock_irqrestore(&bcd2k->midi_lock, flags);
 }
 
 static void bcd2000_midi_handle_input(struct bcd2000 *bcd2k,
@@ -194,6 +199,9 @@ static void bcd2000_midi_output_trigger(struct snd_rawmidi_substream *substream,
 						int up)
 {
 	struct bcd2000 *bcd2k = substream->rmidi->private_data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bcd2k->midi_lock, flags);
 
 	if (up) {
 		bcd2k->midi_out_substream = substream;
@@ -203,11 +211,14 @@ static void bcd2000_midi_output_trigger(struct snd_rawmidi_substream *substream,
 	} else {
 		bcd2k->midi_out_substream = NULL;
 	}
+
+	spin_unlock_irqrestore(&bcd2k->midi_lock, flags);
 }
 
 static void bcd2000_output_complete(struct urb *urb)
 {
 	struct bcd2000 *bcd2k = urb->context;
+	unsigned long flags;
 
 	bcd2k->midi_out_active = 0;
 
@@ -219,12 +230,15 @@ static void bcd2000_output_complete(struct urb *urb)
 		return;
 
 	/* check if there is more data userspace wants to send */
+	spin_lock_irqsave(&bcd2k->midi_lock, flags);
 	bcd2000_midi_send(bcd2k);
+	spin_unlock_irqrestore(&bcd2k->midi_lock, flags);
 }
 
 static void bcd2000_input_complete(struct urb *urb)
 {
 	int ret;
+	unsigned long flags;
 	struct bcd2000 *bcd2k = urb->context;
 
 	if (urb->status)
@@ -234,6 +248,8 @@ static void bcd2000_input_complete(struct urb *urb)
 	if (!bcd2k || urb->status == -ESHUTDOWN)
 		return;
 
+	spin_lock_irqsave(&bcd2k->midi_lock, flags);
+
 	if (urb->actual_length > 0)
 		bcd2000_midi_handle_input(bcd2k, urb->transfer_buffer,
 					urb->actual_length);
@@ -244,6 +260,8 @@ static void bcd2000_input_complete(struct urb *urb)
 		dev_err(&bcd2k->dev->dev, PREFIX
 			"%s: usb_submit_urb() failed, ret=%d\n",
 			__func__, ret);
+
+	spin_unlock_irqrestore(&bcd2k->midi_lock, flags);
 }
 
 static const struct snd_rawmidi_ops bcd2000_midi_output = {
@@ -348,16 +366,28 @@ static int bcd2000_init_midi(struct bcd2000 *bcd2k)
 	return 0;
 }
 
+static void bcd2000_midi_free(struct bcd2000 *bcd2k,
+			      struct urb **urb_p)
+{
+	struct urb *urb = *urb_p;
+	unsigned long flags;
+
+	if (!urb)
+		return;
+
+	usb_poison_urb(urb);
+	spin_lock_irqsave(&bcd2k->midi_lock, flags);
+	*urb_p = NULL;
+	spin_unlock_irqrestore(&bcd2k->midi_lock, flags);
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
@@ -397,6 +427,7 @@ static int bcd2000_probe(struct usb_interface *interface,
 	bcd2k->card = card;
 	bcd2k->card_index = card_index;
 	bcd2k->intf = interface;
+	spin_lock_init(&bcd2k->midi_lock);
 
 	snd_card_set_dev(card, &interface->dev);
 
-- 
2.53.0




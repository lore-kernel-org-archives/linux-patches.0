Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041140;
	b=3EWRgpTwFG6HTSE0XPsagFCQdChC7148rtCNQvC5iJKeBxsiy+/Gy9XbhKuffK8Ej2aI
	 IXPrVBmN32rMoOUCTp4GuxGeQEMf8ZCAEy3Ah8Jz2vMnb2FS5jVG4071Zs2AtfVHmGmoL
	 jE2qiZMAzfRAt4uM6zkIt3Ehl/hf4XSYM9XYye1svu1TwLS7Fl98EWyXT+595CqB80k1w
	 4wROkhHG3zIwFoAWAkbIMt/gCOvSr+A6DNj9nUHqRUyCa5AkUDYhk6MgsNmXjNy4KH8FA
	 K1ZA7ABVUTLOOUfqTb19SRLRK/C9XFluelcPZhc/s26NUo74qeMcb0kMcpiVlAptuxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8j5hW78VYJyWzQJnLdrbPhmh0YFxb+18TP6wYBXCLZ8=;
	b=RDPbBELcb6FOGi2sfhoxA0wmbqKJwYzVAXebLIu6j+ppkzzCeFcdvfmtVKAd7pKxTK/Y
	 7ULLuZnedpjpXbMuptPYAVF5fvqF5JBmLKwSrnclCUfQsM1W0liibUob0XE3yDb535Lcb
	 4rNTo1Xy8wJeL90CnHiCpTtNXTsfKn2+F0y5S+7wPCBXqz7G1kK/kVbfhVfuoDmSRyp9a
	 Ub5qNAZ86NiaMTBER6HezlQAjeY78qY6YukdU4tZ7rjZUnw8DB5aUMYdKBf0pTO/1JJCX
	 /yv4iImGmbFN2TLLIPt477QAf2YLEfRpsikxlyLspJQhDwuL1G5CAHbHsNEqBvENtdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V6icFd+U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDAA606A320;
	Wed, 18 Nov 2026 22:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V6icFd+U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667F91F000C4;
	Wed, 18 Nov 2026 22:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041139;
	bh=8j5hW78VYJyWzQJnLdrbPhmh0YFxb+18TP6wYBXCLZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6icFd+UaCM+Q2zomU2ognhTeqC4rqI73m4AyZ99eII4g9IzhHLyStoDNiO7nfQ7M
	 uT+8zzGKBCGp/ZtbCFNWI21Vvy93oYth/POuDwdh5xMMuDC0Yq0vHW8KaiFKPI+5wX
	 KO2G63lObY1oWCjjbh/0iBiEVDE17xCVEu4yGs5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2706/3318] ALSA: caiaq: Fix races at MIDI URB and trigger accesses
Date: Wed, 18 Nov 2026 15:55:28 +0100
Message-ID: <20261118150442.078603757@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 52b1213e2a086f2828500ab9c8bac45b213429bb ]

URB completion and rawmidi trigger callbacks can race with each other,
which may put the state inconsistent, causing double submissions, etc.

Guard both with a new spinlock for avoiding the races.

Fixes: f3f80a9205da ("ALSA: caiaq - Fix Oops with MIDI")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261008192553.300025-7-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/device.c | 1 +
 sound/usb/caiaq/device.h | 3 ++-
 sound/usb/caiaq/midi.c   | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/usb/caiaq/device.c b/sound/usb/caiaq/device.c
index 993858d18b680..5e89047c9d9cc 100644
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -448,6 +448,7 @@ static int create_card(struct usb_device *usb_dev,
 	cdev->chip.usb_id = USB_ID(le16_to_cpu(usb_dev->descriptor.idVendor),
 				  le16_to_cpu(usb_dev->descriptor.idProduct));
 	spin_lock_init(&cdev->spinlock);
+	spin_lock_init(&cdev->midi_lock);
 	mutex_init(&cdev->ep1_out_mutex);
 
 	*cardp = card;
diff --git a/sound/usb/caiaq/device.h b/sound/usb/caiaq/device.h
index bef5fd31dedd4..e1ec0bfdbb99a 100644
--- a/sound/usb/caiaq/device.h
+++ b/sound/usb/caiaq/device.h
@@ -74,7 +74,8 @@ struct snd_usb_caiaqdev {
 	unsigned char midi_out_buf[EP1_BUFSIZE];
 
 	struct caiaq_device_spec spec;
-	spinlock_t spinlock;
+	spinlock_t spinlock;	/* for PCM audio */
+	spinlock_t midi_lock;	/* midi_x_stream, midi_out_active */
 	wait_queue_head_t ep1_wait_queue;
 	wait_queue_head_t prepare_wait_queue;
 	int spec_received, audio_parm_answer;
diff --git a/sound/usb/caiaq/midi.c b/sound/usb/caiaq/midi.c
index 18529484c8dcc..b7d7d24937a74 100644
--- a/sound/usb/caiaq/midi.c
+++ b/sound/usb/caiaq/midi.c
@@ -79,6 +79,7 @@ static void snd_usb_caiaq_midi_output_trigger(struct snd_rawmidi_substream *subs
 {
 	struct snd_usb_caiaqdev *cdev = substream->rmidi->private_data;
 
+	guard(spinlock_irqsave)(&cdev->midi_lock);
 	if (up) {
 		cdev->midi_out_substream = substream;
 		if (!cdev->midi_out_active)
@@ -151,6 +152,7 @@ void snd_usb_caiaq_midi_output_done(struct urb* urb)
 {
 	struct snd_usb_caiaqdev *cdev = urb->context;
 
+	guard(spinlock_irqsave)(&cdev->midi_lock);
 	cdev->midi_out_active = 0;
 	if (urb->status != 0)
 		return;
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DBE336ED1;
	Fri,  9 Jan 2026 12:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962920; cv=none; b=UnyPKPtT1PmH/LqYO2QvrkQ6uR9RXYuqLCxra/scUn/1Bv3IX//Zd2r9F5OZapYuvPJXaLMcOvsiDRsAxavqb0vATBTH8bf9eL1QOYlMLWh8DB9OyEHfzJRCKvyG/g8QDtKZ43ziQ79uYXio6g1Ko73CkT0ULPuyUpba3xSNdaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962920; c=relaxed/simple;
	bh=nXyg28i9raOOAmfKRlwxKXjk3Ca4L8FLJs4DhhduNfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1BSXpuvb6BLIGSYJkXhaOnzPYy0jyrDDTtthuXGf6fwZu4TadwMAULaFZQvVHLL8PSJm4RPXqzxcnBFvtkYwoh4sc09ytMzk9sJHfr7vw/G2xaiUfyzR2QWnze/mhQsGotIbj5hqAsTFOWhiXizr5bNXYPmgIDZZdAasCf0Ivc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0vp8bvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0vp8bvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4087C4CEF1;
	Fri,  9 Jan 2026 12:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962920;
	bh=nXyg28i9raOOAmfKRlwxKXjk3Ca4L8FLJs4DhhduNfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0vp8bvE+PZawSHDB7xpbw1u0OFO2F0beEJKt7zQL98RivDwx0hRMComNGuUZt5bP
	 bNOGygc7vrDKgdhpEqJFt90+5y24T3GPevsEpkMejECkzQn8c8pFpx2PnKuChOPw9P
	 w00Z/hig0uQ7KRwZeUClXZwm7GNXdN7HUm1EYo/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 535/634] ALSA: wavefront: Use guard() for spin locks
Date: Fri,  9 Jan 2026 12:43:33 +0100
Message-ID: <20260109112137.706113617@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

[ Upstream commit 4b97f8e614ba46a50bd181d40b5a1424411a211a ]

Clean up the code using guard() for spin locks.

Merely code refactoring, and no behavior change.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250829145300.5460-19-tiwai@suse.de
Stable-dep-of: e11c5c13ce0a ("ALSA: wavefront: Clear substream pointers on close")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/wavefront/wavefront_midi.c  |  127 +++++++++++++---------------------
 sound/isa/wavefront/wavefront_synth.c |   18 ++--
 2 files changed, 59 insertions(+), 86 deletions(-)

--- a/sound/isa/wavefront/wavefront_midi.c
+++ b/sound/isa/wavefront/wavefront_midi.c
@@ -113,7 +113,6 @@ static void snd_wavefront_midi_output_wr
 {
 	snd_wavefront_midi_t *midi = &card->wavefront.midi;
 	snd_wavefront_mpu_id  mpu;
-	unsigned long flags;
 	unsigned char midi_byte;
 	int max = 256, mask = 1;
 	int timeout;
@@ -142,11 +141,9 @@ static void snd_wavefront_midi_output_wr
 				break;
 		}
 	
-		spin_lock_irqsave (&midi->virtual, flags);
-		if ((midi->mode[midi->output_mpu] & MPU401_MODE_OUTPUT) == 0) {
-			spin_unlock_irqrestore (&midi->virtual, flags);
+		guard(spinlock_irqsave)(&midi->virtual);
+		if ((midi->mode[midi->output_mpu] & MPU401_MODE_OUTPUT) == 0)
 			goto __second;
-		}
 		if (output_ready (midi)) {
 			if (snd_rawmidi_transmit(midi->substream_output[midi->output_mpu], &midi_byte, 1) == 1) {
 				if (!midi->isvirtual ||
@@ -160,14 +157,11 @@ static void snd_wavefront_midi_output_wr
 						del_timer(&midi->timer);
 				}
 				midi->mode[midi->output_mpu] &= ~MPU401_MODE_OUTPUT_TRIGGER;
-				spin_unlock_irqrestore (&midi->virtual, flags);
 				goto __second;
 			}
 		} else {
-			spin_unlock_irqrestore (&midi->virtual, flags);
 			return;
 		}
-		spin_unlock_irqrestore (&midi->virtual, flags);
 	}
 
       __second:
@@ -185,15 +179,13 @@ static void snd_wavefront_midi_output_wr
 				break;
 		}
 	
-		spin_lock_irqsave (&midi->virtual, flags);
+		guard(spinlock_irqsave)(&midi->virtual);
 		if (!midi->isvirtual)
 			mask = 0;
 		mpu = midi->output_mpu ^ mask;
 		mask = 0;	/* don't invert the value from now */
-		if ((midi->mode[mpu] & MPU401_MODE_OUTPUT) == 0) {
-			spin_unlock_irqrestore (&midi->virtual, flags);
+		if ((midi->mode[mpu] & MPU401_MODE_OUTPUT) == 0)
 			return;
-		}
 		if (snd_rawmidi_transmit_empty(midi->substream_output[mpu]))
 			goto __timer;
 		if (output_ready (midi)) {
@@ -215,20 +207,16 @@ static void snd_wavefront_midi_output_wr
 						del_timer(&midi->timer);
 				}
 				midi->mode[mpu] &= ~MPU401_MODE_OUTPUT_TRIGGER;
-				spin_unlock_irqrestore (&midi->virtual, flags);
 				return;
 			}
 		} else {
-			spin_unlock_irqrestore (&midi->virtual, flags);
 			return;
 		}
-		spin_unlock_irqrestore (&midi->virtual, flags);
 	}
 }
 
 static int snd_wavefront_midi_input_open(struct snd_rawmidi_substream *substream)
 {
-	unsigned long flags;
 	snd_wavefront_midi_t *midi;
 	snd_wavefront_mpu_id mpu;
 
@@ -243,17 +231,15 @@ static int snd_wavefront_midi_input_open
 	if (!midi)
 	        return -EIO;
 
-	spin_lock_irqsave (&midi->open, flags);
+	guard(spinlock_irqsave)(&midi->open);
 	midi->mode[mpu] |= MPU401_MODE_INPUT;
 	midi->substream_input[mpu] = substream;
-	spin_unlock_irqrestore (&midi->open, flags);
 
 	return 0;
 }
 
 static int snd_wavefront_midi_output_open(struct snd_rawmidi_substream *substream)
 {
-	unsigned long flags;
 	snd_wavefront_midi_t *midi;
 	snd_wavefront_mpu_id mpu;
 
@@ -268,17 +254,15 @@ static int snd_wavefront_midi_output_ope
 	if (!midi)
 	        return -EIO;
 
-	spin_lock_irqsave (&midi->open, flags);
+	guard(spinlock_irqsave)(&midi->open);
 	midi->mode[mpu] |= MPU401_MODE_OUTPUT;
 	midi->substream_output[mpu] = substream;
-	spin_unlock_irqrestore (&midi->open, flags);
 
 	return 0;
 }
 
 static int snd_wavefront_midi_input_close(struct snd_rawmidi_substream *substream)
 {
-	unsigned long flags;
 	snd_wavefront_midi_t *midi;
 	snd_wavefront_mpu_id mpu;
 
@@ -293,16 +277,14 @@ static int snd_wavefront_midi_input_clos
 	if (!midi)
 	        return -EIO;
 
-	spin_lock_irqsave (&midi->open, flags);
+	guard(spinlock_irqsave)(&midi->open);
 	midi->mode[mpu] &= ~MPU401_MODE_INPUT;
-	spin_unlock_irqrestore (&midi->open, flags);
 
 	return 0;
 }
 
 static int snd_wavefront_midi_output_close(struct snd_rawmidi_substream *substream)
 {
-	unsigned long flags;
 	snd_wavefront_midi_t *midi;
 	snd_wavefront_mpu_id mpu;
 
@@ -317,15 +299,13 @@ static int snd_wavefront_midi_output_clo
 	if (!midi)
 	        return -EIO;
 
-	spin_lock_irqsave (&midi->open, flags);
+	guard(spinlock_irqsave)(&midi->open);
 	midi->mode[mpu] &= ~MPU401_MODE_OUTPUT;
-	spin_unlock_irqrestore (&midi->open, flags);
 	return 0;
 }
 
 static void snd_wavefront_midi_input_trigger(struct snd_rawmidi_substream *substream, int up)
 {
-	unsigned long flags;
 	snd_wavefront_midi_t *midi;
 	snd_wavefront_mpu_id mpu;
 
@@ -341,30 +321,27 @@ static void snd_wavefront_midi_input_tri
 	if (!midi)
 		return;
 
-	spin_lock_irqsave (&midi->virtual, flags);
+	guard(spinlock_irqsave)(&midi->virtual);
 	if (up) {
 		midi->mode[mpu] |= MPU401_MODE_INPUT_TRIGGER;
 	} else {
 		midi->mode[mpu] &= ~MPU401_MODE_INPUT_TRIGGER;
 	}
-	spin_unlock_irqrestore (&midi->virtual, flags);
 }
 
 static void snd_wavefront_midi_output_timer(struct timer_list *t)
 {
 	snd_wavefront_midi_t *midi = from_timer(midi, t, timer);
 	snd_wavefront_card_t *card = midi->timer_card;
-	unsigned long flags;
 	
-	spin_lock_irqsave (&midi->virtual, flags);
-	mod_timer(&midi->timer, 1 + jiffies);
-	spin_unlock_irqrestore (&midi->virtual, flags);
+	scoped_guard(spinlock_irqsave, &midi->virtual) {
+		mod_timer(&midi->timer, 1 + jiffies);
+	}
 	snd_wavefront_midi_output_write(card);
 }
 
 static void snd_wavefront_midi_output_trigger(struct snd_rawmidi_substream *substream, int up)
 {
-	unsigned long flags;
 	snd_wavefront_midi_t *midi;
 	snd_wavefront_mpu_id mpu;
 
@@ -380,22 +357,22 @@ static void snd_wavefront_midi_output_tr
 	if (!midi)
 		return;
 
-	spin_lock_irqsave (&midi->virtual, flags);
-	if (up) {
-		if ((midi->mode[mpu] & MPU401_MODE_OUTPUT_TRIGGER) == 0) {
-			if (!midi->istimer) {
-				timer_setup(&midi->timer,
-					    snd_wavefront_midi_output_timer,
-					    0);
-				mod_timer(&midi->timer, 1 + jiffies);
+	scoped_guard(spinlock_irqsave, &midi->virtual) {
+		if (up) {
+			if ((midi->mode[mpu] & MPU401_MODE_OUTPUT_TRIGGER) == 0) {
+				if (!midi->istimer) {
+					timer_setup(&midi->timer,
+						    snd_wavefront_midi_output_timer,
+						    0);
+					mod_timer(&midi->timer, 1 + jiffies);
+				}
+				midi->istimer++;
+				midi->mode[mpu] |= MPU401_MODE_OUTPUT_TRIGGER;
 			}
-			midi->istimer++;
-			midi->mode[mpu] |= MPU401_MODE_OUTPUT_TRIGGER;
+		} else {
+			midi->mode[mpu] &= ~MPU401_MODE_OUTPUT_TRIGGER;
 		}
-	} else {
-		midi->mode[mpu] &= ~MPU401_MODE_OUTPUT_TRIGGER;
 	}
-	spin_unlock_irqrestore (&midi->virtual, flags);
 
 	if (up)
 		snd_wavefront_midi_output_write((snd_wavefront_card_t *)substream->rmidi->card->private_data);
@@ -405,7 +382,6 @@ void
 snd_wavefront_midi_interrupt (snd_wavefront_card_t *card)
 
 {
-	unsigned long flags;
 	snd_wavefront_midi_t *midi;
 	static struct snd_rawmidi_substream *substream = NULL;
 	static int mpu = external_mpu; 
@@ -419,37 +395,37 @@ snd_wavefront_midi_interrupt (snd_wavefr
 		return;
 	}
 
-	spin_lock_irqsave (&midi->virtual, flags);
-	while (--max) {
+	scoped_guard(spinlock_irqsave, &midi->virtual) {
+		while (--max) {
 
-		if (input_avail (midi)) {
-			byte = read_data (midi);
+			if (input_avail(midi)) {
+				byte = read_data(midi);
 
-			if (midi->isvirtual) {				
-				if (byte == WF_EXTERNAL_SWITCH) {
-					substream = midi->substream_input[external_mpu];
-					mpu = external_mpu;
-				} else if (byte == WF_INTERNAL_SWITCH) { 
-					substream = midi->substream_output[internal_mpu];
+				if (midi->isvirtual) {
+					if (byte == WF_EXTERNAL_SWITCH) {
+						substream = midi->substream_input[external_mpu];
+						mpu = external_mpu;
+					} else if (byte == WF_INTERNAL_SWITCH) {
+						substream = midi->substream_output[internal_mpu];
+						mpu = internal_mpu;
+					} /* else just leave it as it is */
+				} else {
+					substream = midi->substream_input[internal_mpu];
 					mpu = internal_mpu;
-				} /* else just leave it as it is */
-			} else {
-				substream = midi->substream_input[internal_mpu];
-				mpu = internal_mpu;
-			}
+				}
 
-			if (substream == NULL) {
-				continue;
-			}
+				if (substream == NULL) {
+					continue;
+				}
 
-			if (midi->mode[mpu] & MPU401_MODE_INPUT_TRIGGER) {
-				snd_rawmidi_receive(substream, &byte, 1);
+				if (midi->mode[mpu] & MPU401_MODE_INPUT_TRIGGER) {
+					snd_rawmidi_receive(substream, &byte, 1);
+				}
+			} else {
+				break;
 			}
-		} else {
-			break;
 		}
-	} 
-	spin_unlock_irqrestore (&midi->virtual, flags);
+	}
 
 	snd_wavefront_midi_output_write(card);
 }
@@ -471,13 +447,10 @@ void
 snd_wavefront_midi_disable_virtual (snd_wavefront_card_t *card)
 
 {
-	unsigned long flags;
-
-	spin_lock_irqsave (&card->wavefront.midi.virtual, flags);
+	guard(spinlock_irqsave)(&card->wavefront.midi.virtual);
 	// snd_wavefront_midi_input_close (card->ics2115_external_rmidi);
 	// snd_wavefront_midi_output_close (card->ics2115_external_rmidi);
 	card->wavefront.midi.isvirtual = 0;
-	spin_unlock_irqrestore (&card->wavefront.midi.virtual, flags);
 }
 
 int
--- a/sound/isa/wavefront/wavefront_synth.c
+++ b/sound/isa/wavefront/wavefront_synth.c
@@ -1740,10 +1740,10 @@ snd_wavefront_internal_interrupt (snd_wa
 		return;
 	}
 
-	spin_lock(&dev->irq_lock);
-	dev->irq_ok = 1;
-	dev->irq_cnt++;
-	spin_unlock(&dev->irq_lock);
+	scoped_guard(spinlock, &dev->irq_lock) {
+		dev->irq_ok = 1;
+		dev->irq_cnt++;
+	}
 	wake_up(&dev->interrupt_sleeper);
 }
 
@@ -1795,11 +1795,11 @@ wavefront_should_cause_interrupt (snd_wa
 	wait_queue_entry_t wait;
 
 	init_waitqueue_entry(&wait, current);
-	spin_lock_irq(&dev->irq_lock);
-	add_wait_queue(&dev->interrupt_sleeper, &wait);
-	dev->irq_ok = 0;
-	outb (val,port);
-	spin_unlock_irq(&dev->irq_lock);
+	scoped_guard(spinlock_irq, &dev->irq_lock) {
+		add_wait_queue(&dev->interrupt_sleeper, &wait);
+		dev->irq_ok = 0;
+		outb(val, port);
+	}
 	while (!dev->irq_ok && time_before(jiffies, timeout)) {
 		schedule_timeout_uninterruptible(1);
 		barrier();



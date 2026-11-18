Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038375;
	b=UMpsqmUF+O7eaC702K3impVp/46/VudBXf6x5HPaFFeRqF6I/JttSDNN/CLgVdH2xOQR
	 AJWxbhIQNL94Jt9TiVWGBLB5TgJjkg8EnniG48Z/0jxPvGswVu3SV5XVssvf2IWIbro8n
	 qmWCYoGzdRAWcydX7ogF/AMx7nMdGT0CEO/yE/Z0abrxaslwcnz7VVifHiEeEHJKrGJqM
	 6FK3uVw2uAYVDwKxkLSax/vbVsApxXhNpiAv5ZfD1A8M3xhlBjwhIw1th9ngLFeCE5+Zc
	 vdCc746k1ypPKzrz1BFeBZN5AfTvQ2l1T+P9yRnOvgMvBZjY/yvtd/BNHuPEAFNRgBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EuevoVPLhM9g5d7lcWIAPCTSofWgsgPaKSv1kr65M3w=;
	b=VL6xQi+9LShmqslo7ph/1eWy8zHfCADIeRImZCRXfyHZe6CjWvEb5IOJs8qvMYsUEd6P
	 IlT2NjGvLJngObUojU4arqLbaYNEF0dm+EuUK5HG2Q2XUyv12Fu7ArE4STXWDKYrOMCVe
	 S6FxAxTZ3GclGseXAAn9uWr1XgmSQJSelGrSlLd1LDuaFeQRLdz9ZrQHQq9Uvs/CtMw5D
	 MMqhS4V6myBoEOWWnkDm9MwQHi1ExH2y46eyDBx8/Bi1Dp2C0qpCa4pZhOz0txggEY9Ym
	 1ZekW8aLDoZd4d0okbFTaNpfFd7SgNMZ4l7RfipnSlaste8J16NxiOIPwmLyOm1nuuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p+cv131S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB9A606A320;
	Wed, 18 Nov 2026 21:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p+cv131S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A42B1F000C8;
	Wed, 18 Nov 2026 21:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038375;
	bh=EuevoVPLhM9g5d7lcWIAPCTSofWgsgPaKSv1kr65M3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p+cv131SpOpbI1HLeTkJBoIX/74Fi7Suu3EipGv/4H/0ylQVjZ4AbLLuswk3o4IjP
	 XEc7Ro11G77qK5Vh+scyH1Xh4loe3CtHHpsa0bkyoSOhHGlcEayGo0/671QRca9ma8
	 Hy5qGrT/+laXsnynSLuH4bO2ILQOS61bmDA7bAc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1695/3318] ALSA: line6: Use guard() for spin locks
Date: Wed, 18 Nov 2026 15:38:37 +0100
Message-ID: <20261118150412.680504141@linuxfoundation.org>
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

[ Upstream commit bdcdb4e7aa410122baa3496b93e7850dc20a90fa ]

Clean up the code using guard() for spin locks.

Merely code refactoring, and no behavior change.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 443ed4edc267 ("ALSA: line6: Handle period elapsed calls outside the locks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/line6/capture.c |  6 +-----
 sound/usb/line6/driver.c  | 31 +++++++++++++++----------------
 sound/usb/line6/midi.c    | 10 ++--------
 sound/usb/line6/pcm.c     | 27 ++++++++++++---------------
 4 files changed, 30 insertions(+), 44 deletions(-)

diff --git a/sound/usb/line6/capture.c b/sound/usb/line6/capture.c
index e77ef16c792f0..f26cb35446cf9 100644
--- a/sound/usb/line6/capture.c
+++ b/sound/usb/line6/capture.c
@@ -157,8 +157,6 @@ void line6_capture_check_period(struct snd_line6_pcm *line6pcm, int length)
 static void audio_in_callback(struct urb *urb)
 {
 	int i, index, length = 0, shutdown = 0;
-	unsigned long flags;
-
 	struct snd_line6_pcm *line6pcm = (struct snd_line6_pcm *)urb->context;
 
 	line6pcm->in.last_frame = urb->start_frame;
@@ -168,7 +166,7 @@ static void audio_in_callback(struct urb *urb)
 		if (urb == line6pcm->in.urbs[index])
 			break;
 
-	spin_lock_irqsave(&line6pcm->in.lock, flags);
+	guard(spinlock_irqsave)(&line6pcm->in.lock);
 
 	for (i = 0; i < LINE6_ISO_PACKETS; ++i) {
 		char *fbuf;
@@ -223,8 +221,6 @@ static void audio_in_callback(struct urb *urb)
 		    test_bit(LINE6_STREAM_PCM, &line6pcm->in.running))
 			line6_capture_check_period(line6pcm, length);
 	}
-
-	spin_unlock_irqrestore(&line6pcm->in.lock, flags);
 }
 
 /* open capture callback */
diff --git a/sound/usb/line6/driver.c b/sound/usb/line6/driver.c
index 9df49a880b750..36b97e8403135 100644
--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -286,31 +286,30 @@ static void line6_data_received(struct urb *urb)
 {
 	struct usb_line6 *line6 = (struct usb_line6 *)urb->context;
 	struct midi_buffer *mb = &line6->line6midi->midibuf_in;
-	unsigned long flags;
 	int done;
 
 	if (urb->status == -ESHUTDOWN)
 		return;
 
 	if (line6->properties->capabilities & LINE6_CAP_CONTROL_MIDI) {
-		spin_lock_irqsave(&line6->line6midi->lock, flags);
-		done =
-			line6_midibuf_write(mb, urb->transfer_buffer, urb->actual_length);
-
-		if (done < urb->actual_length) {
-			line6_midibuf_ignore(mb, done);
-			dev_dbg(line6->ifcdev, "%d %d buffer overflow - message skipped\n",
-				done, urb->actual_length);
+		scoped_guard(spinlock_irqsave, &line6->line6midi->lock) {
+			done =
+				line6_midibuf_write(mb, urb->transfer_buffer, urb->actual_length);
+
+			if (done < urb->actual_length) {
+				line6_midibuf_ignore(mb, done);
+				dev_dbg(line6->ifcdev, "%d %d buffer overflow - message skipped\n",
+					done, urb->actual_length);
+			}
 		}
-		spin_unlock_irqrestore(&line6->line6midi->lock, flags);
 
 		for (;;) {
-			spin_lock_irqsave(&line6->line6midi->lock, flags);
-			done =
-				line6_midibuf_read(mb, line6->buffer_message,
-						   LINE6_MIDI_MESSAGE_MAXLEN,
-						   LINE6_MIDIBUF_READ_RX);
-			spin_unlock_irqrestore(&line6->line6midi->lock, flags);
+			scoped_guard(spinlock_irqsave, &line6->line6midi->lock) {
+				done =
+					line6_midibuf_read(mb, line6->buffer_message,
+							   LINE6_MIDI_MESSAGE_MAXLEN,
+							   LINE6_MIDIBUF_READ_RX);
+			}
 
 			if (done <= 0)
 				break;
diff --git a/sound/usb/line6/midi.c b/sound/usb/line6/midi.c
index 0838632c788e4..c04c3cac8ede7 100644
--- a/sound/usb/line6/midi.c
+++ b/sound/usb/line6/midi.c
@@ -72,7 +72,6 @@ static void line6_midi_transmit(struct snd_rawmidi_substream *substream)
 */
 static void midi_sent(struct urb *urb)
 {
-	unsigned long flags;
 	int status;
 	int num;
 	struct usb_line6 *line6 = (struct usb_line6 *)urb->context;
@@ -84,7 +83,7 @@ static void midi_sent(struct urb *urb)
 	if (status == -ESHUTDOWN)
 		return;
 
-	spin_lock_irqsave(&line6->line6midi->lock, flags);
+	guard(spinlock_irqsave)(&line6->line6midi->lock);
 	num = --line6->line6midi->num_active_send_urbs;
 
 	if (num == 0) {
@@ -94,8 +93,6 @@ static void midi_sent(struct urb *urb)
 
 	if (num == 0)
 		wake_up(&line6->line6midi->send_wait);
-
-	spin_unlock_irqrestore(&line6->line6midi->lock, flags);
 }
 
 /*
@@ -158,17 +155,14 @@ static int line6_midi_output_close(struct snd_rawmidi_substream *substream)
 static void line6_midi_output_trigger(struct snd_rawmidi_substream *substream,
 				      int up)
 {
-	unsigned long flags;
 	struct usb_line6 *line6 =
 	    line6_rawmidi_substream_midi(substream)->line6;
 
 	line6->line6midi->substream_transmit = substream;
-	spin_lock_irqsave(&line6->line6midi->lock, flags);
+	guard(spinlock_irqsave)(&line6->line6midi->lock);
 
 	if (line6->line6midi->num_active_send_urbs == 0)
 		line6_midi_transmit(substream);
-
-	spin_unlock_irqrestore(&line6->line6midi->lock, flags);
 }
 
 static void line6_midi_output_drain(struct snd_rawmidi_substream *substream)
diff --git a/sound/usb/line6/pcm.c b/sound/usb/line6/pcm.c
index 7325482dcaebb..0d7ea10c98ebf 100644
--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -190,11 +190,10 @@ static void line6_buffer_release(struct snd_line6_pcm *line6pcm,
 static int line6_stream_start(struct snd_line6_pcm *line6pcm, int direction,
 			      int type)
 {
-	unsigned long flags;
 	struct line6_pcm_stream *pstr = get_stream(line6pcm, direction);
 	int ret = 0;
 
-	spin_lock_irqsave(&pstr->lock, flags);
+	guard(spinlock_irqsave)(&pstr->lock);
 	if (!test_and_set_bit(type, &pstr->running) &&
 	    !(pstr->active_urbs || pstr->unlink_urbs)) {
 		pstr->count = 0;
@@ -207,7 +206,6 @@ static int line6_stream_start(struct snd_line6_pcm *line6pcm, int direction,
 
 	if (ret < 0)
 		clear_bit(type, &pstr->running);
-	spin_unlock_irqrestore(&pstr->lock, flags);
 	return ret;
 }
 
@@ -215,21 +213,20 @@ static int line6_stream_start(struct snd_line6_pcm *line6pcm, int direction,
 static void line6_stream_stop(struct snd_line6_pcm *line6pcm, int direction,
 			  int type)
 {
-	unsigned long flags;
 	struct line6_pcm_stream *pstr = get_stream(line6pcm, direction);
 
-	spin_lock_irqsave(&pstr->lock, flags);
-	clear_bit(type, &pstr->running);
-	if (!pstr->running) {
-		spin_unlock_irqrestore(&pstr->lock, flags);
-		line6_unlink_audio_urbs(line6pcm, pstr);
-		spin_lock_irqsave(&pstr->lock, flags);
-		if (direction == SNDRV_PCM_STREAM_CAPTURE) {
-			line6pcm->prev_fbuf = NULL;
-			line6pcm->prev_fsize = 0;
-		}
+	scoped_guard(spinlock_irqsave, &pstr->lock) {
+		clear_bit(type, &pstr->running);
+		if (pstr->running)
+			return;
+	}
+
+	line6_unlink_audio_urbs(line6pcm, pstr);
+	if (direction == SNDRV_PCM_STREAM_CAPTURE) {
+		guard(spinlock_irqsave)(&pstr->lock);
+		line6pcm->prev_fbuf = NULL;
+		line6pcm->prev_fsize = 0;
 	}
-	spin_unlock_irqrestore(&pstr->lock, flags);
 }
 
 /* common PCM trigger callback */
-- 
2.53.0




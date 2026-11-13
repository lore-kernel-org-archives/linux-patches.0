Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591484;
	b=mEPmSuIgaPvhzApsthCwJ4tqSz3eLYixwh82B0m7ZzOELwcJxsfiuFwJWNZa1jNiJGal
	 JQchEOVZqmiiHxXPj7vpxU2n4EgTM58zC5JrwHE3zVHt5iFfwG72D71x3LZNv21iiT+gr
	 lUJfcUzmVv2gy9VSougeoHcyPk6ZSmiDJeSOB6kp+MSwQXi3x9jXzcPaKJKxO+q0eLjqp
	 DnWKENKitaNOM5gHuhN2MKDnuQ4nuvinRNBQbRs27bmrTcOQ+Up0NWDRaBxdlJfRp3wZK
	 lACFcBkAhiB2ycTah3Mtm2x4deURAgkxm8QDpdUIAuBaXYd6RUpaWpzAPgtXlxBqpIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lY7gKLGH8j03faQjri9xCvNpntkfEezfL/365Tcl34c=;
	b=NtvvxI24hhXk5EW2I5yDA6vxPFQKOpLmY2yKRPcyDYrrBJVr2Aq5AOepPPjwA/eCoRlW
	 P3bNvrx2cmxvDr92m3tJEn9Fchc+IQKSKcLLvDWe7YLsIqXK/YZtYLBCtoahVOD3YQcBu
	 I8Nh13mamfyYhg7NmT15h+tnc6zmq7wWsuMVBl1P6uMi8cfOFAYXYzUWZMi52oYnI48OY
	 I0yfxAgwGweOSaeKCPyAHaPbczybyLhwWWSMpEGQNhXf2yBIgJyNeuOzwRSotgsLcSyEN
	 Uv87nB3Fwv1vQpD8xg1i4YarBJDFl5Dy69qZglmiUPy02wXJ2y9o/40tHiW2MRD9UPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0vL3xA9m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA80606D485;
	Fri, 13 Nov 2026 17:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0vL3xA9m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9601F000C7;
	Fri, 13 Nov 2026 17:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591484;
	bh=lY7gKLGH8j03faQjri9xCvNpntkfEezfL/365Tcl34c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0vL3xA9m/BZ/xp8Roxi7fisaALce5m55sOFvF/NxZiPhwkNOAHBTRDBqBZQYP4BiS
	 xOxCgbmTCaWUeydA0et/FDflvqqVc1UHao1wuWv6yHQPhX131DsXzVF3GBUiyfLfuj
	 ceZoLW9KpP6flRt0ItKu2ePDxN8pc673Vh5SwQQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 524/670] ALSA: line6: Use guard() for spin locks
Date: Fri, 13 Nov 2026 10:51:28 -0500
Message-ID: <20261113153829.688699753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2ce020939bd72..dde52454ec65e 100644
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
index e9eb5c74d6c7a..caf9bc6616865 100644
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
index 9b51760862809..80d9a6d903424 100644
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
index 7f51a81d7ec9b..77d5802872b16 100644
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




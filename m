Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625007;
	b=mxqaOV4bBCcDRZv+ubbn90wutDbrwdWY+pWfVfwVd4fNAO3LmPpKQzsz5E1lDKxFW+JL
	 ivp8r9Y5X3gxv8U2grvBX2qrg6ZCSXqg/dO7j7T+0Dpf/p8g2xKyjlKS64MrvHm6hMrCe
	 rtkLQNLbe4Sm5mdf+XfLEY5PWQ09ullSMX6KOhVeMhduwxTamUNFuViZp7FUHQcHHHFMh
	 qh1jXaPWvzPZa9zUcyE3wLeNWgsHskqp2sYdzELP07L7540oD2+cJY6kFZfcDtkLEV/FK
	 5V1GpbMJEhrmmQi9gIR7cIZMgN8/Y54+HyRYpEhktNRKrsfZ7nkj6VeYZyyTVd++38A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2yo0Ck0XY3CjXHrEfhi8M2ABgm8IIEhMv1E+/EItgYc=;
	b=dZI+cD4wxuODDsOKrIW/AvEbWJWN+9Xzi6lY/84r2DRdqNE/yBAfvafFqdOabl+GaPsG
	 uV1bd0Ypptrexim1lYwMHTiYgPLINsm3qRlpbhVZDHORb3wE12/junYBvA3DPD91gY8s7
	 ayXcYxinnNy2Z/VzQsLouLiF+urphlgfdAtqBuT/ty64LjVFzv74XOnyDtiJyQt/ey+i4
	 Wcwnwy8E5aYtiCIskC5IUilf+Nr3xin5Ofih8P9nDUqN3b8ntF//Wtq95+KPI3XbKr32r
	 ikOwLj0esOQHEMhSqrGCu+hRWr1I8uCjQVcqo0WMq5r6Be90ui0rqf4PVG70I5pqyHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xgw9cuoy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A402D606A321;
	Wed, 25 Nov 2026 16:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xgw9cuoy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011EE1F000CF;
	Wed, 25 Nov 2026 16:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625007;
	bh=2yo0Ck0XY3CjXHrEfhi8M2ABgm8IIEhMv1E+/EItgYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xgw9cuoydK5aP/RnS9Mm0sDcG3D8M5GCMaToKqrekVuYgCPrzhPoGMes0/nOYbR/9
	 eiNtMubXZ2pja6EE0NDTmIqhUXb8JK7MQqHNg6N/KpG6ttNG70lYUydU06Pr8L8Myh
	 IQM9HEdDt4U7DK6WWFkOYTKtuiP3cgB2XOVCQx/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sinan Turunc <enscrpt@pm.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 377/816] ALSA: ua101: Bound packet copies by the PCM buffer size
Date: Wed, 25 Nov 2026 15:32:05 +0100
Message-ID: <20261125143857.930987545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Sinan Turunc <enscrpt@pm.me>

[ Upstream commit 493a77a9f20fca07ca5654f61c1b03bef035df25 ]

copy_capture_data() and copy_playback_data() wrap the ring buffer
position once and split the memcpy() in two at the buffer end, which is
only correct when one packet holds at most buffer_size frames. The
capture packet size is the device's (actual_length up to wMaxPacketSize,
divided by 3 * bNrChannels from its own descriptor), the playback packet
size is taken from the capture packets, and set_stream_hw() lets the
PCM client pick period_bytes_min 1, periods_min 2 and a period time of
1.5 packet intervals: 9 frames at 44.1 kHz high speed, an 18-frame
buffer. A device sending 672-byte mono 24-bit packets delivers 224
frames per packet.

After the first packet buffer_pos is 206 and stays beyond buffer_size.
On the next packet frames1 = buffer_size - buffer_pos wraps and memcpy()
runs away:

  snd-ua101 2-1:1.0: invalid position: , pos = 206, buffer size = 18,
period size = 9
  BUG: KASAN: slab-out-of-bounds in capture_urb_complete+0x9eb/0xcb0
  Read of size 4294966732 at addr ffff88800d73e7e0 by task vhci_rx/81

and for playback:

  BUG: KASAN: vmalloc-out-of-bounds in playback_work+0x789/0xac0
  Read of size 4294966732 at addr ffffc9000002626a by task kworker/0:1H/80

Clamp the capture copy to buffer_size. On playback, copy at most one
buffer and fill the rest of the packet with silence, so the URB length,
the delay accounting and the data sent stay consistent. With that bound
the single wrap and both memcpy() halves stay inside the buffer. A
device whose packets do not fit the buffer never played correctly
anyway.

Reproduced on 7.3-rc7 with a USB/IP device presenting the UA-101
interface layout and a 672-byte isochronous endpoint.

Fixes: 63978ab3e3e9 ("sound: add Edirol UA-101 support")
Cc: stable@vger.kernel.org
Signed-off-by: Sinan Turunc <enscrpt@pm.me>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261026223543.620-3-enscrpt@pm.me
[ sashal: Adapted the playback_work() hunk to the older code: no scoped_guard indentation, and urb->urb.* / &urb->urb access via the struct ua101_urb wrapper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/misc/ua101.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/sound/usb/misc/ua101.c b/sound/usb/misc/ua101.c
index c43f4e4a8d670..db9dd58b20322 100644
--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -285,13 +285,29 @@ static void playback_work(struct work_struct *work)
 		/* fill packet with data or silence */
 		urb->urb.iso_frame_desc[0].length =
 			frames * ua->playback.frame_bytes;
-		if (test_bit(ALSA_PLAYBACK_RUNNING, &ua->states))
+		if (test_bit(ALSA_PLAYBACK_RUNNING, &ua->states)) {
+			/*
+			 * The packet size comes from the capture stream,
+			 * i.e. from the device, while the ring buffer can
+			 * be as small as two tiny periods. The single wrap
+			 * in copy_playback_data() is only valid for
+			 * frames <= buffer_size, so copy at most one
+			 * buffer and send silence for the rest.
+			 */
+			unsigned int copy_frames = min(frames,
+				ua->playback.substream->runtime->buffer_size);
+
 			do_period_elapsed |= copy_playback_data(&ua->playback,
 								&urb->urb,
-								frames);
-		else
+								copy_frames);
+			memset(urb->urb.transfer_buffer +
+			       copy_frames * ua->playback.frame_bytes, 0,
+			       (frames - copy_frames) *
+			       ua->playback.frame_bytes);
+		} else {
 			memset(urb->urb.transfer_buffer, 0,
 			       urb->urb.iso_frame_desc[0].length);
+		}
 
 		/* and off you go ... */
 		err = usb_submit_urb(&urb->urb, GFP_ATOMIC);
@@ -320,6 +336,13 @@ static bool copy_capture_data(struct ua101_stream *stream, struct urb *urb,
 
 	runtime = stream->substream->runtime;
 	frame_bytes = stream->frame_bytes;
+	/*
+	 * A packet can carry up to max_packet_bytes, the device's
+	 * wMaxPacketSize, which may exceed the whole ring buffer; keep what
+	 * fits so the single wrap below stays valid.
+	 */
+	if (unlikely(frames > runtime->buffer_size))
+		frames = runtime->buffer_size;
 	dest = runtime->dma_area + stream->buffer_pos * frame_bytes;
 	if (stream->buffer_pos + frames <= runtime->buffer_size) {
 		memcpy(dest, urb->transfer_buffer, frames * frame_bytes);
-- 
2.53.0




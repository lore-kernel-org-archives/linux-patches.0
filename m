Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590679;
	b=27g5MXgXoKclfO4gLT3k6WHzeDLQ7zqx1Z+biDVsSAoOKcakTkKrrit0IHJb6M6NV4fG
	 kz9F5A2yhQyiRaVPAEays//0ZoL0LBuM/gzs9l2aDzOKawN3Jli4wGNEuIwn9V7QGliox
	 7t5wP2rXgY221CthCH3u1c/cFU+YRBIJmqk9QtKKSdbHn6qa1usrsRn0bwhS/nu0gfiUt
	 R0X9+cfARcEPQ+Zub/wPEqpDP9A9Lej7zWmwLd6QHxeduqRkup+kXcw4ri13DC3zeRh1H
	 6omUG32RDzVuObJoB+T40L0XqRQKfM4Ykp5bhyxRaPv40HzgZsOgE82u1Y88pD1sH/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G9xIrZEjzfF8U5Z+9qfuD2eeSXob7xFAXSd0DX/YSTE=;
	b=e+zYIK4arYIqOsF3nH/1RGO2BR23Hn/RjRlUw4gRwY1eCUbTdBQ8ZhKQ7sXlbExnjXLe
	 ii0rus04tZWhLtdUXXuhBcJxYuGnAIrGZOyChYdvQSgpkK7eprWDBD6w+K8/Ish2Egc0j
	 bUxuzZwb/+FCmEIcIp4LlBjWZSZJHOe0KjwaEBvpPg+G1kg58fROSYjtFfcsdeY3Tt3Xh
	 9uyvtKicW4ODmNplBJDuKHsy3Rjle2pIc2A/zz2K4cWuBLzD/CZzoq0Mg2EstrnvzRK+N
	 IRC6qZuy7PJR5mr61cpoIz23Pz9vvdaSTj20T4VeELUrC//oz+KxEBPXR1VirajL7+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hLxxFjVa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD18606CEC7;
	Fri, 13 Nov 2026 17:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hLxxFjVa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1D81F000C5;
	Fri, 13 Nov 2026 17:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590678;
	bh=G9xIrZEjzfF8U5Z+9qfuD2eeSXob7xFAXSd0DX/YSTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLxxFjVa+T1Adz1DXp+sUn2MYKEyptTGxxmjN+3+3RsjYETbYP361IMMcWbcy5woW
	 qKl9ShWU6mmzyazywTHAvsLTYEuLJdZP6maeHXeT56xelyEU1/78zff1G7pPnM1NAA
	 pQ4qtAWMTFsnB4cD17IcS1I3m1tA4VUfp7o0NroM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sinan Turunc <enscrpt@pm.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 592/686] ALSA: ua101: Bound packet copies by the PCM buffer size
Date: Fri, 13 Nov 2026 10:52:05 -0500
Message-ID: <20261113153842.012667137@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: changed urb->transfer_buffer to urb->urb.transfer_buffer to match the embedded URB representation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/misc/ua101.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/sound/usb/misc/ua101.c b/sound/usb/misc/ua101.c
index 426171aa6dd28..c1d081231d7c8 100644
--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -282,13 +282,29 @@ static void playback_work(struct work_struct *work)
 			/* fill packet with data or silence */
 			urb->urb.iso_frame_desc[0].length =
 				frames * ua->playback.frame_bytes;
-			if (test_bit(ALSA_PLAYBACK_RUNNING, &ua->states))
+			if (test_bit(ALSA_PLAYBACK_RUNNING, &ua->states)) {
+				/*
+				 * The packet size comes from the capture stream,
+				 * i.e. from the device, while the ring buffer can
+				 * be as small as two tiny periods. The single wrap
+				 * in copy_playback_data() is only valid for
+				 * frames <= buffer_size, so copy at most one
+				 * buffer and send silence for the rest.
+				 */
+				unsigned int copy_frames = min(frames,
+					ua->playback.substream->runtime->buffer_size);
+
 				do_period_elapsed |= copy_playback_data(&ua->playback,
 									&urb->urb,
-									frames);
-			else
+									copy_frames);
+				memset(urb->urb.transfer_buffer +
+				       copy_frames * ua->playback.frame_bytes, 0,
+				       (frames - copy_frames) *
+				       ua->playback.frame_bytes);
+			} else {
 				memset(urb->urb.transfer_buffer, 0,
 				       urb->urb.iso_frame_desc[0].length);
+			}
 
 			/* and off you go ... */
 			err = usb_submit_urb(&urb->urb, GFP_ATOMIC);
@@ -317,6 +333,13 @@ static bool copy_capture_data(struct ua101_stream *stream, struct urb *urb,
 
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




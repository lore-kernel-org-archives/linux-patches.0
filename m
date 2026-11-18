Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053720;
	b=LM/+yRY/l2Wcfz/985lgbjWFLNQf0mFyBi1Zopcp7q9QDoOVRgSKZZpo0tjocs/KbbJq
	 RShXf3xGnitBbcMsP8bvyMapWIPG/F1lnRmdcXfOZZi+6fmX7H00D4kO+OIR8UIBItTPN
	 a/tDoe+F633o6JqQ2CH5gaP2oVs1Yp4WDom7Wxxs4y5SUDJSuo1NoRf6wjWOhTBCRxZVf
	 BXsWiba8UWJITRevWpuWzfbhezeUZRtVfkHOPUy+jbQ2kvsHf4w37JXCqeBmNVf27am0u
	 Pvadn3OCqoAGqlSulA+YyeAf7BpIpKve07YXlhnxex7+OM7M3bqk9weqqdNC5PsgriA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QLfQC1hZSvyEX+QB49n5C3ufR7OORHZXh8nnTkXK3SE=;
	b=jVqTZQKRzyfUTpQZENiIXk9MHQyTEmfyYwlOErtsVsnwHa0x+6ZYLB6qxoIGxpIbxdCf
	 tbz7oRp22qK40At2T011R7KoaDZPLfAw8kdoRKunClicaGUNnqL6ybWFz3KCm1gLhmgTg
	 H/gjtcmagTDNblhjrS5HZfilReNLMg8YXm33eaa13juJGkKkh+yrLDiY/ThUkpeTGs2LU
	 5WE6hhAzi25ifQVoIczeQJ9S7bjljk6PHrpUp0K+mKaYqB2qhuxO+4wuJVnm2PEbnNS4m
	 lGBAGPN5s72cRdMsdVJBwNXNSOgEAdm0Eo4IXpzDyFtmPDT6YvCFFZodl3jMjJfBmng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mzjUCe/u";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF1F606A320;
	Thu, 19 Nov 2026 02:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mzjUCe/u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1971B1F000C4;
	Thu, 19 Nov 2026 02:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053720;
	bh=QLfQC1hZSvyEX+QB49n5C3ufR7OORHZXh8nnTkXK3SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mzjUCe/upSkJmfQM7QnsLWAuVQgi8A1BOP0AcYeQtjvU4oq1TH0n9GAnaqStP6Y76
	 JF5fOZF7HYejW3y76k8JGAjQSG/zNnYPadPXRjN8nUEaIYFP0BUPodUbQ88Mwz7FwX
	 UFVY5U1C7t7F+PmKLE6graTwliPmT0div9G3EzuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sinan Turunc <enscrpt@pm.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1017/2214] ALSA: usb-audio: Bound packet copies by the PCM buffer size
Date: Wed, 18 Nov 2026 15:44:53 +0100
Message-ID: <20261118150053.054552033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sinan Turunc <enscrpt@pm.me>

[ Upstream commit 06be918062adc1a5a76dc346803b136b20bdb5ae ]

retire_capture_urb() and prepare_playback_urb() assume that one USB
packet never carries more data than the whole ALSA ring buffer. Nothing
enforces that: the packet size comes from the device (wMaxPacketSize,
and curpacksize == maxpacksize when the class-specific endpoint
descriptor sets MaxPacketsOnly), while the PCM hardware constraints only
require 64-byte periods, two periods and a period time of one data
interval. An 8 kHz mono U8 stream on a 128-byte buffer is legal, and a
full-speed device can send 1023-byte packets into it.

On the first oversized packet hwptr_done is wrapped once and stays
beyond buffer_bytes (895 for 1023 bytes into 128). On the next packet
the wrap arithmetic in the copy path computes

    bytes1 = subs->buffer_bytes - oldptr

with oldptr > buffer_bytes, so bytes1 wraps to about 4 GB and memcpy()
runs off the end of the URB buffer and of the vmalloc'd DMA buffer:

  BUG: KASAN: slab-out-of-bounds in retire_capture_urb+0x251/0x870
  Read of size 4294966529 at addr ffff88800c1e2800 by task vhci_rx/82

and for playback, where copy_to_urb() has the same shape:

  BUG: KASAN: vmalloc-out-of-bounds in copy_to_urb.isra.0+0x188/0x430
  Read of size 4294966529 at addr ffffc9000004537f by task vhci_rx/79
   prepare_playback_urb+0x98a/0x1fc0

Truncate an oversized capture packet to the buffer size, and stop
filling a playback URB once it holds a whole buffer. With bytes <=
buffer_bytes the single wrap of hwptr_done and the two-part memcpy()
in both copy paths stay inside the buffer. A device whose packets do
not fit the buffer at all was never going to play correctly anyway.

Reproduced on 7.3-rc7 with a USB/IP device (dummy_hcd cannot carry
isochronous data) advertising a UAC1 endpoint with MaxPacketsOnly and
wMaxPacketSize 1023, and a PCM client using period_size 64, periods 2.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Sinan Turunc <enscrpt@pm.me>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261026223543.620-2-enscrpt@pm.me
[ sashal: added the missing ctx->buffer_size check that was already present upstream ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/pcm.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 737302cfede8f..2f3fadeeb3a38 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1228,6 +1228,18 @@ static void retire_capture_urb(struct snd_usb_substream *subs,
 			bytes -= adj;
 			subs->stream_offset_adj -= adj;
 		}
+		/*
+		 * A packet can be as large as the endpoint's maxpacksize, which
+		 * the device chooses, while the ring buffer can be as small as
+		 * two 64-byte periods. The hwptr_done wrap below handles one
+		 * wrap only, so never take more than one buffer from a packet.
+		 */
+		if (unlikely(bytes > subs->buffer_bytes)) {
+			dev_warn_ratelimited(&subs->dev->dev,
+					     "%u-byte packet exceeds %u-byte buffer, truncating\n",
+					     bytes, subs->buffer_bytes);
+			bytes = subs->buffer_bytes;
+		}
 		frames = bytes / stride;
 		if (!subs->txfr_quirk)
 			bytes = frames * stride;
@@ -1441,7 +1453,14 @@ static int prepare_playback_urb(struct snd_usb_substream *subs,
 
 	for (i = 0; i < ctx->packets; i++) {
 		counts = snd_usb_endpoint_next_packet_size(ep, ctx, i, avail);
-		if (counts < 0)
+		/*
+		 * Bound by the ring buffer as well as by the URB:
+		 * copy_to_urb() wraps hwptr_done once, so one URB must
+		 * never carry more than the whole buffer.
+		 */
+		if (counts < 0 ||
+		    (frames + counts) * stride > ctx->buffer_size ||
+		    (frames + counts) * stride > subs->buffer_bytes)
 			break;
 		/* set up descriptor */
 		urb->iso_frame_desc[i].offset = frames * stride;
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D5C2DC783;
	Mon, 17 Aug 2026 14:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977764; cv=none; b=KiSpN8w6VSQPSwPUzfK+pL1ODuPlIQtP6ppArchc6OzSH8RERhZy2LhH+TmzTU4D8KhO3PUxNmfTGjkwMTjwig/9iXkhr8sTelpHk+iEJlapceDMH8ZiOf5DxNFg6Re8g9SY2LMAQ23LWBebMtze4vOo/ElG0Ehg2oqeZn/Z3Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977764; c=relaxed/simple;
	bh=HsHWbGXwbj/J2gyFknqrG8teWhHZwNzh/18vxP1wAjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fe/h9trFsCydXouhC0BcDZ/vPZfAll0n1kKZrHHEnA90s5jm1NBQJ1PTXUKyJc5X2tFkc8rU16PT6/hSsiPfS82A3l6LwyOXVQlBTycZTtW8mw6mkpBWSh0gBClApTKNgxD8FRvd3dlCvIIICmFqzc5dq4ffyOOU/iBMBtGR3G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHWz9/ZZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHWz9/ZZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C431F000E9;
	Mon, 17 Aug 2026 14:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977762;
	bh=39vCbSMHRyohZNMLyNfCjYkUlCj3Q8THOhERnzI2DpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHWz9/ZZTAA8Zf51gmNwxKEfS8OivMEaf7/x2G7oV+9T5PrQTeZ2C5G9aQacMZMmf
	 lM9DvLke1AFwIxAepUxBABU4TRx1VPOHDaUeyZ6d6kggvw2ru/2qy/d1nVh1EoRXBO
	 RYXvz+XkFErB+rFFTDkKeSivMKuq85q2cYq04PNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 401/456] ALSA: usb-audio: fix OOB write on Type II inbound URBs
Date: Mon, 17 Aug 2026 15:33:11 +0200
Message-ID: <20260817132555.009189258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baul Lee <baul.lee@xbow.com>

commit 69ee44e1a23be62318189dc4b37fa4ad94053269 upstream.

data_ep_set_params() sizes each URB transfer buffer before it adds the
Format Type II transfer delimiter:

	u->packets = urb_packs;
	u->buffer_size = maxsize * u->packets;

	if (fmt->fmt_type == UAC_FORMAT_TYPE_II)
		u->packets++; /* for transfer delimiter */
	u->urb = usb_alloc_urb(u->packets, GFP_KERNEL);

buffer_size is computed from the pre-increment packet count and never
recomputed, so for a Type II endpoint the buffer is one packet short of
the packet count the URB is built with.

prepare_inbound_urb() then lays out one iso frame per packet and never
consults buffer_size:

	offs = 0;
	for (i = 0; i < urb_ctx->packets; i++) {
		urb->iso_frame_desc[i].offset = offs;
		urb->iso_frame_desc[i].length = ep->curpacksize;
		offs += ep->curpacksize;
	}

	urb->transfer_buffer_length = offs;
	urb->number_of_packets = urb_ctx->packets;

The last descriptor therefore points one packet past the end of the
transfer buffer, where the host controller writes device data on every
inbound transfer.  prepare_silent_urb() and prepare_playback_urb() bound
their fill loops by ctx->buffer_size, so only capture is affected.

fmt_type comes from the device's audio streaming descriptors, so any
device advertising a Type II capture format hits this once userspace sets
hw_params on the stream.

KASAN on 7.2.0-rc5 (arm64) with a dummy_hcd/raw-gadget device, one report
per inbound transfer:

  BUG: KASAN: slab-out-of-bounds in dummy_timer
  Write of size 64 at addr ffff0000186171c0 by task cons02/166
   __asan_memcpy
   dummy_timer
   hrtimer_run_softirq
  Allocated by task 166:
   usb_alloc_coherent
   snd_usb_endpoint_set_params
  The buggy address is located 0 bytes to the right of
   allocated 64-byte region [ffff000018617180, ffff0000186171c0)

Compute buffer_size after the delimiter packet has been accounted for,
and bound the fill loop by buffer_size, as prepare_silent_urb() already
does on the outbound side.  This grows every Type II URB allocation by
one maxsize packet.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: 8fdff6a319e7 ("ALSA: snd-usb: implement new endpoint streaming model")
Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
Reported-by: Baul Lee <baul.lee@xbow.com>
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Link: https://patch.msgid.link/20260805013441.38245-1-baul.lee@xbow.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -387,13 +387,15 @@ static int prepare_inbound_urb(struct sn
 	case SND_USB_ENDPOINT_TYPE_DATA:
 		offs = 0;
 		for (i = 0; i < urb_ctx->packets; i++) {
+			if (offs + ep->curpacksize > urb_ctx->buffer_size)
+				break;
 			urb->iso_frame_desc[i].offset = offs;
 			urb->iso_frame_desc[i].length = ep->curpacksize;
 			offs += ep->curpacksize;
 		}
 
 		urb->transfer_buffer_length = offs;
-		urb->number_of_packets = urb_ctx->packets;
+		urb->number_of_packets = i;
 		break;
 
 	case SND_USB_ENDPOINT_TYPE_SYNC:
@@ -1251,10 +1253,10 @@ static int data_ep_set_params(struct snd
 		u->index = i;
 		u->ep = ep;
 		u->packets = urb_packs;
-		u->buffer_size = maxsize * u->packets;
 
 		if (fmt->fmt_type == UAC_FORMAT_TYPE_II)
 			u->packets++; /* for transfer delimiter */
+		u->buffer_size = maxsize * u->packets;
 		u->urb = usb_alloc_urb(u->packets, GFP_KERNEL);
 		if (!u->urb)
 			goto out_of_memory;



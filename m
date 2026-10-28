Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210598;
	b=Nz6UhUMzgpz+7xnbrrdfS8GNsidOhpe2IJrWU/9bO0GzNdTqiHX0WtXOIikn4WJmxnaK
	 fJPkjmPG9XqtMlX5DepsVfasfsEeVV6r2LMX/v4VjVowhDObe4rt141kbIMfqsr3tA712
	 nmLbsrnmVvWN/bWFgBiq6h71rV/74LD3e8Poun5QqQXAMys54KcCj27ftRMC17DxRNQNQ
	 ewEJiOCbtR9T/c0P6WMiwMdi2eMPORGkNk/N8l7t9xjJ31tqvtOwu2pokz+ultpcZmQmJ
	 8Es+2KT7T7apOV6VuLGgwBXwPKchSeyQ6thfiltPZiPhl7aHmrVLoiVH1MTb9qHG2Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=go9E8kQtiyrTTqbIZHphrV8ALp2C6jEmBc6qjgHQAuk=;
	b=uR7lTC2eLK8m/V9/fo0ej1VbHrvkk+f8dfN5Qq6pPFgOeWFx83ClGxLPb3q1mBmNdyZi
	 TY23dMzzwsqEeLehIUoM/hxLNbnkTCasqq/XRVNahojGSJ9EKQoVbVv79AoPiVQaWEAra
	 2fLlhjVloACpTccN+hkleeX/qwUrvm1/ynlyGOlMKEAAj0ws3df/lavtpfJ1neUNmQms1
	 2iI6M8txiJ7n2+gka8wWipr6qXn9j0EqzANhDRam/Fze2ZUDTAB730U2IHDybi+KbTQCd
	 6i8uEr42CM+kZDWalNCOjBXAcZ4qS8SEy9h/SK08NPIGdf353DqEn6RsgGeY66HMRkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=crRlF4QL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA63606A321;
	Wed, 28 Oct 2026 18:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=crRlF4QL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBB01F01825;
	Wed, 28 Oct 2026 18:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210598;
	bh=go9E8kQtiyrTTqbIZHphrV8ALp2C6jEmBc6qjgHQAuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=crRlF4QLNoSRBtWH8H1frBArEQ3N09ROS2z22fHBPG7Fvp2gkNqtBRwUM0dQ7M8mu
	 r7H2iiDO09nXcFZGqmHm+6IWknlVZLZae8JBJfYwg47sePQ/u+3dUnCgE04F4zVXtn
	 UQUQEvpDahUEBOs1zZZhbdHxTTY/kIAHhGAn9iZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+8eacd4fa193b1b28@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/571] ALSA: usb-audio: Clamp implicit feedback packet count to URB capacity
Date: Wed, 28 Oct 2026 17:53:04 +0100
Message-ID: <20261028170008.906818560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 76a986c980bb502c7688d605ac7a67fd257a9a1b ]

data_ep_set_params() allocates each data URB for exactly u->packets
isochronous frames, so urb->iso_frame_desc[] has u->packets slots and
ctx->packets is the driver's only record of that limit. For an implicit
feedback sink, snd_usb_queue_pending_output_urbs() overwrites it with the
sync source's packet count, which is calculated independently from the
capture endpoint's parameters. When that count is larger,
prepare_playback_urb() and prepare_silent_urb() can write
iso_frame_desc[] past the allocation; their existing bounds limit payload
bytes, not the descriptor index.

The reproducer uses a high-speed UAC2 device declaring bInterval 1 for
implicit feedback capture (8 packets) and bInterval 4 for playback
(1 packet). On the first capture completion after the stream starts, it
accesses seven descriptors spanning 112 bytes beyond the one-packet URB:

  BUG: KASAN: slab-out-of-bounds in prepare_playback_urb (sound/usb/pcm.c:1560)
  Write of size 4 at addr ffff88801e696ad0 by task vhci_rx/178
   prepare_playback_urb (sound/usb/pcm.c:1560)
   prepare_outbound_urb (sound/usb/endpoint.c:340)
   snd_usb_queue_pending_output_urbs (sound/usb/endpoint.c:501)
   snd_complete_urb (sound/usb/endpoint.c:1834)
   __usb_hcd_giveback_urb (drivers/usb/core/hcd.c:1657)
   usb_hcd_giveback_urb (drivers/usb/core/hcd.c:1741)
   vhci_rx_loop (drivers/usb/usbip/vhci_rx.c:107)
   kthread (kernel/kthread.c:436)
  The buggy address belongs to the object at ffff88801e696a00
   which belongs to the cache kmalloc-256 of size 256
  The buggy address is located 0 bytes to the right of
   allocated 208-byte region [ffff88801e696a00, ffff88801e696ad0)

Record the allocated packet count per endpoint and clamp both the adopted
count and the packet-size copy to it. Fold the Format Type II delimiter
into urb_packs before the allocation loop so the recorded limit matches
every URB.

Fixes: cf044e441902 ("ALSA: usb-audio: Update the number of packets properly at receiving")
Reported-by: co+8eacd4fa193b1b28@bugs.sh
Closes: https://lore.kernel.org/all/22xPn8drvIUtYgVeQnBiNqXuevOTpBAjepLz%40bugs.sh/
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260912200530.1955491-1-xmei5@asu.edu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.h     |  1 +
 sound/usb/endpoint.c | 12 +++++++-----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/sound/usb/card.h b/sound/usb/card.h
index ac5505ce046de..0d860c57d9d9d 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -115,6 +115,7 @@ struct snd_usb_endpoint {
 	unsigned int phase;		/* phase accumulator */
 	unsigned int maxpacksize;	/* max packet size in bytes */
 	unsigned int maxframesize;      /* max packet size in frames */
+	unsigned int max_urb_packs;	/* packets allocated per data URB */
 	unsigned int max_urb_frames;	/* max URB size in frames */
 	unsigned int curpacksize;	/* current packet size in bytes (for capture) */
 	unsigned int curframesize;      /* current packet size in frames (for capture) */
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index aab0ea614f4a8..5219111b79e58 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -496,9 +496,10 @@ int snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
 
 		/* copy over the length information */
 		if (implicit_fb) {
-			ctx->packets = packet->packets;
+			ctx->packets = min_t(int, packet->packets,
+					     ep->max_urb_packs);
 			memcpy(ctx->packet_size, packet->packet_size,
-			       packet->packets * sizeof(packet->packet_size[0]));
+			       ctx->packets * sizeof(packet->packet_size[0]));
 		}
 
 		/* call the data handler to fill in playback data */
@@ -1247,15 +1248,16 @@ static int data_ep_set_params(struct snd_usb_endpoint *ep)
 		ep->nurbs = min(max_urbs, urbs_per_period * ep->cur_buffer_periods);
 	}
 
+	if (fmt->fmt_type == UAC_FORMAT_TYPE_II)
+		urb_packs++; /* for transfer delimiter */
+	ep->max_urb_packs = urb_packs;
+
 	/* allocate and initialize data urbs */
 	for (i = 0; i < ep->nurbs; i++) {
 		struct snd_urb_ctx *u = &ep->urb[i];
 		u->index = i;
 		u->ep = ep;
 		u->packets = urb_packs;
-
-		if (fmt->fmt_type == UAC_FORMAT_TYPE_II)
-			u->packets++; /* for transfer delimiter */
 		u->buffer_size = maxsize * u->packets;
 		u->urb = usb_alloc_urb(u->packets, GFP_KERNEL);
 		if (!u->urb)
-- 
2.53.0




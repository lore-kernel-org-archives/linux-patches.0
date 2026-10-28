Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210572;
	b=EZtwhqVVBV7uQlV93lObgcI6c+1mw/Jk/80wvah/7BtBi8ynx5Gsl3IvjyUBU9HhtOux
	 B8tIkgtXeLEKg7vENwtoa4QIUc1BRnBcRsyoksNnUzexySNkZa9IKDqHU3pptEpdySwmq
	 HLOQRCIw0FTlWsMI1el3CpAY1HL0ZZd3dSXG9bovAaNBEg2s7/oIf8a6+a3zWuEzkcIoZ
	 pRC7QYGvlD37h0rFNDBZUlgiLbUn4lVnO22rE3Gk3GxWPT6iZ2WAgdS81Kjtkti4qZQdq
	 bDHyMvFpjAzcDvuc5qdQXxziVIipvPy4xJf3NXvdSlPy8yHDKrlLd2SSQpgmMZldE5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ffO4710DpFkbcaZQARZYAeEOgZC8pUd8eMgt44eySUM=;
	b=FXe24RmSbV9MhSzh9vVXN9xvGoi6i349vPFWAQhXM7GCi1mdgccu8xh7vsEcd0TLBF8H
	 JJzkfOBElmlQMLodFO1wr8LjDZTOabczhh5cvJ02ykTV+BHNuOXMBHzoRdh+rNnNsKbUs
	 YjHlf36K0SgX1r4nkEr4mSxsmNN3nu3ZVqxGXhDilTEk1dOlcYCzTBAN+MSCd+StbEsoa
	 bOoRCf7pjCbmn2VJ7A6yvFnctjw67C6647X6j3saxpKdndYxvrlH52FexVFDz7Q8xs+e8
	 lGfgRBKn6yzIVMA9Sy3aC8w453MiW6nUSclwvQB+CfJk8+vGF6LCNRVUHb77DwAmZsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kVPu0z2F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55303606A31D;
	Wed, 28 Oct 2026 18:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kVPu0z2F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66CE1F01825;
	Wed, 28 Oct 2026 18:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210572;
	bh=ffO4710DpFkbcaZQARZYAeEOgZC8pUd8eMgt44eySUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVPu0z2FdaPaDEev41HdI09ccARnwKEMgIZ76SsSVMrzibE+v/kAXsxiPAVPcyHAr
	 GXoxZrwljddO/X9dDoWzSAzlsjUnRmrTxmT7fj8VVkbEiJyzKw5jasIL7pF63aVYiG
	 ai9hDj0Cq5UF6XKzusLcKvFOS5kjbmh6Z4iafOwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/571] ALSA: usb-audio: Optimize the copy of packet sizes for implicit fb handling
Date: Wed, 28 Oct 2026 17:53:03 +0100
Message-ID: <20261028170008.882129667@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 36adb51ac0b19edb32ffeea3fe66b174bad25ead ]

We did manual copies over loop for the packet data update of the
implicit feedback, but this can be optimized with a simple memcpy().

Along with it, change the data type of snd_usb_packet_info struct to
align with other (from uint32_t to int).

No functional changes but only code optimizations.

Link: https://patch.msgid.link/20260216141209.1849200-3-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 76a986c980bb ("ALSA: usb-audio: Clamp implicit feedback packet count to URB capacity")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/card.h     | 2 +-
 sound/usb/endpoint.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/usb/card.h b/sound/usb/card.h
index 6ec95b2edf863..ac5505ce046de 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -89,7 +89,7 @@ struct snd_usb_endpoint {
 	struct snd_urb_ctx urb[MAX_URBS];
 
 	struct snd_usb_packet_info {
-		uint32_t packet_size[MAX_PACKS_HS];
+		int packet_size[MAX_PACKS_HS];
 		int packets;
 	} next_packet[MAX_URBS];
 	unsigned int next_packet_head;	/* ring buffer offset to read */
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index e995b7ab88b19..aab0ea614f4a8 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -477,7 +477,7 @@ int snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
 		unsigned long flags;
 		struct snd_usb_packet_info *packet;
 		struct snd_urb_ctx *ctx = NULL;
-		int err, i;
+		int err;
 
 		spin_lock_irqsave(&ep->lock, flags);
 		if ((!implicit_fb || ep->next_packet_queued > 0) &&
@@ -497,8 +497,8 @@ int snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
 		/* copy over the length information */
 		if (implicit_fb) {
 			ctx->packets = packet->packets;
-			for (i = 0; i < packet->packets; i++)
-				ctx->packet_size[i] = packet->packet_size[i];
+			memcpy(ctx->packet_size, packet->packet_size,
+			       packet->packets * sizeof(packet->packet_size[0]));
 		}
 
 		/* call the data handler to fill in playback data */
-- 
2.53.0




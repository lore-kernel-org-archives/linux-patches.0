Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2D95650E7;
	Wed, 30 Sep 2026 17:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790442; cv=none; b=t0Q9xiJRtKEp922YGGIyRohTaJQ804PMgKWioGM2YNLcvKhbO3fbJDEtIKf3LyNoY1M0Br+ErM5Y/deSMAXxXuMwm1QuEVHJQs4jpp5SXls/pSA4vAS+KKeKcR1FS7G1bwhShCS6lJxuoPoIqhGI6MVjwv8nUz2wpevVhRY9Op0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790442; c=relaxed/simple;
	bh=KWdorTWfzUVRyI/D1iTDJroi0cIld3+hfKNH7yjcFLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NL9SKsFINLKdUxC8Tqb9IY1znmkWFdqKay8/o1K4ikrXHi7jXSpFxS6A6zO0X1tbTFBW0eZfBO7YFiWy+yESEAF+evDGA6TMP+USiUijdCAV01vHCuMv3VU2gZhUe4EHTHAt6SJRUssr421eoIdPeqCKQt+ZKZhlxmxmcOlAuLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGZALiNP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGZALiNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5408A1F00898;
	Wed, 30 Sep 2026 17:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790440;
	bh=rL0uoEQ5V7NuHcDv+gfrWDh91/uT2LTsma/EmxeTL7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGZALiNPho4K619HFezU9/GjDsCX5vG9WPjBuz4MGv53Af+QKEhtyYjcukpDnxiQh
	 A61X0rWO/ija1UicHQ7Bi+jGAaQNU1KetvPLoPWRsNHZ7x50OUkW+M+XxO4sLAWaIT
	 x+eDEaKWGwJf0sWd96TUwMUeuCAESGvLslRmWvuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 786/877] ALSA: usb-audio: Optimize the copy of packet sizes for implicit fb handling
Date: Wed, 30 Sep 2026 17:28:17 +0200
Message-ID: <20260930152431.675322726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/card.h     |    2 +-
 sound/usb/endpoint.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

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
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -478,7 +478,7 @@ int snd_usb_queue_pending_output_urbs(st
 		unsigned long flags;
 		struct snd_usb_packet_info *packet;
 		struct snd_urb_ctx *ctx = NULL;
-		int err, i;
+		int err;
 
 		spin_lock_irqsave(&ep->lock, flags);
 		if ((!implicit_fb || ep->next_packet_queued > 0) &&
@@ -498,8 +498,8 @@ int snd_usb_queue_pending_output_urbs(st
 		/* copy over the length information */
 		if (implicit_fb) {
 			ctx->packets = packet->packets;
-			for (i = 0; i < packet->packets; i++)
-				ctx->packet_size[i] = packet->packet_size[i];
+			memcpy(ctx->packet_size, packet->packet_size,
+			       packet->packets * sizeof(packet->packet_size[0]));
 		}
 
 		/* call the data handler to fill in playback data */



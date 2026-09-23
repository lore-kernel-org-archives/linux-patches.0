Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B022153B35C;
	Wed, 23 Sep 2026 14:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175320; cv=none; b=efmgnYkp7ETR77hARG2QBZpdwkLIvVPuolINoOCxyNkgMeTVyJbzTqYhgsRf72PQCzleCXYAcQdMkifIVc2DcsZQKe1mtJigB7QPtzjODy8bcBX1sn14CMjk8/mPYH+wcxZyNvNueQ24IqkTC+pH6emuY/Djo1K/8w3Q+eDffzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175320; c=relaxed/simple;
	bh=YMdJzZnSe5qE4rt9TdJhrReRu8hku88w4TdpL/h2ETs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=la1BPIixA/9dphgLF0a4yoJalpSKCHRWVmmo/LGf8ueNCTrp6PK+4vYSBAByPfmHVQPwTxuVsFUmEZZxj1bidNlxusfD3njfIH+rkbhz6HEbjZE/zu43tWS9GGbjH3SLyhOaWwfLabqeT9vxdUaIi6pJHF0sUL4fy/dbfL7V8Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fap9qOuX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fap9qOuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6611F000FF;
	Wed, 23 Sep 2026 14:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175319;
	bh=KP6Di9DwhMJfDXdMU+VAP0O3hjIaivrplcYEs8DCfwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fap9qOuXnr0xUDF0IC/75KCws07TIaq2Mf8vltauCzIRfipDvWfVa8PqsBttw+RiE
	 JADu99fmzfaCgSL+JQiZ198t5Vsk5Z7e9c8a41epA0S4hQkefyWLF9kXmRDCnQhTD/
	 lrcUNi45J4jBKAMPnUDRnCUnzAslcz44ZBkq3Qug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 361/398] ALSA: usb-audio: Optimize the copy of packet sizes for implicit fb handling
Date: Wed, 23 Sep 2026 16:07:15 +0200
Message-ID: <20260923140652.782691794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -90,7 +90,7 @@ struct snd_usb_endpoint {
 	struct snd_urb_ctx urb[MAX_URBS];
 
 	struct snd_usb_packet_info {
-		uint32_t packet_size[MAX_PACKS_HS];
+		int packet_size[MAX_PACKS_HS];
 		int packets;
 	} next_packet[MAX_URBS];
 	unsigned int next_packet_head;	/* ring buffer offset to read */
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -470,7 +470,7 @@ int snd_usb_queue_pending_output_urbs(st
 	while (ep_state_running(ep)) {
 		struct snd_usb_packet_info *packet;
 		struct snd_urb_ctx *ctx = NULL;
-		int err, i;
+		int err;
 
 		scoped_guard(spinlock_irqsave, &ep->lock) {
 			if ((!implicit_fb || ep->next_packet_queued > 0) &&
@@ -490,8 +490,8 @@ int snd_usb_queue_pending_output_urbs(st
 		/* copy over the length information */
 		if (implicit_fb) {
 			ctx->packets = packet->packets;
-			for (i = 0; i < packet->packets; i++)
-				ctx->packet_size[i] = packet->packet_size[i];
+			memcpy(ctx->packet_size, packet->packet_size,
+			       packet->packets * sizeof(packet->packet_size[0]));
 		}
 
 		/* call the data handler to fill in playback data */



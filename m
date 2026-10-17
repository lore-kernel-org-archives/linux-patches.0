Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF76352C35;
	Sat, 17 Oct 2026 16:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255842; cv=none; b=E6l5a+Asm7eB8BXoB0KNEuYYYXQ6zYGNOwJDb3gZ1wCmNTDcJb58UWX2B/z6a2k1RQ1xkWiG1MpjOBxaQ15ckBD6OyXjaHH1EgCzKVFR77b8df7Kk1zZ2c/QzPX+XkUn2lOeiP701Fe1SnEnBrIsJeni5Wl6zuBngWfryldmakE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255842; c=relaxed/simple;
	bh=RP/vwB6Cj2npjtyXxlTf/rpxyaJ7g87WyQiUXDfv+K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwYyj1bZ3EdQuDUT0j4iSD+fNHjPdG7CZ82ChPjOtuT7l8MadsYYlm2y+pqzLkaRqoR+0nHoXgnn4ipw909M0EQeXN+csYX6KymVeB1T+8272A4jR1IcSl/s4KQQ0dkwCEm3BQeIFIIOFqVA6RPOPOwgEGJoeuILKLMKes78PEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WlhoDQZ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WlhoDQZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5071F000C4;
	Sat, 17 Oct 2026 16:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255840;
	bh=5dnB57yONS2O/xiF3HXP7fCQdD8O6SbDe18R73v/P0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WlhoDQZ/5Q5+P10pCoPN+rsAYnJMFvGbk3dver6Coh14lmjetJkeCjmLIOqU1OSXE
	 fzHGrRzdVi3fej37aAcHdQh5i4pdStN8mu5oXssna+RXp8NsFBpnVEofehX85YH5xE
	 0wSPNYbmhbYKYnunncLREqQdqjGSKJAWckt7yzhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0040/1674] ALSA: usb-audio: Optimize the copy of packet sizes for implicit fb handling
Date: Sat, 17 Oct 2026 17:38:32 +0200
Message-ID: <20261017160432.170555863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c393a9125b9b3..ade43bd97b991 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -478,7 +478,7 @@ int snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
 		unsigned long flags;
 		struct snd_usb_packet_info *packet;
 		struct snd_urb_ctx *ctx = NULL;
-		int err, i;
+		int err;
 
 		spin_lock_irqsave(&ep->lock, flags);
 		if ((!implicit_fb || ep->next_packet_queued > 0) &&
@@ -498,8 +498,8 @@ int snd_usb_queue_pending_output_urbs(struct snd_usb_endpoint *ep,
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




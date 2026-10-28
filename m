Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212138;
	b=YIS+yRrsrWg0cNeuaf83JiMQLCszJT64R6iBciDSaTKlVTShfD4pKY3D1pMJLJP5v5hT
	 ToWeVg1RwiThAxTq+nMSUrI5rzyHx8Ssx1QPWHendL0K1tVQbHcfMjzp/3LFjlm9/Ld+0
	 L+VVsj30EVCo2KaxKzb6XjdLpkt3dh+C0YnHu93Hy5NuHPaKe5IqcHekWPHrJz7vzjPrN
	 U9uzBTgGoBZZjvzhYhZmpS1opiQqqvsC2F8ExTkl80q5js6bURQm0v/BdywdXQBp/jZ+q
	 ZTTzCx0KGubY304GVVmG/JcHxhMC8o+3fxDpz5umPaLlY/4aJmVeCl2ZKqg2mwzEcJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pWD3FxpwHNkVA5twUlERyhLnPYf2BY/t1Boz4fuTKbQ=;
	b=DpaO3lWS31snCm7KKfEogd4ybkxduxoPeOAaK60TQ0EbmI7CBEbeFw/2iNLY0m3isg9+
	 Da47yRlR01s0sv8ZOlTE1znt7+7eF1JVJCowK0ehzR3/EZfTgDkIR9GaJteggoVpKfCO2
	 NBKItBlPWIWNzjYWaJ/5K9zv7qUEzwVLHkHvHxbdGSoDVQ+veOKO2GqATc3ck0YncrlrX
	 Vb1b9dEv5kbKwLOMx8XBMGA807JTOjeQccIisg7BqTbpMh16OOecfDz/dyF4RHfUn1wpR
	 cMJs0NraRf92xCpa1oGgDjSBRGkTav80+K4q0zXD1APXf1QIfqUKXlA9E9DOd0BftCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N99AF+wt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F61606A327;
	Wed, 28 Oct 2026 18:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N99AF+wt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1571F01825;
	Wed, 28 Oct 2026 18:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212138;
	bh=pWD3FxpwHNkVA5twUlERyhLnPYf2BY/t1Boz4fuTKbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N99AF+wto8XGz6xqFhNdJ6MV91qqQzlzivjaN6bchBiYFe+f2uSoewweh/lS8bN+p
	 KBzvRySzPVx9wwRUAmwGwwk+4uJsuVfAgF/9834AUrvXtbfJIcTs7OP5wUnH3fRjEP
	 iaFnUhXSr6sBY3prXU7rVgvdp/YDCAt+uJJmbukQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0050/1887] ALSA: usb-audio: Optimize the copy of packet sizes for implicit fb handling
Date: Wed, 28 Oct 2026 17:35:46 +0100
Message-ID: <20261028170500.365341758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 778466624f030..6cde8455da37b 100644
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




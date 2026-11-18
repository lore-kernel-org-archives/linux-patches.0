Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047026;
	b=nrc33wCE55atEIcoT1oX88QcN44+RMu9/EkSzkT443MfK1Luz00eUKvDwNszw3eLU54k
	 Cpr2ag+EN7At15rOmfyeHvVQtnNsKhlZYfKoim0pNFUC99bxysdd1bawgE1p6NTwufx0t
	 2GcBOixafCgAsJ6GMcgpLWu7r1ZhnK5yv8bBTA4MAuLdOndiKA2ygtOiAZOdlwzs1xJl2
	 rYGA3EDs6jEfCnmZZAdnEhEjsfPZz4BHlO5jJyEgbux8eZ3o9WGGM+B9HzXJ9DezxhWIu
	 Qe6/5oAMM6vw76n0fMY9oLp37iTdtdjJvfJI8JsnJYrMI2RPw8+BQ9LEAGb7jZSEVRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+E5FqbdYu/KgFvIbUyfQFEjsmNhnrhIs9967x3cawHk=;
	b=lMrj+T1UTLw7NehzWM7JdfnuK8rQOYqUl27qv70YCEO4hKFYTbXb//XCiq96NPjCdQg3
	 WCe1+wcJCP8efAbg59Q15Kexo3USeaLix3fmrEnc5OCNjqAXXcMDTgsin3PThq4BEp65B
	 SzvOM0DnXrGCk5MhFljfYx9CGYtv3QJHdHOGfSz0CtQg+JuUCfh3ASNvaH41/5AMskG4r
	 E2LoM1/ehuVnJuWjp6s5BtYQ6Ym+mxv6vdYjLcy+RJ35C36sOxEbEXCU53k9Oib1r6hOy
	 QMwlMGcmDVuFmevkira3PWVtCSvgF/hr2KS9rzt3FXFxEj2T86StdATSnVTyxmZe5AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BimI6rqs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679E960A380F;
	Thu, 19 Nov 2026 00:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BimI6rqs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A541F000C5;
	Thu, 19 Nov 2026 00:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047026;
	bh=+E5FqbdYu/KgFvIbUyfQFEjsmNhnrhIs9967x3cawHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BimI6rqsNjAZ5XdwTZWxI+DzL9P2blA887/Ku3xN3po4IsJUl1NrGAueN/ibqjGcm
	 9j1XKaV8vAtkIcutaPyCxn0z8LHVvVmlJi3tmtsb96/nEdM7Fv6tzZ7xbG+SxbrOyB
	 Uc8x9fPRqNH/B5RHCue1CzhHyNQxpBYHOL2J7gnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1491/2857] ALSA: emux: fix validation of snd_emux.num_ports
Date: Wed, 18 Nov 2026 15:42:05 +0100
Message-ID: <20261118150255.015895059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

[ Upstream commit 19061f35b3eaf4925960be44d870244b99df8d1d ]

Both bounds had off-by-one errors.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Message-ID: <20240406064830.1029573-4-oswald.buddenhagen@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 34e3e04b8a17 ("ALSA: emux: Fix UAF of soundfont zones at note-on")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/synth/emux/emux_seq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/synth/emux/emux_seq.c b/sound/synth/emux/emux_seq.c
index b227c7e0bc2ac..1adaa75df2f6a 100644
--- a/sound/synth/emux/emux_seq.c
+++ b/sound/synth/emux/emux_seq.c
@@ -65,11 +65,11 @@ snd_emux_init_seq(struct snd_emux *emu, struct snd_card *card, int index)
 		return -ENODEV;
 	}
 
-	if (emu->num_ports < 0) {
+	if (emu->num_ports <= 0) {
 		snd_printk(KERN_WARNING "seqports must be greater than zero\n");
 		emu->num_ports = 1;
-	} else if (emu->num_ports >= SNDRV_EMUX_MAX_PORTS) {
-		snd_printk(KERN_WARNING "too many ports."
+	} else if (emu->num_ports > SNDRV_EMUX_MAX_PORTS) {
+		snd_printk(KERN_WARNING "too many ports. "
 			   "limited max. ports %d\n", SNDRV_EMUX_MAX_PORTS);
 		emu->num_ports = SNDRV_EMUX_MAX_PORTS;
 	}
-- 
2.53.0




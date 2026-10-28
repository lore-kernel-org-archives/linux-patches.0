Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208340;
	b=mzZIUgwelHvXbJYqIq1GkR88c69ub1cDSMdJIM386bSSNs+JgfqFcgj53vkArGulKNlg
	 UUP11Hz2P1AkIRtSWFMmE7ggwE8dJhPeI7x1xNFx3lNgQgVTvNe3iBiyotHaJiu11brjd
	 adq07gEBNi6/aeedcRxu7jiJcMiOnrqqoeu6cvsqpq4omENRQNmwDK7U5x2nauN9KCA/w
	 oIQ2rgrOxX4RX/RtaWrxLnR1bXwuhdGqj/78ZjgY4y+Uoyb5328aXVaNA/kCWmSN/+b2N
	 1ztjRlwm68/9q9/ghTrqhdL0rZ5gA+cpPN4k9DhJaZ3T4eULeK6obO+ZTxGmTZtRqLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C/jteOiado5VU1zpa0ggXz3EnQrouy8la9ySolz1elM=;
	b=R3amyQbFOBHLyQqtT9Eg10gG2C9JCdUmsWYHQW1QmVjdoCk5hEnwz0ZlHv+l95J6TYDO
	 AUEf96Xjb+ZZ1x3tVBlOOH1njLikwZa6s+qC5hUlvhbaMevS9H3Dbq87qHumIwXHq3l/J
	 MSLJ6usw0OCi7yNPn6zLE41EF54Wx7vFJPSRG2HUkuuXRbs25QDD1+Z3cG9kX+v1VB441
	 N7vzpVtUxyfmoZHzhvNdUNkks2mNhXVNQE/NL3tyzPwhT54184SxyiJuSvhOmXcqS88jD
	 sH7/sWYeDEwJw0hvMUMPsQseqIGpkjS5Nknl/DYgf7gkMOdHfxyuJSDUTHpN0E1LBsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RzjYeiCt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E125606A31A;
	Wed, 28 Oct 2026 17:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RzjYeiCt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8121F01825;
	Wed, 28 Oct 2026 17:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208340;
	bh=C/jteOiado5VU1zpa0ggXz3EnQrouy8la9ySolz1elM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RzjYeiCtZ7Uy6CMFY2Csb1BYrxD6FG1E15WXv4zLlzHvAgLEeAXPNMj95su1l03rq
	 0X1Jjb01x7ydmUbAGwxHjLoVioCeegGPmQYUtTZFCVEnRcFnGBBBGebgV67A40Dt7q
	 HL+Yyt+EnLt2b7eQDUYZNNdqJEXfEdhVa3tHBtxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/516] ALSA: harmony: initialize locks before requesting IRQ
Date: Wed, 28 Oct 2026 17:53:56 +0100
Message-ID: <20261028170005.506309437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 33abb7491e89285a41565670945293dda841afc4 ]

snd_harmony_create() registers the IRQ before initializing h->lock and
h->mixer_lock. A pending interrupt can invoke the handler while these
locks are uninitialized.

Initialize both locks before requesting the IRQ so the handler always
sees valid lock state.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260830063411.2215691-1-runyu.xiao@seu.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/parisc/harmony.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/parisc/harmony.c b/sound/parisc/harmony.c
index 1440db8b4177f..f5cbcf7a7469a 100644
--- a/sound/parisc/harmony.c
+++ b/sound/parisc/harmony.c
@@ -903,6 +903,9 @@ snd_harmony_create(struct snd_card *card,
 		goto free_and_ret;
 	}
 		
+	spin_lock_init(&h->mixer_lock);
+	spin_lock_init(&h->lock);
+
 	err = request_irq(padev->irq, snd_harmony_interrupt, 0,
 			  "harmony", h);
 	if (err) {
@@ -912,9 +915,6 @@ snd_harmony_create(struct snd_card *card,
 	}
 	h->irq = padev->irq;
 
-	spin_lock_init(&h->mixer_lock);
-	spin_lock_init(&h->lock);
-
 	err = snd_device_new(card, SNDRV_DEV_LOWLEVEL, h, &ops);
 	if (err < 0)
 		goto free_and_ret;
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019235;
	b=k5r0wgbNfb8XQlltG/pvg6YwTfhk0K3t1DLuNZ5WuJphlcYDHjZRrhCfoyQONPruVOo8
	 fLaFGQOnN9lVPAIAvRINFLRTvNhx8ZFHlj/i2jbLR3s79pjvItnXA9rxM+wL/BnnpsHjG
	 mcT/IeMbjaNctHFtnF7fcfPsbjgFnm++dG5A7VcwdYAmi0eIkq8FFxrrBdcMUoHHZwGyM
	 HjRZjwrJWJ6wdWT6vF97wKI2AGD0/+ql7IMhqxBKdOLfkcVJJA4WSbieRWuPQsF4XU0f0
	 uE/CsyaOTxd0Gw52qS7sSFvlD+3OpUsKEwLrFtegRvFIwEdJziOpXvDTAxGy9TP1Qfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D5OSksPvON/xj3JtsvyR8/z2L/vEz70olFr8a4c5/Ok=;
	b=HhxTQ1pLF290SThkDmIBCdn853JIQj3dsxe248PJ51VR5w+csEnfOpN5P0fMlZcxfAlQ
	 Os22pTMHXsTd1y2hiQ6UgLn/Pg4KB7p4cB4fbwu+8NlEsfgl/DHJUoh3/zf2FU7Mj86ad
	 2rEntOBEd5fCBTFQS+fy55/+7B9SlcqNkrx0gRsUjzUJxUqKvciZY55QGX+vfkWfkk2mT
	 h1ovNPirqigAtHr3y7pfCNid6uO6Vas+GYY6PAPCtjkFgCNf1gj3Ff2n438XK+Auon4WA
	 ZrpgKR4DHT1KSgVdxNdXXUnYenqQ2Meh+HVCQNKrTZa++XeamNSgXLoyPBujNq4K3ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2VF50NOZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCEF60A2600;
	Wed, 18 Nov 2026 16:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2VF50NOZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1841F000C4;
	Wed, 18 Nov 2026 16:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019235;
	bh=D5OSksPvON/xj3JtsvyR8/z2L/vEz70olFr8a4c5/Ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2VF50NOZj7k9B3P3rzXOueMKnn39j2nEAKnxaKVDDNg2Vb+ZNOl0eMmufHb4wMf4n
	 RHUUiFwCCVNIdZUXVzjhyfljkZiT/ROzPNvCgac21StATOQCcgTE6XoLgU5YiidIo5
	 cpOiqkvgE0LnCCanmTFgodIXbfqdxDfbsKA4A2ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1522/2651] ALSA: core: Add missing barriers for power_ref vs card->shutdown
Date: Wed, 18 Nov 2026 15:46:02 +0100
Message-ID: <20261118150342.788566401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit a6913835735469751f56473f5212eb291a4805e7 ]

snd_power_ref_and_wait() increments card->power_ref and then reads
card->shutdown (and the power state) locklessly, while
snd_card_disconnect() sets card->shutdown and then waits for
power_ref to drop to zero via snd_power_sync_ref().  Due to the
missing barrier on both sides, the caller proceeds with shutdown still
seen as false, while the disconnect side sees a zero refcount and
continues tearing down incorrectly.

For addressing the potential race, add smp_mb__after_atomic() after
the refcount increment and smp_mb() before snd_power_sync_ref() in
snd_card_disconnect().

Fixes: e94fdbd7b25d ("ALSA: control: Track in-flight control read/write/tlv accesses")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Assisted-by: LLM
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172051.13240-9-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/core/init.c b/sound/core/init.c
index a51b71812fd9b..3b549eb553f1c 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -557,6 +557,8 @@ void snd_card_disconnect(struct snd_card *card)
 		clear_bit(card->number, snd_cards_lock);
 	}
 
+	/* order card->shutdown store against power_ref read */
+	smp_mb();
 	snd_power_sync_ref(card);
 }
 EXPORT_SYMBOL(snd_card_disconnect);
@@ -1174,6 +1176,8 @@ EXPORT_SYMBOL(snd_card_file_remove);
 int snd_power_ref_and_wait(struct snd_card *card)
 {
 	snd_power_ref(card);
+	/* order power_ref increment against card->shutdown read */
+	smp_mb__after_atomic();
 	if (snd_power_get_state(card) != SNDRV_CTL_POWER_D0) {
 		wait_event_cmd(card->power_sleep,
 			       card->shutdown ||
-- 
2.53.0




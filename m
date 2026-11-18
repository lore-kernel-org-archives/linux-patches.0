Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041095;
	b=aOOBrSwmPlFdNu/29VMOlTgQ9Eum6txV/eb60iRufa1BIj0wTLwHEqKxK6Z7Qmi4BZI5
	 QBE5e+fwLvEo2WOoQzSerelz+NoZrSVomA7w/Oer7osjyoPfFU7EX29X7rNkeZuRJ+7zP
	 l0Yl/B8LBIppZQXdRzr5kCBAsYD7bxSD375a43ziMi2swJGD9BVYaEhRgH5VeDKJOPhyN
	 XLR3RU88CTFa5A6iJEMUzP/X386R4TX6r3amumFVl4xILVwCc3/pFsarH9cRu/a63aGoU
	 OY4zvacBEU6h+LJRY5knTwl3DVNtot2kNSHxh5Uu8P0gnFl1iWplOtifPDXJ15S2b6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UekTq9bqIWPqB7uK0aCOVRgLHuVwRVbMIlXn5G71cDY=;
	b=ZeT32QFMiWvrNdBYnTDSRqUV+EWsZtpeMtHGd1NXTurlj78pFCQ7sSUZ7+ieLNqvX/Na
	 xWV/okyaSojRiUoN5esmTH2qa7nmxXUU8x3wDyK9QfJNzGwibSa8Z8ih6XZ8KQFxBr5TV
	 KGD64GEQxqh3Aa8FqFbiJqN44UCbj2IuzXvN9c29fBLAXF6qz1cNhUs0KGlOyGJdGB9IT
	 KXYzmc2Qa01x0uD2smZElyo0YmOw3RS/wLxQ49ska7tOhzkzUEIDOemA17VP8i6MFH7Vf
	 r5zBBNv8XfGDxzmn8VUIupOCC64NBvF1XZBNY4AyVbi4ORnygNYN7hajXoNwuqOh4Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BVFPwwdC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DE5606A32F;
	Wed, 18 Nov 2026 22:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BVFPwwdC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4602C1F000C4;
	Wed, 18 Nov 2026 22:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041094;
	bh=UekTq9bqIWPqB7uK0aCOVRgLHuVwRVbMIlXn5G71cDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BVFPwwdCdgl8kFRniL5Hwfku/9PnF4LvaYeSB88uA2JmSXO1fHH2eI/SnKgjIDN3j
	 QzBdYJQo+dIpVtmTnik0vArpolFpAB5kKNJq6C53iwp553xrYHDEbtYl7AEnLL3mtX
	 lmUjw0MNpmBTpxrlcbRdmx61R80eKkv6dzyJNK78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2691/3318] ALSA: core: Add missing barriers for power_ref vs card->shutdown
Date: Wed, 18 Nov 2026 15:55:13 +0100
Message-ID: <20261118150441.681726870@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c934e26207793..384c44f6b851f 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -555,6 +555,8 @@ void snd_card_disconnect(struct snd_card *card)
 		clear_bit(card->number, snd_cards_lock);
 	}
 
+	/* order card->shutdown store against power_ref read */
+	smp_mb();
 	snd_power_sync_ref(card);
 }
 EXPORT_SYMBOL(snd_card_disconnect);
@@ -1145,6 +1147,8 @@ EXPORT_SYMBOL(snd_card_file_remove);
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025950;
	b=ntNNgipg1WxQWOtNkXpSq1S6RHwxTQA2FK7UxGWs2ITlVxDO/GiwQAwQ44P45VAZ5aAF
	 XA4uZiuZspBRDEKelegx8j9UtMWureCD3JANNrW/JLopLpHp+mYsS39IV9Mi18wu7xgrb
	 cApLHorfcweXZTFUtHXDjmmXLAx6dOoYfcvkfzijxFTJDFBzpL6uywpKq4sJivWwQgosG
	 mCBbIYYbufX5c+mxyOCp1C36qzQIOlGeHH/nEYpsKJ+gheLA1hAR/zC5JzTl04oMFechG
	 QBa4Z86wHKZ5LP8zkdiB0aS5NOJ8nh5bBxbxuswIk7hyarxmYw5NEahDzR9v7zwEvnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UVHXIejQAgwOXlR3GkzRVzpNaE4pob0e9Uh38Ev6JxQ=;
	b=yrav1Tzt2B/GfG75P22bCfXdFSLDL0B8p8ouK58q+Hgx0/FQ84H92yS9vyUP/Ksl57FU
	 t2l7udq4ACrRCeG35cGRt1jUSv8dwPRX2YrNRI6ZLElX2GUHvtGm7R5D8XPX+MWgeEh8g
	 ImwUHUxE9nigGQaWQe6xOdhlXkGaFrRTVh7fw4/4nN03O5c5JebZ694+DwPreaHbzNocu
	 lcpa415c+5K1m63zr+l12LonZ/xsdQQ/Uiyk0eUS1DoHraElES2eVE0K4TSh/bEu1dj9v
	 eqJVpAWHmjsywWFq5SzWnHuMxVqS+jXvumRl7ric37vkwvCM5upgDPPBl2gn2Q8h3uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vU2QS7Fb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D62606A31C;
	Wed, 18 Nov 2026 18:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vU2QS7Fb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778691F000C5;
	Wed, 18 Nov 2026 18:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025950;
	bh=UVHXIejQAgwOXlR3GkzRVzpNaE4pob0e9Uh38Ev6JxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vU2QS7FboMbPFl/wh99DMd60JTOaw5yV3nWEHMjWwHB7jDmlHnO49kxPtOOs2nn0x
	 7FE2H3NHXfktmYNdUPTBUrZKBxBcU5LcHYhHelZxiMiorHXWIfo2axNwqkJcZXYg1W
	 i3if3H2wzQkmkSfUkbUWGCZ/WugApJI69SRC2520=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1261/2151] ALSA: core: Add missing barriers for power_ref vs card->shutdown
Date: Wed, 18 Nov 2026 15:49:56 +0100
Message-ID: <20261118150208.087709130@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 779729738b128..5e1be44b8036b 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -552,6 +552,8 @@ void snd_card_disconnect(struct snd_card *card)
 		clear_bit(card->number, snd_cards_lock);
 	}
 
+	/* order card->shutdown store against power_ref read */
+	smp_mb();
 	snd_power_sync_ref(card);
 }
 EXPORT_SYMBOL(snd_card_disconnect);
@@ -1140,6 +1142,8 @@ EXPORT_SYMBOL(snd_card_file_remove);
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




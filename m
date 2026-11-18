Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055968;
	b=3NCh6DdqUVU0Zgs89LPOJZLwo7sgjZmzwkmL8+oNldYoiPqW2NB5Q5rVjgF/Wj+gYNQR
	 vVqAr1R86/aTpUmgYnsU+gcnioIP3PxlQwyMcHCm8WORR4XXWoDRSJc5rnw9aWqTPp6JY
	 abCDCtHTyX0kdkBRqoDZQLlAhQ3W0KvYxYkr/XXq3XKDlr99J47Lc4yC6pF23MSQH37qk
	 2/6tG2NDRLR0R44ibCWqogc/K5CThdN93B0lW4xy3eefEkgDXYB5PfXE8nQd/b+fz0bae
	 bvWFIZCJ2bP0mEYt+Fi1gxgekpnHdw26ngT1mh/zPGG/Ce2uArowdKxRYiP4Mwib/WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lwNcgAwKnFta8J54Gluv2iDsA4uHO/ZgEVmtzkFZi9k=;
	b=w8ZihdrL94yXvNK697sD/JN03KWJvK3qumiKCNp8yUn4Nmo7OgpdI10FgT6NXAPre9sI
	 mY5diYQDBjsNNAUAlDE+YM9XusBbBYVz/PqO0pG8FWN4g6OxJVNPCAr6M0q1bDTUs0MdB
	 Q2qbVyxG/bUaAy9AVjScSAUC6FOAADOM72tiXKCzNhIvXUSbnEKy/GjcyZIL+DK54mtOM
	 IJUq3VAQVoN8EPZiiikmA3m+TQfhoA+zTcTYGbPNvVWuTmG6OPy2foyQZ6qifAyxGK8sX
	 GBtCaK+JZkHXH973yoqUYsjf0X9bgtm6CdLtI+53tiEsbnrBGndvkUFqTK6AHjU0vJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NdSZ2V6z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7978606A325;
	Thu, 19 Nov 2026 02:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NdSZ2V6z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7D31F000C4;
	Thu, 19 Nov 2026 02:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055967;
	bh=lwNcgAwKnFta8J54Gluv2iDsA4uHO/ZgEVmtzkFZi9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NdSZ2V6zTV7BPE9TRv/xjue5TKtEjdJQLHZHNZT4dH4+uH+Z5D0FiCASTpcQr1maF
	 ix9pfi2zQJ5FCut3HWCJx44PY+WC5nE0XIae9jrWJq5ebump75pPf2y6IptBrhcXTV
	 5F1ST+4lhF+ofbm0kZFZzNKO/dYsNcAAn4UBd8cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1813/2214] ALSA: core: Add missing barriers for power_ref vs card->shutdown
Date: Wed, 18 Nov 2026 15:58:09 +0100
Message-ID: <20261118150124.003087165@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index a1976a0c60ef1..8fb8f3b64d5a2 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -542,6 +542,8 @@ void snd_card_disconnect(struct snd_card *card)
 	clear_bit(card->number, snd_cards_lock);
 	mutex_unlock(&snd_card_mutex);
 
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




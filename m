Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019383;
	b=VLEtUcQSl7I8XnmtJ5NxPbfQQMvWSt+H/KplNP52M1EeobhrfWGoR91Go1Dqg9wbzhTo
	 qNTcmFwm9125GiFBwogZdwsw5R4P8eBn8oOb2mHzViS8VBO51PugjokUhd+FpFQ6P0OgY
	 Tar9vhdOVz2U35anSdoWNm6QWBfw+GwIt2rYWov70WzA76qmM2WuEfskCJbqlqosyZWgv
	 DRYEWgcpQzKWcRdrjY1tmgELwzpoI4adwG9//4NMbM7r9lsuCRMYLJ7ijPU+ys+4LiRaG
	 W0V84MWzKbFHRMtau4uDrW1g/MKUlFJIUyZWir/+aisrTpIGFellTP5PHBR9sGo6o2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kdeAIu9LmZMuSa+2Oyl9X1tP0KD6y9KaUHy5axKC5+g=;
	b=EbPXHc4y9h9WnaoctOrXRxaSymsRL37n3shFZ/i1nFUqyUa8k1U0VBxiq3bAXkA1b5y1
	 eN0n14jn7rMgqv0Hrx4dfYf5ZtFPmwuaBGW6LzY1HRDq90bb5oOUOBdzdS9kFlFxxrBC5
	 04MkvtKLHE6xm4L0/gks80bxKuH2e0mEpW7iKi0fTay+xuPAnL+athCGxHbmWr1v15zBz
	 /SkRS4HXE1qHmL7pdh+RYmKMkcT2vcS3TvhjytfzNkGWqBbKUhhDA79MjqG5Oggc7B5Yn
	 ehOkuCRaPht39wHpA0exylkk5NKk33FfTmsmsnIwwnUXrfVyVL4E6oXsHT71hdei0Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAaolZsi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320F160A260D;
	Wed, 18 Nov 2026 16:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAaolZsi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80ABE1F000C4;
	Wed, 18 Nov 2026 16:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019383;
	bh=kdeAIu9LmZMuSa+2Oyl9X1tP0KD6y9KaUHy5axKC5+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vAaolZsi69yj7iiCNvvsswSPwjn+b5SPfTurx5VfcFy5+YVBQ6AXSz2AeSjvmRrNw
	 3dgD/ymWsHqqFDW63ukV2UkD3QbTMh4pd5/GMKTbwdbRwVCsbfO2U8BWTcUFCHCmOo
	 BTL6k/2n6Ol0PiBfElcMUC9g4YuOkwlk5wvvyLek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1525/2651] ALSA: info: Fix memory leak at card removal
Date: Wed, 18 Nov 2026 15:46:05 +0100
Message-ID: <20261118150342.895208684@linuxfoundation.org>
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

[ Upstream commit a3e8eec7692eac706ba0934fa18453e46acd1a08 ]

The fix for potential deadlock at disconnection by the commit
c7a606519533 ("ALSA: info: Fix potential deadlock at disconnection")
clears card->proc_root pointer at snd_info_card_disconnect(), in order
just to be sure.  But this leads to a memory leak of card->proc_root
content that should have been released at a later call of
snd_info_card_free().

For addressing the memory leak, simply drop the card->proc_root
clearance at snd_info_card_disconnect().

Since card->proc_root might be still looked at in
snd_info_card_id_change() that may be running concurrently during the
connection procedure, add a sanity check there, too.

Fixes: c7a606519533 ("ALSA: info: Fix potential deadlock at disconnection")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20261006174002.703431-1-tiwai%40suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172533.14667-5-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/info.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/core/info.c b/sound/core/info.c
index 3b8ccda04e1a5..c4d57d0809adf 100644
--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -528,6 +528,8 @@ int snd_info_card_register(struct snd_card *card)
 void snd_info_card_id_change(struct snd_card *card)
 {
 	guard(mutex)(&info_mutex);
+	if (card->shutdown)
+		return;
 	if (card->proc_root_link) {
 		proc_remove(card->proc_root_link);
 		card->proc_root_link = NULL;
@@ -555,7 +557,6 @@ void snd_info_card_disconnect(struct snd_card *card)
 	if (card->proc_root)
 		snd_info_clear_entries(card->proc_root);
 	card->proc_root_link = NULL;
-	card->proc_root = NULL;
 }
 
 /*
-- 
2.53.0




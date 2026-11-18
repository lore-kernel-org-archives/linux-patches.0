Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041106;
	b=yZhhIYBQPyKa9APRTZgp1TXYmyfAfsPsCzCAiHafoDnyw9rArDgBbA8tCNLWGOlT/whm
	 SVCHhd+TDQtSDamELDe4ABJYZxRqDdb+3+rfyMRi5HkIUV506pjtQoo42fdhmQMHA98EB
	 gsA5YHWFfR2iseCdmFME3bvYeNNeWLuEfXqUrWPfPsvdxFalaoKIGGoeidZ1ijHMAWEmc
	 TGrHszV+sO2NlyEtEANvlcOCQq8xc12+HKRNwCw8wSoLAugELHs6vlzhmKKbb7yuz0u7L
	 Qwl2QTZkX3d4WPBUf59f3Ad93/oMgUjILkg0EdgRANiA+MwrPEPfV6KaUr3RhZjjuSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ni73IMbvmlR1laHJBtSaAk8Xwtu/41QjM/DjCAQehdY=;
	b=pTbqqVJiN7nPyVHkQHbzf52M06pm2Jhg+OwW8oSGlcjRqkBDLj+eAj1T/cHiXvmChs2V
	 VxQfgQpZkFKynG9snxpAVlZpwEflrQtTqCX+hU2bfRk8L6BZc9ZltP9PQexwgxvUlqE86
	 kpwd6hKGFaX6vDtsT44sS6WhAnOrY87C1Pq/Abl29CX5KyhOYSaGVkfRbmHwAbU/lP5gO
	 VAi2SpBsalF/bwHlNCTzz+gAhhda2/ENhLw10dvOjTH9JD9wbs3/2GAlmzIiGg6rUkdyu
	 nCw2pCd1yGv9Oala7bgE+pi2+1s5o9eReeBJDGi/p4cOlWtXS+8nEpqS6yVO3BBetSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Szll0oIo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C744606A31C;
	Wed, 18 Nov 2026 22:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Szll0oIo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2C61F000C4;
	Wed, 18 Nov 2026 22:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041106;
	bh=ni73IMbvmlR1laHJBtSaAk8Xwtu/41QjM/DjCAQehdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Szll0oIo6II4xoTDYcqYNyduTcmRuuLpwX7f/xYhBSihSilQG6S9+wgxKyhtQttJV
	 HpjWYquT3zNtBSZXJN+qp4c0Ejs81UC8sof/x6/DlUkoDy6YmiFcjK10YjCXz8AWLm
	 Fd2o6E2ZdTJR/lhe2ALy/AFR5bLTGSbxaSJRYkus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2695/3318] ALSA: info: Fix memory leak at card removal
Date: Wed, 18 Nov 2026 15:55:17 +0100
Message-ID: <20261118150441.785965127@linuxfoundation.org>
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
index 1f5b8a3d9e3b6..ce5caf28f041b 100644
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




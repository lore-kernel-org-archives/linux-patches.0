Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049364;
	b=J1ckQCv521+Kg4I86KnXHPxJnrclb0L/22VM1+5oSnNNaBq65ntOUDiPQNZfXmNJWcIW
	 tHMaVAHpFchdmXZjbBUcUd0oowg42Na/ka376IDI6iyTpDW9iadOaPfDBvoj8FMdSQbcZ
	 fzB7reW6/XQKR7q+SQut9Lm1ZMWpFZoeinacPUakoxtrtrx4GDz9yG5rgBwRWMA+2az21
	 bQSH/pZ/kvUoklTYS8FuUxewEUNCkuSBcsK05wkVYdQ0XqqO8O9SrKlVWO+OHZ7XQYEIR
	 RLWxrlWp3/4WHFUAZ48+IJ01gHP4Hh5l/elx6e1BcE25e3KVJgn5vfCfasiMw9IHg4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dezNDUKqqzc0NfXZmtUkCYmaV6+ws5xvSY9nH6Bqrts=;
	b=JMFclJlEum0zg5jNtUvgkTJRliN5hR9TWoolnMkudi9DDdvOA8ws5JD4OUi1ayfeF9zF
	 Zj4RJbCbZfBEegzfH+b6T6JPX0+1AeRO/xGZFqq9R29i9hzeQQvv1x7tBZrDFoxx1wjsS
	 E5Xi/zl43qUTwVT2vGzUWkWAxu+Be6HukUJKfOqXmbCCFpqQ7mE/vKnwEq5adcb8GmIYC
	 tC2EQjiQxZ3NZWcY/ztc2uUYazuSjtQhB7xdpza+iQyX9KhuBr9goMWe8ALqjTIX6zSPZ
	 xUxdZtdb5m22KSyde2UH4DwFiBQeneDus1kBybW0wMyPjKXHrGkNyXu3NXvyCqkuK8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ibzt8brF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0593E606A31C;
	Thu, 19 Nov 2026 00:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ibzt8brF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CBF1F000C5;
	Thu, 19 Nov 2026 00:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049363;
	bh=dezNDUKqqzc0NfXZmtUkCYmaV6+ws5xvSY9nH6Bqrts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibzt8brFpExHTq810qbSxoKWnd7mNSN7GdLjpsSwnlGkgJTceI3/g8dAXfNwGBkbe
	 eVek+VptpDyekDU2euAeuNqzlVRR8QHqI1lB3hntMhqreHq+8UEPzPLTtZHoKe2i5f
	 b/Hekr5Lau1u7KmnzpGjjJwTo9gCa9MpSJ2u1MYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2326/2857] ALSA: info: Fix memory leak at card removal
Date: Wed, 18 Nov 2026 15:56:00 +0100
Message-ID: <20261118150325.285970684@linuxfoundation.org>
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




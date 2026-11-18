Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019293;
	b=fDTQsZBM+4qpE7jpVIzKcXragGVQXkaXsEb48aykloFXfnlgmO3Jid0eL+VwEh1/4Qrm
	 wq5yfP77T8hiLakONqfj8nzyCR/o06IL80nEiSQK9pLqCBJMnu2mpciDnYUanLLjy4WZA
	 pHLjb82+QtFmQH64/XdY9PLp/sfbZPUEzGMZKg/VI6cVBP2sVSiYpAV32m2yAM+C3aOiO
	 AJSegcSPdOztFqezAgI4rziwsCAGkbWVljzWGIBTUjQLmFJpep0s82/cYF3Z4Hjd7rc8r
	 Qvw45nKLvfX9hxFN8um7YBQ+XyimpYSURBeUGnH96ycvihftK+FhqbDJ1EzjN0e+9iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0JisrNT78GbT2tJFiWoIz1BoSVj42MQNzhH8EwLO5SM=;
	b=elyY7wBaWBJwczoX5KucNPx4xXbBwAVfmQI2mvEXXbHnfZOlrByxwbEZ9a9Oq7JIPvqX
	 3ZcSzFGIy55TGfWDsSmUGxZp43EhfwrEemjEMBdka3gy6J8Kco+EnxkhLdl0Udp1N5Hq9
	 s36HOoUlg/ZZwIy0GXUZhTMhk98nD4E1xoJgVq3NAnCSD4dg/Txog40L2WKP2+G5Znnzy
	 DCY8jkfPxDOJLznFW+JSIs6ZAdn13Ltz7fBZOe8Zos4f4eB3ngwj1wkljO/tseVdKlvlD
	 9m0Ib/wecMKvmMCrripP72tayfzZCg/wYVr0Tf/h+Tdu6RtFpqe2MaZe8H4J9IiQyfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kkV7GaCh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C170B60A2620;
	Wed, 18 Nov 2026 16:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kkV7GaCh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6D31F000C6;
	Wed, 18 Nov 2026 16:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019293;
	bh=0JisrNT78GbT2tJFiWoIz1BoSVj42MQNzhH8EwLO5SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kkV7GaChGnT6pZs16fW4eq7CYq9DctS9mwGPJ4hJ5SwSy/9gL+ZlD7aClzuDx9OV/
	 C46CgYPaWXXUG2J0DjYJlM9xeOJXUf2NhEnfxyuLEX6XyjGO7NQF+VSL+eiCvljmUc
	 LidvaKrTRiBslrc4fs6lRHHHeAaBW0danYoY0K7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1527/2651] ALSA: core: Fix leaks at snd_card_init() error paths
Date: Wed, 18 Nov 2026 15:46:07 +0100
Message-ID: <20261118150342.960840271@linuxfoundation.org>
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

[ Upstream commit 344e74ac50aff89674a1bea153f008bfb31ed952 ]

When the snd_card object is initialized internally in snd_card_init(),
the error path of card->value_buf allocation returns straightly as an
error without invoking the destructor, which would leak resources.

Also, the other error paths in snd_card_init() release the card object
only via put_device(), and this misses the cleanups that are done in
snd_card_disconnect(); namely, the reserved slot bit in snd_cards_lock
is never cleared, so the card index remains occupied, and the debugfs
directory created for the card is left over.

Fix them by calling snd_card_free() at the error path, which performs
both the disconnection and the release properly.  As snd_card_free()
calls snd_device_free_all() internally, the explicit call is dropped,
and the error labels are unified.

Fixes: 84446536f63d ("ALSA: control: Verify put() result when in debug mode")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20261007172533.14667-7-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index 3b549eb553f1c..b77f99d088e71 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -356,7 +356,7 @@ static int snd_card_init(struct snd_card *card, struct device *parent,
 	err = snd_info_card_create(card);
 	if (err < 0) {
 		dev_err(parent, "unable to create card info\n");
-		goto __error_ctl;
+		goto __error;
 	}
 
 #ifdef CONFIG_SND_DEBUG
@@ -365,16 +365,16 @@ static int snd_card_init(struct snd_card *card, struct device *parent,
 #endif
 #ifdef CONFIG_SND_CTL_DEBUG
 	card->value_buf = kmalloc_obj(*card->value_buf);
-	if (!card->value_buf)
-		return -ENOMEM;
+	if (!card->value_buf) {
+		err = -ENOMEM;
+		goto __error;
+	}
 #endif
 	return 0;
 
-      __error_ctl:
-	snd_device_free_all(card);
       __error:
-	put_device(&card->card_dev);
-  	return err;
+	snd_card_free(card);
+	return err;
 }
 
 /**
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056088;
	b=nJhsWyLHtScSvo22XNU7GErej5e6QDfPD4YDnoXF0LJtBZG/suBOx9VQ2OnijIiS6Xmy
	 h9bFSwaZdHa2jNwygjjeA6K16qqVwctNIurLv2synDjtgd0acErV+PX5wmr0hDYT0pYb2
	 a9nmF9ZdPSamJGpJ/9MnxTjhDaRcl4uFk8fZpy998M1PUe7Xh/LPY1NnrkWW0UeUcXBkM
	 5eFujRpzRBmSoVcOYNB4QEwawwS+VR6fc+1getvEzMJ+fmdcgiyJSjVxayisG7WobJ4Fq
	 9FWCMMN5ATqhbcFc7xALT81y8j5+MQDqn3sgPYeD7u8qYKzcO5ja+YspkROFBBRxesQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9a+uMnEm3Hr9I9oluY0rsX/hJDyA8joKj1ta9FYnCWk=;
	b=AgNro5Z+1CJqI2YiIysUdmbNIPa0pXK9faH3TaQM3dHYPoum7oWq928uWJ0JBEtPgH7+
	 z6pUnMycBNu3Hr3CM6J24gab/hpM4csXbsDKNsaugUChvS/w7cLFw2knDFmd0iiXV8bEc
	 bOrxOnDw+efWGQlpyVmUg0odkcPuDnlXWUnPb33FMWu6mSHMegoeyWKD3LVD7ryKcGeFX
	 0RKygkmqDUe3kczqXsNbid5LA5/ks4FkZzgKhB8qsF1xFUjA9kp9jSK4UkY5iRyilsQup
	 8iDUgNxumg3jJ6TfJxvGCMLbdS2Pf/asI4rFX6npiPEKY46lxhbf7lnfRHxatawAkzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KnV08fCF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4010B606A32A;
	Thu, 19 Nov 2026 02:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KnV08fCF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF311F000C4;
	Thu, 19 Nov 2026 02:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056088;
	bh=9a+uMnEm3Hr9I9oluY0rsX/hJDyA8joKj1ta9FYnCWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KnV08fCFwXkNvLXjdW3aCwgpR3ELHqcNf9F3WS8WLilaLV30iwdpCYdP1jp3FsKfP
	 fVUz64R9m8wbcl8I9RvTzDZaolATlkNxPT8HTuP4dQ4ZRl4FLi9OOFnqPAh5AxSffX
	 m3unPrpnKoIumRUkr4MWZ5SQdAy9uBD4Uv7xDxPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1812/2214] ALSA: core: Check shutdown flag at D0 power-state, too
Date: Wed, 18 Nov 2026 15:58:08 +0100
Message-ID: <20261118150123.968353143@linuxfoundation.org>
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

[ Upstream commit ad63c5b62843895e8c3cd7291ed07cc659df0355 ]

The snd_power_ref_and_wait() skips the card->shutdown check when the
card is already in D0 state and immediately returns as successful, by
assuming the all-green in D0.  This assumption makes the code after
this sync point behaving as if all power is up and ready, even though
actually it might have been already at the disconnected state.

Add the missing check of shutdown flag there for the more consistent
behavior.

Cc: stable@vger.kernel.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260929125346.1478631-2-tiwai@suse.de
Stable-dep-of: a69138357354 ("ALSA: core: Add missing barriers for power_ref vs card->shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index b3c70ffa295bf..a1976a0c60ef1 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -1145,12 +1145,12 @@ EXPORT_SYMBOL(snd_card_file_remove);
 int snd_power_ref_and_wait(struct snd_card *card)
 {
 	snd_power_ref(card);
-	if (snd_power_get_state(card) == SNDRV_CTL_POWER_D0)
-		return 0;
-	wait_event_cmd(card->power_sleep,
-		       card->shutdown ||
-		       snd_power_get_state(card) == SNDRV_CTL_POWER_D0,
-		       snd_power_unref(card), snd_power_ref(card));
+	if (snd_power_get_state(card) != SNDRV_CTL_POWER_D0) {
+		wait_event_cmd(card->power_sleep,
+			       card->shutdown ||
+			       snd_power_get_state(card) == SNDRV_CTL_POWER_D0,
+			       snd_power_unref(card), snd_power_ref(card));
+	}
 	if (card->shutdown) {
 		snd_power_unref(card);
 		return  -ENODEV;
-- 
2.53.0




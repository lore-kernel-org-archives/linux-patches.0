Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041513;
	b=355KUqWnO7rXdf/WDyjgxCid5noQOxcv0E2TqLS7JHVnCXdXs06iLosCcf85G6fFAdgK
	 dd/qhdGumd+ceZ+pGVNRg/HITCaLuqro2zg6ydrNnaNBbuZCoSMdWaE4mkHC/85uCeKVG
	 Z9qyT15ega71zIybFtBk15NX/Jdr/GqI31lJX7Z1k/YUrCBO7yPgrAmmgVgJtMNF5glxa
	 cPfTXK+LeT5yFTOMv4UCkcc6kL+gmMrhljh9XqbcQrT2PtTNzdqe93XAyEWtP4G4QlPtT
	 eaHz0TKIXzsInoTi7auzzhxpySdAUF8ONoJWF4Q0qaQLo7qb8blDJco2al/HPY7XSaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YjopodnUxoEFgKWHpoooKk9rRuTquHqAcWusaopy4Uc=;
	b=zYVxfcAECvT124opj1iFb5DIlj6pPG6nNMtSh3Dy43qkKfOn/+4NVUKoggfVxURcpB+T
	 2sAg4kiDrXYyba2pSOdPuLtZD1g26ihYe89i2W9nAtzPjwbpBT4xk+E0I2gEgzEAUpkEf
	 16uHwQPBO4XYKQ13f3eNGafIlDOywYatIPXcVyjhR7RZry6Fhmq/2gHYsaL7/xFllIonV
	 0wNQKKAjeakWkuarPKaTKYjI31a0nuuW1zqFNFgL7KVkG17f7uN6B9DhcFaCUw/z3yNfJ
	 SGoFtbZd1evDopJueShVGVtHKNrUe/RmByEWxeF9xJVKUbUsco1MM8p/jjaW+qH8+wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1/OOyh30";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F13B606A32C;
	Wed, 18 Nov 2026 22:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1/OOyh30
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EA71F000C6;
	Wed, 18 Nov 2026 22:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041512;
	bh=YjopodnUxoEFgKWHpoooKk9rRuTquHqAcWusaopy4Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1/OOyh30y7WijWg3tj7S86ehJCJoLoOPi+x23dw2otewNx0aMC1p+GtPfCblaAFqF
	 ySy1UP0MFruuWKBhWFrMNO9GK6rgVvGska9mwQDS4pLkotqcjdk0Eg3g+sjZEZpRlb
	 iiRehZMVExcYs5/wwIr801k9Tr/v8h6utErUJdrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2839/3318] ALSA: jack: Fix kctl free at error in snd_jack_kctl_new()
Date: Wed, 18 Nov 2026 15:57:41 +0100
Message-ID: <20261118150445.790496881@linuxfoundation.org>
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

[ Upstream commit f421be924fec67f74bb0b6988ea8f0a3480df2a7 ]

When an error happens in snd_jack_kctl_new(), it tries to free the new
kcontrol element via snd_ctl_free_one().  But snd_ctl_free_one()
releases only the memories, and the internal linked list and hash
entries still remain, which may lead to bogus accesses to user.

Replace with the correct destructor, snd_ctl_remove(), for clearing
the whole resources of the given kcontrol, instead.

Fixes: 9058cbe1eed2 ("ALSA: jack: implement kctl creating for jack devices")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261013120528.52586-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/jack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/jack.c b/sound/core/jack.c
index 174571e130823..d5b4330747f22 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -454,7 +454,7 @@ static struct snd_jack_kctl * snd_jack_kctl_new(struct snd_card *card, const cha
 
 	return jack_kctl;
 error:
-	snd_ctl_free_one(kctl);
+	snd_ctl_remove(card, kctl);
 	return NULL;
 }
 
-- 
2.53.0




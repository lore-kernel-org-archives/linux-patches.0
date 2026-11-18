Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026560;
	b=n2IPtJtmCNo1o+YiTwkbwwvy1C81ZCpmX7UHpEyCUaisicFsLFlDOdAKHhcLVE1FCgwL
	 PibZieZTcQzP7gwCWisCoMGCSO52LXulM8C1j/ASIVSaF3uDox2j5lKnyafgzJ0i+K/+2
	 BxQ2IzdAqGGYzhJL+f1mQcFYwlexJb3wJEjOwvsCnqlzRA5dnUcnUau9PSskRfcR9RG2P
	 k42CmyKkTrstDNRM5srCSVRQXfeKCshnusUlLHbJEjTWhly/eBXQSpqfigZZJOv3GiEfC
	 jlckACppMS3VQRF1GL6qvlnPcnMvXu9SdACVb4YAeEDEn2E3KEg2fb4xtRZmNEpvv4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U4sheZpXQjgsOzK+7uuWrFLopN4eFtvy1i2MhiG1wQs=;
	b=aCuMtHp4NWvar0VPIwJokrAOPPJSwCQZQOmiGI0CxTy7puSxvqpW4hlcsqEwt2Txrues
	 Kgzqt0ult4XCDRyDxqKVaQGCfnRLrwM3LnGBKfXwfr6wbN+TEcizjZ0zvZK0TBXaKUkkI
	 pUE9EqRskv+wy8AbzUzDkfuDcI8Mb0vz0WDfYk7+6dBmRibXkbauP0f0Bk0Sz8jsn40lW
	 /G+fkBz8b7efrJ5P1+y+Cf//k/iCc7VrGMxPrkMkp01X2YjZ1/PTq/gKoQouwTs566R4G
	 UeWyaLcoq3lQK/2ItxjoiovBY0ADzmzHJR8Hv+9T3rD66hVjPJ8C0q46g21vELpJQJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lytV3oBw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45088606A31C;
	Wed, 18 Nov 2026 18:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lytV3oBw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9141F000C4;
	Wed, 18 Nov 2026 18:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026560;
	bh=U4sheZpXQjgsOzK+7uuWrFLopN4eFtvy1i2MhiG1wQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lytV3oBwoOnE3cy8lxmR371imSNXgVsKAwqbhi9UDK5HWBvWBt7EHJNCRjJwEvhhw
	 S7B1+vjPioFBPakut/1hjKAS0qnRFXfXuwY6UsrseslfbjkxOgkTXvt9PNYIWLMfBq
	 iC0+h34coR5I1M567itwP3UZ3+nKrqwHhvRqGRqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1480/2151] ALSA: jack: Fix kctl free at error in snd_jack_kctl_new()
Date: Wed, 18 Nov 2026 15:53:35 +0100
Message-ID: <20261118150215.802025423@linuxfoundation.org>
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
index 12a3a0fad3ccb..9f1f61892d940 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -456,7 +456,7 @@ static struct snd_jack_kctl * snd_jack_kctl_new(struct snd_card *card, const cha
 
 	return jack_kctl;
 error:
-	snd_ctl_free_one(kctl);
+	snd_ctl_remove(card, kctl);
 	return NULL;
 }
 
-- 
2.53.0




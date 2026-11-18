Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061634;
	b=4EiRyuhhvCSsYJEJ5yyNOM7qvEgyOn8n5CGmp7b9RAuna/VkTYIfSsaEejWi607bU2Aj
	 izl2LnogwfmWeEMUpuM4P0xmDZPhbSpD/gNEWAcTFTek8d5uQlgJcf+sLGqoD2JxFDiKx
	 DSjkesqbrj7lyiEs0ClTJL3JRc4QACLhzvfachNEuU9vieZjef8seessg3ua69Z8Bss+H
	 JaI72RyOxVjzQFiCr8QJ2ypCfPIQZnI8Vg8IAwUqV2fgKrySuQhBMLBEY+YZEQ0gELLBk
	 qXPPNSh6SJO9trZIruAD+hrLjsqB8hlRdHQGp+FS1SYvDWA1wIMrMKYfkwLoP9U9TzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PpmeSmbKkiCSor9PJcSm/h1Kz4yyE+DdvIJyvMDpKkA=;
	b=wNImcihMR6Us/Uwzz+lYhWbUT7yHdn3unamf6gI9xiRWm4QDD96mmSLo+zlqGli5vPrR
	 EQ/Y6zyURxs9wHINZ9JqbnXOe6mZN2W516k4f1jVgM8JKczb52GL96e1+XlENacKl+5gi
	 Ufwq75DQfQXYoWyup+WIQxQ/xQ6tj+A0nqEM8zTIP0WoK2IL+5O9LjlKXelTc+JWG/Iae
	 4wLLrCcvJVHV5VQCJRFrLGh/yHyWUv5dCCkz2ZVrF/gaV4nyDa9+tgi0HuuRscGWNUmYh
	 MhlDkNrdqAgGp0rsksZYTMzqAxOHUP/D1shxma11CMJvLsy99NMQrB6mzqMT+YPABHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfl5KovK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90274606A320;
	Thu, 19 Nov 2026 04:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gfl5KovK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35DA1F000C4;
	Thu, 19 Nov 2026 04:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061634;
	bh=PpmeSmbKkiCSor9PJcSm/h1Kz4yyE+DdvIJyvMDpKkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gfl5KovKoTeHyDJXj75+Ih8K9NDN44fKmPnf2L9lBnrA5Ki5mS59jvceGo/AcnhdN
	 iKm0dPOL1WZi9R5aAHYd4VVucJj+1jCxX+9ejHTHxy0DpglK8PPE16mTUwZRQtnIby
	 b1zLbtkurs7Whcq0Jq+Z/C/Qq3wzqQSNARDycmVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1623/1848] ALSA: jack: Fix kctl free at error in snd_jack_kctl_new()
Date: Wed, 18 Nov 2026 16:01:01 +0100
Message-ID: <20261118150027.512702287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8a9baa084191f..800416093decb 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -163,7 +163,7 @@ static struct snd_jack_kctl * snd_jack_kctl_new(struct snd_card *card, const cha
 
 	return jack_kctl;
 error:
-	snd_ctl_free_one(kctl);
+	snd_ctl_remove(card, kctl);
 	return NULL;
 }
 
-- 
2.53.0




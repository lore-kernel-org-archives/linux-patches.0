Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020068;
	b=yqDSMrw508hygy+Mxe7yxbWxxHIrC6d7hqV2lPYuK8sZQO5bpL8j0ZtC1EiHS88fgWZK
	 rySJPmdU4YBRdDl7cUgD1KoJOuiqmaYDIzvNm2bTQeNP+KTkew/xcpkA+ET55xeocepVP
	 PNAM3GYh9Vo0O74k67oE5umtV0rVy6vultId+BaAanLIGUTxOxjOT83UuHzu+me3bwfzq
	 tUWxnkS2j6dPyVvxRFkoQOgptDOdTbugWCIPiEBIeeja0+OjM4XxcDVGiYKksOspU/4je
	 WbUS2Yb4Rn7zHYSFVt+LoSz5geY+4pt/K3HviI+rHST3c1TuOh0elOfwiKafH+W4jow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aWFW5KVBgwG75CDxkNPTRfGYsFPGJF6wdCiYvRrlmG8=;
	b=3ePtR8VVmU0cSPZ0wIN4QaNSW6CmZu7CsIiwfA+lPMR/NeLSr1xI7hBmNKFp9+wJdEmh
	 vXZzAuvJAUZFPiPrZHqfopR83AqeE7KX8vwa+9Wr5pzzhGcWZVf3RPQGWuMkJSe7QElus
	 F8SzvyBqoFZSYlo97F0C0zeCh3c5nFFXz5TsbmwITo8FTm72LI1iWK9SRs9dOzeb45Kie
	 5uXCeKsNOQu0sxXkvJzFm2ELSbtps5Vv8c159C/edi70MuG+S5+P5E6ySq63QZAJiXqyf
	 KnsIROtj4y9SW54ax6t6Qc5LfnaK8HxyNajoQE7DOxqNGnFdnIX6nJrfnIfl4V+T43Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DI2hFY6M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFE7606A320;
	Wed, 18 Nov 2026 16:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DI2hFY6M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803FD1F000C9;
	Wed, 18 Nov 2026 16:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020068;
	bh=aWFW5KVBgwG75CDxkNPTRfGYsFPGJF6wdCiYvRrlmG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DI2hFY6MKMyWJGAnA3pNLSxsf75vrtvDQO4wEzsHsvuKZMAUE7DKedTJtQ7PhpvDz
	 ILuAdwT8J6dlAM784HRav6pUHef18dZR3wOpBdwzZyUbLrEZtcCeK0VvKHm0X/T5di
	 WJES2r7qxmwlv/hV0ZrCVWgQ+wfsSOsV2mJZW4uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1819/2651] ALSA: jack: Fix kctl free at error in snd_jack_kctl_new()
Date: Wed, 18 Nov 2026 15:50:59 +0100
Message-ID: <20261118150352.677016445@linuxfoundation.org>
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
index 5cc9c42de9811..d9132b885ea3c 100644
--- a/sound/core/jack.c
+++ b/sound/core/jack.c
@@ -453,7 +453,7 @@ static struct snd_jack_kctl * snd_jack_kctl_new(struct snd_card *card, const cha
 
 	return jack_kctl;
 error:
-	snd_ctl_free_one(kctl);
+	snd_ctl_remove(card, kctl);
 	return NULL;
 }
 
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031775;
	b=oGKIsarZbpWfmx1DGs7SQdR61NVJRwffl3cr1Zvj/K8OzCnYXFGZL2LtLG2Zp202U5ys
	 HS0F1q168pUo6tOX/4DHJFnXvkx6rMNeoYVpGlWht71Gzavil9GXd44Zx6PFkI5ZnG26u
	 0GiCGVUZeJiixOCM/ek9lDXIb81Vj4hfRY9jhUzt0nqNjNXaCDrGjcUSXLE5rv4E9ui8x
	 9NJMXAKqBgu0zE/EdHVziJalcmEHoBJ/teDSzTqZM3kSPJVlv/bDaS6/eIwE9rDp8LvQn
	 WuJSTWajnJJVJbyoBdOGSBFx1NZiZXVI3mf3zKDkzD5umEAyDvFtSvPovLHbULsvnHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DOJykFySdZpy5xJDBYh0rSOXtvyv+MJabc7QjR7WTgs=;
	b=g2LUHZigjdzzDDdf3ZIoEKt7ddaaY6hnQ633qPlZ/XDO9PbkfqPY6EFPUznyz6R4+M5X
	 XwLOOO1mozvdRbpTmM2HerUV5b8eaGB3gEZJ4QuPMtpo7Tl5X1P3sHN1A9XoKwmSpX7YQ
	 mrdJOx1NH+PbKH4WlrToe3lBiV8DWiYbdqyUSrLFvPsVFfLt5qldsif4BOIF0JkEAcMV+
	 p1PX1PfV1MGKOU2/1LPiRxaEQSWrMiIQr+RJ1DoEPDLHXUUYoZ4jJnaFTrMxoCkFFYSeB
	 nJc0BloQhnAnQMfpLQuFxYcHuVUxemKwhX+yYZ1Yd8BhXfs8/uTNopKUnKssJIlaPhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itDgXiTI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6983460A2607;
	Wed, 18 Nov 2026 19:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=itDgXiTI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A401F000C6;
	Wed, 18 Nov 2026 19:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031775;
	bh=DOJykFySdZpy5xJDBYh0rSOXtvyv+MJabc7QjR7WTgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itDgXiTIW3z/Ll1myF6gb47wIA95qQNyaI1t+dsG6QiB/S3OeKZFXg42YmVBwNiMw
	 Q4DeypTVFugWsVEHnA42o/9EQs0N0HdYIVspDyfZqXlQG1c7sebzDDXReKJ+Noczpz
	 5vwghHp4eVhaurWI8xdEsCJl+R1+K/vQVQSQDm34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1176/1756] ALSA: jack: Fix kctl free at error in snd_jack_kctl_new()
Date: Wed, 18 Nov 2026 15:55:03 +0100
Message-ID: <20261118150056.762564442@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 63467828ac6ee..b6f5dcbae8b0e 100644
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




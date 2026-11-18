Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049843;
	b=NpdS8AVkqnIc2NQFpM/A6Ga3yrZFSOYTzO4IeS2p5Xd8xvz8lEswiES13MtT0cO5hkKx
	 ey3DAKTEOg9R4rcl9lNhw8t+qHsvyn59Vz7HlI3wJMSIJSfD/DUCHCE1qSWR3XrBKjoB7
	 ZgqLY3ijCSpzc6zlNpmvfScoSpBGa1mhqKV25+vqsCzkXnn6oDS1T5sIH+rY8aSEPrRjA
	 Sp9eofTchmInvHpBuraaTlTISn8+TLM0fUtvHW1CaLBqeGe4GD5aTKZNIxawvrnWRGBXy
	 jZa30ugwgE8ch/1sWUs8vLKUiqkRNtg48aOvhV+Qs8Wc9rPf5MA73udvnYvuSBCiksA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XLxpdla1+69ABJhE6Uolq/DTRkoexPSzZtrl9q1i5FA=;
	b=VNwxwzojLTCHYcPkZYEju5kf1x1Kp/KyCKYV6A93q6Nlu1uCv+jEw3/By1B0Ik7y5gQb
	 TbRTvQcf7POaDwdgRSxyYk9WnRlKZvRjhebMEtF8HZdkOwBZRbAqfOQtqFcedQY+rlV2R
	 St1umAPU/V4MQZ7xPNex83VLEaZmRWSMe2E5KvAkkOPDdTp/1opyrWmvD2VH/x4SB9G0J
	 ZLZPgYJiaYEIQuO9nH8q1oKFOOwetZ6OUlutjv0s+nJgEsme9uYge85M4F/4gjHig2gJB
	 eXcEI/ko8URbpo0z/fNp7f7L5VCxe5pSzIQw1/WAT596OWn8+k2dytdt07IE1A4NKKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yN98eU4p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EFB606A31C;
	Thu, 19 Nov 2026 00:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yN98eU4p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E561F000C4;
	Thu, 19 Nov 2026 00:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049843;
	bh=XLxpdla1+69ABJhE6Uolq/DTRkoexPSzZtrl9q1i5FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yN98eU4p53BI8/q3WyLYTnOUvdO2MF8kJ9PZ7OEAeQPkj/bTYW83/gDDhh/hmBvms
	 0IYxpuOowkZZ8FquTpsgid0GC5NqZewA5PldA4Wm7pGzX+chNoE0St8MS2m+0m1508
	 s+Kperlp/gVU+MAtEixK1c7VppeyP0/iC+NoIrP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2455/2857] ALSA: jack: Fix kctl free at error in snd_jack_kctl_new()
Date: Wed, 18 Nov 2026 15:58:09 +0100
Message-ID: <20261118150329.961100106@linuxfoundation.org>
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062137;
	b=QRAn8qzQAFL9jOoaxbLRUWM6Rxg25iBPaw+UniGPcmgKiH5QG2cCpmKnkGeJ0nowA0Pr
	 odwNEqLAPm0hYcDyhVUK2Z1RWd5VOzVIVnuy1Q9KKtrMj8UaRX1DH2RBU44ZTssjIRdZP
	 jtLsnwE0YhjTyyKqUreU21dsA8mxx9FSAwIj7kX7PKhBIpwnFPUjOPsE4E12XWNqKB8IY
	 kecR9g3XQeIK382YK6VozQq2ePNVo+8e2rTnOEltjQ0dFsd5+qLW0rY0LeMhretLqHn+g
	 69wsjQNwvD38lI19XdD3dWYcRNOLW3km4DB2TBbSIPMPNUVb1PF4m97K0v4Kh4ycdZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q0sMguYZewpExcXJd9eellAXyGXe/qjfpygWaFQQ8t4=;
	b=Ivb2DQ9GRo5Tuux0RyDwPmYar7DUM4a+04GdnSby18KyPgA12lxJ2iwQc09W2bR33URs
	 ecr9omfouQUfJiS7KS3evch9Hwj+PtanuXmQN6dsSaRD6/ES+xl7cCkabhy7B3E5N4Hzl
	 0Ac5LbPncnkygNEXzS3PQiqvBT0ysn5VWLhWRBFewkK8hVucemcRolzz0fbflYzBq9JwJ
	 sNWo7AKk1ipQol4nffo7WsG9z4iS8EH9EutD5w14ruShyPq2Kcn7L2QECdO//vCLUtCql
	 /Me+haRSt1Em6B53rvt6NsPUjc+m7CmVvOlXaMMKXDBxZDd4PJuirsv6fOA00xkPZSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2POzHJm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C635606A653;
	Sat,  7 Nov 2026 14:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2POzHJm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C2A1F0089F;
	Sat,  7 Nov 2026 14:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062137;
	bh=Q0sMguYZewpExcXJd9eellAXyGXe/qjfpygWaFQQ8t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2POzHJm2KWh3v+UrzBdJEU1z+h89eygUwnyCkk9ZYnNxtKbGwD1jgm+DPtSf3aFn
	 BT++BYoz3Czn0Qcyg3SwcgLoqLWHiJGwpnMeA2zH6UcNL5yraCYfhOVB8LE7PBILhk
	 S89MU0Xa2KQtoNpUH9hnIIMN3ksSV8Ip4Sh77CA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1103/1536] ALSA: core: Check shutdown flag at D0 power-state, too
Date: Sat,  7 Nov 2026 08:51:59 -0500
Message-ID: <20261107135028.680601367@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index 87c10bd900a73..92dff1736cfe9 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -1143,12 +1143,12 @@ EXPORT_SYMBOL(snd_card_file_remove);
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




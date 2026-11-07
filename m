Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063045;
	b=yDrulGP8izZZ7ZivshAZCKnXREoIYYGWVXL6Ah+ODxiexw8ciGIwaUGEQS4pFKS1nNPc
	 6WEzzaN1fzVntNH4GfruMYX/nSaKAUpmM2gehxnq8lZe5eGHjl3FFNjvYcM9I3Ul1EBYe
	 nm3q+NEL4rU4OmtmdQFhJbvo5xfgIqY8tYNYzd7+3EKGQR9pZ1vaenivVyX0cy/OzPgXw
	 2wlb2VlJAqtQ7lGymG9uv09rFVcYhM6COj2WSX1kViPdjSbvEoJ3F4TVzIOR/6ksKs3uW
	 yAXorl71fqaNmOF5+fOW5BzMQErEnsPfvfwY5+pm1bVGFn/C4QHFCpb6e7PkY8tnAig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DDk6vluU48kKFfhgly12/xxRN1Fa6b2VPenSd4ByWpU=;
	b=yDG6sf0ouhLFX6whs4543rEnewm4bRbplamBDbKEQSIcaOb5neBDQCCDrB2g/qJllqDz
	 B7laSVvJDFYscSPCsAZo1DsPmFYnRYvJrBd9qLSjd7bnlr89AYHzFWejuVb+p6K+1jdoP
	 SkNtrn6mgSjpOKK1cXpAxGqNJGamb2Zc8rLCRyrVB/OC7OnWea++HNImuI4h3e/Pb9vaR
	 v1sG33/R4CXiEwmFnTqtn2tkrhw56hP2JOaRXFeTOexgBSbLgag102SQRkCnLvmnOwPfC
	 yd9W3WvW4mv7DvHmILCq2RlqcxL5S1J/X/sRgJNRwyTx3UFHLrg3V+1PctQHvBokuDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m5UG1QW9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F18606D806;
	Sat,  7 Nov 2026 14:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m5UG1QW9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CDC1F008A1;
	Sat,  7 Nov 2026 14:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063045;
	bh=DDk6vluU48kKFfhgly12/xxRN1Fa6b2VPenSd4ByWpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m5UG1QW9RU50V49La9DMBhaE9PY/orsRTIwDyEmHU/WjmEoEZYVNK66fpgmYToBdf
	 tjLQr0zgKD3MxtjIP/DPtaulgzN56X3hJfSXa7pFHGepH/UV9RyKSd0HEGzQisG4WU
	 Dx8Xj+zAgMhvrpSL+p2QV6YdyJu7eT3QYz1KCHfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 291/869] ALSA: core: Check shutdown flag at D0 power-state, too
Date: Sat,  7 Nov 2026 08:49:33 -0500
Message-ID: <20261107134901.797615009@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 3a45fa6fc515e..2bf98de846f61 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -1141,12 +1141,12 @@ EXPORT_SYMBOL(snd_card_file_remove);
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




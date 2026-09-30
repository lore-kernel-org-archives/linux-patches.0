Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685C05221DC;
	Wed, 30 Sep 2026 17:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790953; cv=none; b=Wo9sxs5MjiIhdr+4FFlqwWl3muYw886hoOiLsqtb791vJLeT91yRSsYrwyfhUO/XkO/6MzUGQniomJtHnX0u9VcQJTJEqhpNbi/505+QgxUm7tptU+sjMjaOBPvE7F3SSFA7DecdMfjfALutAwmm0H7aGcEoUZAsHUU1WGzy5ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790953; c=relaxed/simple;
	bh=xYYxiVkPe6YBEpYhNQdhV2ykutS2/oAGjSsAesrusz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FO812BQTUnOCAn4lF80SAc1VKXMcr/ZiVZVopjMgZBF2KUpS5S4nkyOA/kcC7v3fzFj+t5733wqBBmsCpepvY5RyENYP4G235Id/jhbY0YwtQ0lyQ2HRhKdKizjF93bX9TzNYCi8yDbGC+70iOM7j+0CBuO2tA/6BzODhqZX7Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqsLpa74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqsLpa74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25581F000FF;
	Wed, 30 Sep 2026 17:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790952;
	bh=0a0DmgYeG/oTLoKEQ2McPUbOujiWmpc9qrwOjqy7Ld4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oqsLpa74/3whc0j6F+S1Ch1GprW8JaXZYkFR9+3AWkMKzF/DJl13/qg/L0SZEn1aY
	 Ae+FznCsAAJWyZkRQMCXBEwvvQ7MeoFSt3VyOmAsf2xPch3xHD7eZQ/GA3fkjZ2Mo5
	 i+1WHBK3iAXKq5KaEqI1LOcqHnUUA7/i8AMExx5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/752] ALSA: es18xx: check control allocation before private data setup
Date: Wed, 30 Sep 2026 17:19:55 +0200
Message-ID: <20260930152400.884719792@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 422e42b7c2b882ba1d16d4afc8891bcea7c4de93 ]

snd_es18xx_mixer() creates controls with snd_ctl_new1() and then stores
bookkeeping pointers or sets private_free before calling snd_ctl_add().
snd_ctl_new1() can return NULL on allocation failure, so those writes
can dereference a NULL control pointer.

Check the returned control pointers before using them and return -ENOMEM
on allocation failure.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://patch.msgid.link/20260607074219.3-1-ruoyuw560@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/es18xx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index 3fcd168480b64..5d9808e59b591 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -1779,6 +1779,8 @@ static int snd_es18xx_mixer(struct snd_card *card)
 	for (idx = 0; idx < ARRAY_SIZE(snd_es18xx_base_controls); idx++) {
 		struct snd_kcontrol *kctl;
 		kctl = snd_ctl_new1(&snd_es18xx_base_controls[idx], chip);
+		if (!kctl)
+			return -ENOMEM;
 		if (chip->caps & ES18XX_HWV) {
 			switch (idx) {
 			case 0:
@@ -1840,6 +1842,8 @@ static int snd_es18xx_mixer(struct snd_card *card)
 		for (idx = 0; idx < ARRAY_SIZE(snd_es18xx_hw_volume_controls); idx++) {
 			struct snd_kcontrol *kctl;
 			kctl = snd_ctl_new1(&snd_es18xx_hw_volume_controls[idx], chip);
+			if (!kctl)
+				return -ENOMEM;
 			if (idx == 0)
 				chip->hw_volume = kctl;
 			else
-- 
2.53.0




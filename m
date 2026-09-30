Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5C14DD3D1;
	Wed, 30 Sep 2026 16:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784465; cv=none; b=fxAyXlzPOkNstEN0EqFnkSGSBnjNYOGQpYxwZpKBwUHWcKUYveFhzGG8/5ovLxvU+/+lhNchL0HRfqDJ2iyR0I209LZLw+cKvc7p72JdMerza6wZysjLqZflSQa7L+VtTB5abrl7XRYUTXoJNBfOezQ1wg2ohZM0RQaUlPHcpjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784465; c=relaxed/simple;
	bh=0ovEyxpl04AHIxgoWCm9aP4gl6flIPOOTA1tBA9HAYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7Xj1wBKJdO3rdzhmiPPkoKNBWkuaAAwRYEcVcIjeM6vpxqfq2L4BN1MUo8DQHu3BLok6I73+RM8CkwDog11kWkMxy4a4pXRkophmU4fX7hRs0MLrXJSJpP8eKa92M9sxHd/DoMD+Py3r79/PbM3bHLr5rDqq0ZyyvTfktYqSyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzKDuM0k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzKDuM0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E381F0089D;
	Wed, 30 Sep 2026 16:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784456;
	bh=Bs4zgO44jXs22R6VHvDyid7KaJFPRysS+bKg/Nzo89Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzKDuM0ko6he6CpkhGm4tjtavEnhBlchQoxIa30R6NNuSc433ll7vEudkp94kWool
	 1owX5E85aIpKKrSQJ5baXFeHKhZLVDeZv+AFRnJlCR1yWDAgXfC71LJkYdkx92nI2e
	 zedFNdUmASqh+Y2oQlmljNztvibG8KBGspzyui7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/982] ALSA: es18xx: check control allocation before private data setup
Date: Wed, 30 Sep 2026 17:14:56 +0200
Message-ID: <20260930152420.246358912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0a32845b1017a..1d21c24c9e20d 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -1776,6 +1776,8 @@ static int snd_es18xx_mixer(struct snd_card *card)
 	for (idx = 0; idx < ARRAY_SIZE(snd_es18xx_base_controls); idx++) {
 		struct snd_kcontrol *kctl;
 		kctl = snd_ctl_new1(&snd_es18xx_base_controls[idx], chip);
+		if (!kctl)
+			return -ENOMEM;
 		if (chip->caps & ES18XX_HWV) {
 			switch (idx) {
 			case 0:
@@ -1837,6 +1839,8 @@ static int snd_es18xx_mixer(struct snd_card *card)
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




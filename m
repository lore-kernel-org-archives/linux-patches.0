Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7C333A9D6;
	Tue, 21 Jul 2026 20:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664921; cv=none; b=V5YaYohHlZDmu5EFcYNlDbGJtr6C8PgNymMc5QGXAv8YxN6CSM07GfxNe/a5KqsNWCSc1K5dz/jISoxWe7n+oPEWVOTUe+ouXdn39g07AFMEesdK7+Hz90vRJG97vPxx76jA+vvc9PLK6jISAABoAv972xEvR7NJ7/vgumB3CMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664921; c=relaxed/simple;
	bh=9baZOSdqa5fGkYcQ+bGnMiZ/zNLvBjHe+EETa2vxfOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1uMwP1muAS3Dh+oRCRooAg+qtd5TS+49KicQcj9r7otaXM6zMXzMPDl6Poswa5i3s95lwPnP3cUFE+MgB/jbIzBcnkxW31FZqSODdNt3N/B7moJHrWOg5MwkYezbinuyNezuSbA4Bg8UTvNMqWk+csqjtYOoIi80WBO5C34NHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9GKJSvS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9GKJSvS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFA71F000E9;
	Tue, 21 Jul 2026 20:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664920;
	bh=kT50HIL5ZrSEEqwnFxFtz1bWrWU1wh8ckewJ70U1l0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O9GKJSvSaLGJneLuQwOUB2DGfv6FITk4nUQV12J5IHZ+U047bfGH7aFO9fdjlqFzz
	 TGR7TEEXYHv120v0fQpiqYmu5MWUu5/q251h8a/9PwKIF2PQZxL4+FuGdCyRL3adDS
	 eijh8nIVCzmk6IJpi4Q9bBb1FlWtXn/c5p6qxj/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0109/1266] ALSA: ice1712: check snd_ctl_new1() return value
Date: Tue, 21 Jul 2026 17:09:06 +0200
Message-ID: <20260721152444.239019341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

commit 2b929b91b0f3bc6de8a844370049cd99ee8e31ff upstream.

snd_ctl_new1() can return NULL when memory allocation fails. The
ice1712 driver calls snd_ctl_new1() without checking the return value
before dereferencing the pointer in multiple places (ice1712.c,
ice1724.c, aureon.c), which can lead to NULL pointer dereferences.

Add NULL checks after snd_ctl_new1() calls and return -ENOMEM if any
fails.

Assisted-by: Opencode:DeepSeek-V4-Flash
Cc: stable@vger.kernel.org
Fixes: b9a4efd61b6b ("ALSA: ice1712,ice1724: fix the kcontrol->id initialization")
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Link: https://patch.msgid.link/tencent_42E5E2AB1B6A5101F7EE8C2117F1F687BB07@qq.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ice1712/aureon.c  |    2 ++
 sound/pci/ice1712/ice1712.c |    8 ++++++++
 sound/pci/ice1712/ice1724.c |    6 ++++++
 3 files changed, 16 insertions(+)

--- a/sound/pci/ice1712/aureon.c
+++ b/sound/pci/ice1712/aureon.c
@@ -1900,6 +1900,8 @@ static int aureon_add_controls(struct sn
 			for (i = 0; i < ARRAY_SIZE(cs8415_controls); i++) {
 				struct snd_kcontrol *kctl;
 				kctl = snd_ctl_new1(&cs8415_controls[i], ice);
+				if (!kctl)
+					return -ENOMEM;
 				if (i > 1)
 					kctl->id.device = ice->pcm->device;
 				err = snd_ctl_add(ice->card, kctl);
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2372,21 +2372,29 @@ int snd_ice1712_spdif_build_controls(str
 	if (snd_BUG_ON(!ice->pcm_pro))
 		return -EIO;
 	kctl = snd_ctl_new1(&snd_ice1712_spdif_default, ice);
+	if (!kctl)
+		return -ENOMEM;
 	kctl->id.device = ice->pcm_pro->device;
 	err = snd_ctl_add(ice->card, kctl);
 	if (err < 0)
 		return err;
 	kctl = snd_ctl_new1(&snd_ice1712_spdif_maskc, ice);
+	if (!kctl)
+		return -ENOMEM;
 	kctl->id.device = ice->pcm_pro->device;
 	err = snd_ctl_add(ice->card, kctl);
 	if (err < 0)
 		return err;
 	kctl = snd_ctl_new1(&snd_ice1712_spdif_maskp, ice);
+	if (!kctl)
+		return -ENOMEM;
 	kctl->id.device = ice->pcm_pro->device;
 	err = snd_ctl_add(ice->card, kctl);
 	if (err < 0)
 		return err;
 	kctl = snd_ctl_new1(&snd_ice1712_spdif_stream, ice);
+	if (!kctl)
+		return -ENOMEM;
 	kctl->id.device = ice->pcm_pro->device;
 	err = snd_ctl_add(ice->card, kctl);
 	if (err < 0)
--- a/sound/pci/ice1712/ice1724.c
+++ b/sound/pci/ice1712/ice1724.c
@@ -2393,16 +2393,22 @@ static int snd_vt1724_spdif_build_contro
 		return err;
 
 	kctl = snd_ctl_new1(&snd_vt1724_spdif_default, ice);
+	if (!kctl)
+		return -ENOMEM;
 	kctl->id.device = ice->pcm->device;
 	err = snd_ctl_add(ice->card, kctl);
 	if (err < 0)
 		return err;
 	kctl = snd_ctl_new1(&snd_vt1724_spdif_maskc, ice);
+	if (!kctl)
+		return -ENOMEM;
 	kctl->id.device = ice->pcm->device;
 	err = snd_ctl_add(ice->card, kctl);
 	if (err < 0)
 		return err;
 	kctl = snd_ctl_new1(&snd_vt1724_spdif_maskp, ice);
+	if (!kctl)
+		return -ENOMEM;
 	kctl->id.device = ice->pcm->device;
 	err = snd_ctl_add(ice->card, kctl);
 	if (err < 0)



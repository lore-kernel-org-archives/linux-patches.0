Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CB03B0ADE;
	Thu, 16 Jul 2026 14:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211788; cv=none; b=UJl2bMeCzKFgQDUOAL0MI3/olUFfsho+QbMdUH1WuRV6USXnsRkSSjQD9AWhbHYx2AXFk+vbqacFvTnPbZRBlRkLPXhekf1kkclt0JTAH3uUfq+taEUKXG7/qBoegoOJC22EAs5wa5/U8a7uHBa3kP+849x1Ly1LyFBD60Mfebg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211788; c=relaxed/simple;
	bh=iCFPimdr0bwTrRI5jBb/sR874AeiwnJK0HLmz06HFss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbZYG2TfP3C09U9W4XNGPAS5YWvEwCO95KAv71VJ2tCvTmIe3+XFFXb6AiKBVC1KAib3vbhyrYTi7rNtHqnVpNm5+H1cOilyWueL9ry5Tva4bAioWjtQ0p11SDb5/4SflE5MYQ5Nt3hY/6X5db/4LA7xnFRlHb+H0sA/SiPCMhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8rnK1r2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8rnK1r2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFBB1F000E9;
	Thu, 16 Jul 2026 14:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211787;
	bh=Am4FkwMw8lDnnm3DbN6pFkunkrQnfxWrTMLzavmgCJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8rnK1r2k0YfWzz11AtWwwXNHA8Dp28g3EjDDYXVN8qdMWQpUiX5nlzskAJopL85K
	 cQEsY/Od5ZORVqZPYPoBfgFaVK8LYRUORyiEYOtFRwRA3tkh74XcFaJF7FikUwOEVL
	 pBxPffn9u9Vv4PLTza/Ru8Sdy7h8reAhqUpwEhKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 079/349] ALSA: ice1712: check snd_ctl_new1() return value
Date: Thu, 16 Jul 2026 15:30:13 +0200
Message-ID: <20260716133035.085625019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



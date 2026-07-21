Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123D9367B63;
	Tue, 21 Jul 2026 21:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668183; cv=none; b=JSmxYX7CaxFEL0gvKl/elFRVdmEtJQEhsn1scEEb1YMmrmHX7hbqTCfzqa3oP6WXfhj+pqZpOKN8TlCjI9Ssj1SZHEXd8pb+nvmCyIAh8EvwKTfvfRPM9Z3fPM5NmP7YtKMOnsxKMKGohfBHxdLpaCyV0CaXJxOAMXOc8IA8yBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668183; c=relaxed/simple;
	bh=5uSZHRvkIPY9Vwayo2m8SGUroEfgQSML+s44oksEJTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nf2/v+hqqSzbpox9tvpZ92odF0iT7eTA2J3W8mWPpI65q/vSEYHZtMYpCg/XEQA3NFk7y2swXv15nJxyi6Sl+id97qI7k9uwpUpOamJ0x9cIQcpPiAH/RI8MjvAmvwhKu/2LhQZBuKw3XuUxUN9cv1JUez3hRChgm8I+HTOm8cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJLnKIF0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJLnKIF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77ECF1F000E9;
	Tue, 21 Jul 2026 21:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668182;
	bh=/ypT8HSVjz8WkKQiqVOg/cULn7DIlkTl2PRp2Ix+/Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CJLnKIF0zwf5a6SlsaTCsq+FIzbmFcWQgbSq0KcOUO4eFVtZ0gQnGPPJHLzPQTEG2
	 YCGgiuxiCCQJY5VpDPl/wEoYIuhBm+w8ccz5t3RNT7EER3kbXeDD4DWjFSbaqP1IRi
	 J2IUSO9HclXjuWlDxL7NvJ0I4wmhGSQTYYadRKVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0079/1067] ALSA: ice1712: check snd_ctl_new1() return value
Date: Tue, 21 Jul 2026 17:11:20 +0200
Message-ID: <20260721152426.340721771@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -1904,6 +1904,8 @@ static int aureon_add_controls(struct sn
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



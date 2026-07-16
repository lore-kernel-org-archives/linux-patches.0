Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F7A400973;
	Thu, 16 Jul 2026 14:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210580; cv=none; b=sLHWtUeqhzKbNmsZfC6QyND6ZnLmakMbvd2G9Epbt1rnwAvoHM3lMOM2FNXlLCfIxMZHTUyudc64T4gb7naA1cWmARZyq16Tc8VorSt+39pB3sk7ZIvU8jOHZWT3EPB/7xM5aXE+0FJz8YEPk+BR+SX3tBAhRH3VHDZ7Tj2W8Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210580; c=relaxed/simple;
	bh=0BHJGReUrPek+vdLtbI2nn1dRWsSViiD/9dy4K0N8HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTlKqmBaD0uMbB3pI3VPlG2Neig9+fF8gz75xGDShHD8qiTLKO1J2XZlwYg1ggi0pvhvxWZm/akvPriEYxC8vLaWt81PsKJOrG+E/BjQu09Itgf6DYKCk8oozqTjDC1cvncyiGE7ZV6iLhN98pURNEkL5Ue75k5Lvax6l0xWmt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3LkrnOf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3LkrnOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5251F000E9;
	Thu, 16 Jul 2026 14:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210579;
	bh=c104K+9C3jFDWzaKL31hEvvfl19Tz3UQEUmfSN3Y8Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q3LkrnOfX5o8EWNZVbhYnJBj2ndM9tnz9Wxkrkud3zM7Ez6CxHnPJW7ATN7SmMDmZ
	 92wE1eZ0bGoHYGjfDlBKD3u/V+ihvo/J/VbcxtAP/OCxmti99C6Q2G4UjafwhBgCzG
	 OrI8XwFZETA+ZkUYh6dwZjisuqrHz3+2vVEdNuvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 102/480] ALSA: gus: check snd_ctl_new1() return value
Date: Thu, 16 Jul 2026 15:27:29 +0200
Message-ID: <20260716133046.921010886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

commit c7fa99d30c7a166a5e5db5a585ce7501ff68326b upstream.

snd_ctl_new1() can return NULL when memory allocation fails.
snd_gf1_pcm_volume_control() does not check the return value before
dereferencing kctl->id.index, which can lead to a NULL pointer
dereference.

Add a NULL check after snd_ctl_new1() and return -ENOMEM if it fails.

Assisted-by: Opencode:DeepSeek-V4-Flash
Cc: stable@vger.kernel.org
Fixes: c5ae57b1bb99 ("ALSA: gus: Fix kctl->id initialization")
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Link: https://patch.msgid.link/tencent_F644A3DCAD32945D62DB2FEEBE8A996F6809@qq.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/isa/gus/gus_pcm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/isa/gus/gus_pcm.c
+++ b/sound/isa/gus/gus_pcm.c
@@ -849,6 +849,8 @@ int snd_gf1_pcm_new(struct snd_gus_card
 		kctl = snd_ctl_new1(&snd_gf1_pcm_volume_control1, gus);
 	else
 		kctl = snd_ctl_new1(&snd_gf1_pcm_volume_control, gus);
+	if (!kctl)
+		return -ENOMEM;
 	kctl->id.index = control_index;
 	err = snd_ctl_add(card, kctl);
 	if (err < 0)



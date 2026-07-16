Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3314841F5F8;
	Thu, 16 Jul 2026 14:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211783; cv=none; b=jt1q1yk+g239wy21hyoKNHb5p4pa9wpZkd+RTWqpy94brknqTuifN5gUBA84gamd5+35COvflDfjlRWRgEq7rJyH+NKwc1mCWhaeG8s/AQ41EZPJmsDhgRzBVMk1rV13KtANLXTe2HFqO1mnUWed1gq38xpZyhSNcH5HmbdsSE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211783; c=relaxed/simple;
	bh=UmwNjYQAkx7qEJa0Io+F6k0SzrNMlRRQYDlZ0QZMXMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZnRo0onUQPOuuKvdf7LfKjaua2ILj54+oMgC57pNNo6J5UKYV4+RtAWesyEj6+Uz6Edp6aDobISmRO2NsH2UZnb8q7UW98gGrFxNVSCRelgjA0J2f29nuwfeYJwZdIm7NEZ56OrSwB7Qx8/tYcTnCU9X+wXBzaGDt/m7rMjSVW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NR9pzfEE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NR9pzfEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98CE31F000E9;
	Thu, 16 Jul 2026 14:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211782;
	bh=gwUcMrQ1qQjBCfAtfx+BV92Hfwhc/TA4lCoVGv6UrrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NR9pzfEE655DeJ9onxpgLvAkEXJ4/LW2FhjzWEqewSAYrWpvOMSHCsu+odYjOVu4O
	 Ky/f79fbcWPRC1BTdT7cjb0Xab8NwwmxNyU8rvMeTVcevIm+fX9E/6mbjvvdhdGMiZ
	 T6E4QeIPBMtDxsOwkUs3o03BVfSUoD1/AB1ARPy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 078/349] ALSA: gus: check snd_ctl_new1() return value
Date: Thu, 16 Jul 2026 15:30:12 +0200
Message-ID: <20260716133035.064480783@linuxfoundation.org>
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
@@ -862,6 +862,8 @@ int snd_gf1_pcm_new(struct snd_gus_card
 		kctl = snd_ctl_new1(&snd_gf1_pcm_volume_control1, gus);
 	else
 		kctl = snd_ctl_new1(&snd_gf1_pcm_volume_control, gus);
+	if (!kctl)
+		return -ENOMEM;
 	kctl->id.index = control_index;
 	err = snd_ctl_add(card, kctl);
 	if (err < 0)



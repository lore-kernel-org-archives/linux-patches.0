Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57FC2DF137;
	Thu, 16 Jul 2026 13:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209185; cv=none; b=VdNn76u/0yQe2QDpFN4oFixgwVdrVqIZ+JEHA3L1NCbJBsvSy2fC//WmPVoDLG1j3DgoE9l9FiccRTTZb1SltMJL0LVYEebhxp+9E37JJrVQSS4pQHiqhbUXkvpioFImsAVhDTE1HpiJ6aajV4qTpxSHv4Kex5wIEbqWzOG3+Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209185; c=relaxed/simple;
	bh=fblYd+/4Mp5doZ61cahUGFDErn2jrTsphKua/VkzoKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoKe5E05TcnV1gdgYeizYPn7PKtuZA+uBifQgXIqJ3c8p2RzbGBSWIAtFr6ROCm6Q1hcF/8mVy9I6g9/4mnqskGOBqeMuqXUwA5ed5dW9qwZLDN3wZqVesdi1gaPkaWgZUhTOADfmiJgfof5mFU+zfXFXkVnMn6HyTgL2HljH/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srQMvx/m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srQMvx/m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163B11F000E9;
	Thu, 16 Jul 2026 13:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209184;
	bh=BOyhCZIjsIHj6kDf5NJfVbGp1dsIPXqyW6VLT2xqwxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=srQMvx/moENxrVhS1vaHbzGxS+TJToRoWZxmI+Zz0yP0S2ZoAaea9bHCrNmkNVSIb
	 Y2HvVapX85MhfBlKlrT0ftaOMHxULBQ+A9OgkYOGCPGzQcAOn5Va8Eb1oHaVhLWTcU
	 t4IpU4Fch5dB/L931+RxSYgRca7K+i9neeE9pjLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 090/518] ALSA: gus: check snd_ctl_new1() return value
Date: Thu, 16 Jul 2026 15:25:58 +0200
Message-ID: <20260716133049.835366334@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -851,6 +851,8 @@ int snd_gf1_pcm_new(struct snd_gus_card
 		kctl = snd_ctl_new1(&snd_gf1_pcm_volume_control1, gus);
 	else
 		kctl = snd_ctl_new1(&snd_gf1_pcm_volume_control, gus);
+	if (!kctl)
+		return -ENOMEM;
 	kctl->id.index = control_index;
 	err = snd_ctl_add(card, kctl);
 	if (err < 0)



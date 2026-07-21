Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB9E44AB60;
	Tue, 21 Jul 2026 21:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668180; cv=none; b=QRDpJtzdDNZ4G+viXARi1lSNJ5HjRhql91Bgkz2+RL3N2oxs+WLKv22WL9bM2qYDcgHZy9mm/0xtxHgLGbtz5+kNj43zT/TAADl7990f0qUrwctNkjrb0QvJ+9GEiRdyz431B+k8kNwGylcc+PMmH5gjG4LgF6yJfH8Ug1n3knM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668180; c=relaxed/simple;
	bh=1NpNHNtGOewzSlVaLVIs+6RjTao1bB7C5fbl+0Ki0M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvFAxA9DpuvigyiZ10gkvjXllgDLOFiIzrz96tNWfcBOroLZ+zgCgairw6EUrk8/EFcBkhRGnMnfkCV2bWC4t7ku9upYXwhuqWAJCxlH3JY/3YtNU/5+sGxmTIe1xBiOkOUqq3OsftoSkrcn6C0Ucr1lr3Z3AAp6bDKJn22WYgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvG8fcXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvG8fcXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63211F00A3A;
	Tue, 21 Jul 2026 21:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668179;
	bh=Ww6GfzZpYxdYdnBcWr9gKdjpbeR82JTtAzuHltmfcJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PvG8fcXJ+EsU5LJ76MbsLAsrNaT10YOz0q76CoJa2KE6GeQbbhi8975tNgsyxVuP2
	 81lLHTq4Iz0tOKBKw2aPEJPKRovjLl+kBEA1nf2ntmmRFJ8bW4XsuTadGojKfB5Ekg
	 MuvnN1gt0CNoygdLqRo/XO11QbzJF10rpdyGLU5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0078/1067] ALSA: gus: check snd_ctl_new1() return value
Date: Tue, 21 Jul 2026 17:11:19 +0200
Message-ID: <20260721152426.315293489@linuxfoundation.org>
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
@@ -892,6 +892,8 @@ int snd_gf1_pcm_new(struct snd_gus_card
 		kctl = snd_ctl_new1(&snd_gf1_pcm_volume_control1, gus);
 	else
 		kctl = snd_ctl_new1(&snd_gf1_pcm_volume_control, gus);
+	if (!kctl)
+		return -ENOMEM;
 	kctl->id.index = control_index;
 	err = snd_ctl_add(card, kctl);
 	if (err < 0)



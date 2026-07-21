Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FDC431A4A;
	Tue, 21 Jul 2026 20:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664919; cv=none; b=bvsiQO4VJggqaQ4jJ58tr1eHeF1rcfclGEzgUT4tcaWY6QMnmFDxw/5zOBGz01A/0SBw/e8acZe0p2ECcxJ/g6T0EX4E0ZE1nx22V+VoR4RZTrGdvlkdGYdSZYvfsATxC6qAYfBpM4Io9K5tv0l9x6g+D07JN17ygTWiUc+0bFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664919; c=relaxed/simple;
	bh=HEiQIK+QjIv/w1UTnRH/KJ3Py4qo+v4vFSri2Bu5jIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jx54Mpb29lUl9n74ivMal/8EMroV1k6yOcMhc5h2QFc7allSqjSiNAIfshhcvu5MYRpfUE1KNBbZ3oVdsjWYdbdreQglY28aoZisD9FUxqEJi7fMuWAqykOLXa7EY5tqdJJFyQxp+FMtLCLcmrCFA4rlEtOBCj4p2DcgBFxQWyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNIuBUCP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNIuBUCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6444B1F000E9;
	Tue, 21 Jul 2026 20:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664917;
	bh=IjFCc0wCzxUbgYFDL/ZhEU5NdT4VyB1b2epWaE3YnCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sNIuBUCPAvnz9H2Qa80amVN7vWdn+CMwx41tNIWLtvHUeSgnacqt7/w03CEgzTqBl
	 u1QoXm8l8owjbIjbxRXckj4zd5L3bRWXXlu9Q2FGa3BD8iK5+LhFVeJcfp13sYlXzR
	 yGVraqoleok5CLO6Vdmy7CMkx0fItK3XRu4rur2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0108/1266] ALSA: gus: check snd_ctl_new1() return value
Date: Tue, 21 Jul 2026 17:09:05 +0200
Message-ID: <20260721152444.215670598@linuxfoundation.org>
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
@@ -875,6 +875,8 @@ int snd_gf1_pcm_new(struct snd_gus_card
 		kctl = snd_ctl_new1(&snd_gf1_pcm_volume_control1, gus);
 	else
 		kctl = snd_ctl_new1(&snd_gf1_pcm_volume_control, gus);
+	if (!kctl)
+		return -ENOMEM;
 	kctl->id.index = control_index;
 	err = snd_ctl_add(card, kctl);
 	if (err < 0)



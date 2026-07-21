Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D415C43B483;
	Tue, 21 Jul 2026 21:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670969; cv=none; b=o8fKFErGLB+U6udCFv5jlpfB/5c8d0GDWKl2KqLOlWn/53jz43N4Yh/PrnPO0K+HpPkoFj9zYbI0ABpc0G9+jB+ANwQ04M+0NZW69j7pOgXaC0V+hNtA0V1LkRzUUag1PjPvQnNjG+H7pXD7p9hOQa3hPgQRSoJYEcRkVjZk2hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670969; c=relaxed/simple;
	bh=a6gwnP2H0qBxM2LOzdNBkMj/R+o3vZ7Ih8IpQc1iSKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqDJgB8DqSjLHuHgAFH9XQhnD6Cqt8PgZ7LFSVES7/28xZX9OK5E47RZ7ziI+A8qWku/GT0lMJBZuHTHWH/l8mIl1+vEPLPwLn9VpZQjwWQ6Y0JyK6wviCw/lOgLqbSfin+XfI6Nq02xJ4ErLiKofS2FFSJ3Dxw3IA+t9gRvrwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i02RHXfY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i02RHXfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453D81F000E9;
	Tue, 21 Jul 2026 21:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670968;
	bh=KT4MgP7S/tyR83LVAwxBgv4BSkOqztnIPtSQ5PsxTJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i02RHXfY9JKTkP5sMAQxy0Kqvkfb8vyOUVomEvc0G/1vdAmEWExgzTsQ30G9a3+Bx
	 FgO6Lpf3dJeUV91/1S39qri49DhPlpGL8JErHxTORsYHoe2Eax0nM6ouvBHVKfNFz/
	 +tOGMai34VNoSEaV+J5I6Jks8kzpyTknZqySEn7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 068/843] ALSA: es1938: check snd_ctl_new1() return value
Date: Tue, 21 Jul 2026 17:15:03 +0200
Message-ID: <20260721152407.517123945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Zhao Dongdong <zhaodongdong@kylinos.cn>

commit 1edd1f02dddd20aeb6066ded41017615766ea42f upstream.

snd_ctl_new1() can return NULL when memory allocation fails.
snd_es1938_mixer() does not check the return value before dereferencing
the pointer, which can lead to a NULL pointer dereference.

Add a NULL check after snd_ctl_new1() and return -ENOMEM if it fails.

Assisted-by: Opencode:DeepSeek-V4-Flash
Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Link: https://patch.msgid.link/tencent_E0DC65165FDF2C8982BAFB6794B854B53B0A@qq.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/es1938.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -1690,6 +1690,8 @@ static int snd_es1938_mixer(struct es193
 	for (idx = 0; idx < ARRAY_SIZE(snd_es1938_controls); idx++) {
 		struct snd_kcontrol *kctl;
 		kctl = snd_ctl_new1(&snd_es1938_controls[idx], chip);
+		if (!kctl)
+			return -ENOMEM;
 		switch (idx) {
 			case 0:
 				chip->master_volume = kctl;



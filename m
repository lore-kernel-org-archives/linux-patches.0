Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494B44252D9;
	Thu, 16 Jul 2026 14:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211775; cv=none; b=f0Z4HS98f6nAmgWI9gcPFhNjJYMnSeYqFQ2AF+2iYxBH+szgk8fVv3IW3xS+dDe+7DnE2hgEwanqSluwIhQymfSvH92SbtGlyQfKJYosVGVDJjAfmAFoI/DCXrXFBPz3CS+eIlygamhlVhI88nrUBJMIG3TOPdyO8LZ4vwqWkFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211775; c=relaxed/simple;
	bh=Wu/Mf17CynXBuvDkQeykwjEuzNyL1QnMczYqo8LFiGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvXZGA6KL0VTydhF64yQkbvug8sl19P93szxaTXy8LKQZuyL6WsG52kybJm6ykKcoQuzTbQJKgRRzrt7yr/nRD69gPQnY11uqyZZjEyIrkWFJedFCS1tTUfd2rhzgu5Mu+IediJ9jlR+3ZbFrHTKiZXH6fadU1s+3rmAdf7l4vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUv2mBn/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUv2mBn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66F01F000E9;
	Thu, 16 Jul 2026 14:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211774;
	bh=Db2a5De2cHV/zghP6pIQQMYTt1WL1INtQJleAZIHRdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUv2mBn/jl8Ls1XKcxyiwUnYeE73SjLfJYGkU9S7Y9p1XNF4G+9NIi2gnk1iFS4i9
	 K780Wpyds13MVmBh3/Zqc3POl7dRy3zEHy5YWKiSCpsd9XkyEZX0YKTMHv6M6RAdQq
	 lVN4UabPcrAERorypwddqAHAoIw0KoGNJirYcaps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 075/349] ALSA: cmipci: check snd_ctl_new1() return value
Date: Thu, 16 Jul 2026 15:30:09 +0200
Message-ID: <20260716133035.000702778@linuxfoundation.org>
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

commit c205bd1b28fb7e5f1061a4e78813fad7d315cb3e upstream.

snd_ctl_new1() can return NULL when memory allocation fails.
snd_cmipci_spdif_controls() does not check the return value before
dereferencing kctl->id.device, which can lead to a NULL pointer
dereference.

Add NULL checks after snd_ctl_new1() calls and return -ENOMEM if any
fails.

Assisted-by: Opencode:DeepSeek-V4-Flash
Cc: stable@vger.kernel.org
Fixes: f2f312ad88c6 ("ALSA: cmipci: Fix kctl->id initialization")
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Link: https://patch.msgid.link/tencent_964433DCD132125D5EDA79EE068A2D6EFA09@qq.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/cmipci.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -2672,16 +2672,22 @@ static int snd_cmipci_mixer_new(struct c
 		}
 		if (cm->can_ac3_hw) {
 			kctl = snd_ctl_new1(&snd_cmipci_spdif_default, cm);
+			if (!kctl)
+				return -ENOMEM;
 			kctl->id.device = pcm_spdif_device;
 			err = snd_ctl_add(card, kctl);
 			if (err < 0)
 				return err;
 			kctl = snd_ctl_new1(&snd_cmipci_spdif_mask, cm);
+			if (!kctl)
+				return -ENOMEM;
 			kctl->id.device = pcm_spdif_device;
 			err = snd_ctl_add(card, kctl);
 			if (err < 0)
 				return err;
 			kctl = snd_ctl_new1(&snd_cmipci_spdif_stream, cm);
+			if (!kctl)
+				return -ENOMEM;
 			kctl->id.device = pcm_spdif_device;
 			err = snd_ctl_add(card, kctl);
 			if (err < 0)



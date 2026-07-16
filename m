Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EE73D25D0;
	Thu, 16 Jul 2026 14:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211770; cv=none; b=O+oGw1kaz6bDWFB4YdTQFDdmcDAQ9funhr/5ybXZcplYvKIi5AeytMKohzZLIFlmoZMcq8vAOkyeH1hlZom9kNlxz69Jsin76sNWp3vcHzyw7WEVb+NC+shR4QwPkbdiRw9R4zkKMCQfMtEPQLzp6oH1uLM7r8TxiTLhH+x56vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211770; c=relaxed/simple;
	bh=66q/Yrd9x5wmF8E5/1jzf4J5FjG+5d9zccPQPM4gc0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VA4ptnyPXiGtIxIusYNiGsxqoF2RpAfhUCy4fnx2zXjib0RR8zik7Aq9ekr4sruTwc+73aD+qpLyhifhfpLDRPPdSQkvH+YNUIuJCKpBD7Qi+DSCkwkdl4nnvCpE5WFsrUnWLnt7r2W7U6h1naB8vSq1TnzmAtmT56GLYQ8MRx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nleO81ol; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nleO81ol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3671F000E9;
	Thu, 16 Jul 2026 14:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211768;
	bh=tHpKnMlKjM4txEAw/Rf24BVOwwpdcrfYBaTvZ6zpOKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nleO81old2TPeZDaWB2qasXeoJqulcdAEHqtbPYMZqZRvUTdACNl3UZBBSQJMLw8i
	 lGhMVTMosFsKVuZStPly+2ZfoYyqfbM1426VLI4UOIcMCkocip5uq8XZm9/UKJJprr
	 KMdyANQ9hBR5iVo5paPCVjFuNUUadEAJum0eQr1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 073/349] ALSA: ymfpci: check snd_ctl_new1() return value
Date: Thu, 16 Jul 2026 15:30:07 +0200
Message-ID: <20260716133034.954824872@linuxfoundation.org>
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

commit e64d170346d00b580c0043de3e5ccb3e331c47d4 upstream.

snd_ctl_new1() can return NULL when memory allocation fails.
snd_ymfpci_create_spdif_controls() does not check the return value
before dereferencing kctl->id.device, which can lead to a NULL pointer
dereference.

Add NULL checks after snd_ctl_new1() calls and return -ENOMEM if any
fails.

Assisted-by: Opencode:DeepSeek-V4-Flash
Cc: stable@vger.kernel.org
Fixes: c9b83ae4a160 ("ALSA: ymfpci: Fix kctl->id initialization")
Signed-off-by: Zhao Dongdong <zhaodongdong@kylinos.cn>
Link: https://patch.msgid.link/tencent_4745C5DC2333325C0EDAB1EFC88A136E6809@qq.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ymfpci/ymfpci_main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/pci/ymfpci/ymfpci_main.c
+++ b/sound/pci/ymfpci/ymfpci_main.c
@@ -1822,16 +1822,22 @@ int snd_ymfpci_mixer(struct snd_ymfpci *
 	if (snd_BUG_ON(!chip->pcm_spdif))
 		return -ENXIO;
 	kctl = snd_ctl_new1(&snd_ymfpci_spdif_default, chip);
+	if (!kctl)
+		return -ENOMEM;
 	kctl->id.device = chip->pcm_spdif->device;
 	err = snd_ctl_add(chip->card, kctl);
 	if (err < 0)
 		return err;
 	kctl = snd_ctl_new1(&snd_ymfpci_spdif_mask, chip);
+	if (!kctl)
+		return -ENOMEM;
 	kctl->id.device = chip->pcm_spdif->device;
 	err = snd_ctl_add(chip->card, kctl);
 	if (err < 0)
 		return err;
 	kctl = snd_ctl_new1(&snd_ymfpci_spdif_stream, chip);
+	if (!kctl)
+		return -ENOMEM;
 	kctl->id.device = chip->pcm_spdif->device;
 	err = snd_ctl_add(chip->card, kctl);
 	if (err < 0)



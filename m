Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166AA472F80;
	Tue, 21 Jul 2026 20:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664903; cv=none; b=WmlsMSiwMu4tQsoRgVnGcZ+Cpp5ifc+K3CyLfZKlIFtn8vFPRmEG43/Hs3eaE2rNrqPEJz8vvBGAJwS7kVGVRLUIpFlqj8sYGjLX9x64DD1MsprI2yH9nOBc2wLox3E7KWWx6xQe15+qb1EimgBaMN/Qf0nuWOfUvIiaR1UnSJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664903; c=relaxed/simple;
	bh=EarOF721Gkhv4PzTqjWaA8moCQ9wYFVv9YbfwczSil4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqyoWMrJcirZW5YcmV+0m/iTQVqYsnk8IQyQYbfkxVNXVdJLtjtSaXQt6AIzvIuwbo4OZso1dO8f3sKoFUpwpT9W4kFyzUtjDpXnM0w9WV4tNCvP26yxutuNYZZc8ws7EVEi+HcTSEqZgNBdzSHmmohh2Yi64ZZGC2t2XraHHn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOZDwdj+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOZDwdj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789351F000E9;
	Tue, 21 Jul 2026 20:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664902;
	bh=S3tAa9vayAVejgnYDaM0aNC5A0r4iGbyCoGV9Kyb6pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOZDwdj+MGM2qrF7dRVkVFGhJSv9AQTxP8GuJG6z+H0V7D4r7jdKAOAZNd1V+7ZdD
	 2e6NhHtZQvYunn9S4QghvxWmbylQclIBXpbdOfuiQMrVitVlPEDSYigmOlupw46Tbx
	 HooV2/3qvu9rBO4kX7QDwfgdzp+XRDakWepW1kB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0103/1266] ALSA: ymfpci: check snd_ctl_new1() return value
Date: Tue, 21 Jul 2026 17:09:00 +0200
Message-ID: <20260721152444.105741347@linuxfoundation.org>
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



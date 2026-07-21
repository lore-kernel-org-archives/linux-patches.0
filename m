Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E71044AB6A;
	Tue, 21 Jul 2026 21:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668167; cv=none; b=fzfdVqhSryD1o10yvAOGG+p5S2U/KfQsRpYXvnMq3wfj6ICt8o5/mkVmDffd2YKBRzqfe8HR0rgRGFiQzcdOYf1GZRIMnLQBRnZWEtM83OeDsHkml3E53hSn54uL8Fhhz3HJnXAGGOGb/qgKvh56kj6nHMGg0iLdOxnNlHnyG7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668167; c=relaxed/simple;
	bh=oZ3XFJdZY2gBwu4OUMWrppNTyTJqXAZtlMdC8BCdqMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxFSJyLHkUXGkUUpKBUjdFz9H6pheQY4HPIQkFaiJFzOcihzNBUiBw/AMmosIhfXqzM2AjQ+zP8N1gmiRYJFK4T+nCg8wT5g0omrbgv6oQyLCxJt/LQXQE6tbezHnUNTQpeREPrktgXFqiLh6o40pdBqLcKQr+Nkuxj1DBsylAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yybsdEiS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yybsdEiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918611F000E9;
	Tue, 21 Jul 2026 21:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668166;
	bh=h6kxornq/Hg7Gm+C8uwBKPcWaq/l15ikKKYTehuufeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yybsdEiSEB0Kaq2s5gvjk2yM/RCGoO7I+9R53U9EfnZQJb9R9JPLNLcOpy0gUhEta
	 Bu7sw6VU3ZnVlzvGYKbp1De8eJI3a6yAXQxZmPxM1iaZ5y42yu94iXkotYSdNV2rWK
	 Zw3N4XjxVW/uoSD5vyAJRqqFXGpz/ttRKTlZR500=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0073/1067] ALSA: ymfpci: check snd_ctl_new1() return value
Date: Tue, 21 Jul 2026 17:11:14 +0200
Message-ID: <20260721152426.203362496@linuxfoundation.org>
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
@@ -1827,16 +1827,22 @@ int snd_ymfpci_mixer(struct snd_ymfpci *
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



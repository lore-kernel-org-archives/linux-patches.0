Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE05C30D3F6;
	Thu, 16 Jul 2026 14:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210677; cv=none; b=rDLZGrMAM2pDHu/CfsR4AIWlRIzGTpcsYZhsAHNR3CfnVEQNWqe+NuEDWS6719SrrrKbAQaxqqW9jFzS+kpCUj630aeHUxKzNDwXB4w8oplh/x4Ts079in2lWgbOdFa+AYMjXOF8oWiX+scujMHmUIS7MUUPKB4vzO2jooiH23s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210677; c=relaxed/simple;
	bh=yJXum7650prg8Vn+xZ9ssy+//G0+f3+aNmoHbHsIb90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVyT8uhe5bHuIxRO0pyp4OE/l/Knzv087Wq3WUNYiPHUG//aksvhbC8sWCL2yz0rDnxfF2IsqVAXUrhfENXWoqCKgVruC/6LWu7wW0ZBUHaMv00TkItBpUp5RvDtxgGW+EZnIvJuddVxRPfViP6jAgoGkoi64zZUi8uflVfH7cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCW8LjgI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCW8LjgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128D51F000E9;
	Thu, 16 Jul 2026 14:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210676;
	bh=+1bB51XS/VwEUkp73cnCvgNG4kdXTCKmIoIeEW7awMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kCW8LjgI6msG0Xy2upL9p2bntMamNp2znrZdeOjZjTxC+huFdzRNAlRlPV7eF2MT7
	 xhX/PylyXqGITjhEGDlbDAmqafq4R8LefPiI4NR8zH1NMCe14ZTk9mbJ5EAlu3NS7B
	 RV+zwZLKUYdm5UIyQv9YSbU+dfWeqMgy179wfbb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 094/480] ALSA: ymfpci: check snd_ctl_new1() return value
Date: Thu, 16 Jul 2026 15:27:21 +0200
Message-ID: <20260716133046.745107335@linuxfoundation.org>
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
@@ -1781,16 +1781,22 @@ int snd_ymfpci_mixer(struct snd_ymfpci *
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



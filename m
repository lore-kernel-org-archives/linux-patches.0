Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8689744AB6A;
	Tue, 21 Jul 2026 21:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668172; cv=none; b=C+gk2bxglqea1SuMkx5BZmeanyunalUi8Vvj/I3AbUMtYwfkXgdFyxzEPttFK722zk4TpZv9vt9KbnAXN+Us+/yTmfXkPMO2gvkam09t6Gs9anTLdc+GwTDOjSYkpIl6Pu+O+RXYKUgY5bQhfQWg35fE4kr5+XMI5FtbrMOYHNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668172; c=relaxed/simple;
	bh=fyt0uSlcPS95/4BE+4khvJOkMcRpgGhSjLV2SC0laPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KSjE1h3vU2SKuKwix2KfGrm+q6/ubLq2si3yVp5vpX24WPlJfZ6bwThBuGBk0r4XGO/IPUfsHVeR9gbPGAoctvIOyflg5xIZLuQ7+RIxYwPKP3aR2iLK+qPQ6DlfiI/R8oXiswYdOObbbBZbzOpQPE69FzOF8j80fe3ItyPha4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GUm4TDk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GUm4TDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68CC1F00A3D;
	Tue, 21 Jul 2026 21:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668171;
	bh=2q0faxtSs7SC4Xo8t58ChOA7LZSDTarW/dNJBXitmlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0GUm4TDkxvlVnRX1SduiIRc7gUmPPqjwy7KgFgtg6w54f7234jLkaqtN5LavxynhJ
	 8pc842XvwX0FLYwpexmA5w+bjar/o1Z4E/sYJ772kptFxm6B8lC2IYyTPHAzs3AS6O
	 xRB7jHP2qzBo8F1h56L+shWCR9/unCP+pyzYFlyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0075/1067] ALSA: cmipci: check snd_ctl_new1() return value
Date: Tue, 21 Jul 2026 17:11:16 +0200
Message-ID: <20260721152426.249846661@linuxfoundation.org>
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
@@ -2688,16 +2688,22 @@ static int snd_cmipci_mixer_new(struct c
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



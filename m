Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBC030D3F6;
	Thu, 16 Jul 2026 14:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210685; cv=none; b=m/kkw+/gj9uZ7aU4HCOMkpM4rytOFoMkArF9OrI1Xs50K22ub7QHxYqDIyc1cutk/OKRYUb3sRA4tIVKeQxxT4Szck6poB7u/JTJh293Kd8WHiS+L2SbbIAd9TnTNDvofOVmZx2kPITsCOZh1PhwhSW0Q6PZ40IeGZc23QBr9gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210685; c=relaxed/simple;
	bh=QpX74RsUtkEPUcV/vGfsFMRHdSNP21RJPiGIdQOxG3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkNxqzXqcuIWpAugZKlkscEJLtu4KNwn2kHaiDhBIZrmPqwOulqXe23S40PElFi4T7cGl4sPVFGV5qh9JJTq9GVkzSzN8a3vGkjgmKwO9mYB/gji+HKtdvrRPYos/kfat2YkbL6A8/qasPC4xH5B3+26X/ZohRMiZIHcp+FvJ/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nlTJ+6Lp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nlTJ+6Lp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E483D1F000E9;
	Thu, 16 Jul 2026 14:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210684;
	bh=K63wWziLB3BukuL8OqahFxsftcIjMkDlCmN8Q4SDys8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nlTJ+6LpnYgVAxD3Z8pqESPMgSseK34MSkyrt1deJ9VQzu/yV2TMchbPzk36Arc5x
	 xYrMyh/mxSYn/gMBKpJfpGaXYuM12qA5Exqh+XQYaiFc56tBO++JyOVcDZ8l/ssag3
	 vgOFQQaWBTixysVsba1cUPzMawaLr2WDlO5+QoIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Dongdong <zhaodongdong@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 097/480] ALSA: cmipci: check snd_ctl_new1() return value
Date: Thu, 16 Jul 2026 15:27:24 +0200
Message-ID: <20260716133046.810879942@linuxfoundation.org>
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
@@ -2637,16 +2637,22 @@ static int snd_cmipci_mixer_new(struct c
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609E0196D9B;
	Thu,  6 Jun 2024 14:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683008; cv=none; b=NbqUOi7Gdkixm0O+ci4e+GlBeniEw/NexR8zKD2dU65AsWfrfDZB5/Pnbe5xxhT53cC/7elhs8jGkf/tsDCdOEt671lfFX0s54GFA+x/WIYFFRKd3SeZP/hxqm3axjWckSadXcIurM6I1Za/2YSXH/oImDldBA3Mhn59Y7QPhME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683008; c=relaxed/simple;
	bh=ynaY/u8fK9ENM6lwyMdsz3OJF3a8SldLQW6PpMiWXWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RM639Qrufl4xOg49M3pmAmhHUXppmjG14K32oGGKDNhzKp4dA+hxjP37RoIVtgPWurLs44c4fdd+FkPikYHeB4tActgZkw/CgY9fwPatgTawLe3LCOmvYV5Wuxf4vuQkI7nH+yAdGIGFlIu5DRfPc+NIW+ISXGsr3iiSxV2APoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4R8kRPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4R8kRPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62C9C2BD10;
	Thu,  6 Jun 2024 14:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683007;
	bh=ynaY/u8fK9ENM6lwyMdsz3OJF3a8SldLQW6PpMiWXWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4R8kRPu/Bd4Tnz4u7lonXfvlntzznfa8BNXQo69wU1HzIoNX3KPCqJv5L53+8JJt
	 NitmpwhD4J6hT6/XQnOd++fYhqn1kWBXIJ/nnKnd5+xOEgchBh3pUC2VH0MncuYZ3x
	 o4MYiyWqUS7E+O+x2T31Ni2vVytoKQ3kivcdBl+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 216/374] ALSA: hda/cs_dsp_ctl: Use private_free for control cleanup
Date: Thu,  6 Jun 2024 16:03:15 +0200
Message-ID: <20240606131659.043100915@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 172811e3a557d8681a5e2d0f871dc04a2d17eb13 ]

Use the control private_free callback to free the associated data
block. This ensures that the memory won't leak, whatever way the
control gets destroyed.

The original implementation didn't actually remove the ALSA
controls in hda_cs_dsp_control_remove(). It only freed the internal
tracking structure. This meant it was possible to remove/unload the
amp driver while leaving its ALSA controls still present in the
soundcard. Obviously attempting to access them could cause segfaults
or at least dereferencing stale pointers.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 3233b978af23 ("ALSA: hda: hda_cs_dsp_ctl: Add Library to support CS_DSP ALSA controls")
Link: https://lore.kernel.org/r/20240508095627.44476-1-rf@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_cs_dsp_ctl.c | 47 ++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/sound/pci/hda/hda_cs_dsp_ctl.c b/sound/pci/hda/hda_cs_dsp_ctl.c
index 463ca06036bfe..9db45d7c17e5f 100644
--- a/sound/pci/hda/hda_cs_dsp_ctl.c
+++ b/sound/pci/hda/hda_cs_dsp_ctl.c
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <sound/soc.h>
+#include <linux/cleanup.h>
 #include <linux/firmware/cirrus/cs_dsp.h>
 #include <linux/firmware/cirrus/wmfw.h>
 #include "hda_cs_dsp_ctl.h"
@@ -97,11 +98,23 @@ static unsigned int wmfw_convert_flags(unsigned int in)
 	return out;
 }
 
-static void hda_cs_dsp_add_kcontrol(struct hda_cs_dsp_coeff_ctl *ctl, const char *name)
+static void hda_cs_dsp_free_kcontrol(struct snd_kcontrol *kctl)
 {
+	struct hda_cs_dsp_coeff_ctl *ctl = (struct hda_cs_dsp_coeff_ctl *)snd_kcontrol_chip(kctl);
 	struct cs_dsp_coeff_ctl *cs_ctl = ctl->cs_ctl;
+
+	/* NULL priv to prevent a double-free in hda_cs_dsp_control_remove() */
+	cs_ctl->priv = NULL;
+	kfree(ctl);
+}
+
+static void hda_cs_dsp_add_kcontrol(struct cs_dsp_coeff_ctl *cs_ctl,
+				    const struct hda_cs_dsp_ctl_info *info,
+				    const char *name)
+{
 	struct snd_kcontrol_new kcontrol = {0};
 	struct snd_kcontrol *kctl;
+	struct hda_cs_dsp_coeff_ctl *ctl __free(kfree) = NULL;
 	int ret = 0;
 
 	if (cs_ctl->len > ADSP_MAX_STD_CTRL_SIZE) {
@@ -110,6 +123,13 @@ static void hda_cs_dsp_add_kcontrol(struct hda_cs_dsp_coeff_ctl *ctl, const char
 		return;
 	}
 
+	ctl = kzalloc(sizeof(*ctl), GFP_KERNEL);
+	if (!ctl)
+		return;
+
+	ctl->cs_ctl = cs_ctl;
+	ctl->card = info->card;
+
 	kcontrol.name = name;
 	kcontrol.info = hda_cs_dsp_coeff_info;
 	kcontrol.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
@@ -117,20 +137,22 @@ static void hda_cs_dsp_add_kcontrol(struct hda_cs_dsp_coeff_ctl *ctl, const char
 	kcontrol.get = hda_cs_dsp_coeff_get;
 	kcontrol.put = hda_cs_dsp_coeff_put;
 
-	/* Save ctl inside private_data, ctl is owned by cs_dsp,
-	 * and will be freed when cs_dsp removes the control */
 	kctl = snd_ctl_new1(&kcontrol, (void *)ctl);
 	if (!kctl)
 		return;
 
-	ret = snd_ctl_add(ctl->card, kctl);
+	kctl->private_free = hda_cs_dsp_free_kcontrol;
+	ctl->kctl = kctl;
+
+	/* snd_ctl_add() calls our private_free on error, which will kfree(ctl) */
+	cs_ctl->priv = no_free_ptr(ctl);
+	ret = snd_ctl_add(info->card, kctl);
 	if (ret) {
 		dev_err(cs_ctl->dsp->dev, "Failed to add KControl %s = %d\n", kcontrol.name, ret);
 		return;
 	}
 
 	dev_dbg(cs_ctl->dsp->dev, "Added KControl: %s\n", kcontrol.name);
-	ctl->kctl = kctl;
 }
 
 static void hda_cs_dsp_control_add(struct cs_dsp_coeff_ctl *cs_ctl,
@@ -138,7 +160,6 @@ static void hda_cs_dsp_control_add(struct cs_dsp_coeff_ctl *cs_ctl,
 {
 	struct cs_dsp *cs_dsp = cs_ctl->dsp;
 	char name[SNDRV_CTL_ELEM_ID_NAME_MAXLEN];
-	struct hda_cs_dsp_coeff_ctl *ctl;
 	const char *region_name;
 	int ret;
 
@@ -163,15 +184,7 @@ static void hda_cs_dsp_control_add(struct cs_dsp_coeff_ctl *cs_ctl,
 			 " %.*s", cs_ctl->subname_len - skip, cs_ctl->subname + skip);
 	}
 
-	ctl = kzalloc(sizeof(*ctl), GFP_KERNEL);
-	if (!ctl)
-		return;
-
-	ctl->cs_ctl = cs_ctl;
-	ctl->card = info->card;
-	cs_ctl->priv = ctl;
-
-	hda_cs_dsp_add_kcontrol(ctl, name);
+	hda_cs_dsp_add_kcontrol(cs_ctl, info, name);
 }
 
 void hda_cs_dsp_add_controls(struct cs_dsp *dsp, const struct hda_cs_dsp_ctl_info *info)
@@ -203,7 +216,9 @@ void hda_cs_dsp_control_remove(struct cs_dsp_coeff_ctl *cs_ctl)
 {
 	struct hda_cs_dsp_coeff_ctl *ctl = cs_ctl->priv;
 
-	kfree(ctl);
+	/* ctl and kctl may already have been removed by ALSA private_free */
+	if (ctl && ctl->kctl)
+		snd_ctl_remove(ctl->card, ctl->kctl);
 }
 EXPORT_SYMBOL_NS_GPL(hda_cs_dsp_control_remove, SND_HDA_CS_DSP_CONTROLS);
 
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56291BC09A;
	Thu,  6 Jun 2024 14:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683508; cv=none; b=fkXTtt27BmyYuRrKuFID/tMmd9ORJhUOXLUbR1DlEG6i1yPwFxfjg9duQLSTuh1lR+rFTESUeL0co7BxyLcS34Y/I/YIG0IAW4uHiOh+2hsPyifMgYU/YoHfGTWmPqsgGUfU3F0ukWvqOAbj8tpqfLSWOX2rogqKqBEcOmAuWzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683508; c=relaxed/simple;
	bh=tJzcgTgXgGFCY56QrcUpKgqGANf3YEv5hVFkGkaiTak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVoQsW5LjEeyRCQZ8bwU6mtS1xPVGY6hbtKIjyTI6Ir4HFAllPRrb2VoSOI3JDYXK9MU+xqa499hYLW1Cxt20sNR7K/X+d2lqGWlxWSxKUCB0tj2NAiFFa3mJIdEMIw4vvYnsy6YWSu+ytVO2HXrMh01eQ4xk5BcE3m1r11dKVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMsmXJXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMsmXJXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AECC32781;
	Thu,  6 Jun 2024 14:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683508;
	bh=tJzcgTgXgGFCY56QrcUpKgqGANf3YEv5hVFkGkaiTak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMsmXJXJ/opPqaPuDy/ojWKtQgF8cjCriA+6IX5uF4uL+klM1BqKeYvg/G7hFneCV
	 b7LoG3wI1HM79QINWZjKmrGMTrQ8e3Y+AyXCBTSQZX1VcpRPVDi5FEgRKDiYBoi9x+
	 6YiUvCX60XuimpjBzzAVrQVIdmOiD3HAViMluf4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 397/473] ALSA: hda/cs_dsp_ctl: Use private_free for control cleanup
Date: Thu,  6 Jun 2024 16:05:26 +0200
Message-ID: <20240606131712.946821371@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1622a22f96f6a..4a84ebe83157e 100644
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




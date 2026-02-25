Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50281EB5E1;
	Wed, 25 Feb 2026 01:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983199; cv=none; b=MonRSBRiL/yiC+6feWJhAuQBNl8YZUbmln+MswVPPhCUqy5Zk5jPLOdMU4Z89meN3T2N0LT7GXRSDvNCaNQaVkaY4G6k8HKyqaFp8RGqtc6NOHTQKX+cf6FNll1czlrwsjTXeJ7wXjQJLH/8cY07R1uz0PZGEuYYZplwXrxgJT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983199; c=relaxed/simple;
	bh=gG+H5YxytJfqttM9xfxr6ntG+EZXGbHs8G8S5trc3Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AcRX+zn8HYGFgc5UlHQkEdr2iQrA91uhWdsMCRLhowtABNo+c7jg8qLx65a/TGJIQ6WuZGTMHM7YKnPQBq8i1TO1XJHYV0MY8WErdyz48HpIk/dejHyC/HCm8LE56HVqfnWWpthIkkwE72A/tynhmpyx5sPAD0iFZy90pSn56y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sobRSvQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sobRSvQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64822C19423;
	Wed, 25 Feb 2026 01:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983199;
	bh=gG+H5YxytJfqttM9xfxr6ntG+EZXGbHs8G8S5trc3Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sobRSvQ86x1vljWzg8HfPdvlC9jlXBsjVH6oMGOSoNIZkxpVFKA9LbaWB5gl65hX6
	 rIF6i9WiOj6Aa3R0dRIZN01ORmZc0PXnNVz9bYAPmpBkwl6FZSeYOqoQ2WeoeHVNb5
	 14opuRMewxXFwdMtKo4VCP7PbjfVRGEMsbhlla3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 305/781] ASoC: SDCA: Add ability to connect SDCA jacks to ASoC jacks
Date: Tue, 24 Feb 2026 17:16:54 -0800
Message-ID: <20260225012407.189220706@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 82e12800f563baf663277ef0017f40a335b8e84c ]

Add handling for the ASoC jack API to SDCA to allow user-space to be
hooked up normally.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251215153650.3913117-3-ckeepax@opensource.cirrus.com
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: d7730c44b7dd ("ASoC: SDCA: Still process most of the jack detect if control is missing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/sdca_jack.h  |   5 ++
 sound/soc/sdca/sdca_jack.c | 106 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 110 insertions(+), 1 deletion(-)

diff --git a/include/sound/sdca_jack.h b/include/sound/sdca_jack.h
index 9fad5f22cbb9e..3ec22046d3ebc 100644
--- a/include/sound/sdca_jack.h
+++ b/include/sound/sdca_jack.h
@@ -12,16 +12,21 @@
 
 struct sdca_interrupt;
 struct snd_kcontrol;
+struct snd_soc_jack;
 
 /**
  * struct jack_state - Jack state structure to keep data between interrupts
  * @kctl: Pointer to the ALSA control attached to this jack
+ * @jack: Pointer to the ASoC jack struct for this jack
  */
 struct jack_state {
 	struct snd_kcontrol *kctl;
+	struct snd_soc_jack *jack;
 };
 
 int sdca_jack_alloc_state(struct sdca_interrupt *interrupt);
 int sdca_jack_process(struct sdca_interrupt *interrupt);
+int sdca_jack_set_jack(struct sdca_interrupt_info *info, struct snd_soc_jack *jack);
+int sdca_jack_report(struct sdca_interrupt *interrupt);
 
 #endif // __SDCA_JACK_H__
diff --git a/sound/soc/sdca/sdca_jack.c b/sound/soc/sdca/sdca_jack.c
index 83b2b9cc81f00..5b9cf69cbcd6b 100644
--- a/sound/soc/sdca/sdca_jack.c
+++ b/sound/soc/sdca/sdca_jack.c
@@ -17,11 +17,13 @@
 #include <linux/rwsem.h>
 #include <sound/asound.h>
 #include <sound/control.h>
+#include <sound/jack.h>
 #include <sound/sdca.h>
 #include <sound/sdca_function.h>
 #include <sound/sdca_interrupts.h>
 #include <sound/sdca_jack.h>
 #include <sound/soc-component.h>
+#include <sound/soc-jack.h>
 #include <sound/soc.h>
 
 /**
@@ -114,7 +116,7 @@ int sdca_jack_process(struct sdca_interrupt *interrupt)
 
 	snd_ctl_notify(card->snd_card, SNDRV_CTL_EVENT_MASK_VALUE, &kctl->id);
 
-	return 0;
+	return sdca_jack_report(interrupt);
 }
 EXPORT_SYMBOL_NS_GPL(sdca_jack_process, "SND_SOC_SDCA");
 
@@ -138,3 +140,105 @@ int sdca_jack_alloc_state(struct sdca_interrupt *interrupt)
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(sdca_jack_alloc_state, "SND_SOC_SDCA");
+
+/**
+ * sdca_jack_set_jack - attach an ASoC jack to SDCA
+ * @info: SDCA interrupt information.
+ * @jack: ASoC jack to be attached.
+ *
+ * Return: Zero on success or a negative error code.
+ */
+int sdca_jack_set_jack(struct sdca_interrupt_info *info, struct snd_soc_jack *jack)
+{
+	int i, ret;
+
+	guard(mutex)(&info->irq_lock);
+
+	for (i = 0; i < SDCA_MAX_INTERRUPTS; i++) {
+		struct sdca_interrupt *interrupt = &info->irqs[i];
+		struct sdca_control *control = interrupt->control;
+		struct sdca_entity *entity = interrupt->entity;
+		struct jack_state *jack_state;
+
+		if (!interrupt->irq)
+			continue;
+
+		switch (SDCA_CTL_TYPE(entity->type, control->sel)) {
+		case SDCA_CTL_TYPE_S(GE, DETECTED_MODE):
+			jack_state = interrupt->priv;
+			jack_state->jack = jack;
+
+			/* Report initial state in case IRQ was already handled */
+			ret = sdca_jack_report(interrupt);
+			if (ret)
+				return ret;
+			break;
+		default:
+			break;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(sdca_jack_set_jack, "SND_SOC_SDCA");
+
+int sdca_jack_report(struct sdca_interrupt *interrupt)
+{
+	struct jack_state *jack_state = interrupt->priv;
+	struct sdca_control_range *range;
+	enum sdca_terminal_type type;
+	unsigned int report = 0;
+	unsigned int reg, val;
+	int ret;
+
+	reg = SDW_SDCA_CTL(interrupt->function->desc->adr, interrupt->entity->id,
+			   SDCA_CTL_GE_SELECTED_MODE, 0);
+
+	ret = regmap_read(interrupt->function_regmap, reg, &val);
+	if (ret) {
+		dev_err(interrupt->dev, "failed to read selected mode: %d\n", ret);
+		return ret;
+	}
+
+	range = sdca_selector_find_range(interrupt->dev, interrupt->entity,
+					 SDCA_CTL_GE_SELECTED_MODE,
+					 SDCA_SELECTED_MODE_NCOLS, 0);
+	if (!range)
+		return -EINVAL;
+
+	type = sdca_range_search(range, SDCA_SELECTED_MODE_INDEX,
+				 val, SDCA_SELECTED_MODE_TERM_TYPE);
+
+	switch (type) {
+	case SDCA_TERM_TYPE_LINEIN_STEREO:
+	case SDCA_TERM_TYPE_LINEIN_FRONT_LR:
+	case SDCA_TERM_TYPE_LINEIN_CENTER_LFE:
+	case SDCA_TERM_TYPE_LINEIN_SURROUND_LR:
+	case SDCA_TERM_TYPE_LINEIN_REAR_LR:
+		report = SND_JACK_LINEIN;
+		break;
+	case SDCA_TERM_TYPE_LINEOUT_STEREO:
+	case SDCA_TERM_TYPE_LINEOUT_FRONT_LR:
+	case SDCA_TERM_TYPE_LINEOUT_CENTER_LFE:
+	case SDCA_TERM_TYPE_LINEOUT_SURROUND_LR:
+	case SDCA_TERM_TYPE_LINEOUT_REAR_LR:
+		report = SND_JACK_LINEOUT;
+		break;
+	case SDCA_TERM_TYPE_MIC_JACK:
+		report = SND_JACK_MICROPHONE;
+		break;
+	case SDCA_TERM_TYPE_HEADPHONE_JACK:
+		report = SND_JACK_HEADPHONE;
+		break;
+	case SDCA_TERM_TYPE_HEADSET_JACK:
+		report = SND_JACK_HEADSET;
+		break;
+	default:
+		break;
+	}
+
+	snd_soc_jack_report(jack_state->jack, report, 0xFFFF);
+
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(sdca_jack_report, "SND_SOC_SDCA");
-- 
2.51.0




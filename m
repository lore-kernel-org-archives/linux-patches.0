Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB12200CD;
	Mon,  4 Mar 2024 21:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588302; cv=none; b=kgm6lsikI/NqrjjgwyZc7dSgjbFvY0cA+fnrDoeokdPRMjFe6w/gmRt7Dk0q27y+SMwPDUzsIBqlS6lW2jjlw9VaA1FeFrddVx+erRjYGsX6Xunud8LZU0phKTR2SR+LUafR5E9KJFuBndPwaEfsQxbpF97cVK+h9+NYWbWlZe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588302; c=relaxed/simple;
	bh=CJQiwjgZCJ5ZxzDKLWrAcqw0zuZG3YaEYCvH4WPvwlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhF/H+qR9RG6GJNW3+YrAN9wK6XZCgWjy++rUtWZaknFpFzddGmU1yKWvEMUtg3cpj5DRfFhWVZfQgoa+G3WO8zEYefuFlCqdk+jIX7rXL0VbRhddk9oong9n0pG7RLT0UlHg87g7Mpx4EX9mkgmHt1fg28uFxhW17f2G/Hyv14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcghKSKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcghKSKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D1DC433F1;
	Mon,  4 Mar 2024 21:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588302;
	bh=CJQiwjgZCJ5ZxzDKLWrAcqw0zuZG3YaEYCvH4WPvwlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcghKSKeRJArbwcyJpLCMvnGpsBIjXcpPGWON6Hs9XOZRjxaXCKCDirCqBZPprTL+
	 LLxIss57xVW9xd57OpoQ8C2cNNaRtvZcYRd0fD+XYCsX0nok0iFZX5CXNxh8qBN0Ie
	 XPKhpTOT6heyN1RAjU0R+fCK77moce0STw5Y6+BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/143] ASoC: soc-card: Fix missing locking in snd_soc_card_get_kcontrol()
Date: Mon,  4 Mar 2024 21:22:56 +0000
Message-ID: <20240304211551.719101786@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit eba2eb2495f47690400331c722868902784e59de ]

snd_soc_card_get_kcontrol() must be holding a read lock on
card->controls_rwsem while walking the controls list.

Compare with snd_ctl_find_numid().

The existing function is renamed snd_soc_card_get_kcontrol_locked()
so that it can be called from contexts that are already holding
card->controls_rwsem (for example, control get/put functions).

There are few direct or indirect callers of
snd_soc_card_get_kcontrol(), and most are safe. Three require
changes, which have been included in this patch:

codecs/cs35l45.c:
  cs35l45_activate_ctl() is called from a control put() function so
  is changed to call snd_soc_card_get_kcontrol_locked().

codecs/cs35l56.c:
  cs35l56_sync_asp1_mixer_widgets_with_firmware() is called from
  control get()/put() functions so is changed to call
  snd_soc_card_get_kcontrol_locked().

fsl/fsl_xcvr.c:
  fsl_xcvr_activate_ctl() is called from three places, one of which
  already holds card->controls_rwsem:
  1. fsl_xcvr_mode_put(), a control put function, which will
     already be holding card->controls_rwsem.
  2. fsl_xcvr_startup(), a DAI startup function.
  3. fsl_xcvr_shutdown(), a DAI shutdown function.

  To fix this, fsl_xcvr_activate_ctl() has been changed to call
  snd_soc_card_get_kcontrol_locked() so that it is safe to call
  directly from fsl_xcvr_mode_put().
  The fsl_xcvr_startup() and fsl_xcvr_shutdown() functions have been
  changed to take a read lock on card->controls_rsem() around calls
  to fsl_xcvr_activate_ctl(). While this is not very elegant, it
  keeps the change small, to avoid this patch creating a large
  collateral churn in fsl/fsl_xcvr.c.

Analysis of other callers of snd_soc_card_get_kcontrol() is that
they do not need any changes, they are not holding card->controls_rwsem
when they call snd_soc_card_get_kcontrol().

Direct callers of snd_soc_card_get_kcontrol():
  fsl/fsl_spdif.c: fsl_spdif_dai_probe() - DAI probe function
  fsl/fsl_micfil.c: voice_detected_fn() - IRQ handler

Indirect callers via soc_component_notify_control():
  codecs/cs42l43: cs42l43_mic_shutter() - IRQ handler
  codecs/cs42l43: cs42l43_spk_shutter() - IRQ handler
  codecs/ak4118.c: ak4118_irq_handler() - IRQ handler
  codecs/wm_adsp.c: wm_adsp_write_ctl() - not currently used

Indirect callers via snd_soc_limit_volume():
  qcom/sc8280xp.c: sc8280xp_snd_init() - DAIlink init function
  ti/rx51.c: rx51_aic34_init() - DAI init function

I don't have hardware to test the fsl/*, qcom/sc828xp.c, ti/rx51.c
and ak4118.c changes.

Backport note:
The fsl/, qcom/, cs35l45, cs35l56 and cs42l43 callers were added
since the Fixes commit so won't all be present on older kernels.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 209c6cdfd283 ("ASoC: soc-card: move snd_soc_card_get_kcontrol() to soc-card")
Link: https://lore.kernel.org/r/20240221123710.690224-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-card.h   |  2 ++
 sound/soc/codecs/cs35l56.c |  2 +-
 sound/soc/fsl/fsl_xcvr.c   | 12 +++++++++++-
 sound/soc/soc-card.c       | 24 ++++++++++++++++++++++--
 4 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/include/sound/soc-card.h b/include/sound/soc-card.h
index ecc02e955279f..1f4c39922d825 100644
--- a/include/sound/soc-card.h
+++ b/include/sound/soc-card.h
@@ -30,6 +30,8 @@ static inline void snd_soc_card_mutex_unlock(struct snd_soc_card *card)
 
 struct snd_kcontrol *snd_soc_card_get_kcontrol(struct snd_soc_card *soc_card,
 					       const char *name);
+struct snd_kcontrol *snd_soc_card_get_kcontrol_locked(struct snd_soc_card *soc_card,
+						      const char *name);
 int snd_soc_card_jack_new(struct snd_soc_card *card, const char *id, int type,
 			  struct snd_soc_jack *jack);
 int snd_soc_card_jack_new_pins(struct snd_soc_card *card, const char *id,
diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index 83178d7c1197b..161f599ecbaee 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -112,7 +112,7 @@ static int cs35l56_sync_asp1_mixer_widgets_with_firmware(struct cs35l56_private
 			name = full_name;
 		}
 
-		kcontrol = snd_soc_card_get_kcontrol(dapm->card, name);
+		kcontrol = snd_soc_card_get_kcontrol_locked(dapm->card, name);
 		if (!kcontrol) {
 			dev_warn(cs35l56->base.dev, "Could not find control %s\n", name);
 			continue;
diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index f0fb33d719c25..c46f64557a7ff 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -174,7 +174,9 @@ static int fsl_xcvr_activate_ctl(struct snd_soc_dai *dai, const char *name,
 	struct snd_kcontrol *kctl;
 	bool enabled;
 
-	kctl = snd_soc_card_get_kcontrol(card, name);
+	lockdep_assert_held(&card->snd_card->controls_rwsem);
+
+	kctl = snd_soc_card_get_kcontrol_locked(card, name);
 	if (kctl == NULL)
 		return -ENOENT;
 
@@ -576,10 +578,14 @@ static int fsl_xcvr_startup(struct snd_pcm_substream *substream,
 	xcvr->streams |= BIT(substream->stream);
 
 	if (!xcvr->soc_data->spdif_only) {
+		struct snd_soc_card *card = dai->component->card;
+
 		/* Disable XCVR controls if there is stream started */
+		down_read(&card->snd_card->controls_rwsem);
 		fsl_xcvr_activate_ctl(dai, fsl_xcvr_mode_kctl.name, false);
 		fsl_xcvr_activate_ctl(dai, fsl_xcvr_arc_mode_kctl.name, false);
 		fsl_xcvr_activate_ctl(dai, fsl_xcvr_earc_capds_kctl.name, false);
+		up_read(&card->snd_card->controls_rwsem);
 	}
 
 	return 0;
@@ -598,11 +604,15 @@ static void fsl_xcvr_shutdown(struct snd_pcm_substream *substream,
 	/* Enable XCVR controls if there is no stream started */
 	if (!xcvr->streams) {
 		if (!xcvr->soc_data->spdif_only) {
+			struct snd_soc_card *card = dai->component->card;
+
+			down_read(&card->snd_card->controls_rwsem);
 			fsl_xcvr_activate_ctl(dai, fsl_xcvr_mode_kctl.name, true);
 			fsl_xcvr_activate_ctl(dai, fsl_xcvr_arc_mode_kctl.name,
 						(xcvr->mode == FSL_XCVR_MODE_ARC));
 			fsl_xcvr_activate_ctl(dai, fsl_xcvr_earc_capds_kctl.name,
 						(xcvr->mode == FSL_XCVR_MODE_EARC));
+			up_read(&card->snd_card->controls_rwsem);
 		}
 		ret = regmap_update_bits(xcvr->regmap, FSL_XCVR_EXT_IER0,
 					 FSL_XCVR_IRQ_EARC_ALL, 0);
diff --git a/sound/soc/soc-card.c b/sound/soc/soc-card.c
index 285ab4c9c7168..8a2f163da6bc9 100644
--- a/sound/soc/soc-card.c
+++ b/sound/soc/soc-card.c
@@ -5,6 +5,9 @@
 // Copyright (C) 2019 Renesas Electronics Corp.
 // Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
 //
+
+#include <linux/lockdep.h>
+#include <linux/rwsem.h>
 #include <sound/soc.h>
 #include <sound/jack.h>
 
@@ -26,12 +29,15 @@ static inline int _soc_card_ret(struct snd_soc_card *card,
 	return ret;
 }
 
-struct snd_kcontrol *snd_soc_card_get_kcontrol(struct snd_soc_card *soc_card,
-					       const char *name)
+struct snd_kcontrol *snd_soc_card_get_kcontrol_locked(struct snd_soc_card *soc_card,
+						      const char *name)
 {
 	struct snd_card *card = soc_card->snd_card;
 	struct snd_kcontrol *kctl;
 
+	/* must be held read or write */
+	lockdep_assert_held(&card->controls_rwsem);
+
 	if (unlikely(!name))
 		return NULL;
 
@@ -40,6 +46,20 @@ struct snd_kcontrol *snd_soc_card_get_kcontrol(struct snd_soc_card *soc_card,
 			return kctl;
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(snd_soc_card_get_kcontrol_locked);
+
+struct snd_kcontrol *snd_soc_card_get_kcontrol(struct snd_soc_card *soc_card,
+					       const char *name)
+{
+	struct snd_card *card = soc_card->snd_card;
+	struct snd_kcontrol *kctl;
+
+	down_read(&card->controls_rwsem);
+	kctl = snd_soc_card_get_kcontrol_locked(soc_card, name);
+	up_read(&card->controls_rwsem);
+
+	return kctl;
+}
 EXPORT_SYMBOL_GPL(snd_soc_card_get_kcontrol);
 
 static int jack_new(struct snd_soc_card *card, const char *id, int type,
-- 
2.43.0




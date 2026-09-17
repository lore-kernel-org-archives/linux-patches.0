Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145E95AA695;
	Thu, 17 Sep 2026 16:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661263; cv=none; b=uPM3o5kJ7OhFB5efT4IPqh9QPun8GNmP+7hzKTuuEx8LjAtqXK22eEnHGcWQZaTYVlqBLy53/90Nn0P0D/Zqy2BnW2LiysNjTsKk5TBY/n9ckGYbsBn5l4hgEnC9PzgKIgE1/mdSxymUntqGiiEJYgePevG1OTSdzQwGTwHpwlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661263; c=relaxed/simple;
	bh=MNu5tmslQVDf4Q5lvdwtWkgvhPXxXLmHXbMwQGDTCRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pagz+4YFYIHMy5txl89n8Ya+4S/GsCy2EWt8ghVUxcmG3jKo6Km0/ikRFT9btYG3jqssiqPtK4EM9RsIxQeggM9PSAdzsUJi0qLhXHMwrZ9wC6+uWVznzbv+AiIsyIe8qj9J7WNE8onLSMhuwhqDnBWEExOZ+LwdNdDI6KhGWWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KAg7R3sc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KAg7R3sc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB161F000FF;
	Thu, 17 Sep 2026 16:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661262;
	bh=NxjE0d4OnyZB6PpZfJ4TnxxgCHL6hotVWn++6nki1f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KAg7R3scZTXB79OK5YEpl82cVVZIv2lOD2pSzaAIecqlKkdHuXP+kJYzciJY5WHMF
	 joNU8R2BKH8547vvI2BTS3ZHmAoOYNjSVDvgbP0LlSNA9PiumIACbyvsJ7kJMRmxvA
	 C/57kF5wFq3sS2tQqce9oSmRysuzcGZinR6KXweU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ezio Galeazzi <eziogale@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0137/1250] ALSA: hda/ca0132: add QUIRK_GENERIC path for Gigabyte GA-Z170X-Gaming G1
Date: Thu, 17 Sep 2026 15:58:52 +0100
Message-ID: <20260917151555.761101257@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Ezio Galeazzi <eziogale@gmail.com>

[ Upstream commit e79615b05c78d19b085c8eb7971c82cb5b0f22d1 ]

Some CA0132 implementations (e.g. Gigabyte GA-Z170X-Gaming G1) produce
white noise when using the DSP firmware path. Add a QUIRK_GENERIC path
that uses the standard HDA generic parser instead, with custom pin
configs.
This patch applies against v6.18.24.

Signed-off-by: Ezio Galeazzi <eziogale@gmail.com>
Link: https://lore.kernel.org/0c0b781f-1595-4595-921a-66d83cf5930b@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/Kconfig  |   1 +
 sound/hda/codecs/ca0132.c | 111 +++++++++++++++++++++++++++++++++-----
 2 files changed, 99 insertions(+), 13 deletions(-)

diff --git a/sound/hda/codecs/Kconfig b/sound/hda/codecs/Kconfig
index addbc94243365..dcf340e5a0c1a 100644
--- a/sound/hda/codecs/Kconfig
+++ b/sound/hda/codecs/Kconfig
@@ -69,6 +69,7 @@ comment "Set to Y if you want auto-loading the codec driver"
 
 config SND_HDA_CODEC_CA0132
 	tristate "Build Creative CA0132 codec support"
+	select SND_HDA_GENERIC
 	help
 	  Say Y or M here to include Creative CA0132 codec support in
 	  snd-hda-intel driver.
diff --git a/sound/hda/codecs/ca0132.c b/sound/hda/codecs/ca0132.c
index dd054aedd501c..92fc93fb209a9 100644
--- a/sound/hda/codecs/ca0132.c
+++ b/sound/hda/codecs/ca0132.c
@@ -24,6 +24,7 @@
 #include "hda_local.h"
 #include "hda_auto_parser.h"
 #include "hda_jack.h"
+#include "generic.h"
 
 #include "ca0132_regs.h"
 
@@ -1060,6 +1061,8 @@ enum dsp_download_state {
  */
 
 struct ca0132_spec {
+	struct hda_gen_spec gen;
+
 	const struct snd_kcontrol_new *mixers[5];
 	unsigned int num_mixers;
 	const struct hda_verb *base_init_verbs;
@@ -1174,6 +1177,7 @@ enum {
 	QUIRK_R3D,
 	QUIRK_AE5,
 	QUIRK_AE7,
+	QUIRK_GENERIC,
 	QUIRK_NONE = HDA_FIXUP_ID_NOT_SET,
 };
 
@@ -1292,6 +1296,20 @@ static const struct hda_pintbl ae7_pincfgs[] = {
 	{}
 };
 
+static const struct hda_pintbl ca0132_generic_pincfgs[] = {
+	{ 0x0b, 0x41014111 },
+	{ 0x0c, 0x414520f0 }, /* SPDIF out */
+	{ 0x0d, 0x01014010 }, /* lineout */
+	{ 0x0e, 0x41c501f0 },
+	{ 0x0f, 0x411111f0 }, /* disabled */
+	{ 0x10, 0x411111f0 }, /* disabled */
+	{ 0x11, 0x41012014 },
+	{ 0x12, 0x37a790f0 }, /* mic */
+	{ 0x13, 0x77a701f0 },
+	{ 0x18, 0x500000f0 },
+	{}
+};
+
 static const struct hda_quirk ca0132_quirks[] = {
 	SND_PCI_QUIRK(0x1028, 0x057b, "Alienware M17x R4", QUIRK_ALIENWARE_M17XR4),
 	SND_PCI_QUIRK(0x1028, 0x0685, "Alienware 15 2015", QUIRK_ALIENWARE),
@@ -1304,6 +1322,7 @@ static const struct hda_quirk ca0132_quirks[] = {
 	SND_PCI_QUIRK(0x1458, 0xA016, "Recon3Di", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1458, 0xA026, "Gigabyte G1.Sniper Z97", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1458, 0xA036, "Gigabyte GA-Z170X-Gaming 7", QUIRK_R3DI),
+	SND_PCI_QUIRK(0x1458, 0xA046, "Gigabyte GA-Z170X-Gaming G1", QUIRK_GENERIC),
 	SND_PCI_QUIRK(0x3842, 0x1038, "EVGA X99 Classified", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x3842, 0x104b, "EVGA X299 Dark", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x3842, 0x1055, "EVGA Z390 DARK", QUIRK_R3DI),
@@ -1325,6 +1344,7 @@ static const struct hda_model_fixup ca0132_quirk_models[] = {
 	{ .id = QUIRK_R3D, .name = "r3d" },
 	{ .id = QUIRK_AE5, .name = "ae5" },
 	{ .id = QUIRK_AE7, .name = "ae7" },
+	{ .id = QUIRK_GENERIC, .name = "generic" },
 	{}
 };
 
@@ -9882,14 +9902,57 @@ static void sbz_detect_quirk(struct hda_codec *codec)
 	}
 }
 
+static void ca0132_generic_init_hook(struct hda_codec *codec)
+{
+	struct ca0132_spec *spec = codec->spec;
+
+	snd_hda_sequence_write(codec, spec->spec_init_verbs);
+}
+
+static int ca0132_generic_probe(struct hda_codec *codec)
+{
+	struct ca0132_spec *spec = codec->spec;
+	struct auto_pin_cfg *cfg = &spec->gen.autocfg;
+	int err;
+
+	snd_hda_gen_spec_init(&spec->gen);
+
+	snd_hda_apply_pincfgs(codec, ca0132_generic_pincfgs);
+
+	ca0132_init_chip(codec);
+
+	err = ca0132_prepare_verbs(codec);
+	if (err < 0)
+		return err;
+
+	err = snd_hda_parse_pin_def_config(codec, cfg, NULL);
+	if (err < 0)
+		return err;
+	err = snd_hda_gen_parse_auto_config(codec, cfg);
+	if (err < 0)
+		return err;
+
+	spec->gen.init_hook = ca0132_generic_init_hook;
+	spec->gen.automute_speaker = 0;
+	spec->gen.automute_lo = 0;
+
+	snd_hda_sequence_write(codec, spec->spec_init_verbs);
+	return 0;
+}
+
 static void ca0132_codec_remove(struct hda_codec *codec)
 {
 	struct ca0132_spec *spec = codec->spec;
 
-	if (ca0132_quirk(spec) == QUIRK_ZXR_DBPRO)
+	switch (ca0132_quirk(spec)) {
+	case QUIRK_GENERIC:
+		snd_hda_gen_remove(codec);
+		return;
+	case QUIRK_ZXR_DBPRO:
 		return dbpro_free(codec);
-	else
+	default:
 		return ca0132_free(codec);
+	}
 }
 
 static int ca0132_codec_probe(struct hda_codec *codec,
@@ -9906,14 +9969,21 @@ static int ca0132_codec_probe(struct hda_codec *codec,
 	codec->spec = spec;
 	spec->codec = codec;
 
-	/* Detect codec quirk */
-	snd_hda_pick_fixup(codec, ca0132_quirk_models, ca0132_quirks, NULL);
-	if (ca0132_quirk(spec) == QUIRK_SBZ)
-		sbz_detect_quirk(codec);
-
+	/* These must be set before any path is taken */
 	codec->pcm_format_first = 1;
 	codec->no_sticky_stream = 1;
 
+	/* Detect codec quirk */
+	snd_hda_pick_fixup(codec, ca0132_quirk_models, ca0132_quirks, NULL);
+	switch (ca0132_quirk(spec)) {
+	case QUIRK_SBZ:
+		sbz_detect_quirk(codec);
+		break;
+	case QUIRK_GENERIC:
+		return ca0132_generic_probe(codec);
+	default:
+		break;
+	}
 
 	spec->dsp_state = DSP_DOWNLOAD_INIT;
 	spec->num_mixers = 1;
@@ -10014,36 +10084,51 @@ static int ca0132_codec_build_controls(struct hda_codec *codec)
 {
 	struct ca0132_spec *spec = codec->spec;
 
-	if (ca0132_quirk(spec) == QUIRK_ZXR_DBPRO)
+	switch (ca0132_quirk(spec)) {
+	case QUIRK_GENERIC:
+		return snd_hda_gen_build_controls(codec);
+	case QUIRK_ZXR_DBPRO:
 		return dbpro_build_controls(codec);
-	else
+	default:
 		return ca0132_build_controls(codec);
+	}
 }
 
 static int ca0132_codec_build_pcms(struct hda_codec *codec)
 {
 	struct ca0132_spec *spec = codec->spec;
 
-	if (ca0132_quirk(spec) == QUIRK_ZXR_DBPRO)
+	switch (ca0132_quirk(spec)) {
+	case QUIRK_GENERIC:
+		return snd_hda_gen_build_pcms(codec);
+	case QUIRK_ZXR_DBPRO:
 		return dbpro_build_pcms(codec);
-	else
+	default:
 		return ca0132_build_pcms(codec);
+	}
 }
 
 static int ca0132_codec_init(struct hda_codec *codec)
 {
 	struct ca0132_spec *spec = codec->spec;
 
-	if (ca0132_quirk(spec) == QUIRK_ZXR_DBPRO)
+	switch (ca0132_quirk(spec)) {
+	case QUIRK_GENERIC:
+		return snd_hda_gen_init(codec);
+	case QUIRK_ZXR_DBPRO:
 		return dbpro_init(codec);
-	else
+	default:
 		return ca0132_init(codec);
+	}
 }
 
 static int ca0132_codec_suspend(struct hda_codec *codec)
 {
 	struct ca0132_spec *spec = codec->spec;
 
+	if (ca0132_quirk(spec) == QUIRK_GENERIC)
+		return 0;
+
 	cancel_delayed_work_sync(&spec->unsol_hp_work);
 	return 0;
 }
-- 
2.53.0




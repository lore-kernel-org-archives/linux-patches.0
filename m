Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E01BDF71;
	Mon,  6 Jan 2025 15:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177971; cv=none; b=TiylmuZ3E+ZhmZRr3y+voPVJ24pHZGdJd6OD+vNNPJIaUe22Vg+hM1omi0XUrLOZU6A30wan0IPBEdV1bmnTM039lwHNi1hNneQhyjjM2Ix09qjbpxTesxsx1gUvmXTIw8l/k/JYTn2hES9zq8hlQaAKOrcobVHec9xnn0gaaIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177971; c=relaxed/simple;
	bh=S6yqeSBnokvLVZiA/hfcyrEi5RZaMx7+drhPOhQRllU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSpDugCKCOkpEg7pxMNyDa6mcqHZM0HPHEEtg2IOE5G/1KyR3gLeUX5HMxMmSGsIEcYo72mxd9LBWgyJnQeLa5mf3fu42pMWv5TZm5NYi5CSzOZEeDW4b35uYluGLi/W/yXgRtEK2tpxHsQ8mg6TJjiCrGDSh+i0YaoEQPP/SZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Hm6qVvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Hm6qVvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CCBC4CEDF;
	Mon,  6 Jan 2025 15:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177971;
	bh=S6yqeSBnokvLVZiA/hfcyrEi5RZaMx7+drhPOhQRllU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Hm6qVvOqHtCjniBnJS09mAnpuVpcG01X7oNfa1OsgOUx8eM535KMyCYfSiqTHqsA
	 DssVrWCsdHEJxu2ReFXp9zuy6JUrn10vQaBKPAe6bbhEjThVBw4rySifnPiMflkwr+
	 IoSpP3fjVW2dkuv+R1mo4/VJVX3xpuOamSz3pPvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 087/156] ALSA: hda/ca0132: Use standard HD-audio quirk matching helpers
Date: Mon,  6 Jan 2025 16:16:13 +0100
Message-ID: <20250106151145.007991194@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7c005292e20ac53dfa601bf2a7375fd4815511ad ]

CA0132 used the PCI SSID lookup helper that doesn't support the model
string matching or quirk aliasing.

Replace it with the standard HD-audio quirk helpers for supporting
those, and add the definition of the model strings for supported
quirks, too.  There should be no visible change to the outside for the
working system, but the driver will parse the model option and apply
the quirk based on it from now on.

Link: https://patch.msgid.link/20241207133754.3658-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_ca0132.c | 37 ++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index e4673a71551a..d40197fb5fbd 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1134,7 +1134,6 @@ struct ca0132_spec {
 
 	struct hda_codec *codec;
 	struct delayed_work unsol_hp_work;
-	int quirk;
 
 #ifdef ENABLE_TUNING_CONTROLS
 	long cur_ctl_vals[TUNING_CTLS_COUNT];
@@ -1166,7 +1165,6 @@ struct ca0132_spec {
  * CA0132 quirks table
  */
 enum {
-	QUIRK_NONE,
 	QUIRK_ALIENWARE,
 	QUIRK_ALIENWARE_M17XR4,
 	QUIRK_SBZ,
@@ -1176,10 +1174,11 @@ enum {
 	QUIRK_R3D,
 	QUIRK_AE5,
 	QUIRK_AE7,
+	QUIRK_NONE = HDA_FIXUP_ID_NOT_SET,
 };
 
 #ifdef CONFIG_PCI
-#define ca0132_quirk(spec)		((spec)->quirk)
+#define ca0132_quirk(spec)		((spec)->codec->fixup_id)
 #define ca0132_use_pci_mmio(spec)	((spec)->use_pci_mmio)
 #define ca0132_use_alt_functions(spec)	((spec)->use_alt_functions)
 #define ca0132_use_alt_controls(spec)	((spec)->use_alt_controls)
@@ -1293,7 +1292,7 @@ static const struct hda_pintbl ae7_pincfgs[] = {
 	{}
 };
 
-static const struct snd_pci_quirk ca0132_quirks[] = {
+static const struct hda_quirk ca0132_quirks[] = {
 	SND_PCI_QUIRK(0x1028, 0x057b, "Alienware M17x R4", QUIRK_ALIENWARE_M17XR4),
 	SND_PCI_QUIRK(0x1028, 0x0685, "Alienware 15 2015", QUIRK_ALIENWARE),
 	SND_PCI_QUIRK(0x1028, 0x0688, "Alienware 17 2015", QUIRK_ALIENWARE),
@@ -1316,6 +1315,19 @@ static const struct snd_pci_quirk ca0132_quirks[] = {
 	{}
 };
 
+static const struct hda_model_fixup ca0132_quirk_models[] = {
+	{ .id = QUIRK_ALIENWARE, .name = "alienware" },
+	{ .id = QUIRK_ALIENWARE_M17XR4, .name = "alienware-m17xr4" },
+	{ .id = QUIRK_SBZ, .name = "sbz" },
+	{ .id = QUIRK_ZXR, .name = "zxr" },
+	{ .id = QUIRK_ZXR_DBPRO, .name = "zxr-dbpro" },
+	{ .id = QUIRK_R3DI, .name = "r3di" },
+	{ .id = QUIRK_R3D, .name = "r3d" },
+	{ .id = QUIRK_AE5, .name = "ae5" },
+	{ .id = QUIRK_AE7, .name = "ae7" },
+	{}
+};
+
 /* Output selection quirk info structures. */
 #define MAX_QUIRK_MMIO_GPIO_SET_VALS 3
 #define MAX_QUIRK_SCP_SET_VALS 2
@@ -9957,17 +9969,15 @@ static int ca0132_prepare_verbs(struct hda_codec *codec)
  */
 static void sbz_detect_quirk(struct hda_codec *codec)
 {
-	struct ca0132_spec *spec = codec->spec;
-
 	switch (codec->core.subsystem_id) {
 	case 0x11020033:
-		spec->quirk = QUIRK_ZXR;
+		codec->fixup_id = QUIRK_ZXR;
 		break;
 	case 0x1102003f:
-		spec->quirk = QUIRK_ZXR_DBPRO;
+		codec->fixup_id = QUIRK_ZXR_DBPRO;
 		break;
 	default:
-		spec->quirk = QUIRK_SBZ;
+		codec->fixup_id = QUIRK_SBZ;
 		break;
 	}
 }
@@ -9976,7 +9986,6 @@ static int patch_ca0132(struct hda_codec *codec)
 {
 	struct ca0132_spec *spec;
 	int err;
-	const struct snd_pci_quirk *quirk;
 
 	codec_dbg(codec, "patch_ca0132\n");
 
@@ -9987,11 +9996,7 @@ static int patch_ca0132(struct hda_codec *codec)
 	spec->codec = codec;
 
 	/* Detect codec quirk */
-	quirk = snd_pci_quirk_lookup(codec->bus->pci, ca0132_quirks);
-	if (quirk)
-		spec->quirk = quirk->value;
-	else
-		spec->quirk = QUIRK_NONE;
+	snd_hda_pick_fixup(codec, ca0132_quirk_models, ca0132_quirks, NULL);
 	if (ca0132_quirk(spec) == QUIRK_SBZ)
 		sbz_detect_quirk(codec);
 
@@ -10068,7 +10073,7 @@ static int patch_ca0132(struct hda_codec *codec)
 		spec->mem_base = pci_iomap(codec->bus->pci, 2, 0xC20);
 		if (spec->mem_base == NULL) {
 			codec_warn(codec, "pci_iomap failed! Setting quirk to QUIRK_NONE.");
-			spec->quirk = QUIRK_NONE;
+			codec->fixup_id = QUIRK_NONE;
 		}
 	}
 #endif
-- 
2.39.5




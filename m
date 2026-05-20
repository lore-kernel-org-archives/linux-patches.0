Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835CF3E5ECF;
	Wed, 20 May 2026 17:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299488; cv=none; b=EwQFtmRo6iHVP/poCkrAKu6ZaR21rlseHTEwlBcZIwLZ80Axzlhj/bp0BgtQt2449k5L9XD3hp1rqOEBpOolWgRdM1chFmZpClCWJb/0hLwrawWDbor8iKv0syXFbyLGRy8OQHMRMhJ3/7UxtVi9cxVICcraNF4ntIMeSnjMj5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299488; c=relaxed/simple;
	bh=jPkIfmZkmMX6D/q5a8RYtlZmJjM3qfmSu5qlop++J+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWgtpJRjqouBQoLOIx9Mqq1iiZR1lofGVE4x5CzOVsep8MnE1eayZH3bHeVBNu4NBeIy6wWi/32T24/gITxANCYsyc//p4dgyVsYJc6ktvD/laKS+NpRnVkUxpvBElDvHiJ6hh2k69ISvKeRD7ahaq+mgN+cnIPFhfw50XNn7Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bX2BEuw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bX2BEuw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BB71F000E9;
	Wed, 20 May 2026 17:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299487;
	bh=tlb8Cm45hTAPUEtcgussz15t0SMP9uPJqq2+DSiY6VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1bX2BEuwps3rxEe/rJrDMShgRP5mjOyB2NWATpB9N4gXnsIwdGGBDqyjEKeBCSnwz
	 fG3nRAUPLvusOGv4i41qkDQw7iBb73xCSGUU5Zepb70EGdb3Wvrcix/Qk5PgvyZUCp
	 Rl1Q+GhJLSzSYRZruFVLEdiF2OJh2ZxULJnBSwIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Robert Beckett <bob.beckett@collabora.com>,
	Umang Jain <uajain@igalia.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Melissa Wen <mwen@igalia.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 754/957] ASoC: amd: acp: Add DMI quirk for Valve Steam Deck OLED
Date: Wed, 20 May 2026 18:20:37 +0200
Message-ID: <20260520162150.917544875@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

[ Upstream commit b0f6f4ac7d5d04fe2adcdd63ed1cd1ad505b8958 ]

Commit 671dd2ffbd8b ("ASoC: amd: acp: Add new cpu dai and dailink creation for I2S BT instance")
introduced a change that "broke" Steam Deck's audio probe, in the OLED
model, as observed in the following dmesg snippet:

[...]
snd_sof_amd_vangogh 0000:04:00.5: Topology: ABI 3:26:0 Kernel ABI 3:23:1
sof_mach nau8821-max: ASoC: physical link acp-bt-codec (id 2) not exist
sof_mach nau8821-max: ASoC: topology: could not load header: -22
snd_sof_amd_vangogh 0000:04:00.5: tplg amd/sof-tplg/sof-vangogh-nau8821-max.tplg component load failed -22
snd_sof_amd_vangogh 0000:04:00.5: error: failed to load DSP topology -22
snd_sof_amd_vangogh 0000:04:00.5: ASoC error (-22): at snd_soc_component_probe() on 0000:04:00.5
sof_mach nau8821-max: ASoC: failed to instantiate card -22
sof_mach nau8821-max: error -EINVAL: Failed to register card(sof-nau8821-max)
sof_mach nau8821-max: probe with driver sof_mach failed with error -22
[...]

Notice the quotes in "broke": it's not really a bug in such commit,
but instead a problem with a topology file from Steam Deck OLED. This
was discussed to great extent in [1], and Cristian proposed a pretty
simple and functional change that resolved the issue for the Deck's
issue. That change, though, would break other devices, so it wasn't
accepted upstream. And the proper suggested solution (fix the topology)
was never implemented, so Valve's kernel (and anyone that wants to boot
the mainline on Steam Deck OLED) is carrying that fix downstream.

So, we propose hereby a different approach: a DMI quirk, as many already
present in the sound drivers, to address this issue solely on Steam Deck
OLED, not breaking other devices and as a bonus, allowing simple patch
up in case eventually the topology file gets fixed (we'd just need to
check against any DMI info reflecting that or the topology/FW versions).

The motivation of such upstream quirk is related to users that want
to test latest kernel trees on their devices and get no only non-working
sound device, but seems some games (like Ori and the Blind Forest)
can't properly work without a proper functional audio device.
Example of such report can be seen at [2].

Cc: Mark Brown <broonie@kernel.org>
Cc: Robert Beckett <bob.beckett@collabora.com>
Cc: Umang Jain <uajain@igalia.com>
Fixes: 671dd2ffbd8b ("ASoC: amd: acp: Add new cpu dai and dailink creation for I2S BT instance")
Link: https://lore.kernel.org/r/20231209205351.880797-11-cristian.ciocaltea@collabora.com/ [1]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218677 [2]
Reviewed-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Melissa Wen <mwen@igalia.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Link: https://patch.msgid.link/20260423183505.116445-1-gpiccoli@igalia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-legacy-mach.c |  2 +-
 sound/soc/amd/acp/acp-mach-common.c | 22 +++++++++++++++++++---
 sound/soc/amd/acp/acp-mach.h        |  4 ++++
 sound/soc/amd/acp/acp-sof-mach.c    |  2 +-
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/sound/soc/amd/acp/acp-legacy-mach.c b/sound/soc/amd/acp/acp-legacy-mach.c
index a7a551366a409..235d6cc83fa98 100644
--- a/sound/soc/amd/acp/acp-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-legacy-mach.c
@@ -174,7 +174,7 @@ static int acp_asoc_probe(struct platform_device *pdev)
 		acp_card_drvdata->acp_rev = mach->mach_params.subsystem_rev;
 
 	dmi_id = dmi_first_match(acp_quirk_table);
-	if (dmi_id && dmi_id->driver_data)
+	if (dmi_id && dmi_id->driver_data == (void *)QUIRK_TDM_MODE_ENABLE)
 		acp_card_drvdata->tdm_mode = dmi_id->driver_data;
 
 	ret = acp_legacy_dai_links_create(card);
diff --git a/sound/soc/amd/acp/acp-mach-common.c b/sound/soc/amd/acp/acp-mach-common.c
index c4bc8e849284c..a2031e7f61424 100644
--- a/sound/soc/amd/acp/acp-mach-common.c
+++ b/sound/soc/amd/acp/acp-mach-common.c
@@ -20,6 +20,7 @@
 #include <sound/soc.h>
 #include <linux/input.h>
 #include <linux/module.h>
+#include <linux/dmi.h>
 
 #include "../../codecs/rt5682.h"
 #include "../../codecs/rt1019.h"
@@ -37,15 +38,21 @@
 #define NAU8821_FREQ_OUT	12288000
 #define MAX98388_CODEC_DAI	"max98388-aif1"
 
-#define TDM_MODE_ENABLE 1
-
 const struct dmi_system_id acp_quirk_table[] = {
 	{
 		/* Google skyrim proto-0 */
 		.matches = {
 			DMI_EXACT_MATCH(DMI_PRODUCT_FAMILY, "Google_Skyrim"),
 		},
-		.driver_data = (void *)TDM_MODE_ENABLE,
+		.driver_data = (void *)QUIRK_TDM_MODE_ENABLE,
+	},
+	{
+		/* Valve Steam Deck OLED */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Valve"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Galileo"),
+		},
+		.driver_data = (void *)QUIRK_REMAP_DMIC_BT,
 	},
 	{}
 };
@@ -1385,6 +1392,7 @@ int acp_sofdsp_dai_links_create(struct snd_soc_card *card)
 	struct snd_soc_dai_link *links;
 	struct device *dev = card->dev;
 	struct acp_card_drvdata *drv_data = card->drvdata;
+	const struct dmi_system_id *dmi_id = dmi_first_match(acp_quirk_table);
 	int i = 0, num_links = 0;
 
 	if (drv_data->hs_cpu_id)
@@ -1556,6 +1564,9 @@ int acp_sofdsp_dai_links_create(struct snd_soc_card *card)
 			links[i].codecs = &snd_soc_dummy_dlc;
 			links[i].num_codecs = 1;
 		}
+
+		if (dmi_id && dmi_id->driver_data == (void *)QUIRK_REMAP_DMIC_BT)
+			links[i].id = DMIC_BE_ID;
 		i++;
 	}
 
@@ -1571,6 +1582,11 @@ int acp_sofdsp_dai_links_create(struct snd_soc_card *card)
 		links[i].capture_only = 1;
 		links[i].nonatomic = true;
 		links[i].no_pcm = 1;
+
+		if (dmi_id && dmi_id->driver_data == (void *)QUIRK_REMAP_DMIC_BT) {
+			links[i].id = BT_BE_ID;
+			dev_dbg(dev, "quirk REMAP_DMIC_BT enabled\n");
+		}
 	}
 
 	card->dai_link = links;
diff --git a/sound/soc/amd/acp/acp-mach.h b/sound/soc/amd/acp/acp-mach.h
index f94c30c20f20b..7177d3fd96192 100644
--- a/sound/soc/amd/acp/acp-mach.h
+++ b/sound/soc/amd/acp/acp-mach.h
@@ -26,6 +26,10 @@
 
 #define acp_get_drvdata(card) ((struct acp_card_drvdata *)(card)->drvdata)
 
+/* List of DMI quirks - check acp-mach-common.c for usage. */
+#define QUIRK_TDM_MODE_ENABLE 1
+#define QUIRK_REMAP_DMIC_BT 2
+
 enum be_id {
 	HEADSET_BE_ID = 0,
 	AMP_BE_ID,
diff --git a/sound/soc/amd/acp/acp-sof-mach.c b/sound/soc/amd/acp/acp-sof-mach.c
index 6215e31eceddf..36ecef7013b9c 100644
--- a/sound/soc/amd/acp/acp-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sof-mach.c
@@ -110,7 +110,7 @@ static int acp_sof_probe(struct platform_device *pdev)
 
 	acp_card_drvdata = card->drvdata;
 	dmi_id = dmi_first_match(acp_quirk_table);
-	if (dmi_id && dmi_id->driver_data)
+	if (dmi_id && dmi_id->driver_data == (void *)QUIRK_TDM_MODE_ENABLE)
 		acp_card_drvdata->tdm_mode = dmi_id->driver_data;
 
 	acp_card_drvdata->acp_rev = mach->mach_params.subsystem_rev;
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA111DE8AE;
	Sat, 14 Feb 2026 01:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031086; cv=none; b=cgskD4lTeJsUjTLjiqzRMF+iW20C2oLRYDnyV6PquQ+IePEeqA4bP2bUZzZnFQHBq0gtO7cr6TogP0LDqM9ryOySmEoyhWeAmA1FX8EKQAhz1m+Yg2Fv4R1pr9T82tnHy19dg9nB3K6H54YWj6nIY2/zof8V21ijTunT/oQHazU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031086; c=relaxed/simple;
	bh=oxRyOpzNXomCcgLihhBoiOsspK8db4IoQtFKoIklDvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bq1b5Yvy9KpsX3N2m35qgsNLUYMZRZX8YALKgXECjZmgLlT86WmKDR58ehv/0ytG+HErLSuUffiwIm74Txiz2uB32dgLtPJgDq2eLKabiDkxRkWR6FQY91W4r0w/7bXVSgmlq4WdRhxh34420pcfou1Np0j6w/Plv/pq68geUX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WEkVVN6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WEkVVN6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2BFC16AAE;
	Sat, 14 Feb 2026 01:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031086;
	bh=oxRyOpzNXomCcgLihhBoiOsspK8db4IoQtFKoIklDvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WEkVVN6u1bMYq+O2KANlf7oiT0Kc0xs0eocBgSK7X08vV//c4icPaf8971cjI3Eui
	 mABO8GQF2c6bU2sqkcuookPKnjOdGPkezSXrQRcCvRBgB/ripcJcYgpkEqmOzEwKQF
	 HeVUWZEU4twmip5dj9njqMuGVJvcThFhqNcYfeR9cWli1AfYvh5yX7QSMNQ7KDM55g
	 rpu3YC1TSOs07/wx/XpRJJcNvR3iZ8OukxUWzBMBNrUWERo1ab1QU4UjNC2lRkDEyo
	 /zqvS9l02iNCWO4PE8N3bu+yl69xSh1SIUwAYIM0LDDjt18hjz51MQqqoulvbENsJf
	 c7mPtdoKeOBKA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Samuel Dionne-Riel <samuel@dionne-riel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	sbinding@opensource.cirrus.com,
	kailang@realtek.com,
	chris.chiu@canonical.com
Subject: [PATCH AUTOSEL 6.19] ALSA: hda/realtek: Add quirk for Minisforum V3 SE
Date: Fri, 13 Feb 2026 19:58:55 -0500
Message-ID: <20260214010245.3671907-55-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Samuel Dionne-Riel <samuel@dionne-riel.com>

[ Upstream commit e3474301824926ecce1d45f2ede7ecdda9a35840 ]

First, adding a generic quirk for Bass speaker DAC avoidance.

This pattern (re-routing the bass speakers off of a DAC without volume
control) seems common enough that having a "model" to match against and
quickly use to verify may be worthwhile.

The alc285_fixup_thinkpad_x1_gen7 routing was selected, amongst the
different options, as it should allow tuning the ratio between both
speaker set.

The routing was verified using `hda-verb`, and picking either 0x00 or
0x01. Either routing made the volume of the bass speakers controllable.

    hda-verb /dev/snd/hwC1D0 0x17 SET_CONNECT_SEL 0x01

This likely will apply for the Minisforum V3, though there isn't a lot
of information to confirm whether or not the identifiers are the same.

This was verified on the Minisforum V3 SE, and the root cause (the bass
speakers routing) was found out by using pink noise, and playing with
the mixers.

Signed-off-by: Samuel Dionne-Riel <samuel@dionne-riel.com>
Link: https://patch.msgid.link/20260203010132.1981419-2-samuel@dionne-riel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis
This commit adds a hardware quirk for the Minisforum V3 SE device. The
problem is that the bass speakers are routed through a DAC without
volume control, meaning users cannot control the bass speaker volume.
The fix re-routes the bass speakers to a DAC that has volume control,
borrowing the routing already used for ThinkPad X1 Gen 7.

### Code Change Analysis
The changes are in three parts, all within
`sound/hda/codecs/realtek/alc269.c`:

1. **New enum entry**: `ALC245_FIXUP_BASS_HP_DAC` added to the fixup
   enum
2. **New fixup definition**: A simple fixup entry that reuses the
   existing `alc285_fixup_thinkpad_x1_gen7` function for DAC routing
3. **New PCI quirk entry**: `SND_PCI_QUIRK(0x1f4c, 0xe001, "Minisforum
   V3 (SE)", ALC245_FIXUP_BASS_HP_DAC)` - maps the specific PCI
   subsystem ID to the new fixup
4. **New model string**: `{.id = ALC245_FIXUP_BASS_HP_DAC, .name =
   "alc245-fixup-bass-hp-dac"}` added to the model fixup table

### Classification
This is a **hardware quirk** addition. It falls squarely into the
"QUIRKS and WORKAROUNDS" exception category for stable backports. The
quirk fixes a real hardware issue where bass speakers on the Minisforum
V3 SE cannot have their volume controlled.

### Scope and Risk Assessment
- **Very small change**: ~10 lines of actual new code
- **Zero risk to other hardware**: The quirk is matched by a specific
  PCI subsystem vendor/device ID (0x1f4c, 0xe001), so it only affects
  this exact device
- **Reuses existing, proven code**: The `alc285_fixup_thinkpad_x1_gen7`
  function is already well-tested on ThinkPad hardware
- **Verified by user**: The commit message states the fix was verified
  on actual hardware using `hda-verb`

### User Impact
Without this quirk, the Minisforum V3 SE has bass speakers that cannot
be volume-controlled - they play at full volume or not at all. This is a
significant usability issue for real hardware owners.

### Stability
- Uses an existing fixup function (no new code logic)
- Device-specific PCI ID matching ensures no other devices are affected
- The pattern is identical to hundreds of other audio quirks in this
  file

### Dependencies
No dependencies on other commits. The `alc285_fixup_thinkpad_x1_gen7`
function already exists in stable trees. The only requirement is that
the enum numbering lines up, which is a standard consideration for any
quirk addition.

### Conclusion
This is a textbook hardware quirk addition - small, device-specific,
zero risk to other hardware, fixes a real usability issue on specific
hardware, and reuses existing proven fixup code. Audio codec quirks are
one of the most common types of stable backports.

**YES**

 sound/hda/codecs/realtek/alc269.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 527630446631f..f26c0aaa4c705 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -4046,6 +4046,7 @@ enum {
 	ALC288_FIXUP_SURFACE_SWAP_DACS,
 	ALC236_FIXUP_HP_MUTE_LED_MICMUTE_GPIO,
 	ALC233_FIXUP_LENOVO_GPIO2_MIC_HOTKEY,
+	ALC245_FIXUP_BASS_HP_DAC,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -6548,6 +6549,11 @@ static const struct hda_fixup alc269_fixups[] = {
                 .type = HDA_FIXUP_FUNC,
                 .v.func = alc233_fixup_lenovo_gpio2_mic_hotkey,
         },
+	[ALC245_FIXUP_BASS_HP_DAC] = {
+		.type = HDA_FIXUP_FUNC,
+		/* Borrow the DAC routing selected for those Thinkpads */
+		.v.func = alc285_fixup_thinkpad_x1_gen7,
+	},
 };
 
 static const struct hda_quirk alc269_fixup_tbl[] = {
@@ -7607,6 +7613,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1e39, 0xca14, "MEDION NM14LNL", ALC233_FIXUP_MEDION_MTL_SPK),
 	SND_PCI_QUIRK(0x1ee7, 0x2078, "HONOR BRB-X M1010", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1f4c, 0xe001, "Minisforum V3 (SE)", ALC245_FIXUP_BASS_HP_DAC),
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2039, 0x0001, "Inspur S14-G1", ALC295_FIXUP_CHROME_BOOK),
@@ -7822,6 +7829,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC285_FIXUP_HP_GPIO_AMP_INIT, .name = "alc285-hp-amp-init"},
 	{.id = ALC236_FIXUP_LENOVO_INV_DMIC, .name = "alc236-fixup-lenovo-inv-mic"},
 	{.id = ALC2XX_FIXUP_HEADSET_MIC, .name = "alc2xx-fixup-headset-mic"},
+	{.id = ALC245_FIXUP_BASS_HP_DAC, .name = "alc245-fixup-bass-hp-dac"},
 	{}
 };
 #define ALC225_STANDARD_PINS \
-- 
2.51.0


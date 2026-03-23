Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8CB3B27E5;
	Mon, 23 Mar 2026 14:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275110; cv=none; b=ZdnDEQwE/yUdW29LipUSzNwL4hWnXAsRenEvDjQCaNW9piQX4Ab6KolQpNKb+a00Jwbn/cxuLqnMmi8rMqWfEixyeSyOoOT4zYxANUxMGaUptU6wy87Nrqg2AFCiljbfOeKID54MYmgw+LIqamsQLWE1R3n39IbRDox5yGOl1ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275110; c=relaxed/simple;
	bh=JJJPRhmFdVOmOUfDUXTTzUP05PoByBuSAwwSOtvA8I0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCgrrd80mBgydyReMZ9nYg1Mb5Vok0w6vGPR3qDsccZUzo/5YCyibHnhwgVDwRgUMpRZUdAbMVx+PmgT/UdnF88uzLWi2CKuXr9du2UdXaB1dp50+CyplBjNspUOBwqCqEY1xVHAHcpPJIg0K+ESkAs1UKlfu0iXyInft7aDzuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLmKWEy7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLmKWEy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5330C2BC9E;
	Mon, 23 Mar 2026 14:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275110;
	bh=JJJPRhmFdVOmOUfDUXTTzUP05PoByBuSAwwSOtvA8I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLmKWEy7TxBFC00cflnttaLdLjHqGm4MLxxIhK2Spl7B2ph4cgEhxl3XwPkV3aHYo
	 sLtcFLZ5EurFklTUnwxiQiN9XM+3AWoqbXf+LtSlcHj6Ohay5WvIg5pXyCgOorwlvY
	 r2Ecjd4THCxKVwl5F6GJq+TX27/kO3BoIxJJ/uog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.com>,
	Sean Rhodes <sean@starlabs.systems>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/460] ALSA: hda/realtek: Fix speaker pop on Star Labs StarFighter
Date: Mon, 23 Mar 2026 14:40:00 +0100
Message-ID: <20260323134526.759335448@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Rhodes <sean@starlabs.systems>

[ Upstream commit 1cb3c20688fc8380c9b365d03aea7e84faf6a9fd ]

On Star Labs StarFighter (Realtek ALC233/235), the internal speakers can
emit an audible pop when entering or leaving runtime suspend.

Mute the speaker output paths via snd_hda_gen_shutup_speakers() in the
Realtek shutup callback before the codec is powered down.

This is enough to avoid the pop without special EAPD handling.

Test results:
- runtime PM pop fixed
- still reaches D3 (PCI 0000:00:1f.3 power_state=D3hot)
- does not address pops on cold boot (G3 exit) or around display manager
  start/shutdown

journalctl -k (boot):
- snd_hda_codec_alc269 hdaudioC0D0: ALC233: picked fixup for PCI SSID
  7017:2014
- snd_hda_codec_alc269 hdaudioC0D0: autoconfig for ALC233: line_outs=1
  (0x1b/0x0/0x0/0x0/0x0) type:speaker

Suggested-by: Takashi Iwai <tiwai@suse.com>
Tested-by: Sean Rhodes <sean@starlabs.systems>
Signed-off-by: Sean Rhodes <sean@starlabs.systems>
Link: https://patch.msgid.link/4d5fb71b132bb283fd41c622b8413770b2065242.1771532060.git.sean@starlabs.systems
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c13def0f1e1a4..cb6ff3c36c5f0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4164,6 +4164,24 @@ static int alc269_resume(struct hda_codec *codec)
 	return 0;
 }
 
+#define STARLABS_STARFIGHTER_SHUTUP_DELAY_MS	30
+
+static void starlabs_starfighter_shutup(struct hda_codec *codec)
+{
+	if (snd_hda_gen_shutup_speakers(codec))
+		msleep(STARLABS_STARFIGHTER_SHUTUP_DELAY_MS);
+}
+
+static void alc233_fixup_starlabs_starfighter(struct hda_codec *codec,
+					      const struct hda_fixup *fix,
+					      int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		spec->shutup = starlabs_starfighter_shutup;
+}
+
 static void alc269_fixup_pincfg_no_hp_to_lineout(struct hda_codec *codec,
 						 const struct hda_fixup *fix, int action)
 {
@@ -8203,6 +8221,7 @@ enum {
 	ALC245_FIXUP_CLEVO_NOISY_MIC,
 	ALC269_FIXUP_VAIO_VJFH52_MIC_NO_PRESENCE,
 	ALC233_FIXUP_MEDION_MTL_SPK,
+	ALC233_FIXUP_STARLABS_STARFIGHTER,
 	ALC294_FIXUP_BASS_SPEAKER_15,
 	ALC283_FIXUP_DELL_HP_RESUME,
 	ALC294_FIXUP_ASUS_CS35L41_SPI_2,
@@ -10591,6 +10610,10 @@ static const struct hda_fixup alc269_fixups[] = {
 			{ }
 		},
 	},
+	[ALC233_FIXUP_STARLABS_STARFIGHTER] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc233_fixup_starlabs_starfighter,
+	},
 	[ALC294_FIXUP_BASS_SPEAKER_15] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc294_fixup_bass_speaker_15,
@@ -11606,6 +11629,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x2782, 0x1705, "MEDION E15433", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x2782, 0x4900, "MEDION E15443", ALC233_FIXUP_MEDION_MTL_SPK),
+	SND_PCI_QUIRK(0x7017, 0x2014, "Star Labs StarFighter", ALC233_FIXUP_STARLABS_STARFIGHTER),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
@@ -11702,6 +11726,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC298_FIXUP_TPT470_DOCK_FIX, .name = "tpt470-dock-fix"},
 	{.id = ALC298_FIXUP_TPT470_DOCK, .name = "tpt470-dock"},
 	{.id = ALC233_FIXUP_LENOVO_MULTI_CODECS, .name = "dual-codecs"},
+	{.id = ALC233_FIXUP_STARLABS_STARFIGHTER, .name = "starlabs-starfighter"},
 	{.id = ALC700_FIXUP_INTEL_REFERENCE, .name = "alc700-ref"},
 	{.id = ALC269_FIXUP_SONY_VAIO, .name = "vaio"},
 	{.id = ALC269_FIXUP_DELL_M101Z, .name = "dell-m101z"},
-- 
2.51.0




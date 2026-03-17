Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CF23E3DAB;
	Tue, 17 Mar 2026 16:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765450; cv=none; b=Vlpak/doYi25GQ5XOZy/r54tPoo/k1hWZxD85gj5P6crW2mG+S+MdRCaVBfC8mL6iuPfYT58813se6DNl9JPYYqSeOmhGVC+cnw9p91u1vOIuodlkQXDjcpUjCuCjt713AIrmV8WYU1I8whbyp8lHd6R3Om4PHzfRAXd2Uyl3ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765450; c=relaxed/simple;
	bh=w1o3GV+oo/onask9i/U6zUyDw+xzjfm4a1/2Wo+onIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJUtgS/CPfawun76Uc3jJZ0fLiTX0tzL3AA2Mq6ZtRuXpsKBdbcX9THDChK3hl3NrlAe7SLCtUg/IUmK0qt2nKbPSRCTtLlYnqT4GsJ8anolc7khhI3Mm6WnjrzOgzQZYW0wh1rAAhpcfYMu5oaBpLSPAGGmfRO9g3DKC0VJT00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0kpLEtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0kpLEtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78636C19424;
	Tue, 17 Mar 2026 16:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765450;
	bh=w1o3GV+oo/onask9i/U6zUyDw+xzjfm4a1/2Wo+onIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0kpLEtJcptPzjanRMvijKkUJZjQVm5rgesDuj1v5LiAM3JzjM4VTe7O5PmI55xLs
	 6P/xNfjYurBHLiPptM0cw6bpOm6tDikz/OfTIUMg7xz+4Ykca4hiDCnD8Z8Swu6Ig2
	 ++F8ZhT5z77ie71Apad9GgaidaPbmdY133BJVhJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.com>,
	Sean Rhodes <sean@starlabs.systems>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 014/378] ALSA: hda/realtek: Fix speaker pop on Star Labs StarFighter
Date: Tue, 17 Mar 2026 17:29:31 +0100
Message-ID: <20260317163007.499188560@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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
 sound/hda/codecs/realtek/alc269.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index f5719e630d28a..4c49f1195e1bc 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -1017,6 +1017,24 @@ static int alc269_resume(struct hda_codec *codec)
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
@@ -4040,6 +4058,7 @@ enum {
 	ALC245_FIXUP_CLEVO_NOISY_MIC,
 	ALC269_FIXUP_VAIO_VJFH52_MIC_NO_PRESENCE,
 	ALC233_FIXUP_MEDION_MTL_SPK,
+	ALC233_FIXUP_STARLABS_STARFIGHTER,
 	ALC294_FIXUP_BASS_SPEAKER_15,
 	ALC283_FIXUP_DELL_HP_RESUME,
 	ALC294_FIXUP_ASUS_CS35L41_SPI_2,
@@ -6500,6 +6519,10 @@ static const struct hda_fixup alc269_fixups[] = {
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
@@ -7662,6 +7685,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x2782, 0x1705, "MEDION E15433", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x2782, 0x4900, "MEDION E15443", ALC233_FIXUP_MEDION_MTL_SPK),
+	SND_PCI_QUIRK(0x7017, 0x2014, "Star Labs StarFighter", ALC233_FIXUP_STARLABS_STARFIGHTER),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
@@ -7758,6 +7782,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC298_FIXUP_TPT470_DOCK_FIX, .name = "tpt470-dock-fix"},
 	{.id = ALC298_FIXUP_TPT470_DOCK, .name = "tpt470-dock"},
 	{.id = ALC233_FIXUP_LENOVO_MULTI_CODECS, .name = "dual-codecs"},
+	{.id = ALC233_FIXUP_STARLABS_STARFIGHTER, .name = "starlabs-starfighter"},
 	{.id = ALC700_FIXUP_INTEL_REFERENCE, .name = "alc700-ref"},
 	{.id = ALC269_FIXUP_SONY_VAIO, .name = "vaio"},
 	{.id = ALC269_FIXUP_DELL_M101Z, .name = "dell-m101z"},
-- 
2.51.0




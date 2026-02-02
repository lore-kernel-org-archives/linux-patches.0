Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385EC315D28;
	Mon,  2 Feb 2026 21:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068815; cv=none; b=XUDNDPnwRCSOQkW5p8PRNV9ZEz5J18TIuHUSPVYCe7AlUwOP2ozlb5D5tboHG+YARvg8jv5gBTOrSmYiJy80yD3EyxUSd9SfWR7tokvVgyMinorQZyC9Jb8LVF/7/U1dXM7rE3G0wqwH61sR10QjhKlvv+vgaG1y5VeYKSvNzkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068815; c=relaxed/simple;
	bh=q5jOZpkpq5JllY90MmWL++/0M9i/2ri13o2GtkbI/SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0bSAcjYAGxWP4BTH3/JD9bEPIl2UPFZFzyTyMh6Nxj/EJ1P6C1+DV6iGjT58TkAfpMpdYFenxYedJ4dLRouJQRU6JQpVFaJNMSjx2Bi+SbtHTMZqWi4aA87ebjaVya3mpSQ9nSIjBLP3KZGxQvLnYRUQGsIVWM5pCkHDH0NpLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mSDUUi+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mSDUUi+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F6FC116C6;
	Mon,  2 Feb 2026 21:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770068815;
	bh=q5jOZpkpq5JllY90MmWL++/0M9i/2ri13o2GtkbI/SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSDUUi+N2JrQXkRELY1XlUB48aNp3MltMurjQZa1Eivvu5Phg6PN3ryYlOn4/iIvB
	 /NRgYtbNzAcSDJfOaebvBbxF8L6vl0MtKZJtcTbOXYNqX1E5MY2ROAPJrwNDQPLMQW
	 bz6VrSZ/jVdTkFH9H9cx7UZKnOD+p9cpHNXHA8o6aSY6IUHspW02hER8A4MKOIFcP8
	 pFvNS+tRe6MfkLrJnnJCcqQAaJdoq8meCjZDS+1M/MwDo9drA7b848nC3cxXEkTBgn
	 RHXSGUBgOnrnygvlzh9O/rXmGiKPOhQUj+VEYp5v4LtJFhusncNTSd0oL3eGuWC9eF
	 duZkdF86hNdqg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Martin Hamilton <m@martinh.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	sbinding@opensource.cirrus.com,
	kailang@realtek.com,
	chris.chiu@canonical.com,
	edip@medip.dev
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda/realtek: ALC269 fixup for Lenovo Yoga Book 9i 13IRU8 audio
Date: Mon,  2 Feb 2026 16:45:59 -0500
Message-ID: <20260202214643.212290-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260202214643.212290-1-sashal@kernel.org>
References: <20260202214643.212290-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.8
Content-Transfer-Encoding: 8bit

From: Martin Hamilton <m@martinh.net>

[ Upstream commit 64e0924ed3b446fdd758dfab582e0e961863a116 ]

The amp/speakers on the Lenovo Yoga Book 9i 13IRU8 laptop aren't
fully powered up, resulting in horrible tinny sound by default.

The kernel has an existing quirk for PCI SSID 0x17aa3843 which
matches this machine and several others. The quirk applies the
ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP fixup, however the fixup does not
work on this machine.

This patch modifies the existing quirk by adding a check for the
subsystem ID 0x17aa3881. If present, ALC287_FIXUP_TAS2781_I2C will
be applied instead of ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP. With this
change the TAS2781 amp is powered up, firmware is downloaded and
recognised by HDA/SOF - i.e. all is good, and we can boogie.

Code is re-used from alc298_fixup_lenovo_c940_duet7(), which fixes a
similar problem with two other Lenovo laptops.

Cross checked against ALSA cardinfo database for potential clashes.
Tested against 6.18.5 kernel built with Arch Linux default options.
Tested in HDA mode and SOF mode.

Note: Possible further work required to address quality of life issues
caused by the firmware's agressive power saving, and to improve ALSA
control mappings.

Signed-off-by: Martin Hamilton <m@martinh.net>
Link: https://patch.msgid.link/20260122-alc269-yogabook9i-fixup-v1-1-a6883429400f@martinh.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The `alc298_fixup_lenovo_c940_duet7` pattern was introduced in June
2022, making it well-established and available in all active stable
trees.

## Summary

### What the commit fixes:
The Lenovo Yoga Book 9i 13IRU8 laptop has broken audio - "horrible tinny
sound" - because the TAS2781 amplifier isn't being properly initialized.
The machine shares a PCI SSID (0x17aa3843) with other Yoga 9i models,
but needs a different fixup to work correctly.

### Why it matters to stable users:
This is a real-world hardware issue affecting laptop users who have
completely broken speaker audio. The "tinny sound" described means the
speakers are essentially unusable.

### Does it meet stable kernel rules?

1. **Obviously correct**: Yes - follows an identical, proven pattern
   from `alc298_fixup_lenovo_c940_duet7()` that has been in the kernel
   since June 2022
2. **Fixes a real bug**: Yes - "horrible tinny sound" is a significant
   audio bug on production hardware
3. **Fixes an important issue**: Yes - broken speakers on a premium
   laptop significantly impact usability
4. **Small and contained**: Yes - ~25 lines, single file, minimal scope
5. **No new features**: Correct - it routes an existing machine to an
   existing fixup (`ALC287_FIXUP_TAS2781_I2C`)
6. **Applies cleanly**: Should apply cleanly as it only touches quirk
   infrastructure

### Risk vs Benefit:
- **Benefit**: High - fixes broken audio for Yoga Book 9i users
- **Risk**: Very low - the check for subsystem ID 0x17aa3881 ensures
  only the specific machine is affected. Other Yoga 9i models with SSID
  0x17aa3843 will continue to get the existing
  `ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP` fixup

### Dependencies:
- `ALC287_FIXUP_TAS2781_I2C` must exist (added Aug 2023)
- `__snd_hda_apply_fixup()` must exist (established infrastructure)
- The pattern is well-tested from `alc298_fixup_lenovo_c940_duet7()`

### Concerns:
- For older stable trees (6.1.y, 5.15.y), the `ALC287_FIXUP_TAS2781_I2C`
  fixup may not exist, so this patch would only be applicable to 6.6+
  stable trees
- Tested by the author on 6.18.5 in both HDA and SOF modes

This is a textbook example of a hardware quirk/workaround that falls
under the "quirks and workarounds" exception for stable. It fixes broken
hardware using a proven pattern with minimal risk to other systems.

**YES**

 sound/hda/codecs/realtek/alc269.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 57bad9884158c..32cba2c81ccdd 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3674,6 +3674,7 @@ enum {
 	ALC287_FIXUP_LEGION_15IMHG05_AUTOMUTE,
 	ALC287_FIXUP_YOGA7_14ITL_SPEAKERS,
 	ALC298_FIXUP_LENOVO_C940_DUET7,
+	ALC287_FIXUP_LENOVO_YOGA_BOOK_9I,
 	ALC287_FIXUP_13S_GEN2_SPEAKERS,
 	ALC256_FIXUP_SET_COEF_DEFAULTS,
 	ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
@@ -3757,6 +3758,23 @@ static void alc298_fixup_lenovo_c940_duet7(struct hda_codec *codec,
 	__snd_hda_apply_fixup(codec, id, action, 0);
 }
 
+/* A special fixup for Lenovo Yoga 9i and Yoga Book 9i 13IRU8
+ * both have the very same PCI SSID and vendor ID, so we need
+ * to apply different fixups depending on the subsystem ID
+ */
+static void alc287_fixup_lenovo_yoga_book_9i(struct hda_codec *codec,
+					   const struct hda_fixup *fix,
+					   int action)
+{
+	int id;
+
+	if (codec->core.subsystem_id == 0x17aa3881)
+		id = ALC287_FIXUP_TAS2781_I2C; /* Yoga Book 9i 13IRU8 */
+	else
+		id = ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP; /* Yoga 9i */
+	__snd_hda_apply_fixup(codec, id, action, 0);
+}
+
 static const struct hda_fixup alc269_fixups[] = {
 	[ALC269_FIXUP_GPIO2] = {
 		.type = HDA_FIXUP_FUNC,
@@ -5764,6 +5782,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc298_fixup_lenovo_c940_duet7,
 	},
+	[ALC287_FIXUP_LENOVO_YOGA_BOOK_9I] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc287_fixup_lenovo_yoga_book_9i,
+	},
 	[ALC287_FIXUP_13S_GEN2_SPEAKERS] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -7085,7 +7107,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3827, "Ideapad S740", ALC285_FIXUP_IDEAPAD_S740_COEF),
 	SND_PCI_QUIRK(0x17aa, 0x3834, "Lenovo IdeaPad Slim 9i 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x383d, "Legion Y9000X 2019", ALC285_FIXUP_LEGION_Y9000X_SPEAKERS),
-	SND_PCI_QUIRK(0x17aa, 0x3843, "Yoga 9i", ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP),
+	SND_PCI_QUIRK(0x17aa, 0x3843, "Lenovo Yoga 9i / Yoga Book 9i", ALC287_FIXUP_LENOVO_YOGA_BOOK_9I),
 	SND_PCI_QUIRK(0x17aa, 0x3847, "Legion 7 16ACHG6", ALC287_FIXUP_LEGION_16ACHG6),
 	SND_PCI_QUIRK(0x17aa, 0x384a, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
-- 
2.51.0


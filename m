Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714041F4FBC;
	Wed,  6 Nov 2024 12:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897732; cv=none; b=tPS1urz1xdV/FbgEb12VDFNcqFVdLxX8EFDtyEAXjGAm7YgWFOwI0pg0TTmriDZu9Q7KikCZvf6lWgRcs8FQfyZXWB3Jz+eBwPo02916PziCriwhcM3kDo2DMC92nfydJzy+b0BM/IXJVAigElA2m7GD6aNh0D/sfpPd9H5cc3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897732; c=relaxed/simple;
	bh=SuRbsDMMX8NpMK0YgUe7cm6E7YgQg6Zob0mfhkjhJfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwON35tbz5kEoPLxl4I6r4R+n06tJFJhTADl01xIVSn5hZR6MwWVH4P/iTONcGbSMky3mlBw/HCSE3fTuKn9zmwh2nyzczc0R06zBhE3APjf9/VLJ8bpsUIB/ow091Qj6ZGEfhvVa67USi52AZXUD0dvQqUcD/DP0LJY1iiMmek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lNgeU1U+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lNgeU1U+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E995AC4CECD;
	Wed,  6 Nov 2024 12:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897732;
	bh=SuRbsDMMX8NpMK0YgUe7cm6E7YgQg6Zob0mfhkjhJfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lNgeU1U+0SkuXpFbu10k6ONzJZP9kTy6WUynQSejES5g5FE1wsz6ad/0aVjuetq9c
	 2ftA7gppwGVSmEhbSUPl8GPeBIHmtM5pWfXGj/JlgFI0wPO306qCj0s9PrhCSuwFlm
	 PtsRA5ANGU/KuYZ2a66NkZJS8CmPj6ZIQyMwxjDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/151] ALSA: hda/realtek: Limit internal Mic boost on Dell platform
Date: Wed,  6 Nov 2024 13:05:03 +0100
Message-ID: <20241106120312.032143798@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 78e7be018784934081afec77f96d49a2483f9188 ]

Dell want to limit internal Mic boost on all Dell platform.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/561fc5f5eff04b6cbd79ed173cd1c1db@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9be5a5c509f09..bf504744ae2a3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7234,6 +7234,7 @@ enum {
 	ALC286_FIXUP_SONY_MIC_NO_PRESENCE,
 	ALC269_FIXUP_PINCFG_NO_HP_TO_LINEOUT,
 	ALC269_FIXUP_DELL1_MIC_NO_PRESENCE,
+	ALC269_FIXUP_DELL1_LIMIT_INT_MIC_BOOST,
 	ALC269_FIXUP_DELL2_MIC_NO_PRESENCE,
 	ALC269_FIXUP_DELL3_MIC_NO_PRESENCE,
 	ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
@@ -7268,6 +7269,7 @@ enum {
 	ALC255_FIXUP_ACER_MIC_NO_PRESENCE,
 	ALC255_FIXUP_ASUS_MIC_NO_PRESENCE,
 	ALC255_FIXUP_DELL1_MIC_NO_PRESENCE,
+	ALC255_FIXUP_DELL1_LIMIT_INT_MIC_BOOST,
 	ALC255_FIXUP_DELL2_MIC_NO_PRESENCE,
 	ALC255_FIXUP_HEADSET_MODE,
 	ALC255_FIXUP_HEADSET_MODE_NO_HP_MIC,
@@ -7760,6 +7762,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE
 	},
+	[ALC269_FIXUP_DELL1_LIMIT_INT_MIC_BOOST] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc269_fixup_limit_int_mic_boost,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_DELL1_MIC_NO_PRESENCE
+	},
 	[ALC269_FIXUP_DELL2_MIC_NO_PRESENCE] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -8040,6 +8048,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC255_FIXUP_HEADSET_MODE
 	},
+	[ALC255_FIXUP_DELL1_LIMIT_INT_MIC_BOOST] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc269_fixup_limit_int_mic_boost,
+		.chained = true,
+		.chain_id = ALC255_FIXUP_DELL1_MIC_NO_PRESENCE
+	},
 	[ALC255_FIXUP_DELL2_MIC_NO_PRESENCE] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -10482,6 +10496,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC269_FIXUP_DELL2_MIC_NO_PRESENCE, .name = "dell-headset-dock"},
 	{.id = ALC269_FIXUP_DELL3_MIC_NO_PRESENCE, .name = "dell-headset3"},
 	{.id = ALC269_FIXUP_DELL4_MIC_NO_PRESENCE, .name = "dell-headset4"},
+	{.id = ALC269_FIXUP_DELL4_MIC_NO_PRESENCE_QUIET, .name = "dell-headset4-quiet"},
 	{.id = ALC283_FIXUP_CHROME_BOOK, .name = "alc283-dac-wcaps"},
 	{.id = ALC283_FIXUP_SENSE_COMBO_JACK, .name = "alc283-sense-combo"},
 	{.id = ALC292_FIXUP_TPT440_DOCK, .name = "tpt440-dock"},
@@ -11033,16 +11048,16 @@ static const struct snd_hda_pin_quirk alc269_fallback_pin_fixup_tbl[] = {
 	SND_HDA_PIN_QUIRK(0x10ec0289, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
 		{0x19, 0x40000000},
 		{0x1b, 0x40000000}),
-	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
+	SND_HDA_PIN_QUIRK(0x10ec0295, 0x1028, "Dell", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE_QUIET,
 		{0x19, 0x40000000},
 		{0x1b, 0x40000000}),
 	SND_HDA_PIN_QUIRK(0x10ec0256, 0x1028, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE,
 		{0x19, 0x40000000},
 		{0x1a, 0x40000000}),
-	SND_HDA_PIN_QUIRK(0x10ec0236, 0x1028, "Dell", ALC255_FIXUP_DELL1_MIC_NO_PRESENCE,
+	SND_HDA_PIN_QUIRK(0x10ec0236, 0x1028, "Dell", ALC255_FIXUP_DELL1_LIMIT_INT_MIC_BOOST,
 		{0x19, 0x40000000},
 		{0x1a, 0x40000000}),
-	SND_HDA_PIN_QUIRK(0x10ec0274, 0x1028, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB,
+	SND_HDA_PIN_QUIRK(0x10ec0274, 0x1028, "Dell", ALC269_FIXUP_DELL1_LIMIT_INT_MIC_BOOST,
 		{0x19, 0x40000000},
 		{0x1a, 0x40000000}),
 	SND_HDA_PIN_QUIRK(0x10ec0256, 0x1043, "ASUS", ALC2XX_FIXUP_HEADSET_MIC,
-- 
2.43.0




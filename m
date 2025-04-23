Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294982701A0;
	Wed, 23 Apr 2025 14:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419618; cv=none; b=RMk+Kf+h8ncRrdjsahmyUjJYcclhz3Q8Jl9Uv1B2xP9Ux6YRXPt7wtnVln8dFbMT5+wNuoRIL/cMZ60xdzNS/q9DcUUri2TFEbuZHUMan4IaYwdw8m35a9XM2c2SC/+kcbEpV90t2nIsy9TZtcCueU1g2Cp9NAOGWUUUFVj7EF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419618; c=relaxed/simple;
	bh=omZ1saq1fZRA+tf29SH4Eush5isZBZIVkyWoUZxjqxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfBD7ibNj9MqOyv4gq6i719Y85UjoKF8Khm/YbcMlmwvHN+eQNpCGxX2Bu6bX0T5N7BWlMSg5BHk6pEEZezyiFXNDIp3yOS0iCTK37XAwSNOLxeBX345NvZmpJDVryl/U61YRwqa3dpf9dsAVwgG4N4AliDt6RkA15gIDezs6qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKNdRuh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKNdRuh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD266C4CEE2;
	Wed, 23 Apr 2025 14:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419618;
	bh=omZ1saq1fZRA+tf29SH4Eush5isZBZIVkyWoUZxjqxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rKNdRuh23DcJIBhy8h5HwQGMz1Ntu0skw9m8KyBhdAAZC+HqZiS1u4juPbPqFMWjt
	 Itge0Bj+b+qy++ZV+2TT9m/FYBMFSAAeA+1MedO02vym8ARcDcDySBYdho7KDtIwfz
	 UXYC1EmZc1cCqnbvmU6mBtQsPqYCWtXxUPC56e2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/223] ALSA: hda: improve bass speaker support for ASUS Zenbook UM5606WA
Date: Wed, 23 Apr 2025 16:41:34 +0200
Message-ID: <20250423142618.021315495@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Jaroslav Kysela <perex@perex.cz>

[ Upstream commit a7df7f909cec96e2fb7813a9b0b7e06a976983ab ]

This hardware has ALC294 codec with speaker NID 0x17 and bass speaker
NID 0x15.

This patch removes DAC NID 0x06 (without volume control) from
the connection list for bass speaker NID 0x15. Both speaker PINs
are routed to DAC NID 0x03 with this change.

Link: https://github.com/alsa-project/alsa-ucm-conf/issues/467
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Link: https://patch.msgid.link/20241128112145.3409492-1-perex@perex.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: b5458fcabd96 ("ALSA: hda/realtek - Fixed ASUS platform headset Mic issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 0bf833c960215..4ae987731a152 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6603,6 +6603,16 @@ static void alc285_fixup_speaker2_to_dac1(struct hda_codec *codec,
 	}
 }
 
+/* disable DAC3 (0x06) selection on NID 0x15 - share Speaker/Bass Speaker DAC 0x03 */
+static void alc294_fixup_bass_speaker_15(struct hda_codec *codec,
+					 const struct hda_fixup *fix, int action)
+{
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		static const hda_nid_t conn[] = { 0x02, 0x03 };
+		snd_hda_override_conn_list(codec, 0x15, ARRAY_SIZE(conn), conn);
+	}
+}
+
 /* Hook to update amp GPIO4 for automute */
 static void alc280_hp_gpio4_automute_hook(struct hda_codec *codec,
 					  struct hda_jack_callback *jack)
@@ -7888,6 +7898,7 @@ enum {
 	ALC245_FIXUP_CLEVO_NOISY_MIC,
 	ALC269_FIXUP_VAIO_VJFH52_MIC_NO_PRESENCE,
 	ALC233_FIXUP_MEDION_MTL_SPK,
+	ALC294_FIXUP_BASS_SPEAKER_15,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -10222,6 +10233,10 @@ static const struct hda_fixup alc269_fixups[] = {
 			{ }
 		},
 	},
+	[ALC294_FIXUP_BASS_SPEAKER_15] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc294_fixup_bass_speaker_15,
+	},
 };
 
 static const struct hda_quirk alc269_fixup_tbl[] = {
@@ -10750,6 +10765,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1d42, "ASUS Zephyrus G14 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1da2, "ASUS UP6502ZA/ZD", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x1df3, "ASUS UM5606WA", ALC294_FIXUP_BASS_SPEAKER_15),
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402ZA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.39.5




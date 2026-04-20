Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073273DB644;
	Mon, 20 Apr 2026 13:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691447; cv=none; b=DXUvJrpc4p1OLqcqIEYhsdAdqvLsGpNqgpUgfGxFY0KKNyC7rF1wgONO7Uc0kIcFqw1RFOIz2DboNTzYt9CApGAooAxAMr0G36EHCKgM3p0MkuXVrmO1H8R9IWbz5M0HG3Q2ChADelUY/S8iVwPiJSWH1PYPitbzh/ekRo9GUpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691447; c=relaxed/simple;
	bh=xytY17X001U8hg8PP6IHpMXp5Wocpf580anDoKIYbkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anJ03N7ky81nLRpX8W9J6e+uuY4RH96oxCogeBge9vmJx4ZwdtloR3m6wzZxmAfxsOZfXheGQIiD8raCLoyBgU0Gu8c4STtGuwyKdDZGcFJ0/hy091aCBSLaoi5muy+wm40nEMww+1dP8LZ4jJpQDcRa3P/TwjwUDAodPkn0PoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BxgpZaOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BxgpZaOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A54C2BCB6;
	Mon, 20 Apr 2026 13:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691446;
	bh=xytY17X001U8hg8PP6IHpMXp5Wocpf580anDoKIYbkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BxgpZaOE7Aj4nxTGfAcbe4jHFbOtX2Jk0wUItiRKSJAkrdTu1yqitD5dv1Z6Mg5Av
	 ghtspS4VXLVNmtNfeyggvxwvqamjkaGG+0G0+1OlR8mcGD/ZJV2FfZntahyvSmVyUv
	 d+cCBCDR5TRlXePp45GZJbLpKGGbL3KHRJZMsvvntEFbA2qrF7DVTya0WuFOsciwzx
	 BxBCYi4rqHv/rSB/lUCsulSKfPHyQLgowgDTFJ+EsD9ApfKjeQY4zBnvCeQMET37zh
	 xWcRUZzkT9XLipnPFWORNxl3c2PP0DQHiNBMeMb8glNqMD/HtnoaBDRTQqACsR8vXq
	 ZiJTulPINV5vw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Savenko <alex.sav4387@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14IMH9
Date: Mon, 20 Apr 2026 09:17:07 -0400
Message-ID: <20260420132314.1023554-33-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Alexander Savenko <alex.sav4387@gmail.com>

[ Upstream commit 217d5bc9f96272316ac5a3215c7cc32a5127bbf3 ]

The Lenovo Yoga Pro 7 14IMH9 (DMI: 83E2) shares PCI SSID 17aa:3847
with the Legion 7 16ACHG6, but has a different codec subsystem ID
(17aa:38cf). The existing SND_PCI_QUIRK for 17aa:3847 applies
ALC287_FIXUP_LEGION_16ACHG6, which attempts to initialize an external
I2C amplifier (CLSA0100) that is not present on the Yoga Pro 7 14IMH9.

As a result, pin 0x17 (bass speakers) is connected to DAC 0x06 which
has no volume control, making hardware volume adjustment completely
non-functional. Audio is either silent or at maximum volume regardless
of the slider position.

Add a HDA_CODEC_QUIRK entry using the codec subsystem ID (17aa:38cf)
to correctly identify the Yoga Pro 7 14IMH9 and apply
ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN, which redirects pin 0x17 to
DAC 0x02 and restores proper volume control. The existing Legion entry
is preserved unchanged.

This follows the same pattern used for 17aa:386e, where Legion Y9000X
and Yoga Pro 7 14ARP8 share a PCI SSID but are distinguished via
HDA_CODEC_QUIRK.

Link: https://github.com/nomad4tech/lenovo-yoga-pro-7-linux
Tested-by: Alexander Savenko <alex.sav4387@gmail.com>
Signed-off-by: Alexander Savenko <alex.sav4387@gmail.com>
Link: https://patch.msgid.link/20260331082929.44890-1-alex.sav4387@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 sound/hda/codecs/realtek/alc269.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 1c8ee8263ab3a..2e89528e5cec1 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7402,6 +7402,10 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3834, "Lenovo IdeaPad Slim 9i 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x383d, "Legion Y9000X 2019", ALC285_FIXUP_LEGION_Y9000X_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3843, "Lenovo Yoga 9i / Yoga Book 9i", ALC287_FIXUP_LENOVO_YOGA_BOOK_9I),
+	/* Yoga Pro 7 14IMH9 shares PCI SSID 17aa:3847 with Legion 7 16ACHG6;
+	 * use codec SSID to distinguish them
+	 */
+	HDA_CODEC_QUIRK(0x17aa, 0x38cf, "Lenovo Yoga Pro 7 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3847, "Legion 7 16ACHG6", ALC287_FIXUP_LEGION_16ACHG6),
 	SND_PCI_QUIRK(0x17aa, 0x384a, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
-- 
2.53.0


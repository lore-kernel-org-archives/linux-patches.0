Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBB153A3AD;
	Thu, 17 Sep 2026 17:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664673; cv=none; b=Sjb8R54UCd5yW0U7mJ3XY6bRbW9eD9Cmz98rtVGvnQj/HwL1l9xxmiAwRSjrvRCNC0Op4PpMcNUsxVtRv0hsH7H1LIPo2NwqDxfrvLiMB/GZus47dreE2qrG8P1dgQfGMB0mWYz8bXegZyn+6YdhgXRs+o6q6B0Suz4NFlJ21rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664673; c=relaxed/simple;
	bh=2o2UWfPh3C7yx4xDzEJ+/rTolmfnna/y3m/Nk/sJf+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8UpdXKocJ8/FVlBtdnmw2o6ALsQgg9f5tu0OLxLkkLuRh9eXZ6RblrKWtijyM9GPLdSpSV6DDjFxGp+RLKpa6OgewnZriDPHDzMlWGTwV9uB+jwZWY59ObPaWiDOX68Bt1AyHT/WYXMXk8v5givlBfGQZoM5ZhWCf+kNz4UoP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DCb56op; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DCb56op"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE911F000FF;
	Thu, 17 Sep 2026 17:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664672;
	bh=B+tSSNgF9rtZ0fllmNJtJNXaH6pJJ20e6amEBohMNQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1DCb56opUBiVkg/AFhgSk4V9U5Aj6HHZlkUmv710vMzNEQLRFZ5WPf1jSWJ5zFJQp
	 6PFHIl2RzYfOt589s/Xh+1+kFmnabzhx3kqyb1Nqx6+fi7nqvpDyAJhYUhRZqlq2ED
	 XJ5w7yRpMZc62PtTnS83/Ho5DSSeT054rgboLxRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Aherin <chrisaherin@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0450/1250] ALSA: hda/realtek: Add quirk for Lenovo Yoga 7 16IAP7
Date: Thu, 17 Sep 2026 16:04:05 +0100
Message-ID: <20260917151604.192145989@linuxfoundation.org>
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

From: Chris Aherin <chrisaherin@gmail.com>

[ Upstream commit b70f007a9fc665ee988683fd5085ab34e2c10ad3 ]

The Yoga 7 16IAP7 (board LNVNB161216, codec SSID 17aa:386a) has pin
complex 0x17 (bass speakers) wrongly reported as unconnected, causing
only one of four speaker pins (0x14) to be configured and resulting in
mono/tinny audio.

SOF corrupts the PCI subsystem ID to 17aa:0000, preventing SND_PCI_QUIRK
from matching. HDA_CODEC_QUIRK is used instead, which matches against
codec->core.subsystem_id read directly from the HDA codec register and
unaffected by the SOF bug.

Applies ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN, the same fixup used for
the Yoga 7 14IAL7, which corrects pin 0x17's default configuration and
enables both speaker pairs.

Signed-off-by: Chris Aherin <chrisaherin@gmail.com>
Link: https://patch.msgid.link/20260622001210.20553-1-chrisaherin@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 2843171e9c718..fc179a302efb8 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7449,6 +7449,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3865, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3866, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3869, "Lenovo Yoga7 14IAL7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
+	HDA_CODEC_QUIRK(0x17aa, 0x386a, "Lenovo Yoga 7 16IAP7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	HDA_CODEC_QUIRK(0x17aa, 0x386e, "Legion Y9000X 2022 IAH7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x386e, "Yoga Pro 7 14ARP8", ALC285_FIXUP_SPEAKER2_TO_DAC1),
 	HDA_CODEC_QUIRK(0x17aa, 0x38a8, "Legion Pro 7 16ARX8H", ALC287_FIXUP_TAS2781_I2C), /* this must match before PCI SSID 17aa:386f below */
-- 
2.53.0




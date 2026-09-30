Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602253BB138;
	Wed, 30 Sep 2026 18:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794692; cv=none; b=jxRUGjn8RwhIoXxQ8kBOojcO843CsFL9k38CxNzVUglt3rwQ9DR8BUQcibfu32ViH9/EdDe6MQKa0QAVqR5OlXnah2jInkXOIrQEi0uYirJKSn9XYRlinOZVMb21D7d51Pa7oXASzFXEvI8mqyaX5i8/qs1aCNnGaGgWQfIcJD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794692; c=relaxed/simple;
	bh=9eYz54L5f7ZOaGs9a2aN6mBGBvzSxznTp5/hgzqgMMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnO+CyuCDPMYEeBUOpuoK6NToQDBsoywnWJx0CTUO91UweMH7UhcccoLWMnak/ROPRt32Ql8yP/Pck62Kup5IwQGZtNCuwxYxCXGkFAKPZFyLfKRgOgVBBFqM5rKUBOESVC5bQPavzOvRdIqDfoBd8rsV0DvPZHJM3sGFAigtRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eHqwTgUm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eHqwTgUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9F51F000FF;
	Wed, 30 Sep 2026 18:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794691;
	bh=QR3ZRPEobv7F1FpUHNDmxCNIBROnShNv9IorsKJ1zG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eHqwTgUmt72JFXGokV4p1G+59BmZHHpRSSoUTYEfwro/s2J9jbjjGHYdnQJh/dSCy
	 pc2083Y06I7CxSuHlyszhonmfxKKI2gJKOPgG14war3hsB/AaFxTrORWDi3Poasr8u
	 ZiCrFzyRyK4g/O5XnT0uQJcGgeim6GAmCni6Ac54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Bowen <hicbowen@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0300/1193] ALSA: hda/realtek: Fix speakers on MECHREVO WUJIE Series
Date: Wed, 30 Sep 2026 17:16:24 +0200
Message-ID: <20260930152440.819285774@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Bowen <hicbowen@gmail.com>

[ Upstream commit 9064637fb2a80b43105900a47d414997630e5b6b ]

The internal speakers on the MECHREVO WUJIE Series are silent,
while the headphone output works correctly.

The BIOS reports NID 0x1b on the Realtek ALC233 codec as
unconnected with pin configuration 0x411111f0. However, the pin
is connected to an internal speaker.

Overriding NID 0x1b with 0x90170150 makes the HDA generic parser
detect both 0x14 and 0x1b as speaker outputs and restores internal
speaker playback.

Add a pin configuration fixup for the affected PCI SSID c011:1d05.

Tested on a MECHREVO WUJIE Series laptop with board
WUJIE Series-Lark4-LNL and firmware EM_LNL326_V1.0.23.

Signed-off-by: Chen Bowen <hicbowen@gmail.com>
Link: https://patch.msgid.link/20260710133409.16641-1-hicbowen@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 300d78a4d8e58..3a320b9baaa1d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7453,6 +7453,7 @@ enum {
 	ALC275_FIXUP_DELL_XPS,
 	ALC293_FIXUP_LENOVO_SPK_NOISE,
 	ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY,
+	ALC233_FIXUP_WUJIE_SPEAKERS,
 	ALC233_FIXUP_LENOVO_L2MH_LOW_ENLED,
 	ALC255_FIXUP_DELL_SPK_NOISE,
 	ALC225_FIXUP_DISABLE_MIC_VREF,
@@ -7663,6 +7664,13 @@ static void alc287_fixup_lenovo_14irp8_duetitl(struct hda_codec *codec,
 }
 
 static const struct hda_fixup alc269_fixups[] = {
+	[ALC233_FIXUP_WUJIE_SPEAKERS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1b, 0x90170150 }, /* internal speaker */
+			{ }
+		},
+	},
 	[ALC269_FIXUP_GPIO2] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc_fixup_gpio2,
@@ -10674,6 +10682,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
 	SND_PCI_QUIRK(0x8086, 0x3038, "Intel NUC 13", ALC295_FIXUP_CHROME_BOOK),
+	SND_PCI_QUIRK(0xc011, 0x1d05, "MECHREVO WUJIE Series", ALC233_FIXUP_WUJIE_SPEAKERS),
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0006, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
-- 
2.53.0




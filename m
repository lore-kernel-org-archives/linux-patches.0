Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3BA4E0215;
	Thu, 17 Sep 2026 18:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668387; cv=none; b=aq5pEokSuHtPfBQy0ULZsGwdKulxYwocTZyv6FwcQl1/9ynybetTDjUlULhocjiE/s70HBqpk2yo6dOBZ1+TfUyfAhQczIYjhc0/OnH5BTbe/Xk1I/nF6yxSSoRLKFeOmP6z1zKkuJIiHT03j7cR+Q6LOTfamQ4T+EJQUribSr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668387; c=relaxed/simple;
	bh=tLV10EpKEZHFZ6IP1zurz6CJEqcJw7JBBWWMbib8VSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOsKwJAzs/TilYgo6kNS8wgsB96hOfUZQxiNoLY2XE0DD4gq+6FVlkJ3jxtS71df8LGXrpSHDCbD7/h8nsSO2d9BG2dptX5sbiEAXDlQw72gUlSd0i1D2hE210SHpHq8sO9+P9qzVHIUl5lbtLRRh3R514PFzDA/ZSrxAipKUcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oA6NxPTp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oA6NxPTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA911F000FF;
	Thu, 17 Sep 2026 18:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668386;
	bh=3zFpHlgLOyN9QuPruSshYuEK/BcRENc+0PKguU8RE8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oA6NxPTpn67Fwb4RIr40QXR3Ql9hIm04F6lilSm7Zsbxz0Vlnq/VL/RjiEuWuW7qt
	 Wg+S06COL0B4NDOtxmrf5oWOa5ifip5kMt4zJbwpujxjKh1IbE/tGiBLDreyAh26QA
	 jqU+fQX5kz1NGozqJE9uKTGeCmjcL26IG4kiqxuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Bowen <hicbowen@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0406/1102] ALSA: hda/realtek: Fix speakers on MECHREVO WUJIE Series
Date: Thu, 17 Sep 2026 16:05:49 +0100
Message-ID: <20260917151549.855517626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index a03f94a1bcd18..632d52a9aec98 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8046,6 +8046,7 @@ enum {
 	ALC275_FIXUP_DELL_XPS,
 	ALC293_FIXUP_LENOVO_SPK_NOISE,
 	ALC233_FIXUP_LENOVO_LINE2_MIC_HOTKEY,
+	ALC233_FIXUP_WUJIE_SPEAKERS,
 	ALC233_FIXUP_LENOVO_L2MH_LOW_ENLED,
 	ALC255_FIXUP_DELL_SPK_NOISE,
 	ALC225_FIXUP_DISABLE_MIC_VREF,
@@ -8282,6 +8283,13 @@ static void alc287_fixup_lenovo_yoga_book_9i(struct hda_codec *codec,
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
@@ -11676,6 +11684,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
 	SND_PCI_QUIRK(0x8086, 0x3038, "Intel NUC 13", ALC295_FIXUP_CHROME_BOOK),
+	SND_PCI_QUIRK(0xc011, 0x1d05, "MECHREVO WUJIE Series", ALC233_FIXUP_WUJIE_SPEAKERS),
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0006, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
-- 
2.53.0




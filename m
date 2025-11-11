Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FAA31283E;
	Tue, 11 Nov 2025 01:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825248; cv=none; b=rufTkVDYkUxJEr/3KXebFHh1IGUZVMcpkmE9ES9dGo5C/gn8ttVSUJFROL2LJ1nr8lvu7IH5cIpfE3COJxhByNYaeLnDrb3610UCwgNBiTdsKKUfWJ+sF2gPAxz+chr6odkLOeuNK4GThvud7VhfGDLHT50uZ9OdT3uVIFbQHNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825248; c=relaxed/simple;
	bh=aGtSnRgMX+XG6hQduXUQAeAVxulCxhEDhT2GHu25hTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MC9Eiq0veHqKRk9bp31M6zvuNxj06Bbj8xV/MgIUcSUwV8VkCQGd/DtejQXzivOn+fDm+Wz8YXZdPL8es9DDLkINra0p8dSVKfiIhdurZREk8eqakjDWb19xErXLD55mFzA4TR70bJQze6QnKpVgySnLDEeGvhiVnwJennRhZxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrJot2yf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrJot2yf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5562C116B1;
	Tue, 11 Nov 2025 01:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825248;
	bh=aGtSnRgMX+XG6hQduXUQAeAVxulCxhEDhT2GHu25hTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrJot2yfyVE9gQziLpaet2RIQvzQbKYolyqHxP34r+E034th2nsOcXRUAxGD3+2tV
	 RnT8nNfAwpCRLOd2kjFSsrCPLF8AbiP0y+gIFbxWHSMprghoTGT0xuybm3ikDDnQ3g
	 8jSD70pBjNd4sk30GmlDNDffrqyveqpkbtrAkDxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Holliday <dochollidayxx@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 724/849] ALSA: hda/realtek: Add quirk for ASUS ROG Zephyrus Duo
Date: Tue, 11 Nov 2025 09:44:54 +0900
Message-ID: <20251111004553.937558346@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Holliday <dochollidayxx@gmail.com>

[ Upstream commit 328b80b29a6a165c47fcc04d2bef3e09ed1d28f9 ]

The ASUS ROG Zephyrus Duo 15 SE (GX551QS) with ALC 289 codec requires specific
pin configuration for proper volume control. Without this quirk, volume
adjustments produce a muffled sound effect as only certain channels attenuate,
leaving bass frequency at full volume.

Testing with hdajackretask confirms these pin tweaks fix the issue:
- Pin 0x17: Internal Speaker (LFE)
- Pin 0x1e: Internal Speaker

Signed-off-by: Adam Holliday <dochollidayxx@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 8fb1a5c6ff6df..28297e936a96f 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3737,6 +3737,7 @@ enum {
 	ALC285_FIXUP_ASUS_GA605K_HEADSET_MIC,
 	ALC285_FIXUP_ASUS_GA605K_I2C_SPEAKER2_TO_DAC1,
 	ALC269_FIXUP_POSITIVO_P15X_HEADSET_MIC,
+	ALC289_FIXUP_ASUS_ZEPHYRUS_DUAL_SPK,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -6166,6 +6167,14 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269VC_FIXUP_ACER_MIC_NO_PRESENCE,
 	},
+	[ALC289_FIXUP_ASUS_ZEPHYRUS_DUAL_SPK] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x17, 0x90170151 }, /* Internal Speaker LFE */
+			{ 0x1e, 0x90170150 }, /* Internal Speaker */
+			{ }
+		},
+	}
 };
 
 static const struct hda_quirk alc269_fixup_tbl[] = {
@@ -6721,6 +6730,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
 	SND_PCI_QUIRK(0x1043, 0x1533, "ASUS GV302XA/XJ/XQ/XU/XV/XI", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1573, "ASUS GZ301VV/VQ/VU/VJ/VA/VC/VE/VVC/VQC/VUC/VJC/VEC/VCC", ALC285_FIXUP_ASUS_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1652, "ASUS ROG Zephyrus Do 15 SE", ALC289_FIXUP_ASUS_ZEPHYRUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1663, "ASUS GU603ZI/ZJ/ZQ/ZU/ZV", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1683, "ASUS UM3402YAR", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.51.0




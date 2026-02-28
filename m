Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17C33314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301206; cv=none; b=S4PU7vgAOi/1X4o+zCdmqoFIosg+pfCwzS5Vj/UdZEIm6w9BPj+B89UW8Ov5aTbAgJROadkWhNBdD2y6qa2s8RdOyr+K+JPpqYpAUQSmdDDcxrz/m5agX2xYdqp1FOZOG49w5v01U5Fi1jyQo06fWvZiWRd9dn7A+9shdcZHvdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301206; c=relaxed/simple;
	bh=kjpBHVIpNxPDBLfrYEEWIxLW44fhYCnF/R/UZyOQ6Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lj1nUibwAKjaFm8zCB9KQptRBUJuCmL3ggJCqIXJUbJ+N3/tg0tR20Y3KlIA00gWGDbgDrMe/p9ih7zYZkm9pYjsgvc0Z5jpmr9890RkEbQnKLU/q1/qN8GAGIouWDd+cLxxNM72DCtL9afXT23qVJSGbizjfvglDPk9Mw0BDzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U7cO0RqQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U7cO0RqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A9FC19423;
	Sat, 28 Feb 2026 17:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301206;
	bh=kjpBHVIpNxPDBLfrYEEWIxLW44fhYCnF/R/UZyOQ6Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U7cO0RqQH69Nc0pe8cuDlAlUE7Egwb2Km714L9Jwsi54TdLCUpXMd+WtAfa+2RF0n
	 HSo5uTrd8aybcmg7TLWUeDWQ5l7bWgSqlg64F8O9kI9r7CYZW277zQ+SPO+LpWmXJT
	 WoewifCfJKNKPgPDJiJNPEJtMVfPQeTMLy38z7TSrpzFbqS2HsIwmWZPgJYAmaqU6+
	 TgK4abZodPEdO8omZ5v44vxWjxY45h+/en06YvNE5Q59c4MG2HQXv8yShTbUNiKxyG
	 +Y2/GFWXFmNbDvlbZPUwS7/kKM7uFkgJinWnX7SpDO+anIfrkRh2YtUv//wd2dEtpe
	 wFhGD2wOYrCaQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Erik Sanjaya <sirreidlos@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 380/752] ALSA: hda/realtek: Fix headset mic on ASUS Zenbook 14 UX3405MA
Date: Sat, 28 Feb 2026 12:41:31 -0500
Message-ID: <20260228174750.1542406-380-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Erik Sanjaya <sirreidlos@gmail.com>

[ Upstream commit 91062e119b4eafde553c894ca072cd615a6dae2e ]

The ASUS Zenbook 14 UX3405MA uses an ALC294 codec with CS35L41
amplifiers over SPI. The existing quirk for this model only configured
the amplifiers, leaving the headset microphone on the combo jack
non-functional.

Introduce a new fixup that configures pin 0x19 as headset mic input
and chains to ALC245_FIXUP_CS35L41_SPI_2 to preserve speaker
functionality.

Similar to the fix done for the UM3406HA in commit 018f659753fd
("ALSA: hda/realtek: Fix headset mic on ASUS Zenbook 14").

Signed-off-by: Erik Sanjaya <sirreidlos@gmail.com>
Link: https://patch.msgid.link/20260217102112.20651-1-sirreidlos@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 553ffed048ea7..6d3d464f1f6c6 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3777,6 +3777,7 @@ enum {
 	ALC294_FIXUP_ASUS_MIC,
 	ALC294_FIXUP_ASUS_HEADSET_MIC,
 	ALC294_FIXUP_ASUS_I2C_HEADSET_MIC,
+	ALC294_FIXUP_ASUS_SPI_HEADSET_MIC,
 	ALC294_FIXUP_ASUS_SPK,
 	ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
 	ALC285_FIXUP_LENOVO_PC_BEEP_IN_NOISE,
@@ -5121,6 +5122,15 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC287_FIXUP_CS35L41_I2C_2
 	},
+	[ALC294_FIXUP_ASUS_SPI_HEADSET_MIC] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x19, 0x04a11020 }, /* use as headset mic */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC245_FIXUP_CS35L41_SPI_2
+	},
 	[ALC294_FIXUP_ASUS_SPK] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -7027,7 +7037,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x19ce, "ASUS B9450FA", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19e1, "ASUS UX581LV", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1a13, "Asus G73Jw", ALC269_FIXUP_ASUS_G73JW),
-	SND_PCI_QUIRK(0x1043, 0x1a63, "ASUS UX3405MA", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x1a63, "ASUS UX3405MA", ALC294_FIXUP_ASUS_SPI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1a83, "ASUS UM5302LA", ALC294_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1a8e, "ASUS G712LWS", ALC294_FIXUP_LENOVO_MIC_LOCATION),
 	SND_PCI_QUIRK(0x1043, 0x1a8f, "ASUS UX582ZS", ALC245_FIXUP_CS35L41_SPI_2),
-- 
2.51.0


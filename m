Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846D84F648A;
	Wed, 30 Sep 2026 15:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782701; cv=none; b=rqK1bqVU4veUgflATkj3r/JCUmCVRd3jc7N/VlBzxgXdnr83PH/RYYHBDy7JypSaH4TU0BewaFuGQWg9I+tfFZS6X87BvhDbM+AbIbOwQru5ywbuhTT3O6z1wcSai5GHjnLkp0rATSwBzOUZepNhZM8WvY2ohHhJ7IoPSxrPI68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782701; c=relaxed/simple;
	bh=wzBluChLDI9USRr1B8A49a7DsaXx+tn1wKOe+WTHn1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGyOBwq13ViKnX9ka6e+CGHaFjYHEfZisGYZtGsA+v6gnUChGs1ucO44EWjGVE4gazFuoD9XycehiIBDq/I5qP4t6ws/3HMXYe4tstfVbAgV2R7/nya5nypxf1otWzUH6bCuGsr4TUtARJp/78EhGNw95/7uKI4eMGU7LYnif9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKrd5h4z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKrd5h4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BEA1F0089A;
	Wed, 30 Sep 2026 15:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782683;
	bh=T6eG6neEhqfrlNvCncuLWU0mafWWSTCwavjfATSkw+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cKrd5h4zdglsRhJf6S2ewl+MIIxd9oY2UaQUanj8ydjIamdghBApnSiBpIWRP94LU
	 THn1bssraTMYVC8okH4krf9w7u5EQCg7IJrQ2gq/x0xHwOEtF56FqjE+IXJDzBGAvn
	 Wo8JysR8SdV+xz1vJZsSkI4Ap1l8A6P8BuNaRU/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Galen Hassen <rwekyes@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/595] ALSA: hda/conexant: Add pin config quirk for Lenovo IdeaPad Slim 5 16AKP10
Date: Wed, 30 Sep 2026 17:20:26 +0200
Message-ID: <20260930152350.597603902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Galen Hassen <rwekyes@gmail.com>

[ Upstream commit f7c4968ae3af3e819428da5416c2dfd361473f5c ]

The Lenovo IdeaPad Slim 5 16AKP10 (PCI SSID 17aa:38b6) uses the
Conexant SN6140 codec. The internal microphone is on pin 0x1a but
the BIOS configures it with pin default 0x95a60120, which includes
a jack detection bit that causes the kernel to treat it as an
unplugged external mic rather than a fixed internal mic.

Add a pin config quirk that overrides pin 0x1a to 0x95a60130,
setting the connectivity bits to indicate a fixed/always-connected
device. This allows the internal microphone to be correctly
identified and used.

Signed-off-by: Galen Hassen <rwekyes@gmail.com>
Link: https://patch.msgid.link/20260616173257.37373-1-rwekyes@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 4d0bd1903ccbd..6a7fcb4c77dda 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -237,6 +237,7 @@ enum {
 	CXT_FIXUP_HEADSET_MIC,
 	CXT_FIXUP_HP_MIC_NO_PRESENCE,
 	CXT_PINCFG_SWS_JS201D,
+	CXT_PINCFG_LENOVO_IDEAPAD_SLIM5_16AKP10,
 	CXT_PINCFG_TOP_SPEAKER,
 	CXT_FIXUP_HP_A_U,
 	CXT_FIXUP_ACER_SWIFT_HP,
@@ -771,6 +772,12 @@ static const struct hda_pintbl cxt_pincfg_lemote[] = {
 	{}
 };
 
+/* Lenovo IdeaPad Slim 5 16AKP10 with SN6140 */
+static const struct hda_pintbl cxt_pincfg_lenovo_ideapad_slim5_16akp10[] = {
+	{ 0x1a, 0x95a60130 }, /* Internal mic, fixed/always-connected */
+	{}
+};
+
 /* SuoWoSi/South-holding JS201D with sn6140 */
 static const struct hda_pintbl cxt_pincfg_sws_js201d[] = {
 	{ 0x16, 0x03211040 }, /* hp out */
@@ -962,6 +969,10 @@ static const struct hda_fixup cxt_fixups[] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = cxt_pincfg_sws_js201d,
 	},
+	[CXT_PINCFG_LENOVO_IDEAPAD_SLIM5_16AKP10] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = cxt_pincfg_lenovo_ideapad_slim5_16akp10,
+	},
 	[CXT_PINCFG_TOP_SPEAKER] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cxt_fixup_sirius_top_speaker,
@@ -1067,6 +1078,7 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x17aa, 0x21da, "Lenovo X220", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x21db, "Lenovo X220-tablet", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo IdeaPad Z560", CXT_FIXUP_MUTE_LED_EAPD),
+	SND_PCI_QUIRK(0x17aa, 0x38b6, "Lenovo IdeaPad Slim 5 16AKP10", CXT_PINCFG_LENOVO_IDEAPAD_SLIM5_16AKP10),
 	SND_PCI_QUIRK(0x17aa, 0x3905, "Lenovo G50-30", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x390b, "Lenovo G50-80", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C443133987;
	Tue, 20 Feb 2024 21:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463119; cv=none; b=Q2AhwiISBi9Id7ADbUzH6uSm7e2Q0UzEzueDHQLgN17yuYIdmyYL+53eT7efPpC45SLMItO712F9HdlDuO+/Ko24BwYVM1T6+m/V8iki7BNM8NSANhB1PXKeTMoI1Wk1oUnmDKpv3eN5M2eTHa++iOgEMhUbveseUI5lUi7aC9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463119; c=relaxed/simple;
	bh=t7YAM4s1964nfOC+vY6PSvtfGcViS6NBJ8i77WAQUus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDTdzkjUa6kiaDpMqfQ4ugs8KxyAvP7biqjicFx3qVZZGhteyDy4SvYXt+uRgapM+9TBpwPGGoYj4YTFPGj1AXOrqOG6bTe2I6qr+fx7NCZ+0uTLd1HMFuPEwR7EtT07cmmkUQLR+jM2dI8NhNc/o/mmLKG5pFzOEHP11i4rw7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgz0nmUa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgz0nmUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6674C433C7;
	Tue, 20 Feb 2024 21:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463119;
	bh=t7YAM4s1964nfOC+vY6PSvtfGcViS6NBJ8i77WAQUus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgz0nmUaf/li2cjPOPaSu2ztfXElGSBjZJiH+XulUNqJT3wO4qqE5p/0j5fcF7b9d
	 NsuUF2Wcz//TxCQVmD+WUyEZaqGPWMdsuGjxXb0YsvEdddpCH2Ozm+AXaLCV/wvfrY
	 gcfPQD3T4BfNNO2Wb4vq/jXMEV/i78EXvszNoFME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bo liu <bo.liu@senarytech.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 134/197] ALSA: hda/conexant: Add quirk for SWS JS201D
Date: Tue, 20 Feb 2024 21:51:33 +0100
Message-ID: <20240220204845.082730008@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bo liu <bo.liu@senarytech.com>

commit 4639c5021029d49fd2f97fa8d74731f167f98919 upstream.

The SWS JS201D need a different pinconfig from windows driver.
Add a quirk to use a specific pinconfig to SWS JS201D.

Signed-off-by: bo liu <bo.liu@senarytech.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240205013802.51907-1-bo.liu@senarytech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -344,6 +344,7 @@ enum {
 	CXT_FIXUP_HP_ZBOOK_MUTE_LED,
 	CXT_FIXUP_HEADSET_MIC,
 	CXT_FIXUP_HP_MIC_NO_PRESENCE,
+	CXT_PINCFG_SWS_JS201D,
 };
 
 /* for hda_fixup_thinkpad_acpi() */
@@ -841,6 +842,17 @@ static const struct hda_pintbl cxt_pincf
 	{}
 };
 
+/* SuoWoSi/South-holding JS201D with sn6140 */
+static const struct hda_pintbl cxt_pincfg_sws_js201d[] = {
+	{ 0x16, 0x03211040 }, /* hp out */
+	{ 0x17, 0x91170110 }, /* SPK/Class_D */
+	{ 0x18, 0x95a70130 }, /* Internal mic */
+	{ 0x19, 0x03a11020 }, /* Headset Mic */
+	{ 0x1a, 0x40f001f0 }, /* Not used */
+	{ 0x21, 0x40f001f0 }, /* Not used */
+	{}
+};
+
 static const struct hda_fixup cxt_fixups[] = {
 	[CXT_PINCFG_LENOVO_X200] = {
 		.type = HDA_FIXUP_PINS,
@@ -996,6 +1008,10 @@ static const struct hda_fixup cxt_fixups
 		.chained = true,
 		.chain_id = CXT_FIXUP_HEADSET_MIC,
 	},
+	[CXT_PINCFG_SWS_JS201D] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = cxt_pincfg_sws_js201d,
+	},
 };
 
 static const struct snd_pci_quirk cxt5045_fixups[] = {
@@ -1069,6 +1085,7 @@ static const struct snd_pci_quirk cxt506
 	SND_PCI_QUIRK(0x103c, 0x8457, "HP Z2 G4 mini", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x8458, "HP Z2 G4 mini premium", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x138d, "Asus", CXT_FIXUP_HEADPHONE_MIC_PIN),
+	SND_PCI_QUIRK(0x14f1, 0x0265, "SWS JS201D", CXT_PINCFG_SWS_JS201D),
 	SND_PCI_QUIRK(0x152d, 0x0833, "OLPC XO-1.5", CXT_FIXUP_OLPC_XO),
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Lenovo T400", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x215e, "Lenovo T410", CXT_PINCFG_LENOVO_TP410),
@@ -1109,6 +1126,7 @@ static const struct hda_model_fixup cxt5
 	{ .id = CXT_FIXUP_HP_ZBOOK_MUTE_LED, .name = "hp-zbook-mute-led" },
 	{ .id = CXT_FIXUP_HP_MIC_NO_PRESENCE, .name = "hp-mic-fix" },
 	{ .id = CXT_PINCFG_LENOVO_NOTEBOOK, .name = "lenovo-20149" },
+	{ .id = CXT_PINCFG_SWS_JS201D, .name = "sws-js201d" },
 	{}
 };
 



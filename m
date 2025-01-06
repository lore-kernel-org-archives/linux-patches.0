Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA652AF06;
	Mon,  6 Jan 2025 15:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178747; cv=none; b=d6LAP0z2F6PO3K3vdvHddgM8N+IL+TDpfk4UvtdlWWsrxxRcpfSdDExlRaPHmFIqW42kTb12rY6Dv1EgWcbZP1ynHg9sBIs2YuMN7g4sHkLGirne5veuS9R2xv/fpz6+8Tt5uraDwIdAfpM0qBTPqLi9QpwbAPYBUh9nqSOUFj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178747; c=relaxed/simple;
	bh=7mfIxkNqBAz9J8Kv1zWlKeeFsNKLen7CCi+enO33U78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIGeTEdEVE/XKqOytoRhL1T3bTT+M1sJn2sWg8YfNeiwkTjMLQuEVxb4EVKi4iLYQovgQjuktrgVO22fTsHQADWnoDB7KEqze+ZC1M7mc/s6YVEioTzBrIgO7KJKSTMSJ8vN8sbnGWtWHlgR7ldMq8i/2losvDz1np54hQ2L0hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/O6CDYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/O6CDYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96986C4CED2;
	Mon,  6 Jan 2025 15:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178747;
	bh=7mfIxkNqBAz9J8Kv1zWlKeeFsNKLen7CCi+enO33U78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/O6CDYQC6bWC6RVJReRuoPaTVTyu+5LcNRNCH2nBabrJJkriUmCMdDq9GHIYTv1K
	 xokf15FaBZD/XnKQIa02Cc47CeuMuH0Vx+ZxBYXsDt4qonwz6JyuezdfxYVWRXh825
	 +DgZ6xEXu9zo03kj3+5YiX1P//x+HQC9I9B3kgQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bo liu <bo.liu@senarytech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 079/168] ALSA: hda/conexant: fix Z60MR100 startup pop issue
Date: Mon,  6 Jan 2025 16:16:27 +0100
Message-ID: <20250106151141.449193873@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bo liu <bo.liu@senarytech.com>

[ Upstream commit 947c4012f8f03a8bb946beb6e5294d5e32817d67 ]

When Z60MR100 startup, speaker will output a pop. To fix this issue,
we mute codec by init verbs in bios when system startup, and set GPIO
to low to unmute codec in codec driver when it loaded .

[ white space fixes and compile warning fix by tiwai ]

Signed-off-by: bo liu <bo.liu@senarytech.com>
Link: https://patch.msgid.link/20241129014441.437205-1-bo.liu@senarytech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 8bc0dce59263..520144df0174 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -311,6 +311,7 @@ enum {
 	CXT_FIXUP_HP_MIC_NO_PRESENCE,
 	CXT_PINCFG_SWS_JS201D,
 	CXT_PINCFG_TOP_SPEAKER,
+	CXT_FIXUP_HP_A_U,
 };
 
 /* for hda_fixup_thinkpad_acpi() */
@@ -778,6 +779,18 @@ static void cxt_setup_mute_led(struct hda_codec *codec,
 	}
 }
 
+static void cxt_setup_gpio_unmute(struct hda_codec *codec,
+				  unsigned int gpio_mute_mask)
+{
+	if (gpio_mute_mask) {
+		// set gpio data to 0.
+		snd_hda_codec_write(codec, 0x01, 0, AC_VERB_SET_GPIO_DATA, 0);
+		snd_hda_codec_write(codec, 0x01, 0, AC_VERB_SET_GPIO_MASK, gpio_mute_mask);
+		snd_hda_codec_write(codec, 0x01, 0, AC_VERB_SET_GPIO_DIRECTION, gpio_mute_mask);
+		snd_hda_codec_write(codec, 0x01, 0, AC_VERB_SET_GPIO_STICKY_MASK, 0);
+	}
+}
+
 static void cxt_fixup_mute_led_gpio(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)
 {
@@ -792,6 +805,15 @@ static void cxt_fixup_hp_zbook_mute_led(struct hda_codec *codec,
 		cxt_setup_mute_led(codec, 0x10, 0x20);
 }
 
+static void cxt_fixup_hp_a_u(struct hda_codec *codec,
+			     const struct hda_fixup *fix, int action)
+{
+	// Init vers in BIOS mute the spk/hp by set gpio high to avoid pop noise,
+	// so need to unmute once by clearing the gpio data when runs into the system.
+	if (action == HDA_FIXUP_ACT_INIT)
+		cxt_setup_gpio_unmute(codec, 0x2);
+}
+
 /* ThinkPad X200 & co with cxt5051 */
 static const struct hda_pintbl cxt_pincfg_lenovo_x200[] = {
 	{ 0x16, 0x042140ff }, /* HP (seq# overridden) */
@@ -1016,6 +1038,10 @@ static const struct hda_fixup cxt_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cxt_fixup_sirius_top_speaker,
 	},
+	[CXT_FIXUP_HP_A_U] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cxt_fixup_hp_a_u,
+	},
 };
 
 static const struct snd_pci_quirk cxt5045_fixups[] = {
@@ -1090,6 +1116,7 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x103c, 0x8457, "HP Z2 G4 mini", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x8458, "HP Z2 G4 mini premium", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x138d, "Asus", CXT_FIXUP_HEADPHONE_MIC_PIN),
+	SND_PCI_QUIRK(0x14f1, 0x0252, "MBX-Z60MR100", CXT_FIXUP_HP_A_U),
 	SND_PCI_QUIRK(0x14f1, 0x0265, "SWS JS201D", CXT_PINCFG_SWS_JS201D),
 	SND_PCI_QUIRK(0x152d, 0x0833, "OLPC XO-1.5", CXT_FIXUP_OLPC_XO),
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Lenovo T400", CXT_PINCFG_LENOVO_TP410),
@@ -1135,6 +1162,7 @@ static const struct hda_model_fixup cxt5066_fixup_models[] = {
 	{ .id = CXT_PINCFG_LENOVO_NOTEBOOK, .name = "lenovo-20149" },
 	{ .id = CXT_PINCFG_SWS_JS201D, .name = "sws-js201d" },
 	{ .id = CXT_PINCFG_TOP_SPEAKER, .name = "sirius-top-speaker" },
+	{ .id = CXT_FIXUP_HP_A_U, .name = "HP-U-support" },
 	{}
 };
 
-- 
2.39.5




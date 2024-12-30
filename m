Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6437815E8B;
	Mon, 30 Dec 2024 15:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573798; cv=none; b=efddrWws3WhRXQA5cFfc114CbJyLHkQ3qp67I5u+A1+T/n3BY/5jgQxolnj4WUiyqH9gBH7vA0ludQUAA3iOTmZCtZ7Jc/8TpLUx38EDBVZt6/NRuAdSCKcOy0oiEHJ3dn+YnJQCaw0MwtbbGPV2bjphQ5kQL4gbvNE6vs9l5ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573798; c=relaxed/simple;
	bh=MSH0TEbPTISKpHsC9+7OBgEfzJrQazKVDJ/X5pOjugc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqmxB1Iz7GCYEQdtdbZfKGoweEFuSPHOyIqdxYFjQZyTUXJBxJtAdfTJpaU97EyUhpS9on+JH7lXc9tdDjuvGpmnb9GzaS+95iaOxDT5TNe2KYWuaW+cF5CT3isbyP8q11+LoQZCJ20fN472iCdvSp6qd/0qficDEfAw1Oguo5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1+kcIey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1+kcIey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62E2C4CED0;
	Mon, 30 Dec 2024 15:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573798;
	bh=MSH0TEbPTISKpHsC9+7OBgEfzJrQazKVDJ/X5pOjugc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1+kcIeyZHIGJc6LkMfZ/qkaS4D13N9Pet0DCrEAcuIefdg3hfihMph30qypZg7up
	 MgcYvshHHjjqUF6RA8rS4zltCulkjQ+OV4Bvk04byoitqBmcywByW5w0DwtmlMEyHm
	 pdR8QKreks/1I7k/uvocjRZyDgmc2SYfqCh6CLPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bo liu <bo.liu@senarytech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 37/86] ALSA: hda/conexant: fix Z60MR100 startup pop issue
Date: Mon, 30 Dec 2024 16:42:45 +0100
Message-ID: <20241230154213.129338097@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b3208b068dd8..989ce0fb6291 100644
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
@@ -1002,6 +1024,10 @@ static const struct hda_fixup cxt_fixups[] = {
 			{ }
 		},
 	},
+	[CXT_FIXUP_HP_A_U] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cxt_fixup_hp_a_u,
+	},
 };
 
 static const struct hda_quirk cxt5045_fixups[] = {
@@ -1076,6 +1102,7 @@ static const struct hda_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x103c, 0x8457, "HP Z2 G4 mini", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x8458, "HP Z2 G4 mini premium", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x138d, "Asus", CXT_FIXUP_HEADPHONE_MIC_PIN),
+	SND_PCI_QUIRK(0x14f1, 0x0252, "MBX-Z60MR100", CXT_FIXUP_HP_A_U),
 	SND_PCI_QUIRK(0x14f1, 0x0265, "SWS JS201D", CXT_PINCFG_SWS_JS201D),
 	SND_PCI_QUIRK(0x152d, 0x0833, "OLPC XO-1.5", CXT_FIXUP_OLPC_XO),
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Lenovo T400", CXT_PINCFG_LENOVO_TP410),
@@ -1121,6 +1148,7 @@ static const struct hda_model_fixup cxt5066_fixup_models[] = {
 	{ .id = CXT_PINCFG_LENOVO_NOTEBOOK, .name = "lenovo-20149" },
 	{ .id = CXT_PINCFG_SWS_JS201D, .name = "sws-js201d" },
 	{ .id = CXT_PINCFG_TOP_SPEAKER, .name = "sirius-top-speaker" },
+	{ .id = CXT_FIXUP_HP_A_U, .name = "HP-U-support" },
 	{}
 };
 
-- 
2.39.5




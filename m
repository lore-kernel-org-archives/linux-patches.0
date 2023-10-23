Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A3614AB9
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8BORvkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1CBC433C7;
	Mon, 23 Oct 2023 11:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060037;
	bh=9RHwx6c4IC8v85ijmD9fUjOfH+Uq8uCKlrm00Sr6Yf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8BORvkb2B18ip8FErCynKqLKamjxJ2/3HYVSQNKI9lzBek7Ihza1HrLAUzqokowR
	 Qe0eC3dheHKx64TORAGrkWf4GmRW5pWehKwHKtofrDnwP/TY3G/tbsldXYnf7qY8p1
	 4A3cvGJyTxZMcG/l76MlzjBqEkALopdYDSPkRm/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 038/196] ALSA: hda/realtek - Fixed ASUS platform headset Mic issue
Date: Mon, 23 Oct 2023 12:55:03 +0200
Message-ID: <20231023104829.565919496@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

From: Kailang Yang <kailang@realtek.com>

commit c8c0a03ec1be6b3f3ec1ce91685351235212db19 upstream.

ASUS platform Headset Mic was disable by default.
Assigned verb table for Mic pin will enable it.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1155d914c20c40569f56d36c79254879@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7006,6 +7006,24 @@ static void alc287_fixup_bind_dacs(struc
 					0x0); /* Make sure 0x14 was disable */
 	}
 }
+/* Fix none verb table of Headset Mic pin */
+static void alc_fixup_headset_mic(struct hda_codec *codec,
+				   const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+	static const struct hda_pintbl pincfgs[] = {
+		{ 0x19, 0x03a1103c },
+		{ }
+	};
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		snd_hda_apply_pincfgs(codec, pincfgs);
+		alc_update_coef_idx(codec, 0x45, 0xf<<12 | 1<<10, 5<<12);
+		spec->parse_flags |= HDA_PINCFG_HEADSET_MIC;
+		break;
+	}
+}
 
 
 enum {
@@ -7270,6 +7288,7 @@ enum {
 	ALC245_FIXUP_HP_X360_MUTE_LEDS,
 	ALC287_FIXUP_THINKPAD_I2S_SPK,
 	ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD,
+	ALC2XX_FIXUP_HEADSET_MIC,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -9359,6 +9378,10 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC287_FIXUP_CS35L41_I2C_2_THINKPAD_ACPI,
 	},
+	[ALC2XX_FIXUP_HEADSET_MIC] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc_fixup_headset_mic,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -10633,6 +10656,8 @@ static const struct snd_hda_pin_quirk al
 	SND_HDA_PIN_QUIRK(0x10ec0274, 0x1028, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB,
 		{0x19, 0x40000000},
 		{0x1a, 0x40000000}),
+	SND_HDA_PIN_QUIRK(0x10ec0256, 0x1043, "ASUS", ALC2XX_FIXUP_HEADSET_MIC,
+		{0x19, 0x40000000}),
 	{}
 };
 



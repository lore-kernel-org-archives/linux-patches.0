Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0D814A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jtlx/z9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA69AC433C8;
	Mon, 23 Oct 2023 11:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059038;
	bh=WVTRM7w9F8/jz7xnpCj6WPms8Y/KBTboj3j/xkVxr1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jtlx/z9ZcFjyNX0ILMhaT5uaIiQoLGwAr6zwUeRkYykyO7nm3mFLdweMCXM/xEXLq
	 /bsbLy0N8HRIVqPJFqOFfX7yQf4xdQlt+lpcTEg2T84qkuElpC5FCLkkXH9vS1UI8K
	 J6EMRdHMfB9NyInyvtQ3Ym54TiNUJTa6/msJO2o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.5 043/241] ALSA: hda/realtek - Fixed ASUS platform headset Mic issue
Date: Mon, 23 Oct 2023 12:53:49 +0200
Message-ID: <20231023104834.967128753@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7009,6 +7009,24 @@ static void alc287_fixup_bind_dacs(struc
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
@@ -7274,6 +7292,7 @@ enum {
 	ALC245_FIXUP_HP_X360_MUTE_LEDS,
 	ALC287_FIXUP_THINKPAD_I2S_SPK,
 	ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD,
+	ALC2XX_FIXUP_HEADSET_MIC,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -9372,6 +9391,10 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC287_FIXUP_CS35L41_I2C_2_THINKPAD_ACPI,
 	},
+	[ALC2XX_FIXUP_HEADSET_MIC] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc_fixup_headset_mic,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -10656,6 +10679,8 @@ static const struct snd_hda_pin_quirk al
 	SND_HDA_PIN_QUIRK(0x10ec0274, 0x1028, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB,
 		{0x19, 0x40000000},
 		{0x1a, 0x40000000}),
+	SND_HDA_PIN_QUIRK(0x10ec0256, 0x1043, "ASUS", ALC2XX_FIXUP_HEADSET_MIC,
+		{0x19, 0x40000000}),
 	{}
 };
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE11269894;
	Tue,  8 Apr 2025 11:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110163; cv=none; b=oYIa1wzOpDguI+O9TuuH67qx/HzQkLyrAadNFKyA3x7vWxI5BOuUlJyDZflTTqQYGZrdgu+v5uJb0FIYTz7m1nkYNWc6VolEI/OU/KtKsugLY5Bdy8pE4dMQ+eNI87qg82fnTO1c+2Ht4wLlt6V3UtqRFOmE527xe2MTehIT4wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110163; c=relaxed/simple;
	bh=MQvTsYE7GsaVEWZTZa1YvHHlpYHpyHlsbWQbSvr5Tzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0iP2NYbNBCWP2o6mjrBxQZsUuh3tDm5qZy/g52iZ3PnPgfo2V92X2hYsQn61Nx3TEWkBduOEptyfJgrPMQsl2u29gIbjZlY/6sq3V12JpTTPL4KjVIp0O2XSQ8Dtxslqd7eMgCoftfLwuIitF/xIlbIYMk6mhDeGmUEXOUTlmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EM1AWZqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EM1AWZqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDC7C4CEE5;
	Tue,  8 Apr 2025 11:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110161;
	bh=MQvTsYE7GsaVEWZTZa1YvHHlpYHpyHlsbWQbSvr5Tzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EM1AWZqdI4ynTuI/0BbE2A69f3k1FDxH1L6jCmkbyBaVfz2BxFR6Q5SiqKDo/kY5m
	 SSLw8tI5UrLHUiKiD8ykdou3w57ct+N9rlGkbo9VdBINEFWgJ+cS+GebcANGWY4j7F
	 HaIYBImgtnyAcF8UnnZVAUFaNeGJtPuwiJaBYLUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navon John Lukose <navonjohnlukose@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/227] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion x360 14-dy1xxx
Date: Tue,  8 Apr 2025 12:49:28 +0200
Message-ID: <20250408104826.000127225@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Navon John Lukose <navonjohnlukose@gmail.com>

[ Upstream commit b11a74ac4f545626d0dc95a8ca8c41df90532bf3 ]

Add a fixup to enable the mute LED on HP Pavilion x360 Convertible
14-dy1xxx with ALC295 codec. The appropriate coefficient index and bits
were identified through a brute-force method, as detailed in
https://bbs.archlinux.org/viewtopic.php?pid=2079504#p2079504.

Signed-off-by: Navon John Lukose <navonjohnlukose@gmail.com>
Link: https://patch.msgid.link/20250307213319.35507-1-navonjohnlukose@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f3cb24ed3a78a..3fdd2337919e1 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4702,6 +4702,21 @@ static void alc236_fixup_hp_coef_micmute_led(struct hda_codec *codec,
 	}
 }
 
+static void alc295_fixup_hp_mute_led_coefbit11(struct hda_codec *codec,
+				const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->mute_led_polarity = 0;
+		spec->mute_led_coef.idx = 0xb;
+		spec->mute_led_coef.mask = 3 << 3;
+		spec->mute_led_coef.on = 1 << 3;
+		spec->mute_led_coef.off = 1 << 4;
+		snd_hda_gen_add_mute_led_cdev(codec, coef_mute_led_set);
+	}
+}
+
 static void alc285_fixup_hp_mute_led(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)
 {
@@ -6942,6 +6957,7 @@ enum {
 	ALC290_FIXUP_MONO_SPEAKERS_HSJACK,
 	ALC290_FIXUP_SUBWOOFER,
 	ALC290_FIXUP_SUBWOOFER_HSJACK,
+	ALC295_FIXUP_HP_MUTE_LED_COEFBIT11,
 	ALC269_FIXUP_THINKPAD_ACPI,
 	ALC269_FIXUP_DMIC_THINKPAD_ACPI,
 	ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13,
@@ -8487,6 +8503,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC283_FIXUP_INT_MIC,
 	},
+	[ALC295_FIXUP_HP_MUTE_LED_COEFBIT11] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc295_fixup_hp_mute_led_coefbit11,
+	},
 	[ALC298_FIXUP_SAMSUNG_AMP] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc298_fixup_samsung_amp,
@@ -9195,6 +9215,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8519, "HP Spectre x360 15-df0xxx", ALC285_FIXUP_HP_SPECTRE_X360),
 	SND_PCI_QUIRK(0x103c, 0x8537, "HP ProBook 440 G6", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x85c6, "HP Pavilion x360 Convertible 14-dy1xxx", ALC295_FIXUP_HP_MUTE_LED_COEFBIT11),
 	SND_PCI_QUIRK(0x103c, 0x85de, "HP Envy x360 13-ar0xxx", ALC285_FIXUP_HP_ENVY_X360),
 	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
-- 
2.39.5




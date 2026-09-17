Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E1A53F6A7;
	Thu, 17 Sep 2026 17:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664925; cv=none; b=cfNG2WmWNDoAsIdGJpIBoZ86csxQbfj+gJPj7h2KoF3ewHtidrIQwftXc0/KB4Hj6brDmYl5+hAY+J2bhEsfCTB5xXQd71YoZmAoJhrUaErx2aVyqcvavlpRy2ZGoR6BdS9X6YJ3fWaL1cq82/HppHhjAU2ktups9OPm4Aeh5j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664925; c=relaxed/simple;
	bh=16k7vAHphzevvsI44jcMIpAQz9slxKsJw0q+95IFQTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3BQSbALoNSXFT8gQUYLgtlJzRYAwLX402e7bcURNGapc3+Yz+ZNzH7bEnti8/b/qOyL4OKPmpIXSnhkn9GyX76eFsSQNHQ9/b6TBinKme9XZb+D2l2R1xei07sGdf1tGlgTePU7tlxMrH4qjhAqsDKbEPsN9XZ8wUXXrWSDiN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/5172DI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/5172DI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBE71F0089A;
	Thu, 17 Sep 2026 17:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664924;
	bh=slu7CczgwmnxiUpbAaDUL29lxBP78LCXy+mDwGCN8uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/5172DIj/p7MOaOcHZAz5mrh6pLLVAakCbY5GNdRXeC8lLpUsPorkjXyGZJLjN5+
	 KnWLQBzGZud1Bo1c/rZckcK+rmFwIiySkisZYuFL5Ac4ZU0xZ2EjPTZvVgEvH+Tc6P
	 B5HLl/BKTw9wO2pw4jxce7ommO1vxPClRowpTk3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0534/1250] ALSA: hda/realtek: Add quirk for HP Pavilion x360
Date: Thu, 17 Sep 2026 16:05:29 +0100
Message-ID: <20260917151606.410644442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 02bbbf05d19f49c5cc9f249dd8844b2a7f2a2b8c ]

HP Pavilion x360 sets a bogus PCI SSID (103c:0000), hence the driver
picks up a wrong quirk entry, resulting in an almost silent output.
And yet, the existing quirk for x390 doesn't seem sufficing, and we
need the extra setup for the amp.

This patch adds the quirk entry for the codec SSID (103c:8486) to
initialize the amp via COEF verbs and chains to the existing quirk for
another x360 model to address the silent output.

Closes: https://lore.kernel.org/CAF2ktaUW2oaWwGazGtJQ3o1JyE2R4O2xPd-Dchr=qqi7_QRruQ@mail.gmail.com
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260716064916.540616-1-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index bf7d4793d8725..a2cda3a964fee 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3823,6 +3823,7 @@ enum {
 	ALC256_FIXUP_HUAWEI_MACH_WX9_PINS,
 	ALC298_FIXUP_HUAWEI_MBX_STEREO,
 	ALC295_FIXUP_HP_X360,
+	ALC295_FIXUP_HP_PAVILION_X360,
 	ALC221_FIXUP_HP_HEADSET_MIC,
 	ALC285_FIXUP_LENOVO_HEADPHONE_NOISE,
 	ALC295_FIXUP_HP_AUTO_MUTE,
@@ -5135,6 +5136,19 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HP_MUTE_LED_MIC3
 	},
+	[ALC295_FIXUP_HP_PAVILION_X360] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			/* force amp gain and processing state */
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x07 },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x7770 },
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x0d },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x3000 },
+			{}
+		},
+		.chained = true,
+		.chain_id = ALC295_FIXUP_HP_X360
+	},
 	[ALC221_FIXUP_HP_HEADSET_MIC] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -6729,6 +6743,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x82c0, "HP G3 mini premium", ALC221_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x83b9, "HP Spectre x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x841c, "HP Pavilion 15-CK0xx", ALC269_FIXUP_HP_MUTE_LED_MIC3),
+	HDA_CODEC_QUIRK(0x103c, 0x8486, "HP Pavilion x360", ALC295_FIXUP_HP_PAVILION_X360),
 	SND_PCI_QUIRK(0x103c, 0x8497, "HP Envy x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x84a6, "HP 250 G7 Notebook PC", ALC269_FIXUP_HP_LINE1_MIC1_LED),
 	SND_PCI_QUIRK(0x103c, 0x84ae, "HP 15-db0403ng", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1065136EA81;
	Mon,  9 Feb 2026 14:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647474; cv=none; b=k0607dMO+hPizgnxuz0r0xO001Rk2CjAzEhM0lOI1XalB0cAqX7BgOgGtenkNAoMVFh0tPcJjdWmtCKvFnV/45/vByyzw+PyrZb350E7O7qo4DaOF3ejD7YzMSVE+vz1lxxYrnAGpZ3T7PTWpDey/doCXOUzkSXNTaCKdZq+Aog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647474; c=relaxed/simple;
	bh=E8YxwSN+6LsXV2YzVyXRNeb6CNce2eBqp6GWqSc2GpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0AgEhrVRkFEnyEFgy1KO5pcHvD0JMuoB2f0pGxhc38NzYDuWcJjdkeN8z+Dn4WUUuGQ9Ira3Agw5lhDSN4D2MYGjiO6xnf78+21+wUZWDwUkN/qAbqDmQ9wQdllFYz9pT63/g8j1PTm3q137YBtpWo4qrrQruz6HFv5/zzqfeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obns8Xq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obns8Xq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BFEC116C6;
	Mon,  9 Feb 2026 14:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647474;
	bh=E8YxwSN+6LsXV2YzVyXRNeb6CNce2eBqp6GWqSc2GpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obns8Xq3bHEc59Jhq+05/enA/YJmsJC0S5bg4gdretmYhc7/oLXlD7la0CKGjpX59
	 WcFJG+JkI4dXRFzZkay6VqQG3uzesXRLcguRIGaZSP61dK4FtsCPwrY57GCeddqET1
	 HZKIBGplfRYYeqflwKZ9Plr2Pa9xOh6pyoStjssM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Hamilton <m@martinh.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 110/175] ALSA: hda/realtek: ALC269 fixup for Lenovo Yoga Book 9i 13IRU8 audio
Date: Mon,  9 Feb 2026 15:23:03 +0100
Message-ID: <20260209142324.376722056@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Martin Hamilton <m@martinh.net>

[ Upstream commit 64e0924ed3b446fdd758dfab582e0e961863a116 ]

The amp/speakers on the Lenovo Yoga Book 9i 13IRU8 laptop aren't
fully powered up, resulting in horrible tinny sound by default.

The kernel has an existing quirk for PCI SSID 0x17aa3843 which
matches this machine and several others. The quirk applies the
ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP fixup, however the fixup does not
work on this machine.

This patch modifies the existing quirk by adding a check for the
subsystem ID 0x17aa3881. If present, ALC287_FIXUP_TAS2781_I2C will
be applied instead of ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP. With this
change the TAS2781 amp is powered up, firmware is downloaded and
recognised by HDA/SOF - i.e. all is good, and we can boogie.

Code is re-used from alc298_fixup_lenovo_c940_duet7(), which fixes a
similar problem with two other Lenovo laptops.

Cross checked against ALSA cardinfo database for potential clashes.
Tested against 6.18.5 kernel built with Arch Linux default options.
Tested in HDA mode and SOF mode.

Note: Possible further work required to address quality of life issues
caused by the firmware's agressive power saving, and to improve ALSA
control mappings.

Signed-off-by: Martin Hamilton <m@martinh.net>
Link: https://patch.msgid.link/20260122-alc269-yogabook9i-fixup-v1-1-a6883429400f@martinh.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index e9022f751c959..ddfad56b30af5 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3674,6 +3674,7 @@ enum {
 	ALC287_FIXUP_LEGION_15IMHG05_AUTOMUTE,
 	ALC287_FIXUP_YOGA7_14ITL_SPEAKERS,
 	ALC298_FIXUP_LENOVO_C940_DUET7,
+	ALC287_FIXUP_LENOVO_YOGA_BOOK_9I,
 	ALC287_FIXUP_13S_GEN2_SPEAKERS,
 	ALC256_FIXUP_SET_COEF_DEFAULTS,
 	ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
@@ -3757,6 +3758,23 @@ static void alc298_fixup_lenovo_c940_duet7(struct hda_codec *codec,
 	__snd_hda_apply_fixup(codec, id, action, 0);
 }
 
+/* A special fixup for Lenovo Yoga 9i and Yoga Book 9i 13IRU8
+ * both have the very same PCI SSID and vendor ID, so we need
+ * to apply different fixups depending on the subsystem ID
+ */
+static void alc287_fixup_lenovo_yoga_book_9i(struct hda_codec *codec,
+					   const struct hda_fixup *fix,
+					   int action)
+{
+	int id;
+
+	if (codec->core.subsystem_id == 0x17aa3881)
+		id = ALC287_FIXUP_TAS2781_I2C; /* Yoga Book 9i 13IRU8 */
+	else
+		id = ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP; /* Yoga 9i */
+	__snd_hda_apply_fixup(codec, id, action, 0);
+}
+
 static const struct hda_fixup alc269_fixups[] = {
 	[ALC269_FIXUP_GPIO2] = {
 		.type = HDA_FIXUP_FUNC,
@@ -5764,6 +5782,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc298_fixup_lenovo_c940_duet7,
 	},
+	[ALC287_FIXUP_LENOVO_YOGA_BOOK_9I] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc287_fixup_lenovo_yoga_book_9i,
+	},
 	[ALC287_FIXUP_13S_GEN2_SPEAKERS] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -7088,7 +7110,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3827, "Ideapad S740", ALC285_FIXUP_IDEAPAD_S740_COEF),
 	SND_PCI_QUIRK(0x17aa, 0x3834, "Lenovo IdeaPad Slim 9i 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x383d, "Legion Y9000X 2019", ALC285_FIXUP_LEGION_Y9000X_SPEAKERS),
-	SND_PCI_QUIRK(0x17aa, 0x3843, "Yoga 9i", ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP),
+	SND_PCI_QUIRK(0x17aa, 0x3843, "Lenovo Yoga 9i / Yoga Book 9i", ALC287_FIXUP_LENOVO_YOGA_BOOK_9I),
 	SND_PCI_QUIRK(0x17aa, 0x3847, "Legion 7 16ACHG6", ALC287_FIXUP_LEGION_16ACHG6),
 	SND_PCI_QUIRK(0x17aa, 0x384a, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
-- 
2.51.0




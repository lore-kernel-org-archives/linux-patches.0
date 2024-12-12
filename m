Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0295222D41;
	Thu, 12 Dec 2024 15:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018173; cv=none; b=Wf1rrM3N2CB9i3EFc4cYNpHudt57s/+UT764L8IyA3d3V+5Ye40g7glkY7CznmElRcC19KhigK7gNT0IaW26Ki+Wx7ltbxlVwpsEZlkRjvVpJY2NwfQmGwMmHF3jKEuxpGyzoyR+B6QEhUzup84ZTUYdWr2eXQDu1j+oqwyfid0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018173; c=relaxed/simple;
	bh=8Gx9v2TiUcU8RnSyTgqBQL2jWQWkh0loQTBqf0e54Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATDnczeNR98AdYKFH9Jih9/OqeF8JddtraHvs83/iWHUmqGK2qlnYZcknR6kv8jO6y9OR6aBMUYdMrMUPUZ68nIOWu6ESUGUn/6O7uSqK+G3wq+Ck29z6uOCI7yebEyfNN7v8nVmhlDq8pL2MO0F15fHkDLr2UVIx5cFVKf7mec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QSfKLg6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QSfKLg6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EE2C4CECE;
	Thu, 12 Dec 2024 15:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018173;
	bh=8Gx9v2TiUcU8RnSyTgqBQL2jWQWkh0loQTBqf0e54Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QSfKLg6y1zuNWW809DZyesVJFrS4IfxcAbgcb+4E4gw8CDqlKNqyCwCTTdU95dh4T
	 5Q6sVKHjgG4E0CskFcsNKdv1eOAe/86n/069tNbQnf5f4UGRkxbC5KllVoSaUkQltL
	 A7Xrlq5ebKTXsX5Dh1MTAvsoMgI5Myu0C1Wc5eOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/356] ALSA: hda/conexant: Use the new codec SSID matching
Date: Thu, 12 Dec 2024 15:58:57 +0100
Message-ID: <20241212144253.231369273@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 1f55e3699fc9ced72400cdca39fe248bf2b288a2 ]

Now we can perform the codec ID matching primarily, and reduce the
conditional application of the quirk for conflicting PCI SSID between
System76 and Tuxedo devices.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20241008120233.7154-3-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 5cd3589153b6d..b3208b068dd80 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -832,23 +832,6 @@ static const struct hda_pintbl cxt_pincfg_sws_js201d[] = {
 	{}
 };
 
-/* pincfg quirk for Tuxedo Sirius;
- * unfortunately the (PCI) SSID conflicts with System76 Pangolin pang14,
- * which has incompatible pin setup, so we check the codec SSID (luckily
- * different one!) and conditionally apply the quirk here
- */
-static void cxt_fixup_sirius_top_speaker(struct hda_codec *codec,
-					 const struct hda_fixup *fix,
-					 int action)
-{
-	/* ignore for incorrectly picked-up pang14 */
-	if (codec->core.subsystem_id == 0x278212b3)
-		return;
-	/* set up the top speaker pin */
-	if (action == HDA_FIXUP_ACT_PRE_PROBE)
-		snd_hda_codec_set_pincfg(codec, 0x1d, 0x82170111);
-}
-
 static const struct hda_fixup cxt_fixups[] = {
 	[CXT_PINCFG_LENOVO_X200] = {
 		.type = HDA_FIXUP_PINS,
@@ -1013,8 +996,11 @@ static const struct hda_fixup cxt_fixups[] = {
 		.v.pins = cxt_pincfg_sws_js201d,
 	},
 	[CXT_PINCFG_TOP_SPEAKER] = {
-		.type = HDA_FIXUP_FUNC,
-		.v.func = cxt_fixup_sirius_top_speaker,
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1d, 0x82170111 },
+			{ }
+		},
 	},
 };
 
@@ -1113,8 +1099,8 @@ static const struct hda_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Thinkpad", CXT_FIXUP_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x1c06, 0x2011, "Lemote A1004", CXT_PINCFG_LEMOTE_A1004),
 	SND_PCI_QUIRK(0x1c06, 0x2012, "Lemote A1205", CXT_PINCFG_LEMOTE_A1205),
-	SND_PCI_QUIRK(0x2782, 0x12c3, "Sirius Gen1", CXT_PINCFG_TOP_SPEAKER),
-	SND_PCI_QUIRK(0x2782, 0x12c5, "Sirius Gen2", CXT_PINCFG_TOP_SPEAKER),
+	HDA_CODEC_QUIRK(0x2782, 0x12c3, "Sirius Gen1", CXT_PINCFG_TOP_SPEAKER),
+	HDA_CODEC_QUIRK(0x2782, 0x12c5, "Sirius Gen2", CXT_PINCFG_TOP_SPEAKER),
 	{}
 };
 
-- 
2.43.0




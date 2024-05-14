Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B6569950;
	Tue, 14 May 2024 10:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683705; cv=none; b=lbnOaJAMxYSKexbXn7U6h6RUOrVF42KLy/n592f3qWN2LtsnJPgkFIB1OLOq4P7mBCT9Twaz191h8WpEvdgX8dlzgr2Cd434+KsOjsUJXX7cvW3J9ezPDsuIrQyc1UBtmKteoKfe3wiFxIJu/3xQF7TW8g0QpSVyfdV4+TmTKlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683705; c=relaxed/simple;
	bh=UYG20tI9WFYjsmYnISPuWUvoBQ6ehSO+R01HAxcXulY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUh+N5e32mMfE1u4Wp4UYnVr90WcxQwyJ3wvlx3eboHJrVB/Tq4XS3iTZfg5vWh7zudU59BSWr7QS0kJDX4an67o1vZP7eXskFRfq0qI6kNzjaPdfyzyyfsKAu6QjsyXaZY9TrzEMLxv4xhsL8/p2p1kJC3ALdqCK3i8Debf54U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nW9d8lAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nW9d8lAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33A6C2BD10;
	Tue, 14 May 2024 10:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683705;
	bh=UYG20tI9WFYjsmYnISPuWUvoBQ6ehSO+R01HAxcXulY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nW9d8lAu6/fUAUMG1ZoqTZi87yDLO+rAOYhFITS0YOAlAlhh0cnMArfWMzJ4PESVz
	 OVsRnGw3M85BsoVkeTlpn0NFkP0PVdyqblRorRzYLHLhCodKzqULRplqZfqa8C6HUi
	 B1Kw9ViW4CyNXQKfg+T327SojdDsMaYMpVwz4SFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.8 260/336] ALSA: hda/realtek: Fix conflicting PCI SSID 17aa:386f for Lenovo Legion models
Date: Tue, 14 May 2024 12:17:44 +0200
Message-ID: <20240514101048.431433623@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 39815cdfc8d46ce2c72cbf2aa3d991c4bfb0024f upstream.

Unfortunately both Lenovo Legion Pro 7 16ARX8H and Legion 7i 16IAX7
got the very same PCI SSID while the hardware implementations are
completely different (the former is with TI TAS2781 codec while the
latter is with Cirrus CS35L41 codec).  The former model got broken by
the recent fix for the latter model.

For addressing the regression, check the codec SSID and apply the
proper quirk for each model now.

Fixes: 24b6332c2d4f ("ALSA: hda: Add Lenovo Legion 7i gen7 sound quirk")
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.suse.com/show_bug.cgi?id=1223462
Message-ID: <20240430163206.5200-1-tiwai@suse.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7502,6 +7502,7 @@ enum {
 	ALC287_FIXUP_YOGA7_14ITL_SPEAKERS,
 	ALC298_FIXUP_LENOVO_C940_DUET7,
 	ALC287_FIXUP_LENOVO_14IRP8_DUETITL,
+	ALC287_FIXUP_LENOVO_LEGION_7,
 	ALC287_FIXUP_13S_GEN2_SPEAKERS,
 	ALC256_FIXUP_SET_COEF_DEFAULTS,
 	ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
@@ -7574,6 +7575,23 @@ static void alc287_fixup_lenovo_14irp8_d
 	__snd_hda_apply_fixup(codec, id, action, 0);
 }
 
+/* Another hilarious PCI SSID conflict with Lenovo Legion Pro 7 16ARX8H (with
+ * TAS2781 codec) and Legion 7i 16IAX7 (with CS35L41 codec);
+ * we apply a corresponding fixup depending on the codec SSID instead
+ */
+static void alc287_fixup_lenovo_legion_7(struct hda_codec *codec,
+					 const struct hda_fixup *fix,
+					 int action)
+{
+	int id;
+
+	if (codec->core.subsystem_id == 0x17aa38a8)
+		id = ALC287_FIXUP_TAS2781_I2C; /* Legion Pro 7 16ARX8H */
+	else
+		id = ALC287_FIXUP_CS35L41_I2C_2; /* Legion 7i 16IAX7 */
+	__snd_hda_apply_fixup(codec, id, action, 0);
+}
+
 static const struct hda_fixup alc269_fixups[] = {
 	[ALC269_FIXUP_GPIO2] = {
 		.type = HDA_FIXUP_FUNC,
@@ -9468,6 +9486,10 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc287_fixup_lenovo_14irp8_duetitl,
 	},
+	[ALC287_FIXUP_LENOVO_LEGION_7] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc287_fixup_lenovo_legion_7,
+	},
 	[ALC287_FIXUP_13S_GEN2_SPEAKERS] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -10372,7 +10394,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3853, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3855, "Legion 7 16ITHG6", ALC287_FIXUP_LEGION_16ITHG6),
 	SND_PCI_QUIRK(0x17aa, 0x3869, "Lenovo Yoga7 14IAL7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
-	SND_PCI_QUIRK(0x17aa, 0x386f, "Legion 7i 16IAX7", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x17aa, 0x386f, "Legion Pro 7/7i", ALC287_FIXUP_LENOVO_LEGION_7),
 	SND_PCI_QUIRK(0x17aa, 0x3870, "Lenovo Yoga 7 14ARB7", ALC287_FIXUP_YOGA7_14ARB7_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3877, "Lenovo Legion 7 Slim 16ARHA7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3878, "Lenovo Legion 7 Slim 16ARHA7", ALC287_FIXUP_CS35L41_I2C_2),



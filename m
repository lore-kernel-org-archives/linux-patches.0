Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286251E4106;
	Mon, 21 Oct 2024 10:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507274; cv=none; b=T2x6akBtAErbDKMB8OZAlA7GnjRkTON4P774phB0X53pm7vv8Oa+8eB1U36g5PPxkHYoQWSwvkfJvPDNPjDw9lq4scGWmdwfziOOJjVI8dEXSQzZokoPmi+jZ15GDtGLbJSRqRnNLBGGdWGEvGIm74GFGwisfz++lms5pZ1aaE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507274; c=relaxed/simple;
	bh=UgXOfjAHbjb7EkeEZROCnChX4uBwhObgqZDuujPOMVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcGpcCNRSt2nQWFLGBEYdhVmfaRwBS7qW3S7k3n48s3Q41I4yE2zohIaPg5a5jQlZmWyAy5Mlf6rd4maH2xnM849xDRWpvhQ29SkatdEM+MX1Mdi6Dly5qjfNJIbHoA3ExWGEHZ1ZpRky3SsV9Sn+IN/PAWEEftNSNi4Tp/ydt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6N7XP9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6N7XP9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6477FC4CEC3;
	Mon, 21 Oct 2024 10:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507273;
	bh=UgXOfjAHbjb7EkeEZROCnChX4uBwhObgqZDuujPOMVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6N7XP9olQlZixEXTvkeBFFdTQksVFU9BgC3IgXPtIl0kAtzaYJ905VnS5RA3S4iK
	 n4CJaq0lMEBqXT+DAvR2pFRIvY81uSdilLGv4KwkPA/gocgqJS02Bnpj25TCm0C2qC
	 JFkEfnVCk4Qby/qqMlWdY6g7IdS+wUR6E55EouyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 04/91] ALSA: hda/conexant - Fix audio routing for HP EliteOne 1000 G2
Date: Mon, 21 Oct 2024 12:24:18 +0200
Message-ID: <20241021102249.970132305@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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

From: Vasiliy Kovalev <kovalev@altlinux.org>

commit 9988844c457f6f17fb2e75aa000b6c3b1b673bb9 upstream.

There is a problem with simultaneous audio output to headphones and
speakers, and when headphones are turned off, the speakers also turn
off and do not turn them on.

However, it was found that if you boot linux immediately after windows,
there are no such problems. When comparing alsa-info, the only difference
is the different configuration of Node 0x1d:

working conf. (windows): Pin-ctls: 0x80: HP
not working     (linux): Pin-ctls: 0xc0: OUT HP

This patch disable the AC_PINCTL_OUT_EN bit of Node 0x1d and fixes the
described problem.

Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241009134248.662175-1-kovalev@altlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -307,6 +307,7 @@ enum {
 	CXT_FIXUP_HP_SPECTRE,
 	CXT_FIXUP_HP_GATE_MIC,
 	CXT_FIXUP_MUTE_LED_GPIO,
+	CXT_FIXUP_HP_ELITEONE_OUT_DIS,
 	CXT_FIXUP_HP_ZBOOK_MUTE_LED,
 	CXT_FIXUP_HEADSET_MIC,
 	CXT_FIXUP_HP_MIC_NO_PRESENCE,
@@ -324,6 +325,19 @@ static void cxt_fixup_stereo_dmic(struct
 	spec->gen.inv_dmic_split = 1;
 }
 
+/* fix widget control pin settings */
+static void cxt_fixup_update_pinctl(struct hda_codec *codec,
+				   const struct hda_fixup *fix, int action)
+{
+	if (action == HDA_FIXUP_ACT_PROBE) {
+		/* Unset OUT_EN for this Node pin, leaving only HP_EN.
+		 * This is the value stored in the codec register after
+		 * the correct initialization of the previous windows boot.
+		 */
+		snd_hda_set_pin_ctl(codec, 0x1d, AC_PINCTL_HP_EN);
+	}
+}
+
 static void cxt5066_increase_mic_boost(struct hda_codec *codec,
 				   const struct hda_fixup *fix, int action)
 {
@@ -975,6 +989,10 @@ static const struct hda_fixup cxt_fixups
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cxt_fixup_mute_led_gpio,
 	},
+	[CXT_FIXUP_HP_ELITEONE_OUT_DIS] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cxt_fixup_update_pinctl,
+	},
 	[CXT_FIXUP_HP_ZBOOK_MUTE_LED] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cxt_fixup_hp_zbook_mute_led,
@@ -1065,6 +1083,7 @@ static const struct snd_pci_quirk cxt506
 	SND_PCI_QUIRK(0x103c, 0x83b2, "HP EliteBook 840 G5", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x83b3, "HP EliteBook 830 G5", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x83d3, "HP ProBook 640 G4", CXT_FIXUP_HP_DOCK),
+	SND_PCI_QUIRK(0x103c, 0x83e5, "HP EliteOne 1000 G2", CXT_FIXUP_HP_ELITEONE_OUT_DIS),
 	SND_PCI_QUIRK(0x103c, 0x8402, "HP ProBook 645 G4", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8427, "HP ZBook Studio G5", CXT_FIXUP_HP_ZBOOK_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x844f, "HP ZBook Studio G5", CXT_FIXUP_HP_ZBOOK_MUTE_LED),



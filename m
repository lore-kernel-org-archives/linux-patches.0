Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384D31E571E;
	Mon, 21 Oct 2024 10:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507757; cv=none; b=cToE7QPCl7wlIgmq6GNWGur1EH5MMGU00LNJuKiV05Sy9mlOluXnMhXUJQ6/y7T2Cah8AYn+bSAiNbLHweS9oIqKViJ6Mc+pSOdCNswd4kVWP1thz/iDAHczuzpQFHY1LXVe4A1cjOoRGbrti5vZztfFV7XtqJ1fAyscgSI0EKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507757; c=relaxed/simple;
	bh=1Py+NPSB2XGxwaOe9rd6vsgwPwZdE+6ZDNhtHu0+CZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XILmOmq2+F1HbZQhxcmdQKptbAjbNY1O59t4cjJgCedxQ50z9CgppPPEN80zJ/Bnei4Vs/5BTzFY4YmaZv6Wc6pooaV3VaAwFC8G1Iw8bBU11QhczD2sCt/HpTJxa183/A1QrNrEWH+qY5zcbiUSZaYNP8eASIRjbyIOAckzcHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuZxbB3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuZxbB3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B235AC4CEC3;
	Mon, 21 Oct 2024 10:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507757;
	bh=1Py+NPSB2XGxwaOe9rd6vsgwPwZdE+6ZDNhtHu0+CZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuZxbB3vlKt13S2hHR9+Bt/71lr34Hgqb5UDELg2kMV+TvFxkdb7/BtdeJ8TqDH2/
	 W9xGn/x+P0MwhugrHSjTDk8Rqzh2p7Zf/lNPOV9SdYTKRzY5VdOgAZlMJzUcXb95v0
	 AsBjwXzTZK6oXuW1NI7gweb8o0c4Y6JbmtWpfX+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 01/52] ALSA: hda/conexant - Fix audio routing for HP EliteOne 1000 G2
Date: Mon, 21 Oct 2024 12:25:22 +0200
Message-ID: <20241021102241.683668742@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -234,6 +234,7 @@ enum {
 	CXT_FIXUP_HP_SPECTRE,
 	CXT_FIXUP_HP_GATE_MIC,
 	CXT_FIXUP_MUTE_LED_GPIO,
+	CXT_FIXUP_HP_ELITEONE_OUT_DIS,
 	CXT_FIXUP_HP_ZBOOK_MUTE_LED,
 	CXT_FIXUP_HEADSET_MIC,
 	CXT_FIXUP_HP_MIC_NO_PRESENCE,
@@ -251,6 +252,19 @@ static void cxt_fixup_stereo_dmic(struct
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
@@ -902,6 +916,10 @@ static const struct hda_fixup cxt_fixups
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
@@ -992,6 +1010,7 @@ static const struct snd_pci_quirk cxt506
 	SND_PCI_QUIRK(0x103c, 0x83b2, "HP EliteBook 840 G5", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x83b3, "HP EliteBook 830 G5", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x83d3, "HP ProBook 640 G4", CXT_FIXUP_HP_DOCK),
+	SND_PCI_QUIRK(0x103c, 0x83e5, "HP EliteOne 1000 G2", CXT_FIXUP_HP_ELITEONE_OUT_DIS),
 	SND_PCI_QUIRK(0x103c, 0x8402, "HP ProBook 645 G4", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8427, "HP ZBook Studio G5", CXT_FIXUP_HP_ZBOOK_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x844f, "HP ZBook Studio G5", CXT_FIXUP_HP_ZBOOK_MUTE_LED),



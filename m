Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AB814B06C;
	Tue, 10 Sep 2024 10:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963994; cv=none; b=lX2rM2KE+1BMy9OAk/wxVlq7tq76exjJ2lRDWmyO3ZcUYR6nzcMOZwYcRHFFwYNOHovl/+B7djEyXGowEbnG1l8rkjq/XdabU7z8HmRgmuNaLhi5DtqkhAXz7dqRDul9FNOgaMTefwefrS3lBPG5sIsBJHUbG6UK5of8fhZE05c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963994; c=relaxed/simple;
	bh=1UDqtOtOTdfHAkVwyWpxxAen2bBUEJLPkd44Y0SZX7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0b1cjYpEUfKujrVaMn1Lj8TiUUpeO8qBRzgXy4mXuJkepqt1Jst0s422HbPyHu8wMN2/o7x5jVtSZb+JAY6SrD8x4KuhIY5D+iC6l8bB6jMtQzPQyAI66mmpIWUdjZD9IJI/hFnhsqJ8ZUfoQSNMI+A/Lr+iOWJiDi7NSY+DR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ov/duPg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ov/duPg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD3CC4CEC3;
	Tue, 10 Sep 2024 10:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963994;
	bh=1UDqtOtOTdfHAkVwyWpxxAen2bBUEJLPkd44Y0SZX7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ov/duPg1WYgbmt9BGBZo81h7OzqrmDHyNFs0988DlQrCX2hH/aCNAPSkCfDMstp8Q
	 2hu5gxBtYs7Par6e+lx3ULMiVgL+fJQKfMrpn7zDZ1LBp7T+dgjNEHSPYz7yJXF0Aq
	 WFPY5kyWIGOkM/Xp//n2C1aaUkj5BOW4+mPVKWxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 007/269] ALSA: hda/conexant: Add pincfg quirk to enable top speakers on Sirius devices
Date: Tue, 10 Sep 2024 11:29:54 +0200
Message-ID: <20240910092608.499491051@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Christoffer Sandberg <cs@tuxedo.de>

commit 4178d78cd7a86510ba68d203f26fc01113c7f126 upstream.

The Sirius notebooks have two sets of speakers 0x17 (sides) and
0x1d (top center). The side speakers are active by default but
the top speakers aren't.

This patch provides a pincfg quirk to activate the top speakers.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20240827102540.9480-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -311,6 +311,7 @@ enum {
 	CXT_FIXUP_HEADSET_MIC,
 	CXT_FIXUP_HP_MIC_NO_PRESENCE,
 	CXT_PINCFG_SWS_JS201D,
+	CXT_PINCFG_TOP_SPEAKER,
 };
 
 /* for hda_fixup_thinkpad_acpi() */
@@ -978,6 +979,13 @@ static const struct hda_fixup cxt_fixups
 		.type = HDA_FIXUP_PINS,
 		.v.pins = cxt_pincfg_sws_js201d,
 	},
+	[CXT_PINCFG_TOP_SPEAKER] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1d, 0x82170111 },
+			{ }
+		},
+	},
 };
 
 static const struct snd_pci_quirk cxt5045_fixups[] = {
@@ -1074,6 +1082,8 @@ static const struct snd_pci_quirk cxt506
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Thinkpad", CXT_FIXUP_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x1c06, 0x2011, "Lemote A1004", CXT_PINCFG_LEMOTE_A1004),
 	SND_PCI_QUIRK(0x1c06, 0x2012, "Lemote A1205", CXT_PINCFG_LEMOTE_A1205),
+	SND_PCI_QUIRK(0x2782, 0x12c3, "Sirius Gen1", CXT_PINCFG_TOP_SPEAKER),
+	SND_PCI_QUIRK(0x2782, 0x12c5, "Sirius Gen2", CXT_PINCFG_TOP_SPEAKER),
 	{}
 };
 
@@ -1093,6 +1103,7 @@ static const struct hda_model_fixup cxt5
 	{ .id = CXT_FIXUP_HP_MIC_NO_PRESENCE, .name = "hp-mic-fix" },
 	{ .id = CXT_PINCFG_LENOVO_NOTEBOOK, .name = "lenovo-20149" },
 	{ .id = CXT_PINCFG_SWS_JS201D, .name = "sws-js201d" },
+	{ .id = CXT_PINCFG_TOP_SPEAKER, .name = "sirius-top-speaker" },
 	{}
 };
 



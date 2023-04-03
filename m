Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006E1612E
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBDFC433D2;
	Mon,  3 Apr 2023 14:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531771;
	bh=xdGYwNmhlpqCInwajrFt+0V7h8GxzpAJom1D2Eh7N7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HcGcOhwycIep6mkC+2qo5uSY2NssIQv2nuiqmO2xG0JUL6OqdJH76A7AQ/0OEjVlg
	 FZ1ALMDYlQWYGY3ixbTJBts7+HxgsGQByBDT0+tQI2UTwGR38YWTWp7XuHR8V+cH0b
	 pRWqQD3yyx1AiWjz4qtoSqHgGxZrriUVrlry3CNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jetro Jormalainen <jje-lxkl@jetro.fi>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 095/104] ALSA: hda/conexant: Partial revert of a quirk for Lenovo
Date: Mon,  3 Apr 2023 16:09:27 +0200
Message-Id: <20230403140407.896749082@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

commit b871cb971c683f7f212e7ca3c9a6709a75785116 upstream.

The recent commit f83bb2592482 ("ALSA: hda/conexant: Add quirk for
LENOVO 20149 Notebook model") introduced a quirk for the device with
17aa:3977, but this caused a regression on another model (Lenovo
Ideadpad U31) with the very same PCI SSID.  And, through skimming over
the net, it seems that this PCI SSID is used for multiple different
models, so it's no good idea to apply the quirk with the SSID.

Although we may take a different ID check (e.g. the codec SSID instead
of the PCI SSID), unfortunately, the original patch author couldn't
identify the hardware details any longer as the machine was returned,
and we can't develop the further proper fix.

In this patch, instead, we partially revert the change so that the
quirk won't be applied as default for addressing the regression.
Meanwhile, the quirk function itself is kept, and it's now made to be
applicable via the explicit model=lenovo-20149 option.

Fixes: f83bb2592482 ("ALSA: hda/conexant: Add quirk for LENOVO 20149 Notebook model")
Reported-by: Jetro Jormalainen <jje-lxkl@jetro.fi>
Link: https://lore.kernel.org/r/20230308215009.4d3e58a6@mopti
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230320140954.31154-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -939,7 +939,10 @@ static const struct snd_pci_quirk cxt506
 	SND_PCI_QUIRK(0x17aa, 0x3905, "Lenovo G50-30", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x390b, "Lenovo G50-80", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
-	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_PINCFG_LENOVO_NOTEBOOK),
+	/* NOTE: we'd need to extend the quirk for 17aa:3977 as the same
+	 * PCI SSID is used on multiple Lenovo models
+	 */
+	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo G50-70", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Thinkpad", CXT_FIXUP_THINKPAD_ACPI),
@@ -961,6 +964,7 @@ static const struct hda_model_fixup cxt5
 	{ .id = CXT_FIXUP_HP_DOCK, .name = "hp-dock" },
 	{ .id = CXT_FIXUP_MUTE_LED_GPIO, .name = "mute-led-gpio" },
 	{ .id = CXT_FIXUP_HP_MIC_NO_PRESENCE, .name = "hp-mic-fix" },
+	{ .id = CXT_PINCFG_LENOVO_NOTEBOOK, .name = "lenovo-20149" },
 	{}
 };
 



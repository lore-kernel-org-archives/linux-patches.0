Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1866014D431;
	Tue, 10 Sep 2024 10:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963462; cv=none; b=K0jos2WlUh0BbLxVjMc0hEkTNecJREh/KA1kERfqUhPsd2fylFUFaEI0U0dXxCyzpe24C6Ks9m/Erz5glvhoQDz8wCEPgHw19lUYiiqcDfZnOSuvsC7h5oLqHegD52LnVsKM2IOTnao7O/sNbpYQ7Z5zHYK2zzbwXHD89MTnSls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963462; c=relaxed/simple;
	bh=TlAuyj5p6O+D65DPe3AnERp9saE/jphpxcUaL74cwKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9xD57/syvx7paOGokHAkOBLnqLzDrKxWDIfMughq3vtj1nvqIXWgYNs264xhkr45Y2y97LmXexCScWhqYB9e3rWjuat5kBUWKvqw9TcezaIns3o0QyZBjHr9+tXtNJ5jAbyqEFPNo5EudmhPmp2ahUdIpVFuJn012rzZ5YTqxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSP2Bkt1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSP2Bkt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942BFC4CEC3;
	Tue, 10 Sep 2024 10:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963462;
	bh=TlAuyj5p6O+D65DPe3AnERp9saE/jphpxcUaL74cwKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSP2Bkt1V74t+vU7kUcZMMJnYcOrLALcVPpu++FHDeWdkxIGmZxHzNjn+aDlKK5JZ
	 8ZIlYXt5GreRrZXfQV4LTgUNuBxGgHcLxJHzYxTPMB+uGZ94HC7VFz+knZRkQrde3R
	 SXLmOoWa3pZQLXXXFdBZ8PGc03fqko8bfBO4jGKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 066/214] ALSA: hda/conexant: Add pincfg quirk to enable top speakers on Sirius devices
Date: Tue, 10 Sep 2024 11:31:28 +0200
Message-ID: <20240910092601.448217021@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 



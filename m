Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11750310620;
	Thu, 12 Mar 2026 20:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346906; cv=none; b=Aw+Y/nZrH4itPExP9tAK9k+VydqjfJS3x4Ud9OTo/fs79wVm9TwYQ+w0hilKv+zeSUr3mVeWgV0L10EiC+o6jCqIPl2D3+ds1eFcrDQi7o46Uzuj9LesU4x7+ghll73uvpTL5b7pkLRGXxYYYImsFFe0haID05UPLQAyusumU3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346906; c=relaxed/simple;
	bh=EaEjCxrJjU5Wr3HoMrz2m6XSUDTl9XkTt/w0z2PYhes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3K89l5IzMvaaZDSHGi6Dq5HO8EnlMNH9hRXZGH8ALP4Bote6Rxe3uc63rTjzK2zIs2I+ngR8vzqCzttGDbutL/7m4FKypjzjZl3X+v67L/UIZlu1uTis2p/tW/mhfh4xq/l+bqLNVfGTmeET9u239jP+6Oud/GPMnSFAHGXfOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1YscozP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1YscozP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E04C4CEF7;
	Thu, 12 Mar 2026 20:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346905;
	bh=EaEjCxrJjU5Wr3HoMrz2m6XSUDTl9XkTt/w0z2PYhes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y1YscozPiLr9Ah4ATNtLHbS6jIdW3QbK4hEJ8Qp0s4E1HXpJFNAPERzAQoXMJLLnY
	 SNc1C9DR1OdwJ+I79MBSagVMjrgT9rbOYKgcHu3Hr/13ye69hp31FtMAf77RPZXW7N
	 88z1GkiyQ1McY0SqUmxYJkRqJW9kzj3jQC6dzA4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 124/265] ALSA: hda/conexant: Fix headphone jack handling on Acer Swift SF314
Date: Thu, 12 Mar 2026 21:08:31 +0100
Message-ID: <20260312201022.726516168@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7bc0df86c2384bc1e2012a2c946f82305054da64 ]

Acer Swift SF314 (SSID 1025:136d) needs a bit of tweaks of the pin
configurations for NID 0x16 and 0x19 to make the headphone / headset
jack working.  NID 0x17 can remain as is for the working speaker, and
the built-in mic is supported via SOF.

Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221086
Link: https://patch.msgid.link/20260217104414.62911-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 9dc11d922612b..b7c9eba9236d8 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -308,6 +308,7 @@ enum {
 	CXT_PINCFG_SWS_JS201D,
 	CXT_PINCFG_TOP_SPEAKER,
 	CXT_FIXUP_HP_A_U,
+	CXT_FIXUP_ACER_SWIFT_HP,
 };
 
 /* for hda_fixup_thinkpad_acpi() */
@@ -1024,6 +1025,14 @@ static const struct hda_fixup cxt_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cxt_fixup_hp_a_u,
 	},
+	[CXT_FIXUP_ACER_SWIFT_HP] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x16, 0x0321403f }, /* Headphone */
+			{ 0x19, 0x40f001f0 }, /* Mic */
+			{ }
+		},
+	},
 };
 
 static const struct hda_quirk cxt5045_fixups[] = {
@@ -1073,6 +1082,7 @@ static const struct hda_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x1025, 0x0543, "Acer Aspire One 522", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x054c, "Acer Aspire 3830TG", CXT_FIXUP_ASPIRE_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x054f, "Acer Aspire 4830T", CXT_FIXUP_ASPIRE_DMIC),
+	SND_PCI_QUIRK(0x1025, 0x136d, "Acer Swift SF314", CXT_FIXUP_ACER_SWIFT_HP),
 	SND_PCI_QUIRK(0x103c, 0x8079, "HP EliteBook 840 G3", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x807C, "HP EliteBook 820 G3", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x80FD, "HP ProBook 640 G2", CXT_FIXUP_HP_DOCK),
-- 
2.51.0




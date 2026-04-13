Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F01630AACB;
	Mon, 13 Apr 2026 16:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097187; cv=none; b=UVoy7VRFMPJtQEzr7phAXqD4TwCUvS86MdsGi4y60X15sLV13oSYy4rGpIcZsZ9RVszWEw0toBXi0jekb8j5zRNV9hmW0OeWnYrEXzCaQZ1yyaBoRc7ezm95Y8LHxxhRO9VifG8812q6Lq+lzXPaLqmpzvavviHtbofJCEkhGQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097187; c=relaxed/simple;
	bh=EouXTlL3xIvQwlhrcU6qxwMFIpKnctxCUIZ3FtomDvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LF8CU9+GTvbETau2upv18aKEzCWZfmwqie1IHtw7m9F/5PtxwLZayijo6Qjsv1hqfkSzSDMEgAguFqMNtsSV6e5Crg92KfuQ7iLP3R/sy71vZwyPtNqGAdi8dbSDhIKQ7MUrwJqqqRCGDlH7inVXKtBeuNzU0Yukg05rxTGcGnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M10Kj5vN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M10Kj5vN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D72AC2BCAF;
	Mon, 13 Apr 2026 16:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097187;
	bh=EouXTlL3xIvQwlhrcU6qxwMFIpKnctxCUIZ3FtomDvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M10Kj5vNKhw+PQ3VY65a0xuRP5EcmPCms2Rd/ncP1fOjwUlzfTVgvxlcgWksFTSWI
	 32PwTTM1E/f59O8HtdiswdjSu5Zz81vUida5EaUiAzPqEhmKQSxbQipDDIM/yOWDxR
	 NS7fL9AZAs49foWBSDmuWJyMfCakho9JM3QocwPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/570] ALSA: hda/conexant: Fix headphone jack handling on Acer Swift SF314
Date: Mon, 13 Apr 2026 17:52:50 +0200
Message-ID: <20260413155831.892110630@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9a2b945a25d0a..2d653b73e6795 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -312,6 +312,7 @@ enum {
 	CXT_PINCFG_SWS_JS201D,
 	CXT_PINCFG_TOP_SPEAKER,
 	CXT_FIXUP_HP_A_U,
+	CXT_FIXUP_ACER_SWIFT_HP,
 };
 
 /* for hda_fixup_thinkpad_acpi() */
@@ -1042,6 +1043,14 @@ static const struct hda_fixup cxt_fixups[] = {
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
 
 static const struct snd_pci_quirk cxt5045_fixups[] = {
@@ -1091,6 +1100,7 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x1025, 0x0543, "Acer Aspire One 522", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x054c, "Acer Aspire 3830TG", CXT_FIXUP_ASPIRE_DMIC),
 	SND_PCI_QUIRK(0x1025, 0x054f, "Acer Aspire 4830T", CXT_FIXUP_ASPIRE_DMIC),
+	SND_PCI_QUIRK(0x1025, 0x136d, "Acer Swift SF314", CXT_FIXUP_ACER_SWIFT_HP),
 	SND_PCI_QUIRK(0x103c, 0x8079, "HP EliteBook 840 G3", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x807C, "HP EliteBook 820 G3", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x80FD, "HP ProBook 640 G2", CXT_FIXUP_HP_DOCK),
-- 
2.51.0




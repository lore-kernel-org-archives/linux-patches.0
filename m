Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90B22AF0E;
	Thu, 12 Dec 2024 15:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016712; cv=none; b=PGJdYD/0Q96js9QvJrmVR2z9VlJi3NLYNrpiiYeux1l/epq8CeLZpp5HvNw4o5ezgBKjxe9lopxdHBWNhduWJiwGA2m2zatGG/d06QUZevPvCmrCgkzN8tMjVw9Vqr+TgHvo0/JYB/RfCYrl9gjYqCxaFWGplLbNfVSD2YSRNCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016712; c=relaxed/simple;
	bh=lO7ytba74JbcTjNb7az6EqGpswuymYGe3DwUI2S9oWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dthpKFajxczGsCMwzQxMoxNa22KxfkG4o10P48Ide8OOvBkmmOoHrQ/ZcIrAX/HQ7/nWt4V4qUzU7AFh7C5c19dbb52hnTN91zeZfrtZEbFfBOn+fgPsExFlKZSP9dBO0M4SarJKFhwg/9gHZ5NU8u4FDEWpsX048g111Aj/C5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtuNHskm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtuNHskm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EF6C4CECE;
	Thu, 12 Dec 2024 15:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016712;
	bh=lO7ytba74JbcTjNb7az6EqGpswuymYGe3DwUI2S9oWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtuNHskm7yNAWbhLim8+IpXsh5hCSfmn7TK1oPy1Wb50shHDtjlp8w1arpdfrN/LH
	 6Kz12gktL8m9nSajhDRWpsYaxovyp6CcdPikKTcBT+Q7wk9hgJg0UG7z+047gzo56v
	 wkuKKBg8SR+gqF8miUYdJAbPslA+27u94DFzhPI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 277/466] ALSA: hda/conexant: Use the new codec SSID matching
Date: Thu, 12 Dec 2024 15:57:26 +0100
Message-ID: <20241212144317.730929628@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4df30976b73a2..2e9f817b948eb 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -828,23 +828,6 @@ static const struct hda_pintbl cxt_pincfg_sws_js201d[] = {
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
@@ -1009,8 +992,11 @@ static const struct hda_fixup cxt_fixups[] = {
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
 
@@ -1109,8 +1095,8 @@ static const struct hda_quirk cxt5066_fixups[] = {
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




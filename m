Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB483EDE5B;
	Tue, 12 May 2026 18:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609054; cv=none; b=obpECdxZwLcqK1E/+EBp8yxM4GkigAB1AoXUsjbgcckdUWKnj/wQUXgmFn60NuunhnhAomr2O9Nl1q1FuoA8kmbsfp+2n+2c82EmMyE+tPAS8c2qtOXUPudv1uLydgYIoxjP5AHPnPvBNHjD4Lz0iNdUBpbhUbLZ8YbENznH+8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609054; c=relaxed/simple;
	bh=N5ZIocmcLcdofUrD499do3pTI9xKC/2Mg1XD9Y18v8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mLlX03UvlT2w/BavSurRsoQufsB11yYmQiOSU8hdHundC9Evn2606nWhZHwNi4TUkbayM/ZO7LNZpFZoI1Qgf3Pe41dGGMtFE2HtIqyG3TT+zP0pO7Z9fVicsFTkQlfZlrBI7H2xGxWSVANCHBDIZ+CX46PdnyIDuPlKddtFn90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGVk/OOM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGVk/OOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9228C2BCC7;
	Tue, 12 May 2026 18:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609054;
	bh=N5ZIocmcLcdofUrD499do3pTI9xKC/2Mg1XD9Y18v8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGVk/OOMr9bts5HWbnRwil0ryFdHwxdBrq8NcKlVzhENyULckH+fVPITkfFkC1Bvz
	 6FEehBBjhAC38qZYjfh7Pm1qhbV3fVo+mOgt7/LGCwkpwucjfBtxD/opuC11c3Bxq2
	 2WSI9EuD7nHX1C3JQlPhy0Lw9gpszSxrACVpmGnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuriy Padlyak <yuriypadlyak@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 047/307] ALSA: hda/realtek: Fix speaker silence after S3 resume on Xiaomi Mi Laptop Pro 15
Date: Tue, 12 May 2026 19:37:22 +0200
Message-ID: <20260512173941.117129678@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuriy Padlyak <yuriypadlyak@gmail.com>

commit 92a8b5e2eff6920bf815cd6a80b088ec3fdf01a3 upstream.

The Xiaomi Mi Laptop Pro 15 (TM1905, subsystem 1d72:1905) ships with the
Realtek ALC256 codec on Intel Comet Lake PCH-LP. After S3 resume the
codec sets coefficient register 0x10 to 0x0220 instead of 0x0020 — bit 9
is erroneously set, which silences the internal speaker. Bluetooth and
HDMI audio are unaffected because they use different paths.

This is the same mechanism fixed for Clevo NJ51CU by commit edca7cc4b0ac
("ALSA: hda/realtek: Fix quirk for Clevo NJ51CU"), but the existing
ALC256_FIXUP_MIC_NO_PRESENCE_AND_RESUME also reconfigures pin 0x19 as a
front mic, which is wrong for this Xiaomi where pin 0x19 default is
0x411111f0 (disabled). Add a minimal fixup that only clears the stuck
coef bit, and add the Xiaomi SSID to the quirk table.

Verified by reading coef 0x10 with hda-verb after resume (returns
0x0220), writing 0x0020, and confirming the internal speaker resumes
output. With this fixup applied the bit is cleared on every codec init,
including post-resume.

Signed-off-by: Yuriy Padlyak <yuriypadlyak@gmail.com>
Cc: <stable@vger.kernel.org>
Tested-by: Yuriy Padlyak <yuriypadlyak@gmail.com>
Link: https://patch.msgid.link/20260429220903.14918-1-yuriypadlyak@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3397,6 +3397,19 @@ static void alc256_fixup_mic_no_presence
 	}
 }
 
+static void alc256_fixup_xiaomi_pro15_resume(struct hda_codec *codec,
+					     const struct hda_fixup *fix,
+					     int action)
+{
+	/*
+	 * On the Xiaomi Mi Laptop Pro 15 (TM1905, SSID 1d72:1905) the ALC256
+	 * codec sets coefficient 0x10 bit 9 to 1 after S3 resume, silencing
+	 * the internal speaker. Bluetooth and HDMI audio are unaffected.
+	 * Clear the bit so the speaker keeps working across suspend cycles.
+	 */
+	alc_update_coef_idx(codec, 0x10, 1<<9, 0);
+}
+
 static void alc256_decrease_headphone_amp_val(struct hda_codec *codec,
 					      const struct hda_fixup *fix, int action)
 {
@@ -4054,6 +4067,7 @@ enum {
 	ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
 	ALC233_FIXUP_NO_AUDIO_JACK,
 	ALC256_FIXUP_MIC_NO_PRESENCE_AND_RESUME,
+	ALC256_FIXUP_XIAOMI_PRO15_RESUME,
 	ALC285_FIXUP_LEGION_Y9000X_SPEAKERS,
 	ALC285_FIXUP_LEGION_Y9000X_AUTOMUTE,
 	ALC287_FIXUP_LEGION_16ACHG6,
@@ -6241,6 +6255,10 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
 	},
+	[ALC256_FIXUP_XIAOMI_PRO15_RESUME] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc256_fixup_xiaomi_pro15_resume,
+	},
 	[ALC287_FIXUP_LEGION_16ACHG6] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc287_fixup_legion_16achg6_speakers,
@@ -7751,6 +7769,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d72, 0x1905, "Xiaomi Mi Laptop Pro 15", ALC256_FIXUP_XIAOMI_PRO15_RESUME),
 	SND_PCI_QUIRK(0x1d72, 0x1945, "Redmi G", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1e39, 0xca14, "MEDION NM14LNL", ALC233_FIXUP_MEDION_MTL_SPK),



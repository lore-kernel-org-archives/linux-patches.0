Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3583A30567C;
	Thu, 30 Jul 2026 15:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424596; cv=none; b=cTNv8Xynq5/Lbnhf9OdDx1PI2uq7aDjL2W7FPy3uOJqBsKPJRXePsPlhMYLOj1E4d1alRmzVNB5/3S+MKrbL+kpO7oJowe9aZaSjktlY81v04kbkj3pUwYTX123CIzI5GIUAxlWpcDSOWsOiddIg3OvF8JW9yk5+qGYL8HRdnho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424596; c=relaxed/simple;
	bh=kkHsDF3Y1HPiuUKev4LyMBDBs9cuPqz7pD8jTkdcsDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggFUAMIIINZCI4he+UHcwfzzmnYFQI44XF4mIPa1Yil4twKco8cHwStSTPw6gquz9dHaAR7u4nAQCxdp0C+pVVvIgHs1cZed1sMVKXKF1XpWXxX5HMB0Dfyyq39FffNluus1VUbtaxOfSUnxGDEX2c3F6i8gXLyl7qLR0bf6nd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzMroXym; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzMroXym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3321F000E9;
	Thu, 30 Jul 2026 15:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424595;
	bh=VLD/YpRtfbsLUdkA/sGY6sHZaWibQ46CMipTVsr6uho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BzMroXymYZYMKmYgILjvlJ5jLt0f5PuXJt1Efj+AJOcu4FZDBgoon2ouTAAOFoCYN
	 c10h9PJR3GYPeCfaUlEKWWUj4lgv+GKEGTI0pH9Xie0UcvyzAUqabft4Jp8KAa2aQ2
	 M38MwaskxZsz+gELnlAgCp0+45gxjVqh1Fq68PDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Maksimov <nickstogramm@yandex.ru>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 447/675] ALSA: hda/realtek: Fix speakers on Lunnen Ground 14
Date: Thu, 30 Jul 2026 16:12:57 +0200
Message-ID: <20260730141454.639763960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Maksimov <nickstogramm@yandex.ru>

commit 5c3f8dac531b454bf67b6ee3c2aac89f0aaaef74 upstream.

The firmware on the Lunnen Ground 14 marks pin 0x1b as unused even
though the internal speakers are connected to it. As a result, the
speakers are not detected.

Add a pin configuration quirk for PCI subsystem ID 2782:a212 to configure
pin 0x1b as an internal speaker.

The pin configuration was tested on a Lunnen Ground 14 (DMI product LL4FA)
with an ALC269VC codec. The internal speakers and microphone work as
expected.

Cc: stable@vger.kernel.org
Signed-off-by: Nikita Maksimov <nickstogramm@yandex.ru>
Link: https://patch.msgid.link/20260720180214.73770-1-nickstogramm@yandex.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3742,6 +3742,7 @@ enum {
 	ALC269_FIXUP_DMIC_THINKPAD_ACPI,
 	ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13,
 	ALC269VC_FIXUP_INFINIX_Y4_MAX,
+	ALC269VC_FIXUP_LUNNEN_GROUND_14,
 	ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO,
 	ALC255_FIXUP_ACER_MIC_NO_PRESENCE,
 	ALC255_FIXUP_ASUS_MIC_NO_PRESENCE,
@@ -4183,6 +4184,13 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_LIMIT_INT_MIC_BOOST
 	},
+	[ALC269VC_FIXUP_LUNNEN_GROUND_14] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1b, 0x90170150 }, /* internal speaker */
+			{ }
+		},
+	},
 	[ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -7573,6 +7581,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x2782, 0x1705, "MEDION E15433", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x2782, 0x4900, "MEDION E15443", ALC233_FIXUP_MEDION_MTL_SPK),
+	SND_PCI_QUIRK(0x2782, 0xa212, "Lunnen Ground 14", ALC269VC_FIXUP_LUNNEN_GROUND_14),
 	SND_PCI_QUIRK(0x7017, 0x2014, "Star Labs StarFighter", ALC233_FIXUP_STARLABS_STARFIGHTER),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),



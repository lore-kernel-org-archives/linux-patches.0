Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495DB34DCE4;
	Thu, 30 Jul 2026 14:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422737; cv=none; b=t0mDQbKhyD+XxORXpbc1wNhr1StU6zmNVr5gUxOZ/GV8DWk3FL1KGy58cGK4mg0svVDAUDPfb4rx+hO2ZlcFuXx9bEcd+tPCdBVyaG4xIgrQg2hDJk9rUOXqpo72AbIbVxX/w/lBKEjswyZ9Qq99IWgHafFLU3sWMwyMynfKLhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422737; c=relaxed/simple;
	bh=j6vWoHy6DykNWX5UqPK8pKPM3r0GFs2urF13eVoluvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsRt6sf1TK6nSngvpvotXPcq+RbCziMgvG+0VhkVjYUeVvfopbdCp2cIGdQLZgJwkq2knYeTAmy3kD07w73eAITVY/BMJcZxuPgKke3AR+z3zTdkOuB0zIOLXdj/wQrADZiQz0bonEY/cx69Nia4eapnu9qaF1ndGGdBmsQZeDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DT7EtSpr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DT7EtSpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831691F000E9;
	Thu, 30 Jul 2026 14:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422736;
	bh=/F6LwMk7Lof93wE9aVd9G3SD36IvF3ceBSjHfQe0ddM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DT7EtSprrnMY5Y/JN9Aq93gxzeNtjbYTrK/stYybhIGNv14tofm2I20d+pKSMqHzb
	 ulj6YPzJzMogVLwGe/iCdkQtd38Is36GNkXr8D9QIqi2vqnDedNW0sd2rI8ok6XD4R
	 6ZjDZlaBAwUx8fyaoE3Tj/a5CjzGsJD4k7TeX/7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Maksimov <nickstogramm@yandex.ru>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 538/744] ALSA: hda/realtek: Fix speakers on Lunnen Ground 14
Date: Thu, 30 Jul 2026 16:13:31 +0200
Message-ID: <20260730141455.712024323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3891,6 +3891,7 @@ enum {
 	ALC269_FIXUP_DMIC_THINKPAD_ACPI,
 	ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13,
 	ALC269VC_FIXUP_INFINIX_Y4_MAX,
+	ALC269VC_FIXUP_LUNNEN_GROUND_14,
 	ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO,
 	ALC255_FIXUP_ACER_MIC_NO_PRESENCE,
 	ALC255_FIXUP_ASUS_MIC_NO_PRESENCE,
@@ -4345,6 +4346,13 @@ static const struct hda_fixup alc269_fix
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
@@ -7875,6 +7883,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x2782, 0x1705, "MEDION E15433", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x2782, 0x4900, "MEDION E15443", ALC233_FIXUP_MEDION_MTL_SPK),
+	SND_PCI_QUIRK(0x2782, 0xa212, "Lunnen Ground 14", ALC269VC_FIXUP_LUNNEN_GROUND_14),
 	SND_PCI_QUIRK(0x7017, 0x2014, "Star Labs StarFighter", ALC233_FIXUP_STARLABS_STARFIGHTER),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D391F7591;
	Tue,  3 Dec 2024 16:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242582; cv=none; b=lI3G8VU0ofaJ5QUa5eHFlX9S25x4moBtP6QonpPH7vvEvRjOpMlVebZPUhvHZ8lwq98oY8h/QslospoANZdHZjhunWVPk1Jtn9+NnoeZs0SHgpihho1zQAHbdgIhnBYwYuxMqqJNycNzvSWzfZ7H8v6QTa7t6pujeLdgMjKD9oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242582; c=relaxed/simple;
	bh=wyDxYWovDAxvHtI/3kzviVQM3OuGV1a3jaeo7qwKIg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmoS4fmpqnXgVvNO8tdnsTt95Xo37C0EMYCJ11bPdBnnJv01vc6brccMYy2iFlIZ4nLAeXZrTLfo5NhIZh0QSKAlYD4ZghD4rzvVOyb5nFp5glWPqG02re2GUrt6OOzDY51vNjEaMG/3pHBgYoJ0eyblKKOSLLwPhNl5pVDY/Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KEdnjsoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KEdnjsoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B736C4CECF;
	Tue,  3 Dec 2024 16:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242582;
	bh=wyDxYWovDAxvHtI/3kzviVQM3OuGV1a3jaeo7qwKIg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KEdnjsoXKMbU2SXI2kYy8iQoW4jqngp6cFzuWaKEDGub+IzygUAKEyJdc+DuQQskC
	 wOA1W1g8k+Sg91CzoB44BXqV+7+cn7Z4Ns2obqL4u2bbigohjbmL8dqNODGltMftUh
	 Bg5uirlBgxPCK9JW0SozzRB5Km7tDLx5NH7riAwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinesh Kumar <desikumar81@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 746/826] ALSA: hda/realtek: Fix Internal Speaker and Mic boost of Infinix Y4 Max
Date: Tue,  3 Dec 2024 15:47:53 +0100
Message-ID: <20241203144812.863893041@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Dinesh Kumar <desikumar81@gmail.com>

commit 5ebe792a5139f1ce6e4aed22bef12e7e2660df96 upstream.

Internal Speaker of Infinix Y4 Max remains muted due to incorrect
Pin configuration, and the Internal Mic records high noise. This patch
corrects the Pin configuration for the Internal Speaker and limits
the Internal Mic boost.
HW Probe for device: https://linux-hardware.org/?probe=6d4386c347
Test: Internal Speaker works fine, Mic has low noise.

Signed-off-by: Dinesh Kumar <desikumar81@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241125092842.13208-1-desikumar81@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7548,6 +7548,7 @@ enum {
 	ALC269_FIXUP_THINKPAD_ACPI,
 	ALC269_FIXUP_DMIC_THINKPAD_ACPI,
 	ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13,
+	ALC269VC_FIXUP_INFINIX_Y4_MAX,
 	ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO,
 	ALC255_FIXUP_ACER_MIC_NO_PRESENCE,
 	ALC255_FIXUP_ASUS_MIC_NO_PRESENCE,
@@ -8005,6 +8006,15 @@ static const struct hda_fixup alc269_fix
 		.chained = true,
 		.chain_id = ALC269_FIXUP_LIMIT_INT_MIC_BOOST
 	},
+	[ALC269VC_FIXUP_INFINIX_Y4_MAX] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x1b, 0x90170150 }, /* use as internal speaker */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC269_FIXUP_LIMIT_INT_MIC_BOOST
+	},
 	[ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -11022,6 +11032,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
+	SND_PCI_QUIRK(0x2782, 0x1701, "Infinix Y4 Max", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x2782, 0x4900, "MEDION E15443", ALC233_FIXUP_MEDION_MTL_SPK),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),



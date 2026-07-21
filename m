Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F1346AA81;
	Tue, 21 Jul 2026 15:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648006; cv=none; b=hXzGRTY71ZKEcZrf7JpTXl/NoocaNLQlK4EGFtdSX9nLbvZrESMHuvT/tWgheae8/F07/ysxOJSipmxSEobfABE1bPzc7W2pch+cPK0IQJse5CshLbT8xzi0pot4I13730knAOSr5+VGMOzN3LFUvf9mpGF+ti27+vIo3Gym5m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648006; c=relaxed/simple;
	bh=ajNnrreMfvfd/ZLzhCwnkQdYLzJAEy6AkbGnbStexxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWDbg/pZdpSJAjk7vSaichVzq7KiPwuzJJiJBJKTXkLzP4w21+2TDf/euawh20AMjFZoYgFbqtLRsjkfDWI2BCBXcl5ImvGZt1x6Utu4N7msY9f1PQZ5+pRC7vMlzWSPSr2FKwW/Y4f5Llz7I2VXFZ041CYGpfez0rPoJQjoVfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lV1e+nxt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lV1e+nxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460881F000E9;
	Tue, 21 Jul 2026 15:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648004;
	bh=ZN8xMSq3gq/gNrhZXjpqBNv2yxz1qoXZTERyCaODq/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lV1e+nxtolm6FHYCr7TkVRAQ0IC85do6TtzPgLNCxWdGW0aTlTGnSc9TcNITeJFl0
	 sT2GqSws3DQ9y9weAmswwVSgpkzcbEUItCxFNeA9/dxRGqGh1TYhL/D4cwERR3ZiwR
	 qSHCHYkrTQhyxlfEJ7IGJZ7ekZUWPayT6n80Y3Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Laine <damien.laine@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 0008/2077] ALSA: hda/realtek: Fix speakers on Legion Pro 7 16ARX8H with codec SSID 17aa:38a7
Date: Tue, 21 Jul 2026 16:54:41 +0200
Message-ID: <20260721152552.861823436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Damien Laine <damien.laine@gmail.com>

commit d35dfb6329accfe1cfa0b57e35214b5cbbe0f9ae upstream.

Some units of the Lenovo Legion Pro 7 16ARX8H (82WS) report codec
subsystem ID 17aa:38a7 instead of 17aa:38a8. Since only 38a8 has a
codec SSID quirk, these machines fall through to the PCI SSID match
17aa:386f (Legion Pro 7i 16IAX7) and get ALC287_FIXUP_CS35L41_I2C_2,
which probes the Cirrus amplifiers of the Intel variant. The TI
TAS2781 amplifier (ACPI TIAS2781:00) present on this AMD variant is
never bound and the internal speakers remain silent.

Add a codec SSID quirk for 17aa:38a7 pointing to
ALC287_FIXUP_TAS2781_I2C, mirroring the existing 38a8 entry.

Tested on a Legion Pro 7 16ARX8H (82WS, BIOS LPCN62WW): with the codec
SSID overridden to 17aa:38a8 via the HDA patch loader, the TAS2781
amplifier binds and the internal speakers work.

Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Laine <damien.laine@gmail.com>
Link: https://patch.msgid.link/20260712213708.1835469-1-damien.laine@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7723,6 +7723,7 @@ static const struct hda_quirk alc269_fix
 	HDA_CODEC_QUIRK(0x17aa, 0x386e, "Legion Y9000X 2022 IAH7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x386e, "Yoga Pro 7 14ARP8", ALC285_FIXUP_SPEAKER2_TO_DAC1),
 	HDA_CODEC_QUIRK(0x17aa, 0x38a8, "Legion Pro 7 16ARX8H", ALC287_FIXUP_TAS2781_I2C), /* this must match before PCI SSID 17aa:386f below */
+	HDA_CODEC_QUIRK(0x17aa, 0x38a7, "Legion Pro 7 16ARX8H", ALC287_FIXUP_TAS2781_I2C), /* this must match before PCI SSID 17aa:386f below */
 	SND_PCI_QUIRK(0x17aa, 0x386f, "Legion Pro 7i 16IAX7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3870, "Lenovo Yoga 7 14ARB7", ALC287_FIXUP_YOGA7_14ARB7_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3877, "Lenovo Legion 7 Slim 16ARHA7", ALC287_FIXUP_CS35L41_I2C_2),



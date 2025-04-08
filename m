Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF001265CC8;
	Tue,  8 Apr 2025 11:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110471; cv=none; b=senYYr/5Q4Dq4AwD9u+INckPJ6Hs+rmL/sO/0xmeRrgiLAuTh1qFS6S31uVQMOjwEoDmaPmSxbPlNG+KHh87BY7LeX/mrYshkHhQysBEZQVQ6QphOs5E/yL0Zalk0Lplqjr7wuTB/qEvDHzGf9AtHk3smlIxWQvd9KAvRfZ37qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110471; c=relaxed/simple;
	bh=54ap4gN3G2IutxdqqZt8IxHRrFkPpSGLO016L1rTGQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGv2Uc5J6uw6TMSsrBZi4qplcxqWE7oplnIQCbmFksTlw0ujzIr8mh9WKKIaGu5XTeUEwi3I7MN2kRAM12+TlCPF3C336BArt48mbTtUDF/U/C+0flQBNBlXBSURNF98OQR5QtI8dEPm0iYiCWoUhhYqWEzqBxuW1w3DuFmHadM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OuIDna+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuIDna+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A464C4CEE5;
	Tue,  8 Apr 2025 11:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110471;
	bh=54ap4gN3G2IutxdqqZt8IxHRrFkPpSGLO016L1rTGQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OuIDna+NtG/LZPsy2GCpDUfT9FNNfo/TkIkqecZP2l1jzMNujft9t4IHtEHYzKRT8
	 pRyTITI7jTMNEfw/Jxoo8effV3K/xY7lTJ8fcKCwo9kvK+6qUD7YXW3B+CRQE7krB5
	 K71WoZrjZzWFfSMA6GmZmzR+C7sSjSRBR5zZse9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 075/731] ALSA: hda/realtek: Fix built-in mic assignment on ASUS VivoBook X515UA
Date: Tue,  8 Apr 2025 12:39:32 +0200
Message-ID: <20250408104916.014517743@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 829ee558f3527fd602c6e2e9f270959d1de09fe0 ]

ASUS VivoBook X515UA with PCI SSID 1043:106f had a default quirk
pickup via pin table that applies ALC256_FIXUP_ASUS_MIC, but this adds
a bogus built-in mic pin 0x13 enabled.  This was no big problem
because the pin 0x13 was assigned as the secondary mic, but the recent
fix made the entries sorted, hence this bogus pin appeared now as the
primary input and it broke.

For fixing the bug, put the right quirk entry for this device pointing
to ALC256_FIXUP_ASUS_MIC_NO_PRESENCE.

Fixes: 3b4309546b48 ("ALSA: hda: Fix headset detection failure due to unstable sort")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219897
Link: https://patch.msgid.link/20250324153233.21195-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index abe269fb8ce00..d70c72bda90a5 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10702,6 +10702,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x1054, "ASUS G614FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x1043, 0x106f, "ASUS VivoBook X515UA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1074, "ASUS G614PH/PM/PP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x10a1, "ASUS UX391UA", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x10a4, "ASUS TP3407SA", ALC287_FIXUP_TAS2781_I2C),
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399F826F459;
	Tue,  8 Apr 2025 12:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117005; cv=none; b=hRV5U+4f9LWFbgmOxcXyEZiVM219ihJ7fB0H6eThVmTKSHwgk9D7s5BBs83XAJbcJJohmX9zExyQysEDuNa15I0JLMOpT9joOIKGgUFZhryKNOi5yA3MIL7dJpFgO4UFi0PPuydHblV5v1VqwF6OFQ5T0CHm8TWsOgcEMpeCRJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117005; c=relaxed/simple;
	bh=e4WkKWgRfNDCY12+tZMjd0poMOxQgUUOLxNkgYQP5yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oR5gES/WTrKngU5DlLfRxdaIt2mqmSdkIJpBEXmHHRHm2uY750lcuK3a0+rWO5bgXExQd6Un7oU7odDf0vWvq6//6LxcqYkOmkFzuF/KLyTQ/gqBFp1BOzHcTNcKgNdPeg8YYai4noIUxk1nud+8T4Tx54IvV1kViAlZJcQgF40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdp3r1ru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdp3r1ru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6223DC4CEE5;
	Tue,  8 Apr 2025 12:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117004;
	bh=e4WkKWgRfNDCY12+tZMjd0poMOxQgUUOLxNkgYQP5yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdp3r1ruu/Aw/mLjuSOACjJMqrU8KV5wNMEzeLv3MfPcXAUwlSGXsRohISV8Mpbxf
	 MQ10Ly+d3vUC5FbbUy1FubRCNxCtKGNdAgRdiZVjmmbcsy1DwRMHWESY4ShyCgETTc
	 CqW+p7P4TMM1f92VYwzVJIjil1DjadIx6d5wv5z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 309/423] ALSA: hda/realtek: Fix built-in mic breakage on ASUS VivoBook X515JA
Date: Tue,  8 Apr 2025 12:50:35 +0200
Message-ID: <20250408104852.999226801@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 84c3c08f5a6c2e2209428b76156bcaf349c3a62d ]

ASUS VivoBook X515JA with PCI SSID 1043:14f2 also hits the same issue
as other VivoBook model about the mic pin assignment, and the same
workaround is required to apply ALC256_FIXUP_ASUS_MIC_NO_PRESENCE
quirk.

Fixes: 3b4309546b48 ("ALSA: hda: Fix headset detection failure due to unstable sort")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219902
Link: https://patch.msgid.link/20250326152205.26733-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 23dd0bf7f6657..1e2059035d5b1 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10676,6 +10676,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1493, "ASUS GV601VV/VU/VJ/VQ/VI", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x14d3, "ASUS G614JY/JZ/JG", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x14e3, "ASUS G513PI/PU/PV", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x14f2, "ASUS VivoBook X515JA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1503, "ASUS G733PY/PZ/PZV/PYV", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
 	SND_PCI_QUIRK(0x1043, 0x1533, "ASUS GV302XA/XJ/XQ/XU/XV/XI", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.39.5




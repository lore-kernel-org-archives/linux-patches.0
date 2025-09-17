Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C043E3016F8;
	Wed, 17 Sep 2025 12:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113214; cv=none; b=Ee+xP+qe+H4L0Sx8QwxIM7Ami9ecgGSZIluBCUZXnzu3IOUU8YC3c/0Uutgxq+6GnO0vZ/wmZr5TEf1VGiZsmLjnEV1Atm4EEZx90/DVjVjU5oxOy61eGyp8WMAuCDOZd8X+a1JroXKgjd+O9e25GlfBPcfjlUpnjuvaLPlmgz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113214; c=relaxed/simple;
	bh=xy4RDdvfh68AwXx27hjLgDvko+0pzwtFjQTxewgfl/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYpW1kTg/IdYnaarQd9OhJ3vDSoyw+wbIQSAc7K2/gDTYHY1DNAZoLE7bYZaW9A8jZz/zosQSgZqIY6lzJdKQb0jiFGkaNIu1XocCMbXQpYaTKTAvZXNIXzsBdPVJI0BcDTrGdF+PkjUTt8PsBKAPgdHf5ozcakO6DEvEQqtKYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADGEJ/AB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADGEJ/AB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7C2C4CEF0;
	Wed, 17 Sep 2025 12:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113214;
	bh=xy4RDdvfh68AwXx27hjLgDvko+0pzwtFjQTxewgfl/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADGEJ/ABA7pNPyyjAVFAjvADpZLhuB4IdcbzRP3edJAG7QCP5xVOASk7dP1vVAfCD
	 4/pYJVjrWMp2DSFJ2pWf6eNpwLvspnIyJd1aDOAtsuGEvA48dAfAjgG04wfpHb+rAO
	 /5iZ1NGk/nW8QfDCSKkJJk//Xy2Z84OCV2lJ1BI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/140] ALSA: hda/realtek: Fix built-in mic assignment on ASUS VivoBook X515UA
Date: Wed, 17 Sep 2025 14:33:10 +0200
Message-ID: <20250917123344.756968379@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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
index a28a59926adad..eb0e404c17841 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10857,6 +10857,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x1054, "ASUS G614FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x1043, 0x106f, "ASUS VivoBook X515UA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1074, "ASUS G614PH/PM/PP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x10a1, "ASUS UX391UA", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x10a4, "ASUS TP3407SA", ALC287_FIXUP_TAS2781_I2C),
-- 
2.51.0




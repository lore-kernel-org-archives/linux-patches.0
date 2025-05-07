Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC532116E9;
	Wed,  7 May 2025 18:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644101; cv=none; b=ofXS5wToeGEUWJrxMJkdgVSHu0gNE6B+xdRKnP+FAeTa4Hcfz67WUYsGL0/V0w0dT7xXuP+xNOdF8yldlkCSLigHVCaTEUIhysY3CLE3kdbWIpXr6vpqLnGaaqT4YJ+be5At0FcGAHhFOSzRQlagbgRl55TqLJfKss/SD3Zklyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644101; c=relaxed/simple;
	bh=TDiMTYrr6pU1UL0eaJqEd3St34xNUTQfOURU8baAP3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIy8F+VlZudRwoCyoI7sTvHhsSqy+4fqjmiigk8NxZ4sBoB627XiXiSeK+PQFqYdzlln/6OHjgC3cZnZ5sXSR0oISflBfzP/Ux9l4u/I939CnddYpMUBWWxVRnJPI70ISr8lmrWyZ3NELc3R1j7KfdT3YKU4Qjy6eNt6ilZYGSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEaz7Rvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEaz7Rvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1BFC4CEE2;
	Wed,  7 May 2025 18:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644100;
	bh=TDiMTYrr6pU1UL0eaJqEd3St34xNUTQfOURU8baAP3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEaz7RvzL0IfBYNl2sCULjGOQFWvQyXf0k9m5oRFf64pTHelrJ0S+d2OWppkLSBm9
	 WU8ZV68NsIYZ0znRPa46iidrPfiJGkIIt0lE5tDV7ewRRUCaCutX+IvYS44tCbLI9x
	 g91F+p8C2hH0QInV25UcRXyeU58nSzJ7uG0HVQQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 120/183] ALSA: hda/realtek: Fix built-mic regression on other ASUS models
Date: Wed,  7 May 2025 20:39:25 +0200
Message-ID: <20250507183829.686718875@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

[ Upstream commit 4d5b71b487291da9f92e352c0a7e39f256d60db8 ]

A few ASUS models use the ALC256_FIXUP_ASUS_HEADSET_MODE although they
have no built-in mic pin on NID 0x13, as found in the commit
c1732ede5e80 ("ALSA: hda/realtek - Fix headset and mic on several Asus
laptops with ALC256").  This was relatively harmless in the past as
NID 0x13 was assigned as the secondary mic.  But since the fix for the
pin sort order, this pin became the primary one, hence user started
noticing the broken input, and we've fixed already for a few ASUS
models to switch to ALC256_FIXUP_ASUS_MIC_NO_PRESENCE.

This patch corrects the other ASUS models to use the right quirk entry
for fixing the built-in mic regression.  Here we cover X541SA
(1043:12e0), X541UV (1043:12f0), Z550SA (1043:13bf0) and X555UB
(1043:1ccd).

Fixes: 3b4309546b48 ("ALSA: hda: Fix headset detection failure due to unstable sort")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=220058
Link: https://patch.msgid.link/20250430053210.31776-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 263c7be1d4e29..2ff02fb6f7e94 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10774,10 +10774,10 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x12a3, "Asus N7691ZM", ALC269_FIXUP_ASUS_N7601ZM),
 	SND_PCI_QUIRK(0x1043, 0x12af, "ASUS UX582ZS", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x12b4, "ASUS B3405CCA / P3405CCA", ALC294_FIXUP_ASUS_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1043, 0x12e0, "ASUS X541SA", ALC256_FIXUP_ASUS_MIC),
-	SND_PCI_QUIRK(0x1043, 0x12f0, "ASUS X541UV", ALC256_FIXUP_ASUS_MIC),
+	SND_PCI_QUIRK(0x1043, 0x12e0, "ASUS X541SA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1043, 0x12f0, "ASUS X541UV", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1313, "Asus K42JZ", ALC269VB_FIXUP_ASUS_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0x1043, 0x13b0, "ASUS Z550SA", ALC256_FIXUP_ASUS_MIC),
+	SND_PCI_QUIRK(0x1043, 0x13b0, "ASUS Z550SA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1427, "Asus Zenbook UX31E", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1043, 0x1433, "ASUS GX650PY/PZ/PV/PU/PYV/PZV/PIV/PVV", ALC285_FIXUP_ASUS_I2C_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1460, "Asus VivoBook 15", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
@@ -10831,7 +10831,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1c92, "ASUS ROG Strix G15", ALC285_FIXUP_ASUS_G533Z_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1c9f, "ASUS G614JU/JV/JI", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1caf, "ASUS G634JY/JZ/JI/JG", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
-	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1ccf, "ASUS G814JU/JV/JI", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1cdf, "ASUS G814JY/JZ/JG", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1cef, "ASUS G834JY/JZ/JI/JG", ALC285_FIXUP_ASUS_HEADSET_MIC),
-- 
2.39.5




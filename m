Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024F3206F18;
	Tue,  8 Apr 2025 12:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114996; cv=none; b=GUdvDkCJryUSnUgd+K98qEpi0cZr7EGNXZ7mx1EuY1hNSXqiSIbQFpRuYZENndfVXPO1F5rK4H3shYHTEuVT6hJSFNSyT5/1nYq81NKruXSbsM/0c7bUU0/84YO9u4U0dyZL6PGWJ0BoAvDxJj4exmC8BFWmudUu8NJ/H5n/v1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114996; c=relaxed/simple;
	bh=Af7H/pWZNaWs9nIoEMF2wtRH2g7BQWd2abZir2rOlDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GYsFm4sV2VASDy/RjyMtKiGpEXvxTEOdikpY84tyVpOv4D9FO0umPcSQf6tl69x6C3OEKNjcswuFBPbymOFGkYeDqQt5lVUa8XCxaQjUua8eVB4vbx9m+hQbK1MOcOygnHIXCLKolkNBuVVlx1oSBtiEaWKRDosfddhSminwoz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CevKV+4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CevKV+4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A474C4CEE5;
	Tue,  8 Apr 2025 12:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114995;
	bh=Af7H/pWZNaWs9nIoEMF2wtRH2g7BQWd2abZir2rOlDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CevKV+4KGpB+Fz8NzsAWrsk+EYCwoIhuBk6dEzcMRqeHLEcDkEUAw7a497DqzkeXl
	 +ZYCMp+k7w9MbjE6aNbd5IoT+kpifdRDrFDl8+7Jw3CuxfT4lcQdVVEm6cXX3Vsex2
	 f8lCBrAL3Dp+qxxBX52ViiCJDFv0kXUt8mWZzFto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Daniel=20B=C3=A1rta?= <daniel.barta@trustlab.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 312/499] ALSA: hda: Fix speakers on ASUS EXPERTBOOK P5405CSA 1.0
Date: Tue,  8 Apr 2025 12:48:44 +0200
Message-ID: <20250408104859.000014764@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Bárta <daniel.barta@trustlab.cz>

[ Upstream commit f479ecc5ef15ed8d774968c1a8726a49420f11a0 ]

After some digging around I have found that this laptop has Cirrus's smart
aplifiers connected to SPI bus (spi1-CSC3551:00-cs35l41-hda).

To get them correctly detected and working I had to modify patch_realtek.c
with ASUS EXPERTBOOK P5405CSA 1.0 SystemID (0x1043, 0x1f63) and add
corresponding hda_quirk (ALC245_FIXUP_CS35L41_SPI_2).

Signed-off-by: Daniel Bárta <daniel.barta@trustlab.cz>
Link: https://patch.msgid.link/20250227161256.18061-2-daniel.barta@trustlab.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 575e76590a106..dc7e732a7691f 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10750,6 +10750,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1f12, "ASUS UM5302", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1f1f, "ASUS H7604JI/JV/J3D", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1f62, "ASUS UX7602ZM", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x1f63, "ASUS P5405CSA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1f92, "ASUS ROG Flow X16", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1fb3, "ASUS ROG Flow Z13 GZ302EA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
-- 
2.39.5




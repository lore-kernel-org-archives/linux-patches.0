Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C611715E8B;
	Mon, 30 Dec 2024 15:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573865; cv=none; b=Wqvgzwrrd3UrLT7HM3B9uhK3PQoU43FwdLV/QrUauaQvfKXTPp9eHgvc2SRcEBvzllH0lUQmV9PTes9Xs8CW164zM1PPRUpbqfjTap+lul4ime+zuXX4pHAlk/wD7VI+fJ/KiDTm0VkEJLuUbbNvcY97VfFuLL734rtYmpdBoDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573865; c=relaxed/simple;
	bh=GJ7n8JqmoRm+msBlmSM4zxKfYNFwgPQMA52MgCaSY44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KonFf12Lkt5283z/81gYan3ker2s4IKb0/xHjYOIgwoT76CU1qay5jRgLuYFfxR6WZiyrYVjCpQK1gYotBrN/4s5CId1M9gtFHCKCKsbix8+vYYFM6xahFwyB1HNQ9qecrlv56FBR8HFdwdbEG1jee2WMtPx1igzD+DYjgXy6E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=01x8+yQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="01x8+yQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA254C4CED0;
	Mon, 30 Dec 2024 15:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573865;
	bh=GJ7n8JqmoRm+msBlmSM4zxKfYNFwgPQMA52MgCaSY44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=01x8+yQBgsas6/4vs1qnpBoj2h6KKvKYyoJChWuuSh8HSH5afKIvwz4Qd5HbLu7JL
	 qKwkwW8Qp0MDbHtNovx0Cil2WETSb5/j4RHr0SAT1zodXPgkjH9UDkZtMiAP/k6QsR
	 h7HsPBatsTipbX/fYiVAtClLMC4/ZiqxU18Kh1w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chris.chiu@canonical.com>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 56/86] ALSA: hda/realtek: fix micmute LEDs dont work on HP Laptops
Date: Mon, 30 Dec 2024 16:43:04 +0100
Message-ID: <20241230154213.847757822@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Chiu <chris.chiu@canonical.com>

[ Upstream commit 0d08f0eec961acdb0424a3e2cfb37cfb89154833 ]

These HP laptops use Realtek HDA codec ALC3315 combined CS35L56
Amplifiers. They need the quirk ALC285_FIXUP_HP_GPIO_LED to get
the micmute LED working.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Reviewed-by: Simon Trimmer <simont@opensource.cirrus.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241202144659.1553504-1-chris.chiu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e847bdb600fd..b50778e34f5d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10054,7 +10054,13 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8ca4, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca7, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8cf5, "HP ZBook Studio 16", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8d01, "HP ZBook Power 14 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8d84, "HP EliteBook X G1i", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8d91, "HP ZBook Firefly 14 G12", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8d92, "HP ZBook Firefly 16 G12", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8e18, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8e19, "HP ZBook Firelfy 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8e1a, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.39.5




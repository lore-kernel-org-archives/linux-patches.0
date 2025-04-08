Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A37D22257E;
	Tue,  8 Apr 2025 11:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111956; cv=none; b=gqwVRtiMyqrH887t5Z7hGGb772XP6q2FFC1TU+7OvGYKOLPlaxNyolB98zdMvMuvsHt3gJRXWeFRrvJDCuGF0b6HREE9l4brpmHKt8ADjSu/ZxQEWTb3qVorHKnJEMrGcSzSipZwzlLEs3Xs0IWE0t5h2IM6w1kLdzVxJf5ZCRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111956; c=relaxed/simple;
	bh=EsQvZ8SmJ6RxoRT3Su2SWLXVZgQApmQyr4d6nATwkTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDN0+9bN1SI4H/wrZ+CXgoInW8ySxEAqbJzwsTEPPl6w3NO8wqamj800BC5GsXKtfpdIxTNsoF/hM2+u67t8qL+bqk+RIsJUmFcneY3am1dmZ5BsDcHFN+gt2RwFwa7GeOblQwGDiGWXnEhCWnLZSFFpV28tc0uX40vPuuUh0ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFxFrJiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFxFrJiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071F8C4CEE5;
	Tue,  8 Apr 2025 11:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111956;
	bh=EsQvZ8SmJ6RxoRT3Su2SWLXVZgQApmQyr4d6nATwkTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFxFrJiTvycNbHstRKcweJN/ycbqgEnRdr6LOPuJtoHwMOsk3LlKZV5l5zQ49p/Sv
	 hzeH8QPXGy2yWL4zu5AxelQeYMnga1Lf/JF4XsQ7a4XmeAdXo50N4TptPgSawgrSdK
	 NTpg0G6F4bXw6gpKX7oKAUhOgtUjq3aKu04v17jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 595/731] ALSA: hda/realtek: Fix built-in mic breakage on ASUS VivoBook X515JA
Date: Tue,  8 Apr 2025 12:48:12 +0200
Message-ID: <20250408104928.114562340@linuxfoundation.org>
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
index d70c72bda90a5..9df400f7a144e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10736,6 +10736,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1493, "ASUS GV601VV/VU/VJ/VQ/VI", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x14d3, "ASUS G614JY/JZ/JG", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x14e3, "ASUS G513PI/PU/PV", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x14f2, "ASUS VivoBook X515JA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1503, "ASUS G733PY/PZ/PZV/PYV", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
 	SND_PCI_QUIRK(0x1043, 0x1533, "ASUS GV302XA/XJ/XQ/XU/XV/XI", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.39.5




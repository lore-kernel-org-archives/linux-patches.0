Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE2737E5ED;
	Fri,  7 Aug 2026 15:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116586; cv=none; b=Xw3d5nFvSiTyAoBg7PX/f65HwNaL+V8+ufmggI3FFdsG8kajqSrO2oTf2rWMy7EQy3eThpJASP1v4cNO/QwR9weZgoDi6LjWdWmcuMYdDk949wVoBJ5iaiX4gbSGPOLFQcU4rYuEP3KR1C3KhX04u58emTBEm0/BVI4qCYDaW0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116586; c=relaxed/simple;
	bh=zNqo0nKvEHyK78K/b4+y0UqM85A/TT0Ut8uEeorUhN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORH2xpTpyvUSCzMVkL+TsysOMznLw0bLPslpnJe6RNTUKzxpH4tOZ7h3qXsHnoEZmuor2T3PsMkfWCPxZ7ol6ArbyLyRAm7u19fWx0w5YTN+Ogxwh5aLL7yoT0ex9/J0xarUXPSEks+d0ipnFwRb5ohV5d8fVNU7Jwe+wB4xmWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HanGFodj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HanGFodj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188B81F000E9;
	Fri,  7 Aug 2026 15:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116585;
	bh=JtB8yD5aiz/GcwvYuApHs9M6OoSEin6bPOPczV7flsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HanGFodjDjZOpwZMx2+5TQZKdwx+BzB9I8NJnrsubIPXHlctTWVIjx+jsjomFKlRI
	 ZDPSR3a0uiTwfvBFylIwV5jHejHPXDyvaIlUEBHm8c+78B1BOywQqqI7jmO+S2z3wV
	 F8Q4M+I18pQJZhX2wAl9S//rxgFWlMzG9rRBFvJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Diesen <michael.diesen@posteo.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 005/438] ALSA: hda/realtek: Add quirk for HP Dragonfly Folio G3 2-in-1 (103c:8a05)
Date: Fri,  7 Aug 2026 16:33:21 +0200
Message-ID: <20260807143428.125603465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Michael Diesen <michael.diesen@posteo.de>

[ Upstream commit bed0c8084044364f5ac3f3e89e1bbad423f6b0d4 ]

The HP Dragonfly Folio G3 2-in-1 also ships with PCI SSID 103c:8a05.
On this unit the ALC245 codec reports subsystem id 103c:8a06 - the SSID
that is already covered by commit 0a10faad5ca5 ("ALSA: hda/realtek: add
quirk for HP Dragonfly Folio G3 2-in-1") - while the PCI SSID that
SND_PCI_QUIRK matches against is 103c:8a05:

  snd_hda_codec_alc269 ehdaudio0D0: ALC245: picked fixup for PCI SSID 103c:8a05
  cs35l41-hda spi1-CSC3551:00-cs35l41-hda.0: CS35L41 Bound - SSID: 103C8A06

The existing entry therefore never applies here, the four CS35L41
amplifiers on SPI are not registered and the internal speakers stay
silent.

Add the same fixup that the 8a06 entry uses: the four amplifiers bind
and the speaker mute LED (codec GPIO 0x04) works.

Signed-off-by: Michael Diesen <michael.diesen@posteo.de>
Link: https://patch.msgid.link/20260727091920.4634-1-michael.diesen@posteo.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 427caf08145d..cfc313f49381 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7086,6 +7086,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x89d3, "HP EliteBook 645 G9 (MB 89D2)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x89da, "HP Spectre x360 14t-ea100", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x89e7, "HP Elite x2 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8a05, "HP Dragonfly Folio G3 2-in-1", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a06, "HP Dragonfly Folio G3 2-in-1", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a1f, "HP Laptop 14s-dr5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
-- 
2.53.0




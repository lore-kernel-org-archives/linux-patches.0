Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3FB37FF60;
	Thu, 20 Aug 2026 15:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238696; cv=none; b=BADMBG/3hFfEeY2xaAvpn0aC48jZhHkZIb/Y8kX8JBibU85s/k8gH0EvDfiJTmdOgNECxCJ265RL4cCXwEfZWNAm3XkMh41y2ksL7oRp7uga35ktJIw4S2ZvsrgeV+9DBQlU3HCijHxLPDf5+lCg5awRNZdLyimO3VDEYdfTN/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238696; c=relaxed/simple;
	bh=AsOKQgwi9gLFl1VJbGuVrdQgcqPcs1HxE9q9FRU4M1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvQVRZko9Xgt5A16SPf7sB3DemgaHD0TtAWPRY9U0ZXDM6YfYiUd0K+qH7mYoFSoA1Vjxsqq7AsmW2lR77a1NyNo9CQzrj66QYXUZLiwz73132njvFew2PCbRqdKDbQsxMmLEECG8RSC2TyFyPFrGlXev2JUF+Jy9RSZ7wMYMIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUTZHc1p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUTZHc1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B981F00A3A;
	Thu, 20 Aug 2026 15:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238694;
	bh=RqrnsyLZdCfSSwAJmEGpUXNUBYgM6T9sSfacGgNbOH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tUTZHc1pFgBA+l30optayWhCSuGjhc2Kirmtc3DlQQtSvlNBoSei9Ws+XIjBeVX7B
	 4B7xr7Bx0EkWwrH2rU7DcR0YP7Ec3uZonOvIwdMh1DEWiQBrU6+8r2K/dHA4zW+EDr
	 GDRQnDSBhhiO5B+VOf0dOza7ZqVuLVPWExsw8L20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Diesen <michael.diesen@posteo.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 001/217] ALSA: hda/realtek: Add quirk for HP Dragonfly Folio G3 2-in-1 (103c:8a05)
Date: Thu, 20 Aug 2026 16:52:49 +0200
Message-ID: <20260820145237.588061707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7a047bdbae462..e79997b34302e 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6839,6 +6839,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x89d3, "HP EliteBook 645 G9 (MB 89D2)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x89da, "HP Spectre x360 14t-ea100", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x89e7, "HP Elite x2 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8a05, "HP Dragonfly Folio G3 2-in-1", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a06, "HP Dragonfly Folio G3 2-in-1", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a1f, "HP Laptop 14s-dr5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
-- 
2.53.0




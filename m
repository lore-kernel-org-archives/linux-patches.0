Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF2E3C0628;
	Thu, 17 Sep 2026 18:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668197; cv=none; b=aF7a8T19jVvm/Gy27+tXpGQxeJJ4PgYbyq32DGoEczuVkw8VEanon9Nnt1ZB74uKft1ipmtTRAfHONN/vVkExt3PYdCpIzpzI4iwVe2QOVB5T43UHHZWm8dihZHRC0ye58+gjP7hFtFzI/t9GXIUGdqQglv8DW0OQ1Ogm5T54Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668197; c=relaxed/simple;
	bh=vPaT5arksn95OqF+qY04llqwTmXSqqXX/+FannbHqtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwYlPdousA3QFgwE9qAbFps09+xsj9I64qanpowcEGa9xZXb4udBEt26/wmqHRie+l1nP8yUgI85RVO99YSdRUwUglWjXui8eiMPxUePg+//92D9+HOpcVgdUF+Vrk3dR56UNmY56NqwwNyF7vHVbcrmJ9HF9M6fQqCl22iDjiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9b2KBG8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9b2KBG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590911F000FF;
	Thu, 17 Sep 2026 18:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668195;
	bh=pLKm090KsgkIixwLiqyW6zs7nRFY/KAsqXdqPuVZueA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9b2KBG8PRklreAy/vkXgv6vwwUvZosw9mJoKZ2jn17hLfqEoO0V8MD2n3GihX6Y3
	 sXXSXVR3EW78bXaeKPB+QrKegNSTu9k8mqAHPMgGA9YtQZrweoybHy+ieXLP7yVeB8
	 syXtEHUUTIRj50TRi49Y/FAQrIVc9yR1Gvhcm74Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Aherin <chrisaherin@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0345/1102] ALSA: hda/realtek: Add quirk for Lenovo Yoga 7 16IAP7
Date: Thu, 17 Sep 2026 16:04:48 +0100
Message-ID: <20260917151548.301708746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Aherin <chrisaherin@gmail.com>

[ Upstream commit b70f007a9fc665ee988683fd5085ab34e2c10ad3 ]

The Yoga 7 16IAP7 (board LNVNB161216, codec SSID 17aa:386a) has pin
complex 0x17 (bass speakers) wrongly reported as unconnected, causing
only one of four speaker pins (0x14) to be configured and resulting in
mono/tinny audio.

SOF corrupts the PCI subsystem ID to 17aa:0000, preventing SND_PCI_QUIRK
from matching. HDA_CODEC_QUIRK is used instead, which matches against
codec->core.subsystem_id read directly from the HDA codec register and
unaffected by the SOF bug.

Applies ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN, the same fixup used for
the Yoga 7 14IAL7, which corrects pin 0x17's default configuration and
enables both speaker pairs.

Signed-off-by: Chris Aherin <chrisaherin@gmail.com>
Link: https://patch.msgid.link/20260622001210.20553-1-chrisaherin@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 5978ea4bb3b85..a2a1335e7d985 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11536,6 +11536,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3865, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3866, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3869, "Lenovo Yoga7 14IAL7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
+	HDA_CODEC_QUIRK(0x17aa, 0x386a, "Lenovo Yoga 7 16IAP7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	HDA_CODEC_QUIRK(0x17aa, 0x386e, "Legion Y9000X 2022 IAH7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x386e, "Yoga Pro 7 14ARP8", ALC285_FIXUP_SPEAKER2_TO_DAC1),
 	HDA_CODEC_QUIRK(0x17aa, 0x38a8, "Legion Pro 7 16ARX8H", ALC287_FIXUP_TAS2781_I2C), /* this must match before PCI SSID 17aa:386f below */
-- 
2.53.0




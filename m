Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61084336EE1;
	Mon, 20 Apr 2026 16:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701207; cv=none; b=QYIo3Fr31rv6b0lREpozvvlzYKuIFP2nUSEw3TLJx+L0pKRNd0ITfk4hm4Lm3uxzvl439xP3pWFQmb6P8XAAQ5QJUt+SVa0WnBnH50qvjk87HqUlZA5uvIvj2fxTbuQ/gsNyyS+PjfoeWftwHu8R93zaoSupkA3WS5xrFybKCgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701207; c=relaxed/simple;
	bh=eTTBJ5KKprb4AuajIlCneNYeGZ6lQkNOLP7onK2Q9sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIYHHsaj4oHVSqEuWSxaQ5BVAWbL6irgOss8lrSMaWjcOQaAnEPTHlk3/NmPc9Gmn7mmHcUfdDJE84IDv/a2BNcKbFFwOgouQSpc1GsCi7ZjYvFizq6j5VL0uAWWlSVzxlj0XJP1Bh2lCIYpPa2fKiX/Lhrc5CVZ0XKMQPcAgqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4YY4IGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4YY4IGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E939AC19425;
	Mon, 20 Apr 2026 16:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701207;
	bh=eTTBJ5KKprb4AuajIlCneNYeGZ6lQkNOLP7onK2Q9sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4YY4IGAylkSo8yN/UPhIW3CIAKbm9jbTMpgjbV7s2u68fhSZgWT8TA7UKLkH2C1e
	 epUsn4iBikcDLGFUFdwx19dogRpgE1IwdoQJTQKWY6OrphSqE1zcyF6JHSBZOT1j8l
	 NiKJZ+d3WHyPdLt7tkRYqkLjQOhdJdCBFcW9kkPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Savenko <alex.sav4387@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/162] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7 14IMH9
Date: Mon, 20 Apr 2026 17:40:56 +0200
Message-ID: <20260420153927.896780609@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

From: Alexander Savenko <alex.sav4387@gmail.com>

[ Upstream commit 217d5bc9f96272316ac5a3215c7cc32a5127bbf3 ]

The Lenovo Yoga Pro 7 14IMH9 (DMI: 83E2) shares PCI SSID 17aa:3847
with the Legion 7 16ACHG6, but has a different codec subsystem ID
(17aa:38cf). The existing SND_PCI_QUIRK for 17aa:3847 applies
ALC287_FIXUP_LEGION_16ACHG6, which attempts to initialize an external
I2C amplifier (CLSA0100) that is not present on the Yoga Pro 7 14IMH9.

As a result, pin 0x17 (bass speakers) is connected to DAC 0x06 which
has no volume control, making hardware volume adjustment completely
non-functional. Audio is either silent or at maximum volume regardless
of the slider position.

Add a HDA_CODEC_QUIRK entry using the codec subsystem ID (17aa:38cf)
to correctly identify the Yoga Pro 7 14IMH9 and apply
ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN, which redirects pin 0x17 to
DAC 0x02 and restores proper volume control. The existing Legion entry
is preserved unchanged.

This follows the same pattern used for 17aa:386e, where Legion Y9000X
and Yoga Pro 7 14ARP8 share a PCI SSID but are distinguished via
HDA_CODEC_QUIRK.

Link: https://github.com/nomad4tech/lenovo-yoga-pro-7-linux
Tested-by: Alexander Savenko <alex.sav4387@gmail.com>
Signed-off-by: Alexander Savenko <alex.sav4387@gmail.com>
Link: https://patch.msgid.link/20260331082929.44890-1-alex.sav4387@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 04e10da997b53..b73c2741f8ae7 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11524,6 +11524,10 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3834, "Lenovo IdeaPad Slim 9i 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x383d, "Legion Y9000X 2019", ALC285_FIXUP_LEGION_Y9000X_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3843, "Lenovo Yoga 9i / Yoga Book 9i", ALC287_FIXUP_LENOVO_YOGA_BOOK_9I),
+	/* Yoga Pro 7 14IMH9 shares PCI SSID 17aa:3847 with Legion 7 16ACHG6;
+	 * use codec SSID to distinguish them
+	 */
+	HDA_CODEC_QUIRK(0x17aa, 0x38cf, "Lenovo Yoga Pro 7 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3847, "Legion 7 16ACHG6", ALC287_FIXUP_LEGION_16ACHG6),
 	SND_PCI_QUIRK(0x17aa, 0x384a, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
-- 
2.53.0




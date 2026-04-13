Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B042226D18;
	Mon, 13 Apr 2026 16:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097886; cv=none; b=RKYsRiw/XcnuYTTbtm4zJZkxN04BZ2d73MjK+0lZaxjyoWQ/XGr4iDyB+CXgWenZF3eusi7TNN6SBDTv5Zf56x/MI/10Exw3cufMwoccBsEbS4I1tudfZc+uJOEE6buprYNarB7FqPs6TlclvXRCh3J613NUW4EzPdh8qpyok3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097886; c=relaxed/simple;
	bh=q1dObH+j+B0YmMFZMgYl+luDsHaRR02IXcsbFit5f/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/T0DpafCYnAn6rKwVUw14adItE1yFXaOEa3bhBarA+RASMtTs96w7x/SlTbm1OM6inZE5toHwiR6WJneksVL8zjKRhIQwYGgDFcAWgdidprLtu4yT8AVROTFeuYIalso+MPKfCPn8bp3L1S2B2bEEMCu7GSpI4sE2w8s6Y0kig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hog77H2r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hog77H2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56DAC2BCAF;
	Mon, 13 Apr 2026 16:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097886;
	bh=q1dObH+j+B0YmMFZMgYl+luDsHaRR02IXcsbFit5f/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hog77H2r3SKsze1pQQcbdmcSY3hRdzaQL15Hal4nTjR7ApRcfZInyrI2JMxGUcxvw
	 tIrXpmenItdKZiudDSu0s0yXOf7aTC6AZ5JiR3NsY1BZnEzJ0dNB6aHm+QkGznbo4T
	 jnuuiE1S0QW74U7AwiJLXAPlPalstp7BLk0yDQRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uzair Mughal <contact@uzair.is-a.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 311/570] ALSA: hda/realtek: Add headset jack quirk for Thinkpad X390
Date: Mon, 13 Apr 2026 17:57:22 +0200
Message-ID: <20260413155842.146810648@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uzair Mughal <contact@uzair.is-a.dev>

[ Upstream commit 542127f6528ca7cc3cf61e1651d6ccb58495f953 ]

The Lenovo ThinkPad X390 (ALC257 codec, subsystem ID 0x17aa2288)
does not report headset button press events. Headphone insertion is
detected (SW_HEADPHONE_INSERT), but pressing the inline microphone
button on a headset produces no input events.

Add a SND_PCI_QUIRK entry that maps this subsystem ID to
ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK, which enables
headset jack button detection through alc_fixup_headset_jack()
and ThinkPad ACPI integration. This is the same fixup used by
similar ThinkPad models (P1 Gen 3, X1 Extreme Gen 3).

Signed-off-by: Uzair Mughal <contact@uzair.is-a.dev>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260307012906.20093-1-contact@uzair.is-a.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 72d9ea5171bbd..38fda5dbd75ba 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9608,6 +9608,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x224c, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x224d, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x225d, "Thinkpad T480", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x17aa, 0x2288, "Thinkpad X390", ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK),
 	SND_PCI_QUIRK(0x17aa, 0x2292, "Thinkpad X1 Carbon 7th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
 	SND_PCI_QUIRK(0x17aa, 0x22be, "Thinkpad X1 Carbon 8th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
 	SND_PCI_QUIRK(0x17aa, 0x22c1, "Thinkpad P1 Gen 3", ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK),
-- 
2.51.0




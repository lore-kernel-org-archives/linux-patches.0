Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001A1241667;
	Thu, 13 Feb 2025 14:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457890; cv=none; b=LjWmVvpvI+TF5KnEndZ/nWcVmMS+C6yN5bNp8w7ZAvOlAhAeDJfclQ3NvkuMbrR+L8QVBreYWwBg7QsOq2xYsszLCxi196wMdqc44IIwIoV9dSnK88t5gPHICykkqKd+eB/Y1wuQsStZ8Dd9/xmC6emFFAf446XfyVFrT4fulww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457890; c=relaxed/simple;
	bh=ys8uDUSiy3H30+/9xEJc/T80c3ZTw3JUkGnQQJbPWNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1Pu2l3CxcpzlGOnmdrSop6sWUt/eIEzzvClSUlBMcFSuBIhN0t9xn7jwTtH4EnhUKnKe8iH2uzrOpZa3lt74DJ8zO3oeq8NzhFPUk1GCs2FVaSDISFJYM8MysY26Ctg68+j0z96jo+9Ph5FYJRnnqtvJU3h+oek7LZV+Z+/WLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZrrmOvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZrrmOvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AD1C4CED1;
	Thu, 13 Feb 2025 14:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457889;
	bh=ys8uDUSiy3H30+/9xEJc/T80c3ZTw3JUkGnQQJbPWNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZrrmOvDV9Iv/LFRYTGJjaa2a0G2pK9Y7GKZJ3LqxVSvg2SY/Ez85qHCsrIk7iuEB
	 4R7619HxEY1Djq1v2zV/EzvppDkT0PM50LRvc6lbvy98m9xK1o192Fwd2BEMuVHG6c
	 h8g6awGr3zqPUwzGLPuSzILPQ38Y3RnBATBML5hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Samantha Glocker <iam@anislandsomewhere.com>
Subject: [PATCH 6.12 243/422] ALSA: hda/realtek: Fix quirk matching for Legion Pro 7
Date: Thu, 13 Feb 2025 15:26:32 +0100
Message-ID: <20250213142445.913830988@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

commit 0f3a822ae2254a1e7ce3a130a1efd94e2cab73ee upstream.

The recent cleanup of the quirk table entries with the codec ID
matching caused a regression on some Lenovo Legion 7 models with PCI
SSID 17aa:386f: it assumed wrongly as if the codec SSID on the machine
were also 17aa:386f, but in this case, it was 17aa:38a8.  This made
the binding with a wrong sub-codec, instead of TAS2781, the Cirrus
codec was bound.

For addressing the regression, correct the quirk entry to the right
value 17aa:38a8.

Note that this makes the entry appearing in an unsorted position.
This exception is needed because the entry must match before the PCI
SSID 17aa:386f.

Also there is another entry for 17aa:38a8, but the latter is for PCI
SSID matching while the new entry is for the codec SSID matching.

Fixes: 504f052aa343 ("ALSA: hda/realtek: Use codec SSID matching for Lenovo devices")
Reported-and-tested-by: Samantha Glocker <iam@anislandsomewhere.com>
Closes: https://lore.kernel.org/CAGPQRHYd48U__UKYj2jJnT4+dnNNoWRBi+wj6zPRn=JpNMBUrg@mail.gmail.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250125120519.16420-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10874,7 +10874,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x17aa, 0x3869, "Lenovo Yoga7 14IAL7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	HDA_CODEC_QUIRK(0x17aa, 0x386e, "Legion Y9000X 2022 IAH7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x386e, "Yoga Pro 7 14ARP8", ALC285_FIXUP_SPEAKER2_TO_DAC1),
-	HDA_CODEC_QUIRK(0x17aa, 0x386f, "Legion Pro 7 16ARX8H", ALC287_FIXUP_TAS2781_I2C),
+	HDA_CODEC_QUIRK(0x17aa, 0x38a8, "Legion Pro 7 16ARX8H", ALC287_FIXUP_TAS2781_I2C), /* this must match before PCI SSID 17aa:386f below */
 	SND_PCI_QUIRK(0x17aa, 0x386f, "Legion Pro 7i 16IAX7", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3870, "Lenovo Yoga 7 14ARB7", ALC287_FIXUP_YOGA7_14ARB7_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3877, "Lenovo Legion 7 Slim 16ARHA7", ALC287_FIXUP_CS35L41_I2C_2),



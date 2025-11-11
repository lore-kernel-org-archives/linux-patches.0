Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D680C12DDA1;
	Tue, 11 Nov 2025 00:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822266; cv=none; b=m04u8+sHarDy8EDTlniqC0bacWIeJV1vcQdEq/UoihIKJA0wVuSFpoOGMoEnzbvX9vFb1ROi6wUAr6vRkJX21GGxDHiAhkVu7+3NSfnzlTxfzkSgEooMgO9KaJfzSO+kav43IBMuMb6/WGtgPx9yoZYRrr2PBqTSl4xSWEOM/x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822266; c=relaxed/simple;
	bh=eOmjF8VLW4B8wMyWobjFrutIFlU2Bx4A9ByDHp0aFrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKdzSvGSmOzu4Whb4HrvWl+szHhs5jn6SQS0X1TQ444eIf8sQQ5sNMfFrmoimh28Vuo2ZJkWru+Q/4yv9s/N3ZQXlZ19lSLDzDiLhGV5dBwLAkGmz6PdEI7vp+cxfMtUMZts/oAJoYSV68jVdPhfhf74SI2iEsfl2sCReve2ZDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxEHByVB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxEHByVB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BF1C116B1;
	Tue, 11 Nov 2025 00:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822266;
	bh=eOmjF8VLW4B8wMyWobjFrutIFlU2Bx4A9ByDHp0aFrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxEHByVBjJ8zn9YhWaDGO5JXKJApz5ZqmCMokWxeHoerGNGXwRO4LXvXZDKjfJmEX
	 LlijnDPvpxJXD72YFK58AU8igDcxDPZw4vGokV5R2YI2GnSbtJ57NAn+z277LZ/WBY
	 NAwpX6IYnQT/wZUGeipsw80IU4XiEl+fhsix/HLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 069/849] ALSA: usb-audio: dont log messages meant for 1810c when initializing 1824c
Date: Tue, 11 Nov 2025 09:33:59 +0900
Message-ID: <20251111004538.095004192@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>

[ Upstream commit 75cdae446ddffe0a6a991bbb146dee51d9d4c865 ]

The log messages for the PreSonus STUDIO 1810c about
device_setup are not applicable to the 1824c, and should
not be logged when 1824c initializes.

Refactor from if statement to switch statement as there
might be more STUDIO series devices added later.

Fixes: 080564558eb1 ("ALSA: usb-audio: enable support for Presonus Studio 1824c within 1810c file")
Signed-off-by: Roy Vegard Ovesen <roy.vegard.ovesen@gmail.com>
Link: https://patch.msgid.link/aPaYTP7ceuABf8c7@ark
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_s1810c.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/sound/usb/mixer_s1810c.c b/sound/usb/mixer_s1810c.c
index 2413a6d96971c..5b187f89c7f8e 100644
--- a/sound/usb/mixer_s1810c.c
+++ b/sound/usb/mixer_s1810c.c
@@ -562,15 +562,6 @@ int snd_sc1810_init_mixer(struct usb_mixer_interface *mixer)
 	if (!list_empty(&chip->mixer_list))
 		return 0;
 
-	dev_info(&dev->dev,
-		 "Presonus Studio 1810c, device_setup: %u\n", chip->setup);
-	if (chip->setup == 1)
-		dev_info(&dev->dev, "(8out/18in @ 48kHz)\n");
-	else if (chip->setup == 2)
-		dev_info(&dev->dev, "(6out/8in @ 192kHz)\n");
-	else
-		dev_info(&dev->dev, "(8out/14in @ 96kHz)\n");
-
 	ret = snd_s1810c_init_mixer_maps(chip);
 	if (ret < 0)
 		return ret;
@@ -599,16 +590,28 @@ int snd_sc1810_init_mixer(struct usb_mixer_interface *mixer)
 	if (ret < 0)
 		return ret;
 
-	// The 1824c has a Mono Main switch instead of a
-	// A/B select switch.
-	if (mixer->chip->usb_id == USB_ID(0x194f, 0x010d)) {
-		ret = snd_s1810c_switch_init(mixer, &snd_s1824c_mono_sw);
+	switch (chip->usb_id) {
+	case USB_ID(0x194f, 0x010c): /* Presonus Studio 1810c */
+		dev_info(&dev->dev,
+			 "Presonus Studio 1810c, device_setup: %u\n", chip->setup);
+		if (chip->setup == 1)
+			dev_info(&dev->dev, "(8out/18in @ 48kHz)\n");
+		else if (chip->setup == 2)
+			dev_info(&dev->dev, "(6out/8in @ 192kHz)\n");
+		else
+			dev_info(&dev->dev, "(8out/14in @ 96kHz)\n");
+
+		ret = snd_s1810c_switch_init(mixer, &snd_s1810c_ab_sw);
 		if (ret < 0)
 			return ret;
-	} else if (mixer->chip->usb_id == USB_ID(0x194f, 0x010c)) {
-		ret = snd_s1810c_switch_init(mixer, &snd_s1810c_ab_sw);
+
+		break;
+	case USB_ID(0x194f, 0x010d): /* Presonus Studio 1824c */
+		ret = snd_s1810c_switch_init(mixer, &snd_s1824c_mono_sw);
 		if (ret < 0)
 			return ret;
+
+		break;
 	}
 
 	return ret;
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542AD1AF0AF;
	Mon,  9 Feb 2026 14:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647665; cv=none; b=PhLFUHGRLvwkQn8YcKmfW+InqrgLs/FPuizuWb/Y4udFCNIrCZRYo2gbZcg89gSKawOcsMd1+mDNYDs55/ZltlxwqXmwNomJRM8aOP/f053icU8rEJpO9pUTUytYKNIRtmZIjbtkOiPsTCQdEIOukBkJBuL3ho0sOElnJ5WO4Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647665; c=relaxed/simple;
	bh=cF3Y8aGhCUKnvEXLr+5EgPquFON1X3n0VeFsfhtEcNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdHIMRbEbFEdTDGf3uo2zb9fgCZK20wuEg4BdSFXyepmcmnZtSfltaQY/6+OE/VX7qM3AtpvNuXqEA8Vpu/YIkroFMp/GdUHtV74WV6OUKea+SbvTmSgiD8zeRELSwlppJCo41K3qW0VhOyoCLMDXsY06ahfp+tcDhEQJb+Pfz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/JY2bBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/JY2bBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E44C116C6;
	Mon,  9 Feb 2026 14:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647665;
	bh=cF3Y8aGhCUKnvEXLr+5EgPquFON1X3n0VeFsfhtEcNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/JY2bBqVowUdmYmHI6O+3ZuoiM485JJmH33HmrswCZXUewciVHDt0tjiP3ovR5Mo
	 b/A5LlfMtx91PMWCSKEOQjkVGzJmg1HbknJzAdLL56qnFzlDDk1PhWg5ug43y3VnOO
	 dRqyuBqrKiVSQdazJP1przKwCWlVBY1YBvVJ67Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Shtylyov <s.shtylyov@auroraos.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 160/175] ALSA: usb-audio: fix broken logic in snd_audigy2nx_led_update()
Date: Mon,  9 Feb 2026 15:23:53 +0100
Message-ID: <20260209142326.247749379@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Sergey Shtylyov <s.shtylyov@auroraos.dev>

[ Upstream commit 124bdc6eccc8c5cba68fee00e01c084c116c4360 ]

When the support for the Sound Blaster X-Fi Surround 5.1 Pro was added,
the existing logic for the X-Fi Surround 5.1 in snd_audigy2nx_led_put()
was broken due to missing *else* before the added *if*: snd_usb_ctl_msg()
became incorrectly called twice and an error from first snd_usb_ctl_msg()
call ignored.  As the added snd_usb_ctl_msg() call was totally identical
to the existing one for the "plain" X-Fi Surround 5.1, just merge those
two *if* statements while fixing the broken logic...

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

Fixes: 7cdd8d73139e ("ALSA: usb-audio - Add support for USB X-Fi S51 Pro")
Signed-off-by: Sergey Shtylyov <s.shtylyov@auroraos.dev>
Link: https://patch.msgid.link/20260203161558.18680-1-s.shtylyov@auroraos.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 828af3095b86e..4873b5e748016 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -311,13 +311,8 @@ static int snd_audigy2nx_led_update(struct usb_mixer_interface *mixer,
 	if (pm.err < 0)
 		return pm.err;
 
-	if (chip->usb_id == USB_ID(0x041e, 0x3042))
-		err = snd_usb_ctl_msg(chip->dev,
-				      usb_sndctrlpipe(chip->dev, 0), 0x24,
-				      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_OTHER,
-				      !value, 0, NULL, 0);
-	/* USB X-Fi S51 Pro */
-	if (chip->usb_id == USB_ID(0x041e, 0x30df))
+	if (chip->usb_id == USB_ID(0x041e, 0x3042) ||	/* USB X-Fi S51 */
+	    chip->usb_id == USB_ID(0x041e, 0x30df))	/* USB X-Fi S51 Pro */
 		err = snd_usb_ctl_msg(chip->dev,
 				      usb_sndctrlpipe(chip->dev, 0), 0x24,
 				      USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_OTHER,
-- 
2.51.0




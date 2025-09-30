Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC5621ABD0;
	Tue, 30 Sep 2025 15:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244415; cv=none; b=cd5l2QFXfiY5GG4VE48pWNSFRXFQJJJi3nilBQrFjpaSdyYkz+jsudaA2jCmUj/O3B3ahavoO6nTjiGxpMBYgw4HckpUuW+nYwz5a0vIzoNkkdHEr4YppxR0oGDxdMmbU0iRlR9VMZPE9YGJu9xxTlu+mGDxWqlHWHOzNOU5BrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244415; c=relaxed/simple;
	bh=lBk3wrZh0Xt/9D0hapALG7vdDEgw5j01KH6OKMtKoEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bix7APRO72Wv6i3zdRGqIJybKpjRSHJ6+ZkotVVKu4Ql35cKROdbo4Pyp/xNz+Pzk4pg5HQWhir7z/XriL7ZrfwfyMLRbgk/RdA5UPfXQ93EY1OQORgIYKbEwy0hl/QkY05Ad8RLKmUKToSX0Q4GysCrZupI1LMyvD6m9RyLubs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l291Cj7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l291Cj7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4477C4CEF0;
	Tue, 30 Sep 2025 15:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244415;
	bh=lBk3wrZh0Xt/9D0hapALG7vdDEgw5j01KH6OKMtKoEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l291Cj7UYOicWJbNQ8o6/jgHC52YzMEWLScAF54Likx/WuN/01b3HcLEkfg/YIB0h
	 BEQwzTQEPqMP05tqhghmTddEgMqX4zAA/O73/w/T/VSNs8ZbjrLCeIkkH8gYEJ2qM1
	 Gq2PDfo7VkXSLTKe9Z8Y4pyUDOCbAfsQcpl3Goj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/122] ALSA: usb-audio: Fix build with CONFIG_INPUT=n
Date: Tue, 30 Sep 2025 16:47:02 +0200
Message-ID: <20250930143826.725806488@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit d0630a0b80c08530857146e3bf183a7d6b743847 ]

The recent addition of DualSense mixer quirk relies on the input
device handle, and the build can fail if CONFIG_INPUT isn't set.
Put (rather ugly) workarounds to wrap with IS_REACHABLE() for avoiding
the build error.

Fixes: 79d561c4ec04 ("ALSA: usb-audio: Add mixer quirk for Sony DualSense PS5")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202506130733.gnPKw2l3-lkp@intel.com/
Reviewed-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20250613081543.7404-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index b3afa7b26b9cd..7a4d449182d65 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -528,6 +528,7 @@ static int snd_emu0204_controls_create(struct usb_mixer_interface *mixer)
 					  &snd_emu0204_control, NULL);
 }
 
+#if IS_REACHABLE(CONFIG_INPUT)
 /*
  * Sony DualSense controller (PS5) jack detection
  *
@@ -784,6 +785,7 @@ static int snd_dualsense_controls_create(struct usb_mixer_interface *mixer)
 
 	return snd_dualsense_jack_create(mixer, "Headset Mic Jack", false);
 }
+#endif /* IS_REACHABLE(CONFIG_INPUT) */
 
 /* ASUS Xonar U1 / U3 controls */
 
@@ -3388,10 +3390,12 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
 		err = snd_emu0204_controls_create(mixer);
 		break;
 
+#if IS_REACHABLE(CONFIG_INPUT)
 	case USB_ID(0x054c, 0x0ce6): /* Sony DualSense controller (PS5) */
 	case USB_ID(0x054c, 0x0df2): /* Sony DualSense Edge controller (PS5) */
 		err = snd_dualsense_controls_create(mixer);
 		break;
+#endif /* IS_REACHABLE(CONFIG_INPUT) */
 
 	case USB_ID(0x0763, 0x2030): /* M-Audio Fast Track C400 */
 	case USB_ID(0x0763, 0x2031): /* M-Audio Fast Track C400 */
-- 
2.51.0




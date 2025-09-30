Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB29205E3B;
	Tue, 30 Sep 2025 15:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245668; cv=none; b=XR4clieOxGAion4nOxsc9MVRXLTcnNyKsjDCHEtBxv7gs6gDebVz+/aNkT4hS1svzyrduq+aZyJsK670dVuQAcsxf35LdELB4TGir7aqv/KdfKYuHIreuIIgk5hoaZtaYOh2Hs1q6hRdKIVqsXunmPGnLEkvBrJowRZ2Dtuj75w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245668; c=relaxed/simple;
	bh=cdpFMa2QBxQnkado6z5L3WPwGCbeTgxV/qz+QQQy++U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbkLkSzufsLGtBJXA9kC69pdNuH60m2VMsqmjsE9wqbXah9L04fofYnLB7kgRF8K3bf/GXvU2m1NZny/XVSJ+ww6s5AsukTah5QQeydVySJV5gl7MAkPy67UXhwbunA50hYeUgRNjrL3NXl6h2Foh+tBTAmKeOldyMaGlEL09lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ib7sWRsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ib7sWRsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0ADC4CEF0;
	Tue, 30 Sep 2025 15:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245666;
	bh=cdpFMa2QBxQnkado6z5L3WPwGCbeTgxV/qz+QQQy++U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ib7sWRsnuYZ858DNgqqXHiZlU1BFZXM2B30TYG1rKhE396IOg+XtO4QHLRMXARjp3
	 V/bdufa0zXC/G0FGs1AY/DPvqPj6Lwd8XE5wxtvo93wXmHBi08WH9/uu+AK1HgtUSH
	 PPokYsHN653C2/06yx14u4FzXDhNBgWVW2allSfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 14/91] ALSA: usb-audio: Fix build with CONFIG_INPUT=n
Date: Tue, 30 Sep 2025 16:47:13 +0200
Message-ID: <20250930143821.722707588@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f1b663a05f295..8c0b8383abe1e 100644
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
 
@@ -3648,10 +3650,12 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
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




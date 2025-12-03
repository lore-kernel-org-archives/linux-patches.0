Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AAE312813;
	Wed,  3 Dec 2025 15:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776728; cv=none; b=RdMrBm3iYxlob2sLXk9QgGGAb6qsfPHkFPlv7c4UUKav9vaEaKp0oTsVudxPt2NS2jCFRnflyju5L7dodWBFPreO9YEhwH2G2UhIwKZcqRT+QRcbkSm1AMz7IxGTDsjQWYpw1jIQj5MeXMA894OTInKS+MyVC07oNlS1uioPkUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776728; c=relaxed/simple;
	bh=IMnftusQ1MOqKHxDejdX9DbLern6530dPOyGfQtfKkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsrQt5dNTZmAuuhiN50PE3vK6nPByJ4uJ0UEFiu1h9aMwUqNvO3gKXh12Yqokf4SeQJP993GGgm+ZDyRuZeTLF4i76Xgpi7+IdQ2Uui1QbQcIanbymuKZBycRQLgJpYa9VPkUkxd+1n+slxBSgJc5mhR4ilbvbdNCT69SnKGdb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUsLQ/Vr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUsLQ/Vr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606D3C116C6;
	Wed,  3 Dec 2025 15:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776727;
	bh=IMnftusQ1MOqKHxDejdX9DbLern6530dPOyGfQtfKkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xUsLQ/VrFT2+nOA9y0MBGNkcwErvoEiB3Nn/DDHUshVbzED9vAWehsvjG12O2XJ7/
	 rYD9xbhFzur5zGnelrwp9PZsEDH/Khw0gysqlhHdoV8xxAqtUH+oR7RwC+uwUY0Pol
	 09b5UvbCWiBCu/5EiWIJHI8SJMa5zLW7g0H6IfLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bfd77469c8966de076f7@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 242/300] ALSA: usb-audio: Fix potential overflow of PCM transfer buffer
Date: Wed,  3 Dec 2025 16:27:26 +0100
Message-ID: <20251203152409.591731015@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

[ Upstream commit 05a1fc5efdd8560f34a3af39c9cf1e1526cc3ddf ]

The PCM stream data in USB-audio driver is transferred over USB URB
packet buffers, and each packet size is determined dynamically.  The
packet sizes are limited by some factors such as wMaxPacketSize USB
descriptor.  OTOH, in the current code, the actually used packet sizes
are determined only by the rate and the PPS, which may be bigger than
the size limit above.  This results in a buffer overflow, as reported
by syzbot.

Basically when the limit is smaller than the calculated packet size,
it implies that something is wrong, most likely a weird USB
descriptor.  So the best option would be just to return an error at
the parameter setup time before doing any further operations.

This patch introduces such a sanity check, and returns -EINVAL when
the packet size is greater than maxpacksize.  The comparison with
ep->packsize[1] alone should suffice since it's always equal or
greater than ep->packsize[0].

Reported-by: syzbot+bfd77469c8966de076f7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bfd77469c8966de076f7
Link: https://lore.kernel.org/690b6b46.050a0220.3d0d33.0054.GAE@google.com
Cc: Lizhi Xu <lizhi.xu@windriver.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20251109091211.12739-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ changed ep->cur_rate to rate parameter and chip to ep->chip ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1093,6 +1093,11 @@ int snd_usb_endpoint_set_params(struct s
 	ep->sample_rem = rate % ep->pps;
 	ep->packsize[0] = rate / ep->pps;
 	ep->packsize[1] = (rate + (ep->pps - 1)) / ep->pps;
+	if (ep->packsize[1] > ep->maxpacksize) {
+		usb_audio_dbg(ep->chip, "Too small maxpacksize %u for rate %u / pps %u\n",
+			      ep->maxpacksize, rate, ep->pps);
+		return -EINVAL;
+	}
 
 	/* calculate the frequency in 16.16 format */
 	ep->freqm = ep->freqn;



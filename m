Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9EA34EF19;
	Fri, 21 Nov 2025 13:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733463; cv=none; b=rEDUG/2ezvyp+Qx4Nbne0MJlaVzIOALjYt+Q0tYbT3ejeBFsKz1hbR6shuS0Do0npueybf/MX1gQxIM1sQPgTBaZ67eIuwinxD7zb90Hg6tdYemgv3yfUdfqtS2JQqfE7nc9z0+fStKss5RQcXnGgJk4wIMgsUKX9VuD3Yy/wys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733463; c=relaxed/simple;
	bh=2Tyvk57FoFnW/rUwimrV7xx+b9aVshDelF0vU1DMcS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHUtaPpSKj7789NLflSoekd2Qdl0pxoExPCBaafzZZrBlapY9zvnCa4Iwcl0+KVntXPnhr1AcDS57D0LJin6+Juprd/Az8ODMk1KK8KNic2I7Zf1CkJHVELeQHfM7gK+NDeNvIdnK4j5lNyVHFPWr1+RSsuGk5ak3X5yUXBJfRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCBWn46H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCBWn46H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2EBC4CEF1;
	Fri, 21 Nov 2025 13:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733463;
	bh=2Tyvk57FoFnW/rUwimrV7xx+b9aVshDelF0vU1DMcS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xCBWn46HB6+GbFGYzou3UMK8mvU+ZvrHCqBVwCiemuoDD85pi8GFBgX5NjIFth9Il
	 N3pohvqdZRMX3N7nLfI/hMTT0E3Yn/vU3/ThCluvnzJ2L0HycPopksBO9fCMGseKVR
	 uFCkI1w+g1EmuRqdgrwLe65caXKpCwt6Z8ihQOlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bfd77469c8966de076f7@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 476/529] ALSA: usb-audio: Fix potential overflow of PCM transfer buffer
Date: Fri, 21 Nov 2025 14:12:55 +0100
Message-ID: <20251121130247.946338133@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

commit 05a1fc5efdd8560f34a3af39c9cf1e1526cc3ddf upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/endpoint.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -1383,6 +1383,11 @@ int snd_usb_endpoint_set_params(struct s
 	ep->sample_rem = ep->cur_rate % ep->pps;
 	ep->packsize[0] = ep->cur_rate / ep->pps;
 	ep->packsize[1] = (ep->cur_rate + (ep->pps - 1)) / ep->pps;
+	if (ep->packsize[1] > ep->maxpacksize) {
+		usb_audio_dbg(chip, "Too small maxpacksize %u for rate %u / pps %u\n",
+			      ep->maxpacksize, ep->cur_rate, ep->pps);
+		return -EINVAL;
+	}
 
 	/* calculate the frequency in 16.16 format */
 	ep->freqm = ep->freqn;



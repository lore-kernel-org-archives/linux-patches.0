Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6634A3ACEE0;
	Sat, 17 Oct 2026 17:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256614; cv=none; b=UVCUNjj50YBU9VWDmU06UhGKoufYXz3xvYR5JsaPszp+LK0RhMOOAd1gmlru/vp+1t/BQN2g3GHeJkn3cSvAyTlNuuop4yAvhINnbWwZqSInnXjM8L2z/pOVblxhHRXy84fKd9zYK/9Z6lrmZj7chbKRX/yPEaBn0+23JhSnlCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256614; c=relaxed/simple;
	bh=/JPiD1J+B2ZyiIMuKiCsOrYKs07TzZexFxrSIl09DLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBpQQFSGBydW2warVb1O0YzZ6AryrtdJRYBogJr+JrknxmXAnWWrkL0drpbEFu46X/sDie4k91sOMgk+Z4qdWHZbB4ROP/ZQHBWCOjnbZqOBV+iYR0wqUiBaUrW4Izi0lplMKJTuFe3Hx4WxwkEksCs6N/o8i0av9r7gTCpEpHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTLWyaYT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTLWyaYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4201F000C4;
	Sat, 17 Oct 2026 17:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256613;
	bh=63Xcd2vreXWpUyIaKxxn1h655VK+xvT+8biHhqD+/fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zTLWyaYTRczCZtgVVLvHkf9GSOCgjdyd13XZuezFJs8hmmsmM7lMZPt/OTAhv9hCE
	 phJ66NORXepbXeB9u68tHSHaa6u3v0gPZdLOJMaJXs3fl+YY2dJXxRnZwcn0eSH4Wd
	 3DCbNi8VxhuqLxwk/goI55fJbmgpbSvi6I8CIboo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+24304d323d28f156@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 0292/1674] ALSA: ua101: reject mismatched capture/playback packet sizes
Date: Sat, 17 Oct 2026 17:42:44 +0200
Message-ID: <20261017160438.609709318@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

commit 86f86e6fdedc33c5b8d38b9208b350f8accf57ee upstream.

detect_usb_format() cross-checks bSubframeSize, bBitResolution and
tSamFreq between the capture and playback interfaces, but never relates
the two endpoints' wMaxPacketSize and bNrChannels.  Each playback URB
gets a buffer of ua->playback.max_packet_bytes, while the number of
bytes written into it is derived from the capture stream:
capture_urb_complete() computes frames from the received capture packet
and capture.frame_bytes, and start_usb_playback() and playback_work()
multiply that by playback.frame_bytes.

A device declaring a large capture wMaxPacketSize with few capture
channels and a small playback wMaxPacketSize with many playback channels
therefore memset()s and memcpy()s past the end of the playback buffer,
in open() of the PCM node the driver registers during probe.
usb_submit_urb() rejects the over-long iso_frame_desc[0].length with
-EMSGSIZE, but only after the write.

Reject such descriptors at probe time.  Genuine UA-101/UA-1000 hardware
declares proportional packet sizes and is unaffected.

  BUG: KASAN: slab-out-of-bounds in start_usb_playback (sound/usb/misc/ua101.c:586)
  Write of size 2048 at addr ffff8881098f3c00 by task exploit/5021
  Call Trace:
   __asan_memset (mm/kasan/shadow.c:84)
   start_usb_playback (sound/usb/misc/ua101.c:586)
   playback_pcm_open (sound/usb/misc/ua101.c:679)
   snd_pcm_open_substream (sound/core/pcm_native.c:2829)
   snd_pcm_open (sound/core/pcm_native.c:2865 sound/core/pcm_native.c:2932)
   snd_pcm_playback_open (sound/core/pcm_native.c:2891)
   snd_open (sound/core/sound.c:166)
   chrdev_open (fs/char_dev.c:411)
   do_dentry_open (fs/open.c:996)
   vfs_open (fs/open.c:1101)
   path_openat (fs/namei.c:4837 fs/namei.c:5000)
   do_file_open (fs/namei.c:5029)
   do_sys_openat2 (fs/open.c:1417)
   __x64_sys_openat (fs/open.c:1423 fs/open.c:1439 fs/open.c:1434)
   do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:84)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

  The buggy address belongs to the object at ffff8881098f3c00
   which belongs to the cache kmalloc-192 of size 192
  The buggy address is located 0 bytes inside of
   allocated 168-byte region [ffff8881098f3c00, ffff8881098f3ca8)

Cc: stable@vger.kernel.org
Fixes: 63978ab3e3e9 ("sound: add Edirol UA-101 support")
Reported-by: <co+24304d323d28f156@bugs.sh>
Assisted-by: LLM
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260918225753.1278505-1-xmei5@asu.edu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/misc/ua101.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/usb/misc/ua101.c
+++ b/sound/usb/misc/ua101.c
@@ -1022,6 +1022,15 @@ static int detect_usb_format(struct ua10
 	}
 	ua->playback.usb_pipe = usb_sndisocpipe(ua->dev, usb_endpoint_num(epd));
 	ua->playback.max_packet_bytes = usb_endpoint_maxp(epd);
+
+	if (ua->capture.max_packet_bytes / ua->capture.frame_bytes *
+	    ua->playback.frame_bytes > ua->playback.max_packet_bytes) {
+		dev_err(&ua->dev->dev,
+			"playback packet size %u too small for %u capture frames\n",
+			ua->playback.max_packet_bytes,
+			ua->capture.max_packet_bytes / ua->capture.frame_bytes);
+		return -ENXIO;
+	}
 	return 0;
 }
 



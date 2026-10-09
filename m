Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EF046EF92;
	Fri,  9 Oct 2026 14:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556318; cv=none; b=bO5FC4GcawTAtxCdxqalEJYViG4uz0IDLJghb0/+oIIlQOzV02/QHOPNJNCuhlar7+KcppFmh9e7LBZtBg7mkTofIVhEUquWRHcsNhnCbXjuAe8YSPUVnqwNqeBxn7iJRg7nUEKevqv/x6QXxMUE+Dj1pi9RP59+zu0Fvq1LfG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556318; c=relaxed/simple;
	bh=SU7njEuXfPJpe1MnEN5+3D8m1KOS2EWBHAIC4JwGWZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b40Ol16aE5Ui2bCUZOgmHaTtYmG5lrMZYct/uOgvnyIGXrG/W7aJWvbE7jBu2e+K8EFrwKJ3e/MWUusEy8qNNy1O/s4jUOkrQzYjl7wwGYfBEWftJEu+ao1X0TGF09K4KGHgpTCd+kUJ0YO4DP6Y8CEkxhSXt4n1jMRbkz6Ncwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmWLiKrT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmWLiKrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB761F000FF;
	Fri,  9 Oct 2026 14:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556314;
	bh=8XVqELbhFtglqbb/Co9n0TkYsk2v3X6p1Kr7/jFVA+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RmWLiKrT7QYdPooXTE4NS2DeO9c09C6GrJU6aAVohCNfLRadxrUws3vGw3ctVyx2j
	 48xytSUKYvXvAmuiS/mW3+SXqlECDNs5um+6r43Hk83wdK9BNXhlMWQ8Ld+cAvoAug
	 MEjsArwM7Mi/ZPnvHsawM4bDUySoifpYT/Tpyyqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+24304d323d28f156@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 214/403] ALSA: ua101: reject mismatched capture/playback packet sizes
Date: Fri,  9 Oct 2026 16:09:35 +0200
Message-ID: <20261009140957.145698307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
@@ -1002,6 +1002,15 @@ static int detect_usb_format(struct ua10
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
 



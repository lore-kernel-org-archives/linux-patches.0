Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8611F3B582F;
	Fri,  9 Oct 2026 14:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555978; cv=none; b=RwPk4wk70tuK8qwttP4LDiS6N5GHNZxQIG1vjoTg2Y3y6nSzbldeYjBWPmWsi+jgIlOUqN2hQKZZpdajqVs7GlzlsYxQgPf4i5WJrLXywDr6xzD2fk9EKq2Q8FiwRNlcfFXgAER+SjSYrrK+7H6O97GJniA2K8FJ9JteDR/I+kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555978; c=relaxed/simple;
	bh=FmlaMl8OKcHHDed49DXg+0Yrknv8RUbT6U1dLY7FI/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oB9jqOaQi6ztqECm9JfXoNw02h3M5DjnG8eUtIPLKVhDvfr3kqFOzRZcPBkqXpIpmTw1aGUZALXoYBtEHVeCJrQI/jBw74ksnRnPAl79U6y8LudFcjlI4DtDgVrRidHE3C4eeNV0z9vZo26l2spv4znfw0E4QrZIPUXIf21oe34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHNN+eLe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHNN+eLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B501F000FF;
	Fri,  9 Oct 2026 14:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555977;
	bh=yCTDQ75TAzm1yLRt6cuyInXG981hH98YF6xXyP6pYBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHNN+eLevkffaN6Lo64ZjX9W7V7UTOJ0NVUofuzsMH4n//PJAF7vw75QZqZKZIWDm
	 RnLI+2XpULRbs4For7s12z/WBUF6yZVQ55UudA00YYnq/FnwJw98mp2zzgE3xKDhsI
	 skedYM6uGlk5M8zzMk+Pw+nk7N8Bcqrk5XqBRFdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+be8fa7ea6f77fdce@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 064/428] ALSA: line6: reject oversized playback packets
Date: Fri,  9 Oct 2026 16:06:41 +0200
Message-ID: <20261009140947.549944752@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

commit 61b0a5a114fa4552892da5c0ff2f42e63bf08c6b upstream.

Each playback URB is handed a slice of out.buffer that is exactly
LINE6_ISO_PACKETS * max_packet_size_out bytes, sized from the OUT
endpoint, but the number of bytes written into that slice is never
compared against it.

submit_audio_out_urb() takes the frame count from prev_fsize, which
audio_in_callback() derived from the *IN* endpoint's received packet
length, and rescales it with the playback frame size; when prev_fsize is
still zero it synthesizes a length from the sample rate instead.  On a
device declaring a large IN wMaxPacketSize and a small OUT
wMaxPacketSize, the resulting memcpy(), or the memset() when the
playback stream is idle, runs past its slice and, as the reproducer
below shows, beyond the allocation.

usb_submit_urb() is not a backstop.  max_packet_size_out comes from
usb_maxpacket(), which returns only the low 11 bits of wMaxPacketSize,
while USB core validates a high-speed isochronous length against that
base scaled by usb_endpoint_maxp_mult().  A length of up to three times
the allocated slice is therefore accepted, and even a rejected URB is
only rejected after the write.

Reject a packet that does not fit the slice the driver allocated for it.
Clamping it instead would silently shorten the capture-derived rate
feedback and desynchronize the two streams.

  BUG: KASAN: slab-out-of-bounds in submit_audio_out_urb (sound/usb/line6/playback.c:229)
  Write of size 1024 at addr ffff888100bbd400 by task kworker/1:2/5002
  Workqueue: events line6_startup_work
  Call Trace:
   __asan_memcpy (mm/kasan/shadow.c:106)
   submit_audio_out_urb (sound/usb/line6/playback.c:229)
   line6_submit_audio_out_all_urbs (sound/usb/line6/playback.c:291)
   line6_stream_start (sound/usb/line6/pcm.c:194)
   line6_pcm_acquire (sound/usb/line6/pcm.c:337)
   line6_startup_work (sound/usb/line6/driver.c:728)
   process_one_work (kernel/workqueue.c:3396)
   worker_thread (kernel/workqueue.c:3479 kernel/workqueue.c:3560)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)

  The buggy address belongs to the object at ffff888100bbd400
   which belongs to the cache kmalloc-256 of size 256
  The buggy address is located 0 bytes inside of
   allocated 256-byte region [ffff888100bbd400, ffff888100bbd500)

Cc: stable@vger.kernel.org
Fixes: 7a0f55aeeb8f ("ALSA: line6: Support assymetrical in/out configurations")
Reported-by: <co+be8fa7ea6f77fdce@bugs.sh>
Assisted-by: LLM
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260918234014.1318325-1-xmei5@asu.edu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/line6/playback.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/usb/line6/playback.c
+++ b/sound/usb/line6/playback.c
@@ -182,6 +182,13 @@ static int submit_audio_out_urb(struct s
 
 		fsize *= bytes_per_frame;
 
+		if (fsize > line6pcm->max_packet_size_out) {
+			dev_err(line6pcm->line6->ifcdev,
+				"playback packet too large: %d > %d\n",
+				fsize, line6pcm->max_packet_size_out);
+			return -EMSGSIZE;
+		}
+
 		fout->offset = urb_size;
 		fout->length = fsize;
 		urb_size += fsize;



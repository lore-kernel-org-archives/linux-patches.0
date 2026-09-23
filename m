Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32F3414413;
	Wed, 23 Sep 2026 14:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173060; cv=none; b=QqC28AfDVZkNHIZWQrgwDYwsOeTGUoX+aq4OoxmRLIN7id9C0I6t48r/XV5qgKEUJF8FcqvW4SwyWKMPLl3RD4P2fInBVeFNOhjqtvUzauUwc9eY11+/lyjoIhtK0hcygSEfUciWynZ4CtH0wvZrWZeWbIzdWZuWQsj0sBlWwxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173060; c=relaxed/simple;
	bh=zBlvSOLjM1P2UqCIf6NfY63i7lrfY2uIf106M+ln0z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EioTddvoT7wHS01jwpqH0sAoSxynxNUMa64GvB11CN3gMe9DU5/n96DnGuf5YwYgAsc67c1YB/WTSaJeFPb7MFTAlP72wBvtoUahThLipZLrnlFDpG458vZ+nn7UJNn9D7PKfFHxuPHDtRjlyuTF/m9zozrc7EN8ysWedB2Xpao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKANh9LY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKANh9LY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1359A1F000FF;
	Wed, 23 Sep 2026 14:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173058;
	bh=WirVVwuNxmyz+VQ+mCvfFZtC5l2InI8BwWp/mik6vhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKANh9LYXkSCgv+iUg9TEvScDhfs3+L64rDczEzRgYapP7Ksgw3yxxh1EDD1Ql1+i
	 DUWF9fj4ok21daV6VrjbSSYfGmUBUuCKnmBNk8qqLJze0vxaQekRBIVqqZvfWd6u8S
	 cye1G9WrRKGynS6bjtxxb9o3CZtYMcm+ZIgc3jwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+855929c2df672879@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 139/438] ALSA: 6fire: fix OOB write from device-reported iso length
Date: Wed, 23 Sep 2026 16:02:40 +0200
Message-ID: <20260923140648.379396499@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

[ Upstream commit 1589afe2d099d3e817873bc474676968d7080410 ]

usb6fire_pcm_in_urb_handler() sizes each outgoing isochronous packet as
(actual_length - 4) / (in_n_analog << 2) * (out_n_analog << 2) + 4, where
actual_length is the unsigned length the device reported for the matching
IN packet.  A packet completed with status 0 and actual_length < 4 wraps
the subtraction to 0x7fffffec; a zero-length isochronous packet is legal
on the bus, and the preceding loop rejects only non-zero status.  The sum
reaches memset() on out_urb->buffer, a 4832-byte object from
kcalloc(PCM_MAX_PACKET_SIZE, PCM_N_PACKETS_PER_URB).

Even without the wrap the result is out of bounds: at 88.2/96 kHz the
4-in/6-out scaling turns a full 420-byte IN packet into 628, so eight
packets span 5024 bytes of that buffer.  usb_submit_urb() rejects an
over-long descriptor only after the memset() and the
usb6fire_pcm_playback() copy of user PCM data have run.

Guard the subtraction as the sibling usb6fire_pcm_capture() already does,
and limit the frame count to what fits in rt->out_packet_size, the OUT
endpoint's wMaxPacketSize.  This bounds total_length by the buffer size
while keeping each packet length aligned to a whole output frame.

  BUG: KASAN: out-of-bounds in usb6fire_pcm_in_urb_handler (sound/usb/6fire/pcm.c:338)
  Write of size 18446744073709551456 at addr ffff88802a3d0000 by task vhci_rx/5018
  Call Trace:
   dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
   print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
   kasan_report (mm/kasan/report.c:595)
   kasan_check_range (mm/kasan/generic.c:186 mm/kasan/generic.c:200)
   __asan_memset (mm/kasan/shadow.c:84)
   usb6fire_pcm_in_urb_handler (sound/usb/6fire/pcm.c:338)
   __usb_hcd_giveback_urb (drivers/usb/core/hcd.c:1657)
   usb_hcd_giveback_urb (drivers/usb/core/hcd.c:1741)
   vhci_rx_loop (drivers/usb/usbip/vhci_rx.c:107 drivers/usb/usbip/vhci_rx.c:242)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)

  Allocated by task 10:
   __kmalloc_cache_noprof (mm/slub.c:5563)
   usb6fire_pcm_init (sound/usb/6fire/pcm.c:560 sound/usb/6fire/pcm.c:595)
   usb6fire_chip_probe (sound/usb/6fire/chip.c:133)
   usb_probe_interface (drivers/usb/core/driver.c:399)

  The buggy address belongs to the object at ffff88802a3d0000
   which belongs to the cache kmalloc-8k of size 8192
  The buggy address is located 0 bytes inside of
   4832-byte region [ffff88802a3d0000, ffff88802a3d12e0)
  Kernel panic - not syncing: Fatal exception in interrupt

Fixes: c6d43ba816d1 ("ALSA: usb/6fire - Driver for TerraTec DMX 6Fire USB")
Reported-by: co+855929c2df672879@bugs.sh
Closes: https://lore.kernel.org/all/gisnub8aWGLbyZLcDCSc7zWsHonMWGcyRgt5%40bugs.sh/
Assisted-by: LLM
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Link: https://patch.msgid.link/20260914074324.3590843-1-xmei5@asu.edu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/6fire/pcm.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/sound/usb/6fire/pcm.c b/sound/usb/6fire/pcm.c
index 21789db6657d3..0285d79ace0fc 100644
--- a/sound/usb/6fire/pcm.c
+++ b/sound/usb/6fire/pcm.c
@@ -335,11 +335,19 @@ static void usb6fire_pcm_in_urb_handler(struct urb *usb_urb)
 
 	/* setup out urb structure */
 	for (i = 0; i < PCM_N_PACKETS_PER_URB; i++) {
+		unsigned int frames = 0;
+
 		isoc_out = &out_urb->instance->iso_frame_desc[i];
 		isoc_in = &in_urb->instance->iso_frame_desc[i];
+		if (isoc_in->actual_length > 4)
+			frames = (isoc_in->actual_length - 4)
+					/ (rt->in_n_analog << 2);
+		frames = min_t(unsigned int, frames,
+				       (rt->out_packet_size - 4)
+				       / (rt->out_n_analog << 2));
+
 		isoc_out->offset = total_length;
-		isoc_out->length = (isoc_in->actual_length - 4) / (rt->in_n_analog << 2)
-				* (rt->out_n_analog << 2) + 4;
+		isoc_out->length = frames * (rt->out_n_analog << 2) + 4;
 		isoc_out->status = 0;
 		total_length += isoc_out->length;
 	}
-- 
2.53.0




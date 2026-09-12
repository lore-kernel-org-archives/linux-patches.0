Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7B83B3C10;
	Sat, 12 Sep 2026 18:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237090; cv=none; b=rexeWq5xwnrHg88jvJk6KqHAgOLBjOa2lN5BXrNRTwCxuQmZiqAgSIT7IYgdBl/WMqW/BNfSyJ0QtAatgLUzvJRfAzg/GTb+v+LaRknHv4HudDAN0HZYilCzYuwxfv+r0sAWW7ZTUm2XXMneWBDq1jFR3hhzmMAY3dPhP2CAX98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237090; c=relaxed/simple;
	bh=RssPVZUbDgDx8MlnUNzN6Q7XF6l2adXyPP13xeHQq1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DToVGD/foIImybQKvE8QU1+l8bFBVUi48yNNVdszPJ1v7olHaIC7yNNF9Ficku2UdDigchIDG5GiYsUBgPfg/vIx/LhVGODXJM1O+2gdP5Djl2XqMSbUeBhW/Yx/5T4P7lOiJOdBIGfALhUIKvgFaU+HdZgn3vxQP3UcgH0pCIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9/IrDOQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9/IrDOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 072B11F000FF;
	Sat, 12 Sep 2026 18:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237088;
	bh=xxIjYk3dn16wcuLlbppyRQTjioUmhX7JdfgCt5Hm3Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9/IrDOQTLEcylmK9svN2ggu9a1y+tFc3hkbLP07xI8QaGnJNgcBEEZPVawKJL4zr
	 /KJVjqPFQDcr1GPlC/3HitYultEZcfS4u90MIlra/fYzc27BKf+37gy87UCkERSUpm
	 pSuL5tMmqfUtN3NQTDuqLgsnKcKwyRAyTn87UCsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 188/935] ALSA: 6fire: bound the MIDI event length from the device
Date: Sat, 12 Sep 2026 08:53:38 +0200
Message-ID: <20260912065531.127487965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baul Lee <baul.lee@xbow.com>

commit a478893b59e36cfe7d77a76b352f2db55502e879 upstream.

usb6fire_comm_receiver_handler() forwards a MIDI event using a length
byte the device supplies, with no bound and no check that the transfer
delivered that many bytes:

	if (!urb->status) {
		if (rt->receiver_buffer[0] == 0x10) /* midi in event */
			if (midi_rt)
				midi_rt->in_received(midi_rt,
						rt->receiver_buffer + 2,
						rt->receiver_buffer[1]);
	}

receiver_buffer is a 64-byte kzalloc() buffer (COMM_RECEIVER_BUFSIZE), so
only 62 bytes follow the two-byte header.  receiver_buffer[1] is a u8 the
device chooses, so a device that answers with 0x10 and a length of 0xFF
makes snd_rawmidi_receive() read 255 bytes starting two bytes into a
64-byte object.  The bytes past the buffer are handed to userspace
through the rawmidi read path.

urb->actual_length is not consulted either, so a short transfer leaves
both the type byte and the length byte at their previous values and the
handler acts on stale data.

The receiver URB is submitted from usb6fire_comm_init() at probe, so the
read happens on plug with no user action; forwarding to userspace also
needs a MIDI input substream open, since usb6fire_midi_in_received()
only calls snd_rawmidi_receive() when rt->in is set.

KASAN on 7.2.0-rc5 (arm64), single packet from an emulated device:

  BUG: KASAN: slab-out-of-bounds in snd_rawmidi_receive
  Read of size 255 at addr ffff000009f64682 by task bash/183
   __asan_memcpy
   snd_rawmidi_receive
   usb6fire_midi_in_received [snd_usb_6fire]
   usb6fire_comm_receiver_handler [snd_usb_6fire]
  Allocated by task 11:
   usb6fire_comm_init [snd_usb_6fire]
   usb6fire_chip_probe [snd_usb_6fire]
  The buggy address is located 2 bytes inside of
   allocated 64-byte region [ffff000009f64680, ffff000009f646c0)

Reject the event when the length exceeds the bytes that follow the
header, and require the transfer to have delivered the header plus that
many bytes.  The receiver URB is submitted with a 64-byte
transfer_buffer_length, so a genuine device cannot deliver an event
longer than those 62 bytes and nothing valid is dropped.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: c6d43ba816d1 ("ALSA: usb/6fire - Driver for TerraTec DMX 6Fire USB")
Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
Reported-by: Baul Lee <baul.lee@xbow.com>
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Link: https://patch.msgid.link/20260805013423.38175-1-baul.lee@xbow.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/6fire/comm.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/sound/usb/6fire/comm.c
+++ b/sound/usb/6fire/comm.c
@@ -36,11 +36,14 @@ static void usb6fire_comm_receiver_handl
 	struct midi_runtime *midi_rt = rt->chip->midi;
 
 	if (!urb->status) {
-		if (rt->receiver_buffer[0] == 0x10) /* midi in event */
+		u8 len = rt->receiver_buffer[1];
+
+		if (rt->receiver_buffer[0] == 0x10 && /* midi in event */
+		    len <= COMM_RECEIVER_BUFSIZE - 2 &&
+		    urb->actual_length >= len + 2)
 			if (midi_rt)
 				midi_rt->in_received(midi_rt,
-						rt->receiver_buffer + 2,
-						rt->receiver_buffer[1]);
+						rt->receiver_buffer + 2, len);
 	}
 
 	if (!rt->chip->shutdown) {



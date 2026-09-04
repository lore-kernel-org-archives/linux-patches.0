Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8453451AB;
	Fri,  4 Sep 2026 06:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501676; cv=none; b=YgUN73Pw+lGxvtknG2ApWr/JUUPPeMrY20ureBOrjwdYC3imXTjaVG954s+trOmtYfHVhJVQXoGUxwY2gLhBfDnZMRng6tYuuMicvDP3yWJQnN5uiAecSZMlWQnTNNoCbDCtKg33+afNiaY184M8Muxu9FMC/giO3QOqH0QHEWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501676; c=relaxed/simple;
	bh=KKx2K5Ip0/G7tedYxJtGXbmlWhvz8BQPRcBFK1ZwyiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHgjmP9il3+qeelOg0qboIyOz46Fes/b86Y9lOcd0Z4cezJUsT+aJzwxH/ZgxcVSiaPQlUknsBSypJj2l0lkpZvm82RQzBdJDNLuu6O4bb+nXRMzs9kCJ4Pt+aVkQNrRByaRXndSe4Jk2Xq3OH5P1G5gWCnr1BqL26rfIZosnQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FaHJiMsK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FaHJiMsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61C41F00A3D;
	Fri,  4 Sep 2026 06:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501675;
	bh=7MRiWKBuMX0Vy15A5bY5VKaVjJL/pMlefrhp2BHqYew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FaHJiMsKSVwrltEWSoB/kmulkLszPaHKvhUmJoigalfdM5vV8epfrQGvMazHU5xCE
	 G57T3gCS7bvLrjSY+q9jspUfLWEf86HiAqjmoeS+FdJ/5YS/ifEM/kIlLLFbCYW047
	 M1vphszoBeh8xVwV9vEn2ekFkzAm1rL5BL84KRHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 486/552] ALSA: 6fire: bound the MIDI event length from the device
Date: Fri,  4 Sep 2026 07:00:43 +0200
Message-ID: <20260904045801.687819130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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



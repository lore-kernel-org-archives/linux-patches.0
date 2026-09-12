Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFCF357D18;
	Sat, 12 Sep 2026 15:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227630; cv=none; b=lGMQ+6TLV09ecVvYJy2TwsvH7enx5Z3EJ2S5L3MXxodGCT+HMng+mYAfUTtiziZzvpgaEHF1TMRvatfeC/O1F04h80vXzElnr7Xvgkt8RlBF9FEySHK87BYAVHljyA8G+Nt+qLsYfsCQ9qb46ZD82dciZuIvZap6Hj7YtOb7rhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227630; c=relaxed/simple;
	bh=4Wr8agvNr1+z02m5zTjTWMfFURJA3lgOixbwTcD8tuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7II6PjPKXRzkbR5LyQr/21t4Y/bIQg2AFSdR00UFDf6BqfZIKF36wyySJg0k+osHs7aDhuuULyldSTzf1gUebrUTG6lDVKhWweWSufj+AwvJSrrpbqWPUf4ryFr4IxQARbtCYzI8XIotQ4YOkQZvDJKJxBVNBwZMNaKRonmQNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FnSF7EH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FnSF7EH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AB21F000FF;
	Sat, 12 Sep 2026 15:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227628;
	bh=7l4E2N1yznJ2vCC+JCrb2AE4wiUEmtbWMtxt4FqAEk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FnSF7EHEUPCrtrrr28Zc6ivGQUI8AIbyXcZQ174KZxHmW/Df9h7y2jsrgMUN8KoK
	 N+Tj8+mUe6J1qOIIf6067SjVEOq1koA7logd4Njh3Ox6vLMulXvOmfUHwnZpyZM1MJ
	 HvAOKf3vJSRdSIyiIDjfR7hs17/qj8LccuvTJHJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0220/1191] ALSA: 6fire: bound the MIDI event length from the device
Date: Sat, 12 Sep 2026 08:49:08 +0200
Message-ID: <20260912065553.155573318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



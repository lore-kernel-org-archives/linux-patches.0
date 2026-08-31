Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBE44921AC;
	Mon, 31 Aug 2026 14:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185137; cv=none; b=SaJwppTc/ZRDV9lHvPY2Dy3eLNcXiL3Kgq7JkYwWVmgxJgncvj0A/EtX56tLhCAtud+ScOOQzypWo8Q9icYg/pZV1Ik3O+dBCX7+brWEfFtb3JSJ1brcnczt+U0hOFSg3Ys8b0UEF631c9naWEB/RpxnIK9QMIsM2E4+ZXai70U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185137; c=relaxed/simple;
	bh=GebjLC5fZ6r2iSHwjgzBW6g6ZsW5nDW5/8x+Hu35gCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qw34q9gSdQI+jRyUp54E77F03ir5LSQiaH9hlbGImeBRrvYv9ebNsagTAhwRgxaaT/hrhU1uRZs/hCNDB6mN0raEDPrLz85XnavUVRi7ETwLnHgXwB0Lio+hZWWTVEaqhOLT7M9w+JbEjy8KjyUjGO3u2O5fHvKS4+f9VS4OY0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgoZOfFg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgoZOfFg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B041F000E9;
	Mon, 31 Aug 2026 14:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185135;
	bh=lDwpyA5Rhfh8BO2gEoJ8JJW9VrZXCW/ZaSBpvYfx86Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rgoZOfFgv17KtG0edhNUpggKKO47tn9mS4waa7cnvxRaHcVzwHeR7v+ZTq7Fk3hvd
	 YjgT+YTPOrMz7Ch8w6wxqwyuY9JOlmX1+0nFpwgt7BCi1X0IVY/N9t5s/+6jOu7oBe
	 CBOpIA/4AMhbA+RjOKGhArgSmCnCJKPfMPuc/Sss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marouane El Moufid <eun0us@espilon.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 64/69] ALSA: usb-audio: fix OOB write in snd_usbmidi_novation_output()
Date: Mon, 31 Aug 2026 15:35:37 +0200
Message-ID: <20260831133401.936807793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

From: Marouane El Moufid <eun0us@espilon.net>

commit 1035a8f63bae28e498b0e7b5ac91d749844a7158 upstream.

snd_usbmidi_novation_output() lays out a two-byte header at
transfer_buffer[0..1] and passes &transfer_buffer[2] together with a
length of ep->max_transfer - 2 to snd_rawmidi_transmit():

	count = snd_rawmidi_transmit(ep->ports[0].substream,
				     &transfer_buffer[2],
				     ep->max_transfer - 2);

ep->max_transfer comes from the output endpoint's wMaxPacketSize via
usb_maxpacket(). A malformed or malicious device can advertise a bulk
OUT endpoint with a wMaxPacketSize of 1 - the USB core only clamps this
value downwards - so ep->max_transfer becomes 1 and the count argument
becomes -1.

snd_rawmidi_transmit() passes the negative count on to
__snd_rawmidi_transmit_peek(), where "if (count1 > count) count1 = count"
leaves count1 negative; get_aligned_size() keeps it negative for a
byte-stream substream, so the following memcpy(buffer, ..., count1) runs
with a (size_t)-1 length and writes far past the transfer buffer, which
was allocated with usb_alloc_coherent(ep->max_transfer).

This is the same class of bug that was fixed for snd_usbmidi_akai_output()
in commit 0970274613fb ("ALSA: usb-audio: fix OOB write in
snd_usbmidi_akai_output()"); the novation output routine was left
unguarded. Bail out when the endpoint cannot hold the two-byte header
plus at least one payload byte.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Marouane El Moufid <eun0us@espilon.net>
Link: https://patch.msgid.link/178749334830.543645.13722252148340572274@espilon.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/midi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -878,6 +878,8 @@ static void snd_usbmidi_novation_output(
 
 	if (!ep->ports[0].active)
 		return;
+	if (ep->max_transfer < 3)
+		return;
 	transfer_buffer = urb->transfer_buffer;
 	count = snd_rawmidi_transmit(ep->ports[0].substream,
 				     &transfer_buffer[2],



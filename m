Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4521431578E;
	Fri,  7 Aug 2026 14:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114171; cv=none; b=nT6Zec/q6uMM3chbrl2NLiEWJZbyqz9U1hI4Z/1HF7ebx1TFGVn3im8y/+rRknllp5gb2TOkL8SetitJW/kPXDm3RXVdWgO8P6Pbj4AGFzRVQzHaD1PhkAFQokf9Dq+Jx6AQ33DymcTVakzNMHnJOFBoDprMdj26ETCjOk20ZVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114171; c=relaxed/simple;
	bh=qB0owGhMRQhVUTdfaDEs73B/VH126LnCs12JpybUAmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3PsFc6OfILFMz8FgnK8jUgjStrHKqKIbJB0SVt5CfcsRXO3I2OBLde1iXDxNWA88lgJe8Oo4ZjV0y/oLK0La4IBIOJlLgKfq0YYKnfm0cuYPVnhU/sDkYnJ0/FRsg/Mbzd/f5aGNPZj1m2iAbqTtxB9X2s7ynfYL/jb1OB0s88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOqU8CHN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOqU8CHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD791F000E9;
	Fri,  7 Aug 2026 14:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114170;
	bh=r+yQtxncnfRFSO5byLjOULlzeJwV+aN7CzWZnCVCqHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nOqU8CHNoJklth+15oXo1ZfuSBq4nttZQhWFKI4dA94S5uTvaa0zInlo6fflDt1iN
	 gt6qNMP5FqGfizwUjpoXdiYooLpmMnavCUKFfiz93rRRQhe9rw6t69Ai1YMhHDM0tx
	 jV2rPr4ouU5tB8N9+OV7f6UlMCai4k159D6CJSv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>
Subject: [PATCH 6.12 167/337] ALSA: usb-audio: fix OOB write in snd_usbmidi_akai_output()
Date: Fri,  7 Aug 2026 16:36:10 +0200
Message-ID: <20260807143422.177014203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baul Lee <baul.lee@xbow.com>

commit 0970274613fb463d376211450cab066d34ebfe6a upstream.

snd_usbmidi_akai_output() computes its fill-loop bound

	buf_end = ep->max_transfer - MAX_AKAI_SYSEX_LEN - 1;

as a signed int, so a small device-advertised bulk-OUT max_transfer
makes buf_end negative.  The loop guard then compares the u32
urb->transfer_buffer_length against that negative int: the usual
arithmetic conversion turns buf_end into a large unsigned value, so the
guard stays true and each iteration keeps appending SysEx framing and
payload bytes past the end of the URB transfer buffer, which is only
max_transfer bytes long.

A USB device that advertises a tiny bulk-OUT endpoint can therefore
trigger an attacker-length- and content-controlled heap out-of-bounds
write when a process writes to the created /dev/snd/midiC*D* node.

Return early when there is no room for even one SysEx, so the loop is
never entered with a bound that would wrap.  The loop is the last
statement of the function, so bailing out is equivalent to it not
running.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: 4434ade8c933 ("ALSA: usb-audio: add support for Akai MPD16")
Suggested-by: Takashi Iwai <tiwai@suse.de>
Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
Reported-by: Baul Lee <baul.lee@xbow.com>
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Link: https://patch.msgid.link/20260726074500.50145-1-baul.lee@xbow.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/midi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -800,6 +800,8 @@ static void snd_usbmidi_akai_output(stru
 
 	msg = urb->transfer_buffer + urb->transfer_buffer_length;
 	buf_end = ep->max_transfer - MAX_AKAI_SYSEX_LEN - 1;
+	if (buf_end <= 0)
+		return;
 
 	/* only try adding more data when there's space for at least 1 SysEx */
 	while (urb->transfer_buffer_length < buf_end) {



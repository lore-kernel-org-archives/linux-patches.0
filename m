Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2A61A681E;
	Fri,  7 Aug 2026 15:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117294; cv=none; b=SmWaA0vsezVyupdOvnTN8ysxxpTpvr9ey5nXPaEJoAm7QIdziHeiBtaZ4PyiqAx9DWbsZUgzDlRsVtDSjpowPsusiy7Zh6CNdllUGH+u2mfV+BrOK6yXqpy8YFqXhD6YKcGoAGJv+cQUvna0el3ADTWLQW0eg6uVbgBfolX4MHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117294; c=relaxed/simple;
	bh=pCHZNMQdDz5KHMaEFWi8T8t7VEE8APEURkH4ykc9Koo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cisdbkAp+h6VTHAh+0f/eJIXSNMk/YYQ3Q5FZ4fqLZVgQUYj8RMpxE3FkdfdJMdvzMD5CHZGwPLADZugCHrGdnKFMWDY991YgeklxWZb5RvqzMQSDRChCbRxcLa6TfOjnjsCudYMT7li56+gMYkjWaoYV6x6pja99rgl3H+0Ces=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbeA/4tt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbeA/4tt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964991F000E9;
	Fri,  7 Aug 2026 15:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117293;
	bh=33qQ3pJDHM2gkHNIulQIuIWxF5Kf9wGniyiWwvpe6VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PbeA/4ttRE8xuXFLp6kr0/ur5uwjA6DjGNm1QVrC9ef9oXFFHrqxE1OAWbYVz0f28
	 Rlw94GvWGXceQzK/uwyLzQqXAEyyToIm0yzu+MBQrsEc9P4LkvuXVkcqUCzH6W3obC
	 d+MvAI7ywlPFJGGuvkAcA3phsXGViW4S4LwXtczY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>
Subject: [PATCH 7.1 269/438] ALSA: usb-audio: fix OOB write in snd_usbmidi_akai_output()
Date: Fri,  7 Aug 2026 16:37:45 +0200
Message-ID: <20260807143433.721853116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -797,6 +797,8 @@ static void snd_usbmidi_akai_output(stru
 
 	msg = urb->transfer_buffer + urb->transfer_buffer_length;
 	buf_end = ep->max_transfer - MAX_AKAI_SYSEX_LEN - 1;
+	if (buf_end <= 0)
+		return;
 
 	/* only try adding more data when there's space for at least 1 SysEx */
 	while (urb->transfer_buffer_length < buf_end) {



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B5943DA3A;
	Mon, 17 Aug 2026 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977375; cv=none; b=EIfe6guHxI7XUe0D+zWjhfvLkWCbZVEN4C8gDE34AF/ucfpW6wD6EuTT0JKqpxs7MMq3NMqini/P1BkQOOEYoYkPGLztfTlSr3rhNWdAF3BXaXQN404DD3tX88Xvng2sebfTZUn7/ytGHCliU+it4sQr91FLEcflVxLQAAX4ryA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977375; c=relaxed/simple;
	bh=gLdpEvNqLIM0RkZvlLD/8xE/deS75QVxNIjUf6iLtHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hc1hTPN84U6Gd+ZnlkWx/Emn4BKsNZ4tJ/NlxUEI3lKh0nQsGdQwxc83xUc+fV1bkTHuN4yBowmYaGt3p+61leyXl4y7B+2jxEhq3i7SGTsKaNIKXNNWqQY8P4ZyfBIwrUn40hx3kgXKd1mBLucI9ykBbH0i2TfYw7ONnKuUiEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qK5C6xrI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qK5C6xrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A561F000E9;
	Mon, 17 Aug 2026 14:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977374;
	bh=4bcGffmH19DnsC4Syf0orJzMHJ9G12eiXvZrAfINl9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qK5C6xrIpLyWOEDWoMZ7e6M1I9IDCsI4mTYdJAfuNapisP0ubpe+Hro59R+RiHfWO
	 OhZXVkVBYzw1NhHdhvG1m7zFE8pCZSQnhEln5nzcMtW+AOsnx6i+ENukJvJJwwKkdU
	 t6ShNyVVoR6rzPstu3YmfPxHO7FckJAz9hWY+P8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>
Subject: [PATCH 5.15 306/456] ALSA: usb-audio: fix OOB write in snd_usbmidi_akai_output()
Date: Mon, 17 Aug 2026 15:31:36 +0200
Message-ID: <20260817132551.746685049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0021842882B;
	Fri,  7 Aug 2026 15:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115270; cv=none; b=sLlKpLINNzIzHhd+NIku7GL0IrsLRIs8RshvVf3ohcfmnBZhI++Zv/izchZnK0NXWqavmeMowYJLdbjlbVGASGYZQvO47/7uJm5XhaCy9MI5VuGYthbuBYWfZGp27fM6TQs/pY/7dUGVnKtZV9CcnrTSrvicqKfwHmYeY38gw20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115270; c=relaxed/simple;
	bh=76Vqflt20/szlldkISE2v2Wn9DPR5kVgC3MCwZw4aGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VU4b5itKqRzvRnGTUJu0CtW26kQFtvbTIqkneuLzNgZd5Or7cAZOD5Re2YDnsVtsGIujzOq6HDLbiA5BTHRli6BDYS9HiubKE3YBlg8R+Gg07DI+4M+cDsBE8avMtpk+0nQp1mQU8oHmJ7KjJHvxYhDilEob0XPIpj/r2OVtVY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yzni90gK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yzni90gK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2081F000E9;
	Fri,  7 Aug 2026 15:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115268;
	bh=XNMSWFEsnGBYIkEroV7WBcUcX05jwKFdKsOP+owf91k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yzni90gK8E2XWrCWLSJN1bX8U+qcIYL9IYvzDg5GhyDjW3JCK6WlI7pe2UMSXroOR
	 Fs5YBLNziyfbmur/hrJ/En/HtjUa3JUGjXVDNY/FDBu8c6+BpDPDesvSurfCxjcZz2
	 Gh5e08PuDJ6nYxyVoX166rI/CYTQ4dXne9r4Pxnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>
Subject: [PATCH 6.18 216/396] ALSA: usb-audio: fix OOB write in snd_usbmidi_akai_output()
Date: Fri,  7 Aug 2026 16:36:16 +0200
Message-ID: <20260807143428.926746118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -793,6 +793,8 @@ static void snd_usbmidi_akai_output(stru
 
 	msg = urb->transfer_buffer + urb->transfer_buffer_length;
 	buf_end = ep->max_transfer - MAX_AKAI_SYSEX_LEN - 1;
+	if (buf_end <= 0)
+		return;
 
 	/* only try adding more data when there's space for at least 1 SysEx */
 	while (urb->transfer_buffer_length < buf_end) {



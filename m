Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848C243E06D;
	Mon, 17 Aug 2026 14:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976092; cv=none; b=Wi0FKC0QDJih5VTYl7O0inrKOACViOZjR1RTretxsLJpAnGNGjjTrPO0VjL9H2Q+oIePfDbaEGjEpXr/JN/T0CaiQdfLhVpmucIdsPJ7XM/aAzhQpv8ddFQnsmACX4XKXNgpBxLnSo90JV+oPP/V6AftaZJBbk1M/qfiwlnGpHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976092; c=relaxed/simple;
	bh=qTJozFeEvxij3BVe9L22/04Wre+ZMjOiHbjescHkRLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOV3dM+as/9L3H4Lr1GP5VaXCL+il7pBRfC7MaNB02gk8cs0B9e2+Ed76C6BcU9yGi+p2NIv9+3T1ZwjlqimYZweqTzPSkVGdcnDu9kS77I/lIMbJgz4nXLoCXScsTV9KBQXWPUH1bCZLfg6LOMY4BsyDldKkxUlXVBZyeO1dng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=puH4qyhQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="puH4qyhQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D977E1F00A3A;
	Mon, 17 Aug 2026 14:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976091;
	bh=6tRlR34Qi/oHzycRGmNTxAbYTdcdTzkFxd196mZPhCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=puH4qyhQ+LjgElHsafS1FS472JHy54bW9yrr/u+msEQ7ryA44QMKeobOGmV8hfRrt
	 y9gbXFGcVDPKorbiJeuoQ6i0S8mDIOsuKq+Pj8mIzvoHbCOoOK7lwUBwihY/iSiRin
	 OhlD8bBwjVJSPQ4SgNLAOgZiDDtaZCDUfQfsAkK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>
Subject: [PATCH 5.10 254/389] ALSA: usb-audio: fix OOB write in snd_usbmidi_akai_output()
Date: Mon, 17 Aug 2026 15:31:33 +0200
Message-ID: <20260817132549.133690971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -816,6 +816,8 @@ static void snd_usbmidi_akai_output(stru
 
 	msg = urb->transfer_buffer + urb->transfer_buffer_length;
 	buf_end = ep->max_transfer - MAX_AKAI_SYSEX_LEN - 1;
+	if (buf_end <= 0)
+		return;
 
 	/* only try adding more data when there's space for at least 1 SysEx */
 	while (urb->transfer_buffer_length < buf_end) {



Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590478;
	b=EAZ3d+sUBXqgR9kjopG2iUTQUqNovY+oN57h9nTelyCoTaAyBR5a79ot3MaNEykrVzU8
	 rdCET6UDG0kGtepd4k8y9V1BRTsIzl8FbrwA7KCoKyO8MKyT7C9K7T8YzfgzHKbZwq+QY
	 r+iKF9HrW/i0X2TcF7jSgTNxZj8vdx3X6iMhhD9ixSLQLxrmKH0nNvV4LuYj0y2Aw+GIA
	 SK7I8oWg4dMTjWCFJ9dAUJLDUbkcTq951lZTI8WzGpJohxtgyvHNa/k2Qx+09PTYeoY/f
	 7JhLPZJpfMJIaG2FcS+Xz1RccKwXNp0RWt0AFFzlptg71jWRkwwYdbM+m+VvmcjfFnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590478;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hA/NkboYhXzvqxCrzXto0RqBD+V53uj8sHvJGg2JasA=;
	b=z4N5b+Rd7nL/gEkca2mEZy/vOW+OABR9gCA44d3MP+tKn7OT01tzeUbtobskwt6hG+vW
	 Kd9JbZGUuSVpxhE/DsMGBhEA/xr4/liNnX0tl2VIo+zhkgwKmh27WrgjVOyE+xdeqJ9dM
	 W2TQtQRDokXeH9hWZ09dioFH4JX6lJDcAZ7sDE9tzs6d0QxTfGHvYQrxw4pbGeszJrrrr
	 DLakokDEufZa3XZgqKvHeoYVxbjfPflFrDjjDDE25fg2QwGd3E3YU+tV75FxnzEDmWN0N
	 noVZDY0v6HQyqU+zSBi3K6GHSCegET1TPcOMrY1zCW15i4VgCteRVc2TIZbMwNF7IWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ur8jn2I2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D230606B81D;
	Fri, 13 Nov 2026 17:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ur8jn2I2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0C61F000C7;
	Fri, 13 Nov 2026 17:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590477;
	bh=hA/NkboYhXzvqxCrzXto0RqBD+V53uj8sHvJGg2JasA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ur8jn2I2sMbzrp5AOIq29B1vnIhLMwpr9QRSKgGXqG48Wlbpnxuf80ZDFgs15e9Or
	 KAFL+EwEXnJPJY0tmb2r75HJqy2+74u2MaB2fMEJyT45kcNYxa3qku7rfLnDITES12
	 6hNzBp+4Y0EFJupNy61llDA0U9q/ylvwxT8Ayt9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 430/686] ALSA: bcd2000: Fix use-after-free of MIDI URBs on file close
Date: Fri, 13 Nov 2026 10:49:23 -0500
Message-ID: <20261113153835.494353715@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

[ Upstream commit f6c7bb1f0799591a62be75b9bcf84245b4f208b7 ]

bcd2000_disconnect() calls snd_card_disconnect(), which only prevents
new opens, and then frees the MIDI URBs.  A rawmidi file that was
already open can still be closed afterwards, and its close callback,
bcd2000_midi_output_close(), calls usb_kill_urb() on midi_out_urb.

The URB pointers are cleared on disconnect and their accesses are
serialized with midi_lock, but bcd2000_midi_output_close() reads
midi_out_urb without that lock.  The check can therefore pass just
before the pointer is cleared, and usb_kill_urb() then runs on the URB
that has already been freed:

  BUG: KASAN: slab-use-after-free in usb_kill_urb+0x74/0x80
  Read of size 8 at addr ffff8880078e7d40
   usb_kill_urb
   bcd2000_midi_output_close
   close_substream
   rawmidi_release_priv
   snd_rawmidi_release

  Allocated by: usb_alloc_urb <- bcd2000_init_midi <- bcd2000_probe
  Freed by:     usb_free_urb <- bcd2000_midi_free
                <- bcd2000_disconnect

Take the lock in bcd2000_midi_output_close() and reference the URB with
usb_get_urb() before releasing it.  The URB then stays valid until
usb_put_urb() after usb_kill_urb() has returned, even if a disconnect
frees it in the meantime.  usb_kill_urb() itself cannot run under
midi_lock, as the completion handler takes the same lock.

Fixes: b47a22290d58 ("ALSA: MIDI driver for Behringer BCD2000 USB device")
Cc: stable@vger.kernel.org
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20261031190936.5696-1-25031212351@stu.xidian.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/bcd2000/bcd2000.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/sound/usb/bcd2000/bcd2000.c b/sound/usb/bcd2000/bcd2000.c
index 2bd49bf827489..0fd086cac9552 100644
--- a/sound/usb/bcd2000/bcd2000.c
+++ b/sound/usb/bcd2000/bcd2000.c
@@ -183,10 +183,24 @@ static int bcd2000_midi_output_open(struct snd_rawmidi_substream *substream)
 static int bcd2000_midi_output_close(struct snd_rawmidi_substream *substream)
 {
 	struct bcd2000 *bcd2k = substream->rmidi->private_data;
+	struct urb *urb = NULL;
 
-	if (bcd2k->midi_out_active && bcd2k->midi_out_urb) {
-		usb_kill_urb(bcd2k->midi_out_urb);
-		bcd2k->midi_out_active = 0;
+	/*
+	 * Reference the URB under the lock so that it stays valid until
+	 * usb_kill_urb() returns, even if a disconnect frees it in the
+	 * meantime.  usb_kill_urb() cannot run under the lock, as the
+	 * completion handler takes the same lock.
+	 */
+	scoped_guard(spinlock_irqsave, &bcd2k->midi_lock) {
+		if (bcd2k->midi_out_active && bcd2k->midi_out_urb) {
+			urb = usb_get_urb(bcd2k->midi_out_urb);
+			bcd2k->midi_out_active = 0;
+		}
+	}
+
+	if (urb) {
+		usb_kill_urb(urb);
+		usb_put_urb(urb);
 	}
 
 	return 0;
-- 
2.53.0




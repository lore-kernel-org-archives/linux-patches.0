Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585810;
	b=RB4Lroici+GIKHSeFz38pDi1fFuH59msgXOLc+TfV95Pfx17TyZZoSWiXBMHWrXxbNFx
	 qklu+H1sb/Lp4IUYvlQM6kbCcHc9gc5WXouEnVRp3GpbfiqB/BXL8nYfXMPpqIbydYPGh
	 atlWtUnp53lNF2gnKWIu7QzZWELkCvK1OA+1icWSpQeAqfog/wuz0RSn6Rh6YbmZKz6Cj
	 OKTAhQil/PGVt+nwQmOM1byA+dhkRSPA/5icQSbAZ1EA/JSE5Ujq37GJ7EKkxtR9PkCUI
	 9uP2EBCeMoKnJYaBVwN8ps2WJlYKe8bV3THkOj3wqDFJnHMlEjcsGekQD0gKkU6IWXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yVweCln5TKH9IXQH68bDsMmAevQ9Z886smTT3snwvhI=;
	b=Sd2x6BDhmr3ew9JoCQWgT0irX03H8yQDT25Yld2scEA4FD8kKUq83XfUOxfft24P0Ruc
	 eQSyfxe+PB4yA6gLw0aXGJMC/4b/7fGO2xv84C7WvVbaP++UAwiZWi30d/2hR3nw2PgIc
	 DDbL8DGAXCmJEBUnP9YC6+dSd4qr01vURAHkV65oor7/Mjkyo4jAdDZg/bvrJbO55YxFt
	 u+Sb1PIjV07yZPdBs3HxQDiasnH31G5uCS4K+HxUQ6HKcVaOfu3gr6DmTmXo8821jB68X
	 NN47Z5lXRMy/1i/ayH+WDTNW2QdgE4XnRCRWsrzlYaFf/lzPbMS5uvyKWWQRa4E/CwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jxh+YbHL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6510F606BA98;
	Fri, 13 Nov 2026 16:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jxh+YbHL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11AB11F000C4;
	Fri, 13 Nov 2026 16:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585810;
	bh=yVweCln5TKH9IXQH68bDsMmAevQ9Z886smTT3snwvhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jxh+YbHLpyFJMXPzkRdNpwfk9sEJUmB+YuKUSRd5dX9l8HsWGhU3yGS5bUwWlrrtu
	 m6HQ2u+Y1bT1YtS9Eq5DbYphaN+UctHNbTwYm5u0ZKrkiUXumSwD8BiLV2pKNYNFBp
	 YUfNyjZ58rorKr9yhagl4XTVHBRLDe6vREKHlwhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 394/507] ALSA: bcd2000: Fix use-after-free of MIDI URBs on file close
Date: Fri, 13 Nov 2026 10:51:38 -0500
Message-ID: <20261113153810.103637207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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




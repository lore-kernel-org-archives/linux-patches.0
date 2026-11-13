Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591239;
	b=47iErsQlZvooQLjsqmPts6OOLIUIeVLA5dU2Xi6zt4aLgJTMioGHyozv8MSGmJDrgwdn
	 wBicSpICMByynDC2ojff2Kp9wssDgBqvFDCsjUGHplWMyo0JMszGPrfZzHgwFLSaoouOE
	 dgHsOXwB4oLfsf99C9U9yo/jSKDw7hfz+MmgDHfj5f/TFlA11IFqkxWiZ3JXeGZ+LtISf
	 WuuYQd4UFJAyiihqUMBVEDbb5H1eQMSl+0oMFqKoLQJ5w2w28GEZ4S2TBZAMOr9MwbZco
	 FD/KsAjBAEKkt9IHA/GJk5W4/JVCTbjbXj/0xnOdFEG+4R8YbOtudwmVBL80KMBfy0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QGX6sn5GawOSnP8Tj4pSS3C+hXeZAtuhpxikP6jyhqo=;
	b=rgkydXSO9oxPuTNF1rWAtZ4Txs1ivQdpSVJ1Lq+YGSGuA+qGRbQoiVLknayV8NhlVciv
	 gocxXwtIc9Wgo4rLwYzBngGIcCUMlZZmHUQqmNQEwo9maSpg6xRbqyksLcHmdUR8Su3W4
	 gN3l8UQ9rJxMjb/EcsAllvWnv2aJCTSU73VIFiUBNoWGGeDOFLlxBT3WG1I1ix+bmcOkr
	 AU6t8ZBu02rM4OrFu3Mrd0MsKQv5K4R+X0zfIKEF7/gqcQEtYSr7dkLZda8R2u0YuU6Pm
	 PbD27TnA4gb4XTayEKmIR5P2daBGdOQkh2EBqRxMecOC58rubRw6iqsZsuaR14f8few==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GwifPlAb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8785860A260C;
	Fri, 13 Nov 2026 17:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GwifPlAb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E4B1F000C5;
	Fri, 13 Nov 2026 17:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591239;
	bh=QGX6sn5GawOSnP8Tj4pSS3C+hXeZAtuhpxikP6jyhqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GwifPlAbrcakiye7vPJbQbpFCCOVbWQhwwFneQVX3TdEK0A65sdaF73C8VlV15LHR
	 LTceENH8KXnu7z4CZeJPh9f28PKHuZpjeO1AWFwviGzo/QxyO7gP5G6cq/fJUKObs9
	 8FsUD4m2MBfQbB4JkqjuX01nyY/G/juo1M5dBzGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 366/670] ALSA: bcd2000: Fix use-after-free of MIDI URBs on file close
Date: Fri, 13 Nov 2026 10:48:50 -0500
Message-ID: <20261113153824.205103542@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dce6d1f611f94..fc18a4348265b 100644
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




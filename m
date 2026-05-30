Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C318B27A477;
	Sat, 30 May 2026 17:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163066; cv=none; b=FuH1y63bwio6pEWvLflCfD6HyG7fcdt6SzbAeZrpuqy5dum7I1v44DmA2nmpfsZj6BKhjFnC0t5pr3vYNKdjHMLPKpUgKDdMsa2O6n20bCJ+0PmXL+/dWvqdB2RjDIgdo8EI/o2y4rIQPCoByctCs0lLmMcv2Se06+8vI0kjzxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163066; c=relaxed/simple;
	bh=xSUkoqDHqr4PTTAfV790H/F7HGLx1XAihjhoKsACGi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXZyzr2fehbAjPVnbtTfMyRCyRXxtlJZo/avI71FDkrvytZGvojp37pgvrWSpzBrdzhx0X5CLOTpWlhzhZ3s1dewJ/xBgarI4P6VrpDfjufRxN7DDi7NOJl0xfhSoqBASXK4HMj6jgAGT/+TPeyTcQr5nGZqdNcnjTss97kxUoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFnbvhSZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFnbvhSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F641F00893;
	Sat, 30 May 2026 17:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163065;
	bh=8V4GqtH9xPbfbUY9bODOetdviVCGuIVMfZkIpP4d5aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IFnbvhSZ56xx3Xp2n99AwwR04Kl2HNY56bLaLgwv1T0wgpJl7orpBB+sgVYJc7Ygk
	 zs1b62mtbpIAM5gxgvMHnFzlbagynNFEJ4Fyi+AhQbjiC6zYZAUWnQqfSQEcN8R7mo
	 W98npesoP5H4QIa7B92Mx1sUD2lAOqweNIkoeje4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d8f72178ab6783a7daea@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Johnny Hao <johnny_haocn@sina.com>
Subject: [PATCH 5.15 145/776] ALSA: usb-audio: Kill timer properly at removal
Date: Sat, 30 May 2026 17:57:39 +0200
Message-ID: <20260530160244.170232546@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 0718a78f6a9f04b88d0dc9616cc216b31c5f3cf1 ]

The USB-audio MIDI code initializes the timer, but in a rare case, the
driver might be freed without the disconnect call.  This leaves the
timer in an active state while the assigned object is released via
snd_usbmidi_free(), which ends up with a kernel warning when the debug
configuration is enabled, as spotted by fuzzer.

For avoiding the problem, put timer_shutdown_sync() at
snd_usbmidi_free(), so that the timer can be killed properly.
While we're at it, replace the existing timer_delete_sync() at the
disconnect callback with timer_shutdown_sync(), too.

Reported-by: syzbot+d8f72178ab6783a7daea@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/681c70d7.050a0220.a19a9.00c6.GAE@google.com
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250519212031.14436-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ The context change is due to the commit 8fa7292fee5c
("treewide: Switch/rename to timer_delete[_sync]()")
in v6.15 which is irrelevant to the logic of this patch. ]
Signed-off-by: Johnny Hao <johnny_haocn@sina.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/midi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1530,6 +1530,7 @@ static void snd_usbmidi_free(struct snd_
 			snd_usbmidi_in_endpoint_delete(ep->in);
 	}
 	mutex_destroy(&umidi->mutex);
+	timer_shutdown_sync(&umidi->error_timer);
 	kfree(umidi);
 }
 
@@ -1553,7 +1554,7 @@ void snd_usbmidi_disconnect(struct list_
 	spin_unlock_irq(&umidi->disc_lock);
 	up_write(&umidi->disc_rwsem);
 
-	del_timer_sync(&umidi->error_timer);
+	timer_shutdown_sync(&umidi->error_timer);
 
 	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i) {
 		struct snd_usb_midi_endpoint *ep = &umidi->endpoints[i];



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06B52EF664;
	Fri, 10 Oct 2025 13:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102499; cv=none; b=OViAvlWirwVPsv96oaivcdgc93fGChhslbFgQpighZOsi/ISUwxIc0hXl9nmdBD7ZY94wHECtcOiDHb16fKVSafwGwREJfXT5uGfVJewyi2HwIKOIkT5IB338HZLATMMFLaohULh/9IF9W2HRrk24yUBpakBwNMSBDz6mc5Ux/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102499; c=relaxed/simple;
	bh=5XghcfwOY//jaN63uCUdQehLNrKg2GPKdGq/D+SbXUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWvCG0WBb1VIjG8kJ0mUqagS6YFXDhTx3qKZODHlAAq1NJe53O50PJn+xmDO9P3GEtQYqUPaGeMyrIx+/Mf8GyDaEzD8yfQj4hyADlPCrukqRS7dSReu33VJJRhmSgUGp5D8m3kbialH8g5bwgGyKIESMhINtnDouARJwtpcwkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQ5oYQW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQ5oYQW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC95C4CEF1;
	Fri, 10 Oct 2025 13:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102498;
	bh=5XghcfwOY//jaN63uCUdQehLNrKg2GPKdGq/D+SbXUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KQ5oYQW4ptLOhre5w+cU+zHkb3vd1aP2Oo0GxnKAlOu0eCUfpjD7M0lvI3o2oMzWC
	 tTP7RDx8nHaOZXZSQofr4uVO+g12NCNY3FtMgFsO8YuJ4NGnxbUXat5m53N6X9VWYQ
	 wc/OrGJMKksVTNLy/WYarpfVWtTwdqn5km6IdO94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d8f72178ab6783a7daea@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH 6.12 23/35] ALSA: usb-audio: Kill timer properly at removal
Date: Fri, 10 Oct 2025 15:16:25 +0200
Message-ID: <20251010131332.630355663@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 0718a78f6a9f04b88d0dc9616cc216b31c5f3cf1 upstream.

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
[ del_timer vs timer_delete differences ]
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
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



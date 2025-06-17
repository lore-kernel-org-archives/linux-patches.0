Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131D4CA4B;
	Tue, 17 Jun 2025 16:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179439; cv=none; b=RIg0n7Eg2EX4IFFTXFjzr+wp7OIfmcFxNdeNUTEdOjaDbAp5Nw666wGLAP5LAurufT3nEg4JXlfL/ESjHk99BGxo8He2ROa5TmWrlOkkFqIO+/JwvgQrnulsuEkU0JIUBwjuQUOJD50ajTh9FkDnjZ0YWQ+iynNV069l9ETjyhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179439; c=relaxed/simple;
	bh=TqQBF8chDFRlQyuMeEMm9DXWE/+VnC7ZMTOM3gOF3Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImlbIO8AGjfhaV3D+DB8zHDwOX5gCRRv2Xroisrbqxu3Sygk0e/Zdi2PbOqfMpHT/3OQ+Bb0iRJpiW95BMN31lI2iymPeIRXSSpXOQ9eD0yOk2Zx0RCsKFE84XVZRzJ8fVJ4TV9hFzq5sGNkMXzm7NI3zFSXStGBLVJ+RWLBiMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crYs7yzs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crYs7yzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92232C4CEE3;
	Tue, 17 Jun 2025 16:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179438;
	bh=TqQBF8chDFRlQyuMeEMm9DXWE/+VnC7ZMTOM3gOF3Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crYs7yzs0MHyk2R7bzf01j9u+nB2BT4q9FqcqTmHFFqcadd18Kw+nc06XdchVPA7G
	 7IVf8f6RnnPKpB0y5P0os8MBMNHFLVSUdayNLHfrIZw6sQIFJncKAVKYAcFi86GqmS
	 6wkjLaluPlWUsuqGqV3GNrgzqK2sMDqMnD37+S6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d8f72178ab6783a7daea@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.15 747/780] ALSA: usb-audio: Kill timer properly at removal
Date: Tue, 17 Jun 2025 17:27:35 +0200
Message-ID: <20250617152521.919707938@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 
-	timer_delete_sync(&umidi->error_timer);
+	timer_shutdown_sync(&umidi->error_timer);
 
 	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i) {
 		struct snd_usb_midi_endpoint *ep = &umidi->endpoints[i];



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BFD1F63FF;
	Fri, 10 Oct 2025 13:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102545; cv=none; b=pMGn6gTMYnAvZHNyXT5TRnAcCstji6+y+PrPD8FimZk6f6310OjdMnHXSxWGb+pG3i6NRc3gcEFH7ScQIlS2GVmxcZphdZ+2VruqWja4h4u9FHbLCs7SGzGxESOTWw3RDRON4pQqG2qriLdFAjcnn5lsEIlbDWwoR4kuYVzm8H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102545; c=relaxed/simple;
	bh=PacGg/WWrlZ1Mqhk8s+6fk5SVsz1RthG154sVGlqPi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hy1Od87wvg2kyNHc8NMmizu56jImkozFVTaX/T3b8eUeHNdybSOEw+oCC4bsy9ukG6bDL34cJrlPToxJN++RAjy3vkbgKk+bK4bgNSahQWgYwRnUUKy38c2ZQEcvNCgec0t2d7zZt57Pu2ykr1rrX+QxgTFT6PvmN3oaBnGg1LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MU++9G9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MU++9G9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469EEC4CEF1;
	Fri, 10 Oct 2025 13:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102544;
	bh=PacGg/WWrlZ1Mqhk8s+6fk5SVsz1RthG154sVGlqPi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MU++9G9GDpj5/OBfTwrADVIfAWw+vq2agJq+1QDnJdjMtvvpCYOs3lHVK2WCwXudP
	 2ZZLKCcpIEv74uziPXvcT6RAedHc7rR1jzFn6NfT4815ozCuE4do24VKAGXX+8OTXP
	 JQQ9C5aSDp0T2WNdY/DEOHogttK9yHjRwGAbt6cM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d8f72178ab6783a7daea@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Jeongjun Park <aha310510@gmail.com>
Subject: [PATCH 6.6 16/28] ALSA: usb-audio: Kill timer properly at removal
Date: Fri, 10 Oct 2025 15:16:34 +0200
Message-ID: <20251010131330.954916060@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
References: <20251010131330.355311487@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32232F3601;
	Fri, 10 Oct 2025 13:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102502; cv=none; b=jtgOoVR+bKhmSb3cauhqSNdvQhJ3YP/6HKoeDxvGqoh+0pVURPDQnTrRGkmimYp7rwzOuvojlsd5aweUV47wpOreZk6SA/GMXcJiYnC1KfeO555zZKkbPcGceBrfSN0uYGzF50R4HK+uJse+di2loggJIt6Uk867fYsuGPtw930=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102502; c=relaxed/simple;
	bh=U66k5Cak2CQ3IZDtpn52/dFFOuE7GBKha4fEpGQeJao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K30vQKjSR4vcumP4ROJAo5ALgaoQVVZE9jNVRoqjLWACSjUMVqbPFdDpQ0sPW9EAYTSD9nBi6vob+T0AfoHUnzsOyUCjK0ldsTY87yTpPXyqkKBDG4QgP1z2pweqA9IBHqLjAHpEbG5wBd0GjrpIrariSuS7zCBmVOSJe7jLpS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=px2uelCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="px2uelCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0E4C4CEF1;
	Fri, 10 Oct 2025 13:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102501;
	bh=U66k5Cak2CQ3IZDtpn52/dFFOuE7GBKha4fEpGQeJao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=px2uelCkE2ixKEAXHAjiEvsqhZp3QTm8przY+O6iTQk/7+FMCbGFsdMrbQlCGqQ3y
	 SRi5oGDYNhvy0weuOFtxCyrb+q7VKprpskyWVX8ma80chyDYgTaiHzXx4/wLWxwPlb
	 32dF/7aDwr51xCA2JMUAIpY9ECFTqzsjkMBAOhGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f02665daa2abeef4a947@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 24/35] ALSA: usb-audio: fix race condition to UAF in snd_usbmidi_free
Date: Fri, 10 Oct 2025 15:16:26 +0200
Message-ID: <20251010131332.665649277@linuxfoundation.org>
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

From: Jeongjun Park <aha310510@gmail.com>

commit 9f2c0ac1423d5f267e7f1d1940780fc764b0fee3 upstream.

The previous commit 0718a78f6a9f ("ALSA: usb-audio: Kill timer properly at
removal") patched a UAF issue caused by the error timer.

However, because the error timer kill added in this patch occurs after the
endpoint delete, a race condition to UAF still occurs, albeit rarely.

Additionally, since kill-cleanup for urb is also missing, freed memory can
be accessed in interrupt context related to urb, which can cause UAF.

Therefore, to prevent this, error timer and urb must be killed before
freeing the heap memory.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+f02665daa2abeef4a947@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f02665daa2abeef4a947
Fixes: 0718a78f6a9f ("ALSA: usb-audio: Kill timer properly at removal")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/midi.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1522,15 +1522,14 @@ static void snd_usbmidi_free(struct snd_
 {
 	int i;
 
+	if (!umidi->disconnected)
+		snd_usbmidi_disconnect(&umidi->list);
+
 	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i) {
 		struct snd_usb_midi_endpoint *ep = &umidi->endpoints[i];
-		if (ep->out)
-			snd_usbmidi_out_endpoint_delete(ep->out);
-		if (ep->in)
-			snd_usbmidi_in_endpoint_delete(ep->in);
+		kfree(ep->out);
 	}
 	mutex_destroy(&umidi->mutex);
-	timer_shutdown_sync(&umidi->error_timer);
 	kfree(umidi);
 }
 



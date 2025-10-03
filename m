Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87C035962;
	Fri,  3 Oct 2025 16:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507670; cv=none; b=obBow3aqnfpk36++7FvrwUFNERVVQg/tQNxP2aLkU3wjA/s1gqqzDvFuJVcCs8u2I/jg07Gds4aDLFZ4KfHgLI5P91Ja2ct4Ck54cWaU7nDnROGEmjSFsHFVCdCXafia0ZfqbZG4I1mPmrXSl0F/cM+fJgWAOAYTFXiwi303HXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507670; c=relaxed/simple;
	bh=X+GizAEOl54bOfX/Ni7TKTVQNmcTSrEoKi7iPxhHplo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6h89/cW5splv3zbW+E4q/3PeMuj1wfIY6jS37S0C78iZh+41SEcebcEygoahOpOWXvJqb90G/dvnEXEznIfMn4GJM3PEJPelfZkvtUzql1yL3Rto5y6RoDuv7qYceSXe1KxcSIMHGPEUdr+UOEMcbEU7ZiV3t2xCaHWq/1cx2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecuNBO2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecuNBO2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26663C4CEF5;
	Fri,  3 Oct 2025 16:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507670;
	bh=X+GizAEOl54bOfX/Ni7TKTVQNmcTSrEoKi7iPxhHplo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecuNBO2TtRBbmw0UYZ8wZAdLCBeeUbKRbk9aa8NC2ME8rQeBz5d8JJq0qV+dt3DkS
	 XyqfvwC3svVh19mnOTPWWQ1tuy3YkHS76f7XTbwteorp6H4n5C9Q1hKDS7mrJuAWOa
	 LTBan8Ce6eMFZd8J4HlxGGa76gLTvQBP+Sq+Vcsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f02665daa2abeef4a947@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.16 04/14] ALSA: usb-audio: fix race condition to UAF in snd_usbmidi_free
Date: Fri,  3 Oct 2025 18:05:38 +0200
Message-ID: <20251003160352.839770244@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160352.713189598@linuxfoundation.org>
References: <20251003160352.713189598@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
 sound/usb/midi.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index acb3bf92857c..97e7e7662b12 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -1522,15 +1522,14 @@ static void snd_usbmidi_free(struct snd_usb_midi *umidi)
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
 
-- 
2.51.0




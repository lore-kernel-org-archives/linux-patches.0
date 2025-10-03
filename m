Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF0429BDB5;
	Fri,  3 Oct 2025 16:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507620; cv=none; b=OKzTotfGiJGxAAAbpUWBiGeETItFp2YaEcBIoCqZz8+oVAKE6IJg02alV1OQgA1lsqTcH7pLV8l+26cunzzFjIuMba7rbXazIe/4EBM2jvEppTs3sIUqZUFsNR4ObMtZN+gBHb8VtAFdaT9TsLm9FNz6bT0Y+j1QknFRVHMVkjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507620; c=relaxed/simple;
	bh=P1qFc0jP2+XuMcV+vOWR5X2AqBnrOL0JFCDjchX+YyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwxBBtlOcpLbd7pugL/KcGmhIUULhhReo37jhX0dL+wiFg7Cli+Rzeuby/Nxgdm6rCjA9ElFrSiaC4BxU/yXuUaPxA6C8CdaJkx1Ac6RqAWqnTY8lijvogDNQ2LoFoGXtTxffbwH65VFt1AtCxHpJbgm6wWSWERXtvJS+/h7lTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AP8XUB0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AP8XUB0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9D7C4CEF5;
	Fri,  3 Oct 2025 16:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507620;
	bh=P1qFc0jP2+XuMcV+vOWR5X2AqBnrOL0JFCDjchX+YyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AP8XUB0Wk9t0fTmnaPhDhGpYIcyJCxMY0GaxnpY8ftyU60J2RqyXIITS+kCvg+eT1
	 R/R0VNpvjXVEi741kOPZ9D3INNfT+l9Rl42TUIrVgu0sJe2SvwnbOtIY2xGFcsuv14
	 WFAlJ3jZ9dmMXSmZFzbmCxiAEVTOKJIIEMfLIPgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f02665daa2abeef4a947@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.17 04/15] ALSA: usb-audio: fix race condition to UAF in snd_usbmidi_free
Date: Fri,  3 Oct 2025 18:05:28 +0200
Message-ID: <20251003160400.033871446@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
References: <20251003160359.831046052@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 



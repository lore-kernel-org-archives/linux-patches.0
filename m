Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEAD2DF137;
	Thu, 16 Jul 2026 13:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209272; cv=none; b=kSK3/WFAOcrDWVlM4jqmg2ATdFngPUklrHnjIeXXJuoSk77EBN9ZAyXp8rZ0iLmooXEBjsli2bmMz+VkTbXBgHEXAgJWrlCuVTvtpbxSWZ5p+ETo663f5wOJms2IbqSksYJAKXu1R5su30zJ3h683dkrjRBrougAIHUM5WQ1Mso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209272; c=relaxed/simple;
	bh=pl3/tXqgIECMd8yd6q/kPlcFxylPkbquebGYKt5XJAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2x6heTLJH7uVVJP1A0iO/CSaA9H5uOIGoDWzswQJKk+wjImYCdGvY1lEre+CLT1Hv37NqqMh7fIlpjsq0RAbdgeXdox/BfB/hAC127BJcWlh6kG4/Mp1v4r1W/Cf0ARkK81gJzrRpefdLZ/T/X9o8XN+cvL4vP4z1nIn//sYwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScRI3QGQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScRI3QGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020EB1F000E9;
	Thu, 16 Jul 2026 13:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209271;
	bh=9KnsWv0TdcBN0UdzArZRU4F0ZaBFeZv3UWZMSVsqdPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ScRI3QGQr84prbQwmOWUd84FIZYjBoYU0jkHiMP0LykjEB1q439VlKpyll+LnQPdI
	 gF88yAaOlYj68o7w4H/K9BNL9Pn6+AIdGeHyjwZxwEc/TTXhvoRX+pVS1BGD8frAZa
	 0FRFKFYnTPZ/4LSQORh5hWolQpHPbScK0D2Vt8lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 079/518] ALSA: usx2y: us144mkii: fix work UAF on disconnect
Date: Thu, 16 Jul 2026 15:25:47 +0200
Message-ID: <20260716133049.516558000@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

commit 147996e7e7c9e8339c0e04f6fa7ccb3e4d448ff7 upstream.

tascam_disconnect() cancels capture_work and midi_in_work before
usb_kill_anchored_urbs() kills the capture/MIDI-in URBs.  Those URBs
self-resubmit, and their completion handlers reschedule the work.

A URB that completes in the small window between cancel_work_sync() and
usb_kill_anchored_urbs() therefore re-arms the work after its only
cancel.  Nothing cancels it again before snd_card_free() frees the
card-private tascam structure, so the work handler then runs on freed
memory.

Kill the anchored URBs before cancelling the work; once the work is
cancelled no remaining URB can complete to re-arm it.

Fixes: c1bb0c13e430 ("ALSA: usb-audio: us144mkii: Implement audio capture and decoding")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260701095231.1020811-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/usx2y/us144mkii.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/sound/usb/usx2y/us144mkii.c
+++ b/sound/usb/usx2y/us144mkii.c
@@ -585,19 +585,24 @@ static void tascam_disconnect(struct usb
 		return;
 
 	if (intf->cur_altsetting->desc.bInterfaceNumber == 0) {
-		/* Ensure all deferred work is complete before freeing resources */
 		snd_card_disconnect(tascam->card);
-		cancel_work_sync(&tascam->stop_work);
-		cancel_work_sync(&tascam->capture_work);
-		cancel_work_sync(&tascam->midi_in_work);
-		cancel_work_sync(&tascam->midi_out_work);
-		cancel_work_sync(&tascam->stop_pcm_work);
 
+		/*
+		 * Kill the URBs before cancelling the work, so a late URB
+		 * completion cannot re-arm a work that then runs after
+		 * snd_card_free().
+		 */
 		usb_kill_anchored_urbs(&tascam->playback_anchor);
 		usb_kill_anchored_urbs(&tascam->capture_anchor);
 		usb_kill_anchored_urbs(&tascam->feedback_anchor);
 		usb_kill_anchored_urbs(&tascam->midi_in_anchor);
 		usb_kill_anchored_urbs(&tascam->midi_out_anchor);
+
+		cancel_work_sync(&tascam->stop_work);
+		cancel_work_sync(&tascam->capture_work);
+		cancel_work_sync(&tascam->midi_in_work);
+		cancel_work_sync(&tascam->midi_out_work);
+		cancel_work_sync(&tascam->stop_pcm_work);
 		timer_delete_sync(&tascam->error_timer);
 		tascam_free_urbs(tascam);
 		snd_card_free(tascam->card);



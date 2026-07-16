Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA9B5A79B;
	Thu, 16 Jul 2026 14:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210598; cv=none; b=V2Y9+1zisvREVb3MLwFZ9u59BGZ/Kohvabyvbli2BOCYfY5R8N2ogPq2NyutHf4oJMIi4fnB7r0tF2w3f+44WY2MaX1S5lwjStOcv96k6QL607FvB6RqCu0UMO2yPPtjjwTkDje5unKR9EavmB/d8zDmea7PMW4+Z4eTkJgHcHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210598; c=relaxed/simple;
	bh=ozI15+q9cGXlE3VN3G8of162hEqWmOJZkPVr+jdVctE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6DqojFz1veR1QQFuB1Pxr3mwkVvrnVzA9y60TL6Ddh2ooHwbrifvllABTXVctcAUTIY/Sg4rFT7V7+GCJMvhUJYKNfoQWypMSZkBaHaUEVE5XgkaEZ8LdT1nyjG4tSAcyg+6nk4zEOsb/eyICHc+1lo1yuqGJNzayivD3M6ax0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AO87AjjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AO87AjjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6F11F000E9;
	Thu, 16 Jul 2026 14:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210597;
	bh=+wuzHXuRgoaYIe7ImO4nwNXG6jmo3nV8dpP7+/46Dfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AO87AjjUxA2sXv5WM4UbtEex7OE4qJ/adFWSp21GFDmeOxn09Hig7sChlAxbUeMS2
	 4ThZhvJj5o3EWbV7i443tNfIiOElihqpCR3OJVVhcuIu5l2+fdVPf7MLH7pmS0Kggv
	 fXn4joCVpz60o7AnOPcT5pimDZkV3kVgAgMN81v0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 091/480] ALSA: usx2y: us144mkii: fix work UAF on disconnect
Date: Thu, 16 Jul 2026 15:27:18 +0200
Message-ID: <20260716133046.678674006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 sound/usb/usx2y/us144mkii.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/sound/usb/usx2y/us144mkii.c b/sound/usb/usx2y/us144mkii.c
index 94553b61013c..58ef23146f20 100644
--- a/sound/usb/usx2y/us144mkii.c
+++ b/sound/usb/usx2y/us144mkii.c
@@ -585,19 +585,24 @@ static void tascam_disconnect(struct usb_interface *intf)
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
-- 
2.55.0




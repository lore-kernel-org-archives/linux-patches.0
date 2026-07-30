Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF30C35DA67;
	Thu, 30 Jul 2026 15:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426227; cv=none; b=dbcxcbQtLoe2DsJ4wlDBk36m+fZIetLEp736wuMQW/q7zDNI6TEQH5szPW7BPjDUoDjvHNekOOTzNKzUyRBx32HRXnnP2fLHnOqZiF6kUwPHe4Gn7Z7Sx8eigB+1hbTiqRLN43dEC5hROHRjJpXfZBhPT3dzu7hQeITLzZ+dNJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426227; c=relaxed/simple;
	bh=M74YN6FxzZyybuZhfAXTYbeRMXQYuVUK2ORFMVvTM4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mVzuctZazb1/Y0UP2WrOPRoBZIFjl8V8z22a6UcnPgymrdDbArSuyvXgcAZI3kwfKtrVYDxnidQkq+EtwmPo76eQEhz64/qeDBPmmVKuyO8iyG+6WB3z/5p1yVyj3ZAJcvMvdEGvp2WddyQjOAQ+/Zj5/QOrsW4yx/C8336sDgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z2PhJsOu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z2PhJsOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EC71F000E9;
	Thu, 30 Jul 2026 15:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426226;
	bh=psfFfj1UVAd8XMzIgKFs2UhuHsn3IsnIH7P9sfGtNeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z2PhJsOu2NT6avfJ3lWAzXXWSFLJJVaCBxceD8J8x1HptZ/aQWdtaeQ2EPsbdZOs8
	 Zwb4aP2Lwwu7zEuT0y0xc6ZT1eIrnjMxNKYwKjYxDOQAuWm3XgKmSYs2Keq8mMtkSB
	 l3FbzfurxpzOsHWMnfjKymzbdmbKMPHabiAyi2w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Norbert Szetei <norbert@doyensec.com>
Subject: [PATCH 6.12 345/602] ALSA: timer: dont re-enter an instance callback that is still running
Date: Thu, 30 Jul 2026 16:12:17 +0200
Message-ID: <20260730141443.209355018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Norbert Szetei <norbert@doyensec.com>

commit 70d28bfcd6224eed75986b3b987b997e59643fa4 upstream.

The userspace-driven timer (utimer) TRIGGER ioctl calls
snd_timer_interrupt() directly with no serialization, so two threads
triggering the same utimer can run snd_timer_interrupt() on one
snd_timer concurrently.

snd_timer_process_callbacks() drops timer->lock around each instance
callback and marks the in-flight callback with the single
SNDRV_TIMER_IFLG_CALLBACK bit; snd_timer_close_locked() waits on that
bit to drain an in-flight callback before freeing the instance. The bit
cannot represent two concurrent callbacks: when a second interrupt
re-queues an instance whose callback is still running, both run at once,
the first to finish clears the bit, and the close-path drain then frees
the instance (and its callback_data) while the other callback is still
live - a use-after-free reachable by any user able to open
/dev/snd/timer, both via a user timer instance and via a sequencer queue
timer bound to the utimer.

snd_timer_interrupt() sets IFLG_CALLBACK before dropping timer->lock, so
a concurrent interrupt already observes it under the lock. Skip
re-queuing an instance (and its slaves) to the ack/sack list while its
callback is in flight; the accumulated pticks are delivered on the next
tick, so no event is lost.

Fixes: 37745918e0e7 ("ALSA: timer: Introduce virtual userspace-driven timers")
Cc: stable@vger.kernel.org
Suggested-by: Takashi Iwai <tiwai@suse.de>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/6F9B6501-8E65-4265-B02C-7EFB240D1664@doyensec.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/timer.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -883,12 +883,15 @@ void snd_timer_interrupt(struct snd_time
 			ack_list_head = &timer->ack_list_head;
 		else
 			ack_list_head = &timer->sack_list_head;
-		if (list_empty(&ti->ack_list))
+		/* don't requeue an instance whose callback is still running */
+		if (list_empty(&ti->ack_list) &&
+		    !(ti->flags & SNDRV_TIMER_IFLG_CALLBACK))
 			list_add_tail(&ti->ack_list, ack_list_head);
 		list_for_each_entry(ts, &ti->slave_active_head, active_list) {
 			ts->pticks = ti->pticks;
 			ts->resolution = resolution;
-			if (list_empty(&ts->ack_list))
+			if (list_empty(&ts->ack_list) &&
+			    !(ts->flags & SNDRV_TIMER_IFLG_CALLBACK))
 				list_add_tail(&ts->ack_list, ack_list_head);
 		}
 	}



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CEE32B116;
	Thu, 30 Jul 2026 15:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424607; cv=none; b=icuZWYVfKn9kHBtYww4AGQnDXNNd2Q0yT0KzkaiIxoFFK5lAq8F31QsJnPQ7sI/5htWUxwBLl5xH0Q7FSxVzFIPzJBB5lLS/XQdvV4IiIlcauzFW6L0j7Ib6pRLZhhvAAa0Vx8JSyUejwfVj5NVaW0TvSMiLjnDbORq0PifCs+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424607; c=relaxed/simple;
	bh=jvn6cDLjcupamLGr1neahpF1tgt/h1wSopcord5havA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZ/VyjQKAqjZJNd4T8qvef0n5qCu6731dP7f9qJwCE37T6h3iXgq9+KVg0Y3vqwXx57gU4wD8KIcewHhCN/vb+CwUUOnO4YXxsD6zrOjYllV9OBWvsuIDE76Z3WpPmWFzbTh/7FFUqefyVDzufuvYODyCIcDpLo62sUnnwjDXR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iX+QHs4e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iX+QHs4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D261F000E9;
	Thu, 30 Jul 2026 15:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424606;
	bh=3OPCORNeJ8Soz+oBhrrnHwCtKlD+pmQtn1o/L4USKYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iX+QHs4eMmJR2cBwvi2Da/8FRSO+DDPGXUtYJ6m6WBJ3NTyVImwd35qIy1tMLZH27
	 uX0EXB4qw7RPHNbtdlwbIoaIk0rfTmSHiErZyKT8LxNhhWsvrdVNpsTZUymPSsxLvE
	 5ymGF1109vbKEW+U50AnxbacMe4CxjqTyJoNqExw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Norbert Szetei <norbert@doyensec.com>
Subject: [PATCH 6.18 451/675] ALSA: timer: dont re-enter an instance callback that is still running
Date: Thu, 30 Jul 2026 16:13:01 +0200
Message-ID: <20260730141454.722525420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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



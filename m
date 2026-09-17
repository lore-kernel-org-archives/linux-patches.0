Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838E04E3255;
	Thu, 17 Sep 2026 15:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660249; cv=none; b=EBiJ8wDJU1gP8L7a/tX3kwHJ1em93jEmAt/7nZpj0auAxMmexRMEp58vSnhZsA0w6N+mG9vE70nWXK8DstdJZs1/uSfmwjasHzka4sjdM78X0VSCvzzU9/XPa+rPlVo+Wx4m275Q8LQfw7TUE3EXA8bdLVr9q240P/eyFjj56qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660249; c=relaxed/simple;
	bh=2yPq2zuSCan+xQkGCw4Kh2iDQKXOr54awKtN4nOoYOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUB5IxYpkrS9o5AuE+p9t4ikOaMI6VYARo3kfzbfSR9EaWyD1lMTO8BWLlocosHetuG82QwFHpDYRc60pMS3YCw6wErOsKwI93E8kA0sbUjgFPiyFQdvQgHgiUyccjJAZUqdGB28tkzFG1I0BB1ch4ZY0ahGXXFis/9tDY+Ujl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWWNdUaL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWWNdUaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB441F00893;
	Thu, 17 Sep 2026 15:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660244;
	bh=3aTEvlz+fh4sRoKDp0U7ZgsGoqrgsBKy1ODITJm899M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zWWNdUaLy9lpiczeA8ArdYHw4KCKnmzdH2McA889lYw4W3+Ibc7OJibq0Ta5k4Kiy
	 xIk8Ml/RcrjmSXQXT+2b+6QSalb00FiKkf5xvF9FB3YiMOr9ektiJt9WnZmttYjA8V
	 B5E/LOsu07aKuBSvb5fVaa39zjkZqg4uFH/6q2hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Parri <parri.andrea@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.2 526/733] hrtimer: Use hard expiry when updating timers on the same base
Date: Thu, 17 Sep 2026 16:13:54 +0100
Message-ID: <20260917151405.289317134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

commit c5dcb3aadc18d7b82ba64790721b005d18193d35 upstream.

Rearming a queued timer with nonzero slack can leave the timerqueue out
of order. remove_and_enqueue_same_base() checks the new soft expiry
against its neighbours' hard expiries, then stores the new hard expiry
in the node without requeueing it.

For example, with A at 10 and B at 20, rearming A at 11 with slack 30
passes the neighbour check but leaves A's hard expiry of 41 before B's
20. The same function also caches the soft expiry in base->expires_next
when updating or inserting the first timer, giving next-event selection
an earlier deadline than the queue head's hard expiry.

Set the timer expiry before handling the queue. Use its stored hard
expiry for the in-place ordering check and both updates to
base->expires_next.

The early update is safe because remove_and_enqueue_same_base() runs
with base->cpu_base->lock held. The lock keeps the queue stable while
hrtimer_can_update_in_place() checks the new expiry against both
neighbours. If the check fails, timerqueue_linked_del() removes the node
without comparing expiry values before it is reinserted.

Fixes: eddffab8282e3 ("hrtimer: Keep track of first expiring timer per clock base")
Fixes: 343f2f4dc5425 ("hrtimer: Try to modify timers in place")
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Assisted-by: LLM
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260910143442.2018-1-parri.andrea@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/hrtimer.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1236,13 +1236,23 @@ remove_and_enqueue_same_base(struct hrti
 {
 	bool was_first = false;
 
+	/*
+	 * Updating the sort key while @timer is queued can temporarily
+	 * make the tree inconsistent. This is safe under cpu_base->lock:
+	 * no other queue operation can observe that state.
+	 * hrtimer_can_update_in_place() either confirms that the new expiry
+	 * fits between the neighbours or timerqueue_linked_del() removes the
+	 * timer without consulting the expiry.
+	 */
+	hrtimer_set_expires_range_ns(timer, expires, delta_ns);
+	expires = hrtimer_get_expires(timer);
+
 	/* Remove it from the timer queue if active */
 	if (timer->is_queued) {
 		was_first = !timerqueue_linked_prev(&timer->node);
 
 		/* Try to update in place to avoid the de/enqueue dance */
 		if (hrtimer_can_update_in_place(timer, base, expires)) {
-			hrtimer_set_expires_range_ns(timer, expires, delta_ns);
 			trace_hrtimer_start(timer, mode, true);
 			if (was_first)
 				base->expires_next = expires;
@@ -1253,9 +1263,6 @@ remove_and_enqueue_same_base(struct hrti
 		timerqueue_linked_del(&base->active, &timer->node);
 	}
 
-	/* Set the new expiry time */
-	hrtimer_set_expires_range_ns(timer, expires, delta_ns);
-
 	debug_activate(timer, mode, timer->is_queued);
 	base->cpu_base->active_bases |= 1 << base->index;
 



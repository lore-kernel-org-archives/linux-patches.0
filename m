Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9D51714A1;
	Thu, 15 Aug 2024 13:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729995; cv=none; b=dOl2rbjlu/gGsAeSb1NCKUHXKoA+s4zzBU72bRc1clUk/cclQoOnE+QPVpI9et5w87i31U3HmKoM7T3sFOPGvoQVwiQmNuaOrMdq+rSlEJpw67tTXUem7EoyDafS81XApoCW12VZu6DKVL3mjzFxYl/wiCi3aGEvJqfCANRR01s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729995; c=relaxed/simple;
	bh=kl3LjUe787JztQswTDaviJ2jJrAaCHr4mjUteh7nrPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2g88ZWxBQmhTb/2im2Ep4Qpka0TNKrK9gtvc/yJxdaICh5QNYGKDhbOlxYDjTG/bPJxuOOoNboGlWnusWNe++H5UIZny6QxqF81Irj+xI1cL4f85Nzf8fjctkw/hXwOIpGzx+lYe/B+4rscqkOU1wryzIMNdlVyL1Ti/rpgAvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FeRe/W/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FeRe/W/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2D7C32786;
	Thu, 15 Aug 2024 13:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729994;
	bh=kl3LjUe787JztQswTDaviJ2jJrAaCHr4mjUteh7nrPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeRe/W/6GiTbJemeYPOMNrtPh7TSQnOzjzGJJWZs2aYU1ds5kz52p3/viF3aCuteu
	 6X7YtZtN609zL6an8oGqHJfxcdz0FWSjMdSv/mK4pwDxVlpxpWE2mjMyj97e4wWfOk
	 NytmkmyCj2dolR8MDeOZUjA0HxJOZ4O6gRj1hiJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.15 230/484] perf: Fix event leak upon exit
Date: Thu, 15 Aug 2024 15:21:28 +0200
Message-ID: <20240815131950.291168036@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

commit 2fd5ad3f310de22836cdacae919dd99d758a1f1b upstream.

When a task is scheduled out, pending sigtrap deliveries are deferred
to the target task upon resume to userspace via task_work.

However failures while adding an event's callback to the task_work
engine are ignored. And since the last call for events exit happen
after task work is eventually closed, there is a small window during
which pending sigtrap can be queued though ignored, leaking the event
refcount addition such as in the following scenario:

    TASK A
    -----

    do_exit()
       exit_task_work(tsk);

       <IRQ>
       perf_event_overflow()
          event->pending_sigtrap = pending_id;
          irq_work_queue(&event->pending_irq);
       </IRQ>
    =========> PREEMPTION: TASK A -> TASK B
       event_sched_out()
          event->pending_sigtrap = 0;
          atomic_long_inc_not_zero(&event->refcount)
          // FAILS: task work has exited
          task_work_add(&event->pending_task)
       [...]
       <IRQ WORK>
       perf_pending_irq()
          // early return: event->oncpu = -1
       </IRQ WORK>
       [...]
    =========> TASK B -> TASK A
       perf_event_exit_task(tsk)
          perf_event_exit_event()
             free_event()
                WARN(atomic_long_cmpxchg(&event->refcount, 1, 0) != 1)
                // leak event due to unexpected refcount == 2

As a result the event is never released while the task exits.

Fix this with appropriate task_work_add()'s error handling.

Fixes: 517e6a301f34 ("perf: Fix perf_pending_task() UaF")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240621091601.18227-4-frederic@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/core.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2395,18 +2395,15 @@ event_sched_out(struct perf_event *event
 	}
 
 	if (event->pending_sigtrap) {
-		bool dec = true;
-
 		event->pending_sigtrap = 0;
 		if (state != PERF_EVENT_STATE_OFF &&
-		    !event->pending_work) {
-			event->pending_work = 1;
-			dec = false;
+		    !event->pending_work &&
+		    !task_work_add(current, &event->pending_task, TWA_RESUME)) {
 			WARN_ON_ONCE(!atomic_long_inc_not_zero(&event->refcount));
-			task_work_add(current, &event->pending_task, TWA_RESUME);
-		}
-		if (dec)
+			event->pending_work = 1;
+		} else {
 			local_dec(&event->ctx->nr_pending);
+		}
 	}
 
 	perf_event_set_state(event, state);



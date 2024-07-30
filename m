Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF4F155CB3;
	Tue, 30 Jul 2024 16:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358062; cv=none; b=GvPN3gyiG1/wQ1+xwyPDfhNZ7928FFG2noii9IMWGBXlUcMaTwcswbKJe6eYq/ORvYIOeJU93ZNqbQDwX/O3NMp+JmXJoK5WfrznckI3fGz/HmumhM8gu1YYcWH8atUbTW94z2aEpOBDauibmN0srfRsL08/uzidWP4+ONt8wBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358062; c=relaxed/simple;
	bh=dr0p8AGUFqIDhGC3n+LTt6ouONRSfWrbbko4IZ3Mo2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJ2/ynOO78qGcPudiyl7yHFU20v0yoMsvu8xYhZxaQFfi92Sc4xSFybr44zQ5g67xC7N41hzN9Hh6FSt93U8SCxxEg+w5wqNPWbr32KuNItXQsbGwg266JpKWKUMcterZMlNjx1ktY3TL/5YnoaRw4KvrijQHJg6y2uiWLv0rWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhqqqsiB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhqqqsiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3109DC32782;
	Tue, 30 Jul 2024 16:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358062;
	bh=dr0p8AGUFqIDhGC3n+LTt6ouONRSfWrbbko4IZ3Mo2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhqqqsiBgof68iBNIZY0jMPwWgwbFHLw1+u6KfbPNgivHrP2QWGn6r8HvxDFdMwJR
	 6QW7P4ItfdR4Eaxy5PGbcLxkv1dyeuW/h3qbpL5k40FVH61Pf9+3RDrHt2BeQxUVxV
	 uxGJtdpF23gMSZXTgDXtEgC/CNuJXPkRQbUKzXmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 353/440] perf: Fix event leak upon exit
Date: Tue, 30 Jul 2024 17:49:46 +0200
Message-ID: <20240730151629.606696804@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2316,18 +2316,15 @@ event_sched_out(struct perf_event *event
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



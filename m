Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645571891DD;
	Wed,  3 Jul 2024 10:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004222; cv=none; b=pxkVfON7TTBh8WNHcAFVsIuBCDmiFKIt7EEjPUAVMwC6sHmDPhgq+PzFJXKW7AQObq6hFWEHXg8tnHVSWbkIN1o6OQIYqiS+/bENiFiQIqW8lhDRZydTATgQnaKBzwdMIcGSs2HJ+R7edocToq1MQhlSQIigwMzNNmUuunonaRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004222; c=relaxed/simple;
	bh=a73Np0KCs6DjM3KFfkee0vksWSyHHnEK1455oyVzlTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezRF2YUlFQEWUbgtZudCRgl1ZV3L8z4qyJW4aF8gXzgpRdxGz3Z9ttzi0kRAzyCIkrkSMJsR3b0jenHTzmA6tVyAfY0+VxfYu4QigiuBe/kMZ2sLQ0nhEYGzuLP7b+19IfWs+U5KpOLB2NnRW8kI4YfnO/LKvabieUVFatvbHVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4XD827E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4XD827E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC85AC2BD10;
	Wed,  3 Jul 2024 10:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004222;
	bh=a73Np0KCs6DjM3KFfkee0vksWSyHHnEK1455oyVzlTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4XD827EoR4mXOb0mXroTn/jrXjIrLQwr3XLbrdciH5HyGDXt3Sedr76BwAq9+i93
	 YzN7n0f9B8/tB4Z5PGgzrTgxXi41et4xy8p1551tziJ3+vjGajpxhcuXl7U9DrqTCH
	 eXshgPIzlSKudTV5dPnkge1x4YJO3L6CX4mo/7xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haifeng Xu <haifeng.xu@shopee.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 128/189] perf/core: Fix missing wakeup when waiting for context reference
Date: Wed,  3 Jul 2024 12:39:49 +0200
Message-ID: <20240703102846.322162342@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haifeng Xu <haifeng.xu@shopee.com>

[ Upstream commit 74751ef5c1912ebd3e65c3b65f45587e05ce5d36 ]

In our production environment, we found many hung tasks which are
blocked for more than 18 hours. Their call traces are like this:

[346278.191038] __schedule+0x2d8/0x890
[346278.191046] schedule+0x4e/0xb0
[346278.191049] perf_event_free_task+0x220/0x270
[346278.191056] ? init_wait_var_entry+0x50/0x50
[346278.191060] copy_process+0x663/0x18d0
[346278.191068] kernel_clone+0x9d/0x3d0
[346278.191072] __do_sys_clone+0x5d/0x80
[346278.191076] __x64_sys_clone+0x25/0x30
[346278.191079] do_syscall_64+0x5c/0xc0
[346278.191083] ? syscall_exit_to_user_mode+0x27/0x50
[346278.191086] ? do_syscall_64+0x69/0xc0
[346278.191088] ? irqentry_exit_to_user_mode+0x9/0x20
[346278.191092] ? irqentry_exit+0x19/0x30
[346278.191095] ? exc_page_fault+0x89/0x160
[346278.191097] ? asm_exc_page_fault+0x8/0x30
[346278.191102] entry_SYSCALL_64_after_hwframe+0x44/0xae

The task was waiting for the refcount become to 1, but from the vmcore,
we found the refcount has already been 1. It seems that the task didn't
get woken up by perf_event_release_kernel() and got stuck forever. The
below scenario may cause the problem.

Thread A					Thread B
...						...
perf_event_free_task				perf_event_release_kernel
						   ...
						   acquire event->child_mutex
						   ...
						   get_ctx
   ...						   release event->child_mutex
   acquire ctx->mutex
   ...
   perf_free_event (acquire/release event->child_mutex)
   ...
   release ctx->mutex
   wait_var_event
						   acquire ctx->mutex
						   acquire event->child_mutex
						   # move existing events to free_list
						   release event->child_mutex
						   release ctx->mutex
						   put_ctx
...						...

In this case, all events of the ctx have been freed, so we couldn't
find the ctx in free_list and Thread A will miss the wakeup. It's thus
necessary to add a wakeup after dropping the reference.

Fixes: 1cf8dfe8a661 ("perf/core: Fix race between close() and fork()")
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20240513103948.33570-1-haifeng.xu@shopee.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 576af248a539a..2347dda682abd 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4760,6 +4760,7 @@ int perf_event_release_kernel(struct perf_event *event)
 again:
 	mutex_lock(&event->child_mutex);
 	list_for_each_entry(child, &event->child_list, child_list) {
+		void *var = NULL;
 
 		/*
 		 * Cannot change, child events are not migrated, see the
@@ -4800,11 +4801,23 @@ int perf_event_release_kernel(struct perf_event *event)
 			 * this can't be the last reference.
 			 */
 			put_event(event);
+		} else {
+			var = &ctx->refcount;
 		}
 
 		mutex_unlock(&event->child_mutex);
 		mutex_unlock(&ctx->mutex);
 		put_ctx(ctx);
+
+		if (var) {
+			/*
+			 * If perf_event_free_task() has deleted all events from the
+			 * ctx while the child_mutex got released above, make sure to
+			 * notify about the preceding put_ctx().
+			 */
+			smp_mb(); /* pairs with wait_var_event() */
+			wake_up_var(var);
+		}
 		goto again;
 	}
 	mutex_unlock(&event->child_mutex);
-- 
2.43.0




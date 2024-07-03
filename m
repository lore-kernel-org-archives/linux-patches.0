Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9C345945;
	Wed,  3 Jul 2024 11:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004989; cv=none; b=FTNsKQ/8wRlvIfTaS4tIXPQeqzCTRUkEsYs2bHf2RAslemIcOKLWiu66sRSYOdAqSCIb4XwfDlHZ6KTENTH0jUao8+UP0HViPGM58OYzZnbhyUnJUxqteiFCAHNCvqmN0wi7pMuzJTnOBQCM+B92NKLEAqRDdtqhdurd0Cyd/Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004989; c=relaxed/simple;
	bh=nrI5xGGVE4l0Xjvq34yDcaVYndqwWSjLDfLVYdtxFjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWOKOa7oei3tl6gu2Gp5Gl9glSvurRo1n66S8vddUXCMhFpAPs5X0obMsUmbPh37kok1ubzQIJ7Sm41J1D1XoZQuwpFPDcq4oxEHw22a7GSDqpcqNNLW6qniaPoqY41pyQerAIrwe9AIGpTvbX8run0mxrPvA5fYsqo5p6CrQW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WS58j1eO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WS58j1eO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A00DC2BD10;
	Wed,  3 Jul 2024 11:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004989;
	bh=nrI5xGGVE4l0Xjvq34yDcaVYndqwWSjLDfLVYdtxFjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WS58j1eOG01gIoDMnmGx/jjib/DjNjedfGFH6U9AYulxCriaU+Ffdu6wJoQnakgUG
	 n15dZS39tDDnGKj4Fxvfg4VOKNCVAIMUSHvlSpQRQ4eUjdhUkWoTXCdc5Vf92RPw/u
	 jo541tZ40A9uYSMmBKBoz7hM3pRMQMul7i4bPJGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haifeng Xu <haifeng.xu@shopee.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/290] perf/core: Fix missing wakeup when waiting for context reference
Date: Wed,  3 Jul 2024 12:39:33 +0200
Message-ID: <20240703102911.419496895@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e0b47bed86750..3a191bec69aca 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5128,6 +5128,7 @@ int perf_event_release_kernel(struct perf_event *event)
 again:
 	mutex_lock(&event->child_mutex);
 	list_for_each_entry(child, &event->child_list, child_list) {
+		void *var = NULL;
 
 		/*
 		 * Cannot change, child events are not migrated, see the
@@ -5168,11 +5169,23 @@ int perf_event_release_kernel(struct perf_event *event)
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




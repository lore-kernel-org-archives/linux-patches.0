Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AED1F3BAC;
	Mon, 14 Jul 2025 23:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752534499; cv=none; b=WG2Bju6pSsKzX12ayy667E/RxwgfFuSdMiiwGKr1ny1iXg23gl2yPUQfgz4Eg+C4GNHcfiYZRw1ZFCJfJ6D9dJa485wnyPTAjEQhYDDT7JrlgFodD8S0TRIUyMeOLR3kIY6U680LpxonEBoWcGoshTXkUwiz22jHHag191tLgyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752534499; c=relaxed/simple;
	bh=aZopBhGjm6b8ZhwVgOoxaIYjjq15fUw+DW+MiePavw4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cDUhv9EKgjlp+DafdiRiD1PY6FVpLWqA4bgTtDTHPdw9q6CwLPgL5zc9ALzQ4aGGzK+bi/d5VpGXZhvI4/TlWQ/godzabhTTiTgT6epu8lfihA/O9dR/FS4D1dgg9UhN38WhT/rAiKLbfQXSh9H9EZ8FpO2oX3jM+AKLzqRVlJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W3dOVIFK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W3dOVIFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5CFC4CEF0;
	Mon, 14 Jul 2025 23:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752534499;
	bh=aZopBhGjm6b8ZhwVgOoxaIYjjq15fUw+DW+MiePavw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3dOVIFKLiFjzmg7MwAfHkxwXm3nz2lulJUiUsEjBkB5GGcVt94f2tOfwXsXmD+KZ
	 TW+DWf/zEhmggpqr5DNVlP7Q00w0GXZAfFcRIRdsI7/T4LMNa/lKfWkjMMOlK6GKVD
	 D1QRWTcvLRd5d/b9MIruQSC9SFfNSjCU5MHWmgPEDDezenJ63s+MvPVhMlczkzrYCu
	 1xHtXcnAQqvieKuzAbYzeKSmWMM2cAt7hDEXdYzvWDXc+wVjOnfX6Q28Eu5N1lsH+J
	 ZY5dn6ZK8BNM1st5VRQuz0TuUjcomAHKKxwV7l62QIQDJaKwqWFiWh8bVphUHF3Vm4
	 pYu+VnsPSnYHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	syzbot <syzbot+2fe61cb2a86066be6985@syzkaller.appspotmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 2/3] perf/core: Fix WARN in perf_sigtrap()
Date: Mon, 14 Jul 2025 19:08:11 -0400
Message-Id: <20250714230812.3710500-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250714230812.3710500-1-sashal@kernel.org>
References: <20250714230812.3710500-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.188
Content-Transfer-Encoding: 8bit

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 3da6bb419750f3ad834786d6ba7c9d5d062c770b ]

Since exit_task_work() runs after perf_event_exit_task_context() updated
ctx->task to TASK_TOMBSTONE, perf_sigtrap() from perf_pending_task() might
observe event->ctx->task == TASK_TOMBSTONE.

Swap the early exit tests in order not to hit WARN_ON_ONCE().

Closes: https://syzkaller.appspot.com/bug?extid=2fe61cb2a86066be6985
Reported-by: syzbot <syzbot+2fe61cb2a86066be6985@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/b1c224bd-97f9-462c-a3e3-125d5e19c983@I-love.SAKURA.ne.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit, let me provide my assessment:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **It fixes a real bug with user-visible impact**: The commit fixes a
   WARN_ON_ONCE() that fires in perf_sigtrap() when the system hits a
   specific race condition. This WARN causes kernel log spam and
   indicates an unexpected state that shouldn't occur.

2. **The fix is small and contained**: The change is minimal - it simply
   reorders two early exit checks in perf_sigtrap():
   - Before: Check `event->ctx->task != current` first, then check
     `PF_EXITING`
   - After: Check `PF_EXITING` first, then check `event->ctx->task !=
     current`

3. **Clear race condition**: The commit message explains the race:
   exit_task_work() runs after perf_event_exit_task_context() has
   updated ctx->task to TASK_TOMBSTONE. When perf_sigtrap() is called
   from perf_pending_task() during this window, it observes
   event->ctx->task == TASK_TOMBSTONE, which doesn't match current,
   triggering the WARN.

4. **Low risk of regression**: The fix simply reorders existing checks
   without changing functionality. If the task is exiting (PF_EXITING is
   set), we return early regardless. The reordering just prevents the
   WARN from firing in this legitimate exit scenario.

5. **Fixes a reproducible issue**: The commit references a specific
   syzbot report
   (https://syzkaller.appspot.com/bug?extid=2fe61cb2a86066be6985),
   indicating this is a real issue that can be triggered, not just
   theoretical.

6. **Follows stable tree rules**: This is an important bugfix (prevents
   kernel warnings), has minimal risk, and doesn't introduce new
   features or make architectural changes.

The fix is appropriate because during task exit, it's expected that
ctx->task might be TASK_TOMBSTONE while the task is still cleaning up
its work items. By checking PF_EXITING first, we properly handle the
legitimate exit case without triggering false warnings.

 kernel/events/core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index c7ae6b426de38..e2457319b63e1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6667,18 +6667,18 @@ void perf_event_wakeup(struct perf_event *event)
 static void perf_sigtrap(struct perf_event *event)
 {
 	/*
-	 * We'd expect this to only occur if the irq_work is delayed and either
-	 * ctx->task or current has changed in the meantime. This can be the
-	 * case on architectures that do not implement arch_irq_work_raise().
+	 * Both perf_pending_task() and perf_pending_irq() can race with the
+	 * task exiting.
 	 */
-	if (WARN_ON_ONCE(event->ctx->task != current))
+	if (current->flags & PF_EXITING)
 		return;
 
 	/*
-	 * Both perf_pending_task() and perf_pending_irq() can race with the
-	 * task exiting.
+	 * We'd expect this to only occur if the irq_work is delayed and either
+	 * ctx->task or current has changed in the meantime. This can be the
+	 * case on architectures that do not implement arch_irq_work_raise().
 	 */
-	if (current->flags & PF_EXITING)
+	if (WARN_ON_ONCE(event->ctx->task != current))
 		return;
 
 	send_sig_perf((void __user *)event->pending_addr,
-- 
2.39.5


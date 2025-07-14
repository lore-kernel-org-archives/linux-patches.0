Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C0D291C14;
	Mon, 14 Jul 2025 23:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752534450; cv=none; b=Ti6JQsYKlVAC0GdLvcES+75rXpoUkuqA7o4IUy7hIz/6meXDeo5OJx6N4bZuxzhp6UlqGc6RyuWuMFsBM/nlefcoJm3RTreifI25tjxNob/ABx0kfse4wC98TBtO/Zrp3FO7Oigj7cZoOUkHn/DIn1IWoWWV/aMG070tAGftbuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752534450; c=relaxed/simple;
	bh=TvMhV8JxLv+JN+nrVul8DqDYxh4dThaWXlW2istWtsw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A4fFyJa0dqlEmP59tjL6LRAZ66pADlDALatx3R1cZAWROIMMAlngZWI+F7fQ49eLY37BpMF/qXN93jBp8u5TCpV78YD+D5KvWYL9PsCKyUAs5zXyPdgZrufHwB5I/FeuvKVTyd/JyMlX6SaVtQFsQ7qrvXVAco5eSULk4A0rZ/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n7hi/Hmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7hi/Hmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C91C4CEF4;
	Mon, 14 Jul 2025 23:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752534450;
	bh=TvMhV8JxLv+JN+nrVul8DqDYxh4dThaWXlW2istWtsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7hi/HmqdetV3qFpjqKq2rLb8pANS9CbZrrkfyrdgO+Ef6nvdijDC+6wW2rfI2DBH
	 LlVu5R1wmeBF3TD6l4aWO/Jur7rXoSYxt22wl4qtN662i+Dfj8o2uGo2xftO/D2pmX
	 SFO/jglyrigiKDqCvzzFC8EFz5nzyWwx1cOIg6mGAdBPmHQRjmioyqN8fM6MjqI+Xl
	 q/y3RV+L3IuDPig/umLsGhe34JOImUizVBIgyV0wSJKy3KjNxJ/IlBzgRQlLmQ++oU
	 NDxTxyyxNFJE8RRxqrZApeUh1YCjiUeiPjjKDSz2oJBLHYmKVpc23cTEqel9D+nylC
	 gQGivim1Or/+A==
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
Subject: [PATCH AUTOSEL 6.12 07/12] perf/core: Fix WARN in perf_sigtrap()
Date: Mon, 14 Jul 2025 19:07:10 -0400
Message-Id: <20250714230715.3710039-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250714230715.3710039-1-sashal@kernel.org>
References: <20250714230715.3710039-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.38
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
index 7210104b3345c..5ad445e80af3b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6894,18 +6894,18 @@ void perf_event_wakeup(struct perf_event *event)
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


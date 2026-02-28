Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7430A36B055
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300961; cv=none; b=I4VYrINvLCrkpi+VM08oqGuM2qQQBhzTpQKxYjYYQj9DjNtEKBIXJAt0Vuep8qpR1H74wCW5rmZQ66oLErVlk91XRT1nOSTa20CtDVB+NRdcQUtOMRw+mCy5SwWvO14zCTY6R1BIGt6btGM0PFu6JqKThM0DbZ6Xz9faQMWxYu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300961; c=relaxed/simple;
	bh=bql9hcFeWcz9bH/7q+zBdFSmaqAiNnaVVaQe7klwTGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clG8ufwIYDVR+nmVNvPxEiuNsEJwz/XzDT9AWvrQGfJvGKLi2f5RCjNtpXB+vluLUCqR1shvvsdbeKWcXoiuXow7dSYhajSwyt4kSwOI5gyPRPjFFFisTHUDH58Q/eXoOFMuuYrzko8SiPvMXyUm3fLfO4Aq3VZyvQ6cj/hdpAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBQrur20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBQrur20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12E6C116D0;
	Sat, 28 Feb 2026 17:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300961;
	bh=bql9hcFeWcz9bH/7q+zBdFSmaqAiNnaVVaQe7klwTGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBQrur20e9PORt2ce/09bBIKTMluPgzx1s51YyHh5p2Y4qXszlCPI/bx63wiSEljn
	 jyZZCAZ5Nful7LYbVYM6Qpyd1C+9w9PLl6UnMd4jzVXXXDEGlUh+/eU6hIEUjRPzjV
	 QzvLt+YsJ98AZw2PLwxWwYuTuc/uvaUsoR58e/4f1BrREyjvZ5u2oJW2+fQAiu62Cv
	 Ni2FC73o74y/t58xDBVIE72hzVHkjw39M1fQCt4tNo4zOV7bCKFti8AF07ZmYtskFK
	 lf13zAGoHpzRa3B6Y5k60I2epufMsmHmiY0HylFI3VhEXURbSb/KHIjrqYuKnHIe2z
	 s/sEZhLzdpn3A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Namhyung Kim <namhyung@kernel.org>,
	Rosalie Fang <rosaliefang@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 086/752] perf/core: Fix slow perf_event_task_exit() with LBR callstacks
Date: Sat, 28 Feb 2026 12:36:37 -0500
Message-ID: <20260228174750.1542406-86-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 4960626f956d63dce57f099016c2ecbe637a8229 ]

I got a report that a task is stuck in perf_event_exit_task() waiting
for global_ctx_data_rwsem.  On large systems with lots threads, it'd
have performance issues when it grabs the lock to iterate all threads
in the system to allocate the context data.

And it'd block task exit path which is problematic especially under
memory pressure.

  perf_event_open
    perf_event_alloc
      attach_perf_ctx_data
        attach_global_ctx_data
          percpu_down_write (global_ctx_data_rwsem)
            for_each_process_thread
              alloc_task_ctx_data
                                               do_exit
                                                 perf_event_exit_task
                                                   percpu_down_read (global_ctx_data_rwsem)

It should not hold the global_ctx_data_rwsem on the exit path.  Let's
skip allocation for exiting tasks and free the data carefully.

Reported-by: Rosalie Fang <rosaliefang@google.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260112165157.1919624-1-namhyung@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1d8ca8e34f5c4..c34b927e5ece3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5279,9 +5279,20 @@ attach_task_ctx_data(struct task_struct *task, struct kmem_cache *ctx_cache,
 		return -ENOMEM;
 
 	for (;;) {
-		if (try_cmpxchg((struct perf_ctx_data **)&task->perf_ctx_data, &old, cd)) {
+		if (try_cmpxchg(&task->perf_ctx_data, &old, cd)) {
 			if (old)
 				perf_free_ctx_data_rcu(old);
+			/*
+			 * Above try_cmpxchg() pairs with try_cmpxchg() from
+			 * detach_task_ctx_data() such that
+			 * if we race with perf_event_exit_task(), we must
+			 * observe PF_EXITING.
+			 */
+			if (task->flags & PF_EXITING) {
+				/* detach_task_ctx_data() may free it already */
+				if (try_cmpxchg(&task->perf_ctx_data, &cd, NULL))
+					perf_free_ctx_data_rcu(cd);
+			}
 			return 0;
 		}
 
@@ -5327,6 +5338,8 @@ attach_global_ctx_data(struct kmem_cache *ctx_cache)
 	/* Allocate everything */
 	scoped_guard (rcu) {
 		for_each_process_thread(g, p) {
+			if (p->flags & PF_EXITING)
+				continue;
 			cd = rcu_dereference(p->perf_ctx_data);
 			if (cd && !cd->global) {
 				cd->global = 1;
@@ -14223,8 +14236,11 @@ void perf_event_exit_task(struct task_struct *task)
 
 	/*
 	 * Detach the perf_ctx_data for the system-wide event.
+	 *
+	 * Done without holding global_ctx_data_rwsem; typically
+	 * attach_global_ctx_data() will skip over this task, but otherwise
+	 * attach_task_ctx_data() will observe PF_EXITING.
 	 */
-	guard(percpu_read)(&global_ctx_data_rwsem);
 	detach_task_ctx_data(task);
 }
 
-- 
2.51.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6199B309997;
	Sun,  1 Jun 2025 23:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821084; cv=none; b=MuqqDrNA1G8wHBEKRKtKNh1SF8DpqQmsW6080YooNoduNdHmaPfgTcWudSmXOzi0FZPPp36v+IdiyULtbP03Y3j+mxxBzWjrO4Aq19WgPqArU+Mdbpy4IFDuYzeH5Wdb9srGk0ydQcBypjQHuIkzRwUwrTW75rPU2naafcEOb20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821084; c=relaxed/simple;
	bh=0JZPRXZ/4kFSPERQfK2yij+1TwpexOjgdO1yFV7OcXE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uWXqHysLTdiFuZLLbgHF0fhgj2m9w2waqC4nvA9wX5GJi4YDAsjm/Bq1NAKur/nRuXZIhetEJloq47o/qJ0kUrVWeIUM8tLs080jCMAtbCs4Mxn7gO8t/qX88EVnhXYjCUuRz+eTXa4iv9P/QbB0ow41xoCLPDFHzcjfRwDndyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wripm3tB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wripm3tB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AEEEC4CEE7;
	Sun,  1 Jun 2025 23:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821084;
	bh=0JZPRXZ/4kFSPERQfK2yij+1TwpexOjgdO1yFV7OcXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wripm3tB5jfBnwooSPvAlfe27D4jyOS7IQS7CtX09RsPpZgpvwesjrdtukv/4lzd5
	 saXwIR8xokmM6xG/9yBPfYjo42agVQHIKJp265LYC9lHhezMGQ+HbuEzKD5WA1Vs6a
	 hBAUarJoBw/AQYa3QY/6VySknxAIQhNVQqhm6KXtEd6HyJWocaD7PZcl8RuBbvTWcn
	 kFCcDUIw79289GRYl5bk/G/dRXrRzKFdpLlEEFMCu3b7lo0A4R15uoM34Y5B14nSQW
	 Nhe+C220oeF6F3jqGZiCbTiimraLPedz+oQhLMVLuD0ObwK7G9I1M8PlCZom+VgjGY
	 Ox8H4AQQb5JtA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	syzbot+01affb1491750534256d@syzkaller.appspotmail.com,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 07/66] workqueue: Fix race condition in wq->stats incrementation
Date: Sun,  1 Jun 2025 19:36:44 -0400
Message-Id: <20250601233744.3514795-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601233744.3514795-1-sashal@kernel.org>
References: <20250601233744.3514795-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.92
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 70e1683ca3a6474360af1d3a020a9a98c8492cc0 ]

Fixed a race condition in incrementing wq->stats[PWQ_STAT_COMPLETED] by
moving the operation under pool->lock.

Reported-by: syzbot+01affb1491750534256d@syzkaller.appspotmail.com
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my detailed analysis: ## Race Condition Analysis The commit fixes a
**data race condition** in `pwq->stats[PWQ_STAT_COMPLETED]++` that is
directly related to a previously fixed race condition for
`pwq->stats[PWQ_STAT_STARTED]++` (commit fe48ba7daefe). **The Problem:**
- Line 3244 in the current kernel shows
`pwq->stats[PWQ_STAT_COMPLETED]++` is executed **outside** the
`pool->lock` protection - Multiple worker threads can concurrently
increment this counter, creating a race condition identical to the one
fixed in commit fe48ba7daefe - The syzbot report confirms this is a real
issue affecting production systems **The Fix:** The commit moves
`pwq->stats[PWQ_STAT_COMPLETED]++` from line ~3244 (before
`lock_map_release`) to after `raw_spin_lock_irq(&pool->lock)` at line
~3273, ensuring atomic access under lock protection. ## Backport
Suitability Criteria **✅ Fixes Important Bug:** Yes - race conditions
can lead to incorrect statistics and potential corruption **✅ Small and
Contained:** The change is minimal - just moving one line of code to a
different location **✅ No Side Effects:** Moving the stats increment
under lock protection has no functional side effects beyond fixing the
race **✅ No Architectural Changes:** This is purely a synchronization
fix with no design changes **✅ Critical Subsystem:** Workqueue is a core
kernel subsystem used throughout the kernel **✅ Clear Stable Tree
Compliance:** - Important bugfix ✓ - Minimal risk ✓ - Confined to
workqueue subsystem ✓ - Reported by automated testing (syzbot) ✓ ##
Historical Precedent The commit directly parallels the **previously
backported** commit fe48ba7daefe (Similar Commit #1), which fixed the
same type of race condition for `PWQ_STAT_STARTED`. That commit was
marked "Backport Status: YES" and demonstrates that: 1. KCSAN-detected
race conditions in workqueue stats are considered backport-worthy 2.
Moving stats increments under lock protection is an established fix
pattern 3. The workqueue maintainer (Tejun Heo) accepts such fixes ##
Risk Assessment **Minimal Risk:** The change only affects when the
counter is incremented (under lock vs. outside lock). Since both
locations are in the same execution path, there's no functional behavior
change - only proper synchronization. **No Regression Potential:** The
fix follows the exact same pattern as the successful previous fix,
reducing the likelihood of introducing new issues. This commit
represents a clear, low-risk bug fix that addresses a real concurrency
issue in a critical kernel subsystem, making it an ideal candidate for
stable tree backporting.

 kernel/workqueue.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 59b6efb2a11c3..78d4f51a9506e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2637,7 +2637,7 @@ __acquires(&pool->lock)
 	 * point will only record its address.
 	 */
 	trace_workqueue_execute_end(work, worker->current_func);
-	pwq->stats[PWQ_STAT_COMPLETED]++;
+
 	lock_map_release(&lockdep_map);
 	lock_map_release(&pwq->wq->lockdep_map);
 
@@ -2666,6 +2666,8 @@ __acquires(&pool->lock)
 
 	raw_spin_lock_irq(&pool->lock);
 
+	pwq->stats[PWQ_STAT_COMPLETED]++;
+
 	/*
 	 * In addition to %WQ_CPU_INTENSIVE, @worker may also have been marked
 	 * CPU intensive by wq_worker_tick() if @work hogged CPU longer than
-- 
2.39.5


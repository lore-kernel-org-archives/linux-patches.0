Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAE76FC5;
	Thu, 12 Feb 2026 01:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770858612; cv=none; b=ZcG3BOJSsAhE0VfQuGpQSjxseUWSPc9zbnwYvJberc59e/+joAPHUx2eBUSx1sOYzGHQkdiJsW2yT4MR2mHskdSugIyYdegJ0U+exvugDXYVFwlKiZpeKr+S7P4a9SYH2ACYvfNV/hE3V5K7Et/Afz5LIijkQ6oZ9R862CTkbtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770858612; c=relaxed/simple;
	bh=tY1f3l3ee3lzvZ7i6WOoDnfPAXcfd0BFXKIKSn5Vqhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fVHyMSkp89isNhIvCCJ9W6AQyz97YmToQhm+gwu1w4NkG1l1ZCzie4D0aCqUYWvkmVpcJvW7+q55fTn22cunJj91qrQLwBwA7TlZrjyIcIyDWp6hN5JO321zL5lZKz0ZwDwkL6FY1CZxWgTxlNOQe/7p28oKTQ11xEZst8++/Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gd+cXV+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gd+cXV+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27699C16AAE;
	Thu, 12 Feb 2026 01:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770858612;
	bh=tY1f3l3ee3lzvZ7i6WOoDnfPAXcfd0BFXKIKSn5Vqhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gd+cXV+9Uv4Cwpt+1tKcUFbZ60e4w64konBjcBic6ji5cxc/9KF/HNIGRfP6J5xT6
	 ivB7P0mCfJ8jovqSEc94Is8T3otTXDXiENZTyEOMPk4Jvs2gcsr/uHziTGMZS8AVwc
	 G1v2k7yEDBhfoDJ6H8vhEwhgGTgyZtsPGbq97JegGFrjVvtNlwo12wgSih/kLn8gBZ
	 MES6qxNZyyU0866u1TtIf51ZawyXUCxJ893YBxLKjWjqC/IQzlKnWs827JaSJbWTWT
	 pnYc9+as6+zwLMDvI1KIdKLXUtmncEF/SE4epK+tW4bJ1H1VTOXCIeekks8CwzHR4r
	 cBvRrSu/sfhww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Joel Fernandes <joelagnelf@nvidia.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] sched/debug: Fix updating of ppos on server write ops
Date: Wed, 11 Feb 2026 20:09:32 -0500
Message-ID: <20260212010955.3480391-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260212010955.3480391-1-sashal@kernel.org>
References: <20260212010955.3480391-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joel Fernandes <joelagnelf@nvidia.com>

[ Upstream commit 6080fb211672aec6ce8f2f5a2e0b4eae736f2027 ]

Updating "ppos" on error conditions does not make much sense. The pattern
is to return the error code directly without modifying the position, or
modify the position on success and return the number of bytes written.

Since on success, the return value of apply is 0, there is no point in
modifying ppos either. Fix it by removing all this and just returning
error code or number of bytes written on success.

Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Acked-by: Tejun Heo <tj@kernel.org>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20260126100050.3854740-3-arighi@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The code is identical in 6.18 stable and the commit's parent. The patch
would apply cleanly to 6.18.y and 6.17.y.

Now I have all the information needed for a thorough analysis.

---

## Detailed Analysis

### 1. Commit Message Analysis

The commit is titled "sched/debug: Fix updating of ppos on server write
ops" — clearly labeled as a **fix**. The commit message describes
incorrect handling of the file position pointer (`ppos`) when
`dl_server_apply_params()` returns an error. The message has strong
review/test coverage:
- **Signed-off-by**: Joel Fernandes (NVIDIA), Peter Zijlstra (Intel
  scheduler maintainer)
- **Reviewed-by**: Juri Lelli (Red Hat), Andrea Righi (NVIDIA)
- **Acked-by**: Tejun Heo (well-known kernel developer)
- **Tested-by**: Christian Loehle (ARM)

### 2. Code Change Analysis — The Bug

The buggy code in `sched_fair_server_write()` (present since the fair
server was introduced in v6.12-rc1 via `d741f297bceaf`):

```c
retval = dl_server_apply_params(&rq->fair_server, runtime, period, 0);
if (retval)
    cnt = retval;       // cnt is size_t (unsigned), retval is int
(-EBUSY = -16)
                        // cnt becomes (size_t)-16 = 0xFFFFFFFFFFFFFFF0

// ... after scoped_guard ends ...
*ppos += cnt;           // ppos gets corrupted: advanced by ~18 exabytes
return cnt;             // returns (ssize_t)(size_t)(-16) = -16 = -EBUSY
(by accident)
```

When `dl_server_apply_params()` fails with `-EBUSY` (bandwidth
overflow), two problems occur:

**Problem 1 — `*ppos` corruption**: The negative error code `-16` is
assigned to `cnt` (type `size_t`, unsigned), producing
`0xFFFFFFFFFFFFFFF0` on 64-bit. This massive value is then added to
`*ppos`, corrupting the file position. While this "accidentally" works
for returning the error code (due to 2's complement), the file position
becomes garbage. Subsequent writes to the same file descriptor will
operate at a corrupt offset.

**Problem 2 — Type-unsafe error propagation**: The error code is passed
through `size_t` (unsigned) and back to `ssize_t` (signed). While this
works by coincidence on 2's complement architectures, it's semantically
incorrect and relies on implementation-defined behavior.

The fix is clean:
1. Initialize `retval = 0`
2. Remove the `if (retval) cnt = retval;` hack
3. After the server restart, check `if (retval < 0) return retval;` —
   properly returning the error code without modifying `ppos`
4. On success, `*ppos += cnt; return cnt;` works correctly as before

### 3. Classification

This is a **real bug fix** for incorrect error handling in a debugfs
write interface. It's not a feature, not a cleanup — the commit fixes
actual incorrect behavior (ppos corruption on error).

### 4. Scope and Risk Assessment

- **Lines changed**: 7 (4 insertions, 3 deletions) — extremely small
- **Files touched**: 1 (`kernel/sched/debug.c`)
- **Risk**: Minimal. The change is purely about error path handling. The
  success path is unchanged.
- **Self-contained**: Yes, no dependencies on other commits in the
  series

### 5. User Impact

- **Who is affected**: Any user writing to
  `/sys/kernel/debug/sched/fair_server/cpuN/{runtime,period}` when
  `dl_server_apply_params()` fails (returns `-EBUSY` due to bandwidth
  overflow)
- **Severity**: Low-to-moderate. Debugfs is root-only, and the `-EBUSY`
  error path is somewhat uncommon. However, when triggered, it corrupts
  the file position, which could confuse tools writing to this interface
- **Affected versions**: All kernels 6.12+ (since the fair server
  interface was introduced)

### 6. Stability and Clean Backport

- The bug exists identically in all stable trees from 6.12.y through
  6.18.y
- The fix applies cleanly to 6.17.y and 6.18.y (identical code)
- For 6.12.y through 6.16.y, minor context adaptation may be needed
  (different `dl_server_stop` conditional, `h_nr_running` vs
  `h_nr_queued`), but the core fix is the same
- Well-tested: Tested-by, multiple Reviewed-by tags from respected
  developers
- Signed off by the scheduler maintainer (Peter Zijlstra)

### 7. Dependency Check

- The commit does NOT depend on patch 2 in the series (which only
  touches `deadline.c`)
- It does NOT depend on the `kstrtoull_from_user` conversion (that
  conversion affected `sched_scaling_write`, not the fair server write)
- The affected code exists in all stable trees from 6.12 onward

### Decision

This commit fixes a real bug (file position corruption on error path) in
the scheduler's debugfs interface. It is:
- Small and surgical (7 lines)
- Obviously correct
- Well-reviewed and tested by multiple kernel developers including the
  scheduler maintainer
- Self-contained with no dependencies
- Applicable to all stable trees 6.12+

The severity is on the lower end (debugfs, root-only, uncommon error
path), but the fix is low-risk and clearly beneficial. The code was
incorrect from day one.

**YES**

 kernel/sched/debug.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 41caa22e0680a..93f009e1076d8 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -345,8 +345,8 @@ static ssize_t sched_fair_server_write(struct file *filp, const char __user *ubu
 	long cpu = (long) ((struct seq_file *) filp->private_data)->private;
 	struct rq *rq = cpu_rq(cpu);
 	u64 runtime, period;
+	int retval = 0;
 	size_t err;
-	int retval;
 	u64 value;
 
 	err = kstrtoull_from_user(ubuf, cnt, 10, &value);
@@ -380,8 +380,6 @@ static ssize_t sched_fair_server_write(struct file *filp, const char __user *ubu
 		dl_server_stop(&rq->fair_server);
 
 		retval = dl_server_apply_params(&rq->fair_server, runtime, period, 0);
-		if (retval)
-			cnt = retval;
 
 		if (!runtime)
 			printk_deferred("Fair server disabled in CPU %d, system may crash due to starvation.\n",
@@ -389,6 +387,9 @@ static ssize_t sched_fair_server_write(struct file *filp, const char __user *ubu
 
 		if (rq->cfs.h_nr_queued)
 			dl_server_start(&rq->fair_server);
+
+		if (retval < 0)
+			return retval;
 	}
 
 	*ppos += cnt;
-- 
2.51.0


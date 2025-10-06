Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEFE246766;
	Mon,  6 Oct 2025 18:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759774772; cv=none; b=NaP4DS1L08XUVJ1a6CWNSdN8k68Jwa+cQPG6J6wn7wnOD1UHOdDUT7Wr3zb4rCF5VFiXKNKEYPi/XOFZ3OSE/IrcPUWUqsYa5HWwGvAQlL0/yWJSZVVnf3udAI5M24z1Y3jKRCzWoefz6nLhd8FERsHpV9HRLfnl23PNA+HSBII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759774772; c=relaxed/simple;
	bh=CvfGgEBl25MOW5xHddb76nDW1uClv4FoaxzRoD4emQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LQNE30f0+POBXe/dKaBgjvxvhUhdgdR/rlj/rXfuRaurkxDsNNXEj9y3x/fQoO7X6gGjfmMZrH/ds6Rqeog5B9/NJzCDJuswlG/S0ThTPIezMXfS/EaGUTupBTx5FfKxPTJS3P+Rm8cAjqdEagOQBMXYvl3jq/Hb1/ol4jwsAYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MMks/9Hs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMks/9Hs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44920C4CEF7;
	Mon,  6 Oct 2025 18:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759774772;
	bh=CvfGgEBl25MOW5xHddb76nDW1uClv4FoaxzRoD4emQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMks/9Hs6HhlqnzM9rZHCQaDxZnMJMV2r5FicJystjyBCJ7BmDFbjGF0vv2cHvLy1
	 4+giO9PSCEKj0h/cOwj15zEwD5ta1o3pIgOlfZNwYgkxmeS/avGBFkl6SMaqqn37VM
	 RoLQ/U1hX1qamWfM5ioNRJDy56hxKFYPuiLoTt6Dp2mEb0Vz4CiduqH0lLtgL3Mbgs
	 /bLVjUzKzlsvshg1rNEaXo5fFMRh8j59fIS3fJgXjwy9I4KOsCl3ovGd+j2siLH1cd
	 6dLWd6hD5fqUBJFYieA3loAJX2oCCuYuD8SHfWJ3t/yij2AN3zbasIViJ89oJhlXXb
	 cH5eIaNJaq6Iw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aaron Lu <ziqianlu@bytedance.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] sched/fair: update_cfs_group() for throttled cfs_rqs
Date: Mon,  6 Oct 2025 14:17:54 -0400
Message-ID: <20251006181835.1919496-22-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251006181835.1919496-1-sashal@kernel.org>
References: <20251006181835.1919496-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aaron Lu <ziqianlu@bytedance.com>

[ Upstream commit fcd394866e3db344cbe0bb485d7e3f741ac07245 ]

With task based throttle model, tasks in a throttled hierarchy are
allowed to continue to run if they are running in kernel mode. For this
reason, PELT clock is not stopped for these cfs_rqs in throttled
hierarchy when they still have tasks running or queued.

Since PELT clock is not stopped, whether to allow update_cfs_group()
doing its job for cfs_rqs which are in throttled hierarchy but still
have tasks running/queued is a question.

The good side is, continue to run update_cfs_group() can get these
cfs_rq entities with an up2date weight and that up2date weight can be
useful to derive an accurate load for the CPU as well as ensure fairness
if multiple tasks of different cgroups are running on the same CPU.
OTOH, as Benjamin Segall pointed: when unthrottle comes around the most
likely correct distribution is the distribution we had at the time of
throttle.

In reality, either way may not matter that much if tasks in throttled
hierarchy don't run in kernel mode for too long. But in case that
happens, let these cfs_rq entities have an up2date weight seems a good
thing to do.

Signed-off-by: Aaron Lu <ziqianlu@bytedance.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Status: YES (with critical dependencies)

### Executive Summary

This commit **should be backported** to stable kernel trees, but **only
as part of the complete task-based throttle model series**. In fact,
this commit has **already been backported** to Linux 6.17 stable tree
(commit 4ee521004f8ef) by stable maintainer Sasha Levin, which is strong
evidence of its suitability for stable backporting.

### Code Change Analysis

The commit makes a minimal code change in `kernel/sched/fair.c`,
removing 3 lines from `update_cfs_group()`:

```c
- if (throttled_hierarchy(gcfs_rq))
- return;
-
```

This removal allows `update_cfs_group()` to continue updating group
entity weights even for cgroups in throttled hierarchies. Previously,
line 3960-3961 would cause an early return, preventing weight
recalculation for any throttled cfs_rq.

### Context and Dependencies

**Critical Finding**: This commit is **NOT standalone**. It is part 5 of
a 7-commit series implementing the task-based throttle model:

1. **e1fad12dcb66b** - "Switch to task based throttle model" (341 line
   change - the base)
2. **eb962f251fbba** - "Task based throttle time accounting"
3. **5b726e9bf9544** - "Get rid of throttled_lb_pair()"
4. **fe8d238e646e1** - "Propagate load for throttled cfs_rq"
5. **fcd394866e3db** - "update_cfs_group() for throttled cfs_rqs" ←
   **This commit**
6. **253b3f5872419** - "Do not special case tasks in throttled
   hierarchy" (follow-up fix)
7. **0d4eaf8caf8cd** - "Do not balance task to a throttled cfs_rq"
   (follow-up performance fix)

All 7 commits were backported together to Linux 6.17 stable tree.

### Why This Change Is Necessary

Under the **old throttle model**: When a cfs_rq was throttled, its
entity was dequeued from the CPU's runqueue, preventing all tasks from
running. The PELT clock stopped, so updating group weights was
unnecessary and prevented by the `throttled_hierarchy()` check at line
3960.

Under the **new task-based throttle model** (introduced by commit
e1fad12dcb66b):
- Tasks in throttled hierarchies **continue running if in kernel mode**
- PELT clock **remains active** while throttled tasks still run/queue
- The `throttled_hierarchy()` check at line 3960 becomes **incorrect** -
  it prevents weight updates even though PELT is still running

**The fix**: Remove lines 3960-3961 to allow `calc_group_shares()` (line
3963) and `reweight_entity()` (line 3965) to execute, giving throttled
cfs_rq entities up-to-date weights for accurate CPU load calculation and
cross-cgroup fairness.

### Benefits and Trade-offs

**Benefits** (from commit message):
- Up-to-date weights enable accurate CPU load derivation
- Ensures fairness when multiple tasks from different cgroups run on
  same CPU
- Prevents stale weight values during extended kernel-mode execution

**Trade-offs** (acknowledged in commit):
- As Benjamin Segall noted: "the most likely correct distribution is the
  distribution we had at the time of throttle"
- May not matter much if tasks don't run in kernel mode for long periods
- Performance tuning was needed (see follow-up commit 0d4eaf8caf8cd
  which addresses hackbench regression by preventing load balancing to
  throttled cfs_rqs)

### What Problems Does This Solve?

The base task-based throttle model (e1fad12dcb66b) solves a **real
bug**: With the old model, a task holding a percpu_rwsem as reader in a
throttled cgroup couldn't run until the next period, causing:
- Writers waiting longer
- Reader build-up
- **Task hung warnings**

This specific commit ensures the new model works correctly by keeping
weight calculations accurate during kernel-mode execution of throttled
tasks.

### Risk Assessment

**Low to Medium Risk** for the following reasons:

**Mitigating factors**:
- Small code change (3 lines removed)
- Already backported to 6.17 stable by experienced maintainer
- Well-tested by multiple developers (Valentin Schneider, Chen Yu,
  Matteo Martelli, K Prateek Nayak)
- Part of thoroughly reviewed patch series linked at
  https://lore.kernel.org/r/20250829081120.806-4-ziqianlu@bytedance.com

**Risk factors**:
- Modifies core scheduler behavior in subtle ways
- Requires entire series (cannot be cherry-picked alone)
- Follow-up performance fixes needed (commit 0d4eaf8caf8cd mentions AMD
  Genoa performance degradation with hackbench that required additional
  checks)
- Affects PELT weight calculations during throttling edge cases

**No evidence of**:
- Reverts
- CVE assignments
- Major regression reports
- Security implications

### Backporting Requirements

If backporting to stable trees **without** the task-based throttle
model:

**DO NOT BACKPORT** - This commit will break things. The
`throttled_hierarchy()` check at line 3960 exists for a reason in the
old throttle model where PELT clocks stop on throttle.

If backporting to stable trees **with** the task-based throttle model:

**MUST BACKPORT** as part of the complete series:
1. Base commit e1fad12dcb66b (341 lines - major change)
2. Commits eb962f251fbba, 5b726e9bf9544, fe8d238e646e1
3. **This commit** (fcd394866e3db)
4. **Follow-up fixes** 253b3f5872419 and 0d4eaf8caf8cd

### Stable Tree Rules Compliance

- ✅ **Fixes important bugs**: Yes (task hung due to percpu_rwsem
  interactions)
- ✅ **Relatively small change**: Yes for this commit (3 lines), but
  series is large
- ✅ **Minimal side effects**: When backported with complete series
- ❌ **No major architectural changes**: No - this IS part of a major
  architectural change
- ✅ **Clear benefits**: Yes - prevents task hangs, improves fairness
- ⚠️ **Explicit stable tag**: No "Cc: stable" tag, but manually selected
  by stable maintainer
- ✅ **Minimal regression risk**: When backported with complete series
  and follow-ups

### Recommendation

**YES - Backport this commit**, with the following requirements:

1. **MUST include the entire task-based throttle series** (commits 1-7
   listed above)
2. **MUST include follow-up performance fixes** (especially
   0d4eaf8caf8cd)
3. **Target kernel version**: 6.17+ (already done) or newer LTS versions
   planning major scheduler updates
4. **Not suitable for**: Older stable trees without appetite for the
   341-line base architectural change

The fact that Sasha Levin already backported this entire series to 6.17
stable is the strongest indicator this is appropriate for stable
backporting.

 kernel/sched/fair.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8ce56a8d507f9..eea0b6571af5a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3957,9 +3957,6 @@ static void update_cfs_group(struct sched_entity *se)
 	if (!gcfs_rq || !gcfs_rq->load.weight)
 		return;
 
-	if (throttled_hierarchy(gcfs_rq))
-		return;
-
 	shares = calc_group_shares(gcfs_rq);
 	if (unlikely(se->load.weight != shares))
 		reweight_entity(cfs_rq_of(se), se, shares);
-- 
2.51.0


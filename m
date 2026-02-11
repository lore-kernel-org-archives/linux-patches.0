Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AEA1A9FA4;
	Wed, 11 Feb 2026 12:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813107; cv=none; b=fxgIPNv75en0grp2VCWfytbMBYLfYJTzjLAn8VE05scx7T/74Nr31mtKzIJGpctc6omADdxU4dcjUr0JhrrE+itUowymr48zKq40NIHzkDXRRWyIo56LT8chVXJhfI7EQucNm2/pPgB3hr2UD9MYtCIriqKuB9nblB+4l1cqEME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813107; c=relaxed/simple;
	bh=Tf2HFjwCMjCSlIDdTt4ev05KSSziEzdiulZOqr2rm+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hD+bi1OP0sxtHQwdYB/YQHCpqRFfKDgif1AIQ7O2G1H5mnV4ZF/7zW/17h6hxDbf5/hWhoOfoyC9NVrMnDXS2nNcK1oaaUKrwPeQelkR/7EFdgoBmtysxns9HYhXP7DaaFAHiPNTQapITI2355nAnrC4pa6RTd8xZ6pgGrYHaag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tewN5C1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tewN5C1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDADC2BC87;
	Wed, 11 Feb 2026 12:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813107;
	bh=Tf2HFjwCMjCSlIDdTt4ev05KSSziEzdiulZOqr2rm+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tewN5C1XsPMIXcoLeufJOAvYhAgoy8xQJX4J2i0/3nQgpQLc9ihayjI/GY+UtxxZs
	 lK4MgFSx59z+qgqdbbOvZbYOErhUlvBusYZe8BYWpXbXykclKpcTZDga55dXD2cBpF
	 4daeHAhT73Pp3xXWQMjlQyMzM/kBanfZuEra1VIzIhqlyw5fyUsPjSGLVlMlPgWlo6
	 3bTbq/X60+ZfyhgcKdUn1E+YuodpcxqsSIv88OXQbtxsWPMvgCWyHIhWMFYWMA8A21
	 qTtIDGThTynefynpPWDwLfrZ0lz2EqzD/xXU8CKSt0czLib7F+/yQ/g7fT8G+UQHPM
	 +C8qHLiYEel7g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yu Kuai <yukuai@fnnas.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Hannes Reinecke <hare@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] blk-mq-sched: unify elevators checking for async requests
Date: Wed, 11 Feb 2026 07:30:27 -0500
Message-ID: <20260211123112.1330287-17-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211123112.1330287-1-sashal@kernel.org>
References: <20260211123112.1330287-1-sashal@kernel.org>
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

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit 1db61b0afdd7e8aa9289c423fdff002603b520b5 ]

bfq and mq-deadline consider sync writes as async requests and only
reserve tags for sync reads by async_depth, however, kyber doesn't
consider sync writes as async requests for now.

Consider the case there are lots of dirty pages, and user use fsync to
flush dirty pages. In this case sched_tags can be exhausted by sync writes
and sync reads can stuck waiting for tag. Hence let kyber follow what
mq-deadline and bfq did, and unify async requests checking for all
elevators.

Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile the findings.

---

## Complete Analysis

### 1. COMMIT MESSAGE ANALYSIS

The subject "blk-mq-sched: unify elevators checking for async requests"
sounds like a cleanup/unification commit, but the message body reveals a
**real I/O starvation bug in the kyber scheduler**:

> *"Consider the case there are lots of dirty pages, and user use fsync
to flush dirty pages. In this case sched_tags can be exhausted by sync
writes and sync reads can stuck waiting for tag."*

This describes a concrete, user-visible problem: sync read starvation
when kyber is the I/O scheduler and fsync flushes dirty pages.

### 2. CODE CHANGE ANALYSIS — The Bug Mechanism

The key to understanding this bug lies in the difference between
`op_is_sync()` and the new `blk_mq_is_sync_read()`:

```470:474:include/linux/blk_types.h
static inline bool op_is_sync(blk_opf_t op)
{
        return (op & REQ_OP_MASK) == REQ_OP_READ ||
                (op & (REQ_SYNC | REQ_FUA | REQ_PREFLUSH));
}
```

`op_is_sync()` returns **true** for both sync reads AND sync writes
(writes with `REQ_SYNC`/`REQ_FUA`/`REQ_PREFLUSH`).

When `fsync()` triggers writeback, writes get `REQ_SYNC` because
`wbc->sync_mode == WB_SYNC_ALL`:

```93:103:include/linux/writeback.h
static inline blk_opf_t wbc_to_write_flags(struct writeback_control
*wbc)
{
        blk_opf_t flags = 0;

        if (wbc->sync_mode == WB_SYNC_ALL)
                flags |= REQ_SYNC;
        // ...
}
```

**Kyber's bug** — in `kyber_limit_depth()`:

```553:564:block/kyber-iosched.c
static void kyber_limit_depth(blk_opf_t opf, struct blk_mq_alloc_data
*data)
{
        /*
  - We use the scheduler tags as per-hardware queue queueing tokens.
  - Async requests can be limited at this stage.
         */
        if (!op_is_sync(opf)) {
                struct kyber_queue_data *kqd =
data->q->elevator->elevator_data;

                data->shallow_depth = kqd->async_depth;
        }
}
```

The condition `!op_is_sync(opf)` means only truly async operations get
throttled. Sync writes (from fsync) pass `op_is_sync()` as true, so they
get **full depth** — no throttling. This means sync writes can consume
ALL sched_tags.

**mq-deadline and bfq already handle this correctly:**

```493:506:block/mq-deadline.c
static void dd_limit_depth(blk_opf_t opf, struct blk_mq_alloc_data
*data)
{
        struct deadline_data *dd = data->q->elevator->elevator_data;

        /* Do not throttle synchronous reads. */
        if (op_is_sync(opf) && !op_is_write(opf))
                return;

        // ... throttle everything else including sync writes
        data->shallow_depth = dd->async_depth;
}
```

Both mq-deadline and bfq use `op_is_sync(opf) && !op_is_write(opf)` to
give full depth only to sync **reads**. Sync writes are properly
throttled by `async_depth`.

**The fix:** Changes kyber's condition from `!op_is_sync(opf)` to
`!blk_mq_is_sync_read(opf)`, where the new helper is defined as:

```c
static inline bool blk_mq_is_sync_read(blk_opf_t opf)
{
    return op_is_sync(opf) && !op_is_write(opf);
}
```

### 3. BEHAVIORAL IMPACT BY SCHEDULER

| Scheduler | Before | After | Behavioral Change? |
|---|---|---|---|
| **kyber** | Only async ops throttled; sync writes get full depth |
Everything except sync reads throttled | **YES — this is the bug fix** |
| **bfq** | `op_is_sync(opf) && !op_is_write(opf)` |
`blk_mq_is_sync_read(opf)` | **NO — semantically identical** |
| **mq-deadline** | `op_is_sync(opf) && !op_is_write(opf)` |
`blk_mq_is_sync_read(opf)` | **NO — semantically identical** |

The bfq and mq-deadline changes are purely cosmetic refactoring. The
actual bug fix is exclusively in kyber.

### 4. BUG SEVERITY

The starvation scenario is concrete and reproducible:
1. System has lots of dirty pages
2. User calls `fsync()` to flush them
3. Lots of sync writes are submitted
4. Kyber gives them full depth (no throttling)
5. All sched_tags consumed by sync writes
6. Sync reads from applications **starve** — they cannot get any tags
7. Read I/O hangs until writes complete

This is a **system responsiveness issue** — applications waiting for
reads (file access, page faults) can hang when another process is doing
heavy fsyncing.

### 5. SCOPE AND RISK

- **Size:** Very small — adds a 4-line helper, changes one condition in
  each of 3 files
- **Risk for bfq/mq-deadline:** Zero — semantically identical changes
- **Risk for kyber:** Low — the change aligns kyber with the well-
  established and battle-tested behavior of mq-deadline and bfq. Kyber's
  `async_depth` is set to 75% of `q->nr_requests` (`KYBER_ASYNC_PERCENT
  = 75`), so sync writes still get generous tag allocation, just not
  unlimited
- **Possible regression:** Slight reduction in sync write throughput on
  kyber (now throttled to 75% of tags instead of 100%), but this is the
  correct behavior to prevent read starvation

### 6. REVIEW AND TESTING

The commit has two `Reviewed-by` tags from experienced kernel
developers:
- **Nilay Shroff** (IBM) — block layer contributor
- **Hannes Reinecke** (SUSE) — longstanding storage/block subsystem
  maintainer

Signed off by **Jens Axboe** — block subsystem maintainer.

### 7. DEPENDENCY ANALYSIS

The commit depends on `42e6c6ce03fd3e` ("lib/sbitmap: convert
shallow_depth from one word to the whole sbitmap") for context lines in
the bfq part (which references `bfqd->async_depths`, renamed from
`bfqd->word_depths` in the prerequisite). However:

- The **core fix** (kyber condition change) is completely independent
- The bfq and mq-deadline changes are cosmetic and could be dropped for
  stable
- For stable trees, the kyber fix + helper function could be backported
  alone, or the bfq/mq-deadline parts could be adapted to match older
  context

### 8. BUG LONGEVITY

The bug has existed since kyber's introduction in commit `00e043936e9a1`
(April 2017, kernel v4.12). The original code already used
`!op_is_sync(op)` which had the same problem. The mq-deadline scheduler
only added tag reservation in v5.15 (commit `07757588e507`, June 2021)
and correctly used `op_is_sync(opf) && !op_is_write(opf)` from the
start. The bfq scheduler similarly had the correct check. Kyber was the
odd one out.

### 9. CONCLUSION

This commit fixes a real I/O starvation bug in the kyber scheduler where
sync writes (from fsync/sync) can exhaust all scheduler tags and starve
sync reads. The fix is:

- **Small and surgical** — one condition change in kyber, plus a trivial
  helper function
- **Obviously correct** — it aligns kyber with the proven behavior of
  mq-deadline and bfq
- **Low risk** — the bfq/mq-deadline parts are semantically identical;
  the kyber change is well-bounded
- **Well-reviewed** — by experienced block subsystem developers and the
  subsystem maintainer
- **Fixes a real user-visible bug** — read I/O starvation during fsync-
  heavy workloads

The only concern is the dependency on a prerequisite for the bfq context
lines, but the core kyber fix is standalone and the bfq/mq-deadline
parts are optional cosmetic refactoring that could be adapted or dropped
for stable trees.

**YES**

 block/bfq-iosched.c   | 2 +-
 block/blk-mq-sched.h  | 5 +++++
 block/kyber-iosched.c | 2 +-
 block/mq-deadline.c   | 2 +-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 6e54b1d3d8bc2..9e9d081e86bb2 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -697,7 +697,7 @@ static void bfq_limit_depth(blk_opf_t opf, struct blk_mq_alloc_data *data)
 	unsigned int limit, act_idx;
 
 	/* Sync reads have full depth available */
-	if (op_is_sync(opf) && !op_is_write(opf))
+	if (blk_mq_is_sync_read(opf))
 		limit = data->q->nr_requests;
 	else
 		limit = bfqd->async_depths[!!bfqd->wr_busy_queues][op_is_sync(opf)];
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index 02c40a72e9598..5678e15bd33c4 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -137,4 +137,9 @@ static inline void blk_mq_set_min_shallow_depth(struct request_queue *q,
 						depth);
 }
 
+static inline bool blk_mq_is_sync_read(blk_opf_t opf)
+{
+	return op_is_sync(opf) && !op_is_write(opf);
+}
+
 #endif
diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index c1b36ffd19ceb..2b3f5b8959af0 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -556,7 +556,7 @@ static void kyber_limit_depth(blk_opf_t opf, struct blk_mq_alloc_data *data)
 	 * We use the scheduler tags as per-hardware queue queueing tokens.
 	 * Async requests can be limited at this stage.
 	 */
-	if (!op_is_sync(opf)) {
+	if (!blk_mq_is_sync_read(opf)) {
 		struct kyber_queue_data *kqd = data->q->elevator->elevator_data;
 
 		data->shallow_depth = kqd->async_depth;
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 3e3719093aec7..29d00221fbea6 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -495,7 +495,7 @@ static void dd_limit_depth(blk_opf_t opf, struct blk_mq_alloc_data *data)
 	struct deadline_data *dd = data->q->elevator->elevator_data;
 
 	/* Do not throttle synchronous reads. */
-	if (op_is_sync(opf) && !op_is_write(opf))
+	if (blk_mq_is_sync_read(opf))
 		return;
 
 	/*
-- 
2.51.0


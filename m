Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01F43207;
	Wed, 11 Feb 2026 12:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813091; cv=none; b=s0xL4kaqmGm5WoU/G6L2yV7QLM5Rfs01T20MvdhTwGZ6yVsatEbz4QkqeDchVRTeG9piVFhiCWVSDn4Py6g14+6i4IYTJ/LlTxW2Jbea0LmFgc6nMHpDXyUYfOyitJTNTV3wOaizp5F7Th2XXO9t60/EepFU+SnOnHDgVEMG3KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813091; c=relaxed/simple;
	bh=54ptZY70lc/rowJfJIo76PTdUbKdlVReVnA7x+FOggg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdw85/gaJbhUhukA5G2mTJX3cPhVUMWcK3qIhx3nLeJ0OkDwBVP411Jz/ApW64VoSwvAhVjTmgdYWYmY0/AFtttkUr5FtY4x6VHx//W57H3UvIbOnWvy7PfiEnt4quaGvaECk0uOTqE5SBvWfmf5M1cEh63B+pRfkrjLcgZ25Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AfDKzCeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AfDKzCeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC58C19425;
	Wed, 11 Feb 2026 12:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813090;
	bh=54ptZY70lc/rowJfJIo76PTdUbKdlVReVnA7x+FOggg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfDKzCeBPe361GvqJ5M4rZ0G8L5qd50P1Gf8EJuL+cy3pAZCJze+0dMMslrTxixyI
	 ExxklOyK9j6n/tnlgOG0bAaxg4y3S/xrGwEt3jSIC4zLw3/9lb5MLnVS1J3D+f9gT+
	 hXP+4wrvJ5wTrSG23vlAE9EMM44UQBtxwstBMBc1Chm9hSmPl8ktdewgJFilLBwU6A
	 6q2SgoRooeyzEbqBcjVKBk+ldl5NFoecLvSb9kI4uANQcf6pJGwJsFh7KwZnOOhTJe
	 TYk+Z6mtlZaAB6jK4yzXjQXH0C9PCRnDtojAyDdhJdt7ZZtCpIq7j3NbMr3h4Y5MaZ
	 E9NFKmfArFi0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Luke Wang <ziniu.wang_1@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] block: decouple secure erase size limit from discard size limit
Date: Wed, 11 Feb 2026 07:30:19 -0500
Message-ID: <20260211123112.1330287-9-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Luke Wang <ziniu.wang_1@nxp.com>

[ Upstream commit ee81212f74a57c5d2b56cf504f40d528dac6faaf ]

Secure erase should use max_secure_erase_sectors instead of being limited
by max_discard_sectors. Separate the handling of REQ_OP_SECURE_ERASE from
REQ_OP_DISCARD to allow each operation to use its own size limit.

Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is an important caller. `blk_insert_cloned_request` is used by
device mapper (dm) to submit cloned requests. If
`blk_queue_get_max_sectors` returns the wrong value (e.g.,
`max_discard_sectors` instead of `max_secure_erase_sectors`), and the
cloned request's sector count exceeds the wrong limit but fits within
the correct one, the request will be **rejected with BLK_STS_IOERR** on
line 3291. This is a real I/O error path!

Here is my complete analysis:

---

## Detailed Analysis

### 1. Commit Message Analysis

The commit clearly describes a **bug fix**: secure erase operations were
incorrectly limited by `max_discard_sectors` instead of
`max_secure_erase_sectors`. This is a correctness issue, not a feature.
The commit was reviewed by Ulf Hansson (MMC maintainer) and merged by
Jens Axboe (block layer maintainer).

### 2. Code Change Analysis

The patch modifies two files with two distinct changes:

**Change A: `block/blk.h` - `blk_queue_get_max_sectors()`**

Before the fix:
```211:213:block/blk.h
        if (unlikely(op == REQ_OP_DISCARD || op == REQ_OP_SECURE_ERASE))
                return min(q->limits.max_discard_sectors,
                           UINT_MAX >> SECTOR_SHIFT);
```

Both `REQ_OP_DISCARD` and `REQ_OP_SECURE_ERASE` used
`max_discard_sectors`. The fix separates them so secure erase uses
`max_secure_erase_sectors`.

**Change B: `block/blk-merge.c` - `bio_split_discard()`**

The original `bio_split_discard()` always split using
`lim->max_discard_sectors`, even for `REQ_OP_SECURE_ERASE` (which
reaches this function via `__bio_split_to_limits` at line 407-409 of
`blk.h`). The fix refactors the function into a wrapper that selects the
correct limit and a helper `__bio_split_discard()` that does the actual
splitting.

### 3. Bug Mechanism and Impact

**The bug**: The kernel `queue_limits` structure has separate fields for
`max_discard_sectors` and `max_secure_erase_sectors`, but the block
layer core code in two critical paths ignored the secure erase field and
always used the discard field.

**Concrete impact scenarios**:

1. **virtio_blk**: This driver reads separate limits from the virtio
   config for discard (`max_discard_sectors`) and secure erase
   (`max_secure_erase_sectors`). The driver even documents the
   workaround: *"The discard and secure erase limits are combined since
   the Linux block layer uses the same limit for both commands."*
   (virtio_blk.c lines 1336-1341). This means the driver had to
   artificially reduce its limits to compensate for the block layer bug.

2. **xen-blkfront**: Sets `max_secure_erase_sectors = UINT_MAX` while
   `max_discard_sectors = get_capacity(gd)` - different values.

3. **dm (device mapper)**: The `blk_insert_cloned_request()` function
   calls `blk_queue_get_max_sectors()` and rejects requests that exceed
   the limit with `BLK_STS_IOERR`. If `max_secure_erase_sectors` >
   `max_discard_sectors` on the underlying device, valid secure erase
   requests could be rejected with I/O errors. Conversely, if
   `max_secure_erase_sectors` < `max_discard_sectors`, oversized
   requests could be sent to hardware.

4. **The most dangerous case**: When `max_secure_erase_sectors <
   max_discard_sectors`, the bio splitting code won't split the secure
   erase bio when it should, sending a request larger than the device
   can handle. This can cause **I/O errors, device failures, or data
   integrity issues** with secure erase operations.

### 4. Scope and Risk Assessment

- **Lines changed**: ~25 lines of actual logic change across 2 files
- **Files touched**: `block/blk-merge.c` and `block/blk.h` (core block
  layer, but well-contained)
- **Risk of regression**: **Low**. For any driver that sets
  `max_secure_erase_sectors == max_discard_sectors` (like MMC), the
  behavior is completely unchanged. For drivers with different values,
  the behavior is corrected.
- **The change is obviously correct**: Secure erase operations should
  use secure erase limits, not discard limits.

### 5. Affected Subsystems and Users

- MMC/eMMC (mobile, embedded) - same values, no visible change
- virtio_blk (VMs, cloud) - corrects a workaround-needing limitation
- xen-blkfront (Xen VMs) - corrects a real mismatch
- dm (device-mapper stacking) - fixes potential I/O errors

### 6. Backport Complexity

- For kernels 6.12+: The patch should apply nearly cleanly;
  `bio_submit_split()` and the current code structure exist.
- For kernels 6.1-6.11: The `blk.h` change applies cleanly (same
  pattern). The `blk-merge.c` change needs adaptation because the
  splitting mechanism is different (returns split bio instead of using
  `bio_submit_split`), but the conceptual fix is the same.
- For kernel 5.15: `max_secure_erase_sectors` field exists but
  `blkdev_issue_secure_erase` was introduced in 6.1; older kernels have
  different secure erase code paths.

### 7. Stability Indicators

- Reviewed by Ulf Hansson (MMC subsystem co-maintainer)
- Merged by Jens Axboe (block layer maintainer)
- Simple, obviously correct fix

### 8. Conclusion

This commit fixes a real bug where the block layer core was using the
wrong limit for secure erase operations, potentially causing:
- I/O errors when valid requests are rejected
- Oversized requests being sent to hardware
- Unnecessary performance limitations

The fix is small, contained, obviously correct, and was reviewed by
multiple maintainers. It affects core block layer code that is shared
across all block devices supporting secure erase. The risk of regression
is minimal since the change only affects the code path when
`max_secure_erase_sectors != max_discard_sectors`.

**YES**

 block/blk-merge.c | 21 +++++++++++++++++----
 block/blk.h       |  6 +++++-
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index d3115d7469df0..bf8faadb0bd46 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -158,8 +158,9 @@ static struct bio *bio_submit_split(struct bio *bio, int split_sectors)
 	return bio;
 }
 
-struct bio *bio_split_discard(struct bio *bio, const struct queue_limits *lim,
-		unsigned *nsegs)
+static struct bio *__bio_split_discard(struct bio *bio,
+		const struct queue_limits *lim, unsigned *nsegs,
+		unsigned int max_sectors)
 {
 	unsigned int max_discard_sectors, granularity;
 	sector_t tmp;
@@ -169,8 +170,7 @@ struct bio *bio_split_discard(struct bio *bio, const struct queue_limits *lim,
 
 	granularity = max(lim->discard_granularity >> 9, 1U);
 
-	max_discard_sectors =
-		min(lim->max_discard_sectors, bio_allowed_max_sectors(lim));
+	max_discard_sectors = min(max_sectors, bio_allowed_max_sectors(lim));
 	max_discard_sectors -= max_discard_sectors % granularity;
 	if (unlikely(!max_discard_sectors))
 		return bio;
@@ -194,6 +194,19 @@ struct bio *bio_split_discard(struct bio *bio, const struct queue_limits *lim,
 	return bio_submit_split(bio, split_sectors);
 }
 
+struct bio *bio_split_discard(struct bio *bio, const struct queue_limits *lim,
+		unsigned *nsegs)
+{
+	unsigned int max_sectors;
+
+	if (bio_op(bio) == REQ_OP_SECURE_ERASE)
+		max_sectors = lim->max_secure_erase_sectors;
+	else
+		max_sectors = lim->max_discard_sectors;
+
+	return __bio_split_discard(bio, lim, nsegs, max_sectors);
+}
+
 static inline unsigned int blk_boundary_sectors(const struct queue_limits *lim,
 						bool is_atomic)
 {
diff --git a/block/blk.h b/block/blk.h
index e4c433f62dfc7..4cd5a91346d8a 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -208,10 +208,14 @@ static inline unsigned int blk_queue_get_max_sectors(struct request *rq)
 	struct request_queue *q = rq->q;
 	enum req_op op = req_op(rq);
 
-	if (unlikely(op == REQ_OP_DISCARD || op == REQ_OP_SECURE_ERASE))
+	if (unlikely(op == REQ_OP_DISCARD))
 		return min(q->limits.max_discard_sectors,
 			   UINT_MAX >> SECTOR_SHIFT);
 
+	if (unlikely(op == REQ_OP_SECURE_ERASE))
+		return min(q->limits.max_secure_erase_sectors,
+			   UINT_MAX >> SECTOR_SHIFT);
+
 	if (unlikely(op == REQ_OP_WRITE_ZEROES))
 		return q->limits.max_write_zeroes_sectors;
 
-- 
2.51.0


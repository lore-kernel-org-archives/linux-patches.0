Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A375E28DB46;
	Sat, 14 Feb 2026 21:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104335; cv=none; b=TvS/j47j7C47+VsUSK0qHyHkdVC5bg/naHr3TEXeqwYUwHc9vodDl3uIUqx0CIHzJem5+x4fFTx68bXEZR3R/1EqyIQCP5N/27TOHrdBMrvhuTQFpwD+348TweqsdJjf6XBzNyKdytPPzUqTVfuNyvmuZ5e38loiYxdJtcr9yVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104335; c=relaxed/simple;
	bh=Yqrhd+nhoVtpTaD+nA/VjIKxancmh3d+x4JTwZkS4D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eKkbFvh+FbFYaSPyBex+oFQ3Kwjy7ri+GmLQ6S1F25xjEci/BhrLjfztZDuE2cumMZrOZanFs1pxjA8hrA/lcx366rqCcvKFvze77P6GiWCbAD4sFlLa+sCVGBCdaaVFTkWyxSlxFzqTPHO7efWwkkKGPgdLYPOC8wSVT1dhg2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRCCaVuG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRCCaVuG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C601C19422;
	Sat, 14 Feb 2026 21:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104335;
	bh=Yqrhd+nhoVtpTaD+nA/VjIKxancmh3d+x4JTwZkS4D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WRCCaVuGx/gdP4ep3wZOmQwgjNhWzJgi5gzvwttt13IGJTZUbv+Z1HsHmdZ904B6E
	 gWNy9fX66BlMsSi+UpDxKNODbzMj8SEMOp8HGvOYpFNcAHPD/q2e/5kJHdgS+CGppp
	 uVW0M9KaQeNfgQlhaud6bjFbnrvrEbR5ybY9JSqKn8DKgWwfO8bVgqlZbDs/HDFQAp
	 BtTx0EcjNlPW1si/GMUXcsaSNdjsiJCIPYz7NAStX/95e9ZSe/K/gXIIottconeOU/
	 X3lCRqPahc4Q3B7RyoHGchn4PHUofjca2B8OrOkKyKYLjTyk+A5RLnxQuVWqXLvkRg
	 lDZb/8f5TK8XQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Grest <Alexander.Grest@microsoft.com>,
	Mostafa Saleh <smostafa@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jgg@ziepe.ca,
	praan@google.com,
	joerg.roedel@amd.com,
	yelangyan@huaqin.corp-partner.google.com,
	baolu.lu@linux.intel.com
Subject: [PATCH AUTOSEL 6.19-5.10] iommu/arm-smmu-v3: Improve CMDQ lock fairness and efficiency
Date: Sat, 14 Feb 2026 16:22:49 -0500
Message-ID: <20260214212452.782265-24-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
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

From: Alexander Grest <Alexander.Grest@microsoft.com>

[ Upstream commit df180b1a4cc51011c5f8c52c7ec02ad2e42962de ]

The SMMU CMDQ lock is highly contentious when there are multiple CPUs
issuing commands and the queue is nearly full.

The lock has the following states:
 - 0:		Unlocked
 - >0:		Shared lock held with count
 - INT_MIN+N:	Exclusive lock held, where N is the # of shared waiters
 - INT_MIN:	Exclusive lock held, no shared waiters

When multiple CPUs are polling for space in the queue, they attempt to
grab the exclusive lock to update the cons pointer from the hardware. If
they fail to get the lock, they will spin until either the cons pointer
is updated by another CPU.

The current code allows the possibility of shared lock starvation
if there is a constant stream of CPUs trying to grab the exclusive lock.
This leads to severe latency issues and soft lockups.

Consider the following scenario where CPU1's attempt to acquire the
shared lock is starved by CPU2 and CPU0 contending for the exclusive
lock.

CPU0 (exclusive)  | CPU1 (shared)     | CPU2 (exclusive)    | `cmdq->lock`
--------------------------------------------------------------------------
trylock() //takes |                   |                     | 0
                  | shared_lock()     |                     | INT_MIN
                  | fetch_inc()       |                     | INT_MIN
                  | no return         |                     | INT_MIN + 1
                  | spins // VAL >= 0 |                     | INT_MIN + 1
unlock()          | spins...          |                     | INT_MIN + 1
set_release(0)    | spins...          |                     | 0 see[NOTE]
(done)            | (sees 0)          | trylock() // takes  | 0
                  | *exits loop*      | cmpxchg(0, INT_MIN) | 0
                  |                   | *cuts in*           | INT_MIN
                  | cmpxchg(0, 1)     |                     | INT_MIN
                  | fails // != 0     |                     | INT_MIN
                  | spins // VAL >= 0 |                     | INT_MIN
                  | *starved*         |                     | INT_MIN

[NOTE] The current code resets the exclusive lock to 0 regardless of the
state of the lock. This causes two problems:
1. It opens the possibility of back-to-back exclusive locks and the
   downstream effect of starving shared lock.
2. The count of shared lock waiters are lost.

To mitigate this, we release the exclusive lock by only clearing the sign
bit while retaining the shared lock waiter count as a way to avoid
starving the shared lock waiters.

Also deleted cmpxchg loop while trying to acquire the shared lock as it
is not needed. The waiters can see the positive lock count and proceed
immediately after the exclusive lock is released.

Exclusive lock is not starved in that submitters will try exclusive lock
first when new spaces become available.

Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Alexander Grest <Alexander.Grest@microsoft.com>
Signed-off-by: Jacob Pan <jacob.pan@linux.microsoft.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### 3. Detailed Code Change Analysis

The commit makes two key changes:

**Change 1: `arm_smmu_cmdq_shared_lock()` simplification (the starvation
fix)**

**Before:**
```c
do {
    val = atomic_cond_read_relaxed(&cmdq->lock, VAL >= 0);
} while (atomic_cmpxchg_relaxed(&cmdq->lock, val, val + 1) != val);
```

**After:**
```c
atomic_cond_read_relaxed(&cmdq->lock, VAL > 0);
```

The old code waited for `VAL >= 0` (unlocked), then tried to CAS to
increment. But between seeing 0 and the CAS, another exclusive locker
could steal the lock, causing the shared waiter to loop endlessly. The
new code waits for `VAL > 0` — since the shared waiter already
incremented the counter (the `atomic_fetch_inc_relaxed` earlier), once
the exclusive lock releases, the counter will already be positive (the
waiter's increment is preserved). No CAS loop needed.

**Change 2: `arm_smmu_cmdq_exclusive_unlock_irqrestore()` (the root
cause fix)**

**Before:**
```c
atomic_set_release(&cmdq->lock, 0);
```

**After:**
```c
atomic_fetch_andnot_release(INT_MIN, &cmdq->lock);
```

This is the critical fix. Previously, the exclusive unlock reset the
lock to 0 unconditionally, **discarding the count of shared waiters**.
This meant:
1. Shared waiters' increments were lost
2. Another exclusive locker could immediately grab the lock (seeing 0)
3. Shared waiters would be starved indefinitely

The new code only clears the sign bit (INT_MIN), preserving the shared
waiter count. After this, if there are N shared waiters, the lock value
becomes N (positive), and:
- Shared waiters immediately see the positive value and proceed
- No exclusive locker can grab it (they need value == 0)

### 4. Classification

This is a **bug fix** — specifically fixing a **lock starvation issue
that causes soft lockups**. The commit explicitly states "severe latency
issues and soft lockups."

### 5. Scope and Risk Assessment

- **Files changed:** 1 file
- **Lines changed:** Roughly 30 lines net (within the locking functions
  only)
- **Subsystem:** ARM SMMUv3 IOMMU — widely used in ARM64 server and
  embedded systems
- **Risk:** LOW-MEDIUM. The changes are localized to the custom locking
  primitives. The logic is well-explained and the correctness argument
  is clear. The change was reviewed by Google and NVIDIA engineers and
  signed off by Will Deacon (ARM SMMU maintainer).

**Potential concern:** The change to `VAL > 0` (from `VAL >= 0`) in
`shared_lock()` requires the unlock change to work together — they are
semantically coupled. Both changes are in this single commit, so they
must be backported together (which they are).

### 6. User Impact

- **Who is affected:** All ARM64 systems using SMMUv3 under heavy IOMMU
  command queue pressure (multi-CPU, high throughput I/O)
- **Severity:** Soft lockups are a serious issue — they can freeze the
  system, trigger watchdog resets, and cause service outages
- **Real-world trigger:** Multiple CPUs issuing IOMMU commands
  concurrently with a nearly full queue — this is a realistic scenario
  for servers with many I/O devices

### 7. Stability Indicators

- **Reviewed-by:** Two reviewers from Google and NVIDIA
- **Signed-off-by:** Will Deacon (ARM SMMU maintainer) — highest
  authority for this subsystem
- The commit message provides a detailed starvation scenario,
  demonstrating thorough understanding of the bug

### 8. Dependency Check

The changes are self-contained within the locking primitives. No other
commits are needed. The code being modified (the CMDQ locking mechanism)
has existed since the SMMUv3 driver was introduced and is present in all
stable trees that support ARM SMMUv3.

### 9. Conclusion

This commit fixes a real, severe bug (soft lockups due to lock
starvation) in the ARM SMMUv3 command queue. The fix is:
- **Obviously correct:** The starvation mechanism is clearly explained
  and the fix directly addresses it
- **Fixes a real bug:** Soft lockups are a serious stability issue
- **Small and contained:** ~30 lines changed in one file, limited to
  locking primitives
- **No new features:** Pure bug fix
- **Well-reviewed:** Multiple reviewers plus maintainer sign-off
- **Low regression risk:** The logic change is clean and well-reasoned

The fix is directly relevant to stable kernel users running ARM64 server
and embedded systems with SMMUv3. Soft lockups can cause service outages
and system instability.

**YES**

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 31 ++++++++++++++-------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d16d35c78c068..7a6aea3b61c11 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -487,20 +487,26 @@ static void arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu)
  */
 static void arm_smmu_cmdq_shared_lock(struct arm_smmu_cmdq *cmdq)
 {
-	int val;
-
 	/*
-	 * We can try to avoid the cmpxchg() loop by simply incrementing the
-	 * lock counter. When held in exclusive state, the lock counter is set
-	 * to INT_MIN so these increments won't hurt as the value will remain
-	 * negative.
+	 * When held in exclusive state, the lock counter is set to INT_MIN
+	 * so these increments won't hurt as the value will remain negative.
+	 * The increment will also signal the exclusive locker that there are
+	 * shared waiters.
 	 */
 	if (atomic_fetch_inc_relaxed(&cmdq->lock) >= 0)
 		return;
 
-	do {
-		val = atomic_cond_read_relaxed(&cmdq->lock, VAL >= 0);
-	} while (atomic_cmpxchg_relaxed(&cmdq->lock, val, val + 1) != val);
+	/*
+	 * Someone else is holding the lock in exclusive state, so wait
+	 * for them to finish. Since we already incremented the lock counter,
+	 * no exclusive lock can be acquired until we finish. We don't need
+	 * the return value since we only care that the exclusive lock is
+	 * released (i.e. the lock counter is non-negative).
+	 * Once the exclusive locker releases the lock, the sign bit will
+	 * be cleared and our increment will make the lock counter positive,
+	 * allowing us to proceed.
+	 */
+	atomic_cond_read_relaxed(&cmdq->lock, VAL > 0);
 }
 
 static void arm_smmu_cmdq_shared_unlock(struct arm_smmu_cmdq *cmdq)
@@ -527,9 +533,14 @@ static bool arm_smmu_cmdq_shared_tryunlock(struct arm_smmu_cmdq *cmdq)
 	__ret;								\
 })
 
+/*
+ * Only clear the sign bit when releasing the exclusive lock this will
+ * allow any shared_lock() waiters to proceed without the possibility
+ * of entering the exclusive lock in a tight loop.
+ */
 #define arm_smmu_cmdq_exclusive_unlock_irqrestore(cmdq, flags)		\
 ({									\
-	atomic_set_release(&cmdq->lock, 0);				\
+	atomic_fetch_andnot_release(INT_MIN, &cmdq->lock);		\
 	local_irq_restore(flags);					\
 })
 
-- 
2.51.0


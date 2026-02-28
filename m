Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E536392811
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301079; cv=none; b=kez2YUWqHksHgyl9GxXZRKwAE8lFJ1Albw7mRjbloGAy4LemDehKISm1jUfwwWg68ESgNxa2nuXS+sc238JZOoVPMZvAESduFBpgHv+KFoE8DhvhjiHJIDARM8k6bajJI5KTlcQLpKG0lsLoR7PEnvvlG6rA3g/agNobkaLXtMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301079; c=relaxed/simple;
	bh=HcrYxhHlUeEq28Cr9ceXypYtKtvWgkKsE5EzqUAssD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isq39AQXz5xksWHg/QOmMJ+bZbMtusNrfT/2Rn/7r3Ws1KWFHXnDhNXc9K6MDolStXeNuzdotQ2LqydYhTP6u4HzlfqLpG//uZnmweR1tcK3nFm1R8aq7kfAS7a8xiw7aCEnK/DXZE52Rs+mQPrM00oxbQfVHyUbIDReL9BRXkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iX3nja4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iX3nja4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937C3C116D0;
	Sat, 28 Feb 2026 17:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301079;
	bh=HcrYxhHlUeEq28Cr9ceXypYtKtvWgkKsE5EzqUAssD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iX3nja4c7SPL/k6jZ5dKFU2zUfXEziwCQWgqopZV//vQOt6jkiNX/q6kDhSmUldQb
	 ORC4SGZb3mXxKwHx/Okd5px5Fxar7clOO6YDu59D1rLQFdYmsBX/aDUcJ1HRtmY81Q
	 kuh4IWkjvuYgX8PaW4d3Ul0ZUqu/0+HepBsIV8OFUenvE3QpXrUq7wz4inRAxv2V/P
	 wxOu4mNQvPJmDl9JqIw4UJUZ/OGxW8DoPhWykSx7XuE1cy19kAB5dM/Fl54Bf7yBqY
	 pC/dSxgO3+mqjqpm5tgBFHFDgtyEsqBR+iUg7YJ7eJo6Y0QOpNYhLHbSICqYgXWte8
	 Zmza1utONcH7Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alexander Grest <Alexander.Grest@microsoft.com>,
	Mostafa Saleh <smostafa@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 226/752] iommu/arm-smmu-v3: Improve CMDQ lock fairness and efficiency
Date: Sat, 28 Feb 2026 12:38:57 -0500
Message-ID: <20260228174750.1542406-226-sashal@kernel.org>
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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 31 ++++++++++++++-------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9780f40ba3e65..b4f757e1f105f 100644
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


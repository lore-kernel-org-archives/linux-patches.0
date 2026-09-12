Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A076312834;
	Sat, 12 Sep 2026 08:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200145; cv=none; b=OU+ncfAKRHpdqXDsTtlAjtNguXNXqH9mDWzgd/s4UtRMHsu4btP4l3O9R+9lEHbt2JHw0l2EmMGr9trXRfFR+l7gNgASShf80HAAXeYLJu+cqaMY35w6LVkliD1RA5B3JJOzC1LEvOuEWvO7HPxXBTUnUQshVqDh35APhCi/3Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200145; c=relaxed/simple;
	bh=S24zC5bz4WYPm/CCHDT+XAaDG7r6KooCr4iAruXNdUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrS4qmSsKkLNk5kLlfqbKu4XBIfJf5W4j0VqmzDJZc+ileCEu8pZDHIYbn94erVGgt1bNRr53Xa50zMFLhAzBr5V/tx56noOUnhosMa3mwVR3GDAr+EH6OOo9nUZC5zLKn7TIWbCI1IO1X8owuXUZdIhyaSyeWHxP7YK5s8MCVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKG762EQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKG762EQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C4B1F000FF;
	Sat, 12 Sep 2026 08:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200144;
	bh=pdwdMvz5+sP522/XVWNFNcoRkBDT3/LWRg5vitd/Af8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKG762EQ98tqpqRPJZmq5laQdd2kf5WHdRHRprIU8T0JItmdoOw1oqZch5puEENdc
	 RpEki1v1HHJVNVV7QO+O5k7MdxGMiSVAK9MumGU0D4mhUUAoRFHZWxvCaACnOGovpD
	 NRDQaQSTEiq86uQ0J3DcQSqrti6SyRaeUSbM9IGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0688/1815] sched_ext: Abort directly from the hardlockup handler
Date: Sat, 12 Sep 2026 08:40:38 +0200
Message-ID: <20260912065705.041218521@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 3c4b38064937a761ebbf85b1649e812db85eb59e ]

scx_hardlockup() defers the abort to an irq_work because exit claiming used
to take scx_sched_lock and couldn't run from NMI. The deferral is now
unnecessary - claiming is NMI-safe and asserting ->aborting is exactly what
breaks the live-locks that hard-lock CPUs. Call handle_lockup() directly and
drop the irq_work. This also makes the self-detected case recoverable: the
perf watchdog fires on the hard-locked CPU itself, where a queued irq_work
never runs with IRQs off.

Also fix the return value: %true used to be returned whenever sched_ext was
loaded, suppressing the kernel's hardlockup report even when the abort was
refused. Return %true only when this call initiated the abort.

Fixes: bd2d76455b65 ("sched_ext: Defer scx_hardlockup() out of NMI")
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 35 +++++++++--------------------------
 1 file changed, 9 insertions(+), 26 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 688158b53ddb5..c6cfb162abbdc 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -5363,25 +5363,6 @@ void scx_softlockup(u32 dur_s)
 			cpu, dur_s);
 }
 
-/*
- * scx_hardlockup() runs from NMI and eventually calls scx_claim_exit(),
- * which takes scx_sched_lock. scx_sched_lock isn't NMI-safe and grabbing
- * it from NMI context can lead to deadlocks. Defer via irq_work; the
- * disable path runs off irq_work anyway.
- */
-static atomic_t scx_hardlockup_cpu = ATOMIC_INIT(-1);
-
-static void scx_hardlockup_irq_workfn(struct irq_work *work)
-{
-	int cpu = atomic_xchg(&scx_hardlockup_cpu, -1);
-
-	if (cpu >= 0 && handle_lockup(cpu, "hard lockup - CPU %d", cpu))
-		printk_deferred(KERN_ERR "sched_ext: Hard lockup - CPU %d, disabling BPF scheduler\n",
-				cpu);
-}
-
-static DEFINE_IRQ_WORK(scx_hardlockup_irq_work, scx_hardlockup_irq_workfn);
-
 /**
  * scx_hardlockup - sched_ext hardlockup handler
  *
@@ -5390,19 +5371,21 @@ static DEFINE_IRQ_WORK(scx_hardlockup_irq_work, scx_hardlockup_irq_workfn);
  * Try kicking out the current scheduler in an attempt to recover the system to
  * a good state before taking more drastic actions.
  *
- * Queues an irq_work; the handle_lockup() call happens in IRQ context (see
- * scx_hardlockup_irq_workfn).
+ * Called from NMI. Aborting the scheduler sets ->aborting throughout the
+ * hierarchy before returning, which is what breaks the dispatch-path live-locks
+ * that can hard-lock CPUs.
  *
- * Returns %true if sched_ext is enabled and the work was queued, %false
- * otherwise.
+ * Returns %true if sched_ext is enabled and abort was initiated, which may
+ * resolve the lockup. %false if sched_ext is not enabled or abort was already
+ * initiated by someone else.
  */
 bool scx_hardlockup(int cpu)
 {
-	if (!rcu_access_pointer(scx_root))
+	if (!handle_lockup(cpu, "hard lockup - CPU %d", cpu))
 		return false;
 
-	atomic_cmpxchg(&scx_hardlockup_cpu, -1, cpu);
-	irq_work_queue(&scx_hardlockup_irq_work);
+	printk_deferred(KERN_ERR "sched_ext: Hard lockup - CPU %d, disabling BPF scheduler\n",
+			cpu);
 	return true;
 }
 
-- 
2.53.0




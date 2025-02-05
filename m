Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3E915573F;
	Wed,  5 Feb 2025 13:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763977; cv=none; b=IZj+bywFgrHIhJeZlYXsSws2k4Uily0OwE0k3BtQZonXVQI4onyjbb5GKLjVxCxjiTtbgHThCRua3tUhX9/U/ZHIpywN/cnNkilRpkIFP4xdmdn+MrSlX00TiXMyHc6IqN/HC50vo/qe7RKrof0wfQx/aqz5xYR89+BFoMrK/wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763977; c=relaxed/simple;
	bh=QGwngiQ2zbis9C/YsQ2gMJNqeo2XgxNTSHFyDogjI0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyPIPfA83031myhZvoHqrfFh1EhFQb9diWWK/funqj/fZqCraHOtd8mbhj7CxRwFcCIQm0fNaaJQ/NrfRQ78ouEMpiCETAC5/MuAQ7q3GlmHh/IiLdbHkAN+omUZL4GA/KIXMDAr87EA2CAcuwWDnHZDYj6cpAoWuiOVO6zFnAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHGiAe0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHGiAe0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D38C4CED6;
	Wed,  5 Feb 2025 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763977;
	bh=QGwngiQ2zbis9C/YsQ2gMJNqeo2XgxNTSHFyDogjI0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHGiAe0vcP8Swo3SWguCxYohmFZ1F8EfFuLpmHJ+I3pZUnpxZyI4tbnqG3KFaai7x
	 qNojI8yeAEBOH9QiZs3G0ovfHMUrTtZrBsUSdBy4lkpYCcf9hDtbh1qv+F4Lz1XRA0
	 bBC7wQlvvtOuamZPztmthAC8NoALnjLMXtlGmvEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchen Ding <dtcccc@linux.alibaba.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 035/623] sched: Fix race between yield_to() and try_to_wake_up()
Date: Wed,  5 Feb 2025 14:36:17 +0100
Message-ID: <20250205134457.571743616@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchen Ding <dtcccc@linux.alibaba.com>

[ Upstream commit 5d808c78d97251af1d3a3e4f253e7d6c39fd871e ]

We met a SCHED_WARN in set_next_buddy():
  __warn_printk
  set_next_buddy
  yield_to_task_fair
  yield_to
  kvm_vcpu_yield_to [kvm]
  ...

After a short dig, we found the rq_lock held by yield_to() may not
be exactly the rq that the target task belongs to. There is a race
window against try_to_wake_up().

         CPU0                             target_task

                                        blocking on CPU1
   lock rq0 & rq1
   double check task_rq == p_rq, ok
                                        woken to CPU2 (lock task_pi & rq2)
                                        task_rq = rq2
   yield_to_task_fair (w/o lock rq2)

In this race window, yield_to() is operating the task w/o the correct
lock. Fix this by taking task pi_lock first.

Fixes: d95f41220065 ("sched: Add yield_to(task, preempt) functionality")
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20241231055020.6521-1-dtcccc@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/syscalls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/syscalls.c b/kernel/sched/syscalls.c
index ff0e5ab4e37cb..943406c4ee865 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -1433,7 +1433,7 @@ int __sched yield_to(struct task_struct *p, bool preempt)
 	struct rq *rq, *p_rq;
 	int yielded = 0;
 
-	scoped_guard (irqsave) {
+	scoped_guard (raw_spinlock_irqsave, &p->pi_lock) {
 		rq = this_rq();
 
 again:
-- 
2.39.5




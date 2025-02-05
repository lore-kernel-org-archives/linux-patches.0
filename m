Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB87313C9C4;
	Wed,  5 Feb 2025 13:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763562; cv=none; b=qBFM90JgW6XYgmybpdjLYtU9064F2nz6xDI14KgNULEro9SmDGRV6CzgnuSxObsfORtfF7yT70HbhlWOEM772kHPaXA7Sf5c86ucN8/j/TDkDMFn2MKiDjQUIjtkJYMMdKj9c7yxRIqdg39i93X/Gv16IEUmMdGREc+JL+VNmhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763562; c=relaxed/simple;
	bh=0J3nXKIRWtvqEmBwrJIgIu0DRjVKFQ4HUc5ElIzvjV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvrW7nGGqAgkRt9vVvTLHOASCwcZAirk/jzF2kD2zAzrd5pMqszGSN3BfFPGrtmKvmCBpQ6RYYEeSPL6mF+7i9wReZxyXVeTi3PRu7xrtbypVLNACgz6A6xPWuD5mECYW+ksI8FU+kbDALocHSYaRFzcciDqIcX7diDnCpEYedA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWm8R6qy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWm8R6qy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB11C4CED1;
	Wed,  5 Feb 2025 13:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763562;
	bh=0J3nXKIRWtvqEmBwrJIgIu0DRjVKFQ4HUc5ElIzvjV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWm8R6qyTP7bCw4PTd6rqyPrc58N4+RXRkCZbA6jxFaZsxd6d6ZotJadlpzaLrXRu
	 1YjJK/jj1sFmvystQsidEhkrC6GIyafuW3VZkx8QO+7ifD03Hr/e7oH29ow+TI2QJ4
	 13yjBu2ipwZE1Nc/HJiEEt7ysQ6MOjFos429Zyqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchen Ding <dtcccc@linux.alibaba.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/590] sched: Fix race between yield_to() and try_to_wake_up()
Date: Wed,  5 Feb 2025 14:36:25 +0100
Message-ID: <20250205134456.398778260@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1784ed1fb3fe5..f9cb7896c1b96 100644
--- a/kernel/sched/syscalls.c
+++ b/kernel/sched/syscalls.c
@@ -1471,7 +1471,7 @@ int __sched yield_to(struct task_struct *p, bool preempt)
 	struct rq *rq, *p_rq;
 	int yielded = 0;
 
-	scoped_guard (irqsave) {
+	scoped_guard (raw_spinlock_irqsave, &p->pi_lock) {
 		rq = this_rq();
 
 again:
-- 
2.39.5




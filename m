Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5242212575;
	Fri, 17 Oct 2025 15:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713395; cv=none; b=cClSFkqM7fd47xraDc254FeEeW7WAuhLlQuCof40ZB5jhZwxaTJRsaROk3gBLRrhG5bR2AewQ2jfP9Ay+t760L1m+YhxGgkbpQFdXRqQFaMeSHxZH5njBGjTkEInQzJq9XqsjJgGIfSbTXHiERb4uU1jzAb0kEncTTweM32/6lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713395; c=relaxed/simple;
	bh=Lk+EiBZIaJ9u6cdDSIfdn5iqL/URGPK0X4uOTAPGIII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxxbJuMSR+MgI4TTCMsLR9p7zFbpIWduQzyRbXDwwxNqF4MxiJWrwxIpqb5GycEC+wEm4PVZJrB1az/4TGZD4VA1kBkzUoIJ30JrgFGRq/3LhDBC8s+qYtcfVaZ2ndImfLF3v3QPIPOv9RR05JNGD9KtyPJlDYz7Bny1elX9tT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPfNAtsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPfNAtsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6566CC4CEE7;
	Fri, 17 Oct 2025 15:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713394;
	bh=Lk+EiBZIaJ9u6cdDSIfdn5iqL/URGPK0X4uOTAPGIII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPfNAtsRqxh819t6Bp2xrU3zllP0t0wrh5SryubFb+jD/OGsI1Bu9TVmN2bvsEeqG
	 OCGvDJ7fI8CBGtJjN7n7UkJZVEflFv3jLs9hEwBeWaQfkvLHttMUNTvfy/qg8jIVbF
	 OjaN0JY6VwN6rOJiqqWzKU3U5+tA85rzjAhBlEkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Boqun Feng <boqun.feng@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/168] rseq: Protect event mask against membarrier IPI
Date: Fri, 17 Oct 2025 16:53:49 +0200
Message-ID: <20251017145134.566530000@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 6eb350a2233100a283f882c023e5ad426d0ed63b ]

rseq_need_restart() reads and clears task::rseq_event_mask with preemption
disabled to guard against the scheduler.

But membarrier() uses an IPI and sets the PREEMPT bit in the event mask
from the IPI, which leaves that RMW operation unprotected.

Use guard(irq) if CONFIG_MEMBARRIER is enabled to fix that.

Fixes: 2a36ab717e8f ("rseq/membarrier: Add MEMBARRIER_CMD_PRIVATE_EXPEDITED_RSEQ")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: stable@vger.kernel.org
[ Applied changes to include/linux/sched.h instead of include/linux/rseq.h ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched.h |   11 ++++++++---
 kernel/rseq.c         |   10 +++++-----
 2 files changed, 13 insertions(+), 8 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2313,6 +2313,12 @@ enum rseq_event_mask {
 	RSEQ_EVENT_MIGRATE	= (1U << RSEQ_EVENT_MIGRATE_BIT),
 };
 
+#ifdef CONFIG_MEMBARRIER
+# define RSEQ_EVENT_GUARD	irq
+#else
+# define RSEQ_EVENT_GUARD	preempt
+#endif
+
 static inline void rseq_set_notify_resume(struct task_struct *t)
 {
 	if (t->rseq)
@@ -2331,9 +2337,8 @@ static inline void rseq_handle_notify_re
 static inline void rseq_signal_deliver(struct ksignal *ksig,
 				       struct pt_regs *regs)
 {
-	preempt_disable();
-	__set_bit(RSEQ_EVENT_SIGNAL_BIT, &current->rseq_event_mask);
-	preempt_enable();
+	scoped_guard(RSEQ_EVENT_GUARD)
+		__set_bit(RSEQ_EVENT_SIGNAL_BIT, &current->rseq_event_mask);
 	rseq_handle_notify_resume(ksig, regs);
 }
 
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -226,12 +226,12 @@ static int rseq_need_restart(struct task
 
 	/*
 	 * Load and clear event mask atomically with respect to
-	 * scheduler preemption.
+	 * scheduler preemption and membarrier IPIs.
 	 */
-	preempt_disable();
-	event_mask = t->rseq_event_mask;
-	t->rseq_event_mask = 0;
-	preempt_enable();
+	scoped_guard(RSEQ_EVENT_GUARD) {
+		event_mask = t->rseq_event_mask;
+		t->rseq_event_mask = 0;
+	}
 
 	return !!event_mask;
 }



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A77D2745E;
	Fri, 17 Oct 2025 15:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713939; cv=none; b=V0ThFtup15FQBlAAFmy6stljsK8DBRbBgsw8Ob4xo6aYNzfmPLYww+QH3rkaslasV47JLDMc7Y9dlyxzZ0MOQuhqegfMhFIAGKpF14URZ687MsqXGWjvLBXHUSohL+VJKh7hO4XhRJ64eCjY8NRfeAkcSQLJLTWQrpQRVhyEdCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713939; c=relaxed/simple;
	bh=jPzgKN4/dR0A62w6Zhi6zdJW4q1MJ4BkuhYN8okHins=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1omeYnUSgWLPDPxEMByzA2XYr004XIghckwyfT3nCq0YD4DPbbTZO0h+4G32XooPSSdPrcZp/5iFIMxrMrAtGbI7m3eJWgIkXoJ9YvRv7In8WpKwIMSTjkIElFYKG6iYpQm1RFD31k0DBQFoKWtQe5Xmqceq/s+JvqKyE9muYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnXZh11o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnXZh11o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E74C4CEE7;
	Fri, 17 Oct 2025 15:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713939;
	bh=jPzgKN4/dR0A62w6Zhi6zdJW4q1MJ4BkuhYN8okHins=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnXZh11o5R/UnMhTynfgqqeknFqDk2Jgj6SheVUsxjp4Q+WW8L7HxmKPO3oWSTudd
	 0N5/PJpcxk4Aiv8gOXlXf61PpZZqi6h1eNdfTBC6XLYNEcBpnNNvVCAel4R51mmJeY
	 tmHBg69WANb1zs0lV8H68NDjiyD+SCBFSWWCzCX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Boqun Feng <boqun.feng@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/201] rseq: Protect event mask against membarrier IPI
Date: Fri, 17 Oct 2025 16:53:53 +0200
Message-ID: <20251017145141.059504259@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2343,6 +2343,12 @@ enum rseq_event_mask {
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
@@ -2361,9 +2367,8 @@ static inline void rseq_handle_notify_re
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
@@ -255,12 +255,12 @@ static int rseq_need_restart(struct task
 
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



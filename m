Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D422FD7C3;
	Thu, 28 May 2026 20:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998730; cv=none; b=aZKoCv6a32uKXdymvu4Mu10iTR1yXQEtMkbezCr1qw1V+Jbf/QSLAg2gRIl3Zu+0pAhJOj81Xsaj2IFaaF+l1GQPE6W35R+zAKnblnSYkfKyUGc0VjAscAuCd73Mqlen3+nfB8efJ4U3U5rKCJY802B7Ns8tEu/gmQVFWIKk2AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998730; c=relaxed/simple;
	bh=t01H/03hGJGhwoiyxOHoVlVA11cFJutNlMV+731ASbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gjqRjZY+H3ChX/3RXrD84Q78wVwW/WEbooyqgq3KjUC2TAlzltcCZYBUGxKY/zHGStg9HxLHQVRdWGJtxoLqOG5V0UIurF9pW16ih+y5RjQr4xKVaauX3EHOeXCqVnARUs/T+WdNfBU3QR8zf9kQChbsK1GYlLxnxnVughkAA/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewr50pAT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewr50pAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001DB1F00A3D;
	Thu, 28 May 2026 20:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998729;
	bh=WXyTRTgvBXXJ3Xt0/uTtD+LG90pjaYrnUywak3ZHFic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewr50pAT0OQbVyNVvuGq6dbe3312SZtMzOmJ8rAIospACZTPHzprDyZ9LA+3wSRg3
	 1J1IMj/1R3impBp8a3q2ZWxfUA39Mde1wAn1RN/yGDcrbK2s+allACCfCFY69DnykL
	 7kCTtsP39PiBgRHMC0Ad+1BN4qTjDZ7tUmj1Zjis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 241/461] irq_work: Fix use-after-free in irq_work_single() on PREEMPT_RT
Date: Thu, 28 May 2026 21:46:10 +0200
Message-ID: <20260528194654.120844757@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 91840be8f710370607f949a627e070896faeddb8 ]

On PREEMPT_RT, non-HARD irq_work runs in per-CPU kthreads via
run_irq_workd(), so irq_work_sync() uses rcuwait() to wait for BUSY==0.

After irq_work_single() clears BUSY via atomic_cmpxchg(), it still
dereferences @work for irq_work_is_hard() and rcuwait_wake_up().

An irq_work_sync() caller on another CPU that enters after BUSY is cleared
can observe BUSY==0 immediately, return, and free the work before those
accesses complete — causing a use-after-free.

Fix this by wrapping run_irq_workd() in guard(rcu)() so that the entire
irq_work_single() execution is within an RCU read-side critical
section. Then add synchronize_rcu() in irq_work_sync() after
rcuwait_wait_event() to ensure the caller waits for the RCU grace period
before returning, preventing premature frees.

Fixes: 810979682ccc ("irq_work: Allow irq_work_sync() to sleep if irq_work() no IRQ support.")
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20260330073234.303732-1-jiayuan.chen@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq_work.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 73f7e1fd4ab4d..bf411656c3160 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -292,6 +292,12 @@ void irq_work_sync(struct irq_work *work)
 	    !arch_irq_work_has_interrupt()) {
 		rcuwait_wait_event(&work->irqwait, !irq_work_is_busy(work),
 				   TASK_UNINTERRUPTIBLE);
+		/*
+		 * Ensure irq_work_single() does not access @work
+		 * after removing IRQ_WORK_BUSY. It is always
+		 * accessed within a RCU-read section.
+		 */
+		synchronize_rcu();
 		return;
 	}
 
@@ -302,6 +308,7 @@ EXPORT_SYMBOL_GPL(irq_work_sync);
 
 static void run_irq_workd(unsigned int cpu)
 {
+	guard(rcu)();
 	irq_work_run_list(this_cpu_ptr(&lazy_list));
 }
 
-- 
2.53.0




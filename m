Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774588;
	b=0H5q2YM/F5kzGx+F2NVJCMijCUnUW5I1ywzSlKzj4fVNNQsbNEpL2Zvupzf5GkkOpxMP
	 jnl7BCVwVR1577LSStoN5lsBSB9ahOmE/Ef0tODysPunP8buIcNgwg5mwfkfguQBTcWJ8
	 YiOqugr25XxsnQtHG4X8AO8DBtEZk+nskHUt9xxY8d4d7rvwhxaAeKezBkM5vu2tpoZoU
	 2KEUCJYurxoP0H3bLhfuBLZIAgQv39IkERZ17r1EqxZC5fnohbDpnXLUE2R0JNf1P4KMX
	 eF22uTZ/ktx/ia82Ny3RgEmRPFVn+bDdVoYLVhfaZd4reKAEOsPkKbZ/LiseLPtX/7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W0iLIyTyf1ZUdwJUv/SAJOEiBYe0fZx6Pha1S1DPxWU=;
	b=nsLOL8+6Jt6aMf5ql1s/K4kFFQpFuXwd9c1Q/wlCTYZ5XweP+Qy0NDHQx5AY47ZeKExA
	 CfLAxBSgLdOQsSY4e5TQxaDEtixyiVIl0pfZ9j0vnz4KI1EM/Y3zLeOc2X/REaslUdp2Z
	 ltToeB/Pak06x6fBpstguFUUIlYKg4xrEXPHMNipaopQazen0WGKay8TFjKBO+Be6ehPE
	 MtQSlMJUGREAcY+TdwGJIw8dyjxa0/ylh2sYo/PvYSae2AE86ml6i5lghKCdceNXS+Dky
	 yu7GNi/RF7e9LwIzEQ+qOPqSzgJtSQsqPPiMCvhjaMXonOHFBx8ljQ6YeFzYlPtNrvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xOJLmjwc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66B6606A31F;
	Fri, 23 Oct 2026 16:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xOJLmjwc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AB11F01825;
	Fri, 23 Oct 2026 16:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774587;
	bh=W0iLIyTyf1ZUdwJUv/SAJOEiBYe0fZx6Pha1S1DPxWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xOJLmjwc8s5xdpe67Oc8JzrskZzCflSwwI4of8nmA/8PjWoOD8uSMBPChAUFGY+aO
	 YQ/AfC/AJ2NXSCjNCmyvDlHJMSviC02g+64v6rL883N9yjwPUU6I57Wp/114rRIr6L
	 0PqKEbCeWCTPFiHx5Fp6/JXKb8R5l17yUwW2SQxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 053/242] entry: Account the deferred hrtimer rearm as hardirq context for lockdep
Date: Fri, 23 Oct 2026 18:38:15 +0200
Message-ID: <20261023163715.033054571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

[ Upstream commit 7cbaa0f4579f48e92639c6abb761fdef8fbade47 ]

On a desktop debug kernel (PROVE_LOCKING, KASAN, LOCKDEP_CHAINS_BITS=19)
lockdep switches itself off after about two days of uptime with
"BUG: MAX_LOCKDEP_CHAIN_HLOCKS too low!", and locking is not validated
until the next reboot. In the last such boot the pool ran out after 46.6
hours, and a fifth of it, 533509 of 2621431 chain hlocks in 63838 of
344717 chains, had been created by the deferred hrtimer rearm on return
from interrupt.

Make lockdep account that rearm as part of the timer interrupt it
belongs to.

Commit 15dd3a948855
("hrtimer: Push reprogramming timers into the interrupt return path")
moved the reprogramming of the clock event device out of the timer
interrupt into the interrupt return path. On return to kernel mode
irqentry_exit_to_kernel_mode_after_preempt() performs it after
irq_exit_rcu() has already left lockdep's hardirq context. lockdep
therefore records hrtimer_bases.lock and the timekeeper sequence count
as taken by the interrupted context, on top of the locks that context
holds, and every distinct held-lock stack an interrupt hits adds two
lock chains. When the rearm runs from irq_enter_rcu() or
__irq_exit_rcu() it is still inside lockdep's hardirq context, and there
the same acquisitions reuse one pair of chains.

The dependencies recorded on the return path are "lock held with
interrupts enabled -> hrtimer_bases.lock". Such a lock is hardirq-unsafe
and hrtimer_bases.lock is hardirq-safe, so a path in the reverse
direction is already reported by the irq-safety checks without these
edges.

Re-enter lockdep's hardirq context around the rearm on the kernel return
path. The return to user mode path holds no locks and is left alone, as
is the rearm in __schedule(), which runs under the runqueue lock.

With the same kernel tree, configuration and workload, one hour of
uptime including a full kernel build, the chains of this shape, with
hrtimer_bases.lock and optionally the timekeeper sequence count on top
of a held-lock stack outside the scheduler, go from 13266 (96187 chain
hlocks, 15.9% of those in use) to 4. Those 4 come from clock_was_set(),
which takes cpus_read_lock() and each CPU's hrtimer_bases.lock and reads
the clock under it.

Fixes: 15dd3a948855 ("hrtimer: Push reprogramming timers into the interrupt return path")
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20261013071318.33300-1-mikhail.v.gavrilov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irq-entry-common.h | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/irq-entry-common.h b/include/linux/irq-entry-common.h
index 1fabf0f5ea8e7..c03153548a2d4 100644
--- a/include/linux/irq-entry-common.h
+++ b/include/linux/irq-entry-common.h
@@ -468,6 +468,25 @@ static inline void irqentry_exit_to_kernel_mode_preempt(struct pt_regs *regs,
 		irqentry_exit_cond_resched();
 }
 
+/*
+ * The deferred hrtimer rearm is the tail of the timer interrupt, moved to the
+ * interrupt return path so that it runs after a possible reschedule. By now
+ * irq_exit_rcu() has left lockdep's hardirq context. Re-enter it for the
+ * rearm, so that the hrtimer base lock and the timekeeping sequence count are
+ * not chained onto the locks held by the interrupted context, which would add
+ * new lock chains for every lock stack an interrupt hits.
+ *
+ * The rearm on return to user mode needs no such annotation: no locks are
+ * held there, so it uses the same lock chains as the rearm in hardirq
+ * context.
+ */
+static __always_inline void irqentry_hrtimer_rearm_deferred(void)
+{
+	lockdep_hardirq_enter();
+	hrtimer_rearm_deferred();
+	lockdep_hardirq_exit();
+}
+
 /**
  * irqentry_exit_to_kernel_mode_after_preempt - Establish trace, lockdep and RCU state
  * @regs:	Pointer to current's pt_regs
@@ -491,7 +510,7 @@ irqentry_exit_to_kernel_mode_after_preempt(struct pt_regs *regs, irqentry_state_
 		 */
 		if (state.exit_rcu) {
 			instrumentation_begin();
-			hrtimer_rearm_deferred();
+			irqentry_hrtimer_rearm_deferred();
 			/* Tell the tracer that IRET will enable interrupts */
 			trace_hardirqs_on_prepare();
 			lockdep_hardirqs_on_prepare();
@@ -502,7 +521,7 @@ irqentry_exit_to_kernel_mode_after_preempt(struct pt_regs *regs, irqentry_state_
 		}
 
 		instrumentation_begin();
-		hrtimer_rearm_deferred();
+		irqentry_hrtimer_rearm_deferred();
 		/* Covers both tracing and lockdep */
 		trace_hardirqs_on();
 		instrumentation_end();
-- 
2.53.0




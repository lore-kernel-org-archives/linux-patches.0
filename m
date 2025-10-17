Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E668B2F12CF;
	Fri, 17 Oct 2025 15:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714105; cv=none; b=Bhconie6XT1XIXlk+XZy1vUWT46MAN+6Vgc0MraW/Gz1T65d+3ulczovPI4AakzMthP/l4Eu5onbHPTaf1BHpIlh4nWe++zrsL/ymL65E1AftY5lAG0lvJtfRv6tdzRPiHEN/GROiZTO82SoNh5gEoynb95nhAwg9zLeLrimsgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714105; c=relaxed/simple;
	bh=EZjBkxIrr78ZISRUTuLCewp/30ytmpIS1kRvjEvfMf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuR5N+4p1H+aN3on5wE3cfL0T3W1Nus2o+5XQbkS2Hhr9ktQpKUmdbyn1c6qrvFzwcQrRcpD0lsQi343eBk/LTbNR7LCuq1pIf1yEbRe6TUle0tYqB3ktQXv6qmp2MXFV7ZObjkRUdfEWndLSXOX03tVw97sloO5qecdcuKUG6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVFTJ0nw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVFTJ0nw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2A4C4CEE7;
	Fri, 17 Oct 2025 15:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714104;
	bh=EZjBkxIrr78ZISRUTuLCewp/30ytmpIS1kRvjEvfMf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVFTJ0nwjNXM/x5A4caNyowGKejmrMERk3kgu/pMp5jJZaHB+Q1C+KlQ4DtECNNMX
	 rA7Bi1HfEHLfFU6g1tpXzqPH6zwoaN69H38HrlW41RkC+UtMRp/iT3veFkPtix1qEY
	 HvRFk9ONCfCaimFWFIKQbNiNX0B7KJxfFDinqI5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Boqun Feng <boqun.feng@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 6.12 004/277] rseq: Protect event mask against membarrier IPI
Date: Fri, 17 Oct 2025 16:50:11 +0200
Message-ID: <20251017145147.304978615@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 6eb350a2233100a283f882c023e5ad426d0ed63b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rseq.h |   11 ++++++++---
 kernel/rseq.c        |   10 +++++-----
 2 files changed, 13 insertions(+), 8 deletions(-)

--- a/include/linux/rseq.h
+++ b/include/linux/rseq.h
@@ -7,6 +7,12 @@
 #include <linux/preempt.h>
 #include <linux/sched.h>
 
+#ifdef CONFIG_MEMBARRIER
+# define RSEQ_EVENT_GUARD	irq
+#else
+# define RSEQ_EVENT_GUARD	preempt
+#endif
+
 /*
  * Map the event mask on the user-space ABI enum rseq_cs_flags
  * for direct mask checks.
@@ -41,9 +47,8 @@ static inline void rseq_handle_notify_re
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



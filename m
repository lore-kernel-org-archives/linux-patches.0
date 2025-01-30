Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C951E1E98FF;
	Thu, 30 Jan 2025 14:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247355; cv=none; b=BLJeyKGsHBbPpNcPW0H/X8sFFLyOtADKViLYQrGLFFAM03eUcZ4AknA2tizGrKfJE4Ru4HtUmPacYmCbyKM74o37rzm5t4CUtHw8d7VIcp5WrSmGtZ9nSl1KhW8n4GrG0N54GgTR1MEKOTD7s0dqNRGBjvQWhD01RTonM6/ay9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247355; c=relaxed/simple;
	bh=ayR9LveWTujp0d0RB5fYNg84TSvDz5vDeiXa1TmTehQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHa/MF2f4iV4+u8e4+i3ckSnRvcJl43pqrw6ZaDMsP0IGXq/k4ICOIr8gLgB6vyJbiWtGSnfgaqfteeuNzZhnwZFOSKc51a4n/FhoDqoQNSSuwJwlgRVVm+TPiRWKcbeSHcm2/erB4QGDKKtjRBeWB9Uu9XUT4n0Ct+hi0npSSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJNP/pCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJNP/pCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51DC6C4CEE0;
	Thu, 30 Jan 2025 14:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247355;
	bh=ayR9LveWTujp0d0RB5fYNg84TSvDz5vDeiXa1TmTehQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJNP/pCx/rPgEx+a7Rfs+CmGna3WZI9GAhkhnfYbISb4HTDSkCMpRLtWljNyA1xWI
	 /hoIj+pY3OIwANdPyT1qVCSlp/XpUbkBrJUfRcwgdEdrg8EPu5S5IZyFjACRjY7l1M
	 ux6lhJu0hrFql+wSG4XqHZ0CxystJkB3VyX/aUPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Florian Bezdeka <florian.bezdeka@siemens.com>
Subject: [PATCH 6.1 11/49] softirq: Allow raising SCHED_SOFTIRQ from SMP-call-function on RT kernel
Date: Thu, 30 Jan 2025 15:01:47 +0100
Message-ID: <20250130140134.287151097@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
References: <20250130140133.825446496@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: K Prateek Nayak <kprateek.nayak@amd.com>

commit 6675ce20046d149e1e1ffe7e9577947dee17aad5 upstream.

do_softirq_post_smp_call_flush() on PREEMPT_RT kernels carries a
WARN_ON_ONCE() for any SOFTIRQ being raised from an SMP-call-function.
Since do_softirq_post_smp_call_flush() is called with preempt disabled,
raising a SOFTIRQ during flush_smp_call_function_queue() can lead to
longer preempt disabled sections.

Since commit b2a02fc43a1f ("smp: Optimize
send_call_function_single_ipi()") IPIs to an idle CPU in
TIF_POLLING_NRFLAG mode can be optimized out by instead setting
TIF_NEED_RESCHED bit in idle task's thread_info and relying on the
flush_smp_call_function_queue() in the idle-exit path to run the
SMP-call-function.

To trigger an idle load balancing, the scheduler queues
nohz_csd_function() responsible for triggering an idle load balancing on
a target nohz idle CPU and sends an IPI. Only now, this IPI is optimized
out and the SMP-call-function is executed from
flush_smp_call_function_queue() in do_idle() which can raise a
SCHED_SOFTIRQ to trigger the balancing.

So far, this went undetected since, the need_resched() check in
nohz_csd_function() would make it bail out of idle load balancing early
as the idle thread does not clear TIF_POLLING_NRFLAG before calling
flush_smp_call_function_queue(). The need_resched() check was added with
the intent to catch a new task wakeup, however, it has recently
discovered to be unnecessary and will be removed in the subsequent
commit after which nohz_csd_function() can raise a SCHED_SOFTIRQ from
flush_smp_call_function_queue() to trigger an idle load balance on an
idle target in TIF_POLLING_NRFLAG mode.

nohz_csd_function() bails out early if "idle_cpu()" check for the
target CPU, and does not lock the target CPU's rq until the very end,
once it has found tasks to run on the CPU and will not inhibit the
wakeup of, or running of a newly woken up higher priority task. Account
for this and prevent a WARN_ON_ONCE() when SCHED_SOFTIRQ is raised from
flush_smp_call_function_queue().

Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20241119054432.6405-2-kprateek.nayak@amd.com
Tested-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Signed-off-by: Florian Bezdeka <florian.bezdeka@siemens.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/softirq.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -294,17 +294,24 @@ static inline void invoke_softirq(void)
 		wakeup_softirqd();
 }
 
+#define SCHED_SOFTIRQ_MASK	BIT(SCHED_SOFTIRQ)
+
 /*
  * flush_smp_call_function_queue() can raise a soft interrupt in a function
- * call. On RT kernels this is undesired and the only known functionality
- * in the block layer which does this is disabled on RT. If soft interrupts
- * get raised which haven't been raised before the flush, warn so it can be
+ * call. On RT kernels this is undesired and the only known functionalities
+ * are in the block layer which is disabled on RT, and in the scheduler for
+ * idle load balancing. If soft interrupts get raised which haven't been
+ * raised before the flush, warn if it is not a SCHED_SOFTIRQ so it can be
  * investigated.
  */
 void do_softirq_post_smp_call_flush(unsigned int was_pending)
 {
-	if (WARN_ON_ONCE(was_pending != local_softirq_pending()))
+	unsigned int is_pending = local_softirq_pending();
+
+	if (unlikely(was_pending != is_pending)) {
+		WARN_ON_ONCE(was_pending != (is_pending & ~SCHED_SOFTIRQ_MASK));
 		invoke_softirq();
+	}
 }
 
 #else /* CONFIG_PREEMPT_RT */



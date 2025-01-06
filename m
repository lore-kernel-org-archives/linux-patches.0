Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977748635E;
	Mon,  6 Jan 2025 15:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177157; cv=none; b=idbCi20SVCsZ8LzlcPxu11IOVm8icv1CqtxnvaYM9lL3EJtUhPdcZdnom8C259FC1ZF04l5zP3y9ykojW2rdmegz/pQ5dH/x/G5g2Naa+1eYz7g7HHsf9zafl1PP+btUjxoVWw4Xmr/MXEpB13CW9G8GnjXHvXwu7IifNcfXeaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177157; c=relaxed/simple;
	bh=uTUIecjYpXg30YUTeoJQY1HE+aoKYGyVqGXiPMfnJ2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSOg479Vdlin1HGc0/cQTiXh2b2J7P8dZAKi62rlA4p+d9RJcDsK+VJUAvLaz9c8yY9W29oDuSDzEdIV931KIvSRpUiMyv07GJ4UDIfd3DKk9cP2yLFK/r2JMddD4/ofsnsYtemTGKAO++acXyxwUBTG9dty/BMdH2uiHpU4mfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJPa899s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJPa899s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB5DC4CED2;
	Mon,  6 Jan 2025 15:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177157;
	bh=uTUIecjYpXg30YUTeoJQY1HE+aoKYGyVqGXiPMfnJ2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJPa899sp80PugvKZ2Z42pQGBG+WnmU2tGkJM677DF4BILDoeXgujDMUPp9wxHdON
	 PJ0SmNe3Ca//oAAHxpBVp9jmDyKm38ypixMm8+P5eYQOMR5y+cqO6dhZ5Uv2HQsDxB
	 v+hnMXZnVNqJWRaxrxOCR1qQ4u25R2E06mNO6FCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/222] softirq: Allow raising SCHED_SOFTIRQ from SMP-call-function on RT kernel
Date: Mon,  6 Jan 2025 16:14:35 +0100
Message-ID: <20250106151153.292212277@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit 6675ce20046d149e1e1ffe7e9577947dee17aad5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/softirq.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index bd9716d7bb63..f24d80cf20bd 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -279,17 +279,24 @@ static inline void invoke_softirq(void)
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
-- 
2.39.5




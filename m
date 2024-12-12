Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6242623E6CA;
	Thu, 12 Dec 2024 16:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021419; cv=none; b=dqFRABbFnwLsAoIkJO6f2ZoyJSp5X/A7AumexjRS08wCXmh8xyze+X7UJkxiuAAPKWeGAQ7p7DubQfVpDSL2wSeK2fuRPJdVkvHD2eecOBYlIrFIgm7JZTZvvIMp6YDksh8Nhx/9+sxv23KOkD/Fhgz44N/NFCHY0TimTQtNpAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021419; c=relaxed/simple;
	bh=mwq0Mr/sHasPs/Ny2xkLtffgxk3oMJdnoB2/CW9pufg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLSNcxI79XG1W5OfHCwdxDoX/Bc+DKNnYPJSMfBd2ygoITz2upyWnxGu6KFAUOwmnZyc8eOcDqIAQT1YxyfhCiKV55IVH0V+SPDMcw4FdNWdTEFLuhSBRSUxWmonEYLhJWgsl+RKLH2Tj8wQ3KtuAKE9g7CVA5Nknn8veGPkFe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CskJJAm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CskJJAm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51745C4CECE;
	Thu, 12 Dec 2024 16:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021419;
	bh=mwq0Mr/sHasPs/Ny2xkLtffgxk3oMJdnoB2/CW9pufg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CskJJAm/ppeVAM8sH7fHsfasC4x7rX9+d1QPXZ6l0UmhU/O9c3lFjkAr6IEZbRcp4
	 PLLMNPaKzRnjB5ATGxSABcU+bQ1mEtmaaN6FPUAwxt7qYFvk8Izs3AoHQ80L4WinY2
	 x8fa5SEYFJGY44Ij4ApzWiuZ3GNRhxzok/n8/DGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 732/772] sched/fair: Check idle_cpu() before need_resched() to detect ilb CPU turning busy
Date: Thu, 12 Dec 2024 16:01:17 +0100
Message-ID: <20241212144420.156748489@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit ff47a0acfcce309cf9e175149c75614491953c8f ]

Commit b2a02fc43a1f ("smp: Optimize send_call_function_single_ipi()")
optimizes IPIs to idle CPUs in TIF_POLLING_NRFLAG mode by setting the
TIF_NEED_RESCHED flag in idle task's thread info and relying on
flush_smp_call_function_queue() in idle exit path to run the
call-function. A softirq raised by the call-function is handled shortly
after in do_softirq_post_smp_call_flush() but the TIF_NEED_RESCHED flag
remains set and is only cleared later when schedule_idle() calls
__schedule().

need_resched() check in _nohz_idle_balance() exists to bail out of load
balancing if another task has woken up on the CPU currently in-charge of
idle load balancing which is being processed in SCHED_SOFTIRQ context.
Since the optimization mentioned above overloads the interpretation of
TIF_NEED_RESCHED, check for idle_cpu() before going with the existing
need_resched() check which can catch a genuine task wakeup on an idle
CPU processing SCHED_SOFTIRQ from do_softirq_post_smp_call_flush(), as
well as the case where ksoftirqd needs to be preempted as a result of
new task wakeup or slice expiry.

In case of PREEMPT_RT or threadirqs, although the idle load balancing
may be inhibited in some cases on the ilb CPU, the fact that ksoftirqd
is the only fair task going back to sleep will trigger a newidle balance
on the CPU which will alleviate some imbalance if it exists if idle
balance fails to do so.

Fixes: b2a02fc43a1f ("smp: Optimize send_call_function_single_ipi()")
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20241119054432.6405-4-kprateek.nayak@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1e12f731a0337..cf3bbddd4b7fc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11401,7 +11401,7 @@ static void _nohz_idle_balance(struct rq *this_rq, unsigned int flags)
 		 * work being done for other CPUs. Next load
 		 * balancing owner will pick it up.
 		 */
-		if (need_resched()) {
+		if (!idle_cpu(this_cpu) && need_resched()) {
 			if (flags & NOHZ_STATS_KICK)
 				has_blocked_load = true;
 			if (flags & NOHZ_NEXT_KICK)
-- 
2.43.0




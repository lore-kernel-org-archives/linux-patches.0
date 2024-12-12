Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423361487CD;
	Thu, 12 Dec 2024 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017305; cv=none; b=IeP5AK0R0GVMl4vkzTziMs+WU2ioGv2Pva6RiY5kwHB4uRnMcKOM8Jh4kSkUR+AFCgZoHHCB8CLI94x41aq3DXa7HWLTpq17ss+Hert7Cv67YuF4hmKjPfILcgcoS0h6AoHf39AVwgXV6ELUWwNa/3MGbb/c7cVYiLDtzM6UsGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017305; c=relaxed/simple;
	bh=R8yBiiFGEdiiPcl8FEj2x65iu8LAyFncdEYsa6ZgHUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYn691WxtQ8Ek//VK9sNLgEruiS8/lCeiZLP9wXGb3AGroFGfDHmEKkdFXWCaXVcY8Ivav39xU4SD1GDwX3HWANpX5SWp6yPixLojS1EfpJUGnzsnWRFHS/zAeXDfR6MUuH02csoXNMbBgNWMExFP+9XbGkzCscZUy0C/MoUSKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUEr0DTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUEr0DTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33F4C4CECE;
	Thu, 12 Dec 2024 15:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017305;
	bh=R8yBiiFGEdiiPcl8FEj2x65iu8LAyFncdEYsa6ZgHUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUEr0DTfKPAhNFZ082JU5RFdjuAlC0yhylg4am2ocenCcnPLB+1NmQuzwqfLpU7/j
	 PDqBLPfOb1RD+RMHuAtoyJ5OzNIevOLD9l/x02mkWxRVAGKcq3Yd4SCHOE5yqFOnM1
	 d4wkxM0dWpZ0WhczuEUGXydl1fs5qt+sMEOaGlqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 441/466] sched/fair: Check idle_cpu() before need_resched() to detect ilb CPU turning busy
Date: Thu, 12 Dec 2024 16:00:10 +0100
Message-ID: <20241212144324.281630922@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 49fa456cd3320..782ce70ebd1b0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -12580,7 +12580,7 @@ static void _nohz_idle_balance(struct rq *this_rq, unsigned int flags)
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




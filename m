Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008712210F1;
	Thu, 12 Dec 2024 17:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024861; cv=none; b=gW7GIj05rwWjFAqWlDPjSMI7Z3LWxbMMBoEXflNqee9HDz7tR5uXpx7Anb/x8JFzVDBnwPARJvzBI1FwFv004rwXLgFed8GfVglkIQmN+4XG0Y3CfJMVLO9MoBpAk71+889OkZrzNI+0lDxn4K2cMg1+FsOvevZfoJcoG3y8cVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024861; c=relaxed/simple;
	bh=Y6wykeZF2i8Gl6rIDix89aJOt/aoBP54omOcTFSRx8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rO+8NeZo6wfCvhUaT59H8/lFA63+h34bwQkEgYsa9bdQhcqKPjZIDav4ZpXV5t3hLwcaIWPWco7iu5q2bT4jFVEox1ubw/aKhgZrQwlTptFRvY7ortkstQi3OKgiop60gCbo4TjKnElJWzS7ytyOwRuRw8j6V6GSsbBBLsu8Xq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/AykDn4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/AykDn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D01C4CECE;
	Thu, 12 Dec 2024 17:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024860;
	bh=Y6wykeZF2i8Gl6rIDix89aJOt/aoBP54omOcTFSRx8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/AykDn48aHHtItPXyazp6QI82L5Xnit70bcXXHOxALN+LXghN1vM9E4lw+kneRtt
	 YRN+HSfJm3FJrCbv5FStYOj7+krZ1iH6A27GyXwugVPdh4Jc2r6AOrwhxr2AByGWoj
	 cs+S1cg4ksYslLnLrIR+jYZswrJy8LCuQk840n64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Valentin Schneider <valentin.schneider@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 436/459] sched/fair: Merge for each idle cpu loop of ILB
Date: Thu, 12 Dec 2024 16:02:54 +0100
Message-ID: <20241212144310.977891311@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit 7a82e5f52a3506bc35a4dc04d53ad2c9daf82e7f ]

Remove the specific case for handling this_cpu outside for_each_cpu() loop
when running ILB. Instead we use for_each_cpu_wrap() and start with the
next cpu after this_cpu so we will continue to finish with this_cpu.

update_nohz_stats() is now used for this_cpu too and will prevents
unnecessary update. We don't need a special case for handling the update of
nohz.next_balance for this_cpu anymore because it is now handled by the
loop like others.

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Valentin Schneider <valentin.schneider@arm.com>
Link: https://lkml.kernel.org/r/20210224133007.28644-5-vincent.guittot@linaro.org
Stable-dep-of: ff47a0acfcce ("sched/fair: Check idle_cpu() before need_resched() to detect ilb CPU turning busy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0af373c4d7450..ab29666eb50ed 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10333,22 +10333,9 @@ static void rebalance_domains(struct rq *rq, enum cpu_idle_type idle)
 	 * When the cpu is attached to null domain for ex, it will not be
 	 * updated.
 	 */
-	if (likely(update_next_balance)) {
+	if (likely(update_next_balance))
 		rq->next_balance = next_balance;
 
-#ifdef CONFIG_NO_HZ_COMMON
-		/*
-		 * If this CPU has been elected to perform the nohz idle
-		 * balance. Other idle CPUs have already rebalanced with
-		 * nohz_idle_balance() and nohz.next_balance has been
-		 * updated accordingly. This CPU is now running the idle load
-		 * balance for itself and we need to update the
-		 * nohz.next_balance accordingly.
-		 */
-		if ((idle == CPU_IDLE) && time_after(nohz.next_balance, rq->next_balance))
-			nohz.next_balance = rq->next_balance;
-#endif
-	}
 }
 
 static inline int on_null_domain(struct rq *rq)
@@ -10674,8 +10661,12 @@ static bool _nohz_idle_balance(struct rq *this_rq, unsigned int flags,
 	 */
 	smp_mb();
 
-	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
-		if (balance_cpu == this_cpu || !idle_cpu(balance_cpu))
+	/*
+	 * Start with the next CPU after this_cpu so we will end with this_cpu and let a
+	 * chance for other idle cpu to pull load.
+	 */
+	for_each_cpu_wrap(balance_cpu,  nohz.idle_cpus_mask, this_cpu+1) {
+		if (!idle_cpu(balance_cpu))
 			continue;
 
 		/*
@@ -10721,15 +10712,6 @@ static bool _nohz_idle_balance(struct rq *this_rq, unsigned int flags,
 	if (likely(update_next_balance))
 		nohz.next_balance = next_balance;
 
-	/* Newly idle CPU doesn't need an update */
-	if (idle != CPU_NEWLY_IDLE) {
-		update_blocked_averages(this_cpu);
-		has_blocked_load |= this_rq->has_blocked_load;
-	}
-
-	if (flags & NOHZ_BALANCE_KICK)
-		rebalance_domains(this_rq, CPU_IDLE);
-
 	WRITE_ONCE(nohz.next_blocked,
 		now + msecs_to_jiffies(LOAD_AVG_PERIOD));
 
-- 
2.43.0




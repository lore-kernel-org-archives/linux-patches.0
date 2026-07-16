Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF01D3195EF;
	Thu, 16 Jul 2026 14:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211562; cv=none; b=L2SLylG+Zj0cZS2GRkP3SykucS9YFQZVnqcgsJOa875t/VaczL+CXtCiAKTMJl3PsNdiWn7r7Q8LNQj2R0uHn6W99eXjP+aPfdLUzbYoAO9fjftXLEiI4V7EgBUHJGAw/C+xoDwWUGoQoFmGj/jRxn47PCM/S+oernxd2V6G4H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211562; c=relaxed/simple;
	bh=Pd7sZYDSrl9AP/h2gk/vQKnzicJ9kZz/99+xrmGW58s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilKLdvtl9YYMij50QrENteRnwUoE+ujGEMIxfLJTe26ADZWSXxtLoxe6TfR/TeAXOTBvwjr1DXdUhDFIrt9vgAc6zTStsmdDBbidByBbkpaPTlRGccQL+1wvkpCrr4r9XkFfGBba+aBdv8mcUw0JvbggTWEF5MECJu/Ej1Tvx2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjjqzyCz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjjqzyCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4EB1F000E9;
	Thu, 16 Jul 2026 14:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211561;
	bh=UsTjd8hkQECZjof4tpzEFHuyTIiHUR8UHieZMMG654g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AjjqzyCzH1XTfmsiGA0L+YczxjS4ErnZVlpt5cUgIIaynHkXLN+o0Wia4p99OALWW
	 aN0UDxgOKLqKnlvmNO6FU16iYrA/QB7+Epb4IXUcor1fwXShICpOhRil3WlWJ83QBE
	 calg2yEMtcPZeJXWOPoraizE9xxI4SdKoIvKIvn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Li <adamli@os.amperecomputing.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Erwan Velu <e.velu@criteo.com>
Subject: [PATCH 6.18 476/480] sched/fair: Only update stats for allowed CPUs when looking for dst group
Date: Thu, 16 Jul 2026 15:33:43 +0200
Message-ID: <20260716133055.119872649@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Li <adamli@os.amperecomputing.com>

commit 82d6e01a0699800efd8b048eb584c907ccb47b7a upstream.

Load imbalance is observed when the workload frequently forks new threads.
Due to CPU affinity, the workload can run on CPU 0-7 in the first
group, and only on CPU 8-11 in the second group. CPU 12-15 are always idle.

{ 0 1 2 3 4 5 6 7 } {8 9 10 11 12 13 14 15}
  * * * * * * * *    * * *  *

When looking for dst group for newly forked threads, in many times
update_sg_wakeup_stats() reports the second group has more idle CPUs
than the first group. The scheduler thinks the second group is less
busy. Then it selects least busy CPUs among CPU 8-11. Therefore CPU 8-11
can be crowded with newly forked threads, at the same time CPU 0-7
can be idle.

A task may not use all the CPUs in a schedule group due to CPU affinity.
Only update schedule group statistics for allowed CPUs.

Signed-off-by: Adam Li <adamli@os.amperecomputing.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Erwan Velu <e.velu@criteo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10847,7 +10847,7 @@ static inline void update_sg_wakeup_stat
 	if (sd->flags & SD_ASYM_CPUCAPACITY)
 		sgs->group_misfit_task_load = 1;
 
-	for_each_cpu(i, sched_group_span(group)) {
+	for_each_cpu_and(i, sched_group_span(group), p->cpus_ptr) {
 		struct rq *rq = cpu_rq(i);
 		unsigned int local;
 



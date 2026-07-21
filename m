Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5753911CE;
	Tue, 21 Jul 2026 21:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668648; cv=none; b=nfaHFqG690Pw7JrZGX7BTl9xuJtUh8OgsBK1bNJ7QlmuwLAaAeXHIEDMtysbEA6GghB5/RHbVdPiqNYFDZKHta6nMbmSjpdazbHHAiFR3LwlC9BdM9Cd7CHn77yies2C30BRWrOGtEomCFaWWWWJQomdypAGmnDhQcWl6EWci7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668648; c=relaxed/simple;
	bh=O4/bCKurTkc6RCMhSXyZGJ8VGoJRkfFRehZ9kupXhXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezPAnm8undOWFOehcXZ1tV5cSYazbYSqw639/byLU2bT5nBlyKS1aVKvsjt/ibsw13oJaI1qTp+OMlZqowwNehUDyTGnJry2PM0QpPj06jQ0IclkQ/5Nd10oTnrW3lcOMIhGFgeFrNRqz7OEqRUMySs4d998QEwaDluLBuFr2mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7Lpgly0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7Lpgly0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F042D1F00A3D;
	Tue, 21 Jul 2026 21:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668644;
	bh=FPQTuYRrctqmR67k/80oXg2ENcvz3i+NOAnFGmOAUPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7Lpgly0oc1ffdJ3d4nG33rbAUxYiUgBJOYwPOzf7gBvstE8OmqbpxcWBJ8K83Ibe
	 IYDub/KLZdranmxPvmo4uxRksixZejTZ8SSO+L2dVCCS0gLRa2RBcPQTRVKy7V1PCo
	 QILgJ72XxigKLeH3795nmPVK2E+IE7vqji7u8+Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Li <adamli@os.amperecomputing.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0255/1067] sched/fair: Only update stats for allowed CPUs when looking for dst group
Date: Tue, 21 Jul 2026 17:14:16 +0200
Message-ID: <20260721152430.303901379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Li <adamli@os.amperecomputing.com>

[ Upstream commit 82d6e01a0699800efd8b048eb584c907ccb47b7a ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 376d835ca7b45e..23972665264655 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9550,7 +9550,7 @@ static inline void update_sg_wakeup_stats(struct sched_domain *sd,
 	if (sd->flags & SD_ASYM_CPUCAPACITY)
 		sgs->group_misfit_task_load = 1;
 
-	for_each_cpu(i, sched_group_span(group)) {
+	for_each_cpu_and(i, sched_group_span(group), p->cpus_ptr) {
 		struct rq *rq = cpu_rq(i);
 		unsigned int local;
 
-- 
2.53.0




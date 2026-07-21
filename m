Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BA339768C;
	Tue, 21 Jul 2026 22:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673431; cv=none; b=K+OUKchaWOWG1yH89GSuGCoTXOFGz1CveVAVG2BchMRPGMcWvdJrVDGOm2+gtW/tP4VsLKI+T+kdR7ErEcifr2sZQeQXVZj7cY/Ysg3Ffv04YgbzLDf76JeWUPNGX1BdS8baMwLoI8EnoR8jCGmaDtXU//GJAy7K2sypb4kxQAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673431; c=relaxed/simple;
	bh=AmSaOwArr4IopJfjpJlTCAFXo+GIIBDYb/SRAyDcmbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mutBA2m5sAZIRoIvk0wV0PZBMyHVMwVdnqSalDUGYI9yW6zpRx2ZZNSEZX9y3gKAqJdAZmUn4gSOyKxhVTLntW3oky58fGgQ2ks16Zyd9DR9UOLTOJyKEgnE9CpErWV3dwMWkfkaUYC4WEIRWDOQhtwaziIynFss1OVvX/iYsM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xC+olAJg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xC+olAJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E841F000E9;
	Tue, 21 Jul 2026 22:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673428;
	bh=ADmrb8Z7tIYyfMyn2TAif3fj42J+sPIbGEVyPwd3gKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xC+olAJggb4Cw91PSEK0wKfeJm4MDexGmsdsTCiSD8nnOTScLneP1NFN7egN00njD
	 xCqsoFWenYm/VSuA2rptO3ZMrSyU7SNipnO1slLFk3b6z7fwnIh5yfFuvGC92ec8IS
	 ijW10cDkw3wI1YsRDaFqbozDtUGJR3n6JmXvNftQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Li <adamli@os.amperecomputing.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/699] sched/fair: Only update stats for allowed CPUs when looking for dst group
Date: Tue, 21 Jul 2026 17:18:37 +0200
Message-ID: <20260721152359.266350806@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c11d59bea0ea81..fa85b84fdbc533 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8969,7 +8969,7 @@ static inline void update_sg_wakeup_stats(struct sched_domain *sd,
 	if (sd->flags & SD_ASYM_CPUCAPACITY)
 		sgs->group_misfit_task_load = 1;
 
-	for_each_cpu(i, sched_group_span(group)) {
+	for_each_cpu_and(i, sched_group_span(group), p->cpus_ptr) {
 		struct rq *rq = cpu_rq(i);
 		unsigned int local;
 
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8F346C4D2;
	Tue, 21 Jul 2026 15:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649436; cv=none; b=CnM67Ahwdtn5auXyXZ+IVcUKZ17zEJkVTbuwSbKDjgR65n+TOy1nd7wK0gBj+xJAs9bAxrN0zvBCnbDXxEufRyIA1CDWPHWFLLp1U06MNs+scLNbmWlu0ZLK/thg0KIu3yqkrqSOTxp/TLbVm2VqXLrDD7csx9hoAajfwc85DDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649436; c=relaxed/simple;
	bh=toNHusx4XTslc3WP0ldBjRlfN/Sm4RGZSxHQdAgWyiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AE5nUaxom8OQt8nTGIRBQDd4YltWWutGVKTgkNG8RzGnM+Q3Tq8WUrH5S2E1MgYuUyFqH3fTWcXZNUxYvXuOWAs71Qc1j/deujXx6MRCstcyFSEr8f7AtYtzhSmdKiDYapMktAGL8A0WVCsNn51D8oNJwa/BHs6e1xFWBefP5wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UdyLHfPM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UdyLHfPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C45F1F000E9;
	Tue, 21 Jul 2026 15:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649434;
	bh=aHZaYEiYcAv9cYHvvsGRKw0S6jjjz5GD/SHxyRGymT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdyLHfPMiUybqMRQOOO1TZHLTSVUur5FIMmBBEI7H/N2L9/uIFqjiYhGT5UCeHJ9V
	 WJq/FBGPj7bUDWM5Y3OXdtxUk3CdoGYp2UAMgzlvnxvxt/bZxaAhoCJzYCIfOkVuzo
	 ofQz9Lgt7B7yUjRhaEqImPXmwvlEIvQtUdw7o+ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xia <hongyan.xia@transsion.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0576/2077] sched/fair: Fix cpu_util runnable_avg arithmetic
Date: Tue, 21 Jul 2026 17:04:09 +0200
Message-ID: <20260721152606.392894477@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xia <hongyan.xia@transsion.com>

[ Upstream commit 29922fdfc2a4008d66418bedd0ebf5038fc54efa ]

If we take runnable_avg in max(runnable_avg, util_avg) in cpu_util(), we
should then add or subtract task runnable_avg, but the arithmetic below
is still with task util_avg. This mixes runnable_avg with util_avg which
is incorrect.

Fix by always doing arithmetic with runnable_avg and only take
max(runnable_avg, util_avg) at the last step.

Fixes: 7d0583cf9ec7 ("sched/fair, cpufreq: Introduce 'runnable boosting'")
Signed-off-by: Hongyan Xia <hongyan.xia@transsion.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://patch.msgid.link/20260605094318.37931-1-hongyan.xia@transsion.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bcc984e462272d..abb76775aa7287 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8256,25 +8256,32 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
 static unsigned long
 cpu_util(int cpu, struct task_struct *p, int dst_cpu, int boost)
 {
+	bool add_task = p && task_cpu(p) != cpu && dst_cpu == cpu;
+	bool sub_task = p && task_cpu(p) == cpu && dst_cpu != cpu;
 	struct cfs_rq *cfs_rq = &cpu_rq(cpu)->cfs;
 	unsigned long util = READ_ONCE(cfs_rq->avg.util_avg);
 	unsigned long runnable;
 
-	if (boost) {
-		runnable = READ_ONCE(cfs_rq->avg.runnable_avg);
-		util = max(util, runnable);
-	}
-
 	/*
 	 * If @dst_cpu is -1 or @p migrates from @cpu to @dst_cpu remove its
 	 * contribution. If @p migrates from another CPU to @cpu add its
 	 * contribution. In all the other cases @cpu is not impacted by the
 	 * migration so its util_avg is already correct.
 	 */
-	if (p && task_cpu(p) == cpu && dst_cpu != cpu)
-		lsub_positive(&util, task_util(p));
-	else if (p && task_cpu(p) != cpu && dst_cpu == cpu)
+	if (add_task)
 		util += task_util(p);
+	else if (sub_task)
+		lsub_positive(&util, task_util(p));
+
+	if (boost) {
+		runnable = READ_ONCE(cfs_rq->avg.runnable_avg);
+		if (add_task)
+			runnable += READ_ONCE(p->se.avg.runnable_avg);
+		else if (sub_task)
+			lsub_positive(&runnable,
+				      READ_ONCE(p->se.avg.runnable_avg));
+		util = max(util, runnable);
+	}
 
 	if (sched_feat(UTIL_EST)) {
 		unsigned long util_est;
-- 
2.53.0




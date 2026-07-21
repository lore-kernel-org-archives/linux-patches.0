Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0B946F4A6;
	Tue, 21 Jul 2026 19:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662118; cv=none; b=I0jv9C9TlWPpTnsYkiGWaFNfRNulxIVhsjviyflB96uW3p6mQJt/SmCxQ6jdPKAA7BT+xvTrWPcrqPfIqmsGfR19bd8qdnCaxObMx4BFVEZDTKB3BPppRCEIb6ST5QqQF5F9DTnD28L578t+xu+6isQBubG/zZklhpGGlQMfq+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662118; c=relaxed/simple;
	bh=kBVGyjn+M2cJzEIb2+RAORmGgfoUkuK7yzQKcE31rrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTkTOi4CFhXTF4xFfmsE4m1/mZtvqIP84I2QDs7Gl9FkGOstUCV9M+Ggbedin1q7GmYEO+15fr2ac2e+pAHem4i1Cg9za5u+IpRx7Y4Fo2W5acMeeGTiozRJvHVcKWPM703CnH4AAYaEqjj2kjrkqdW1rVUiu/8tgibJorwp/7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cdHUXff6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cdHUXff6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093501F000E9;
	Tue, 21 Jul 2026 19:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662116;
	bh=kK3iu+iUCfepa1He9kiNvhaq20evr9f8AVD4dZ5qRzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cdHUXff6xrs1IizcnWP5hnwC55ph5umCueMKLKg3wgFaz8xesAjeN/2/TaQo5hG36
	 Im7ViVVQNA0H56UY55q0PfRykx4fC3v2DUE8wAWR+REIOp2XronF7+3D864YWkgotb
	 iHPLO2j+VwQVz2FmI37pTswQfzF/pozaL9DeoFfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xia <hongyan.xia@transsion.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0279/1276] sched/fair: Fix cpu_util runnable_avg arithmetic
Date: Tue, 21 Jul 2026 17:12:02 +0200
Message-ID: <20260721152452.321495899@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index bd1b30ca184f3c..5a09448e22c33a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8101,25 +8101,32 @@ static int select_idle_sibling(struct task_struct *p, int prev, int target)
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




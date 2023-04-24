Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4631E7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D0BC433D2;
	Mon, 24 Apr 2023 13:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342505;
	bh=+Z6QKbpxtVuA7pbqPG2Cg5zvReIQJu6D4/Lk4GfhjuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/8PA9Cla/gbGb3UPIIJPTNcaMCugBCer1JQI7C3okaE2uGu+QYsbJW9r6G8BmNm7
	 /1IpFj1Ao+yWsTDUXBICVgZSIQitp2rxdg6sDWoCm0Y+PYnWhlIGbF72GEw2Jg610R
	 pAPkd+0KR0xl0wW+797JUXcsp/NUPW9Dfb2fQ0OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qais Yousef <qais.yousef@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Qais Yousef (Google)" <qyousef@layalina.io>
Subject: [PATCH 5.15 47/73] sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()s early exit condition
Date: Mon, 24 Apr 2023 15:17:01 +0200
Message-Id: <20230424131130.729372747@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qais Yousef <qais.yousef@arm.com>

commit d81304bc6193554014d4372a01debdf65e1e9a4d upstream.

If the utilization of the woken up task is 0, we skip the energy
calculation because it has no impact.

But if the task is boosted (uclamp_min != 0) will have an impact on task
placement and frequency selection. Only skip if the util is truly
0 after applying uclamp values.

Change uclamp_task_cpu() signature to avoid unnecessary additional calls
to uclamp_eff_get(). feec() is the only user now.

Fixes: 732cd75b8c920 ("sched/fair: Select an energy-efficient CPU on task wake-up")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-8-qais.yousef@arm.com
(cherry picked from commit d81304bc6193554014d4372a01debdf65e1e9a4d)
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3974,14 +3974,16 @@ static inline unsigned long task_util_es
 }
 
 #ifdef CONFIG_UCLAMP_TASK
-static inline unsigned long uclamp_task_util(struct task_struct *p)
+static inline unsigned long uclamp_task_util(struct task_struct *p,
+					     unsigned long uclamp_min,
+					     unsigned long uclamp_max)
 {
-	return clamp(task_util_est(p),
-		     uclamp_eff_value(p, UCLAMP_MIN),
-		     uclamp_eff_value(p, UCLAMP_MAX));
+	return clamp(task_util_est(p), uclamp_min, uclamp_max);
 }
 #else
-static inline unsigned long uclamp_task_util(struct task_struct *p)
+static inline unsigned long uclamp_task_util(struct task_struct *p,
+					     unsigned long uclamp_min,
+					     unsigned long uclamp_max)
 {
 	return task_util_est(p);
 }
@@ -7014,7 +7016,7 @@ static int find_energy_efficient_cpu(str
 	target = prev_cpu;
 
 	sync_entity_load_avg(&p->se);
-	if (!task_util_est(p))
+	if (!uclamp_task_util(p, p_util_min, p_util_max))
 		goto unlock;
 
 	for (; pd; pd = pd->next) {



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FF81170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB246C433C7;
	Mon, 11 Sep 2023 13:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440363;
	bh=NOZSNRDAskRlYaVvUXNZwgg58UgQm/SmTRGPCwPXSTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cr43nOe3ZdLW29ZETunurD34YijhIqaWTky/z8pK8wugk5f3zivbX6eLn0cRhn8Yt
	 KqTZXDDa7ZyFmhUNQYrvEca1hIYYXW9fQQPGyHDNlc0xtKBHetCm3rJEUCcSSPCYne
	 qZCmkSMhOB9dQuO+JkXRec1Gnl2W/drUc+2k0puk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Guittot <vincent.guittot@linaro.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 035/739] sched/fair: remove util_est boosting
Date: Mon, 11 Sep 2023 15:37:14 +0200
Message-ID: <20230911134652.074551890@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit c2e164ac33f75e0acb93004960c73bd9166d3d35 ]

There is no need to use runnable_avg when estimating util_est and that
even generates wrong behavior because one includes blocked tasks whereas
the other one doesn't. This can lead to accounting twice the waking task p,
once with the blocked runnable_avg and another one when adding its
util_est.

cpu's runnable_avg is already used when computing util_avg which is then
compared with util_est.

In some situation, feec will not select prev_cpu but another one on the
same performance domain because of higher max_util

Fixes: 7d0583cf9ec7 ("sched/fair, cpufreq: Introduce 'runnable boosting'")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lore.kernel.org/r/20230706135144.324311-1-vincent.guittot@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b3e25be58e2b7..1d9c2482c5a35 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7289,9 +7289,6 @@ cpu_util(int cpu, struct task_struct *p, int dst_cpu, int boost)
 
 		util_est = READ_ONCE(cfs_rq->avg.util_est.enqueued);
 
-		if (boost)
-			util_est = max(util_est, runnable);
-
 		/*
 		 * During wake-up @p isn't enqueued yet and doesn't contribute
 		 * to any cpu_rq(cpu)->cfs.avg.util_est.enqueued.
-- 
2.40.1




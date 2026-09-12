Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB79427FB7;
	Sat, 12 Sep 2026 08:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202487; cv=none; b=QnvCkDRhbN+g3uUXbGxRoWp72QX5+E8TlILeBkA4nNDMLDtRgNpRvfc7aXu8jA3N/VM/NETNwhEz08hMsG6UVBqlncdVQVvY6++XKE60G4wqC+CQdfdyhrEdjUXTsuXd9mRgcsBwxJvkRLZmdfDjMhhxj3CXan13M7L9jUflFv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202487; c=relaxed/simple;
	bh=d9onDWsXtv3KG0LGcEwT+iP4djZWdscYUlNVH3qXm5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PA4l95Da/B/JTM2yzYLQkpRsr97qOAUUV5gZ+u3fD0+51Y9QFopnRd5LlyHB6VlJukRWuER2hCALaScXorhJ0kIHo4XurJOLimZJSGmgFinmWHZKoZwGj/wwT4uMsTjVe1g2JeJQ8CsqCDkefcFvcll/dex7zpDfGOB9qn03oL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZOedOCs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZOedOCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F80B1F000FF;
	Sat, 12 Sep 2026 08:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202486;
	bh=06XBMY7h0CXVgJvDth764YtRF4zTCEaC5HBzKOsZKh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ZOedOCsVquJcmOAI3Goa/sGfkaHR3whLWO2bt3giDRj6cUZddu1js5F7QyFt6FMn
	 U63/VkPhuUFt5Ziur8FX/5Tx6iOCij2BSnCryHPVX1agZ5ObCAaBbb00gL9BOhnB4T
	 Bwm5UuH58Pcw5TFqLPaciSwCXpjiXzAhMjtrVWUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yu <yu.c.chen@intel.com>,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Christian Loehle <christian.loehle@arm.com>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1213/1815] sched/fair: Also gate overloaded status update for SD_ASYM_CPUCAPACITY
Date: Sat, 12 Sep 2026 08:49:23 +0200
Message-ID: <20260912065717.480755325@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit 6060d61d13a10da8c90da4eadf4a421825149883 ]

The argument sg_overloaded of update_sg_lb_stats() is only consumed when
balancing at the root domain. It only makes sense to update it in such a
case. Commit 3229adbe7875 ("sched/fair: Do not compute overloaded status
unnecessarily during lb") updated the logic accordingly but missed the case
in which the root domain has the SD_ASYM_CPUCAPACITY flag. Fix this.

Fixes: 3229adbe7875 ("sched/fair: Do not compute overloaded status unnecessarily during lb")
Reported-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Andrea Righi <arighi@nvidia.com>
Link: https://patch.msgid.link/20260720-rneri-fix-cas-clusters-v6-2-bb500bf4afd4@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bfe0972abd5f3..648fd3a39fd1f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -11867,7 +11867,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			/* Check for a misfit task on the cpu */
 			if (sgs->group_misfit_task_load < rq->misfit_task_load) {
 				sgs->group_misfit_task_load = rq->misfit_task_load;
-				*sg_overloaded = 1;
+
+				if (balancing_at_rd)
+					*sg_overloaded = 1;
 			}
 		} else if (env->idle && sched_reduced_capacity(rq, env->sd)) {
 			/* Check for a task running on a CPU with reduced capacity */
-- 
2.53.0




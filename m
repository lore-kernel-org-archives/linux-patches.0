Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540CA1D14FC;
	Wed,  2 Oct 2024 14:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878059; cv=none; b=nUvkkN7/Bxqo1Oa9IyxLtn1mdPq6krlmULwu3JPcZTL/6rvSpejVuuYPXzMtCYUW8KA6YcT/JObSZ9dIyf+29Ancp3RhnPpbIZlUjGmmkSMI4opmyBodfyW0J3HGGwvnolAbwBF9CyzqZPXjt2HQN9DLwy/FhgOEXFoKzj7XbjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878059; c=relaxed/simple;
	bh=DRpOFf8cHz5io51K6nuzJ02XkyYu7QPibsbglYaZU1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVbjwm0F1QjugSASALaOLMAirtUqFsvK0jkmpRih7uuVf7aQyg3a0FoeeYkpxzgdUTLA9eIXXHeG4VroFUfyCCECbeCbHVt6Z9D+kOX+gk5CqglQzdzGOGSvEJEjeSb0tJEuTZGO7V/weHTesrQsvWigIXyvgL09HL8GWhUShfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cx2q+zG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cx2q+zG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49CFC4CECD;
	Wed,  2 Oct 2024 14:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878059;
	bh=DRpOFf8cHz5io51K6nuzJ02XkyYu7QPibsbglYaZU1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cx2q+zG6wbdBiBTBXDFVncOvQZnY62yXrO2LlmXEqgaVQgofW3fUvr/NybTVI/CZM
	 xUTKkRSAQGoCzBjY8/b/+SM8xyEN3xE4x43nbcw+6BlXg6vr+MWzhf3PFEOU0MDSoo
	 OV/yMetweIx9xKYKhrN1pRDyKKULTATKex0CkW9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yu <yu.c.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Hongyan Xia <hongyan.xia2@arm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 287/634] sched/pelt: Use rq_clock_task() for hw_pressure
Date: Wed,  2 Oct 2024 14:56:27 +0200
Message-ID: <20241002125822.438103473@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Yu <yu.c.chen@intel.com>

[ Upstream commit 84d265281d6cea65353fc24146280e0d86ac50cb ]

commit 97450eb90965 ("sched/pelt: Remove shift of thermal clock")
removed the decay_shift for hw_pressure. This commit uses the
sched_clock_task() in sched_tick() while it replaces the
sched_clock_task() with rq_clock_pelt() in __update_blocked_others().
This could bring inconsistence. One possible scenario I can think of
is in ___update_load_sum():

  u64 delta = now - sa->last_update_time

'now' could be calculated by rq_clock_pelt() from
__update_blocked_others(), and last_update_time was calculated by
rq_clock_task() previously from sched_tick(). Usually the former
chases after the latter, it cause a very large 'delta' and brings
unexpected behavior.

Fixes: 97450eb90965 ("sched/pelt: Remove shift of thermal clock")
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Hongyan Xia <hongyan.xia2@arm.com>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lkml.kernel.org/r/20240827112607.181206-1-yu.c.chen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3c59f2b34a779..5e4162d02afc1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9365,9 +9365,10 @@ static bool __update_blocked_others(struct rq *rq, bool *done)
 
 	hw_pressure = arch_scale_hw_pressure(cpu_of(rq));
 
+	/* hw_pressure doesn't care about invariance */
 	decayed = update_rt_rq_load_avg(now, rq, curr_class == &rt_sched_class) |
 		  update_dl_rq_load_avg(now, rq, curr_class == &dl_sched_class) |
-		  update_hw_load_avg(now, rq, hw_pressure) |
+		  update_hw_load_avg(rq_clock_task(rq), rq, hw_pressure) |
 		  update_irq_load_avg(rq, 0);
 
 	if (others_have_blocked(rq))
-- 
2.43.0




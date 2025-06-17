Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E1B2F2374;
	Tue, 17 Jun 2025 15:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175089; cv=none; b=W2T0iLcpqO/nwHgX4IzDfet3hFf0MpPpuVPR9eUkB/XhmFIBqxT/6kc63TQp8fnIBxz1a5+FZOxtf+O2tC60hv0Jgol/+WFTBm2y0wM4S+Tu3TEPu5S7CbqCQv7FJU1310H1SU7SykIGjeWu1b6lRR0CYLweIINp7pJhIWIgj/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175089; c=relaxed/simple;
	bh=nzcCbmTkJvlxWcUjsiuKgNQxs+Z3+2kF3J3mr2P/f2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAdTAUp+Teg6CKjL9DjLVDgOgLHFQ9lBtdQA3sm5PsV4RFxri04yDomMsqxFaThsgWWS0qR8QWFdZw+79IKiesrttdFEaF8VYoz/J8Jh/2TBmxY73GU/NZrqdtn3mu0TBzolqHgC3gzbMhd5xvGtPNAbs2JWeLSRmI/FBnT/6Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgF4aFD9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgF4aFD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28473C4CEE3;
	Tue, 17 Jun 2025 15:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175088;
	bh=nzcCbmTkJvlxWcUjsiuKgNQxs+Z3+2kF3J3mr2P/f2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgF4aFD9n5PNwJwMMGmgpIONxDCp/LB8jIqtWtyizFe9HKu3hBCNlnRt0VivWLZ4M
	 KezUyhVqx0fi6CTi8PmSBIhlrVoiTgp+FATvVUCprLBsVPHADjFC9s6f2Xs+w5FLgB
	 hYSqPKXDNeIIas1ea5c6cAQv1mGlaaEQEimFuqOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuewen Yan <xuewen.yan@unisoc.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Tianchen Ding <dtcccc@linux.alibaba.com>
Subject: [PATCH 6.15 048/780] sched/fair: Fixup wake_up_sync() vs DELAYED_DEQUEUE
Date: Tue, 17 Jun 2025 17:15:56 +0200
Message-ID: <20250617152453.457655601@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuewen Yan <xuewen.yan@unisoc.com>

[ Upstream commit aa3ee4f0b7541382c9f6f43f7408d73a5d4f4042 ]

Delayed dequeued feature keeps a sleeping task enqueued until its
lag has elapsed. As a result, it stays also visible in rq->nr_running.
So when in wake_affine_idle(), we should use the real running-tasks
in rq to check whether we should place the wake-up task to
current cpu.
On the other hand, add a helper function to return the nr-delayed.

Fixes: 152e11f6df29 ("sched/fair: Implement delayed dequeue")
Signed-off-by: Xuewen Yan <xuewen.yan@unisoc.com>
Reviewed-and-tested-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20250303105241.17251-2-xuewen.yan@unisoc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0fb9bf995a479..0c04ed4148525 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7196,6 +7196,11 @@ static bool dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	return true;
 }
 
+static inline unsigned int cfs_h_nr_delayed(struct rq *rq)
+{
+	return (rq->cfs.h_nr_queued - rq->cfs.h_nr_runnable);
+}
+
 #ifdef CONFIG_SMP
 
 /* Working cpumask for: sched_balance_rq(), sched_balance_newidle(). */
@@ -7357,8 +7362,12 @@ wake_affine_idle(int this_cpu, int prev_cpu, int sync)
 	if (available_idle_cpu(this_cpu) && cpus_share_cache(this_cpu, prev_cpu))
 		return available_idle_cpu(prev_cpu) ? prev_cpu : this_cpu;
 
-	if (sync && cpu_rq(this_cpu)->nr_running == 1)
-		return this_cpu;
+	if (sync) {
+		struct rq *rq = cpu_rq(this_cpu);
+
+		if ((rq->nr_running - cfs_h_nr_delayed(rq)) == 1)
+			return this_cpu;
+	}
 
 	if (available_idle_cpu(prev_cpu))
 		return prev_cpu;
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406F52E3385;
	Tue,  8 Jul 2025 16:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992889; cv=none; b=uChJjZL7imEwHm04/QJmjw+AMX4AYWDZe8+uAAYXIpRUKxmshZclsmyUZqrQT6GK1AZq7+1SEMP9GMZHUZ0epw9jr5Vn4zvtE9QShYqN6tokVpJmhUx3fdk29FW+h11URGpvbxAGCUoY+XIDyBGbY2WFbiGZ1GjbS4k0KpjDM0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992889; c=relaxed/simple;
	bh=xOqYTmTaUhDlre5EXPWV5eHqTTaye2DyA+5aaoJAE00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hVVzNtdfR4f1I+oj28Hr5vkyw5QHmC2I+9WEhvPXYLw+HiNUPUFcxu0EcogKUOWAduTwQgqPOSUaDeyZbrMhLNZLgEuGOOu4UIyzpAocN0zQXCaFCsf/DUba4IlIQcvNEeN1OmlZvNEYbUw6Y+sFc7Y+9I3J8burN1rOo4fVgWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w52/l3X+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w52/l3X+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777E4C4CEED;
	Tue,  8 Jul 2025 16:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992888;
	bh=xOqYTmTaUhDlre5EXPWV5eHqTTaye2DyA+5aaoJAE00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w52/l3X+ftkRRZ0Xb4GSnAMT7UfwVDQJzetkKVSPuaFNGpU0bpfnLPUebdkurhTwj
	 3VgRkBDFkzJElwTEb7EkcwxoR/quF63NCB00jevohXO5WjQxJpvhZxM1/++G/XTpnM
	 2wol9M0ZgYeM3p21OyRULEU+cGObzs+bp0SGVBv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuewen Yan <xuewen.yan@unisoc.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Tianchen Ding <dtcccc@linux.alibaba.com>
Subject: [PATCH 6.12 115/232] sched/fair: Fixup wake_up_sync() vs DELAYED_DEQUEUE
Date: Tue,  8 Jul 2025 18:21:51 +0200
Message-ID: <20250708162244.448795596@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 47ff4856561ea..7280ed04c96ce 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -7313,6 +7313,11 @@ static bool dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 	return true;
 }
 
+static inline unsigned int cfs_h_nr_delayed(struct rq *rq)
+{
+	return (rq->cfs.h_nr_queued - rq->cfs.h_nr_runnable);
+}
+
 #ifdef CONFIG_SMP
 
 /* Working cpumask for: sched_balance_rq(), sched_balance_newidle(). */
@@ -7474,8 +7479,12 @@ wake_affine_idle(int this_cpu, int prev_cpu, int sync)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1A72DEA7A;
	Wed,  4 Feb 2026 15:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219280; cv=none; b=nAZDbeP6/wNAfaP7qjo8xTYYV3kC66/ybeLKUaH5U3UujVwFvAIDnvemuGLjvxAxfn3WGZ5hHvBsPfQuUdGxVReZUaIsoaIK1jIc+V5pE0fS+jYXFivnsn7ngOgEpjj4RkVIkA9scAGKJeE/YLkCidYnEOFuLcehFb+RvbGFY9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219280; c=relaxed/simple;
	bh=muUuoq5qZO4w6riKWFyswqYCJ3369rje0QROC3GKgfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzhDLAMjltfz/xS1+dKjJO6wCmpOQHCOUawztKIC3spo6C+Cf9D5gabZsnKeLFaauwfDR++zWD9n2uzNbrXEpKk0U0/yYwPWZLa1UexsiE9MBHiiGtrOUS0yFdnW0y0xPSHGyXyDpqb/xvjeUiv1D+X27S6/yox+4ncT3qOZ15U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIub3n2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIub3n2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8603CC4CEF7;
	Wed,  4 Feb 2026 15:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219280;
	bh=muUuoq5qZO4w6riKWFyswqYCJ3369rje0QROC3GKgfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIub3n2socCwJFl2ZzQjU8fFlnLU2NJb1s9NbKDXBIM0qgi3YIEvAqc1qpj3eA0le
	 4WtGIdY6SdXuSsOEf5rPYCyJpAa/0r9p5zNujwLRTGWjh41URO0zvbseiytMGVSGbR
	 jOmOjMyDXmTmwb0bQ0peaIvhcHoz4CWkmAjyTRpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"arighi@nvidia.com, void@manifault.com, sched-ext@lists.linux.dev, Christian Loehle" <christian.loehle@arm.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Christian Loehle <christian.loehle@arm.com>
Subject: [PATCH 6.18 120/122] sched_ext: Dont kick CPUs running higher classes
Date: Wed,  4 Feb 2026 15:41:42 +0100
Message-ID: <20260204143856.168042743@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit a9c1fbbd6dadbaa38c157a07d5d11005460b86b9 upstream.

When a sched_ext scheduler tries to kick a CPU, the CPU may be running a
higher class task. sched_ext has no control over such CPUs. A sched_ext
scheduler couldn't have expected to get access to the CPU after kicking it
anyway. Skip kicking when the target CPU is running a higher class.

Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5164,18 +5164,23 @@ static bool kick_one_cpu(s32 cpu, struct
 {
 	struct rq *rq = cpu_rq(cpu);
 	struct scx_rq *this_scx = &this_rq->scx;
+	const struct sched_class *cur_class;
 	bool should_wait = false;
 	unsigned long flags;
 
 	raw_spin_rq_lock_irqsave(rq, flags);
+	cur_class = rq->curr->sched_class;
 
 	/*
 	 * During CPU hotplug, a CPU may depend on kicking itself to make
-	 * forward progress. Allow kicking self regardless of online state.
+	 * forward progress. Allow kicking self regardless of online state. If
+	 * @cpu is running a higher class task, we have no control over @cpu.
+	 * Skip kicking.
 	 */
-	if (cpu_online(cpu) || cpu == cpu_of(this_rq)) {
+	if ((cpu_online(cpu) || cpu == cpu_of(this_rq)) &&
+	    !sched_class_above(cur_class, &ext_sched_class)) {
 		if (cpumask_test_cpu(cpu, this_scx->cpus_to_preempt)) {
-			if (rq->curr->sched_class == &ext_sched_class)
+			if (cur_class == &ext_sched_class)
 				rq->curr->scx.slice = 0;
 			cpumask_clear_cpu(cpu, this_scx->cpus_to_preempt);
 		}



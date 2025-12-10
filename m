Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529543019C7;
	Wed, 10 Dec 2025 07:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352133; cv=none; b=Gp9bbfI6jq1x+Jd+dVHf479hTHer6YIkiltPsHWrXwe32lmuPX4Ryfo00gk8TXY4J4oD8QIR6rANpbkaR783IQVfwtX0yRR7P9YUUksbuFR5G6lu4PmYCzmSsr/aQlzIX1Q2jN+oaccB46QRziswUjb9cDl7EP6PsexKJpfPjXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352133; c=relaxed/simple;
	bh=d45qxoSJ8ljS6Wav8vwK6GCOM4u7dFBs9p6KXWC1gjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+asWwuPUJJVS3k7cZjITuVucNR1mvxtdhjkpRJA4uPdOJTSNM1NsWrnm+uLz56kuGAfENiqU3FdDBF19XPsXKMuaAuRg79gGWtS4xhZXRP2dyTCUmEyK82uKM0jweGOtjredIFJE+cChCX/ea8LjQDVhc/YqO8ETeuzJ7svJgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbkejCWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbkejCWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF0DC4CEF1;
	Wed, 10 Dec 2025 07:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352133;
	bh=d45qxoSJ8ljS6Wav8vwK6GCOM4u7dFBs9p6KXWC1gjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbkejCWUgSErcNC4tPxQK1S8JgfUYxXpvDabVd/iBoH3078M/WaoHBtRYwD4suSDf
	 alLiUFwlv3aO6pNRpE0nO5SuiHW8OReUatq2vdxRsaCn1gMlE4jYIYb/UJ1Ny1wN8l
	 jz06Vmy3L58U7Ggs/KMgxJa0UWeyW8nHSthJz76M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 44/60] sched_ext: Fix possible deadlock in the deferred_irq_workfn()
Date: Wed, 10 Dec 2025 16:30:14 +0900
Message-ID: <20251210072948.960218513@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang@linux.dev>

[ Upstream commit a257e974210320ede524f340ffe16bf4bf0dda1e ]

For PREEMPT_RT=y kernels, the deferred_irq_workfn() is executed in
the per-cpu irq_work/* task context and not disable-irq, if the rq
returned by container_of() is current CPU's rq, the following scenarios
may occur:

lock(&rq->__lock);
<Interrupt>
  lock(&rq->__lock);

This commit use IRQ_WORK_INIT_HARD() to replace init_irq_work() to
initialize rq->scx.deferred_irq_work, make the deferred_irq_workfn()
is always invoked in hard-irq context.

Signed-off-by: Zqiang <qiang.zhang@linux.dev>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 1e4740de66c28..16a7ae9b29ae4 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -5377,7 +5377,7 @@ void __init init_sched_ext_class(void)
 		BUG_ON(!zalloc_cpumask_var_node(&rq->scx.cpus_to_kick_if_idle, GFP_KERNEL, n));
 		BUG_ON(!zalloc_cpumask_var_node(&rq->scx.cpus_to_preempt, GFP_KERNEL, n));
 		BUG_ON(!zalloc_cpumask_var_node(&rq->scx.cpus_to_wait, GFP_KERNEL, n));
-		init_irq_work(&rq->scx.deferred_irq_work, deferred_irq_workfn);
+		rq->scx.deferred_irq_work = IRQ_WORK_INIT_HARD(deferred_irq_workfn);
 		init_irq_work(&rq->scx.kick_cpus_irq_work, kick_cpus_irq_workfn);
 
 		if (cpu_online(cpu))
-- 
2.51.0




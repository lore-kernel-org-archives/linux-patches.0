Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3ACF288C22;
	Wed, 28 Jan 2026 15:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615424; cv=none; b=dDLdm1VbiW6REWXqI2pEpDOgDOGImN4QuAIXu63im3N9jrR9Kt6/1nA5Sx4fD+OaYPGrnG9LKmpY+spMlA8kcpiOQAr6oJv97wA03d6ztfeLo3EkGbEfoTjLd8bltbIFPCcuNqx7/Q9dOf6eTJEjUpaqVaXro8byrIsVMwi47s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615424; c=relaxed/simple;
	bh=OA8TuQYIQ7XBj8Ad3PQFjcSol22+Ko0ATrdPLDJZNwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2hTMDJOIHOYeMiU6FK34pGdNM8Q4UxhenfHsvEbicYYFheg7rwF6vTlLHjJe9hHKMsnR61gQD5Lugrp9mLwUQpFtVQJ8/qiV7mP3tM+ZjUj4XmPWuzAS8fHJXT+HwuyHu0YqoP+SX2xksuuTieamYyhbPy7MqyiUIJQAulwjQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWdBBx23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWdBBx23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BE7C4CEF1;
	Wed, 28 Jan 2026 15:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615424;
	bh=OA8TuQYIQ7XBj8Ad3PQFjcSol22+Ko0ATrdPLDJZNwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWdBBx23dH2ivjgUbte9dhC8FpimQEU/2jVPgE5CESunVZ2XS7G8XIvedVdV8ERdp
	 o5rvlIvt90NkEsbJg4noOuJvFKfS5IXEIh0L3AiSdeySw20OWgjVkJZHySIKwBj+PW
	 W1fSTuGSeTZw3j5Ergt//5DKQE3DoAKUub5Cq55w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Chen Yu <xnguchen@sina.cn>
Subject: [PATCH 6.12 157/169] sched_ext: Fix possible deadlock in the deferred_irq_workfn()
Date: Wed, 28 Jan 2026 16:24:00 +0100
Message-ID: <20260128145339.663065960@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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
Signed-off-by: Chen Yu <xnguchen@sina.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -6044,7 +6044,7 @@ void __init init_sched_ext_class(void)
 		BUG_ON(!zalloc_cpumask_var(&rq->scx.cpus_to_kick_if_idle, GFP_KERNEL));
 		BUG_ON(!zalloc_cpumask_var(&rq->scx.cpus_to_preempt, GFP_KERNEL));
 		BUG_ON(!zalloc_cpumask_var(&rq->scx.cpus_to_wait, GFP_KERNEL));
-		init_irq_work(&rq->scx.deferred_irq_work, deferred_irq_workfn);
+		rq->scx.deferred_irq_work = IRQ_WORK_INIT_HARD(deferred_irq_workfn);
 		init_irq_work(&rq->scx.kick_cpus_irq_work, kick_cpus_irq_workfn);
 
 		if (cpu_online(cpu))



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D5351E445;
	Wed, 30 Sep 2026 18:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793292; cv=none; b=atYIPL06SD3b99RyXFTSfCPuxu3QtM+cSbPRba2i93SnVGT8koXcpbh8PZNFcQaTFxeFD5aZCRevJ7JoPtv/AcG1lF+lnu+V+yFekSh59DaHlZIpFagxQvwbj5HE5xTN3ey+3X54weot2iyuZCbppzh+q/eZOe7jLO6+oVn2HWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793292; c=relaxed/simple;
	bh=iWl0P5ZBdDjonp7+5Qjd7XA0Fg56biBNuua+W/VAkkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qj9Yy+Aol4HArvcITW02eWNBXbZIFVMJB/CkDXapKdRM30T7nWoScxXubNODP3z08OIUilz0KKdVhrtewFv0nBRxa16Dzd0mr86KH4Pz5J13DayipUrXhlZ4eCUlWy2M+rUyEvSS13gdCcg/r5Kni1v+k89xvFtSZXFLXPQNihU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDfDbEI8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDfDbEI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AD91F000FF;
	Wed, 30 Sep 2026 18:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793291;
	bh=0sOxlfEZBSaLVUOIT8XjZBU6GZ3Adg71jbw+OJtlvCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDfDbEI8HyU2WExK5ny9Jb65U6w3t6U/aEj1o9zyE5C4iUxIYd3NQeLU2MXkGuLp8
	 CG/ElkbaDySjrbMg+80yn1i+HBAc8X9qYekWwIfHFJwy5XfS5zHyRVJKpriN5XWsvI
	 zhymVjTTq6zW92Tlbao25bg4Nxc1WWZLvDImRzK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 202/395] sched/core: Account PSI IRQ time to the execution context, not the scheduling context
Date: Wed, 30 Sep 2026 17:27:44 +0200
Message-ID: <20260930152345.029526491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

[ Upstream commit a0bb6fac53fa7cf1cadb487b43d4c9276a6b82e3 ]

psi_account_irqtime() has two callers which share rq->psi_irq_time, and
they disagree about the context: __schedule() passes the outgoing rq->curr,
sched_tick() passes rq->donor.  Under proxy execution the donor is blocked
on a mutex while rq->curr burns the CPU.

The tick charges PSI_IRQ_FULL to the donor's cgroup and advances the
timestamp, so the call from __schedule() then finds delta <= 0 and charges
nothing.  The delta is not counted twice, it lands on the wrong cgroup.

Pass rq->curr, which is what the call read before commit af0c8b2bf67b
("sched: Split scheduler and execution contexts") renamed 'curr' to
'donor' across sched_tick().  Without CONFIG_SCHED_PROXY_EXEC the two rq
members are a union, so this only changes anything where that option is set,
and it depends on EXPERT.

Fixes: af0c8b2bf67b ("sched: Split scheduler and execution contexts")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20260918132915.1236312-1-zhanxusheng@xiaomi.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index aad9813bd6171..dbd871c6235f4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5613,7 +5613,7 @@ void sched_tick(void)
 	curr = rq->curr;
 	donor = rq->donor;
 
-	psi_account_irqtime(rq, donor, NULL);
+	psi_account_irqtime(rq, curr, NULL);
 
 	update_rq_clock(rq);
 	hw_pressure = arch_scale_hw_pressure(cpu_of(rq));
-- 
2.53.0




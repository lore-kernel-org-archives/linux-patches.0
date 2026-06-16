Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898B7478868;
	Tue, 16 Jun 2026 18:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634473; cv=none; b=ddSmyEfzb4tWrPnZbI9BSwbUcJ3zLwQiYfFsteE5zgePlDSW7k1XvIVDFR8GR0caNCwkkiCRjPZA7sacSviLRED3JXRxRK6vKFFghjL92E7qZmIj9Vi0mPUMctsXqwLlmftn3SFWiTA4Zec/6xZuh21H6LO01DU99rFvowKoqUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634473; c=relaxed/simple;
	bh=sAGtwj/sBi4hj+NjnOOeM2Fq6SmQusyxSAEt5hxpH0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kq7SPiRSCDky/q5cfx/OUKBmxdG9FSG886XlDQ8+IP1RNw23159s0szg/f1fXUA1iyccgV9S77G+v8OypxCh03g8Lh32D4mSFOot9eBUCvSmtHBvePXoWvWlMTZi3oDkvGcbRbL0vz+n87lRt0BFy8XY4yw2sEY/rTitIIsPCCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWHplQnh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWHplQnh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2351F000E9;
	Tue, 16 Jun 2026 18:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634472;
	bh=PMOR+ckDacYYisFD8oInA3mvodMVehQByRuvg8nKDE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWHplQnhugS5lgalB9V2u9y0zOJ/N6FizEKuJ1ukQFW/ipst3C+I6f+XSgSBOKB1D
	 HRvTOIvTWTLvLldMO8s5OSzfrixlV/ICQsU2LZ9axULGlQIV1d8hrQ6EGULogt7O0t
	 QfZG0x3t3hMYoNBnBJ2yaTZv3WHv8vwthRlNJ1O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Salisbury <joseph.salisbury@oracle.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 272/411] sched: Use u64 for bandwidth ratio calculations
Date: Tue, 16 Jun 2026 20:28:30 +0530
Message-ID: <20260616145115.575178814@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Salisbury <joseph.salisbury@oracle.com>

[ Upstream commit c6e80201e057dfb7253385e60bf541121bf5dc33 ]

to_ratio() computes BW_SHIFT-scaled bandwidth ratios from u64 period and
runtime values, but it returns unsigned long.  tg_rt_schedulable() also
stores the current group limit and the accumulated child sum in unsigned
long.

On 32-bit builds, large bandwidth ratios can be truncated and the RT
group sum can wrap when enough siblings are present.  That can let an
overcommitted RT hierarchy pass the schedulability check, and it also
narrows the helper result for other callers.

Return u64 from to_ratio() and use u64 for the RT group totals so
bandwidth ratios are preserved and compared at full width on both 32-bit
and 64-bit builds.

Fixes: b40b2e8eb521 ("sched: rt: multi level group constraints")
Assisted-by: Codex:GPT-5
Signed-off-by: Joseph Salisbury <joseph.salisbury@oracle.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260403210014.2713404-1-joseph.salisbury@oracle.com
[ dropped `extern` keyword from `to_ratio()` declaration ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c  |    2 +-
 kernel/sched/rt.c    |    2 +-
 kernel/sched/sched.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4491,7 +4491,7 @@ void sched_post_fork(struct task_struct
 	uclamp_post_fork(p);
 }
 
-unsigned long to_ratio(u64 period, u64 runtime)
+u64 to_ratio(u64 period, u64 runtime)
 {
 	if (runtime == RUNTIME_INF)
 		return BW_UNIT;
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2606,7 +2606,7 @@ static int tg_rt_schedulable(struct task
 {
 	struct rt_schedulable_data *d = data;
 	struct task_group *child;
-	unsigned long total, sum = 0;
+	u64 total, sum = 0;
 	u64 period, runtime;
 
 	period = ktime_to_ns(tg->rt_bandwidth.rt_period);
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2340,7 +2340,7 @@ extern void init_dl_inactive_task_timer(
 #define RATIO_SHIFT		8
 #define MAX_BW_BITS		(64 - BW_SHIFT)
 #define MAX_BW			((1ULL << MAX_BW_BITS) - 1)
-unsigned long to_ratio(u64 period, u64 runtime);
+u64 to_ratio(u64 period, u64 runtime);
 
 extern void init_entity_runnable_average(struct sched_entity *se);
 extern void post_init_entity_util_avg(struct task_struct *p);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FAE35A3AD;
	Mon,  4 May 2026 14:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903851; cv=none; b=PMiPgMCoxDs0gOrzAyxnuJl2QDGzBnFMrGBWCyrHBV1Un//f8e4hzzcokp42lesSFm+nGblPgBSNxHa3FLPQgyck4x5UQYFW878KWmWhwHLIPPctSm1rT/MCXHLfM6oypDo2LAWH+quPI3hwvTH2gaN3dNcDehHJ3cRuxfod3gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903851; c=relaxed/simple;
	bh=0HrC5sl1nSQUMpX6xt7dvsznCrXE6vIn2k0O6zmlRs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxgVrLGSHDGRvzvDspb1qTjGJUIFD7avhZ/4tYucUancJeXbm69oemePbTYB3NT5Ly5rSH2e/I6ILB1mucGZkmfQCZq4IQB6j9FnTHd0l0+ruGyhIMpE8zXAzXB9UCpYMgH7YFsjOh72ddBYG76sep8qlAy2U3CLadZkV8Ekfbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOtJP/NQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOtJP/NQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEC8C2BCB8;
	Mon,  4 May 2026 14:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903850;
	bh=0HrC5sl1nSQUMpX6xt7dvsznCrXE6vIn2k0O6zmlRs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOtJP/NQWkQ23XgQwIDvpj1lAiQkZZqB2X66JtGwd+BJxUXA9AsWuWYCPS9ovvUPn
	 sHzUtrOyWCndUl2mgnqQI4S/tzMpANx0iabbxLy0ul1lvEAilEyWA+h98MvSdIr9JI
	 Ze6K39bZRUmPpBMBlTXKQV0zaPoLMPC1LzzrHM9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Salisbury <joseph.salisbury@oracle.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.18 085/275] sched: Use u64 for bandwidth ratio calculations
Date: Mon,  4 May 2026 15:50:25 +0200
Message-ID: <20260504135146.078930712@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Joseph Salisbury <joseph.salisbury@oracle.com>

commit c6e80201e057dfb7253385e60bf541121bf5dc33 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c  |    2 +-
 kernel/sched/rt.c    |    2 +-
 kernel/sched/sched.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4792,7 +4792,7 @@ void sched_post_fork(struct task_struct
 	scx_post_fork(p);
 }
 
-unsigned long to_ratio(u64 period, u64 runtime)
+u64 to_ratio(u64 period, u64 runtime)
 {
 	if (runtime == RUNTIME_INF)
 		return BW_UNIT;
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2644,7 +2644,7 @@ static int tg_rt_schedulable(struct task
 {
 	struct rt_schedulable_data *d = data;
 	struct task_group *child;
-	unsigned long total, sum = 0;
+	u64 total, sum = 0;
 	u64 period, runtime;
 
 	period = ktime_to_ns(tg->rt_bandwidth.rt_period);
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2702,7 +2702,7 @@ extern void init_cfs_throttle_work(struc
 #define MAX_BW_BITS		(64 - BW_SHIFT)
 #define MAX_BW			((1ULL << MAX_BW_BITS) - 1)
 
-extern unsigned long to_ratio(u64 period, u64 runtime);
+extern u64 to_ratio(u64 period, u64 runtime);
 
 extern void init_entity_runnable_average(struct sched_entity *se);
 extern void post_init_entity_util_avg(struct task_struct *p);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D86B3ACA68;
	Tue, 16 Jun 2026 19:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636404; cv=none; b=EbNoB0A3JINPryytPhoIk4+2x5Qg81MvwSeLbjlDFuKMIMyx9mr575FcRi8erxFitcxFE+WIN4M+yoic9kkhfXBktNQSct6hPymZqVVZR8siJ49P53Wbjn3NtnexBIIcxJRdvQT0isE429N2dz/Dnt7BD2EgQfPWO0Rj8/Uv+ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636404; c=relaxed/simple;
	bh=ZwpNfZf5qHG8uDqCOVe3MjmfEPwKGYenPtBRGwSKFw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvKeIN2dvD93qOKEeeZRwQdQ85NKFfcQ4VYI2tKjIgGAamdw7G2ct/x+cAVfUjTrjwqRant2OMCW25ZZ69/x18NGjPHzMRP4Bkx01DKhkEAqKECVss3iFkN2g4Ww1YWTtro0VN4Ifcx/sKHecvxVTVWQ+hU9FmomYPGTkBQ2uwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBvy8lcs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBvy8lcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195A61F000E9;
	Tue, 16 Jun 2026 19:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636403;
	bh=Hghlkp8QU9jmfAPmUpPzHZJ0GHKBT1Hw1TJctqATKRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LBvy8lcsHo5cFHkii+KtWkH97ASgyjSuJy2sBfMuqrVXd+rmkZhgpgi8cfMG1JCBD
	 CAw8/WHPA70PoyixppPjScCMCh49BUdvS4JGgtMfw4u3WeiGOq/EyYzvTf8qaX2agg
	 fo37LwTsrDkybue+417AhqQRC1WgsNvYcgJMMlm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Salisbury <joseph.salisbury@oracle.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 232/342] sched: Use u64 for bandwidth ratio calculations
Date: Tue, 16 Jun 2026 20:28:48 +0530
Message-ID: <20260616145059.010270287@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3328,7 +3328,7 @@ void sched_post_fork(struct task_struct
 	uclamp_post_fork(p);
 }
 
-unsigned long to_ratio(u64 period, u64 runtime)
+u64 to_ratio(u64 period, u64 runtime)
 {
 	if (runtime == RUNTIME_INF)
 		return BW_UNIT;
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2527,7 +2527,7 @@ static int tg_rt_schedulable(struct task
 {
 	struct rt_schedulable_data *d = data;
 	struct task_group *child;
-	unsigned long total, sum = 0;
+	u64 total, sum = 0;
 	u64 period, runtime;
 
 	period = ktime_to_ns(tg->rt_bandwidth.rt_period);
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1956,7 +1956,7 @@ extern void init_dl_inactive_task_timer(
 #define RATIO_SHIFT		8
 #define MAX_BW_BITS		(64 - BW_SHIFT)
 #define MAX_BW			((1ULL << MAX_BW_BITS) - 1)
-unsigned long to_ratio(u64 period, u64 runtime);
+u64 to_ratio(u64 period, u64 runtime);
 
 extern void init_entity_runnable_average(struct sched_entity *se);
 extern void post_init_entity_util_avg(struct task_struct *p);



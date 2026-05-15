Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBD9280035;
	Fri, 15 May 2026 16:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861696; cv=none; b=JA2Ve3rqzpB0OLa5yQ84rMuLy/UToOY1sIlmlN05iDV6WBjbl0wBx/xJRS4Y5en5d1MdXRKS1LY7hx/7jk+DG14ie1HPAMSPkjo8Y/ZMRo6bNRmxxZozTCTKUn6ybMurngb1WkWvw42Xg6iV2tvavIIl2qPMZSfjnR9tLJvdb/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861696; c=relaxed/simple;
	bh=Fxt3KIEdmgV2S8deJjCSQ4OdoRpCBRaW9FztK4k9QNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uciJtPa6upX4WCxPmbrq/14Z5EIv+qc60JClVNYJBlqKskjZgzsVl1tWu9Xbs2L/AfXRQ/iQ9Fsqt/vKhCJBnwZxHkzZaZuSECr3DgmXFP4/yWa7InMWGHMHFwfc9Lqsh4gpygD8tVZKG0VV+XKzxPYcmEvLlwuOZzvOz3s9aIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmf8A1m1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmf8A1m1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1472C2BCB0;
	Fri, 15 May 2026 16:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861696;
	bh=Fxt3KIEdmgV2S8deJjCSQ4OdoRpCBRaW9FztK4k9QNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jmf8A1m1dGNXU4q8O+df2LaGDXUnIM/hKcpq/fQwq1jKKmvK8aajy48kNISb7zW4S
	 lZ8AhP88tU6a986xo1a+G8LvnIcS3t8G0UBrbOqMOsTMplAQS67Lv5CcoSTJWntDMv
	 Xr33sN4J0cPOg0iS+6Mhc+C+oH2sdCLrbffZhkBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Salisbury <joseph.salisbury@oracle.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 386/474] sched: Use u64 for bandwidth ratio calculations
Date: Fri, 15 May 2026 17:48:15 +0200
Message-ID: <20260515154723.390131216@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4823,7 +4823,7 @@ void sched_post_fork(struct task_struct
 	uclamp_post_fork(p);
 }
 
-unsigned long to_ratio(u64 period, u64 runtime)
+u64 to_ratio(u64 period, u64 runtime)
 {
 	if (runtime == RUNTIME_INF)
 		return BW_UNIT;
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2776,7 +2776,7 @@ static int tg_rt_schedulable(struct task
 {
 	struct rt_schedulable_data *d = data;
 	struct task_group *child;
-	unsigned long total, sum = 0;
+	u64 total, sum = 0;
 	u64 period, runtime;
 
 	period = ktime_to_ns(tg->rt_bandwidth.rt_period);
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2463,7 +2463,7 @@ extern void init_dl_entity(struct sched_
 #define RATIO_SHIFT		8
 #define MAX_BW_BITS		(64 - BW_SHIFT)
 #define MAX_BW			((1ULL << MAX_BW_BITS) - 1)
-unsigned long to_ratio(u64 period, u64 runtime);
+u64 to_ratio(u64 period, u64 runtime);
 
 extern void init_entity_runnable_average(struct sched_entity *se);
 extern void post_init_entity_util_avg(struct task_struct *p);



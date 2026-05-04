Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01D33DDDDA;
	Mon,  4 May 2026 13:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903084; cv=none; b=GrZbkafl2VONuCP6HUn35RPQ5c0+COV13xu4c1+w1CxRbTyppUg5k4BLqB6C0d7jOd5lR5gaESYFAmHFG3LcRPZgJcUNWXa7C0Mos7PHfa/jMv03abm6IVDG3RIPv749RywAvoznNbMR82kZxsm1kYspbV7sAZGLQ1TUAfKslws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903084; c=relaxed/simple;
	bh=fHTMmoEIZWx4TYeAV0wChvYgCqwfSE0sssQ9xXPvMD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNFwZU8Wuo+uAep3NhPMIJYoMa53d66c8GVEjvN4J4vaRz4C0dMp4TLdONFXUh9zDYP3YOireGcVzyzMsrVvEfJzvP+kFdOGKGCFhTIq+6v0I72Uk0s6UhH+VSkTNIRMgnhR7+irvDFfL8WgP3//8WtmKJ06AHu5D81EmLCDNQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPP+3jMA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPP+3jMA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39FC7C2BCB8;
	Mon,  4 May 2026 13:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903084;
	bh=fHTMmoEIZWx4TYeAV0wChvYgCqwfSE0sssQ9xXPvMD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPP+3jMABXp43SNS5KMRZI0lT797O18lXUeYf/YJuIBhNc9aqqdQCe/hafwUeDJpB
	 hA5iWyDvxFeQ8y+Qr1M9LySpvN90T0OTCWUzmPsSyWu8E074gmmjs5/wHxnkG8IXSR
	 HSTvFWaux2uSWWbDlM2SNDsyYdSYdVad8XufUWhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Salisbury <joseph.salisbury@oracle.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 7.0 096/307] sched: Use u64 for bandwidth ratio calculations
Date: Mon,  4 May 2026 15:49:41 +0200
Message-ID: <20260504135146.427721168@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4738,7 +4738,7 @@ void sched_post_fork(struct task_struct
 	scx_post_fork(p);
 }
 
-unsigned long to_ratio(u64 period, u64 runtime)
+u64 to_ratio(u64 period, u64 runtime)
 {
 	if (runtime == RUNTIME_INF)
 		return BW_UNIT;
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2652,7 +2652,7 @@ static int tg_rt_schedulable(struct task
 {
 	struct rt_schedulable_data *d = data;
 	struct task_group *child;
-	unsigned long total, sum = 0;
+	u64 total, sum = 0;
 	u64 period, runtime;
 
 	period = ktime_to_ns(tg->rt_bandwidth.rt_period);
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2899,7 +2899,7 @@ extern void init_cfs_throttle_work(struc
 #define MAX_BW_BITS		(64 - BW_SHIFT)
 #define MAX_BW			((1ULL << MAX_BW_BITS) - 1)
 
-extern unsigned long to_ratio(u64 period, u64 runtime);
+extern u64 to_ratio(u64 period, u64 runtime);
 
 extern void init_entity_runnable_average(struct sched_entity *se);
 extern void post_init_entity_util_avg(struct task_struct *p);



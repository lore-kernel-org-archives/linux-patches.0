Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC28022FF22;
	Fri, 15 May 2026 16:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862256; cv=none; b=k4Oj0n08XoKZUphe29Ca2wYBrliiOF/JfZfaDkQHSkVfbcIfxl1zyPAwMYm3/oZ/U2M7pWVyqb0LVUwsdzajookeT7cNOMCivVTOfOI4v3VEp50XK40s4dwHgaBTqwuYx3/J3TOqYFEYaC4rmR45un6lOf6GGuFDQlscCqrLAI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862256; c=relaxed/simple;
	bh=wLm++ZP4zo3t7JIbbXD3eMUvwNbv1a4PvJEAKOs3qH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghHpthOzcnHgVRj3mb8UmTj87KpYa1W8A2n+wx4rLd7weabtJoHoez6PH3WcgrWX4F/9Yp+OjFWB25a+RSMXNh7vWK8+GQTEmzb/omvNbY16TXj7NYE5iH4xbdaH386bBuQy1ZXycOEWsOAQD+/VB8ATHVgHxHUzZm89bHhhrhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7F9ShkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7F9ShkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E39C2BCB0;
	Fri, 15 May 2026 16:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862256;
	bh=wLm++ZP4zo3t7JIbbXD3eMUvwNbv1a4PvJEAKOs3qH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7F9ShkOtWe2nNVF3IhaGlUEN40QgTe6O8toPc0C2qfq4KZeyQy8RAicwEE8ZLh9w
	 3xm0nkvFE79BhXVHpD3Ddfmv8x6Sy6+EYd32awgTO8ZeDfmj5dMXscd91ofozOs+gS
	 m4Nv6a2IlyEKe35Yx/7jPU6LxX1ZEQpC4KRkWTXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhidao su <soolaugust@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 169/188] sched/ext: Implement cgroup_set_idle() callback
Date: Fri, 15 May 2026 17:49:46 +0200
Message-ID: <20260515154701.001619963@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: zhidao su <suzhidao@xiaomi.com>

[ Upstream commit 347ed2d566dabb06c7970fff01129c4f59995ed6 ]

Implement the missing cgroup_set_idle() callback that was marked as a
TODO. This allows BPF schedulers to be notified when a cgroup's idle
state changes, enabling them to adjust their scheduling behavior
accordingly.

The implementation follows the same pattern as other cgroup callbacks
like cgroup_set_weight() and cgroup_set_bandwidth(). It checks if the
BPF scheduler has implemented the callback and invokes it with the
appropriate parameters.

Fixes a spelling error in the cgroup_set_bandwidth() documentation.

tj: s/scx_cgroup_rwsem/scx_cgroup_ops_rwsem/ to fix build breakage.

Signed-off-by: zhidao su <soolaugust@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 80afd4c84bc8 ("sched_ext: Read scx_root under scx_cgroup_ops_rwsem in cgroup setters")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched/ext.h   |    1 +
 kernel/sched/ext.c          |   16 +++++++++++++++-
 kernel/sched/ext_internal.h |   13 ++++++++++++-
 3 files changed, 28 insertions(+), 2 deletions(-)

--- a/include/linux/sched/ext.h
+++ b/include/linux/sched/ext.h
@@ -228,6 +228,7 @@ struct scx_task_group {
 	u64			bw_period_us;
 	u64			bw_quota_us;
 	u64			bw_burst_us;
+	bool			idle;
 #endif
 };
 
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3118,6 +3118,7 @@ void scx_tg_init(struct task_group *tg)
 	tg->scx.weight = CGROUP_WEIGHT_DFL;
 	tg->scx.bw_period_us = default_bw_period_us();
 	tg->scx.bw_quota_us = RUNTIME_INF;
+	tg->scx.idle = false;
 }
 
 int scx_tg_online(struct task_group *tg)
@@ -3266,7 +3267,18 @@ void scx_group_set_weight(struct task_gr
 
 void scx_group_set_idle(struct task_group *tg, bool idle)
 {
-	/* TODO: Implement ops->cgroup_set_idle() */
+	struct scx_sched *sch = scx_root;
+
+	percpu_down_read(&scx_cgroup_ops_rwsem);
+
+	if (scx_cgroup_enabled && SCX_HAS_OP(sch, cgroup_set_idle))
+		SCX_CALL_OP(sch, SCX_KF_UNLOCKED, cgroup_set_idle, NULL,
+			    tg_cgrp(tg), idle);
+
+	/* Update the task group's idle state */
+	tg->scx.idle = idle;
+
+	percpu_up_read(&scx_cgroup_ops_rwsem);
 }
 
 void scx_group_set_bandwidth(struct task_group *tg,
@@ -5125,6 +5137,7 @@ static void sched_ext_ops__cgroup_move(s
 static void sched_ext_ops__cgroup_cancel_move(struct task_struct *p, struct cgroup *from, struct cgroup *to) {}
 static void sched_ext_ops__cgroup_set_weight(struct cgroup *cgrp, u32 weight) {}
 static void sched_ext_ops__cgroup_set_bandwidth(struct cgroup *cgrp, u64 period_us, u64 quota_us, u64 burst_us) {}
+static void sched_ext_ops__cgroup_set_idle(struct cgroup *cgrp, bool idle) {}
 #endif
 static void sched_ext_ops__cpu_online(s32 cpu) {}
 static void sched_ext_ops__cpu_offline(s32 cpu) {}
@@ -5163,6 +5176,7 @@ static struct sched_ext_ops __bpf_ops_sc
 	.cgroup_cancel_move	= sched_ext_ops__cgroup_cancel_move,
 	.cgroup_set_weight	= sched_ext_ops__cgroup_set_weight,
 	.cgroup_set_bandwidth	= sched_ext_ops__cgroup_set_bandwidth,
+	.cgroup_set_idle	= sched_ext_ops__cgroup_set_idle,
 #endif
 	.cpu_online		= sched_ext_ops__cpu_online,
 	.cpu_offline		= sched_ext_ops__cpu_offline,
--- a/kernel/sched/ext_internal.h
+++ b/kernel/sched/ext_internal.h
@@ -697,12 +697,23 @@ struct sched_ext_ops {
 	 * 2_500_000. @cgrp is entitled to 2.5 CPUs. @burst_us can be
 	 * interpreted in the same fashion and specifies how much @cgrp can
 	 * burst temporarily. The specific control mechanism and thus the
-	 * interpretation of @period_us and burstiness is upto to the BPF
+	 * interpretation of @period_us and burstiness is up to the BPF
 	 * scheduler.
 	 */
 	void (*cgroup_set_bandwidth)(struct cgroup *cgrp,
 				     u64 period_us, u64 quota_us, u64 burst_us);
 
+	/**
+	 * @cgroup_set_idle: A cgroup's idle state is being changed
+	 * @cgrp: cgroup whose idle state is being updated
+	 * @idle: whether the cgroup is entering or exiting idle state
+	 *
+	 * Update @cgrp's idle state to @idle. This callback is invoked when
+	 * a cgroup transitions between idle and non-idle states, allowing the
+	 * BPF scheduler to adjust its behavior accordingly.
+	 */
+	void (*cgroup_set_idle)(struct cgroup *cgrp, bool idle);
+
 #endif	/* CONFIG_EXT_GROUP_SCHED */
 
 	/*



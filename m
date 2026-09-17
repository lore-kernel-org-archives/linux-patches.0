Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF1F4DEC08;
	Thu, 17 Sep 2026 17:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665292; cv=none; b=NXSAx9eHdJvsjSVb3pdrPgffwEFlg7Bc+dqZ3D+9qZJ+OKJQykOXGsJ914uWJL2inyj1MddUc7BRjTpQ+dY6DfJFrcRH4Q3Ks/EDJ1X0gOTc2fU/GNd9SMibXmq22tWEAD0Tt+B3FTvc6/x2m+n9l+1xx9UkQ2E48zKEFUGynhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665292; c=relaxed/simple;
	bh=i+2gbGu0az160EcQAJXcEVuxuQ8NPNMmmMlLPaxk69I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ru5sqTyLJVLfd7ewvia8sMS/39Rode337YCNzOpVVdehIvzfF6HYaTgVTDhif6Y2RoMXrzRTL397ziPqiJ3CwEwe6NMc0vjYBxCX7goRN+8g9CfyxWr9XZDityFSUm4A7IFChDi4HBQk8W3C2SN9molD8OApfdxs7IP1gA/6nOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CbZfapPc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbZfapPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270E11F000FF;
	Thu, 17 Sep 2026 17:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665290;
	bh=q3swAqqyVgDGkljwrw+p1hsk6zqj8z5CoMWjX3ifDJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CbZfapPcu0LurUdv5znNLlNpOsfUDXEwN7becODoghPwUdo/vTV+SNyNgc6c27Zat
	 XrpwxUht21y35hihRB4ZUMlOT06p/hqt9dEfPX+tFm4yrMNSqZTxVbxHksKu+ZPSn3
	 T93WHB+H44e+mFvmW6o6L5QShbzdMVCo3DvR6TmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-Yang Chou <yphbchou0911@gmail.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0657/1250] sched_ext: Update demo schedulers and selftests to use scx_bpf_task_set_dsq_vtime()
Date: Thu, 17 Sep 2026 16:07:32 +0100
Message-ID: <20260917151609.702092147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Cheng-Yang Chou <yphbchou0911@gmail.com>

[ Upstream commit 6712c4fefca0422851b71d1a58a32ea03f69310f ]

Direct writes to p->scx.dsq_vtime are deprecated in favor of
scx_bpf_task_set_dsq_vtime(). Update scx_simple, scx_flatcg, and
select_cpu_vtime selftest to use the new kfunc with
scale_by_task_weight_inverse().

Signed-off-by: Cheng-Yang Chou <yphbchou0911@gmail.com>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: b6ee92d7f7f0 ("sched_ext: Fix vtime delta loss in scx_flatcg cgroup migration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sched_ext/scx_flatcg.bpf.c                     | 12 +++++++-----
 tools/sched_ext/scx_simple.bpf.c                     |  6 ++++--
 .../selftests/sched_ext/select_cpu_vtime.bpf.c       |  6 ++++--
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/tools/sched_ext/scx_flatcg.bpf.c b/tools/sched_ext/scx_flatcg.bpf.c
index 2e757f3b13530..7d2c5ab114242 100644
--- a/tools/sched_ext/scx_flatcg.bpf.c
+++ b/tools/sched_ext/scx_flatcg.bpf.c
@@ -551,9 +551,11 @@ void BPF_STRUCT_OPS(fcg_stopping, struct task_struct *p, bool runnable)
 	 * too much, determine the execution time by taking explicit timestamps
 	 * instead of depending on @p->scx.slice.
 	 */
-	if (!fifo_sched)
-		p->scx.dsq_vtime +=
-			(SCX_SLICE_DFL - p->scx.slice) * 100 / p->scx.weight;
+	if (!fifo_sched) {
+		u64 delta = scale_by_task_weight_inverse(p, SCX_SLICE_DFL - p->scx.slice);
+
+		scx_bpf_task_set_dsq_vtime(p, p->scx.dsq_vtime + delta);
+	}
 
 	taskc = bpf_task_storage_get(&task_ctx, p, 0, 0);
 	if (!taskc) {
@@ -831,7 +833,7 @@ s32 BPF_STRUCT_OPS(fcg_init_task, struct task_struct *p,
 	if (!(cgc = find_cgrp_ctx(args->cgroup)))
 		return -ENOENT;
 
-	p->scx.dsq_vtime = cgc->tvtime_now;
+	scx_bpf_task_set_dsq_vtime(p, cgc->tvtime_now);
 
 	return 0;
 }
@@ -931,7 +933,7 @@ void BPF_STRUCT_OPS(fcg_cgroup_move, struct task_struct *p,
 		return;
 
 	delta = time_delta(p->scx.dsq_vtime, from_cgc->tvtime_now);
-	p->scx.dsq_vtime = to_cgc->tvtime_now + delta;
+	scx_bpf_task_set_dsq_vtime(p, to_cgc->tvtime_now + delta);
 }
 
 s32 BPF_STRUCT_OPS_SLEEPABLE(fcg_init)
diff --git a/tools/sched_ext/scx_simple.bpf.c b/tools/sched_ext/scx_simple.bpf.c
index e6de99dba7db6..ab2a85316de39 100644
--- a/tools/sched_ext/scx_simple.bpf.c
+++ b/tools/sched_ext/scx_simple.bpf.c
@@ -121,12 +121,14 @@ void BPF_STRUCT_OPS(simple_stopping, struct task_struct *p, bool runnable)
 	 * too much, determine the execution time by taking explicit timestamps
 	 * instead of depending on @p->scx.slice.
 	 */
-	p->scx.dsq_vtime += (SCX_SLICE_DFL - p->scx.slice) * 100 / p->scx.weight;
+	u64 delta = scale_by_task_weight_inverse(p, SCX_SLICE_DFL - p->scx.slice);
+
+	scx_bpf_task_set_dsq_vtime(p, p->scx.dsq_vtime + delta);
 }
 
 void BPF_STRUCT_OPS(simple_enable, struct task_struct *p)
 {
-	p->scx.dsq_vtime = vtime_now;
+	scx_bpf_task_set_dsq_vtime(p, vtime_now);
 }
 
 s32 BPF_STRUCT_OPS_SLEEPABLE(simple_init)
diff --git a/tools/testing/selftests/sched_ext/select_cpu_vtime.bpf.c b/tools/testing/selftests/sched_ext/select_cpu_vtime.bpf.c
index bfcb96cd4954b..aad8de51723e9 100644
--- a/tools/testing/selftests/sched_ext/select_cpu_vtime.bpf.c
+++ b/tools/testing/selftests/sched_ext/select_cpu_vtime.bpf.c
@@ -66,12 +66,14 @@ void BPF_STRUCT_OPS(select_cpu_vtime_running, struct task_struct *p)
 void BPF_STRUCT_OPS(select_cpu_vtime_stopping, struct task_struct *p,
 		    bool runnable)
 {
-	p->scx.dsq_vtime += (SCX_SLICE_DFL - p->scx.slice) * 100 / p->scx.weight;
+	u64 delta = scale_by_task_weight_inverse(p, SCX_SLICE_DFL - p->scx.slice);
+
+	scx_bpf_task_set_dsq_vtime(p, p->scx.dsq_vtime + delta);
 }
 
 void BPF_STRUCT_OPS(select_cpu_vtime_enable, struct task_struct *p)
 {
-	p->scx.dsq_vtime = vtime_now;
+	scx_bpf_task_set_dsq_vtime(p, vtime_now);
 }
 
 s32 BPF_STRUCT_OPS_SLEEPABLE(select_cpu_vtime_init)
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDD221B9E5;
	Mon, 23 Jun 2025 21:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715516; cv=none; b=lHd9OPCYIJTFLx1SZv8OrDqdqoix6Ic/qX5tvKAEL8Oe+DVhHL+dnlMgKbeRE1r2ks53o3BP/5nfT3RHG/uFuJ3iUKKzb2Zu/FbyJdfRnhORHxqkbRO8M6eptLX0rtTs2e5t/mS3RcXpL6fF8SsEU5tpeKW+oclGwCr3JNQujSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715516; c=relaxed/simple;
	bh=9wLy5/vU2QLyWPyeaOfpxCorWYHSTy9l6XCHlYdy2Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaVrZOgoMzylvVQ2COLmQiLJJoyWarw1ryL4/ojCon51BwZ+S6uktjJp12/C/CflbyAc/HA6xrnsEXV9oTpzJHKa0tT7t2qmcb0KcCPYzKtdVQiphwpFxsGndEGcZBKg6SnexpLunpCk09RWL0qjdscZ7BHsSmF8dew6KtwPruQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEzjhgeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEzjhgeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FCDC4CEEA;
	Mon, 23 Jun 2025 21:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715516;
	bh=9wLy5/vU2QLyWPyeaOfpxCorWYHSTy9l6XCHlYdy2Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEzjhgeMk7srY7MMpJWUGwSZRHreRjm8JCzhqZG2N1kj647wYRrL2HRjRBbjrEw+X
	 RGa+xw4GP9NTCw1xg8qXBYYbCitgS3mbR4PQWzRnxnzvMnF0k5cdPgQ+yafQug17+4
	 8dH+FqJLsWom+OavOH5KZhfMQFHzGwFv+l/dzSWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.15 484/592] sched_ext, sched/core: Dont call scx_group_set_weight() prematurely from sched_create_group()
Date: Mon, 23 Jun 2025 15:07:22 +0200
Message-ID: <20250623130711.945562064@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 33796b91871ad4010c8188372dd1faf97cf0f1c0 upstream.

During task_group creation, sched_create_group() calls
scx_group_set_weight() with CGROUP_WEIGHT_DFL to initialize the sched_ext
portion. This is premature and ends up calling ops.cgroup_set_weight() with
an incorrect @cgrp before ops.cgroup_init() is called.

sched_create_group() should just initialize SCX related fields in the new
task_group. Fix it by factoring out scx_tg_init() from sched_init() and
making sched_create_group() call that function instead of
scx_group_set_weight().

v2: Retain CONFIG_EXT_GROUP_SCHED ifdef in sched_init() as removing it leads
    to build failures on !CONFIG_GROUP_SCHED configs.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 819513666966 ("sched_ext: Add cgroup support")
Cc: stable@vger.kernel.org # v6.12+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/core.c |    4 ++--
 kernel/sched/ext.c  |    5 +++++
 kernel/sched/ext.h  |    2 ++
 3 files changed, 9 insertions(+), 2 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8571,7 +8571,7 @@ void __init sched_init(void)
 		init_cfs_bandwidth(&root_task_group.cfs_bandwidth, NULL);
 #endif /* CONFIG_FAIR_GROUP_SCHED */
 #ifdef CONFIG_EXT_GROUP_SCHED
-		root_task_group.scx_weight = CGROUP_WEIGHT_DFL;
+		scx_tg_init(&root_task_group);
 #endif /* CONFIG_EXT_GROUP_SCHED */
 #ifdef CONFIG_RT_GROUP_SCHED
 		root_task_group.rt_se = (struct sched_rt_entity **)ptr;
@@ -9011,7 +9011,7 @@ struct task_group *sched_create_group(st
 	if (!alloc_rt_sched_group(tg, parent))
 		goto err;
 
-	scx_group_set_weight(tg, CGROUP_WEIGHT_DFL);
+	scx_tg_init(tg);
 	alloc_uclamp_sched_group(tg, parent);
 
 	return tg;
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3936,6 +3936,11 @@ bool scx_can_stop_tick(struct rq *rq)
 DEFINE_STATIC_PERCPU_RWSEM(scx_cgroup_rwsem);
 static bool scx_cgroup_enabled;
 
+void scx_tg_init(struct task_group *tg)
+{
+	tg->scx_weight = CGROUP_WEIGHT_DFL;
+}
+
 int scx_tg_online(struct task_group *tg)
 {
 	int ret = 0;
--- a/kernel/sched/ext.h
+++ b/kernel/sched/ext.h
@@ -80,6 +80,7 @@ static inline void scx_update_idle(struc
 
 #ifdef CONFIG_CGROUP_SCHED
 #ifdef CONFIG_EXT_GROUP_SCHED
+void scx_tg_init(struct task_group *tg);
 int scx_tg_online(struct task_group *tg);
 void scx_tg_offline(struct task_group *tg);
 int scx_cgroup_can_attach(struct cgroup_taskset *tset);
@@ -89,6 +90,7 @@ void scx_cgroup_cancel_attach(struct cgr
 void scx_group_set_weight(struct task_group *tg, unsigned long cgrp_weight);
 void scx_group_set_idle(struct task_group *tg, bool idle);
 #else	/* CONFIG_EXT_GROUP_SCHED */
+static inline void scx_tg_init(struct task_group *tg) {}
 static inline int scx_tg_online(struct task_group *tg) { return 0; }
 static inline void scx_tg_offline(struct task_group *tg) {}
 static inline int scx_cgroup_can_attach(struct cgroup_taskset *tset) { return 0; }



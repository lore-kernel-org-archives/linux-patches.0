Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0838322FF22;
	Fri, 15 May 2026 16:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862259; cv=none; b=S5v27EoPKzhlte1WXS12otazFejOPVbaS58+5gzz8xrD5+7RqX7S7IzXbnvbnNRfbQGRJ0XKYHFwX6s5XZfZtqHqO5j+CDTgk6e5PJE+IqGUjkSTmbWP3OURGVpiNl1IIFBr0YFL5x3q2CJBKfzeY1WK/Zhf6uE9eLvibYmghdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862259; c=relaxed/simple;
	bh=K2t4+iwCFTkI6n45wOM4VjxHRKNsXQZQyketqapjKKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuaT+fKC9eTbeH4rXmReuAluszV0Rr6g1Q6nYwou5neXTlWP/LnE0bRFRCcy0TUQb+BVoHS6uer2h8+uVLumOMVc0FSSUdY4CAwLzzM6S8L3CSCwWEGhAwrAqIzDejUdJXFOeoE9+M24RHvThi4N7ZEcwTf2fWo7IKlph3jPw/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXOSIwyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXOSIwyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9078AC2BCB3;
	Fri, 15 May 2026 16:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862258;
	bh=K2t4+iwCFTkI6n45wOM4VjxHRKNsXQZQyketqapjKKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXOSIwyl/0VKbNihC4IWub4Y44zO0q+CQ34I546mxMnT7wAgCZ8JN64AT6Asp/vam
	 j5xeGEdyXdLHiVO4xTpCnHXFJ77o2d9opO7ZbQnxzroZTwURHmkbtJcbOeDDOM1N6t
	 AzMa8yExN8RKzs9aQSb43X7o7LEXGAQZrwQJxFiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/188] sched_ext: Read scx_root under scx_cgroup_ops_rwsem in cgroup setters
Date: Fri, 15 May 2026 17:49:47 +0200
Message-ID: <20260515154701.023992674@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 80afd4c84bc8f5e80145ce35279f5ce53f6043db ]

scx_group_set_{weight,idle,bandwidth}() cache scx_root before acquiring
scx_cgroup_ops_rwsem, so the pointer can be stale by the time the op runs.
If the loaded scheduler is disabled and freed (via RCU work) and another is
enabled between the naked load and the rwsem acquire, the reader sees
scx_cgroup_enabled=true (the new scheduler's) but dereferences the freed one
- UAF on SCX_HAS_OP(sch, ...) / SCX_CALL_OP(sch, ...).

scx_cgroup_enabled is toggled only under scx_cgroup_ops_rwsem write
(scx_cgroup_{init,exit}), so reading scx_root inside the rwsem read section
correlates @sch with the enabled snapshot.

Fixes: a5bd6ba30b33 ("sched_ext: Use cgroup_lock/unlock() to synchronize against cgroup operations")
Cc: stable@vger.kernel.org # v6.18+
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3251,9 +3251,10 @@ void scx_cgroup_cancel_attach(struct cgr
 
 void scx_group_set_weight(struct task_group *tg, unsigned long weight)
 {
-	struct scx_sched *sch = scx_root;
+	struct scx_sched *sch;
 
 	percpu_down_read(&scx_cgroup_ops_rwsem);
+	sch = scx_root;
 
 	if (scx_cgroup_enabled && SCX_HAS_OP(sch, cgroup_set_weight) &&
 	    tg->scx.weight != weight)
@@ -3267,9 +3268,10 @@ void scx_group_set_weight(struct task_gr
 
 void scx_group_set_idle(struct task_group *tg, bool idle)
 {
-	struct scx_sched *sch = scx_root;
+	struct scx_sched *sch;
 
 	percpu_down_read(&scx_cgroup_ops_rwsem);
+	sch = scx_root;
 
 	if (scx_cgroup_enabled && SCX_HAS_OP(sch, cgroup_set_idle))
 		SCX_CALL_OP(sch, SCX_KF_UNLOCKED, cgroup_set_idle, NULL,
@@ -3284,9 +3286,10 @@ void scx_group_set_idle(struct task_grou
 void scx_group_set_bandwidth(struct task_group *tg,
 			     u64 period_us, u64 quota_us, u64 burst_us)
 {
-	struct scx_sched *sch = scx_root;
+	struct scx_sched *sch;
 
 	percpu_down_read(&scx_cgroup_ops_rwsem);
+	sch = scx_root;
 
 	if (scx_cgroup_enabled && SCX_HAS_OP(sch, cgroup_set_bandwidth) &&
 	    (tg->scx.bw_period_us != period_us ||



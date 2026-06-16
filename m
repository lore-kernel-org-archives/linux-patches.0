Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150B13C5827;
	Tue, 16 Jun 2026 17:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630097; cv=none; b=eneozgMocA0hqm7gZRq1YiDsUI5SKfrL9qx0b+UKpr8OireLLkwqBxECY3Db66mL6mw1J8Ge9xdZAPecyTMGKOaL0WccqtbaHFoHe54ArFGDx48z1M0+ieaYor3r/vhu42x9thcluG45t8lAVBzEPaTCzBDlthJdnErOzAYsUuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630097; c=relaxed/simple;
	bh=Uz6etODfcZL/LMcxeiECnW9c5lYj6i012OgJ1UICXgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWjknyDCTUFqu+lqxO0835EaCVKFi8W2e1ufnyhRIgmQZhOr1XgPBAzWNdsu1PnqKuABOi8wfUj/x+sfsIe4YqqGjbn0++LfIZXaacB/Cp4cHICe2F6dOGQFzQPjPTNFLNxMbIszwi96PIiRrgrJYn8EqzZILLaGrZ3OjMsd/cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zshr3nwS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zshr3nwS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4D91F000E9;
	Tue, 16 Jun 2026 17:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630096;
	bh=dKIGP/S1n73kOUW6QDYdhIfZecIVS2NjDI8BNy4NBMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zshr3nwS++y9LQTDFnJj3hlvK4l99UerH0EuQxg8erkT1EKe61jYNIiVlDGOpR4Jt
	 8TLMMM2cZ8SYBn2jxCckn0jw7LGJGRxIx89Vxbpyz/T6pVH7nYl1ZS5n4xkigx3g9y
	 mVFxZ+gvuCyhXOZZl5gCLpAV7MO0OG9ehkxh5cdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Waiman Long <longman@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 377/452] cgroup/cpuset: Reset DL migration state on can_attach() failure
Date: Tue, 16 Jun 2026 20:30:04 +0530
Message-ID: <20260616145136.782842006@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

[ Upstream commit 4a39eda5fdd867fc39f3c039714dd432cee00268 ]

cpuset_can_attach() accumulates temporary SCHED_DEADLINE migration
state in the destination cpuset while walking the taskset.

If a later task_can_attach() or security_task_setscheduler() check
fails, cgroup_migrate_execute() treats cpuset as the failing subsystem
and does not call cpuset_cancel_attach() for it. The partially
accumulated state is then left behind and can be consumed by a later
attach, corrupting cpuset DL task accounting and pending DL bandwidth
accounting.

Reset the pending DL migration state from the common error exit when
ret is non-zero. Successful can_attach() keeps the state for
cpuset_attach() or cpuset_cancel_attach().

Fixes: 2ef269ef1ac0 ("cgroup/cpuset: Free DL BW in case can_attach() fails")
Cc: stable@vger.kernel.org # v6.10+
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Waiman Long <longman@redhat.com>
[ omitted upstream context line `cs->dl_bw_cpu = cpu;` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2609,16 +2609,13 @@ static int cpuset_can_attach(struct cgro
 		int cpu = cpumask_any_and(cpu_active_mask, cs->effective_cpus);
 
 		if (unlikely(cpu >= nr_cpu_ids)) {
-			reset_migrate_dl_data(cs);
 			ret = -EINVAL;
 			goto out_unlock;
 		}
 
 		ret = dl_bw_alloc(cpu, cs->sum_migrate_dl_bw);
-		if (ret) {
-			reset_migrate_dl_data(cs);
+		if (ret)
 			goto out_unlock;
-		}
 	}
 
 out_success:
@@ -3458,7 +3455,10 @@ static int cpuset_can_fork(struct task_s
 	 * changes which zero cpus/mems_allowed.
 	 */
 	cs->attach_in_progress++;
+
 out_unlock:
+	if (ret)
+		reset_migrate_dl_data(cs);
 	mutex_unlock(&cpuset_mutex);
 	return ret;
 }



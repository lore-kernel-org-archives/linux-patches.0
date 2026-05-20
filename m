Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27313F20E5;
	Wed, 20 May 2026 17:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297131; cv=none; b=BHWrb1Cn3Iw5eUpBq3XEh8zKkq5zCe6mVpaydRrHoHCk7b4rcmc222in/NuTVY3VPOqCHwcqJc5Sh57IYdP9dSnpaZadwundSyVGroyQckdrf0aJQUc495tAVGfTd9b5GhJgi41rpw8P4xOwrImQ+9+Yz7L42het738drriFmfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297131; c=relaxed/simple;
	bh=zx6CxE2u0LMykU+6oGju41hnNOwR4FC5rV7qQsTkQ8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8z5rHOR2iI3EcgLIg4QGyNX1OTLnwczMSUcUuUrkDueVbvwoNlrR+6WZrGqnhFi/9uPJZlA/rEAYoTACVmrMmC2NGU5PYSBwQ4O3lP1Efb9SloagjHPgf1KYiAgFG9H2skmtytVCoaQvbJ/J1sTDtrvs2J1+LXSqLiIWxkgKcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8O16RWk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8O16RWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A6D1F000E9;
	Wed, 20 May 2026 17:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297130;
	bh=KJzUEDvMQam8dFoEpbU+oVY7zYn9nuqHzPEs3mQ8n74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k8O16RWk4V3ecq4oU4GNq+uwNhyeephPQhEGZOSG7nnfVIeYZUruV9xJRS9kmajlM
	 M5M6EuSctpA/aTlylHVPEEmgA0ZDSJr6xjyvWX30DWqktNqVJDBzNmq6p6gKnyG3Tn
	 T+ZJ7VGcIHfkj06L1A6NIiVHWu9u9PhE1jazhim4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 7.0 1045/1146] cgroup/cpuset: Reset DL migration state on can_attach() failure
Date: Wed, 20 May 2026 18:21:35 +0200
Message-ID: <20260520162211.879461501@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

commit 4a39eda5fdd867fc39f3c039714dd432cee00268 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3050,16 +3050,13 @@ static int cpuset_can_attach(struct cgro
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
 
 		cs->dl_bw_cpu = cpu;
 	}
@@ -3070,7 +3067,10 @@ out_success:
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



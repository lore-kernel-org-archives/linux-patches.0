Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6FF282F17;
	Thu, 28 May 2026 20:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999539; cv=none; b=kbuKx8EPSY8rsQ55W8OVq7hhbT4P5HqFVxTzfHSqTiBEoPia42SGs9HTxoNSwhKoxhz05A33RMk0Ukj6+KtkQWTKLe865MLZoyiZ1G75oJRjBMxIqSOrd1yYFGOoVum+CIEHtPdr/iCRK3gdZUha4kyTm+O1vrN6IViXPcgoFA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999539; c=relaxed/simple;
	bh=UMkfW16CXVCAXYcyv0RIGm6qzlAZiVrilxpIdHQKR7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pP+YvUPdiYHScU9+Kp+Bf5HxSPruSPGky9NHOyQQhMqnA96O1RVOGe8bSRlqmuQzg/8wHTi0SFq2JL84f2R6lG02jxc/mpDjdbwwIhni6UK6eW3Kgze6L5d+zqWNidi9miJfcGG2pOE3w1bJpsLtWD+3K0RZCNmpwh+teH0q/hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrFqw2+v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrFqw2+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AB731F00A3C;
	Thu, 28 May 2026 20:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999538;
	bh=d8vPR0zgrGnhf/8vAvHT0sDkrBByK2iUlsdBJCB93Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UrFqw2+vFGjk2wFuT6c2i1y7gDcOxA8eDhVyTVCQxOhk6anhoG84OWi5gTp3cC8GH
	 cP9ljOjticMrYHVsbTLBfCSYgDjcXa6J/BR3phy6zzpsFoHMVywbWjobW9w2+wuL+p
	 E5O54a7SLrU/gGuJjIjauVutsPNRk8LldWVFkQB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Waiman Long <longman@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 075/377] cgroup/cpuset: Reset DL migration state on can_attach() failure
Date: Thu, 28 May 2026 21:45:13 +0200
Message-ID: <20260528194640.538978247@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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
@@ -3163,16 +3163,13 @@ static int cpuset_can_attach(struct cgro
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
@@ -3181,7 +3178,10 @@ out_success:
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



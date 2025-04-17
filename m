Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421641DB148;
	Thu, 17 Apr 2025 18:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913818; cv=none; b=lZ86ZtndT331WsroxBekvjL9LUiU839LDd+Vf82fq+mihHxrQhf2ShzHj2ppH1y5yUAwRxPzP2K0OIPbHkM/nbmW949QjAPDo3rLS+4mSf9LtyP+QbC5I+gEMhm/UAxQvIophDnr0tGZMvyJTZuzRxnj9u2K5qWh/dZNS0pYSDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913818; c=relaxed/simple;
	bh=MulGWxLhCuoiIu3xqBZwygKLU0twDAcJ6IZRiXWYxn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdTWE3j323qGXvCBW7LzDr6I0Jhyxce3WiWAWkGrXk9hJB5AORsA/uH3ylUmqoGOF9TpVhdCqXbk81LHJaxY9diEzggeTcgw8y1eu76Fo0s7z5onz0TMGFqE9iwb1wMT0PxDNNUTIfKE84laWLZIb9d0t9QdZ5GJ1NCDqGBuLaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/S0PYDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/S0PYDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86385C4CEEA;
	Thu, 17 Apr 2025 18:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913818;
	bh=MulGWxLhCuoiIu3xqBZwygKLU0twDAcJ6IZRiXWYxn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/S0PYDFUHn6uqEpkk4Ck4ZpZ24qIcnU46NiYYFFH+ol2RuwoIeBTleEDj+KNx6M+
	 EckoVE93zjlwY6cH5Zp+NCg78FLdTH2dhgWY5D+oaQcYBOcYMLj/YTiA7NNjDeL77F
	 dOLUgNUbj0UkiuiHABYZlqDmK8dEbrA73r0GFMCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 003/414] cgroup/cpuset: Fix error handling in remote_partition_disable()
Date: Thu, 17 Apr 2025 19:46:01 +0200
Message-ID: <20250417175111.535259306@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 8bf450f3aec3d1bbd725d179502c64b8992588e4 ]

When remote_partition_disable() is called to disable a remote partition,
it always sets the partition to an invalid partition state. It should
only do so if an error code (prs_err) has been set. Correct that and
add proper error code in places where remote_partition_disable() is
called due to error.

Fixes: 181c8e091aae ("cgroup/cpuset: Introduce remote partition")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 02f3e9d076894..6c41968bcf4b0 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1407,6 +1407,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 	list_add(&cs->remote_sibling, &remote_children);
 	spin_unlock_irq(&callback_lock);
 	update_unbound_workqueue_cpumask(isolcpus_updated);
+	cs->prs_err = 0;
 
 	/*
 	 * Propagate changes in top_cpuset's effective_cpus down the hierarchy.
@@ -1437,9 +1438,11 @@ static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
 	list_del_init(&cs->remote_sibling);
 	isolcpus_updated = partition_xcpus_del(cs->partition_root_state,
 					       NULL, tmp->new_cpus);
-	cs->partition_root_state = -cs->partition_root_state;
-	if (!cs->prs_err)
-		cs->prs_err = PERR_INVCPUS;
+	if (cs->prs_err)
+		cs->partition_root_state = -cs->partition_root_state;
+	else
+		cs->partition_root_state = PRS_MEMBER;
+
 	reset_partition_data(cs);
 	spin_unlock_irq(&callback_lock);
 	update_unbound_workqueue_cpumask(isolcpus_updated);
@@ -1472,8 +1475,10 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *newmask,
 
 	WARN_ON_ONCE(!cpumask_subset(cs->effective_xcpus, subpartitions_cpus));
 
-	if (cpumask_empty(newmask))
+	if (cpumask_empty(newmask)) {
+		cs->prs_err = PERR_CPUSEMPTY;
 		goto invalidate;
+	}
 
 	adding   = cpumask_andnot(tmp->addmask, newmask, cs->effective_xcpus);
 	deleting = cpumask_andnot(tmp->delmask, cs->effective_xcpus, newmask);
@@ -1483,10 +1488,15 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *newmask,
 	 * not allocated to other partitions and there are effective_cpus
 	 * left in the top cpuset.
 	 */
-	if (adding && (!capable(CAP_SYS_ADMIN) ||
-		       cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
-		       cpumask_subset(top_cpuset.effective_cpus, tmp->addmask)))
-		goto invalidate;
+	if (adding) {
+		if (!capable(CAP_SYS_ADMIN))
+			cs->prs_err = PERR_ACCESS;
+		else if (cpumask_intersects(tmp->addmask, subpartitions_cpus) ||
+			 cpumask_subset(top_cpuset.effective_cpus, tmp->addmask))
+			cs->prs_err = PERR_NOCPUS;
+		if (cs->prs_err)
+			goto invalidate;
+	}
 
 	spin_lock_irq(&callback_lock);
 	if (adding)
@@ -1602,7 +1612,7 @@ static bool prstate_housekeeping_conflict(int prstate, struct cpumask *new_cpus)
  * The partcmd_update command is used by update_cpumasks_hier() with newmask
  * NULL and update_cpumask() with newmask set. The partcmd_invalidate is used
  * by update_cpumask() with NULL newmask. In both cases, the callers won't
- * check for error and so partition_root_state and prs_error will be updated
+ * check for error and so partition_root_state and prs_err will be updated
  * directly.
  */
 static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
@@ -3740,6 +3750,7 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 
 	if (remote && cpumask_empty(&new_cpus) &&
 	    partition_is_populated(cs, NULL)) {
+		cs->prs_err = PERR_HOTPLUG;
 		remote_partition_disable(cs, tmp);
 		compute_effective_cpumask(&new_cpus, cs, parent);
 		remote = false;
-- 
2.39.5




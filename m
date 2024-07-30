Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5BD1B5831;
	Tue, 30 Jul 2024 15:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355051; cv=none; b=bmMLLMnGZ1uQy6PYamZnkB7JIWbepowuRkNmVrEnIJbRbg3JW1sOXaKOkJVbA6q3wgoBsT0/OavmzrJ2Aw8boNpPzn9Op+8r4pl4N1NYZ+GCDWy5LgQHfDkbOmQpD/7LHZDCUoSWBXWwZbxF8kob4Rvo/nwXD2TQGOhmAzyjJsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355051; c=relaxed/simple;
	bh=jJzUG3EuNmci8SyEKNDHVYVm/8BoFs+/syceapt3diA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIJpINYAkUzWzWo5x3Mq7yl9+DmsHXiRvRLHW+s8KLCjXAGpLMJDmXkvKaV9NqMRiwYOo2B1M73ltF60+lGlzGFdIipqqXwlXCRtTWPhYpXMsbgZ65Oex9SVH3N62C8Ybn//pbVSMjyzF6SJ+JBjl9pbpfa9l4B88TkW4cXrKiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrOcog8W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrOcog8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90529C32782;
	Tue, 30 Jul 2024 15:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355051;
	bh=jJzUG3EuNmci8SyEKNDHVYVm/8BoFs+/syceapt3diA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrOcog8WwOIZcMxWm8NWvk5gwNNpqF6LTdwa/u0IfL9rsayagBzGmNF7+4fu2g/fW
	 DPVzPX7GNs2PRhc3EXrTH9x0pYDExOtzcf+uxMGGfMUvg9vdFbQQK5VoBBp8T6YwUi
	 iTEtGKjvFjwB9RfNMkyNTFfvEyIY4L608M/yhSKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 015/809] cgroup/cpuset: Fix remote root partition creation problem
Date: Tue, 30 Jul 2024 17:38:11 +0200
Message-ID: <20240730151725.262561831@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit ccac8e8de99cbcf5e7f53251ebce917bf7bcc29c ]

Since commit 181c8e091aae ("cgroup/cpuset: Introduce remote partition"),
a remote partition can be created underneath a non-partition root cpuset
as long as its exclusive_cpus are set to distribute exclusive CPUs down
to its children. The generate_sched_domains() function, however, doesn't
take into account this new behavior and hence will fail to create the
sched domain needed for a remote root (non-isolated) partition.

There are two issues related to remote partition support. First of
all, generate_sched_domains() has a fast path that is activated if
root_load_balance is true and top_cpuset.nr_subparts is non-zero. The
later condition isn't quite correct for remote partitions as nr_subparts
just shows the number of local child partitions underneath it. There
can be no local child partition under top_cpuset even if there are
remote partitions further down the hierarchy. Fix that by checking
for subpartitions_cpus which contains exclusive CPUs allocated to both
local and remote partitions.

Secondly, the valid partition check for subtree skipping in the csa[]
generation loop isn't enough as remote partition does not need to
have a partition root parent. Fix this problem by breaking csa[] array
generation loop of generate_sched_domains() into v1 and v2 specific parts
and checking a cpuset's exclusive_cpus before skipping its subtree in
the v2 case.

Also simplify generate_sched_domains() for cgroup v2 as only
non-isolating partition roots should be included in building the cpuset
array and none of the v1 scheduling attributes other than a different
way to create an isolated partition are supported.

Fixes: 181c8e091aae ("cgroup/cpuset: Introduce remote partition")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 55 ++++++++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 13 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 73ab45b04c000..a29de57540d71 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -169,7 +169,7 @@ struct cpuset {
 	/* for custom sched domain */
 	int relax_domain_level;
 
-	/* number of valid sub-partitions */
+	/* number of valid local child partitions */
 	int nr_subparts;
 
 	/* partition root state */
@@ -957,13 +957,14 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	int nslot;		/* next empty doms[] struct cpumask slot */
 	struct cgroup_subsys_state *pos_css;
 	bool root_load_balance = is_sched_load_balance(&top_cpuset);
+	bool cgrpv2 = cgroup_subsys_on_dfl(cpuset_cgrp_subsys);
 
 	doms = NULL;
 	dattr = NULL;
 	csa = NULL;
 
 	/* Special case for the 99% of systems with one, full, sched domain */
-	if (root_load_balance && !top_cpuset.nr_subparts) {
+	if (root_load_balance && cpumask_empty(subpartitions_cpus)) {
 single_root_domain:
 		ndoms = 1;
 		doms = alloc_sched_domains(ndoms);
@@ -992,16 +993,18 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	cpuset_for_each_descendant_pre(cp, pos_css, &top_cpuset) {
 		if (cp == &top_cpuset)
 			continue;
+
+		if (cgrpv2)
+			goto v2;
+
 		/*
+		 * v1:
 		 * Continue traversing beyond @cp iff @cp has some CPUs and
 		 * isn't load balancing.  The former is obvious.  The
 		 * latter: All child cpusets contain a subset of the
 		 * parent's cpus, so just skip them, and then we call
 		 * update_domain_attr_tree() to calc relax_domain_level of
 		 * the corresponding sched domain.
-		 *
-		 * If root is load-balancing, we can skip @cp if it
-		 * is a subset of the root's effective_cpus.
 		 */
 		if (!cpumask_empty(cp->cpus_allowed) &&
 		    !(is_sched_load_balance(cp) &&
@@ -1009,16 +1012,28 @@ static int generate_sched_domains(cpumask_var_t **domains,
 					 housekeeping_cpumask(HK_TYPE_DOMAIN))))
 			continue;
 
-		if (root_load_balance &&
-		    cpumask_subset(cp->cpus_allowed, top_cpuset.effective_cpus))
-			continue;
-
 		if (is_sched_load_balance(cp) &&
 		    !cpumask_empty(cp->effective_cpus))
 			csa[csn++] = cp;
 
-		/* skip @cp's subtree if not a partition root */
-		if (!is_partition_valid(cp))
+		/* skip @cp's subtree */
+		pos_css = css_rightmost_descendant(pos_css);
+		continue;
+
+v2:
+		/*
+		 * Only valid partition roots that are not isolated and with
+		 * non-empty effective_cpus will be saved into csn[].
+		 */
+		if ((cp->partition_root_state == PRS_ROOT) &&
+		    !cpumask_empty(cp->effective_cpus))
+			csa[csn++] = cp;
+
+		/*
+		 * Skip @cp's subtree if not a partition root and has no
+		 * exclusive CPUs to be granted to child cpusets.
+		 */
+		if (!is_partition_valid(cp) && cpumask_empty(cp->exclusive_cpus))
 			pos_css = css_rightmost_descendant(pos_css);
 	}
 	rcu_read_unlock();
@@ -1072,6 +1087,20 @@ static int generate_sched_domains(cpumask_var_t **domains,
 	dattr = kmalloc_array(ndoms, sizeof(struct sched_domain_attr),
 			      GFP_KERNEL);
 
+	/*
+	 * Cgroup v2 doesn't support domain attributes, just set all of them
+	 * to SD_ATTR_INIT. Also non-isolating partition root CPUs are a
+	 * subset of HK_TYPE_DOMAIN housekeeping CPUs.
+	 */
+	if (cgrpv2) {
+		for (i = 0; i < ndoms; i++) {
+			cpumask_copy(doms[i], csa[i]->effective_cpus);
+			if (dattr)
+				dattr[i] = SD_ATTR_INIT;
+		}
+		goto done;
+	}
+
 	for (nslot = 0, i = 0; i < csn; i++) {
 		struct cpuset *a = csa[i];
 		struct cpumask *dp;
@@ -1231,7 +1260,7 @@ static void rebuild_sched_domains_locked(void)
 	 * root should be only a subset of the active CPUs.  Since a CPU in any
 	 * partition root could be offlined, all must be checked.
 	 */
-	if (top_cpuset.nr_subparts) {
+	if (!cpumask_empty(subpartitions_cpus)) {
 		rcu_read_lock();
 		cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
 			if (!is_partition_valid(cs)) {
@@ -4579,7 +4608,7 @@ static void cpuset_handle_hotplug(void)
 	 * In the rare case that hotplug removes all the cpus in
 	 * subpartitions_cpus, we assumed that cpus are updated.
 	 */
-	if (!cpus_updated && top_cpuset.nr_subparts)
+	if (!cpus_updated && !cpumask_empty(subpartitions_cpus))
 		cpus_updated = true;
 
 	/* For v1, synchronize cpus_allowed to cpu_active_mask */
-- 
2.43.0




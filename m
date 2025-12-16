Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1C136C5A3;
	Tue, 16 Dec 2025 12:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887949; cv=none; b=KTC8PcZJ+QaWu4AAkv7k8daBUpqRdv+wYN36qbn0B30h6+VihAfQGlPlNSlNQRDm9qtV8tmoPk1qx9i9roa+B9O6Lg05OFxx8Y9k0H5fHDZHClIuV0QDe374sVLaoF4g5wyr0Wmyjt/O+VmYv5iQkxS8Vhc4b+mTfmWf+5srf70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887949; c=relaxed/simple;
	bh=JjOY5AC4OjZcFwlN4C+N0fX5XrNMqYnv9SIvX1D8Vxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYrI1xG2ZcoLFK5BDEO6lsX47rSsuv0d2cfAWMblqM5anuBvTxSYQ2oJuKlG/5OEWhjfLppwoQgv+kTGs7/HZ51mt6u1Hebpc5y75Y7xUcb3Aiho43uXQOZpcVQ+RgmI/QnDcxKKaioEHGLVVLvfDzZMeMd5KrZ9spasvjVS8Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IfKCVEPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IfKCVEPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C619CC4CEF1;
	Tue, 16 Dec 2025 12:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887949;
	bh=JjOY5AC4OjZcFwlN4C+N0fX5XrNMqYnv9SIvX1D8Vxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfKCVEPuPjQuQlaTEeE//s0+jZmB5OPmY07uf3Mgg0mkXpnMLV2npH2NSRDvQcdoZ
	 dzzhX1syb1LTfb6f/CTMNr54RnRArRj6CYMpxc4SuUrDFWiHzNOs8JPje161FupUUo
	 hoQrjEM7QX1kdEhcrSfPpqPjbi8dXSX81Vyp5KoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 354/614] cpuset: Treat cpusets in attaching as populated
Date: Tue, 16 Dec 2025 12:12:01 +0100
Message-ID: <20251216111414.188059104@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit b1bcaed1e39a9e0dfbe324a15d2ca4253deda316 ]

Currently, the check for whether a partition is populated does not
account for tasks in the cpuset of attaching. This is a corner case
that can leave a task stuck in a partition with no effective CPUs.

The race condition occurs as follows:

cpu0				cpu1
				//cpuset A  with cpu N
migrate task p to A
cpuset_can_attach
// with effective cpus
// check ok

// cpuset_mutex is not held	// clear cpuset.cpus.exclusive
				// making effective cpus empty
				update_exclusive_cpumask
				// tasks_nocpu_error check ok
				// empty effective cpus, partition valid
cpuset_attach
...
// task p stays in A, with non-effective cpus.

To fix this issue, this patch introduces cs_is_populated, which considers
tasks in the attaching cpuset. This new helper is used in validate_change
and partition_is_populated.

Fixes: e2d59900d936 ("cgroup/cpuset: Allow no-task partition to have empty cpuset.cpus.effective")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 52468d2c178a3..4dcd633fd6df5 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -352,6 +352,15 @@ static inline bool is_in_v2_mode(void)
 	      (cpuset_cgrp_subsys.root->flags & CGRP_ROOT_CPUSET_V2_MODE);
 }
 
+static inline bool cpuset_is_populated(struct cpuset *cs)
+{
+	lockdep_assert_held(&cpuset_mutex);
+
+	/* Cpusets in the process of attaching should be considered as populated */
+	return cgroup_is_populated(cs->css.cgroup) ||
+		cs->attach_in_progress;
+}
+
 /**
  * partition_is_populated - check if partition has tasks
  * @cs: partition root to be checked
@@ -364,21 +373,31 @@ static inline bool is_in_v2_mode(void)
 static inline bool partition_is_populated(struct cpuset *cs,
 					  struct cpuset *excluded_child)
 {
-	struct cgroup_subsys_state *css;
-	struct cpuset *child;
+	struct cpuset *cp;
+	struct cgroup_subsys_state *pos_css;
 
-	if (cs->css.cgroup->nr_populated_csets)
+	/*
+	 * We cannot call cs_is_populated(cs) directly, as
+	 * nr_populated_domain_children may include populated
+	 * csets from descendants that are partitions.
+	 */
+	if (cs->css.cgroup->nr_populated_csets ||
+	    cs->attach_in_progress)
 		return true;
 	if (!excluded_child && !cs->nr_subparts)
 		return cgroup_is_populated(cs->css.cgroup);
 
 	rcu_read_lock();
-	cpuset_for_each_child(child, css, cs) {
-		if (child == excluded_child)
+	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
+		if (cp == cs || cp == excluded_child)
 			continue;
-		if (is_partition_valid(child))
+
+		if (is_partition_valid(cp)) {
+			pos_css = css_rightmost_descendant(pos_css);
 			continue;
-		if (cgroup_is_populated(child->css.cgroup)) {
+		}
+
+		if (cpuset_is_populated(cp)) {
 			rcu_read_unlock();
 			return true;
 		}
@@ -663,7 +682,7 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 	 * be changed to have empty cpus_allowed or mems_allowed.
 	 */
 	ret = -ENOSPC;
-	if ((cgroup_is_populated(cur->css.cgroup) || cur->attach_in_progress)) {
+	if (cpuset_is_populated(cur)) {
 		if (!cpumask_empty(cur->cpus_allowed) &&
 		    cpumask_empty(trial->cpus_allowed))
 			goto out;
-- 
2.51.0




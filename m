Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3146313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301016; cv=none; b=K07IpHYkY7lXK+D9n5AuDHQQpgu8tu3zQRRS5N83kZow3h6GgbkXcIRwuCnboViZK/aAzvYr0C/lVdQj8STkcpFdLcPErRnPlbhAhPj0yw9h8yLA6DnW4YP0rvC+vOLmd+7XDne8i0TXmoNRY5nQh5X5mcskgWzTEyaH3zoogEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301016; c=relaxed/simple;
	bh=T/iyB2lBxpqs6lxwso+BAIC/pn8FWfyiH6QCM0JgMII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uaY5hbVEHK/hWLUW+FkbR03SUmZoS/hWDpLBt8f3uVe5du7sV8U8Wy8xD6E/qYR50QzyJk14ZZW4ONcu1+SzWRgLSaMTwIxhCIVjalwmNzq66tSTt2oC4vPtHYT07JzLSZTFa2kwDNGEsVxlArEiswmWlO7s5fMN0DVxBnu+cTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cTiBBslq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTiBBslq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECD4C19424;
	Sat, 28 Feb 2026 17:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301015;
	bh=T/iyB2lBxpqs6lxwso+BAIC/pn8FWfyiH6QCM0JgMII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTiBBslqDTRTPK4G31VceiJL6NlFwCNsEhTql9eQ5Ddf/7Xxl+UBlMiGetaEmjq/0
	 im3Hi+Kede7TXHNR1g5NJGsbub0txP5opv6MhEPomhb76DHlty8iF/vPfzKEQYBNOY
	 NgsIW9jVel8UAij+HjojTenuyXmsLTZwFCXdP2AI2kaxYFlgDkiECHOOpBvqytZKMN
	 5pFayGNmXgFPRqv+jnrtDeKlGmR9tBjxo7NyfQDDW7RlU8JQ5W7+jPOKUmh8XRzjik
	 33u1h93O/Rp6mn/2/25OjPqLICeoVWXoplp+1RDjPzugR4wnvn/RvIFu/nhqlLeJrt
	 iBySCW/AXwHfQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waiman Long <longman@redhat.com>,
	Chen Ridong <chenridong@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 151/752] cgroup/cpuset: Don't fail cpuset.cpus change in v2
Date: Sat, 28 Feb 2026 12:37:42 -0500
Message-ID: <20260228174750.1542406-151-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Waiman Long <longman@redhat.com>

[ Upstream commit 6e6f13f6d5095f3a432da421e78f4d7d51ef39c8 ]

Commit fe8cd2736e75 ("cgroup/cpuset: Delay setting of CS_CPU_EXCLUSIVE
until valid partition") introduced a new check to disallow the setting
of a new cpuset.cpus.exclusive value that is a superset of a sibling's
cpuset.cpus value so that there will at least be one CPU left in the
sibling in case the cpuset becomes a valid partition root. This new
check does have the side effect of failing a cpuset.cpus change that
make it a subset of a sibling's cpuset.cpus.exclusive value.

With v2, users are supposed to be allowed to set whatever value they
want in cpuset.cpus without failure. To maintain this rule, the check
is now restricted to only when cpuset.cpus.exclusive is being changed
not when cpuset.cpus is changed.

The cgroup-v2.rst doc file is also updated to reflect this change.

Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/cgroup-v2.rst |  8 +++----
 kernel/cgroup/cpuset.c                  | 30 ++++++++++++-------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 0e6c67ac585a0..edcd125d6992f 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2538,10 +2538,10 @@ Cpuset Interface Files
 	Users can manually set it to a value that is different from
 	"cpuset.cpus".	One constraint in setting it is that the list of
 	CPUs must be exclusive with respect to "cpuset.cpus.exclusive"
-	of its sibling.  If "cpuset.cpus.exclusive" of a sibling cgroup
-	isn't set, its "cpuset.cpus" value, if set, cannot be a subset
-	of it to leave at least one CPU available when the exclusive
-	CPUs are taken away.
+	and "cpuset.cpus.exclusive.effective" of its siblings.	Another
+	constraint is that it cannot be a superset of "cpuset.cpus"
+	of its sibling in order to leave at least one CPU available to
+	that sibling when the exclusive CPUs are taken away.
 
 	For a parent cgroup, any one of its exclusive CPUs can only
 	be distributed to at most one of its child cgroups.  Having an
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1245418cc8b3b..d779e29a9302d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -599,33 +599,31 @@ static inline bool cpusets_are_exclusive(struct cpuset *cs1, struct cpuset *cs2)
 
 /**
  * cpus_excl_conflict - Check if two cpusets have exclusive CPU conflicts
- * @cs1: first cpuset to check
- * @cs2: second cpuset to check
+ * @trial:	the trial cpuset to be checked
+ * @sibling:	a sibling cpuset to be checked against
+ * @xcpus_changed: set if exclusive_cpus has been set
  *
  * Returns: true if CPU exclusivity conflict exists, false otherwise
  *
  * Conflict detection rules:
  * 1. If either cpuset is CPU exclusive, they must be mutually exclusive
  * 2. exclusive_cpus masks cannot intersect between cpusets
- * 3. The allowed CPUs of one cpuset cannot be a subset of another's exclusive CPUs
+ * 3. The allowed CPUs of a sibling cpuset cannot be a subset of the new exclusive CPUs
  */
-static inline bool cpus_excl_conflict(struct cpuset *cs1, struct cpuset *cs2)
+static inline bool cpus_excl_conflict(struct cpuset *trial, struct cpuset *sibling,
+				      bool xcpus_changed)
 {
 	/* If either cpuset is exclusive, check if they are mutually exclusive */
-	if (is_cpu_exclusive(cs1) || is_cpu_exclusive(cs2))
-		return !cpusets_are_exclusive(cs1, cs2);
+	if (is_cpu_exclusive(trial) || is_cpu_exclusive(sibling))
+		return !cpusets_are_exclusive(trial, sibling);
 
 	/* Exclusive_cpus cannot intersect */
-	if (cpumask_intersects(cs1->exclusive_cpus, cs2->exclusive_cpus))
+	if (cpumask_intersects(trial->exclusive_cpus, sibling->exclusive_cpus))
 		return true;
 
-	/* The cpus_allowed of one cpuset cannot be a subset of another cpuset's exclusive_cpus */
-	if (!cpumask_empty(cs1->cpus_allowed) &&
-	    cpumask_subset(cs1->cpus_allowed, cs2->exclusive_cpus))
-		return true;
-
-	if (!cpumask_empty(cs2->cpus_allowed) &&
-	    cpumask_subset(cs2->cpus_allowed, cs1->exclusive_cpus))
+	/* The cpus_allowed of a sibling cpuset cannot be a subset of the new exclusive_cpus */
+	if (xcpus_changed && !cpumask_empty(sibling->cpus_allowed) &&
+	    cpumask_subset(sibling->cpus_allowed, trial->exclusive_cpus))
 		return true;
 
 	return false;
@@ -662,6 +660,7 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 {
 	struct cgroup_subsys_state *css;
 	struct cpuset *c, *par;
+	bool xcpus_changed;
 	int ret = 0;
 
 	rcu_read_lock();
@@ -718,10 +717,11 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 	 * overlap. exclusive_cpus cannot overlap with each other if set.
 	 */
 	ret = -EINVAL;
+	xcpus_changed = !cpumask_equal(cur->exclusive_cpus, trial->exclusive_cpus);
 	cpuset_for_each_child(c, css, par) {
 		if (c == cur)
 			continue;
-		if (cpus_excl_conflict(trial, c))
+		if (cpus_excl_conflict(trial, c, xcpus_changed))
 			goto out;
 		if (mems_excl_conflict(trial, c))
 			goto out;
-- 
2.51.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8241A7264;
	Tue, 13 Oct 2026 12:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896028; cv=none; b=t1zED/Sul2PiE8w8tqJFUdX7yqzFNBlI4msJlIMpfUQZdbjZob+Ks+1WA++5tFMvLCrbIRTh1xQzYbR3e/1sMsvBCQGDGnzlgCGNGnjViKsZAh4IYQw2W1Tt0WOH+3Ya9L5afhRSiHbuswoPBenhdkM8mszVVGG/0WNxy3yudKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896028; c=relaxed/simple;
	bh=IDBG4wd3/wqCqHmCDpLWfFp/M6HED2SwnV1Yo8yStzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rXlekRpvd/7SZ+1wDGBvxPqkb6cHkjGXDLJKHNr9ZtpUN3NooPx6bZOtuFQi9WgMfR+gZ4Wj3D1DQ+FFle9gNpR2QosB7x4MWcyvCG1LSx+MdcB6dOymBc0vDi0Ymk2ZGKJhnICEc8EQ2QGHiRcm7A4exT1L2iopMkZdmZkoW1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3EFr56h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3EFr56h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C390E1F000FF;
	Tue, 13 Oct 2026 12:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896027;
	bh=F93JoY52hnD8bDSIengGnPwDTihNSTXch/kTcOmN1rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J3EFr56h3gyAoEQPSTqIIIt3XDQzpA0/VTRO+pgYw6nQE5eq9L3hH4Td2YIa1OY4w
	 oXD4X9GIYrw/CTwCgyXndZS/1L1t3DoG7dN9yqKqhF8JLBcvWB1fwbTEJr6bCTWR2u
	 ZXxS3dqHsX/cMEb2JXpGZ7YukSCeYHwP5pc5I9EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 474/497] cpuset: separate tmpmasks and cpuset allocation logic
Date: Tue, 13 Oct 2026 13:40:41 +0200
Message-ID: <20261013112919.129796300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit ada00d51622822b151e1b8cc2bc85a20d2191349 ]

The original alloc_cpumasks() served dual purposes: allocating cpumasks
for both temporary masks (tmpmasks) and cpuset structures. This patch:

1. Decouples these allocation paths for better code clarity
2. Introduces dedicated alloc_tmpmasks() and dup_or_alloc_cpuset()
   functions
3. Maintains symmetric pairing:
   - alloc_tmpmasks() ↔ free_tmpmasks()
   - dup_or_alloc_cpuset() ↔ free_cpuset()

Signed-off-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: b8eb5fd5bdb4 ("cgroup/cpuset: Call is_in_v2_mode() after acquiring cpuset_mutex in cpuset_handle_hotplug()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 127 ++++++++++++++++++++++-------------------
 1 file changed, 69 insertions(+), 58 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index ba023c19f502b..eb725c516ce39 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -416,51 +416,47 @@ static void guarantee_online_mems(struct cpuset *cs, nodemask_t *pmask)
 }
 
 /**
- * alloc_cpumasks - allocate three cpumasks for cpuset
- * @cs:  the cpuset that have cpumasks to be allocated.
- * @tmp: the tmpmasks structure pointer
+ * alloc_cpumasks - Allocate an array of cpumask variables
+ * @pmasks: Pointer to array of cpumask_var_t pointers
+ * @size: Number of cpumasks to allocate
  * Return: 0 if successful, -ENOMEM otherwise.
  *
- * Only one of the two input arguments should be non-NULL.
+ * Allocates @size cpumasks and initializes them to empty. Returns 0 on
+ * success, -ENOMEM on allocation failure. On failure, any previously
+ * allocated cpumasks are freed.
  */
-static inline int alloc_cpumasks(struct cpuset *cs, struct tmpmasks *tmp)
+static inline int alloc_cpumasks(cpumask_var_t *pmasks[], u32 size)
 {
-	cpumask_var_t *pmask1, *pmask2, *pmask3, *pmask4;
+	int i;
 
-	if (cs) {
-		pmask1 = &cs->cpus_allowed;
-		pmask2 = &cs->effective_cpus;
-		pmask3 = &cs->effective_xcpus;
-		pmask4 = &cs->exclusive_cpus;
-	} else {
-		pmask1 = &tmp->new_cpus;
-		pmask2 = &tmp->addmask;
-		pmask3 = &tmp->delmask;
-		pmask4 = NULL;
+	for (i = 0; i < size; i++) {
+		if (!zalloc_cpumask_var(pmasks[i], GFP_KERNEL)) {
+			while (--i >= 0)
+				free_cpumask_var(*pmasks[i]);
+			return -ENOMEM;
+		}
 	}
-
-	if (!zalloc_cpumask_var(pmask1, GFP_KERNEL))
-		return -ENOMEM;
-
-	if (!zalloc_cpumask_var(pmask2, GFP_KERNEL))
-		goto free_one;
-
-	if (!zalloc_cpumask_var(pmask3, GFP_KERNEL))
-		goto free_two;
-
-	if (pmask4 && !zalloc_cpumask_var(pmask4, GFP_KERNEL))
-		goto free_three;
-
-
 	return 0;
+}
 
-free_three:
-	free_cpumask_var(*pmask3);
-free_two:
-	free_cpumask_var(*pmask2);
-free_one:
-	free_cpumask_var(*pmask1);
-	return -ENOMEM;
+/**
+ * alloc_tmpmasks - Allocate temporary cpumasks for cpuset operations.
+ * @tmp: Pointer to tmpmasks structure to populate
+ * Return: 0 on success, -ENOMEM on allocation failure
+ */
+static inline int alloc_tmpmasks(struct tmpmasks *tmp)
+{
+	/*
+	 * Array of pointers to the three cpumask_var_t fields in tmpmasks.
+	 * Note: Array size must match actual number of masks (3)
+	 */
+	cpumask_var_t *pmask[3] = {
+		&tmp->new_cpus,
+		&tmp->addmask,
+		&tmp->delmask
+	};
+
+	return alloc_cpumasks(pmask, ARRAY_SIZE(pmask));
 }
 
 /**
@@ -484,26 +480,46 @@ static inline void free_cpumasks(struct cpuset *cs, struct tmpmasks *tmp)
 }
 
 /**
- * alloc_trial_cpuset - allocate a trial cpuset
- * @cs: the cpuset that the trial cpuset duplicates
+ * dup_or_alloc_cpuset - Duplicate or allocate a new cpuset
+ * @cs: Source cpuset to duplicate (NULL for a fresh allocation)
+ *
+ * Creates a new cpuset by either:
+ * 1. Duplicating an existing cpuset (if @cs is non-NULL), or
+ * 2. Allocating a fresh cpuset with zero-initialized masks (if @cs is NULL)
+ *
+ * Return: Pointer to newly allocated cpuset on success, NULL on failure
  */
-static struct cpuset *alloc_trial_cpuset(struct cpuset *cs)
+static struct cpuset *dup_or_alloc_cpuset(struct cpuset *cs)
 {
 	struct cpuset *trial;
 
-	trial = kmemdup(cs, sizeof(*cs), GFP_KERNEL);
+	/* Allocate base structure */
+	trial = cs ? kmemdup(cs, sizeof(*cs), GFP_KERNEL) :
+		     kzalloc(sizeof(*cs), GFP_KERNEL);
 	if (!trial)
 		return NULL;
 
-	if (alloc_cpumasks(trial, NULL)) {
+	/* Setup cpumask pointer array */
+	cpumask_var_t *pmask[4] = {
+		&trial->cpus_allowed,
+		&trial->effective_cpus,
+		&trial->effective_xcpus,
+		&trial->exclusive_cpus
+	};
+
+	if (alloc_cpumasks(pmask, ARRAY_SIZE(pmask))) {
 		kfree(trial);
 		return NULL;
 	}
 
-	cpumask_copy(trial->cpus_allowed, cs->cpus_allowed);
-	cpumask_copy(trial->effective_cpus, cs->effective_cpus);
-	cpumask_copy(trial->effective_xcpus, cs->effective_xcpus);
-	cpumask_copy(trial->exclusive_cpus, cs->exclusive_cpus);
+	/* Copy masks if duplicating */
+	if (cs) {
+		cpumask_copy(trial->cpus_allowed, cs->cpus_allowed);
+		cpumask_copy(trial->effective_cpus, cs->effective_cpus);
+		cpumask_copy(trial->effective_xcpus, cs->effective_xcpus);
+		cpumask_copy(trial->exclusive_cpus, cs->exclusive_cpus);
+	}
+
 	return trial;
 }
 
@@ -2309,7 +2325,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	if (cpumask_equal(cs->cpus_allowed, trialcs->cpus_allowed))
 		return 0;
 
-	if (alloc_cpumasks(NULL, &tmp))
+	if (alloc_tmpmasks(&tmp))
 		return -ENOMEM;
 
 	if (old_prs) {
@@ -2453,7 +2469,7 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	if (retval)
 		return retval;
 
-	if (alloc_cpumasks(NULL, &tmp))
+	if (alloc_tmpmasks(&tmp))
 		return -ENOMEM;
 
 	if (old_prs) {
@@ -2802,7 +2818,7 @@ int cpuset_update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	int spread_flag_changed;
 	int err;
 
-	trialcs = alloc_trial_cpuset(cs);
+	trialcs = dup_or_alloc_cpuset(cs);
 	if (!trialcs)
 		return -ENOMEM;
 
@@ -2863,7 +2879,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	if (new_prs && is_prs_invalid(old_prs))
 		old_prs = PRS_MEMBER;
 
-	if (alloc_cpumasks(NULL, &tmpmask))
+	if (alloc_tmpmasks(&tmpmask))
 		return -ENOMEM;
 
 	err = update_partition_exclusive(cs, new_prs);
@@ -3200,7 +3216,7 @@ ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
 
-	trialcs = alloc_trial_cpuset(cs);
+	trialcs = dup_or_alloc_cpuset(cs);
 	if (!trialcs) {
 		retval = -ENOMEM;
 		goto out_unlock;
@@ -3438,15 +3454,10 @@ cpuset_css_alloc(struct cgroup_subsys_state *parent_css)
 	if (!parent_css)
 		return &top_cpuset.css;
 
-	cs = kzalloc(sizeof(*cs), GFP_KERNEL);
+	cs = dup_or_alloc_cpuset(NULL);
 	if (!cs)
 		return ERR_PTR(-ENOMEM);
 
-	if (alloc_cpumasks(cs, NULL)) {
-		kfree(cs);
-		return ERR_PTR(-ENOMEM);
-	}
-
 	__set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 	fmeter_init(&cs->fmeter);
 	cs->relax_domain_level = -1;
@@ -3907,7 +3918,7 @@ static void cpuset_handle_hotplug(void)
 	bool on_dfl = is_in_v2_mode();
 	struct tmpmasks tmp, *ptmp = NULL;
 
-	if (on_dfl && !alloc_cpumasks(NULL, &tmp))
+	if (on_dfl && !alloc_tmpmasks(&tmp))
 		ptmp = &tmp;
 
 	lockdep_assert_cpus_held();
-- 
2.53.0




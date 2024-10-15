Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768C81EF083;
	Tue, 15 Oct 2024 11:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992420; cv=none; b=h529yoWExYc/b1ybnjE9UhyF68KoY9X4O5gXmSNO5LUVnmZ+OigOW6ylXYRTCD3giw2akwaLlVOWw1Owb04pTjLhtBjUGmI5RBBRVp+HWXQoSobdoS3cdIdD4K9BQSAugP+uKNeMX8bDFl0M2UnmCcfYq/VYPxEaP/htSWQ0F5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992420; c=relaxed/simple;
	bh=p96rqc3xYj8zh3Rd0hYorhDlszX0M8KCKNqqiIdDqvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvXZ4mce9++cvhpx2TK5A7Tu1caG13wQeDAYG5+I61KoqUDWp2SjfUnGpl1L7OdcHIdKB2BikJXpfzXUPUbj6hoeiRWtkZ4NOpHOYYtGof8Vz/W5sAJgcTMhEMYRXoW/7SZvuKKmd5lK5VHa7LAh76DuYLjYUPM2lCn4g5WT3sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jdT0FmjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdT0FmjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF338C4CEC6;
	Tue, 15 Oct 2024 11:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992420;
	bh=p96rqc3xYj8zh3Rd0hYorhDlszX0M8KCKNqqiIdDqvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jdT0FmjDMP8PX0xrnTEoTukRBqkIf5svW9Ypxor4I8TWGXiKnvt43aoQ4DPrpeo3j
	 pOxvqVLLMemogcDn0MYYo7jHqL2RuhNT/OI+w0Pqc4zeXiw/FHHdfEc3zc8+bLc/rf
	 5aHm/JlmYnIwGU3y02MGZSbl6y5fgBnNq1sawEgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/691] cgroup: Make operations on the cgroup root_list RCU safe
Date: Tue, 15 Oct 2024 13:20:28 +0200
Message-ID: <20241015112443.532007991@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit d23b5c577715892c87533b13923306acc6243f93 ]

At present, when we perform operations on the cgroup root_list, we must
hold the cgroup_mutex, which is a relatively heavyweight lock. In reality,
we can make operations on this list RCU-safe, eliminating the need to hold
the cgroup_mutex during traversal. Modifications to the list only occur in
the cgroup root setup and destroy paths, which should be infrequent in a
production environment. In contrast, traversal may occur frequently.
Therefore, making it RCU-safe would be beneficial.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cgroup-defs.h     |  1 +
 kernel/cgroup/cgroup-internal.h |  3 ++-
 kernel/cgroup/cgroup.c          | 14 +++++++-------
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index cd8b8bd5ec4d5..61e92fd055d9c 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -516,6 +516,7 @@ struct cgroup_root {
 
 	/* A list running through the active hierarchies */
 	struct list_head root_list;
+	struct rcu_head rcu;
 
 	/* Hierarchy-specific flags */
 	unsigned int flags;
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index d8fcc139ac05d..f38f56b8cc416 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -172,7 +172,8 @@ extern struct list_head cgroup_roots;
 
 /* iterate across the hierarchies */
 #define for_each_root(root)						\
-	list_for_each_entry((root), &cgroup_roots, root_list)
+	list_for_each_entry_rcu((root), &cgroup_roots, root_list,	\
+				lockdep_is_held(&cgroup_mutex))
 
 /**
  * for_each_subsys - iterate all enabled cgroup subsystems
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 84e85561a87c0..999fef6d12282 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1332,7 +1332,7 @@ static void cgroup_exit_root_id(struct cgroup_root *root)
 
 void cgroup_free_root(struct cgroup_root *root)
 {
-	kfree(root);
+	kfree_rcu(root, rcu);
 }
 
 static void cgroup_destroy_root(struct cgroup_root *root)
@@ -1365,7 +1365,7 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 	spin_unlock_irq(&css_set_lock);
 
 	if (!list_empty(&root->root_list)) {
-		list_del(&root->root_list);
+		list_del_rcu(&root->root_list);
 		cgroup_root_count--;
 	}
 
@@ -1411,7 +1411,6 @@ current_cgns_cgroup_from_root(struct cgroup_root *root)
 	}
 	rcu_read_unlock();
 
-	BUG_ON(!res);
 	return res;
 }
 
@@ -1421,7 +1420,6 @@ static struct cgroup *cset_cgroup_from_root(struct css_set *cset,
 {
 	struct cgroup *res = NULL;
 
-	lockdep_assert_held(&cgroup_mutex);
 	lockdep_assert_held(&css_set_lock);
 
 	if (cset == &init_css_set) {
@@ -1447,7 +1445,9 @@ static struct cgroup *cset_cgroup_from_root(struct css_set *cset,
 
 /*
  * Return the cgroup for "task" from the given hierarchy. Must be
- * called with cgroup_mutex and css_set_lock held.
+ * called with css_set_lock held to prevent task's groups from being modified.
+ * Must be called with either cgroup_mutex or rcu read lock to prevent the
+ * cgroup root from being destroyed.
  */
 struct cgroup *task_cgroup_from_root(struct task_struct *task,
 				     struct cgroup_root *root)
@@ -1986,7 +1986,7 @@ void init_cgroup_root(struct cgroup_fs_context *ctx)
 	struct cgroup_root *root = ctx->root;
 	struct cgroup *cgrp = &root->cgrp;
 
-	INIT_LIST_HEAD(&root->root_list);
+	INIT_LIST_HEAD_RCU(&root->root_list);
 	atomic_set(&root->nr_cgrps, 1);
 	cgrp->root = root;
 	init_cgroup_housekeeping(cgrp);
@@ -2068,7 +2068,7 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	 * care of subsystems' refcounts, which are explicitly dropped in
 	 * the failure exit path.
 	 */
-	list_add(&root->root_list, &cgroup_roots);
+	list_add_rcu(&root->root_list, &cgroup_roots);
 	cgroup_root_count++;
 
 	/*
-- 
2.43.0




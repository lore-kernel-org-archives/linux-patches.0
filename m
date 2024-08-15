Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45CC1AE845;
	Thu, 15 Aug 2024 14:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730978; cv=none; b=osZTVp54sbjQbaxM+LWPB2iNVG+1QNNqbspMfWreFuwZBMHOuwbHoktX4ESSfznh/ViNTncmH2RrpiaEus2R2B8oQ+1T1fIUZ0LYPyslPxuCVxlqA2MX5cZKtrRNhjKm0AuaQHu0zhy3JVWtezNqmjq5TF2MaLQqEWpqhd/DAA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730978; c=relaxed/simple;
	bh=6b7MX9ByWcQGLh3QsIPmxUOsMLP2f5gDqznqnDN5NkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qsgmCE4uvbSzUDqVvtgc6iSjBU/VQsd/zPC9ozmXPrk1YLEsNYfbaejPpevYBa6908OK4pFZjz5J7W0jM4Jv7jB1Po5InbEKLcSS5ef0XkCK4aYyjlEdMk941cwA5VDkIyhkDgp1ByF4Wh04OjfERXT8R9OftlcSkvo+V0I900o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/xBbzDT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/xBbzDT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5F6C32786;
	Thu, 15 Aug 2024 14:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730978;
	bh=6b7MX9ByWcQGLh3QsIPmxUOsMLP2f5gDqznqnDN5NkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/xBbzDTqAbejy6lFXVMUU9HbwW89v/5lQ2XnYl15iensRvqAPl1si6DcXOYAbN0k
	 Y+GsFDuNhe+fI7r8lalukbAYMZ3T/fNVX45PgIdM/qV3jmxiiCyvL0wUZQpC9X9Kt1
	 OIZtFx992bfywUaL4+epNqJQdIZnU18+qGhpdAdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.6 21/67] cgroup: Make operations on the cgroup root_list RCU safe
Date: Thu, 15 Aug 2024 15:25:35 +0200
Message-ID: <20240815131839.149850850@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yafang Shao <laoar.shao@gmail.com>

commit d23b5c577715892c87533b13923306acc6243f93 upstream.

At present, when we perform operations on the cgroup root_list, we must
hold the cgroup_mutex, which is a relatively heavyweight lock. In reality,
we can make operations on this list RCU-safe, eliminating the need to hold
the cgroup_mutex during traversal. Modifications to the list only occur in
the cgroup root setup and destroy paths, which should be infrequent in a
production environment. In contrast, traversal may occur frequently.
Therefore, making it RCU-safe would be beneficial.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
To: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cgroup-defs.h     |    1 +
 kernel/cgroup/cgroup-internal.h |    3 ++-
 kernel/cgroup/cgroup.c          |   23 ++++++++++++++++-------
 3 files changed, 19 insertions(+), 8 deletions(-)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -558,6 +558,7 @@ struct cgroup_root {
 
 	/* A list running through the active hierarchies */
 	struct list_head root_list;
+	struct rcu_head rcu;
 
 	/* Hierarchy-specific flags */
 	unsigned int flags;
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -170,7 +170,8 @@ extern struct list_head cgroup_roots;
 
 /* iterate across the hierarchies */
 #define for_each_root(root)						\
-	list_for_each_entry((root), &cgroup_roots, root_list)
+	list_for_each_entry_rcu((root), &cgroup_roots, root_list,	\
+				lockdep_is_held(&cgroup_mutex))
 
 /**
  * for_each_subsys - iterate all enabled cgroup subsystems
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1313,7 +1313,7 @@ static void cgroup_exit_root_id(struct c
 
 void cgroup_free_root(struct cgroup_root *root)
 {
-	kfree(root);
+	kfree_rcu(root, rcu);
 }
 
 static void cgroup_destroy_root(struct cgroup_root *root)
@@ -1346,7 +1346,7 @@ static void cgroup_destroy_root(struct c
 	spin_unlock_irq(&css_set_lock);
 
 	if (!list_empty(&root->root_list)) {
-		list_del(&root->root_list);
+		list_del_rcu(&root->root_list);
 		cgroup_root_count--;
 	}
 
@@ -1386,7 +1386,15 @@ static inline struct cgroup *__cset_cgro
 		}
 	}
 
-	BUG_ON(!res_cgroup);
+	/*
+	 * If cgroup_mutex is not held, the cgrp_cset_link will be freed
+	 * before we remove the cgroup root from the root_list. Consequently,
+	 * when accessing a cgroup root, the cset_link may have already been
+	 * freed, resulting in a NULL res_cgroup. However, by holding the
+	 * cgroup_mutex, we ensure that res_cgroup can't be NULL.
+	 * If we don't hold cgroup_mutex in the caller, we must do the NULL
+	 * check.
+	 */
 	return res_cgroup;
 }
 
@@ -1445,7 +1453,6 @@ static struct cgroup *current_cgns_cgrou
 static struct cgroup *cset_cgroup_from_root(struct css_set *cset,
 					    struct cgroup_root *root)
 {
-	lockdep_assert_held(&cgroup_mutex);
 	lockdep_assert_held(&css_set_lock);
 
 	return __cset_cgroup_from_root(cset, root);
@@ -1453,7 +1460,9 @@ static struct cgroup *cset_cgroup_from_r
 
 /*
  * Return the cgroup for "task" from the given hierarchy. Must be
- * called with cgroup_mutex and css_set_lock held.
+ * called with css_set_lock held to prevent task's groups from being modified.
+ * Must be called with either cgroup_mutex or rcu read lock to prevent the
+ * cgroup root from being destroyed.
  */
 struct cgroup *task_cgroup_from_root(struct task_struct *task,
 				     struct cgroup_root *root)
@@ -2014,7 +2023,7 @@ void init_cgroup_root(struct cgroup_fs_c
 	struct cgroup_root *root = ctx->root;
 	struct cgroup *cgrp = &root->cgrp;
 
-	INIT_LIST_HEAD(&root->root_list);
+	INIT_LIST_HEAD_RCU(&root->root_list);
 	atomic_set(&root->nr_cgrps, 1);
 	cgrp->root = root;
 	init_cgroup_housekeeping(cgrp);
@@ -2097,7 +2106,7 @@ int cgroup_setup_root(struct cgroup_root
 	 * care of subsystems' refcounts, which are explicitly dropped in
 	 * the failure exit path.
 	 */
-	list_add(&root->root_list, &cgroup_roots);
+	list_add_rcu(&root->root_list, &cgroup_roots);
 	cgroup_root_count++;
 
 	/*



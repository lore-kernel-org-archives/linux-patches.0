Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED991D0437;
	Wed,  2 Oct 2024 13:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877077; cv=none; b=Wh8VP446Z7DB+gZn/IcZeilnLCESSRbZxcox70syMkT7DpEbMi2VH+QtDV9ei4G162uFE2eIrDzPPkXpygysMJ3vbl69PJzuSRrXy5ZpnUFPHXLADMCSPArX/Vq6/ggMnW2ekbOdD6fI8kxUEXgLXW/HL/v+o0ZSj01yjgkaipI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877077; c=relaxed/simple;
	bh=p2f1Vo8QGQ6+snOiU7+Kn3KVHU+CObHTMQiMHX/rp2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OL5FmoHlSTn+ZVxd62Or5hW8QZCSpNHwqOXX1xKYiJH6PKklrOxwkdlXYXIO2ANNA2euQpveS/TFs1/scqUe2VBzpFVO531vQcXBwWu5cHiAbXyfIvblRH90CVsL6cJvcawNxzHHp2UWpxsDOeJDIzjIBvQ9SNj/1q1zNVBntD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUuAsMyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUuAsMyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99576C4CEC2;
	Wed,  2 Oct 2024 13:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877077;
	bh=p2f1Vo8QGQ6+snOiU7+Kn3KVHU+CObHTMQiMHX/rp2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUuAsMyVNX2ZYiXwKi6IDaq5Nn2YhO7Dop1cUoLPMy+tK2BJvulbj95svjc1OPo/z
	 v4QP0vBfOmLcmQv0/Rj9lnvdHAKaLvyNv9S1FNh58Z+LwIKVXJFOqCrSehFt9TyP67
	 YclODa/mymBl9T2W/AO5SbXHJVWKGfkKfbF8GFxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5446fbf332b0602ede0b@syzkaller.appspotmail.com,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.11 655/695] lsm: add the inode_free_security_rcu() LSM implementation hook
Date: Wed,  2 Oct 2024 15:00:53 +0200
Message-ID: <20241002125848.657044691@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <paul@paul-moore.com>

commit 63dff3e48871b0583be5032ff8fb7260c349a18c upstream.

The LSM framework has an existing inode_free_security() hook which
is used by LSMs that manage state associated with an inode, but
due to the use of RCU to protect the inode, special care must be
taken to ensure that the LSMs do not fully release the inode state
until it is safe from a RCU perspective.

This patch implements a new inode_free_security_rcu() implementation
hook which is called when it is safe to free the LSM's internal inode
state.  Unfortunately, this new hook does not have access to the inode
itself as it may already be released, so the existing
inode_free_security() hook is retained for those LSMs which require
access to the inode.

Cc: stable@vger.kernel.org
Reported-by: syzbot+5446fbf332b0602ede0b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/00000000000076ba3b0617f65cc8@google.com
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/lsm_hook_defs.h     |    1 +
 security/integrity/ima/ima.h      |    2 +-
 security/integrity/ima/ima_iint.c |   20 ++++++++------------
 security/integrity/ima/ima_main.c |    2 +-
 security/landlock/fs.c            |    9 ++++++---
 security/security.c               |   32 ++++++++++++++++----------------
 6 files changed, 33 insertions(+), 33 deletions(-)

--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -114,6 +114,7 @@ LSM_HOOK(int, 0, path_notify, const stru
 	 unsigned int obj_type)
 LSM_HOOK(int, 0, inode_alloc_security, struct inode *inode)
 LSM_HOOK(void, LSM_RET_VOID, inode_free_security, struct inode *inode)
+LSM_HOOK(void, LSM_RET_VOID, inode_free_security_rcu, void *inode_security)
 LSM_HOOK(int, -EOPNOTSUPP, inode_init_security, struct inode *inode,
 	 struct inode *dir, const struct qstr *qstr, struct xattr *xattrs,
 	 int *xattr_count)
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -223,7 +223,7 @@ static inline void ima_inode_set_iint(co
 
 struct ima_iint_cache *ima_iint_find(struct inode *inode);
 struct ima_iint_cache *ima_inode_get(struct inode *inode);
-void ima_inode_free(struct inode *inode);
+void ima_inode_free_rcu(void *inode_security);
 void __init ima_iintcache_init(void);
 
 extern const int read_idmap[];
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -109,22 +109,18 @@ struct ima_iint_cache *ima_inode_get(str
 }
 
 /**
- * ima_inode_free - Called on inode free
- * @inode: Pointer to the inode
+ * ima_inode_free_rcu - Called to free an inode via a RCU callback
+ * @inode_security: The inode->i_security pointer
  *
- * Free the iint associated with an inode.
+ * Free the IMA data associated with an inode.
  */
-void ima_inode_free(struct inode *inode)
+void ima_inode_free_rcu(void *inode_security)
 {
-	struct ima_iint_cache *iint;
+	struct ima_iint_cache **iint_p = inode_security + ima_blob_sizes.lbs_inode;
 
-	if (!IS_IMA(inode))
-		return;
-
-	iint = ima_iint_find(inode);
-	ima_inode_set_iint(inode, NULL);
-
-	ima_iint_free(iint);
+	/* *iint_p should be NULL if !IS_IMA(inode) */
+	if (*iint_p)
+		ima_iint_free(*iint_p);
 }
 
 static void ima_iint_init_once(void *foo)
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -1193,7 +1193,7 @@ static struct security_hook_list ima_hoo
 #ifdef CONFIG_INTEGRITY_ASYMMETRIC_KEYS
 	LSM_HOOK_INIT(kernel_module_request, ima_kernel_module_request),
 #endif
-	LSM_HOOK_INIT(inode_free_security, ima_inode_free),
+	LSM_HOOK_INIT(inode_free_security_rcu, ima_inode_free_rcu),
 };
 
 static const struct lsm_id ima_lsmid = {
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -1207,13 +1207,16 @@ static int current_check_refer_path(stru
 
 /* Inode hooks */
 
-static void hook_inode_free_security(struct inode *const inode)
+static void hook_inode_free_security_rcu(void *inode_security)
 {
+	struct landlock_inode_security *inode_sec;
+
 	/*
 	 * All inodes must already have been untied from their object by
 	 * release_inode() or hook_sb_delete().
 	 */
-	WARN_ON_ONCE(landlock_inode(inode)->object);
+	inode_sec = inode_security + landlock_blob_sizes.lbs_inode;
+	WARN_ON_ONCE(inode_sec->object);
 }
 
 /* Super-block hooks */
@@ -1637,7 +1640,7 @@ static int hook_file_ioctl_compat(struct
 }
 
 static struct security_hook_list landlock_hooks[] __ro_after_init = {
-	LSM_HOOK_INIT(inode_free_security, hook_inode_free_security),
+	LSM_HOOK_INIT(inode_free_security_rcu, hook_inode_free_security_rcu),
 
 	LSM_HOOK_INIT(sb_delete, hook_sb_delete),
 	LSM_HOOK_INIT(sb_mount, hook_sb_mount),
--- a/security/security.c
+++ b/security/security.c
@@ -1596,9 +1596,8 @@ int security_inode_alloc(struct inode *i
 
 static void inode_free_by_rcu(struct rcu_head *head)
 {
-	/*
-	 * The rcu head is at the start of the inode blob
-	 */
+	/* The rcu head is at the start of the inode blob */
+	call_void_hook(inode_free_security_rcu, head);
 	kmem_cache_free(lsm_inode_cache, head);
 }
 
@@ -1606,23 +1605,24 @@ static void inode_free_by_rcu(struct rcu
  * security_inode_free() - Free an inode's LSM blob
  * @inode: the inode
  *
- * Deallocate the inode security structure and set @inode->i_security to NULL.
+ * Release any LSM resources associated with @inode, although due to the
+ * inode's RCU protections it is possible that the resources will not be
+ * fully released until after the current RCU grace period has elapsed.
+ *
+ * It is important for LSMs to note that despite being present in a call to
+ * security_inode_free(), @inode may still be referenced in a VFS path walk
+ * and calls to security_inode_permission() may be made during, or after,
+ * a call to security_inode_free().  For this reason the inode->i_security
+ * field is released via a call_rcu() callback and any LSMs which need to
+ * retain inode state for use in security_inode_permission() should only
+ * release that state in the inode_free_security_rcu() LSM hook callback.
  */
 void security_inode_free(struct inode *inode)
 {
 	call_void_hook(inode_free_security, inode);
-	/*
-	 * The inode may still be referenced in a path walk and
-	 * a call to security_inode_permission() can be made
-	 * after inode_free_security() is called. Ideally, the VFS
-	 * wouldn't do this, but fixing that is a much harder
-	 * job. For now, simply free the i_security via RCU, and
-	 * leave the current inode->i_security pointer intact.
-	 * The inode will be freed after the RCU grace period too.
-	 */
-	if (inode->i_security)
-		call_rcu((struct rcu_head *)inode->i_security,
-			 inode_free_by_rcu);
+	if (!inode->i_security)
+		return;
+	call_rcu((struct rcu_head *)inode->i_security, inode_free_by_rcu);
 }
 
 /**



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA7E1E8320;
	Tue, 16 Jun 2026 16:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625958; cv=none; b=dzwxbRo5GIN0sJHrMk6r7LpGDZIMmJrcFVRzwM03MBnZLuzOfvtVYwjFqSoIq2IkwN+mDI3Y3mjjDp6FK5E4f2f/qyZA1ABkOfX9TzAh9Lm++2JwFmZYzT55ZEhWLBHZW31uBjUM7OEG4rnJ/Sicu8gmuiPfO9sB33Iq2FYJgds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625958; c=relaxed/simple;
	bh=NAgBoC2+NONNKzDrJ8d2okSP8FwTMiCrarwaXEFO0MY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2MSd26NxdOo5lj1BtLFR1JuWtIn7AUW9gUgO1wRHIOIaIMSqVmgFIMyeMaA2ADE+HpUj2oNF8jeYPI9TUwvSgMum1pNSIKv8aP4Xx3ERL5H1W/MB3qkOSQKn0Z6e1d3V53wdjo+0k9wke19WsiFMgesD6CwV1MK178+gqWVuqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlfSWQW1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlfSWQW1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19FE1F000E9;
	Tue, 16 Jun 2026 16:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625956;
	bh=7tzfRFTG5K+BPpHpbYf++BqS7iL9kYuX2O9hld0e0I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QlfSWQW1e4rCikpWLx7DbFTM/Yoi0ADW/TEV+v3fEThTZlUFK8iglnWiJSdYZHKzu
	 JYqGmxlxxQpChyJ7Lh2CDTXprt41CUAJ9nbePwxIwLnjT56Nd8nKmPrG/kEG07tqOw
	 uLeNteDrPqAUYrcwc41MIPgB3fgPjo7l3W3dOgkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 212/325] fhandle: fix UAF due to unlocked ->mnt_ns read in may_decode_fh()
Date: Tue, 16 Jun 2026 20:30:08 +0530
Message-ID: <20260616145108.668364401@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit 40ab6644b99685755f740b872c00ef40d9aa870e upstream.

may_decode_fh() accesses mount::mnt_ns without holding any locks; that
means the mount can concurrently be unmounted, and the mnt_namespace can
concurrently be freed after an RCU grace period.

This race can happens as follows, assuming that the mount point was
created by open_tree(..., OPEN_TREE_CLONE):

thread 1            thread 2            RCU
                    __do_sys_open_by_handle_at
                      do_handle_open
                        handle_to_path
                          may_decode_fh
                            is_mounted
                              [mount::mnt_ns access]
                            [mount::mnt_ns access]
__do_sys_close
  fput_close_sync
    __fput
      dissolve_on_fput
        umount_tree
        class_namespace_excl_destructor
          namespace_unlock
            free_mnt_ns
              mnt_ns_tree_remove
                call_rcu(mnt_ns_release_rcu)
                                        mnt_ns_release_rcu
                                          mnt_ns_release
                                            kfree
                            [mnt_namespace::user_ns access] **UAF**

Fix it by taking rcu_read_lock() around the mount::mnt_ns access, like
in __prepend_path().
Additionally, document the semantics of mount::mnt_ns, and use WRITE_ONCE()
for writers that can race with lockless readers.

This bug is unreachable unless one of the following is set:

 - CONFIG_PREEMPTION
 - CONFIG_RCU_STRICT_GRACE_PERIOD

because it requires an RCU grace period to happen during a syscall without
an explicit preemption.

This doesn't seem to have interesting security impact; worst-case, it could
leak the result of an integer comparison to userspace (from the level
check in cap_capable()), cause an endless loop, or crash the kernel by
dereferencing an invalid address.

Fixes: 620c266f3949 ("fhandle: relax open_by_handle_at() permission checks")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://patch.msgid.link/20260603-vfs-fhandle-uaf-fix-v2-1-d05db76a5084@google.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fhandle.c   |   16 ++++++++++++++--
 fs/mount.h     |   10 +++++++++-
 fs/namespace.c |    6 +++---
 3 files changed, 26 insertions(+), 6 deletions(-)

--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -287,6 +287,19 @@ static int do_handle_to_path(struct file
 	return 0;
 }
 
+static bool capable_wrt_mount(struct mount *mount)
+{
+	struct mnt_namespace *mnt_ns;
+
+	/*
+	 * For ->mnt_ns access.
+	 * The following READ_ONCE() is semantically rcu_dereference().
+	 */
+	guard(rcu)();
+	mnt_ns = READ_ONCE(mount->mnt_ns);
+	return ns_capable(mnt_ns->user_ns, CAP_SYS_ADMIN);
+}
+
 static inline int may_decode_fh(struct handle_to_path_ctx *ctx,
 				unsigned int o_flags)
 {
@@ -322,8 +335,7 @@ static inline int may_decode_fh(struct h
 	if (ns_capable(root->mnt->mnt_sb->s_user_ns, CAP_SYS_ADMIN))
 		ctx->flags = HANDLE_CHECK_PERMS;
 	else if (is_mounted(root->mnt) &&
-		 ns_capable(real_mount(root->mnt)->mnt_ns->user_ns,
-			    CAP_SYS_ADMIN) &&
+		 capable_wrt_mount(real_mount(root->mnt)) &&
 		 !has_locked_children(real_mount(root->mnt), root->dentry))
 		ctx->flags = HANDLE_CHECK_PERMS | HANDLE_CHECK_SUBTREE;
 	else
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -69,7 +69,15 @@ struct mount {
 	struct hlist_head mnt_slave_list;/* list of slave mounts */
 	struct hlist_node mnt_slave;	/* slave list entry */
 	struct mount *mnt_master;	/* slave is on master->mnt_slave_list */
-	struct mnt_namespace *mnt_ns;	/* containing namespace */
+	/*
+	 * Containing namespace (active or deactivating, non-refcounted).
+	 * Normally protected by namespace_sem.
+	 * Can also be accessed locklessly under RCU. RCU readers can't rely on
+	 * the namespace still being active, but implicitly hold a passive
+	 * reference (because an RCU delay happens between a namespace being
+	 * deactivated and the corresponding passive refcount drop).
+	 */
+	struct mnt_namespace *mnt_ns;
 	struct mountpoint *mnt_mp;	/* where is it mounted */
 	union {
 		struct hlist_node mnt_mp_list;	/* list mounts with the same mountpoint */
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1085,7 +1085,7 @@ static void mnt_add_to_ns(struct mnt_nam
 	bool mnt_first_node = true, mnt_last_node = true;
 
 	WARN_ON(mnt_ns_attached(mnt));
-	mnt->mnt_ns = ns;
+	WRITE_ONCE(mnt->mnt_ns, ns);
 	while (*link) {
 		parent = *link;
 		if (mnt->mnt_id_unique < node_to_mount(parent)->mnt_id_unique) {
@@ -1434,7 +1434,7 @@ EXPORT_SYMBOL(mntget);
 void mnt_make_shortterm(struct vfsmount *mnt)
 {
 	if (mnt)
-		real_mount(mnt)->mnt_ns = NULL;
+		WRITE_ONCE(real_mount(mnt)->mnt_ns, NULL);
 }
 
 /**
@@ -1806,7 +1806,7 @@ static void umount_tree(struct mount *mn
 			ns->nr_mounts--;
 			__touch_mnt_namespace(ns);
 		}
-		p->mnt_ns = NULL;
+		WRITE_ONCE(p->mnt_ns, NULL);
 		if (how & UMOUNT_SYNC)
 			p->mnt.mnt_flags |= MNT_SYNC_UMOUNT;
 



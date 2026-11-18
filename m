Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015744;
	b=xU9JM7iTACL6bSTr392HEzbKtiyiQ3ZhpIaAniGTFqt38I/q8KYvZDTMdKtqCP+LX734
	 4JD3Wv4m8hyBna/xKO7zFCHh+oIDBljZoz4YJbHbFvotrGhRUPCew6iOPvlw3KqfUs1Xc
	 aeSVbzwm6I8fGC72+PefOpRBfLlUTJN+9HxxWskYUXpneoz8fL017oXYQs0luLzKCpDKV
	 /K4zqvyUKVvfhCAV7/v+ni1YWQrKaDhJKNZ224impQmesFUFUClAi/w09n/HDtGUO3IPP
	 WCNfJVaerJiJanSv3UfggCHpnKdClpUBnToS0LpZnoZ2QXpBWUPGIJtj2mj9Z2sSKxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5vNVNN62rJwoSCv8HnRF2P2LFERJ7fZfX4FfdhlIVI4=;
	b=TMVcFXPJCXl/h2Slr0KV+ozyA0KP0SmhQq1RSnuExj9WQ9tMKPB5jCkgIhyeYq4XLUln
	 Mnbj3Ly6YjVkweX12XE+gzU9Q1otSx4mVklpAaQW9CMAUh7yZ9X1+Im/Oq4TH14ssjH2V
	 4XUoNVo+Pk/0rnvQb9XxsErEJ13UOZ8BllAvLk/SAZfmcb1A53ooFHJSuJVsayvx8haZr
	 1DGJ748xfczmtjkTU60VZYx61wMeWZ2EFVT3lxVRqAkndPX+7SEzEiCBCnd/Mhd9DsevO
	 Kx9chvsIx5EART1RTYNLKxxCAMzzxEVbm7OsWmhH733hk6MSYhyS4dmLYJdVSV7SJyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMMSnlEI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34D9606A325;
	Wed, 18 Nov 2026 15:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMMSnlEI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12ABD1F000C6;
	Wed, 18 Nov 2026 15:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015743;
	bh=5vNVNN62rJwoSCv8HnRF2P2LFERJ7fZfX4FfdhlIVI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMMSnlEIl9ZTw0gNMYAM6RnPOQq853xfA1rpq6wjMVmWFLtke/3x6Eg21ecdeM/B2
	 bIyvLVAVpBVVjEz0tnhlKmaB9Ua5hpO7z2P0j2+ARFcp5RKCzwKqBB8SATX/iMLZ2R
	 6/ofcrnWMNhYf0mIHv7NbgUD9EFuSbBMsHUuYBS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bb2e19a1190a556c01b1@syzkaller.appspotmail.com,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0281/2651] cgroup: Make the offline drain interruptible
Date: Wed, 18 Nov 2026 15:25:21 +0100
Message-ID: <20261118150258.029755958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit c367ce5b31ffd4d958f3f6c5fe1c9e820dc9f526 ]

cgroup_subtree_control_write() and cgroup_type_write() drain dying csses
from the subtree before re-applying control, so that a controller being
re-enabled gets a fresh css instead of adopting one that is still dying. The
drain waits for offline_css() in TASK_UNINTERRUPTIBLE.

Since 1dffd95575eb ("cgroup: Defer kill_css_finish() in
cgroup_apply_control_disable()"), a disabled css offlines only after every
task that still pins it has finished exiting. The root cause of the hang is
an indefinite wait in a place where indefinite waits should not happen: a
task past exit_signals() can block in its exit path for as long as, say, a
FUSE daemon takes to answer a flush, and nothing can interrupt it because
prepare_signal() drops every signal for an exiting group. The drain then
escalated that into an uninterruptible wait for the writer, which sits in D
state for as long as the exiting task does. That is the hang syzbot reports
as "task hung in cgroup_subtree_control_write".

Make the drain interruptible. Nothing has been modified when it runs, so the
write restarts or fails with EINTR without side effects. cgroup1 mount and
remount drain the same way and become interruptible too.
cgroup_destroy_root() drains from a workqueue where no signal is ever
pending and keeps waiting as before.

This only stops the escalation. The write still waits for the exiting tasks,
and the indefinite wait in the exit path remains a separate problem.

Fixes: 1dffd95575eb ("cgroup: Defer kill_css_finish() in cgroup_apply_control_disable()")
Reported-by: syzbot+bb2e19a1190a556c01b1@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/6a23a4b4.e4db5ad2.3b7dfb.0000.GAE@google.com/
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup-internal.h |  2 +-
 kernel/cgroup/cgroup-v1.c       |  8 ++++--
 kernel/cgroup/cgroup.c          | 48 ++++++++++++++++++++++-----------
 3 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 58797123b752f..f2684f9f8e0a3 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -254,7 +254,7 @@ void cgroup_procs_write_finish(struct task_struct *task,
 			       enum cgroup_attach_lock_mode lock_mode)
 	__releases(&cgroup_threadgroup_rwsem);
 
-void cgroup_lock_and_drain_offline(struct cgroup *cgrp);
+int cgroup_lock_and_drain_offline(struct cgroup *cgrp);
 
 int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name, umode_t mode);
 int cgroup_rmdir(struct kernfs_node *kn);
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 7e008867f3ac6..167bf6555a49d 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -1097,7 +1097,9 @@ int cgroup1_reconfigure(struct fs_context *fc)
 	int ret = 0;
 	u32 added_mask, removed_mask;
 
-	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
+	ret = cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
+	if (unlikely(ret))
+		return ret;
 
 	/* See what subsystems are wanted */
 	ret = check_cgroupfs_options(fc);
@@ -1262,7 +1264,9 @@ int cgroup1_get_tree(struct fs_context *fc)
 	if (!ns_capable(ctx->ns->user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 
-	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
+	ret = cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
+	if (unlikely(ret))
+		return ret;
 
 	ret = cgroup1_root_to_use(fc);
 	if (!ret && !percpu_ref_tryget_live(&ctx->root->cgrp.self.refcnt))
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 8463b5071fbdd..37be027ce140b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1379,7 +1379,10 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 
 	trace_cgroup_destroy_root(root);
 
-	cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
+	/* runs off a workqueue, no signal can interrupt the drain */
+	ret = cgroup_lock_and_drain_offline(&cgrp_dfl_root.cgrp);
+	if (WARN_ON_ONCE(ret))
+		cgroup_lock();
 
 	BUG_ON(atomic_read(&root->nr_cgrps));
 	BUG_ON(!list_empty(&cgrp->self.children));
@@ -1687,7 +1690,8 @@ void cgroup_kn_unlock(struct kernfs_node *kn)
  * verifies that the associated cgroup is alive.  Returns the cgroup if
  * alive; otherwise, an ERR_PTR value.  A successful return should be undone by
  * a matching cgroup_kn_unlock() invocation.  If @drain_offline is %true, the
- * cgroup is drained of offlining csses before return.
+ * cgroup is drained of offlining csses before return, and an interrupted drain
+ * fails with -ERESTARTSYS.
  *
  * Any cgroup kernfs method implementation which requires locking the
  * associated cgroup should use this helper.  It avoids nesting cgroup
@@ -1697,6 +1701,7 @@ void cgroup_kn_unlock(struct kernfs_node *kn)
 struct cgroup *cgroup_kn_lock_live(struct kernfs_node *kn, bool drain_offline)
 {
 	struct cgroup *cgrp;
+	int ret;
 
 	if (kernfs_type(kn) == KERNFS_DIR)
 		cgrp = kn->priv;
@@ -1713,10 +1718,16 @@ struct cgroup *cgroup_kn_lock_live(struct kernfs_node *kn, bool drain_offline)
 		return ERR_PTR(-ENODEV);
 	kernfs_break_active_protection(kn);
 
-	if (drain_offline)
-		cgroup_lock_and_drain_offline(cgrp);
-	else
+	if (drain_offline) {
+		ret = cgroup_lock_and_drain_offline(cgrp);
+		if (unlikely(ret)) {
+			kernfs_unbreak_active_protection(kn);
+			cgroup_put(cgrp);
+			return ERR_PTR(ret);
+		}
+	} else {
 		cgroup_lock();
+	}
 
 	if (!cgroup_is_dead(cgrp))
 		return cgrp;
@@ -3320,16 +3331,20 @@ static int cgroup_update_dfl_csses(struct cgroup *cgrp)
  * @cgrp: root of the target subtree
  *
  * Because css offlining is asynchronous, userland may try to re-enable a
- * controller while the previous css is still around.  This function grabs
- * cgroup_mutex and drains the previous css instances of @cgrp's subtree.
+ * controller while the previous css is still around. This function grabs
+ * cgroup_mutex and waits until no css in @cgrp's subtree is dying. A dying css
+ * offlines only after every task that still pins it has finished exiting, which
+ * can take arbitrarily long, so the wait is interruptible.
+ *
+ * Returns 0 with cgroup_mutex held once the subtree is drained, or -ERESTARTSYS
+ * without it if interrupted by a signal.
  */
-void cgroup_lock_and_drain_offline(struct cgroup *cgrp)
-	__acquires(&cgroup_mutex)
+int cgroup_lock_and_drain_offline(struct cgroup *cgrp)
 {
 	struct cgroup *dsct;
 	struct cgroup_subsys_state *d_css;
 	struct cgroup_subsys *ss;
-	int ssid;
+	int ssid, ret;
 
 restart:
 	cgroup_lock();
@@ -3343,17 +3358,20 @@ void cgroup_lock_and_drain_offline(struct cgroup *cgrp)
 				continue;
 
 			cgroup_get_live(dsct);
-			prepare_to_wait(&dsct->offline_waitq, &wait,
-					TASK_UNINTERRUPTIBLE);
-
+			ret = prepare_to_wait_event(&dsct->offline_waitq, &wait,
+						    TASK_INTERRUPTIBLE);
 			cgroup_unlock();
-			schedule();
+			if (!ret)
+				schedule();
 			finish_wait(&dsct->offline_waitq, &wait);
-
 			cgroup_put(dsct);
+			if (unlikely(ret))
+				return ret;
 			goto restart;
 		}
 	}
+
+	return 0;
 }
 
 /**
-- 
2.53.0




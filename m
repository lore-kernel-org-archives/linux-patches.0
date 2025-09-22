Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD3D25F780;
	Mon, 22 Sep 2025 19:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569656; cv=none; b=SO8bPrNVUiy7Pk7zcoBqy+CACoQ1JmtNndJS4Z95nYEMQN/jxWevsgAL8vbGnvtme/ymsybbDjLQRGLFCds66frkVK3/BDQs2zO4OgzileO0BrV5ai7YEDnEMgn2/e1bYXo/xA3QNrx6Xwdw0gX8IsiddlP4XnRbggpmVatFN/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569656; c=relaxed/simple;
	bh=e/SjXS7oiM25DDt3rf4N1Fe9dm2nTn+R9oDNTMOB76c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OgQvXXyS8qG3mqQSL0LO+hyqBnRphRK+SUvTOPfnWwcMADWPk6CixEBqOcSi6BORWEKfkk2CJy2fjLkI1T3kMbDcZxfSpP+30td7MO7abLxsfYP1fYsDNN/uNwuxOR7ysslS8mjldyWR+mIMFSQmk7j01jXZjLzySSZT4/O0UMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhOvUTYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhOvUTYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FDDC4CEF0;
	Mon, 22 Sep 2025 19:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569656;
	bh=e/SjXS7oiM25DDt3rf4N1Fe9dm2nTn+R9oDNTMOB76c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhOvUTYnpZfl9B51qxeA7TyT8coI7RQVOl6ydh2pPxHNy/iNGYYzdIHWHkJjUJro/
	 41aa7JvpkZakyAh4u/XKOooeJiMwwzvr4yw5hG0TxpuTnor4U6d1K70AeDsDUnAMwl
	 /igba3GL90BC7o7wmiJ9pIESUNFfL3Km2JhiZIs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Yingjie <gaoyingjie@uniontech.com>,
	Chen Ridong <chenridong@huawei.com>,
	Teju Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 06/70] cgroup: split cgroup_destroy_wq into 3 workqueues
Date: Mon, 22 Sep 2025 21:29:06 +0200
Message-ID: <20250922192404.646095954@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit 79f919a89c9d06816dbdbbd168fa41d27411a7f9 ]

A hung task can occur during [1] LTP cgroup testing when repeatedly
mounting/unmounting perf_event and net_prio controllers with
systemd.unified_cgroup_hierarchy=1. The hang manifests in
cgroup_lock_and_drain_offline() during root destruction.

Related case:
cgroup_fj_function_perf_event cgroup_fj_function.sh perf_event
cgroup_fj_function_net_prio cgroup_fj_function.sh net_prio

Call Trace:
	cgroup_lock_and_drain_offline+0x14c/0x1e8
	cgroup_destroy_root+0x3c/0x2c0
	css_free_rwork_fn+0x248/0x338
	process_one_work+0x16c/0x3b8
	worker_thread+0x22c/0x3b0
	kthread+0xec/0x100
	ret_from_fork+0x10/0x20

Root Cause:

CPU0                            CPU1
mount perf_event                umount net_prio
cgroup1_get_tree                cgroup_kill_sb
rebind_subsystems               // root destruction enqueues
				// cgroup_destroy_wq
// kill all perf_event css
                                // one perf_event css A is dying
                                // css A offline enqueues cgroup_destroy_wq
                                // root destruction will be executed first
                                css_free_rwork_fn
                                cgroup_destroy_root
                                cgroup_lock_and_drain_offline
                                // some perf descendants are dying
                                // cgroup_destroy_wq max_active = 1
                                // waiting for css A to die

Problem scenario:
1. CPU0 mounts perf_event (rebind_subsystems)
2. CPU1 unmounts net_prio (cgroup_kill_sb), queuing root destruction work
3. A dying perf_event CSS gets queued for offline after root destruction
4. Root destruction waits for offline completion, but offline work is
   blocked behind root destruction in cgroup_destroy_wq (max_active=1)

Solution:
Split cgroup_destroy_wq into three dedicated workqueues:
cgroup_offline_wq – Handles CSS offline operations
cgroup_release_wq – Manages resource release
cgroup_free_wq – Performs final memory deallocation

This separation eliminates blocking in the CSS free path while waiting for
offline operations to complete.

[1] https://github.com/linux-test-project/ltp/blob/master/runtest/controllers
Fixes: 334c3679ec4b ("cgroup: reimplement rebind_subsystems() using cgroup_apply_control() and friends")
Reported-by: Gao Yingjie <gaoyingjie@uniontech.com>
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Suggested-by: Teju Heo <tj@kernel.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 43 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index e8ef062f6ca05..5135838b5899f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -123,8 +123,31 @@ DEFINE_PERCPU_RWSEM(cgroup_threadgroup_rwsem);
  * of concurrent destructions.  Use a separate workqueue so that cgroup
  * destruction work items don't end up filling up max_active of system_wq
  * which may lead to deadlock.
+ *
+ * A cgroup destruction should enqueue work sequentially to:
+ * cgroup_offline_wq: use for css offline work
+ * cgroup_release_wq: use for css release work
+ * cgroup_free_wq: use for free work
+ *
+ * Rationale for using separate workqueues:
+ * The cgroup root free work may depend on completion of other css offline
+ * operations. If all tasks were enqueued to a single workqueue, this could
+ * create a deadlock scenario where:
+ * - Free work waits for other css offline work to complete.
+ * - But other css offline work is queued after free work in the same queue.
+ *
+ * Example deadlock scenario with single workqueue (cgroup_destroy_wq):
+ * 1. umount net_prio
+ * 2. net_prio root destruction enqueues work to cgroup_destroy_wq (CPUx)
+ * 3. perf_event CSS A offline enqueues work to same cgroup_destroy_wq (CPUx)
+ * 4. net_prio cgroup_destroy_root->cgroup_lock_and_drain_offline.
+ * 5. net_prio root destruction blocks waiting for perf_event CSS A offline,
+ *    which can never complete as it's behind in the same queue and
+ *    workqueue's max_active is 1.
  */
-static struct workqueue_struct *cgroup_destroy_wq;
+static struct workqueue_struct *cgroup_offline_wq;
+static struct workqueue_struct *cgroup_release_wq;
+static struct workqueue_struct *cgroup_free_wq;
 
 /* generate an array of cgroup subsystem pointers */
 #define SUBSYS(_x) [_x ## _cgrp_id] = &_x ## _cgrp_subsys,
@@ -5435,7 +5458,7 @@ static void css_release_work_fn(struct work_struct *work)
 	cgroup_unlock();
 
 	INIT_RCU_WORK(&css->destroy_rwork, css_free_rwork_fn);
-	queue_rcu_work(cgroup_destroy_wq, &css->destroy_rwork);
+	queue_rcu_work(cgroup_free_wq, &css->destroy_rwork);
 }
 
 static void css_release(struct percpu_ref *ref)
@@ -5444,7 +5467,7 @@ static void css_release(struct percpu_ref *ref)
 		container_of(ref, struct cgroup_subsys_state, refcnt);
 
 	INIT_WORK(&css->destroy_work, css_release_work_fn);
-	queue_work(cgroup_destroy_wq, &css->destroy_work);
+	queue_work(cgroup_release_wq, &css->destroy_work);
 }
 
 static void init_and_link_css(struct cgroup_subsys_state *css,
@@ -5566,7 +5589,7 @@ static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 err_free_css:
 	list_del_rcu(&css->rstat_css_node);
 	INIT_RCU_WORK(&css->destroy_rwork, css_free_rwork_fn);
-	queue_rcu_work(cgroup_destroy_wq, &css->destroy_rwork);
+	queue_rcu_work(cgroup_free_wq, &css->destroy_rwork);
 	return ERR_PTR(err);
 }
 
@@ -5801,7 +5824,7 @@ static void css_killed_ref_fn(struct percpu_ref *ref)
 
 	if (atomic_dec_and_test(&css->online_cnt)) {
 		INIT_WORK(&css->destroy_work, css_killed_work_fn);
-		queue_work(cgroup_destroy_wq, &css->destroy_work);
+		queue_work(cgroup_offline_wq, &css->destroy_work);
 	}
 }
 
@@ -6173,8 +6196,14 @@ static int __init cgroup_wq_init(void)
 	 * We would prefer to do this in cgroup_init() above, but that
 	 * is called before init_workqueues(): so leave this until after.
 	 */
-	cgroup_destroy_wq = alloc_workqueue("cgroup_destroy", 0, 1);
-	BUG_ON(!cgroup_destroy_wq);
+	cgroup_offline_wq = alloc_workqueue("cgroup_offline", 0, 1);
+	BUG_ON(!cgroup_offline_wq);
+
+	cgroup_release_wq = alloc_workqueue("cgroup_release", 0, 1);
+	BUG_ON(!cgroup_release_wq);
+
+	cgroup_free_wq = alloc_workqueue("cgroup_free", 0, 1);
+	BUG_ON(!cgroup_free_wq);
 	return 0;
 }
 core_initcall(cgroup_wq_init);
-- 
2.51.0




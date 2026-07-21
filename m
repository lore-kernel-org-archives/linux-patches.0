Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB11347BC6;
	Tue, 21 Jul 2026 22:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674715; cv=none; b=JLj8U5pfwFdMeUVHMzmCzq5jPsj22y9TPfLEdmTOUM/fddzYt7GqyeSuU4+mGlniZHiG/UM4gCOGkvEe/3gRb5erupw7UtVDIqt95OtW3kQrrMyMw07Yk497KtUKEkFXuRcXSSFGUpZpZ+UpXNJrsVrRmewBOmHSRSsVBfM5ujI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674715; c=relaxed/simple;
	bh=G/gNI3/hNC42n9hABBsfX13XfBWnVefp4ISwq6TS2fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljgXbjG+n9kpFhADH+DWBhRSpofFqEWG3dnCZsy0O4GfSU98nBA+gZbEycNs3DEO9c1S4XUu+WkVDxAvVd/Xk4g+putlFESIzcKzp/YDowo2zz29kSKhIlK4a9w9fd+W5BWvMzu4riy2gIrAbK2HflURO8deqByaemRET34HR0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=waaNrkqN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waaNrkqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820B31F000E9;
	Tue, 21 Jul 2026 22:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674714;
	bh=//FboLcASpD5XCwnk8n81NrlnvOeeSIE5UMp7g/seSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=waaNrkqNVAnPMW8XabagLlZd7tQEwDYqG5+VAt6XcDTGi0IKeOPyKgzuDfud3KxQb
	 g8I53h8acVzHdqERbfNJaed9ZEzkrfWJBwb+YEr+B0UIT/wMVibGqR82TI/t5Kcved
	 9pU1EJFO/UHgVtwY7yynMoZaXSBWa9vjF7Csp7oA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 646/699] writeback: fix race between cgroup_writeback_umount() and inode_switch_wbs()
Date: Tue, 21 Jul 2026 17:26:45 +0200
Message-ID: <20260721152410.325358054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun@linux.alibaba.com>

[ Upstream commit cba38ec4cbd3a7b8b942a8d52531a05be8a9ff0d ]

When a container exits, the following BUG_ON() is occasionally triggered:

==================================================================
 VFS: Busy inodes after unmount of sdb (ext4)
 ------------[ cut here ]------------
 kernel BUG at fs/super.c:695!
 CPU: 3 PID: 6 Comm: containerd-shim Tainted: G OE K 6.6 #1
 pstate: 63400009 (nZCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
 pc : generic_shutdown_super+0xf0/0x100
 lr : generic_shutdown_super+0xf0/0x100
 Call trace:
  generic_shutdown_super+0xf0/0x100
  kill_block_super+0x20/0x48
  ext4_kill_sb+0x28/0x60
  deactivate_locked_super+0x54/0x130
  deactivate_super+0x84/0xa0
  cleanup_mnt+0xa4/0x140
  __cleanup_mnt+0x18/0x28
  task_work_run+0x78/0xe0
  do_notify_resume+0x204/0x240
==================================================================

The root cause is a race between cgroup_writeback_umount() and
inode_switch_wbs()/cleanup_offline_cgwb(). There is a window between
inode_prepare_wbs_switch() returning true and the subsequent
wb_queue_isw() call. Following is the process that triggers the issue:

      CPU A (umount)           |          CPU B (writeback)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                 inode_switch_wbs/cleanup_offline_cgwb
                                  atomic_inc(&isw_nr_in_flight)
                                  inode_prepare_wbs_switch
                                   -> passes SB_ACTIVE check
                                   __iget(inode)
 generic_shutdown_super
  sb->s_flags &= ~SB_ACTIVE
  cgroup_writeback_umount(sb)
   smp_mb()
   atomic_read(&isw_nr_in_flight)
   rcu_barrier()
    -> no pending RCU callbacks
   flush_workqueue(isw_wq)
    -> nothing queued, returns
  evict_inodes(sb)
   -> Inode skipped as isw still holds a ref.
  sop->put_super(sb)
   /* destroys percpu counters */
  -> VFS: Busy inodes after unmount!
                                  wb_queue_isw()
                                   queue_work(isw_wq, ...)
                                  /* later in work function */
                                  inode_switch_wbs_work_fn
                                   process_inode_switch_wbs
                                    iput() -> evict
                                     percpu_counter_dec() // UAF!

Fix this by extending the RCU read-side critical section in
inode_switch_wbs() and cleanup_offline_cgwb() to cover from
inode_prepare_wbs_switch() through wb_queue_isw().  Since there is
no sleep in this window, rcu_read_lock() can be used.  Then add a
synchronize_rcu() in cgroup_writeback_umount() before the existing
rcu_barrier(), so that all in-flight switchers that have passed the
SB_ACTIVE check have completed queue_work() before flush_workqueue()
is called.

The existing rcu_barrier() is intentionally retained so this fix can
be backported unchanged to stable kernels (5.10.y, 6.6.y, ...) that
still queue switches via queue_rcu_work(). It is a no-op on current
mainline (since commit e1b849cfa6b6 ("writeback: Avoid contention on
wb->list_lock when switching inodes")) and is removed in a follow-up
patch.

Fixes: a1a0e23e4903 ("writeback: flush inode cgroup wb switches instead of pinning super_block")
Cc: stable@vger.kernel.org
Suggested-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/all/mxnjq2l6guusfchvauxr3v7c4bwjasybxlleqbbh4efloeqspz@iqylk76ohufz
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Link: https://patch.msgid.link/20260521095016.2791354-2-libaokun@linux.alibaba.com
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs-writeback.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -507,12 +507,18 @@ static void inode_switch_wbs(struct inod
 
 	atomic_inc(&isw_nr_in_flight);
 
-	/* find and pin the new wb */
+	/*
+	 * Paired with synchronize_rcu() in cgroup_writeback_umount():
+	 * holding rcu_read_lock across the SB_ACTIVE check, the inode
+	 * grab and call_rcu() ensures synchronize_rcu() cannot return
+	 * until the switch is queued, so the subsequent rcu_barrier()
+	 * and flush_workqueue() will wait for the switch.
+	 */
 	rcu_read_lock();
+	/* find and pin the new wb */
 	memcg_css = css_from_id(new_wb_id, &memory_cgrp_subsys);
 	if (memcg_css && !css_tryget(memcg_css))
 		memcg_css = NULL;
-	rcu_read_unlock();
 	if (!memcg_css)
 		goto out_free;
 
@@ -542,9 +548,11 @@ static void inode_switch_wbs(struct inod
 	 * Let's continue after I_WB_SWITCH is guaranteed to be visible.
 	 */
 	call_rcu(&isw->rcu_head, inode_switch_wbs_rcu_fn);
+	rcu_read_unlock();
 	return;
 
 out_free:
+	rcu_read_unlock();
 	atomic_dec(&isw_nr_in_flight);
 	if (isw->new_wb)
 		wb_put(isw->new_wb);
@@ -1011,6 +1019,14 @@ void cgroup_writeback_umount(void)
 {
 	if (atomic_read(&isw_nr_in_flight)) {
 		/*
+		 * Paired with rcu_read_lock() in inode_switch_wbs().
+		 * synchronize_rcu() waits for any in-flight switcher that
+		 * already passed the SB_ACTIVE check to finish calling
+		 * call_rcu(), so the rcu_barrier() and flush_workqueue()
+		 * below will then drain it.
+		 */
+		synchronize_rcu();
+		/*
 		 * Use rcu_barrier() to wait for all pending callbacks to
 		 * ensure that all in-flight wb switches are in the workqueue.
 		 */



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E523E3CEB92;
	Thu, 16 Jul 2026 14:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212072; cv=none; b=NejT6H6OYxbUXASHh7SVjRHFzKsqAcXnCjua6i1XMYiZ1TA2xM8SPW8cgG+2aKUb058N5Kc2avlsw40j0D0wWdyLqrPTswSrw+AlFfLkcVp5JKiKeR8J06Vaf+8GLCr3aiZyJmRHNGzDPysN+44/PIQS8yAMk2EIiKjwqun24z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212072; c=relaxed/simple;
	bh=fU+3mK1RHlAhb8gcpzfQoPV48ONPseQ6gCUGlbDE/iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCdQRReEM/EqS/Z2R7ip+Cd/Uu9uFb1rQHW04YnSvyIIt5Cgztt/6uDmf0D34v+QUKJkrJKLR9Ry1SVprTS5/HPrhdPM7zQCqijINb6Eu4KRDADxccPmDHaZmf0CstB1qAPulO21X6LfXuJagTVsBMDaW4A4PvhcQkr09etiq4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFmQD4bb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFmQD4bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566D21F00A3D;
	Thu, 16 Jul 2026 14:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212070;
	bh=v9l6bZfyR5qQElnILp2XlgtiM/a2rwbtTo9JuYeZ/x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FFmQD4bbLQp33DoO4QMSG1KxbjP6aELA78hESbORrCyxXOLS/LPcJ/8cuXURIGmo4
	 EWYbvJM9e5EFydpdxPldoLPsCCAwiY0PReo1R+d5EqKbJTc9CCz3mKrSmY4hKMSL8T
	 AVzUoIQxZqIId7Kr6CHlmW1Y/Y7vn4Z7Z8d2Ulso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 186/349] writeback: fix race between cgroup_writeback_umount() and inode_switch_wbs()
Date: Thu, 16 Jul 2026 15:32:00 +0200
Message-ID: <20260716133037.543618967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun@linux.alibaba.com>

commit cba38ec4cbd3a7b8b942a8d52531a05be8a9ff0d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs-writeback.c |   31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -651,12 +651,19 @@ static void inode_switch_wbs(struct inod
 
 	atomic_inc(&isw_nr_in_flight);
 
-	/* find and pin the new wb */
+	/*
+	 * Paired with synchronize_rcu() in cgroup_writeback_umount():
+	 * holding rcu_read_lock across inode_prepare_wbs_switch()
+	 * (covering the SB_ACTIVE check and the inode grab) and
+	 * wb_queue_isw() ensures synchronize_rcu() cannot return until
+	 * the work is queued, so the subsequent flush_workqueue() will
+	 * wait for the switch.
+	 */
 	rcu_read_lock();
+	/* find and pin the new wb */
 	memcg_css = css_from_id(new_wb_id, &memory_cgrp_subsys);
 	if (memcg_css && !css_tryget(memcg_css))
 		memcg_css = NULL;
-	rcu_read_unlock();
 	if (!memcg_css)
 		goto out_free;
 
@@ -671,9 +678,11 @@ static void inode_switch_wbs(struct inod
 	isw->inodes[0] = inode;
 
 	wb_queue_isw(new_wb, isw);
+	rcu_read_unlock();
 	return;
 
 out_free:
+	rcu_read_unlock();
 	atomic_dec(&isw_nr_in_flight);
 	if (new_wb)
 		wb_put(new_wb);
@@ -732,6 +741,14 @@ bool cleanup_offline_cgwb(struct bdi_wri
 		new_wb = &wb->bdi->wb; /* wb_get() is noop for bdi's wb */
 
 	nr = 0;
+	/*
+	 * Paired with synchronize_rcu() in cgroup_writeback_umount().
+	 * Holding rcu_read_lock across the SB_ACTIVE check, the inode grab
+	 * and wb_queue_isw() ensures synchronize_rcu() cannot return until
+	 * the work is queued, so the subsequent flush_workqueue() will wait
+	 * for the switch.
+	 */
+	rcu_read_lock();
 	spin_lock(&wb->list_lock);
 	/*
 	 * In addition to the inodes that have completed writeback, also switch
@@ -749,6 +766,7 @@ bool cleanup_offline_cgwb(struct bdi_wri
 
 	/* no attached inodes? bail out */
 	if (nr == 0) {
+		rcu_read_unlock();
 		atomic_dec(&isw_nr_in_flight);
 		wb_put(new_wb);
 		kfree(isw);
@@ -756,6 +774,7 @@ bool cleanup_offline_cgwb(struct bdi_wri
 	}
 
 	wb_queue_isw(new_wb, isw);
+	rcu_read_unlock();
 
 	return restart;
 }
@@ -1192,6 +1211,14 @@ void cgroup_writeback_umount(struct supe
 
 	if (atomic_read(&isw_nr_in_flight)) {
 		/*
+		 * Paired with rcu_read_lock() in inode_switch_wbs() and
+		 * cleanup_offline_cgwb().  synchronize_rcu() waits for any
+		 * in-flight switcher that already passed the SB_ACTIVE check
+		 * to finish queueing its work, so flush_workqueue() below
+		 * will then drain it.
+		 */
+		synchronize_rcu();
+		/*
 		 * Use rcu_barrier() to wait for all pending callbacks to
 		 * ensure that all in-flight wb switches are in the workqueue.
 		 */



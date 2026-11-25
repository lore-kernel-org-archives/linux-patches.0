Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620821;
	b=RAiV7WS6eSnTAnBhm/QKNU9Zt0Yi7f3JoLUTMTyAHGzVb6icIGy7HA22Bf+3nPrjPUrQ
	 LsS1OJV581nKfUqNvTB1Ud5/SAlTeOKPuQxSSJcbZU1Jgd0KBAzxf1okK4yNJz83afiJo
	 9mak7hdkTFhVj+6Og94PAqWZN5b0Kh0c6VFSJ8os8gWPgcFpEgSUJig3H/0FkuuXtE+rV
	 baJub/3pPqAzUeO00x33+vVPfglueKjysAk6z3FqRwxnAjXBbFKlKN0JatwnHvaWwN8V1
	 5p4BqEG61vPs17TYvLyLF4R9UJ+Pg/6C/Tk+PvV3ZJA4QA62YL1BAJvBrxFmyNPKR4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sm784Bzhr7dWzzQxH3zo81F5KxaxI+YuYCkohUM/OpM=;
	b=TK0l0FsgrzwFes6oc56ylp7hFgWy3rSirxD5kR+GxjRyo5vwuEQkjRpXsk3oLQ6HtJ7t
	 iHlQ85T2mTNtcYW9Ec6cVvkhtnxluumhx4EtIFzD/cDyUUu+I2IWCKVdsPp8sCMU7MmHm
	 BcvX1DCAkSOuEDzrdMf7sdx7fiO9oytduMHc0nmrfhdXYZcFrbzs7jVgVB5dxdA7sofYQ
	 mfqs4HLzvneLeVLVJquoKvRPiIbkpjqSQC9RK2RyQpfiDhVF785WIeSkIQytA5HcqEQOO
	 bZguGS+DjdpLc0AnIHgHd3h37RBK16rrkhm0O+RUSbI3Vil+wN69C3Wd/DZPznGcSXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LBbWbmFq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2E0606A31E;
	Wed, 25 Nov 2026 15:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LBbWbmFq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2592D1F000E0;
	Wed, 25 Nov 2026 15:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620820;
	bh=sm784Bzhr7dWzzQxH3zo81F5KxaxI+YuYCkohUM/OpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LBbWbmFqyPY4FckeTrfIsszndphT9cHCmxxBKJyeQeTy4/2OJRQ2LivGGfEhCngj4
	 bZDe2HOhngo4VSOtXK5u1gzNF1liMtZKf4BWnZ9aawrm2HEsXGQLDDfUxRSSRgKU/h
	 ZnydipWTBrD4w/WzSG2qp3uHMRODwLAp4pfJ262o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Eric Hagberg <ehagberg@janestreet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 016/990] writeback: use a per-sb counter to drain inode wb switches at umount
Date: Wed, 25 Nov 2026 15:23:03 +0100
Message-ID: <20261125143822.465844255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun@linux.alibaba.com>

commit 31c1d19ead2c26a63859a2757d8b786765ba9cdd upstream.

Tracking in-flight inode wb switches with a single global counter
(isw_nr_in_flight) plus a synchronize_rcu() based wait in
cgroup_writeback_umount() forces every umount to take a global hit
whenever any other superblock on the system has wb switches in flight,
even if the superblock being unmounted has none of its own.

Replace the global synchronize_rcu()/flush_workqueue() pair with a
per-sb counter, s_isw_nr_in_flight, plus three small helpers:

  - cgroup_writeback_pin(sb)   - increment counter
  - cgroup_writeback_unpin(sb) - decrement and wake drainer if last
  - cgroup_writeback_drain(sb) - wait for counter to reach zero

The wiring is:

  - inode_prepare_wbs_switch() pins before checking SB_ACTIVE and
    grabbing the inode; failure paths unpin before returning.  A
    lockless SB_ACTIVE check at the top of the function lets us skip
    the atomic_inc/smp_mb dance once SB_ACTIVE has been cleared (it
    is monotonic and never set back).
  - process_inode_switch_wbs() unpins after the matching iput().
  - cgroup_writeback_umount() drains the per-sb counter via
    wait_var_event().

The smp_mb() pair between inode_prepare_wbs_switch() and
cgroup_writeback_umount() keeps the SB_ACTIVE / counter ordering:
either the umounter sees a non-zero counter and waits, or the
switcher sees SB_ACTIVE cleared and aborts before grabbing the
inode.

The global isw_nr_in_flight is left in place, since it is still used
to throttle in-flight switches via WB_FRN_MAX_IN_FLIGHT.

The rcu_read_lock() extension in inode_switch_wbs() and
cleanup_offline_cgwb() that the race fix added is no longer needed
and is reverted; the synchronize_rcu() that the race fix added to
cgroup_writeback_umount() is dropped as well.

The following numbers were measured on a 16 vCPU QEMU guest with 4
background superblocks each churning "create memcg -> write 1 MiB ->
rmdir memcg" to keep the global isw_nr_in_flight non-zero.  Latencies
are wall-clock around umount(8); only the target sb's umount is
measured.

Target sb runs its own cgwb churn:

                              p50      p95      p99      max
  global synchronize_rcu()   67.6 ms  88.3 ms  88.3 ms  96.8 ms
  per-sb counter (this)       7.9 ms  10.0 ms  10.0 ms  10.1 ms

Idle target umount latency under cross-sb cgwb-switch pressure:

                              p50      p95      p99      max
  global synchronize_rcu()   62.7 ms  95.4 ms 108.1 ms 108.6 ms
  per-sb counter (this)       5.3 ms   6.9 ms   7.4 ms   7.4 ms
  no-pressure baseline        4.9 ms   5.9 ms   6.3 ms   6.7 ms

8 concurrent umounts of idle sbs under the same pressure:

                              p50      p95      max
  global synchronize_rcu()   61.3 ms  99.5 ms 113.7 ms
  per-sb counter (this)       8.1 ms   9.1 ms   9.5 ms

In-kernel cgroup_writeback_umount() time across the same run
(bpftrace, ~340 calls covering all scenarios):

  global synchronize_rcu()    12371 ms total (~36 ms / call)
  per-sb counter (this)        1.37 ms total ( ~4 us / call)

Suggested-by: Christian Brauner <brauner@kernel.org>
Link: https://lore.kernel.org/r/177910456953.488929.2169908940676707307.b4-review@b4
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Link: https://patch.msgid.link/20260521095016.2791354-4-libaokun@linux.alibaba.com
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ ehagberg: Backported to 6.18.y. struct super_block lives in
  include/linux/fs.h here, so add the field there. 6.18.y predates the
  inode_state_read()/inode_state_set() accessors, so adjust context
  accordingly. Also adjust context in cleanup_offline_cgwb() for
  "writeback: keep cleanup_offline_cgwb()'s scan out of syncs".
  No functional change from upstream. ]
Signed-off-by: Eric Hagberg <ehagberg@janestreet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c  | 97 ++++++++++++++++++++++------------------------
 include/linux/fs.h |  8 ++++
 2 files changed, 55 insertions(+), 50 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a390cb6b14c6f..47bce548278c1 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -488,6 +488,23 @@ static bool inode_do_switch_wbs(struct inode *inode,
 	return switched;
 }
 
+static inline void cgroup_writeback_pin(struct super_block *sb)
+{
+	atomic_inc(&sb->s_isw_nr_in_flight);
+}
+
+static inline void cgroup_writeback_unpin(struct super_block *sb)
+{
+	if (atomic_dec_and_test(&sb->s_isw_nr_in_flight))
+		wake_up_var(&sb->s_isw_nr_in_flight);
+}
+
+static inline void cgroup_writeback_drain(struct super_block *sb)
+{
+	wait_var_event(&sb->s_isw_nr_in_flight,
+		       !atomic_read(&sb->s_isw_nr_in_flight));
+}
+
 static void process_inode_switch_wbs(struct bdi_writeback *new_wb,
 				     struct inode_switch_wbs_context *isw)
 {
@@ -546,8 +563,12 @@ static void process_inode_switch_wbs(struct bdi_writeback *new_wb,
 		wb_put_many(old_wb, nr_switched);
 	}
 
-	for (inodep = isw->inodes; *inodep; inodep++)
+	for (inodep = isw->inodes; *inodep; inodep++) {
+		struct super_block *sb = (*inodep)->i_sb;
+
 		iput(*inodep);
+		cgroup_writeback_unpin(sb);
+	}
 	wb_put(new_wb);
 	kfree(isw);
 	atomic_dec(&isw_nr_in_flight);
@@ -590,16 +611,19 @@ void inode_switch_wbs_work_fn(struct work_struct *work)
 static bool inode_prepare_wbs_switch(struct inode *inode,
 				     struct bdi_writeback *new_wb)
 {
+	/* Avoid the atomic_inc/smp_mb dance once SB_ACTIVE is gone. */
+	if (!(inode->i_sb->s_flags & SB_ACTIVE))
+		return false;
+
 	/*
-	 * Paired with smp_mb() in cgroup_writeback_umount().
-	 * isw_nr_in_flight must be increased before checking SB_ACTIVE and
-	 * grabbing an inode, otherwise isw_nr_in_flight can be observed as 0
-	 * in cgroup_writeback_umount() and the isw_wq will be not flushed.
+	 * Pairs with smp_mb() in cgroup_writeback_umount(): the umounter either
+	 * sees a non-zero counter and waits, or we see SB_ACTIVE clear below.
 	 */
+	cgroup_writeback_pin(inode->i_sb);
 	smp_mb();
 
 	if (IS_DAX(inode))
-		return false;
+		goto out_unpin;
 
 	/* while holding I_WB_SWITCH, no one else can update the association */
 	spin_lock(&inode->i_lock);
@@ -607,13 +631,17 @@ static bool inode_prepare_wbs_switch(struct inode *inode,
 	    inode->i_state & (I_WB_SWITCH | I_FREEING | I_WILL_FREE) ||
 	    inode_to_wb(inode) == new_wb) {
 		spin_unlock(&inode->i_lock);
-		return false;
+		goto out_unpin;
 	}
 	inode->i_state |= I_WB_SWITCH;
 	__iget(inode);
 	spin_unlock(&inode->i_lock);
 
 	return true;
+
+out_unpin:
+	cgroup_writeback_unpin(inode->i_sb);
+	return false;
 }
 
 static void wb_queue_isw(struct bdi_writeback *wb,
@@ -652,19 +680,12 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
 
 	atomic_inc(&isw_nr_in_flight);
 
-	/*
-	 * Paired with synchronize_rcu() in cgroup_writeback_umount():
-	 * holding rcu_read_lock across inode_prepare_wbs_switch()
-	 * (covering the SB_ACTIVE check and the inode grab) and
-	 * wb_queue_isw() ensures synchronize_rcu() cannot return until
-	 * the work is queued, so the subsequent flush_workqueue() will
-	 * wait for the switch.
-	 */
-	rcu_read_lock();
 	/* find and pin the new wb */
+	rcu_read_lock();
 	memcg_css = css_from_id(new_wb_id, &memory_cgrp_subsys);
 	if (memcg_css && !css_tryget(memcg_css))
 		memcg_css = NULL;
+	rcu_read_unlock();
 	if (!memcg_css)
 		goto out_free;
 
@@ -680,11 +701,9 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
 
 	trace_inode_switch_wbs_queue(inode->i_wb, new_wb, 1);
 	wb_queue_isw(new_wb, isw);
-	rcu_read_unlock();
 	return;
 
 out_free:
-	rcu_read_unlock();
 	atomic_dec(&isw_nr_in_flight);
 	if (new_wb)
 		wb_put(new_wb);
@@ -765,14 +784,6 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 	 * moved ones. Exclude syncs as process_inode_switch_wbs() does.
 	 */
 	down_read(&wb->bdi->wb_switch_rwsem);
-	/*
-	 * Paired with synchronize_rcu() in cgroup_writeback_umount().
-	 * Holding rcu_read_lock across the SB_ACTIVE check, the inode grab
-	 * and wb_queue_isw() ensures synchronize_rcu() cannot return until
-	 * the work is queued, so the subsequent flush_workqueue() will wait
-	 * for the switch.
-	 */
-	rcu_read_lock();
 	spin_lock(&wb->list_lock);
 	/*
 	 * In addition to the inodes that have completed writeback, also switch
@@ -791,7 +802,6 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 
 	/* no attached inodes? bail out */
 	if (nr == 0) {
-		rcu_read_unlock();
 		atomic_dec(&isw_nr_in_flight);
 		wb_put(new_wb);
 		kfree(isw);
@@ -800,7 +810,6 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
 
 	trace_inode_switch_wbs_queue(wb, new_wb, nr);
 	wb_queue_isw(new_wb, isw);
-	rcu_read_unlock();
 
 	return restart;
 }
@@ -1228,39 +1237,27 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 }
 
 /**
- * cgroup_writeback_umount - flush inode wb switches for umount
+ * cgroup_writeback_umount - wait for in-flight inode wb switches on @sb
  * @sb: target super_block
  *
- * This function is called when a super_block is about to be destroyed and
- * flushes in-flight inode wb switches.  An inode wb switch goes through
- * RCU and then workqueue, so the two need to be flushed in order to ensure
- * that all previously scheduled switches are finished.  As wb switches are
- * rare occurrences and synchronize_rcu() can take a while, perform
- * flushing iff wb switches are in flight.
+ * Wait until every inode wb switch that already passed the SB_ACTIVE
+ * check on this superblock has been completed by the worker.  Since
+ * SB_ACTIVE is cleared before this is called, no new switches can start
+ * for @sb, so s_isw_nr_in_flight will monotonically drop to zero.
  */
 void cgroup_writeback_umount(struct super_block *sb)
 {
-
 	if (!(sb->s_bdi->capabilities & BDI_CAP_WRITEBACK))
 		return;
 
 	/*
-	 * SB_ACTIVE should be reliably cleared before checking
-	 * isw_nr_in_flight, see generic_shutdown_super().
+	 * Pairs with smp_mb() in inode_prepare_wbs_switch(): we either observe
+	 * a non-zero counter and wait, or the switcher sees SB_ACTIVE clear
+	 * (cleared by generic_shutdown_super()) and bails before grabbing the
+	 * inode.
 	 */
 	smp_mb();
-
-	if (atomic_read(&isw_nr_in_flight)) {
-		/*
-		 * Paired with rcu_read_lock() in inode_switch_wbs() and
-		 * cleanup_offline_cgwb().  synchronize_rcu() waits for any
-		 * in-flight switcher that already passed the SB_ACTIVE check
-		 * to finish queueing its work, so flush_workqueue() below
-		 * will then drain it.
-		 */
-		synchronize_rcu();
-		flush_workqueue(isw_wq);
-	}
+	cgroup_writeback_drain(sb);
 }
 
 static int __init cgroup_writeback_init(void)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 09cbcfbf295f6..b83b5a0761904 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1660,6 +1660,14 @@ struct super_block {
 
 	spinlock_t		s_inode_wblist_lock;
 	struct list_head	s_inodes_wb;	/* writeback inodes */
+
+#ifdef CONFIG_CGROUP_WRITEBACK
+	/*
+	 * Number of in-flight inode wb switches for this sb.  Drained by
+	 * cgroup_writeback_umount() before tear-down.
+	 */
+	atomic_t		s_isw_nr_in_flight;
+#endif
 } __randomize_layout;
 
 static inline struct user_namespace *i_user_ns(const struct inode *inode)
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056244;
	b=jyR82ixN+omOS/fm6zbEbf0QbcuLxxgwiztkgtF1jkxrOK9AhEVyCjNJtubg4sVIq7Vm
	 TEnNy0ePDMl+vn4nIIR1piHhRKkU+uw5fmpk3eaV7btjY/LOTnN8XhsoleTfGUy3sSsg8
	 2IFoThuThQsd30zN1B7Wef0d1XY837PJCBa3bnEYSP1f3XpPvj4ixTrTNpuB7ELX8sfx4
	 1+oVBT1+CXx+VWsECyQG8xrASEc41nmr69EpNjrg6VgYSf7jYVvKd7ry7JDzRcvfzDT9O
	 xbEvDX9MqOuPPpa1Da2Z67IRXuxwt5qxJ7o4tg4/JjcnzcLzB6BoaUzMAYWiyHRHT2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W7RN2ROt8zBCsaO27qw1hjBSebq+2NjPAJiOENUTQYc=;
	b=xqgsuUBxFienhfyytLGcsf2r3Ks/OFa/wuKCOdnypKxQ9gcEbOG8p3MYcWjEnOKbwmoJ
	 Ry0LdbcK6qzbMMuKnswAe0JQmoN+ilSniGOATasBmWn6uCKSsYW/sS+ACeshxaKWEL4LU
	 DApIMk+hE9FL8rY5tkIfjQQy/VtAz3PQs6FGsA9ZTZm2elaInAYmkLmfJYR6vqoH/1oBl
	 Mbus6fnmhVoyCjf5klkgdaywVy3o6s3liSoWwb4pdB/rsVeEfhLflCW2pBkoPJPY/0awb
	 vErQ8f/QVVB5r78q2VROEV7jjxRse17Gh1LYQ9AdHo6yAcyfXK3b3BBQuGnwZ8IlGUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGFj5fPk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E875A606A31C;
	Thu, 19 Nov 2026 02:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGFj5fPk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB721F000C4;
	Thu, 19 Nov 2026 02:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056243;
	bh=W7RN2ROt8zBCsaO27qw1hjBSebq+2NjPAJiOENUTQYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGFj5fPk6zwMujr8Mgv0gcLRzAy3TLoiRM0QDso/OQwtt5tS9zWkApVY5Xqke+v2K
	 zQNcVI5ypEG+hna5FQVY+I1QIM0gidJInYWVSkDM1msmfWDKINSQ80an8qzaH+Xi/U
	 sbxOOiDSNyjUoqolgH7aWnYNAfN5xWpWm6IVlGe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot+a68ce48df87b8e36e915@syzkaller.appspotmail.com,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1901/2214] ocfs2: fix possible deadlock between nfs_sync_rwlock and fs_reclaim
Date: Wed, 18 Nov 2026 15:59:37 +0100
Message-ID: <20261118150127.198765508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 169bc4d16a8efa7852b101fdaa4c028505cd6750 ]

syzbot detected a circular locking dependency on &osb->nfs_sync_rwlock:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);
                               lock(fs_reclaim);
  rlock(&osb->nfs_sync_rwlock);

 *** DEADLOCK ***

Chain exists of:
  &osb->nfs_sync_rwlock --> &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE] --> fs_reclaim

CPU0 is kswapd.  The dentry shrinker runs under fs_reclaim and reaches
ocfs2_delete_inode() through ->evict_inode():

kswapd
 balance_pgdat
  shrink_node
   shrink_slab
    super_cache_scan
     prune_dcache_sb
      shrink_dentry_list
       dentry_kill
        ocfs2_dentry_iput
         evict
          ocfs2_evict_inode
           ocfs2_delete_inode
            ocfs2_nfs_sync_lock
             down_read(&osb->nfs_sync_rwlock)      //C0: grabbing

CPU1 is a task deleting an inode.  It takes nfs_sync_rwlock first, then
the orphan dir and inode alloc system inode i_rwsems, and allocates the
metadata reservation with GFP_KERNEL while holding them:

evict
 ocfs2_evict_inode
  ocfs2_delete_inode
  + ocfs2_nfs_sync_lock
  |  down_read(&osb->nfs_sync_rwlock)              //C1: hold
  + ocfs2_wipe_inode
     + inode_lock(orphan_dir_inode)                //C1: hold
     + ocfs2_truncate_for_delete
     |  ocfs2_commit_truncate
     |   ocfs2_remove_btree_range
     |    ocfs2_reserve_blocks_for_rec_trunc
     |     ocfs2_reserve_new_metadata_blocks
     |      kzalloc_obj()                          //C1: grabbing
     |      // GFP_KERNEL -> might_alloc -> fs_reclaim_acquire
     + ocfs2_remove_inode
        inode_lock(inode_alloc_inode)

jbd2 pins allocations to GFP_NOFS for the lifetime of a transaction
handle, but these reservations are made before ocfs2_start_trans(), so
fs_reclaim is acquired with ocfs2 locks still held and the cycle closes.

The same cycle is reachable from ocfs2_get_dentry() and
ocfs2_get_parent(), which hold nfs_sync_rwlock for write across
ocfs2_test_inode_bit() and ocfs2_iget().

This is more than a lockdep artifact.  A GFP_KERNEL allocation under the
orphan dir i_rwsem enters direct reclaim, which runs the shrinkers, which
can evict another ocfs2 inode and re-enter ocfs2_wipe_inode() on the same
task; the second inode_lock() on the singleton orphan dir inode then
self-deadlocks, since i_rwsem is not recursive.

Establish a GFP_NOFS allocation context for the whole nfs_sync_rwlock
critical section so that nothing holding it can recurse into filesystem
reclaim.  Do it in ocfs2_nfs_sync_lock()/ocfs2_nfs_sync_unlock() rather
than at the call sites, so that future callers cannot forget it.

Link: https://lore.kernel.org/20260922093437.954127-1-joseph.qi@linux.alibaba.com
Fixes: 6ca497a83e59 ("ocfs2: fix rare stale inode errors when exporting via nfs")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+a68ce48df87b8e36e915@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a68ce48df87b8e36e915
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dlmglue.c | 29 +++++++++++++++++++++++++----
 fs/ocfs2/dlmglue.h |  5 +++--
 fs/ocfs2/export.c  | 10 ++++++----
 fs/ocfs2/inode.c   |  5 +++--
 4 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index c8cda79945317..f0febcca61f6f 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -19,6 +19,7 @@
 #include <linux/time.h>
 #include <linux/delay.h>
 #include <linux/quotaops.h>
+#include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
 
 #define MLOG_MASK_PREFIX ML_DLM_GLUE
@@ -2853,21 +2854,34 @@ void ocfs2_rename_unlock(struct ocfs2_super *osb)
 		ocfs2_cluster_unlock(osb, lockres, DLM_LOCK_EX);
 }
 
-int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex)
+int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex, unsigned int *nofs_flag)
 {
 	int status;
+	unsigned int flags;
 	struct ocfs2_lock_res *lockres = &osb->osb_nfs_sync_lockres;
 
 	if (ocfs2_is_hard_readonly(osb))
 		return -EROFS;
 
+	/*
+	 * ocfs2_delete_inode() takes this lock from ->evict_inode(), which the
+	 * dentry shrinker reaches while holding fs_reclaim.  Anything allocated
+	 * under the lock must therefore stay out of filesystem reclaim, or
+	 * reclaim recurses back into the shrinker and tries to take this lock
+	 * again.  Cover the whole critical section, including the cluster lock
+	 * and the sysfile inode locks the callers take below it.
+	 */
+	flags = memalloc_nofs_save();
+
 	if (ex)
 		down_write(&osb->nfs_sync_rwlock);
 	else
 		down_read(&osb->nfs_sync_rwlock);
 
-	if (ocfs2_mount_local(osb))
+	if (ocfs2_mount_local(osb)) {
+		*nofs_flag = flags;
 		return 0;
+	}
 
 	status = ocfs2_cluster_lock(osb, lockres, ex ? LKM_EXMODE : LKM_PRMODE,
 				    0, 0);
@@ -2878,12 +2892,17 @@ int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex)
 			up_write(&osb->nfs_sync_rwlock);
 		else
 			up_read(&osb->nfs_sync_rwlock);
+		memalloc_nofs_restore(flags);
+		return status;
 	}
 
-	return status;
+	*nofs_flag = flags;
+
+	return 0;
 }
 
-void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, int ex)
+void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, int ex,
+			   unsigned int nofs_flag)
 {
 	struct ocfs2_lock_res *lockres = &osb->osb_nfs_sync_lockres;
 
@@ -2894,6 +2913,8 @@ void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, int ex)
 		up_write(&osb->nfs_sync_rwlock);
 	else
 		up_read(&osb->nfs_sync_rwlock);
+
+	memalloc_nofs_restore(nofs_flag);
 }
 
 int ocfs2_trim_fs_lock(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/dlmglue.h b/fs/ocfs2/dlmglue.h
index e5da5809ed95b..dc383a0a87cbe 100644
--- a/fs/ocfs2/dlmglue.h
+++ b/fs/ocfs2/dlmglue.h
@@ -163,8 +163,9 @@ void ocfs2_orphan_scan_unlock(struct ocfs2_super *osb, u32 seqno);
 
 int ocfs2_rename_lock(struct ocfs2_super *osb);
 void ocfs2_rename_unlock(struct ocfs2_super *osb);
-int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex);
-void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, int ex);
+int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int ex, unsigned int *nofs_flag);
+void ocfs2_nfs_sync_unlock(struct ocfs2_super *osb, int ex,
+			   unsigned int nofs_flag);
 void ocfs2_trim_fs_lock_res_init(struct ocfs2_super *osb);
 void ocfs2_trim_fs_lock_res_uninit(struct ocfs2_super *osb);
 int ocfs2_trim_fs_lock(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index eaa8c80ace3cd..41048591ebcf1 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -37,6 +37,7 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 	struct inode *inode;
 	struct ocfs2_super *osb = OCFS2_SB(sb);
 	u64 blkno = handle->ih_blkno;
+	unsigned int nofs_flag = 0;
 	int status, set;
 	struct dentry *result;
 
@@ -59,7 +60,7 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 	 * This will synchronize us against ocfs2_delete_inode() on
 	 * all nodes
 	 */
-	status = ocfs2_nfs_sync_lock(osb, 1);
+	status = ocfs2_nfs_sync_lock(osb, 1, &nofs_flag);
 	if (status < 0) {
 		mlog(ML_ERROR, "getting nfs sync lock(EX) failed %d\n", status);
 		goto check_err;
@@ -89,7 +90,7 @@ static struct dentry *ocfs2_get_dentry(struct super_block *sb,
 	inode = ocfs2_iget(osb, blkno, 0, 0);
 
 unlock_nfs_sync:
-	ocfs2_nfs_sync_unlock(osb, 1);
+	ocfs2_nfs_sync_unlock(osb, 1, nofs_flag);
 
 check_err:
 	if (status < 0) {
@@ -132,12 +133,13 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
 	u64 blkno;
 	struct dentry *parent;
 	struct inode *dir = d_inode(child);
+	unsigned int nofs_flag = 0;
 	int set;
 
 	trace_ocfs2_get_parent(child, child->d_name.len, child->d_name.name,
 			       (unsigned long long)OCFS2_I(dir)->ip_blkno);
 
-	status = ocfs2_nfs_sync_lock(OCFS2_SB(dir->i_sb), 1);
+	status = ocfs2_nfs_sync_lock(OCFS2_SB(dir->i_sb), 1, &nofs_flag);
 	if (status < 0) {
 		mlog(ML_ERROR, "getting nfs sync lock(EX) failed %d\n", status);
 		parent = ERR_PTR(status);
@@ -181,7 +183,7 @@ static struct dentry *ocfs2_get_parent(struct dentry *child)
 	ocfs2_inode_unlock(dir, 0);
 
 unlock_nfs_sync:
-	ocfs2_nfs_sync_unlock(OCFS2_SB(dir->i_sb), 1);
+	ocfs2_nfs_sync_unlock(OCFS2_SB(dir->i_sb), 1, nofs_flag);
 
 bail:
 	trace_ocfs2_get_parent_end(parent);
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index ce1469f969154..4a335eb48da99 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -1026,6 +1026,7 @@ static void ocfs2_delete_inode(struct inode *inode)
 {
 	int wipe, status;
 	sigset_t oldset;
+	unsigned int nofs_flag = 0;
 	struct buffer_head *di_bh = NULL;
 	struct ocfs2_dinode *di = NULL;
 
@@ -1060,7 +1061,7 @@ static void ocfs2_delete_inode(struct inode *inode)
 	 * shared mode so that all nodes can still concurrently
 	 * process deletes.
 	 */
-	status = ocfs2_nfs_sync_lock(OCFS2_SB(inode->i_sb), 0);
+	status = ocfs2_nfs_sync_lock(OCFS2_SB(inode->i_sb), 0, &nofs_flag);
 	if (status < 0) {
 		mlog(ML_ERROR, "getting nfs sync lock(PR) failed %d\n", status);
 		ocfs2_cleanup_delete_inode(inode, 0);
@@ -1132,7 +1133,7 @@ static void ocfs2_delete_inode(struct inode *inode)
 	brelse(di_bh);
 
 bail_unlock_nfs_sync:
-	ocfs2_nfs_sync_unlock(OCFS2_SB(inode->i_sb), 0);
+	ocfs2_nfs_sync_unlock(OCFS2_SB(inode->i_sb), 0, nofs_flag);
 
 bail_unblock:
 	ocfs2_unblock_signals(&oldset);
-- 
2.53.0




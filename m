Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D183A2B9C7;
	Sun,  1 Sep 2024 16:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208735; cv=none; b=EfO3826MqCIV01NsZ0aff+Fp5GGcvnxZcExjaD9ZaRGxdWhNN3/dwRl/JEFJG19+nhsuMlFSdE7g4h7i8ieX1wfDUEZm8yhvdV4Kl2srU4qF7nj/4oR89peGI1CpLgmQr630OYgp7Qx0ItpyGBe2kUGiLkZhEKlaKY6mIcQGsOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208735; c=relaxed/simple;
	bh=KZ+xGyPcFpWkDzmKg3Djqlb6+nfs+K/qzzBCgUkGEWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e5DRo015qphwiDEyS0DP0jWRobJh/k/CDOmor05um2dBj50oK+/Sf2FyD4ZINwXFmPDoLU3vH+5mcr/OQK+8pxm87MHs+fxY4rbMiGaN6pSHnFsw2Y05bBo8LVRq8XGtyaJTerszlG6m1tLu5RB4gIhQEWxy9UdjuVt1JHfg31A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y58ynh4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y58ynh4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFC6C4CEC3;
	Sun,  1 Sep 2024 16:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208735;
	bh=KZ+xGyPcFpWkDzmKg3Djqlb6+nfs+K/qzzBCgUkGEWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y58ynh4xrA6poFWHiKluJ0ZYBhEkmT11NdHmWAS7+sWPkZsyAK7XOTt/LVS1w8vOj
	 uGE70bjTo5EdzVe61yP7sS5vsvXCSOe7YLLPprYOBIgG15LPvCuonvnrVw0RhTZx6W
	 bOOuHdhkEmQ3Qt6DX3dm9ohJZakeLt2N82cWayNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.4 008/134] vfs: Dont evict inode under the inode lru traversing context
Date: Sun,  1 Sep 2024 18:15:54 +0200
Message-ID: <20240901160810.425534650@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 2a0629834cd82f05d424bbc193374f9a43d1f87d upstream.

The inode reclaiming process(See function prune_icache_sb) collects all
reclaimable inodes and mark them with I_FREEING flag at first, at that
time, other processes will be stuck if they try getting these inodes
(See function find_inode_fast), then the reclaiming process destroy the
inodes by function dispose_list(). Some filesystems(eg. ext4 with
ea_inode feature, ubifs with xattr) may do inode lookup in the inode
evicting callback function, if the inode lookup is operated under the
inode lru traversing context, deadlock problems may happen.

Case 1: In function ext4_evict_inode(), the ea inode lookup could happen
        if ea_inode feature is enabled, the lookup process will be stuck
	under the evicting context like this:

 1. File A has inode i_reg and an ea inode i_ea
 2. getfattr(A, xattr_buf) // i_ea is added into lru // lru->i_ea
 3. Then, following three processes running like this:

    PA                              PB
 echo 2 > /proc/sys/vm/drop_caches
  shrink_slab
   prune_dcache_sb
   // i_reg is added into lru, lru->i_ea->i_reg
   prune_icache_sb
    list_lru_walk_one
     inode_lru_isolate
      i_ea->i_state |= I_FREEING // set inode state
     inode_lru_isolate
      __iget(i_reg)
      spin_unlock(&i_reg->i_lock)
      spin_unlock(lru_lock)
                                     rm file A
                                      i_reg->nlink = 0
      iput(i_reg) // i_reg->nlink is 0, do evict
       ext4_evict_inode
        ext4_xattr_delete_inode
         ext4_xattr_inode_dec_ref_all
          ext4_xattr_inode_iget
           ext4_iget(i_ea->i_ino)
            iget_locked
             find_inode_fast
              __wait_on_freeing_inode(i_ea) ----→ AA deadlock
    dispose_list // cannot be executed by prune_icache_sb
     wake_up_bit(&i_ea->i_state)

Case 2: In deleted inode writing function ubifs_jnl_write_inode(), file
        deleting process holds BASEHD's wbuf->io_mutex while getting the
	xattr inode, which could race with inode reclaiming process(The
        reclaiming process could try locking BASEHD's wbuf->io_mutex in
	inode evicting function), then an ABBA deadlock problem would
	happen as following:

 1. File A has inode ia and a xattr(with inode ixa), regular file B has
    inode ib and a xattr.
 2. getfattr(A, xattr_buf) // ixa is added into lru // lru->ixa
 3. Then, following three processes running like this:

        PA                PB                        PC
                echo 2 > /proc/sys/vm/drop_caches
                 shrink_slab
                  prune_dcache_sb
                  // ib and ia are added into lru, lru->ixa->ib->ia
                  prune_icache_sb
                   list_lru_walk_one
                    inode_lru_isolate
                     ixa->i_state |= I_FREEING // set inode state
                    inode_lru_isolate
                     __iget(ib)
                     spin_unlock(&ib->i_lock)
                     spin_unlock(lru_lock)
                                                   rm file B
                                                    ib->nlink = 0
 rm file A
  iput(ia)
   ubifs_evict_inode(ia)
    ubifs_jnl_delete_inode(ia)
     ubifs_jnl_write_inode(ia)
      make_reservation(BASEHD) // Lock wbuf->io_mutex
      ubifs_iget(ixa->i_ino)
       iget_locked
        find_inode_fast
         __wait_on_freeing_inode(ixa)
          |          iput(ib) // ib->nlink is 0, do evict
          |           ubifs_evict_inode
          |            ubifs_jnl_delete_inode(ib)
          ↓             ubifs_jnl_write_inode
     ABBA deadlock ←-----make_reservation(BASEHD)
                   dispose_list // cannot be executed by prune_icache_sb
                    wake_up_bit(&ixa->i_state)

Fix the possible deadlock by using new inode state flag I_LRU_ISOLATING
to pin the inode in memory while inode_lru_isolate() reclaims its pages
instead of using ordinary inode reference. This way inode deletion
cannot be triggered from inode_lru_isolate() thus avoiding the deadlock.
evict() is made to wait for I_LRU_ISOLATING to be cleared before
proceeding with inode cleanup.

Link: https://lore.kernel.org/all/37c29c42-7685-d1f0-067d-63582ffac405@huaweicloud.com/
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219022
Fixes: e50e5129f384 ("ext4: xattr-in-inode support")
Fixes: 7959cf3a7506 ("ubifs: journal: Handle xattrs like files")
Cc: stable@vger.kernel.org
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Link: https://lore.kernel.org/r/20240809031628.1069873-1-chengzhihao@huaweicloud.com
Reviewed-by: Jan Kara <jack@suse.cz>
Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Mateusz Guzik <mjguzik@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/inode.c         |   39 +++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h |    5 +++++
 2 files changed, 42 insertions(+), 2 deletions(-)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -450,6 +450,39 @@ static void inode_lru_list_del(struct in
 		this_cpu_dec(nr_unused);
 }
 
+static void inode_pin_lru_isolating(struct inode *inode)
+{
+	lockdep_assert_held(&inode->i_lock);
+	WARN_ON(inode->i_state & (I_LRU_ISOLATING | I_FREEING | I_WILL_FREE));
+	inode->i_state |= I_LRU_ISOLATING;
+}
+
+static void inode_unpin_lru_isolating(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	WARN_ON(!(inode->i_state & I_LRU_ISOLATING));
+	inode->i_state &= ~I_LRU_ISOLATING;
+	smp_mb();
+	wake_up_bit(&inode->i_state, __I_LRU_ISOLATING);
+	spin_unlock(&inode->i_lock);
+}
+
+static void inode_wait_for_lru_isolating(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	if (inode->i_state & I_LRU_ISOLATING) {
+		DEFINE_WAIT_BIT(wq, &inode->i_state, __I_LRU_ISOLATING);
+		wait_queue_head_t *wqh;
+
+		wqh = bit_waitqueue(&inode->i_state, __I_LRU_ISOLATING);
+		spin_unlock(&inode->i_lock);
+		__wait_on_bit(wqh, &wq, bit_wait, TASK_UNINTERRUPTIBLE);
+		spin_lock(&inode->i_lock);
+		WARN_ON(inode->i_state & I_LRU_ISOLATING);
+	}
+	spin_unlock(&inode->i_lock);
+}
+
 /**
  * inode_sb_list_add - add inode to the superblock list of inodes
  * @inode: inode to add
@@ -562,6 +595,8 @@ static void evict(struct inode *inode)
 
 	inode_sb_list_del(inode);
 
+	inode_wait_for_lru_isolating(inode);
+
 	/*
 	 * Wait for flusher thread to be done with the inode so that filesystem
 	 * does not start destroying it while writeback is still running. Since
@@ -761,7 +796,7 @@ static enum lru_status inode_lru_isolate
 	}
 
 	if (inode_has_buffers(inode) || inode->i_data.nrpages) {
-		__iget(inode);
+		inode_pin_lru_isolating(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(lru_lock);
 		if (remove_inode_buffers(inode)) {
@@ -774,7 +809,7 @@ static enum lru_status inode_lru_isolate
 			if (current->reclaim_state)
 				current->reclaim_state->reclaimed_slab += reap;
 		}
-		iput(inode);
+		inode_unpin_lru_isolating(inode);
 		spin_lock(lru_lock);
 		return LRU_RETRY;
 	}
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2153,6 +2153,9 @@ static inline void init_sync_kiocb(struc
  *			Used to detect that mark_inode_dirty() should not move
  * 			inode between dirty lists.
  *
+ * I_LRU_ISOLATING	Inode is pinned being isolated from LRU without holding
+ *			i_count.
+ *
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  */
 #define I_DIRTY_SYNC		(1 << 0)
@@ -2174,6 +2177,8 @@ static inline void init_sync_kiocb(struc
 #define I_OVL_INUSE		(1 << 14)
 #define I_CREATING		(1 << 15)
 #define I_SYNC_QUEUED		(1 << 17)
+#define __I_LRU_ISOLATING	19
+#define I_LRU_ISOLATING		(1 << __I_LRU_ISOLATING)
 
 #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
 #define I_DIRTY (I_DIRTY_INODE | I_DIRTY_PAGES)



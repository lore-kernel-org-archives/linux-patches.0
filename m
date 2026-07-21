Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBEE33A9FC;
	Tue, 21 Jul 2026 22:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673810; cv=none; b=Jmw8FkxXIBBfhqhoEHplgP2/PU7y7FyD9dAn3Eob/h8sJznctvIRDFi7hGAkXzjS5WUYM3ksSAc9qQR9YTO6JknkII0GIjjG3dqx64cJC0ZS6FU/1Fj77SOsubmDwX4ngsVi+R9oBszhhf+R7My2Sj1iOGPRIUnDsZOAZRHEgZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673810; c=relaxed/simple;
	bh=rXcw+PhiiD0/ZUeLsSo+apQJmTTu5/oDpRnYZbp5qto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=un2COD5F8RHa/nmpVkMz8CijOXmFKTHtuej/WQqLLeB1Htpzz/B6x0fCFJkONpP4PZpBB9KBfa9KXjk/8z2Bw1bFKoPj5ME+oDxthQ18M3D4Ha29gftVgfgMWptrjqTv0R3wx9hEsunsPSccWyNCpaPqaCAKdpOxAENL+dM4Ddk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nblbN73u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nblbN73u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746FB1F000E9;
	Tue, 21 Jul 2026 22:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673809;
	bh=OQceDP8UwNz5YQVCC5sddYV7XYElGxuyEhNWJmUrmM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nblbN73uZU26eYF19DKD94Desg44tev5zKawduMldyra7jtthtlVcL/TIW1VdyeUI
	 wa+ldvZB3O8v8m043X3B3B3DjEixljL+8CTh9DqwbONen5wOC37Kv2l/Dinb2UmJ6r
	 kWASoEvYzPoemIr6BNVa6xAjbBdi3WZsye1HI4Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 302/699] NFSv4/pnfs: defer return_range callbacks until after inode unlock
Date: Tue, 21 Jul 2026 17:21:01 +0200
Message-ID: <20260721152402.508388660@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 77b160b2d863d37f36b6c38e80a7d259ce939e69 ]

Sometimes unmounting an NFS filesystem mounted with pNFS SCSI
layouts triggers the following warning:

     BUG: scheduling while atomic: umount.nfs4/...

    __schedule_bug+0xbd/0x100
     schedule_debug.constprop.0+0x19f/0x220
     __schedule+0x10d/0x10a0
     schedule+0x74/0x190
     schedule_timeout+0xf5/0x220
     io_schedule_timeout+0xd5/0x160
     __wait_for_common+0x186/0x4b0
     blk_execute_rq+0x2ef/0x3a0
     scsi_execute_cmd+0x1ff/0x700
     sd_pr_out_command.isra.0+0x242/0x380 [sd_mod]
     bl_unregister_scsi.constprop.0+0x109/0x3c0 [blocklayoutdriver]
     bl_unregister_dev+0x175/0x1c0 [blocklayoutdriver]
     bl_free_device+0x1f/0x1b0 [blocklayoutdriver]
     bl_free_deviceid_node+0x12/0x30 [blocklayoutdriver]
     nfs4_put_deviceid_node+0x171/0x360 [nfsv4]
     ext_tree_remove+0x11c/0x1d0 [blocklayoutdriver]
     _pnfs_return_layout+0x416/0x900 [nfsv4]
     nfs4_evict_inode+0x108/0x130 [nfsv4]
     evict+0x316/0x750
     dispose_list+0xf1/0x1a0
     evict_inodes+0x33f/0x440
     generic_shutdown_super+0xc9/0x4e0
     kill_anon_super+0x3a/0x90
     nfs_kill_super+0x44/0x60 [nfs]
     deactivate_locked_super+0xb8/0x1b0
     cleanup_mnt+0x25a/0x380
     task_work_run+0x13e/0x210
     exit_to_user_mode_loop+0x169/0x400
     do_syscall_64+0x467/0x1550
     entry_SYSCALL_64_after_hwframe+0x76/0x7e

The warning occurs because the block layout driver unregisters the SCSI
device while the inode lock is still held. Device unregistration issues
a SCSI PR command, which may sleep, resulting in a "scheduling while
atomic" warning.

During layout return, ext_tree_remove() invokes the layout driver's
return_range callback while holding the inode lock. For block layouts,
this callback eventually calls bl_unregister_scsi(), which may block in
scsi_execute_cmd() while issuing PR commands to the device.

Fix this by deferring the return_range callbacks until after the inode
lock has been released. The layout header reference count is incremented
before invoking return_range(), ensuring that the layout header remains
valid while the layout driver removes extents from the extent tree.

Fixes: c88953d87f5c8 ("pnfs: add return_range method")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_proc.c | 9 +++++----
 fs/nfs/pnfs.c          | 4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index bfdd2122407397..dc4b9e7593fdbc 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -243,6 +243,7 @@ static u32 initiate_file_draining(struct nfs_client *clp,
 	struct pnfs_layout_hdr *lo;
 	u32 rv = NFS4ERR_NOMATCHING_LAYOUT;
 	LIST_HEAD(free_me_list);
+	bool return_range = false;
 
 	ino = nfs_layout_find_inode(clp, &args->cbl_fh, &args->cbl_stateid);
 	if (IS_ERR(ino)) {
@@ -287,13 +288,13 @@ static u32 initiate_file_draining(struct nfs_client *clp,
 		/* Embrace your forgetfulness! */
 		rv = NFS4ERR_NOMATCHING_LAYOUT;
 
-		if (NFS_SERVER(ino)->pnfs_curr_ld->return_range) {
-			NFS_SERVER(ino)->pnfs_curr_ld->return_range(lo,
-				&args->cbl_range);
-		}
+		return_range = true;
 	}
 unlock:
 	spin_unlock(&ino->i_lock);
+	if (return_range && NFS_SERVER(ino)->pnfs_curr_ld->return_range)
+		NFS_SERVER(ino)->pnfs_curr_ld->return_range(lo,
+			&args->cbl_range);
 	pnfs_free_lseg_list(&free_me_list);
 	/* Free all lsegs that are attached to commit buckets */
 	nfs_commit_inode(ino, 0);
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index bc0754bba078f0..47b8032f7f4770 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1378,8 +1378,6 @@ _pnfs_return_layout(struct inode *ino)
 	pnfs_clear_layoutcommit(ino, &tmp_list);
 	pnfs_mark_matching_lsegs_return(lo, &tmp_list, &range, 0);
 
-	if (NFS_SERVER(ino)->pnfs_curr_ld->return_range)
-		NFS_SERVER(ino)->pnfs_curr_ld->return_range(lo, &range);
 
 	/* Don't send a LAYOUTRETURN if list was initially empty */
 	if (!test_bit(NFS_LAYOUT_RETURN_REQUESTED, &lo->plh_flags) ||
@@ -1391,6 +1389,8 @@ _pnfs_return_layout(struct inode *ino)
 
 	send = pnfs_prepare_layoutreturn(lo, &stateid, &cred, NULL);
 	spin_unlock(&ino->i_lock);
+	if (NFS_SERVER(ino)->pnfs_curr_ld->return_range)
+		NFS_SERVER(ino)->pnfs_curr_ld->return_range(lo, &range);
 	if (send)
 		status = pnfs_send_layoutreturn(lo, &stateid, &cred, IOMODE_ANY, true);
 out_wait_layoutreturn:
-- 
2.53.0




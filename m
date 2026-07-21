Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E5147126D;
	Tue, 21 Jul 2026 18:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657188; cv=none; b=C3WEsV8Q20aTxaCiqbZAR9OeBdirzo/3e1tJpY84qa8Sy9E2PrLMX4qWQIlnMJtM4axdJsp0WCVJ8Cvf3QjXF3Rs9D/nNI3DqTgobDO9ZTTobljhACdElH7vCBgqZcPKD6flLBBegBqDmNYIYyyyBLE9aZnqSPisezKcrZsLqEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657188; c=relaxed/simple;
	bh=EsgEQajDQQXIJEgGuQbesMx67H1W2TAn4suPbOfzUMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvpLnPTexC1rmw8hvqWyCUFpNCsupm1eqOvZMrD9syynHl6FYS87SqQ2hCcPOr2Oo5r1A48yANomMLpoUzamjS8ufLAPXuHe0lFjgPwFrhWpBHp22BMmVpoOHLHGdW/tN2o5IGE0Y7VulDxnxW9D8mT7MrFl4nzjBdZ5CuuDlRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZOWgAbK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZOWgAbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0711F000E9;
	Tue, 21 Jul 2026 18:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657186;
	bh=LDb2z3ii3CPBV6XSjOvY9303BV4Cl7u0ZeFuhJLBUqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kZOWgAbKYfll7dC6QiRUPoBwj3sMKsAX9gHLJPbw3eRAoA4CvPDV3Xb/lwdeY5x5G
	 3rEHXYQAPLXcFwS50aPCyTAqtXFG9yEk8GtIdwwtniHGuxM34+Gt0+OffoR16u/6XE
	 KGHmvPfJ6DV2NM31404kk1w06UHbWNftKkkLrWQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0670/1611] NFSv4/pnfs: defer return_range callbacks until after inode unlock
Date: Tue, 21 Jul 2026 17:13:06 +0200
Message-ID: <20260721152530.452561575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 8397c43358bd13..4f41986b875e86 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -254,6 +254,7 @@ static u32 initiate_file_draining(struct nfs_client *clp,
 	struct pnfs_layout_hdr *lo;
 	u32 rv = NFS4ERR_NOMATCHING_LAYOUT;
 	LIST_HEAD(free_me_list);
+	bool return_range = false;
 
 	ino = nfs_layout_find_inode(clp, &args->cbl_fh, &args->cbl_stateid);
 	if (IS_ERR(ino)) {
@@ -298,13 +299,13 @@ static u32 initiate_file_draining(struct nfs_client *clp,
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
index d3c1f49f39242d..f84086437f531e 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1463,8 +1463,6 @@ _pnfs_return_layout(struct inode *ino)
 	pnfs_clear_layoutcommit(ino, &tmp_list);
 	pnfs_mark_matching_lsegs_return(lo, &tmp_list, &range, 0);
 
-	if (NFS_SERVER(ino)->pnfs_curr_ld->return_range)
-		NFS_SERVER(ino)->pnfs_curr_ld->return_range(lo, &range);
 
 	/* Don't send a LAYOUTRETURN if list was initially empty */
 	if (!test_bit(NFS_LAYOUT_RETURN_REQUESTED, &lo->plh_flags) ||
@@ -1476,6 +1474,8 @@ _pnfs_return_layout(struct inode *ino)
 
 	send = pnfs_prepare_layoutreturn(lo, &stateid, &cred, NULL);
 	spin_unlock(&ino->i_lock);
+	if (NFS_SERVER(ino)->pnfs_curr_ld->return_range)
+		NFS_SERVER(ino)->pnfs_curr_ld->return_range(lo, &range);
 	if (send)
 		status = pnfs_send_layoutreturn(lo, &stateid, &cred, IOMODE_ANY,
 						0);
-- 
2.53.0




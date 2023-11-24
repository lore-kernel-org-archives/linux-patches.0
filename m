Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083A03173F;
	Fri, 24 Nov 2023 19:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+Xn4q/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7155AC433C7;
	Fri, 24 Nov 2023 19:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853330;
	bh=eY0sw4M6qwjG4xjUzECX3qybKSUJQShjv4KjWvsPkxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+Xn4q/VrDuOVVx90fLpgQlUkO+UoqKzJLzHgltTSIBDqRy+o1Nu58qa4OabTiGCq
	 /vL7i8C7k0ICbQFCdJXsIhfBBIhCKF140JpjjzU+roS6Tpfv8fbRNOKG+ETy8jXgVU
	 HZpqcIy54WN8stN6fNKud5iItmjxDF3H3Oc5idhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hch@lst.de,
	kernel test robot <oliver.sang@intel.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/297] xfs: fix use-after-free in xattr node block inactivation
Date: Fri, 24 Nov 2023 17:53:07 +0000
Message-ID: <20231124172005.345463459@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 95ff0363f3f6ae70c21a0f2b0603e54438e5988b ]

The kernel build robot reported a UAF error while running xfs/433
(edited somewhat for brevity):

 BUG: KASAN: use-after-free in xfs_attr3_node_inactive (fs/xfs/xfs_attr_inactive.c:214) xfs
 Read of size 4 at addr ffff88820ac2bd44 by task kworker/0:2/139

 CPU: 0 PID: 139 Comm: kworker/0:2 Tainted: G S                5.19.0-rc2-00004-g7cf2b0f9611b #1
 Hardware name: Hewlett-Packard p6-1451cx/2ADA, BIOS 8.15 02/05/2013
 Workqueue: xfs-inodegc/sdb4 xfs_inodegc_worker [xfs]
 Call Trace:
  <TASK>
 dump_stack_lvl (lib/dump_stack.c:107 (discriminator 1))
 print_address_description+0x1f/0x200
 print_report.cold (mm/kasan/report.c:430)
 kasan_report (mm/kasan/report.c:162 mm/kasan/report.c:493)
 xfs_attr3_node_inactive (fs/xfs/xfs_attr_inactive.c:214) xfs
 xfs_attr3_root_inactive (fs/xfs/xfs_attr_inactive.c:296) xfs
 xfs_attr_inactive (fs/xfs/xfs_attr_inactive.c:371) xfs
 xfs_inactive (fs/xfs/xfs_inode.c:1781) xfs
 xfs_inodegc_worker (fs/xfs/xfs_icache.c:1837 fs/xfs/xfs_icache.c:1860) xfs
 process_one_work
 worker_thread
 kthread
 ret_from_fork
  </TASK>

 Allocated by task 139:
 kasan_save_stack (mm/kasan/common.c:39)
 __kasan_slab_alloc (mm/kasan/common.c:45 mm/kasan/common.c:436 mm/kasan/common.c:469)
 kmem_cache_alloc (mm/slab.h:750 mm/slub.c:3214 mm/slub.c:3222 mm/slub.c:3229 mm/slub.c:3239)
 _xfs_buf_alloc (include/linux/instrumented.h:86 include/linux/atomic/atomic-instrumented.h:41 fs/xfs/xfs_buf.c:232) xfs
 xfs_buf_get_map (fs/xfs/xfs_buf.c:660) xfs
 xfs_buf_read_map (fs/xfs/xfs_buf.c:777) xfs
 xfs_trans_read_buf_map (fs/xfs/xfs_trans_buf.c:289) xfs
 xfs_da_read_buf (fs/xfs/libxfs/xfs_da_btree.c:2652) xfs
 xfs_da3_node_read (fs/xfs/libxfs/xfs_da_btree.c:392) xfs
 xfs_attr3_root_inactive (fs/xfs/xfs_attr_inactive.c:272) xfs
 xfs_attr_inactive (fs/xfs/xfs_attr_inactive.c:371) xfs
 xfs_inactive (fs/xfs/xfs_inode.c:1781) xfs
 xfs_inodegc_worker (fs/xfs/xfs_icache.c:1837 fs/xfs/xfs_icache.c:1860) xfs
 process_one_work
 worker_thread
 kthread
 ret_from_fork

 Freed by task 139:
 kasan_save_stack (mm/kasan/common.c:39)
 kasan_set_track (mm/kasan/common.c:45)
 kasan_set_free_info (mm/kasan/generic.c:372)
 __kasan_slab_free (mm/kasan/common.c:368 mm/kasan/common.c:328 mm/kasan/common.c:374)
 kmem_cache_free (mm/slub.c:1753 mm/slub.c:3507 mm/slub.c:3524)
 xfs_buf_rele (fs/xfs/xfs_buf.c:1040) xfs
 xfs_attr3_node_inactive (fs/xfs/xfs_attr_inactive.c:210) xfs
 xfs_attr3_root_inactive (fs/xfs/xfs_attr_inactive.c:296) xfs
 xfs_attr_inactive (fs/xfs/xfs_attr_inactive.c:371) xfs
 xfs_inactive (fs/xfs/xfs_inode.c:1781) xfs
 xfs_inodegc_worker (fs/xfs/xfs_icache.c:1837 fs/xfs/xfs_icache.c:1860) xfs
 process_one_work
 worker_thread
 kthread
 ret_from_fork

I reproduced this for my own satisfaction, and got the same report,
along with an extra morsel:

 The buggy address belongs to the object at ffff88802103a800
  which belongs to the cache xfs_buf of size 432
 The buggy address is located 396 bytes inside of
  432-byte region [ffff88802103a800, ffff88802103a9b0)

I tracked this code down to:

	error = xfs_trans_get_buf(*trans, mp->m_ddev_targp,
			child_blkno,
			XFS_FSB_TO_BB(mp, mp->m_attr_geo->fsbcount), 0,
			&child_bp);
	if (error)
		return error;
	error = bp->b_error;

That doesn't look right -- I think this should be dereferencing
child_bp, not bp.  Looking through the codebase history, I think this
was added by commit 2911edb653b9 ("xfs: remove the mappedbno argument to
xfs_da_get_buf"), which replaced a call to xfs_da_get_buf with the
current call to xfs_trans_get_buf.  Not sure why we trans_brelse'd @bp
earlier in the function, but I'm guessing it's to avoid pinning too many
buffers in memory while we inactivate the bottom of the attr tree.
Hence we now have to get the buffer back.

I /think/ this was supposed to check child_bp->b_error and fail the rest
of the invalidation if child_bp had experienced any kind of IO or
corruption error.  I bet the xfs_da3_node_read earlier in the loop will
catch most cases of incoming on-disk corruption which makes this check
mostly moot unless someone corrupts the buffer and the AIL pushes it out
to disk while the buffer's unlocked.

In the first case we'll never get to the bad check, and in the second
case the AIL will shut down the log, at which point there's no reason to
check b_error.  Remove the check, and null out @bp to avoid this problem
in the future.

Cc: hch@lst.de
Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: 2911edb653b9 ("xfs: remove the mappedbno argument to xfs_da_get_buf")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_attr_inactive.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 2b5da6218977c..2afa6d9a7f8f6 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -158,6 +158,7 @@ xfs_attr3_node_inactive(
 	}
 	child_fsb = be32_to_cpu(ichdr.btree[0].before);
 	xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
+	bp = NULL;
 
 	/*
 	 * If this is the node level just above the leaves, simply loop
@@ -211,12 +212,8 @@ xfs_attr3_node_inactive(
 				&child_bp);
 		if (error)
 			return error;
-		error = bp->b_error;
-		if (error) {
-			xfs_trans_brelse(*trans, child_bp);
-			return error;
-		}
 		xfs_trans_binval(*trans, child_bp);
+		child_bp = NULL;
 
 		/*
 		 * If we're not done, re-read the parent to get the next
@@ -233,6 +230,7 @@ xfs_attr3_node_inactive(
 						  bp->b_addr);
 			child_fsb = be32_to_cpu(phdr.btree[i + 1].before);
 			xfs_trans_brelse(*trans, bp);
+			bp = NULL;
 		}
 		/*
 		 * Atomically commit the whole invalidate stuff.
-- 
2.42.0




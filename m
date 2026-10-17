Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEE63A542B;
	Sat, 17 Oct 2026 18:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260818; cv=none; b=KF6GZHKtnYCk73eHnYqoFKp1FtNxKuJDlc2W0C9i/k1ltgGieed4rD/nmy0M29Y8O9AS9FuWfvNX9BaEBD2jDtOVBCqYaT/SDrgtrqRLaMFTj7La/4JRO3xbS77PjFNylUcKm/jufXx5OLMPANXRdi+7xlBkQoVaZbjz7cr1HNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260818; c=relaxed/simple;
	bh=wKJbgMjKwUGmZauyxFQTbDcMTCi7l78NVbgNUBpjnlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cx8D2CDs7cpYVNlcKUwfrx4eZcM8nzDQFPdMTTmzHhWcZKGQs7mjvAs0QxOM79HhEghFjG288qUcjqNWtmBTV6GHNY8iMvW6CANZJ6dfYKP5qU40I86/uiUL0S9fLV1nDPS1PDdc7aXnpIQRY3+6SMWVj/CDs6bd+vOcUxpi6hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYZSSN+A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYZSSN+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3DA1F000C4;
	Sat, 17 Oct 2026 18:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260817;
	bh=b9FQGGBALdAOXk4dJPsLmZhKmAeCK5S7XJTl/KJWaUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYZSSN+A1nOZ6mSv474iQwuIh0RIjKZJzaFbLmMBlPfMp+mQIHX/zEUftCPX3Bd7D
	 s1ztfyUSEpBznyRPqQuJKrDB7DjnYfzw0wqLk3pjuBu/+evua44QN543uFzYiiAj+G
	 h9JxPQ4GjIGLMFm3FKurNmBkPc1deubO0kzzBuYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1668/1674] xfs: catch stale AGF/AGF metadata
Date: Sat, 17 Oct 2026 18:05:40 +0200
Message-ID: <20261017160513.882579590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit db6a2274162de615ff74b927d38942fe3134d298 ]

There is a race condition that can trigger in dmflakey fstests that
can result in asserts in xfs_ialloc_read_agi() and
xfs_alloc_read_agf() firing. The asserts look like this:

 XFS: Assertion failed: pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks), file: fs/xfs/libxfs/xfs_alloc.c, line: 3440
.....
 Call Trace:
  <TASK>
  xfs_alloc_read_agf+0x2ad/0x3a0
  xfs_alloc_fix_freelist+0x280/0x720
  xfs_alloc_vextent_prepare_ag+0x42/0x120
  xfs_alloc_vextent_iterate_ags+0x67/0x260
  xfs_alloc_vextent_start_ag+0xe4/0x1c0
  xfs_bmapi_allocate+0x6fe/0xc90
  xfs_bmapi_convert_delalloc+0x338/0x560
  xfs_map_blocks+0x354/0x580
  iomap_writepages+0x52b/0xa70
  xfs_vm_writepages+0xd7/0x100
  do_writepages+0xe1/0x2c0
  __writeback_single_inode+0x44/0x340
  writeback_sb_inodes+0x2d0/0x570
  __writeback_inodes_wb+0x9c/0xf0
  wb_writeback+0x139/0x2d0
  wb_workfn+0x23e/0x4c0
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30

I've seen the AGI variant from scrub running on the filesysetm
after unmount failed due to systemd interference:

 XFS: Assertion failed: pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) || xfs_is_shutdown(pag->pag_mount), file: fs/xfs/libxfs/xfs_ialloc.c, line: 2804
.....
 Call Trace:
  <TASK>
  xfs_ialloc_read_agi+0xee/0x150
  xchk_perag_drain_and_lock+0x7d/0x240
  xchk_ag_init+0x34/0x90
  xchk_inode_xref+0x7b/0x220
  xchk_inode+0x14d/0x180
  xfs_scrub_metadata+0x2e2/0x510
  xfs_ioc_scrub_metadata+0x62/0xb0
  xfs_file_ioctl+0x446/0xbf0
  __se_sys_ioctl+0x6f/0xc0
  __x64_sys_ioctl+0x1d/0x30
  x64_sys_call+0x1879/0x2ee0
  do_syscall_64+0x68/0x130
  ? exc_page_fault+0x62/0xc0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

Essentially, it is the same problem. When _flakey_drop_and_remount()
loads the drop-writes table, it makes all writes silently fail. Writes
are reported to the fs as completed successfully, but they are not
issued to the backing store. The filesystem sees the successful
write completion and marks the metadata buffer clean and removes it
from the AIL.

If this happens at the same time as memory pressure is occuring,
the now-clean AGF and/or AGI buffers can be reclaimed from memory.

Shortly afterwards, but before _flakey_drop_and_remount() runs
unmount, background writeback is kicked and it tries to allocate
blocks for the dirty pages in memory. This then tries to access the
AGF buffer we just turfed out of memory. It's not found, so it gets
read in from disk.

This is all fine, except for the fact that the last writeback of the
AGF did not actually reach disk. The AGF on disk is stale compared
to the in-memory state held by the perag, and so they don't match
and the assert fires.

Then other operations on that inode hang because the task was killed
whilst holding inode locks. e.g:

 Workqueue: xfs-conv/dm-12 xfs_end_io
 Call Trace:
  <TASK>
  __schedule+0x650/0xb10
  schedule+0x6d/0xf0
  schedule_preempt_disabled+0x15/0x30
  rwsem_down_write_slowpath+0x31a/0x5f0
  down_write+0x43/0x60
  xfs_ilock+0x1a8/0x210
  xfs_trans_alloc_inode+0x9c/0x240
  xfs_iomap_write_unwritten+0xe3/0x300
  xfs_end_ioend+0x90/0x130
  xfs_end_io+0xce/0x100
  process_scheduled_works+0x1d4/0x400
  worker_thread+0x234/0x2e0
  kthread+0x147/0x170
  ret_from_fork+0x3e/0x50
  ret_from_fork_asm+0x1a/0x30
  </TASK>

and it's all down hill from there.

Memory pressure is one way to trigger this, another is to run "echo
3 > /proc/sys/vm/drop_caches" randomly while tests are running.

Regardless of how it is triggered, this effectively takes down the
system once umount hangs because it's holding a sb->s_umount lock
exclusive and now every sync(1) call gets stuck on it.

Fix this by replacing the asserts with a corruption detection check
and a shutdown.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>

6.12:

Fixed conflict due to the following missing commit:
	e9c4d8bfb26c ("xfs: factor out a generic xfs_group structure")

6.6:

Fixed conflict due to the following missing commit:
	e45ea3645178 ("xfs: split the agf_roots and agf_levels arrays")

Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c  | 46 +++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_ialloc.c | 32 ++++++++++++++++++++++----
 2 files changed, 64 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ad2fa3c26f8a9..0383216e39dce 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
+#include "xfs_health.h"
 
 struct kmem_cache	*xfs_extfree_item_cache;
 
@@ -3240,18 +3241,43 @@ xfs_alloc_read_agf(
 
 		set_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
 	}
+
 #ifdef DEBUG
-	else if (!xfs_is_shutdown(pag->pag_mount)) {
-		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
-		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
-		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
-		ASSERT(pag->pagf_longest == be32_to_cpu(agf->agf_longest));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_BNOi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_CNTi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
+	/*
+	 * It's possible for the AGF to be out of sync if the block device is
+	 * silently dropping writes. This can happen in fstests with dmflakey
+	 * enabled, which allows the buffer to be cleaned and reclaimed by
+	 * memory pressure and then re-read from disk here. We will get a
+	 * stale version of the AGF from disk, and nothing good can happen from
+	 * here. Hence if we detect this situation, immediately shut down the
+	 * filesystem.
+	 *
+	 * This can also happen if we are already in the middle of a forced
+	 * shutdown, so don't bother checking if we are already shut down.
+	 */
+	if (!xfs_is_shutdown(pag->pag_mount)) {
+		bool	ok = true;
+
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
+		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
+		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
+		ok &= pag->pagf_longest == be32_to_cpu(agf->agf_longest);
+		ok &= pag->pagf_levels[XFS_BTNUM_BNOi] ==
+		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
+		ok &= pag->pagf_levels[XFS_BTNUM_CNTi] ==
+		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
+
+		if (XFS_IS_CORRUPT(pag->pag_mount, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
+			xfs_trans_brelse(tp, agfbp);
+			xfs_force_shutdown(pag->pag_mount,
+					SHUTDOWN_CORRUPT_ONDISK);
+			return -EFSCORRUPTED;
+		}
 	}
-#endif
+#endif /* DEBUG */
+
 	if (agfbpp)
 		*agfbpp = agfbp;
 	else
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b83e54c709069..dee46010702dc 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -27,6 +27,7 @@
 #include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_health.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -2634,12 +2635,35 @@ xfs_ialloc_read_agi(
 		set_bit(XFS_AGSTATE_AGI_INIT, &pag->pag_opstate);
 	}
 
+#ifdef DEBUG
 	/*
-	 * It's possible for these to be out of sync if
-	 * we are in the middle of a forced shutdown.
+	 * It's possible for the AGF to be out of sync if the block device is
+	 * silently dropping writes. This can happen in fstests with dmflakey
+	 * enabled, which allows the buffer to be cleaned and reclaimed by
+	 * memory pressure and then re-read from disk here. We will get a
+	 * stale version of the AGF from disk, and nothing good can happen from
+	 * here. Hence if we detect this situation, immediately shut down the
+	 * filesystem.
+	 *
+	 * This can also happen if we are already in the middle of a forced
+	 * shutdown, so don't bother checking if we are already shut down.
 	 */
-	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
-		xfs_is_shutdown(pag->pag_mount));
+	if (!xfs_is_shutdown(pag->pag_mount)) {
+		bool	ok = true;
+
+		ok &= pag->pagi_freecount == be32_to_cpu(agi->agi_freecount);
+		ok &= pag->pagi_count == be32_to_cpu(agi->agi_count);
+
+		if (XFS_IS_CORRUPT(pag->pag_mount, !ok)) {
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+			xfs_trans_brelse(tp, agibp);
+			xfs_force_shutdown(pag->pag_mount,
+					SHUTDOWN_CORRUPT_ONDISK);
+			return -EFSCORRUPTED;
+		}
+	}
+#endif /* DEBUG */
+
 	if (agibpp)
 		*agibpp = agibp;
 	else
-- 
2.53.0




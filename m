Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A8118DB24;
	Mon, 10 Mar 2025 17:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627445; cv=none; b=ldBHh1Tsq6deUoQKV77Yj2IVlJZhtdv9uRZHcVNJFr5P3+I+HvO8CZiFuj27oxyPyHN7vvaoPRTwwd9CeGdReDatgasN2dIqr2LuMUwgNHMfqqpPiLqJ/fGQvJCEeDTCSQoC+VnfSIWSkdLKKa1xati6UJpP23Dxeiyyi4foyoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627445; c=relaxed/simple;
	bh=LtXM6VBstzddXldQjWI2K9yD9MV7o9THTuN1NtsNKgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIJzNBUeH8RCkjdkNRxFT0I1i/91KEKforRlW1AIReUDrYa0yR+xxY8nOdU9XLJ8XdFu1tQwIFgJVSR79UCA9qYrgR+bwRsv46XgbPiX1GL+YITUPBBP3Y9tavA8mJMdMdhS9cR/QOJDDpCQUtCKhNtiBrLzh/y+VPTlgDcQ000=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukdTK4L2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukdTK4L2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D7EC4CEE5;
	Mon, 10 Mar 2025 17:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627445;
	bh=LtXM6VBstzddXldQjWI2K9yD9MV7o9THTuN1NtsNKgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukdTK4L2AOG8hCiW1FzBpuLxN1Qt+HZnm2pYiN74iet9jzA9b3zmxeT6Z1v+BlI2o
	 JW3ED6LinpKlrGTSLraNpchRhtBtK4N4u9AWGPO7sXYo/X3c9Cuc8/ZtiT3a9kzqk9
	 ZR3P/+FMWIndskFkIL29rjuqJg9PZpvSVsjz1bzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 131/269] NFS: fix nfs_release_folio() to not deadlock via kcompactd writeback
Date: Mon, 10 Mar 2025 18:04:44 +0100
Message-ID: <20250310170502.942540850@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mike Snitzer <snitzer@kernel.org>

commit ce6d9c1c2b5cc785016faa11b48b6cd317eb367e upstream.

Add PF_KCOMPACTD flag and current_is_kcompactd() helper to check for it so
nfs_release_folio() can skip calling nfs_wb_folio() from kcompactd.

Otherwise NFS can deadlock waiting for kcompactd enduced writeback which
recurses back to NFS (which triggers writeback to NFSD via NFS loopback
mount on the same host, NFSD blocks waiting for XFS's call to
__filemap_get_folio):

6070.550357] INFO: task kcompactd0:58 blocked for more than 4435 seconds.

{---
[58] "kcompactd0"
[<0>] folio_wait_bit+0xe8/0x200
[<0>] folio_wait_writeback+0x2b/0x80
[<0>] nfs_wb_folio+0x80/0x1b0 [nfs]
[<0>] nfs_release_folio+0x68/0x130 [nfs]
[<0>] split_huge_page_to_list_to_order+0x362/0x840
[<0>] migrate_pages_batch+0x43d/0xb90
[<0>] migrate_pages_sync+0x9a/0x240
[<0>] migrate_pages+0x93c/0x9f0
[<0>] compact_zone+0x8e2/0x1030
[<0>] compact_node+0xdb/0x120
[<0>] kcompactd+0x121/0x2e0
[<0>] kthread+0xcf/0x100
[<0>] ret_from_fork+0x31/0x40
[<0>] ret_from_fork_asm+0x1a/0x30
---}

[akpm@linux-foundation.org: fix build]
Link: https://lkml.kernel.org/r/20250225022002.26141-1-snitzer@kernel.org
Fixes: 96780ca55e3c ("NFS: fix up nfs_release_folio() to try to release the page")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Cc: Anna Schumaker <anna.schumaker@oracle.com>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/file.c              |    3 ++-
 include/linux/compaction.h |    5 +++++
 include/linux/sched.h      |    2 +-
 mm/compaction.c            |    3 +++
 4 files changed, 11 insertions(+), 2 deletions(-)

--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -29,6 +29,7 @@
 #include <linux/pagemap.h>
 #include <linux/gfp.h>
 #include <linux/swap.h>
+#include <linux/compaction.h>
 
 #include <linux/uaccess.h>
 #include <linux/filelock.h>
@@ -451,7 +452,7 @@ static bool nfs_release_folio(struct fol
 	/* If the private flag is set, then the folio is not freeable */
 	if (folio_test_private(folio)) {
 		if ((current_gfp_context(gfp) & GFP_KERNEL) != GFP_KERNEL ||
-		    current_is_kswapd())
+		    current_is_kswapd() || current_is_kcompactd())
 			return false;
 		if (nfs_wb_folio(folio->mapping->host, folio) < 0)
 			return false;
--- a/include/linux/compaction.h
+++ b/include/linux/compaction.h
@@ -80,6 +80,11 @@ static inline unsigned long compact_gap(
 	return 2UL << order;
 }
 
+static inline int current_is_kcompactd(void)
+{
+	return current->flags & PF_KCOMPACTD;
+}
+
 #ifdef CONFIG_COMPACTION
 
 extern unsigned int extfrag_for_order(struct zone *zone, unsigned int order);
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1682,7 +1682,7 @@ extern struct pid *cad_pid;
 #define PF_USED_MATH		0x00002000	/* If unset the fpu must be initialized before use */
 #define PF_USER_WORKER		0x00004000	/* Kernel thread cloned from userspace thread */
 #define PF_NOFREEZE		0x00008000	/* This thread should not be frozen */
-#define PF__HOLE__00010000	0x00010000
+#define PF_KCOMPACTD		0x00010000	/* I am kcompactd */
 #define PF_KSWAPD		0x00020000	/* I am kswapd */
 #define PF_MEMALLOC_NOFS	0x00040000	/* All allocations inherit GFP_NOFS. See memalloc_nfs_save() */
 #define PF_MEMALLOC_NOIO	0x00080000	/* All allocations inherit GFP_NOIO. See memalloc_noio_save() */
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -3164,6 +3164,7 @@ static int kcompactd(void *p)
 	if (!cpumask_empty(cpumask))
 		set_cpus_allowed_ptr(tsk, cpumask);
 
+	current->flags |= PF_KCOMPACTD;
 	set_freezable();
 
 	pgdat->kcompactd_max_order = 0;
@@ -3220,6 +3221,8 @@ static int kcompactd(void *p)
 			pgdat->proactive_compact_trigger = false;
 	}
 
+	current->flags &= ~PF_KCOMPACTD;
+
 	return 0;
 }
 



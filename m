Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143F6230BE6;
	Mon, 10 Mar 2025 17:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626782; cv=none; b=rJIl/SFyx3o8qn4FH4H4RcTyQN6QmiYMgclxIY1yuGqQSGWmwFwYchImp8GrO8RY3SXkcGlwYkJxr/NXc+XReBdf2aJXVRFt3ArgTObCfq1s9c73n2wj5xx3kbZynWGWsZu02jrTgvWe6oXU0Qhpx7LBo6tjBD/y3+5xmsG5D4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626782; c=relaxed/simple;
	bh=Fjk0Va2wpj0NnvX5Omrsu4cYDOVz3b7ZQB9y/yrkNQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elqYp6uQls//oGj3zwQnfJM+wEa258/sn7z24IqvxPKzsUYqBD/Eir854haDhGtHPo2cXwaZEiw/KcHKwEA5JmYXe2cnjndkOkqdphEMGSzHPHa9iDRwfn/16Gymx5sLcg/ZkJGR4ghe/x/j4xeeKcSWViVr4kNpNMvlv0HbZg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfheZlnt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfheZlnt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E3AC4CEE5;
	Mon, 10 Mar 2025 17:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626782;
	bh=Fjk0Va2wpj0NnvX5Omrsu4cYDOVz3b7ZQB9y/yrkNQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfheZlntOKXC7n6mVCQHuGfg5iTylocPZaDwcQ9uCzKBPh7MY6CWtoLHwTKaNEhNX
	 pQAlGff5rwxBRLsISnDQ4qS97z6DV/QvlCi8gmb/N3utdCm21u35qOkocj9WPnfGUA
	 FUH7hgJv3nSFTvBTv3NdWIWphcP8vQ4JBEh2dstk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 070/207] NFS: fix nfs_release_folio() to not deadlock via kcompactd writeback
Date: Mon, 10 Mar 2025 18:04:23 +0100
Message-ID: <20250310170450.546883566@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -457,7 +458,7 @@ static bool nfs_release_folio(struct fol
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
@@ -1686,7 +1686,7 @@ extern struct pid *cad_pid;
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
 



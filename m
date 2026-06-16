Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8AC472768;
	Tue, 16 Jun 2026 15:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624722; cv=none; b=PDp+fFHmgM+fUjlTaBWIxIxagWG8ccAZn+t2aJEzOGXWw4OYleGybOygE8FvrMH2qH+JgTpD7T75K2/PpQgfnt0PVcXOlK1SvZJrC+/N3u6fDO3vE9kmG5eLsTp0gpmuJHfowFaKUKGQbcd1zKGhH1wyoSv6yzvJFL3KrgE+yWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624722; c=relaxed/simple;
	bh=HeqP5mG5KTEz2oodvtAKc5YoP0AI/VlR/ViQx+NXtXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aod0AJxLvs+KHQ3sYVvmfiCZ1rTIHPLefcsk7CKwbFQz+G4nb+VKd9gyNy1u5eEyFsQa7vyVm3KeFgrLfoY2V/cM045JbmTHdLHWe3baXH+xLCkjfR2tjcX8odLiNPpsg7P+l3YA/4sjO5J16lgPUk4IITizPv/QfdYeApeznBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2k02Tt2d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2k02Tt2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C0771F000E9;
	Tue, 16 Jun 2026 15:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624719;
	bh=zBtHpd1/7cr5Ovo2uUvPoXDxKs4ssM45CvdeOqWBXo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2k02Tt2dyi9xHHLJ3xvFEIk1mIPeWPeMxEVHd4Fky//d5ZX0MT+rvY8di1jt3Up9A
	 +Kt/9d7diaXzlLVcN7yFNNjE55cNHfepEVoCdOR0sEFLOKk9rCGJmd5wRvN+PsPYcC
	 /m4OCMvR4JKfQwmxrZNmskmVQZ6DACVFB+njzHQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 017/325] erofs: tidy up synchronous decompression
Date: Tue, 16 Jun 2026 20:26:53 +0530
Message-ID: <20260616145058.657893379@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit cc831ab33644088c1eef78936de24701014d520a ]

 - Get rid of `sbi->opt.max_sync_decompress_pages` since it's fixed as
   3 all the time;

 - Add Z_EROFS_MAX_SYNC_DECOMPRESS_BYTES in bytes instead of in pages,
   since for non-4K pages, 3-page limitation makes no sense;

 - Move `sync_decompress` to sbi to avoid unexpected remount impact;

 - Fold z_erofs_is_sync_decompress() into its caller;

 - Better description of sysfs entry `sync_decompress`.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Stable-dep-of: 1aee05e814d2 ("erofs: fix use-after-free on sbi->sync_decompress")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-erofs | 14 ++++++----
 fs/erofs/internal.h                      |  5 +---
 fs/erofs/super.c                         |  3 +-
 fs/erofs/sysfs.c                         |  2 +-
 fs/erofs/zdata.c                         | 35 +++++++++---------------
 5 files changed, 25 insertions(+), 34 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-erofs b/Documentation/ABI/testing/sysfs-fs-erofs
index 76d9808ed58143..b9243c7f28d718 100644
--- a/Documentation/ABI/testing/sysfs-fs-erofs
+++ b/Documentation/ABI/testing/sysfs-fs-erofs
@@ -10,12 +10,16 @@ Description:	Shows all enabled kernel features.
 What:		/sys/fs/erofs/<disk>/sync_decompress
 Date:		November 2021
 Contact:	"Huang Jianan" <huangjianan@oppo.com>
-Description:	Control strategy of sync decompression:
+Description:	Control strategy of synchronous decompression. Synchronous
+		decompression tries to decompress in the reader thread for
+		synchronous reads and small asynchronous reads (<= 12 KiB):
 
-		- 0 (default, auto): enable for readpage, and enable for
-		  readahead on atomic contexts only.
-		- 1 (force on): enable for readpage and readahead.
-		- 2 (force off): disable for all situations.
+		- 0 (auto, default): apply to synchronous reads only, but will
+		                     switch to 1 (force on) if any decompression
+		                     request is detected in atomic contexts;
+		- 1 (force on): apply to synchronous reads and small
+		                asynchronous reads;
+		- 2 (force off): disable synchronous decompression completely.
 
 What:		/sys/fs/erofs/<disk>/drop_caches
 Date:		November 2024
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index f7f622836198da..87edbb4366d16c 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -59,10 +59,6 @@ enum {
 struct erofs_mount_opts {
 	/* current strategy of how to use managed cache */
 	unsigned char cache_strategy;
-	/* strategy of sync decompression (0 - auto, 1 - force on, 2 - force off) */
-	unsigned int sync_decompress;
-	/* threshold for decompression synchronously */
-	unsigned int max_sync_decompress_pages;
 	unsigned int mount_opt;
 };
 
@@ -116,6 +112,7 @@ struct erofs_sb_info {
 	/* managed XArray arranged in physical block number */
 	struct xarray managed_pslots;
 
+	unsigned int sync_decompress;	/* strategy for sync decompression */
 	unsigned int shrinker_run_no;
 	u16 available_compr_algs;
 
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index f5f5d19459eccd..e6725e9847bedd 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -379,8 +379,7 @@ static void erofs_default_options(struct erofs_sb_info *sbi)
 {
 #ifdef CONFIG_EROFS_FS_ZIP
 	sbi->opt.cache_strategy = EROFS_ZIP_CACHE_READAROUND;
-	sbi->opt.max_sync_decompress_pages = 3;
-	sbi->opt.sync_decompress = EROFS_SYNC_DECOMPRESS_AUTO;
+	sbi->sync_decompress = EROFS_SYNC_DECOMPRESS_AUTO;
 #endif
 #ifdef CONFIG_EROFS_FS_XATTR
 	set_opt(&sbi->opt, XATTR_USER);
diff --git a/fs/erofs/sysfs.c b/fs/erofs/sysfs.c
index 1e0658a1d95b9a..86b22b9f0c1910 100644
--- a/fs/erofs/sysfs.c
+++ b/fs/erofs/sysfs.c
@@ -59,7 +59,7 @@ static struct erofs_attr erofs_attr_##_name = {			\
 #define ATTR_LIST(name) (&erofs_attr_##name.attr)
 
 #ifdef CONFIG_EROFS_FS_ZIP
-EROFS_ATTR_RW_UI(sync_decompress, erofs_mount_opts);
+EROFS_ATTR_RW_UI(sync_decompress, erofs_sb_info);
 EROFS_ATTR_FUNC(drop_caches, 0200);
 #endif
 #ifdef CONFIG_EROFS_FS_ZIP_ACCEL
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 33932d56d3a46e..e98d9cb4fe99a4 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -9,6 +9,7 @@
 #include <linux/cpuhotplug.h>
 #include <trace/events/erofs.h>
 
+#define Z_EROFS_MAX_SYNC_DECOMPRESS_BYTES	12288
 #define Z_EROFS_PCLUSTER_MAX_PAGES	(Z_EROFS_PCLUSTER_MAX_SIZE / PAGE_SIZE)
 #define Z_EROFS_INLINE_BVECS		2
 
@@ -1097,21 +1098,6 @@ static int z_erofs_scan_folio(struct z_erofs_frontend *f,
 	return err;
 }
 
-static bool z_erofs_is_sync_decompress(struct erofs_sb_info *sbi,
-				       unsigned int readahead_pages)
-{
-	/* auto: enable for read_folio, disable for readahead */
-	if ((sbi->opt.sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO) &&
-	    !readahead_pages)
-		return true;
-
-	if ((sbi->opt.sync_decompress == EROFS_SYNC_DECOMPRESS_FORCE_ON) &&
-	    (readahead_pages <= sbi->opt.max_sync_decompress_pages))
-		return true;
-
-	return false;
-}
-
 static bool z_erofs_page_is_invalidated(struct page *page)
 {
 	return !page_folio(page)->mapping && !z_erofs_is_shortlived_page(page);
@@ -1473,9 +1459,9 @@ static void z_erofs_decompress_kickoff(struct z_erofs_decompressqueue *io,
 #else
 		queue_work(z_erofs_workqueue, &io->u.work);
 #endif
-		/* enable sync decompression for readahead */
-		if (sbi->opt.sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
-			sbi->opt.sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
+		/* See `sync_decompress` in sysfs-fs-erofs for more details */
+		if (sbi->sync_decompress == EROFS_SYNC_DECOMPRESS_AUTO)
+			sbi->sync_decompress = EROFS_SYNC_DECOMPRESS_FORCE_ON;
 		return;
 	}
 	gfp_flag = memalloc_noio_save();
@@ -1795,16 +1781,21 @@ static void z_erofs_submit_queue(struct z_erofs_frontend *f,
 	z_erofs_decompress_kickoff(q[JQ_SUBMIT], nr_bios);
 }
 
-static int z_erofs_runqueue(struct z_erofs_frontend *f, unsigned int rapages)
+static int z_erofs_runqueue(struct z_erofs_frontend *f, unsigned int rabytes)
 {
 	struct z_erofs_decompressqueue io[NR_JOBQUEUES];
 	struct erofs_sb_info *sbi = EROFS_I_SB(f->inode);
-	bool force_fg = z_erofs_is_sync_decompress(sbi, rapages);
+	int syncmode = sbi->sync_decompress;
+	bool force_fg;
 	int err;
 
+	force_fg = (syncmode == EROFS_SYNC_DECOMPRESS_AUTO && !rabytes) ||
+		(syncmode == EROFS_SYNC_DECOMPRESS_FORCE_ON &&
+			(rabytes <= Z_EROFS_MAX_SYNC_DECOMPRESS_BYTES));
+
 	if (f->head == Z_EROFS_PCLUSTER_TAIL)
 		return 0;
-	z_erofs_submit_queue(f, io, &force_fg, !!rapages);
+	z_erofs_submit_queue(f, io, &force_fg, !!rabytes);
 
 	/* handle bypass queue (no i/o pclusters) immediately */
 	err = z_erofs_decompress_queue(&io[JQ_BYPASS], &f->pagepool);
@@ -1925,7 +1916,7 @@ static void z_erofs_readahead(struct readahead_control *rac)
 	z_erofs_pcluster_readmore(&f, rac, false);
 	z_erofs_pcluster_end(&f);
 
-	(void)z_erofs_runqueue(&f, nrpages);
+	(void)z_erofs_runqueue(&f, nrpages << PAGE_SHIFT);
 	erofs_put_metabuf(&f.map.buf);
 	erofs_release_pages(&f.pagepool);
 }
-- 
2.53.0




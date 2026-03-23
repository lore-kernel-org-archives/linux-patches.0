Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6674933CE9A;
	Mon, 23 Mar 2026 14:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277055; cv=none; b=QCMKaeXrSr7GqZ3NzRg9bV5yu+m/pKGArCtZ2xz69lKSyVeR0UwVMXS4hf8FMgImJR+h6L87nX+XXqxirjkhjjB/vtcWD47oeBzAM3E/s28iSkzErZoCCdjR3TMMsSQJy+ZJ919e3d4D/RutdTThYxfMxSjniirSuDvHfIxTSC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277055; c=relaxed/simple;
	bh=smf3l4bCQQxttt6naDcbKt7irZuELAR5+LAOyNrcu4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+4m9IKDMv3RRNRoXnMiFN8Ok3aTlrbnUMn4WsXQiKUCcqJguG+gCxBHkMWZv5G1HWjjcZbSGU2YNwfCl2CQUtYDb6cTfVvxqVEZOPtcag/APG706cWgo7IGTHk88Y6GXS2oh0aPmHROW9UdcMMUBDZ0cExGjWrSn+Uv5zVWsi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vaSCBhRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vaSCBhRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4169C4CEF7;
	Mon, 23 Mar 2026 14:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277055;
	bh=smf3l4bCQQxttt6naDcbKt7irZuELAR5+LAOyNrcu4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vaSCBhRep1D1iLjklYcoegr0Tk3kb8TTHCBTRRezt/bCuhvr//jHIedCFxs2ki8UH
	 HZOjKOcxdYmxWE8IoxbaZfeOkcivMzTg47+cYzXgj6UTRBy9SAHXAfOm2L1rx/Nh62
	 rgq95TfTSTONurZYeKaF+TME219FeSQXwV+eq/BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Baocong Liu <baocong.liu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 6.12 287/460] f2fs: compress: fix UAF of f2fs_inode_info in f2fs_free_dic
Date: Mon, 23 Mar 2026 14:44:43 +0100
Message-ID: <20260323134533.534278122@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 39868685c2a94a70762bc6d77dc81d781d05bff5 ]

The decompress_io_ctx may be released asynchronously after
I/O completion. If this file is deleted immediately after read,
and the kworker of processing post_read_wq has not been executed yet
due to high workloads, It is possible that the inode(f2fs_inode_info)
is evicted and freed before it is used f2fs_free_dic.

    The UAF case as below:
    Thread A                                      Thread B
    - f2fs_decompress_end_io
     - f2fs_put_dic
      - queue_work
        add free_dic work to post_read_wq
                                                   - do_unlink
                                                    - iput
                                                     - evict
                                                      - call_rcu
    This file is deleted after read.

    Thread C                                 kworker to process post_read_wq
    - rcu_do_batch
     - f2fs_free_inode
      - kmem_cache_free
     inode is freed by rcu
                                             - process_scheduled_works
                                              - f2fs_late_free_dic
                                               - f2fs_free_dic
                                                - f2fs_release_decomp_mem
                                      read (dic->inode)->i_compress_algorithm

This patch store compress_algorithm and sbi in dic to avoid inode UAF.

In addition, the previous solution is deprecated in [1] may cause system hang.
[1] https://lore.kernel.org/all/c36ab955-c8db-4a8b-a9d0-f07b5f426c3f@kernel.org

Cc: Daeho Jeong <daehojeong@google.com>
Fixes: bff139b49d9f ("f2fs: handle decompress only post processing in softirq")
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Signed-off-by: Baocong Liu <baocong.liu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ Keep the original f2fs_vmalloc(workspace_size) in v6.12.y instead of
f2fs_vmalloc(dic->sbi, workspace_size) per commit
54ca9be0bc58 ("f2fs: introduce FAULT_VMALLOC"). ]
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/compress.c |   38 +++++++++++++++++++-------------------
 fs/f2fs/f2fs.h     |    2 ++
 2 files changed, 21 insertions(+), 19 deletions(-)

--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -211,13 +211,13 @@ static int lzo_decompress_pages(struct d
 	ret = lzo1x_decompress_safe(dic->cbuf->cdata, dic->clen,
 						dic->rbuf, &dic->rlen);
 	if (ret != LZO_E_OK) {
-		f2fs_err_ratelimited(F2FS_I_SB(dic->inode),
+		f2fs_err_ratelimited(dic->sbi,
 				"lzo decompress failed, ret:%d", ret);
 		return -EIO;
 	}
 
 	if (dic->rlen != PAGE_SIZE << dic->log_cluster_size) {
-		f2fs_err_ratelimited(F2FS_I_SB(dic->inode),
+		f2fs_err_ratelimited(dic->sbi,
 				"lzo invalid rlen:%zu, expected:%lu",
 				dic->rlen, PAGE_SIZE << dic->log_cluster_size);
 		return -EIO;
@@ -291,13 +291,13 @@ static int lz4_decompress_pages(struct d
 	ret = LZ4_decompress_safe(dic->cbuf->cdata, dic->rbuf,
 						dic->clen, dic->rlen);
 	if (ret < 0) {
-		f2fs_err_ratelimited(F2FS_I_SB(dic->inode),
+		f2fs_err_ratelimited(dic->sbi,
 				"lz4 decompress failed, ret:%d", ret);
 		return -EIO;
 	}
 
 	if (ret != PAGE_SIZE << dic->log_cluster_size) {
-		f2fs_err_ratelimited(F2FS_I_SB(dic->inode),
+		f2fs_err_ratelimited(dic->sbi,
 				"lz4 invalid ret:%d, expected:%lu",
 				ret, PAGE_SIZE << dic->log_cluster_size);
 		return -EIO;
@@ -425,7 +425,7 @@ static int zstd_init_decompress_ctx(stru
 
 	stream = zstd_init_dstream(max_window_size, workspace, workspace_size);
 	if (!stream) {
-		f2fs_err_ratelimited(F2FS_I_SB(dic->inode),
+		f2fs_err_ratelimited(dic->sbi,
 				"%s zstd_init_dstream failed", __func__);
 		vfree(workspace);
 		return -EIO;
@@ -461,14 +461,14 @@ static int zstd_decompress_pages(struct
 
 	ret = zstd_decompress_stream(stream, &outbuf, &inbuf);
 	if (zstd_is_error(ret)) {
-		f2fs_err_ratelimited(F2FS_I_SB(dic->inode),
+		f2fs_err_ratelimited(dic->sbi,
 				"%s zstd_decompress_stream failed, ret: %d",
 				__func__, zstd_get_error_code(ret));
 		return -EIO;
 	}
 
 	if (dic->rlen != outbuf.pos) {
-		f2fs_err_ratelimited(F2FS_I_SB(dic->inode),
+		f2fs_err_ratelimited(dic->sbi,
 				"%s ZSTD invalid rlen:%zu, expected:%lu",
 				__func__, dic->rlen,
 				PAGE_SIZE << dic->log_cluster_size);
@@ -728,7 +728,7 @@ static void f2fs_release_decomp_mem(stru
 
 void f2fs_decompress_cluster(struct decompress_io_ctx *dic, bool in_task)
 {
-	struct f2fs_sb_info *sbi = F2FS_I_SB(dic->inode);
+	struct f2fs_sb_info *sbi = dic->sbi;
 	struct f2fs_inode_info *fi = F2FS_I(dic->inode);
 	const struct f2fs_compress_ops *cops =
 			f2fs_cops[fi->i_compress_algorithm];
@@ -798,7 +798,7 @@ void f2fs_end_read_compressed_page(struc
 {
 	struct decompress_io_ctx *dic =
 			(struct decompress_io_ctx *)page_private(page);
-	struct f2fs_sb_info *sbi = F2FS_I_SB(dic->inode);
+	struct f2fs_sb_info *sbi = dic->sbi;
 
 	dec_page_count(sbi, F2FS_RD_DATA);
 
@@ -1615,14 +1615,13 @@ static inline bool allow_memalloc_for_de
 static int f2fs_prepare_decomp_mem(struct decompress_io_ctx *dic,
 		bool pre_alloc)
 {
-	const struct f2fs_compress_ops *cops =
-		f2fs_cops[F2FS_I(dic->inode)->i_compress_algorithm];
+	const struct f2fs_compress_ops *cops = f2fs_cops[dic->compress_algorithm];
 	int i;
 
-	if (!allow_memalloc_for_decomp(F2FS_I_SB(dic->inode), pre_alloc))
+	if (!allow_memalloc_for_decomp(dic->sbi, pre_alloc))
 		return 0;
 
-	dic->tpages = page_array_alloc(F2FS_I_SB(dic->inode), dic->cluster_size);
+	dic->tpages = page_array_alloc(dic->sbi, dic->cluster_size);
 	if (!dic->tpages)
 		return -ENOMEM;
 
@@ -1652,10 +1651,9 @@ static int f2fs_prepare_decomp_mem(struc
 static void f2fs_release_decomp_mem(struct decompress_io_ctx *dic,
 		bool bypass_destroy_callback, bool pre_alloc)
 {
-	const struct f2fs_compress_ops *cops =
-		f2fs_cops[F2FS_I(dic->inode)->i_compress_algorithm];
+	const struct f2fs_compress_ops *cops = f2fs_cops[dic->compress_algorithm];
 
-	if (!allow_memalloc_for_decomp(F2FS_I_SB(dic->inode), pre_alloc))
+	if (!allow_memalloc_for_decomp(dic->sbi, pre_alloc))
 		return;
 
 	if (!bypass_destroy_callback && cops->destroy_decompress_ctx)
@@ -1690,6 +1688,8 @@ struct decompress_io_ctx *f2fs_alloc_dic
 
 	dic->magic = F2FS_COMPRESSED_PAGE_MAGIC;
 	dic->inode = cc->inode;
+	dic->sbi = sbi;
+	dic->compress_algorithm = F2FS_I(cc->inode)->i_compress_algorithm;
 	atomic_set(&dic->remaining_pages, cc->nr_cpages);
 	dic->cluster_idx = cc->cluster_idx;
 	dic->cluster_size = cc->cluster_size;
@@ -1733,7 +1733,8 @@ static void f2fs_free_dic(struct decompr
 		bool bypass_destroy_callback)
 {
 	int i;
-	struct f2fs_sb_info *sbi = F2FS_I_SB(dic->inode);
+	/* use sbi in dic to avoid UFA of dic->inode*/
+	struct f2fs_sb_info *sbi = dic->sbi;
 
 	f2fs_release_decomp_mem(dic, bypass_destroy_callback, true);
 
@@ -1776,8 +1777,7 @@ static void f2fs_put_dic(struct decompre
 			f2fs_free_dic(dic, false);
 		} else {
 			INIT_WORK(&dic->free_work, f2fs_late_free_dic);
-			queue_work(F2FS_I_SB(dic->inode)->post_read_wq,
-					&dic->free_work);
+			queue_work(dic->sbi->post_read_wq, &dic->free_work);
 		}
 	}
 }
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1525,6 +1525,7 @@ struct compress_io_ctx {
 struct decompress_io_ctx {
 	u32 magic;			/* magic number to indicate page is compressed */
 	struct inode *inode;		/* inode the context belong to */
+	struct f2fs_sb_info *sbi;	/* f2fs_sb_info pointer */
 	pgoff_t cluster_idx;		/* cluster index number */
 	unsigned int cluster_size;	/* page count in cluster */
 	unsigned int log_cluster_size;	/* log of cluster size */
@@ -1565,6 +1566,7 @@ struct decompress_io_ctx {
 
 	bool failed;			/* IO error occurred before decompression? */
 	bool need_verity;		/* need fs-verity verification after decompression? */
+	unsigned char compress_algorithm;	/* backup algorithm type */
 	void *private;			/* payload buffer for specified decompression algorithm */
 	void *private2;			/* extra payload buffer */
 	struct work_struct verity_work;	/* work to verify the decompressed pages */



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42435387593;
	Mon, 23 Mar 2026 14:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277025; cv=none; b=X69lzCwow9mH01jul1wzkby1xDkXZ1MtAleFeudK3/zNivj2bz9Koeoy75od/1X5fCDpaajWQzkBU+43c3cGFVCEQdQzVH11rCWHjGU5Xmz4qc0KU3NQ8AZzyAXwVj+dHoLQ19tvNCuiOyMtP4oTB7SyBz0iY7slfr6svyjMeyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277025; c=relaxed/simple;
	bh=blbJAkK1Djn66CQhVcu1Fo5r4Y8D70iHNwG/fZm2adY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TkHgBbhIAjiq69YwXTr1II2CIIloMKoBr5hzN3nM4ykPCDO6s5BHj5xhYBlwZq/+VOG6tC4J8q7Zl/5J3KW3wbZnvwJ7i2gWdVsft8JyWk4fgyT42//lBr3rOJO3dDZWUXRPV+fGkiloecMpaOqUgQaJLXkdKSatclYbz3eMkuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ON3CfLW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ON3CfLW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC6DC4CEF7;
	Mon, 23 Mar 2026 14:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277025;
	bh=blbJAkK1Djn66CQhVcu1Fo5r4Y8D70iHNwG/fZm2adY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ON3CfLW/+kuL3I1dJKCrLiOzTwN7qMa/0HP+Jnn3BM2vkCkW/AolBqlI5EvAcYoGq
	 XZVvMVWD86mC3EJtlkHOEBOiVBDzMEJrC2HL0W5ABdHsLVS3OnukGjDeNz6UORgZTs
	 OtpGED6+GNjXIO/HxZh87j+O3Uj3Ej4ywNUtrjb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Baocong Liu <baocong.liu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 6.12 286/460] f2fs: compress: change the first parameter of page_array_{alloc,free} to sbi
Date: Mon, 23 Mar 2026 14:44:42 +0100
Message-ID: <20260323134533.510150961@linuxfoundation.org>
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

[ Upstream commit 8e2a9b656474d67c55010f2c003ea2cf889a19ff ]

No logic changes, just cleanup and prepare for fixing the UAF issue
in f2fs_free_dic.

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Signed-off-by: Baocong Liu <baocong.liu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/compress.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -23,20 +23,18 @@
 static struct kmem_cache *cic_entry_slab;
 static struct kmem_cache *dic_entry_slab;
 
-static void *page_array_alloc(struct inode *inode, int nr)
+static void *page_array_alloc(struct f2fs_sb_info *sbi, int nr)
 {
-	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	unsigned int size = sizeof(struct page *) * nr;
 
 	if (likely(size <= sbi->page_array_slab_size))
 		return f2fs_kmem_cache_alloc(sbi->page_array_slab,
-					GFP_F2FS_ZERO, false, F2FS_I_SB(inode));
+					GFP_F2FS_ZERO, false, sbi);
 	return f2fs_kzalloc(sbi, size, GFP_NOFS);
 }
 
-static void page_array_free(struct inode *inode, void *pages, int nr)
+static void page_array_free(struct f2fs_sb_info *sbi, void *pages, int nr)
 {
-	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	unsigned int size = sizeof(struct page *) * nr;
 
 	if (!pages)
@@ -147,13 +145,13 @@ int f2fs_init_compress_ctx(struct compre
 	if (cc->rpages)
 		return 0;
 
-	cc->rpages = page_array_alloc(cc->inode, cc->cluster_size);
+	cc->rpages = page_array_alloc(F2FS_I_SB(cc->inode), cc->cluster_size);
 	return cc->rpages ? 0 : -ENOMEM;
 }
 
 void f2fs_destroy_compress_ctx(struct compress_ctx *cc, bool reuse)
 {
-	page_array_free(cc->inode, cc->rpages, cc->cluster_size);
+	page_array_free(F2FS_I_SB(cc->inode), cc->rpages, cc->cluster_size);
 	cc->rpages = NULL;
 	cc->nr_rpages = 0;
 	cc->nr_cpages = 0;
@@ -616,6 +614,7 @@ static void *f2fs_vmap(struct page **pag
 
 static int f2fs_compress_pages(struct compress_ctx *cc)
 {
+	struct f2fs_sb_info *sbi = F2FS_I_SB(cc->inode);
 	struct f2fs_inode_info *fi = F2FS_I(cc->inode);
 	const struct f2fs_compress_ops *cops =
 				f2fs_cops[fi->i_compress_algorithm];
@@ -636,7 +635,7 @@ static int f2fs_compress_pages(struct co
 	cc->nr_cpages = DIV_ROUND_UP(max_len, PAGE_SIZE);
 	cc->valid_nr_cpages = cc->nr_cpages;
 
-	cc->cpages = page_array_alloc(cc->inode, cc->nr_cpages);
+	cc->cpages = page_array_alloc(sbi, cc->nr_cpages);
 	if (!cc->cpages) {
 		ret = -ENOMEM;
 		goto destroy_compress_ctx;
@@ -711,7 +710,7 @@ out_free_cpages:
 		if (cc->cpages[i])
 			f2fs_compress_free_page(cc->cpages[i]);
 	}
-	page_array_free(cc->inode, cc->cpages, cc->nr_cpages);
+	page_array_free(sbi, cc->cpages, cc->nr_cpages);
 	cc->cpages = NULL;
 destroy_compress_ctx:
 	if (cops->destroy_compress_ctx)
@@ -1325,7 +1324,7 @@ static int f2fs_write_compressed_pages(s
 	cic->magic = F2FS_COMPRESSED_PAGE_MAGIC;
 	cic->inode = inode;
 	atomic_set(&cic->pending_pages, cc->valid_nr_cpages);
-	cic->rpages = page_array_alloc(cc->inode, cc->cluster_size);
+	cic->rpages = page_array_alloc(sbi, cc->cluster_size);
 	if (!cic->rpages)
 		goto out_put_cic;
 
@@ -1427,13 +1426,13 @@ unlock_continue:
 	spin_unlock(&fi->i_size_lock);
 
 	f2fs_put_rpages(cc);
-	page_array_free(cc->inode, cc->cpages, cc->nr_cpages);
+	page_array_free(sbi, cc->cpages, cc->nr_cpages);
 	cc->cpages = NULL;
 	f2fs_destroy_compress_ctx(cc, false);
 	return 0;
 
 out_destroy_crypt:
-	page_array_free(cc->inode, cic->rpages, cc->cluster_size);
+	page_array_free(sbi, cic->rpages, cc->cluster_size);
 
 	for (--i; i >= 0; i--) {
 		if (!cc->cpages[i])
@@ -1454,7 +1453,7 @@ out_free:
 		f2fs_compress_free_page(cc->cpages[i]);
 		cc->cpages[i] = NULL;
 	}
-	page_array_free(cc->inode, cc->cpages, cc->nr_cpages);
+	page_array_free(sbi, cc->cpages, cc->nr_cpages);
 	cc->cpages = NULL;
 	return -EAGAIN;
 }
@@ -1484,7 +1483,7 @@ void f2fs_compress_write_end_io(struct b
 		end_page_writeback(cic->rpages[i]);
 	}
 
-	page_array_free(cic->inode, cic->rpages, cic->nr_rpages);
+	page_array_free(sbi, cic->rpages, cic->nr_rpages);
 	kmem_cache_free(cic_entry_slab, cic);
 }
 
@@ -1623,7 +1622,7 @@ static int f2fs_prepare_decomp_mem(struc
 	if (!allow_memalloc_for_decomp(F2FS_I_SB(dic->inode), pre_alloc))
 		return 0;
 
-	dic->tpages = page_array_alloc(dic->inode, dic->cluster_size);
+	dic->tpages = page_array_alloc(F2FS_I_SB(dic->inode), dic->cluster_size);
 	if (!dic->tpages)
 		return -ENOMEM;
 
@@ -1683,7 +1682,7 @@ struct decompress_io_ctx *f2fs_alloc_dic
 	if (!dic)
 		return ERR_PTR(-ENOMEM);
 
-	dic->rpages = page_array_alloc(cc->inode, cc->cluster_size);
+	dic->rpages = page_array_alloc(sbi, cc->cluster_size);
 	if (!dic->rpages) {
 		kmem_cache_free(dic_entry_slab, dic);
 		return ERR_PTR(-ENOMEM);
@@ -1704,7 +1703,7 @@ struct decompress_io_ctx *f2fs_alloc_dic
 		dic->rpages[i] = cc->rpages[i];
 	dic->nr_rpages = cc->cluster_size;
 
-	dic->cpages = page_array_alloc(dic->inode, dic->nr_cpages);
+	dic->cpages = page_array_alloc(sbi, dic->nr_cpages);
 	if (!dic->cpages) {
 		ret = -ENOMEM;
 		goto out_free;
@@ -1734,6 +1733,7 @@ static void f2fs_free_dic(struct decompr
 		bool bypass_destroy_callback)
 {
 	int i;
+	struct f2fs_sb_info *sbi = F2FS_I_SB(dic->inode);
 
 	f2fs_release_decomp_mem(dic, bypass_destroy_callback, true);
 
@@ -1745,7 +1745,7 @@ static void f2fs_free_dic(struct decompr
 				continue;
 			f2fs_compress_free_page(dic->tpages[i]);
 		}
-		page_array_free(dic->inode, dic->tpages, dic->cluster_size);
+		page_array_free(sbi, dic->tpages, dic->cluster_size);
 	}
 
 	if (dic->cpages) {
@@ -1754,10 +1754,10 @@ static void f2fs_free_dic(struct decompr
 				continue;
 			f2fs_compress_free_page(dic->cpages[i]);
 		}
-		page_array_free(dic->inode, dic->cpages, dic->nr_cpages);
+		page_array_free(sbi, dic->cpages, dic->nr_cpages);
 	}
 
-	page_array_free(dic->inode, dic->rpages, dic->nr_rpages);
+	page_array_free(sbi, dic->rpages, dic->nr_rpages);
 	kmem_cache_free(dic_entry_slab, dic);
 }
 



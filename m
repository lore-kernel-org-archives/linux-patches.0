Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF4381ABF;
	Thu, 13 Jun 2024 12:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281136; cv=none; b=QMLpPlo9iG0EAmiLN2Ik1OUPGG2JxHnH62drR7XMBAneOPkUKENMVq91+wJWdtw6rh/6jFcU+mrNxoNBsvNBovvQ6itdnbTCv9SP3jO1R1eMo4DQxU70BxoQ7lXm893taG0sSfJuLHbzQuI1WAxX/e8wNxtJEEI1HY6OxcsiFeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281136; c=relaxed/simple;
	bh=k6MPVErl4E93ZRaZf3JQIpaDVJsxMppbffGIiTfMKlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUDyhD+Cy3AslFMR7bFwUYzqqQpW5asm62jZblaWZQz2jXzpqlsS4kWBOBVqdowTC5G/02pNLJue7iGZOkG+aJn3K9980GWIFvshZKfmgCQ4S4HZCiZn64bhMO3zjs0s4c8ohs+rzBJ5T2nxpJFmbIGa4abvTCpG2oDzzya/vh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EeTdbrDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EeTdbrDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3463EC4AF1A;
	Thu, 13 Jun 2024 12:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281136;
	bh=k6MPVErl4E93ZRaZf3JQIpaDVJsxMppbffGIiTfMKlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EeTdbrDNfACYk2LP/ofnz3UKnNPEbDPT+JBeeZ51IH1yPZhT+Wg7M+Gir2ivP8xpx
	 YQ5GIuUpV6KMJ1b8qD55wmhHY+ylvOX7j1qWnRaSdn+mB9YPlUnRVpEiWAioFfETTn
	 YmCwRBKAwi9b6o1/3pMfYWXj9K3fFzUw9WWxC21w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <yuchao0@huawei.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 152/317] f2fs: compress: clean up parameter of __f2fs_cluster_blocks()
Date: Thu, 13 Jun 2024 13:32:50 +0200
Message-ID: <20240613113253.445290198@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit 91f0fb6903ed30370135381f10c02a10c7872cdc ]

Previously, in order to reuse __f2fs_cluster_blocks(),
f2fs_is_compressed_cluster() assigned a compress_ctx type variable,
which is used to pass few parameters (cc.inode, cc.cluster_size,
cc.cluster_idx), it's wasteful to allocate such large space in stack.

Let's clean up parameters of __f2fs_cluster_blocks() to avoid that.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 7c5dffb3d90c ("f2fs: compress: fix to relocate check condition in f2fs_{release,reserve}_compress_blocks()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 6c870b741cfe5..04b6de1a58744 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -866,14 +866,17 @@ static bool __cluster_may_compress(struct compress_ctx *cc)
 	return true;
 }
 
-static int __f2fs_cluster_blocks(struct compress_ctx *cc, bool compr)
+static int __f2fs_cluster_blocks(struct inode *inode,
+				unsigned int cluster_idx, bool compr)
 {
 	struct dnode_of_data dn;
+	unsigned int cluster_size = F2FS_I(inode)->i_cluster_size;
+	unsigned int start_idx = cluster_idx <<
+				F2FS_I(inode)->i_log_cluster_size;
 	int ret;
 
-	set_new_dnode(&dn, cc->inode, NULL, NULL, 0);
-	ret = f2fs_get_dnode_of_data(&dn, start_idx_of_cluster(cc),
-							LOOKUP_NODE);
+	set_new_dnode(&dn, inode, NULL, NULL, 0);
+	ret = f2fs_get_dnode_of_data(&dn, start_idx, LOOKUP_NODE);
 	if (ret) {
 		if (ret == -ENOENT)
 			ret = 0;
@@ -884,7 +887,7 @@ static int __f2fs_cluster_blocks(struct compress_ctx *cc, bool compr)
 		int i;
 
 		ret = 1;
-		for (i = 1; i < cc->cluster_size; i++) {
+		for (i = 1; i < cluster_size; i++) {
 			block_t blkaddr;
 
 			blkaddr = data_blkaddr(dn.inode,
@@ -906,25 +909,15 @@ static int __f2fs_cluster_blocks(struct compress_ctx *cc, bool compr)
 /* return # of compressed blocks in compressed cluster */
 static int f2fs_compressed_blocks(struct compress_ctx *cc)
 {
-	return __f2fs_cluster_blocks(cc, true);
+	return __f2fs_cluster_blocks(cc->inode, cc->cluster_idx, true);
 }
 
 /* return # of valid blocks in compressed cluster */
-static int f2fs_cluster_blocks(struct compress_ctx *cc)
-{
-	return __f2fs_cluster_blocks(cc, false);
-}
-
 int f2fs_is_compressed_cluster(struct inode *inode, pgoff_t index)
 {
-	struct compress_ctx cc = {
-		.inode = inode,
-		.log_cluster_size = F2FS_I(inode)->i_log_cluster_size,
-		.cluster_size = F2FS_I(inode)->i_cluster_size,
-		.cluster_idx = index >> F2FS_I(inode)->i_log_cluster_size,
-	};
-
-	return f2fs_cluster_blocks(&cc);
+	return __f2fs_cluster_blocks(inode,
+		index >> F2FS_I(inode)->i_log_cluster_size,
+		false);
 }
 
 static bool cluster_may_compress(struct compress_ctx *cc)
@@ -975,7 +968,7 @@ static int prepare_compress_overwrite(struct compress_ctx *cc,
 	bool prealloc;
 
 retry:
-	ret = f2fs_cluster_blocks(cc);
+	ret = f2fs_is_compressed_cluster(cc->inode, start_idx);
 	if (ret <= 0)
 		return ret;
 
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041CC1D0BA2;
	Wed,  2 Oct 2024 14:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880094; cv=none; b=j2N5OfsW1ZFYoHaWEchBcH1jFThoL1dxrDDyf9zYgpQUOJ1MqjeJvsiD2bgWKRtynYSRsmQU/5uJlrOaNCarVa3uolR4/BMHDQ7f/eymkRAlNx5G1zvG6QN1RaJm0n8SQtlUrDVDamLPCLffho/YezvBMbCzxf3VPjD7LyhsmhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880094; c=relaxed/simple;
	bh=EJq1diHurIEXx3Tg3YnAC5/X6aarIGSAdF0jwCbfVIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMoDHtA0o7BuPSrYVUwCZjvJFJoIflgi4mV3ZZn/Rky3el+ZhqZTqLb0Rk3OC6LdJC/zCD89JHYwEXqN1KWea02NbJGMqd6fckcOJvvTDkfr6UiN/p17U1jUXf0WZPc6h1D06MKSH2nPxHmI0LvV//GBkT/xZYi20yuxhqWYOEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2/PDG2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2/PDG2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC97C4CEC2;
	Wed,  2 Oct 2024 14:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880093;
	bh=EJq1diHurIEXx3Tg3YnAC5/X6aarIGSAdF0jwCbfVIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2/PDG2DV9BuDHmcb22Q4D3iK07HrdmVPuQAJ8Gsy1/DceLzAnDzNezXiUGYYqYdb
	 6Vqgzfm5XUYT16V/gLHX9TQyZWdmQKwwWmON6LD46odoyR8X4xjCLgo653vdRSnURo
	 AIwPV38mZZT3XrVaV/XjalLVL3/WqCoICe3scksk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 342/538] f2fs: compress: do sanity check on cluster when CONFIG_F2FS_CHECK_FS is on
Date: Wed,  2 Oct 2024 14:59:41 +0200
Message-ID: <20241002125805.929920615@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 2aaea533bf063ed3b442df5fe5f6abfc538054c9 ]

This patch covers sanity check logic on cluster w/ CONFIG_F2FS_CHECK_FS,
otherwise, there will be performance regression while querying cluster
mapping info.

Callers of f2fs_is_compressed_cluster() only care about whether cluster
is compressed or not, rather than # of valid blocks in compressed cluster,
so, let's adjust f2fs_is_compressed_cluster()'s logic according to
caller's requirement.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: f785cec298c9 ("f2fs: compress: don't redirty sparse cluster during {,de}compress")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 61 ++++++++++++++++++++++++++--------------------
 fs/f2fs/data.c     |  4 +--
 2 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index c07fe6b840a09..995f6544cc300 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -887,14 +887,15 @@ static bool cluster_has_invalid_data(struct compress_ctx *cc)
 
 bool f2fs_sanity_check_cluster(struct dnode_of_data *dn)
 {
+#ifdef CONFIG_F2FS_CHECK_FS
 	struct f2fs_sb_info *sbi = F2FS_I_SB(dn->inode);
 	unsigned int cluster_size = F2FS_I(dn->inode)->i_cluster_size;
-	bool compressed = dn->data_blkaddr == COMPRESS_ADDR;
 	int cluster_end = 0;
+	unsigned int count;
 	int i;
 	char *reason = "";
 
-	if (!compressed)
+	if (dn->data_blkaddr != COMPRESS_ADDR)
 		return false;
 
 	/* [..., COMPR_ADDR, ...] */
@@ -903,7 +904,7 @@ bool f2fs_sanity_check_cluster(struct dnode_of_data *dn)
 		goto out;
 	}
 
-	for (i = 1; i < cluster_size; i++) {
+	for (i = 1, count = 1; i < cluster_size; i++, count++) {
 		block_t blkaddr = data_blkaddr(dn->inode, dn->node_page,
 							dn->ofs_in_node + i);
 
@@ -923,19 +924,42 @@ bool f2fs_sanity_check_cluster(struct dnode_of_data *dn)
 			goto out;
 		}
 	}
+
+	f2fs_bug_on(F2FS_I_SB(dn->inode), count != cluster_size &&
+		!is_inode_flag_set(dn->inode, FI_COMPRESS_RELEASED));
+
 	return false;
 out:
 	f2fs_warn(sbi, "access invalid cluster, ino:%lu, nid:%u, ofs_in_node:%u, reason:%s",
 			dn->inode->i_ino, dn->nid, dn->ofs_in_node, reason);
 	set_sbi_flag(sbi, SBI_NEED_FSCK);
 	return true;
+#else
+	return false;
+#endif
+}
+
+static int __f2fs_get_cluster_blocks(struct inode *inode,
+					struct dnode_of_data *dn)
+{
+	unsigned int cluster_size = F2FS_I(inode)->i_cluster_size;
+	int count, i;
+
+	for (i = 1, count = 1; i < cluster_size; i++) {
+		block_t blkaddr = data_blkaddr(dn->inode, dn->node_page,
+							dn->ofs_in_node + i);
+
+		if (__is_valid_data_blkaddr(blkaddr))
+			count++;
+	}
+
+	return count;
 }
 
 static int __f2fs_cluster_blocks(struct inode *inode,
-				unsigned int cluster_idx, bool compr)
+				unsigned int cluster_idx, bool compr_blks)
 {
 	struct dnode_of_data dn;
-	unsigned int cluster_size = F2FS_I(inode)->i_cluster_size;
 	unsigned int start_idx = cluster_idx <<
 				F2FS_I(inode)->i_log_cluster_size;
 	int ret;
@@ -950,31 +974,14 @@ static int __f2fs_cluster_blocks(struct inode *inode,
 
 	if (f2fs_sanity_check_cluster(&dn)) {
 		ret = -EFSCORRUPTED;
-		f2fs_handle_error(F2FS_I_SB(inode), ERROR_CORRUPTED_CLUSTER);
 		goto fail;
 	}
 
 	if (dn.data_blkaddr == COMPRESS_ADDR) {
-		int i;
-
-		ret = 1;
-		for (i = 1; i < cluster_size; i++) {
-			block_t blkaddr;
-
-			blkaddr = data_blkaddr(dn.inode,
-					dn.node_page, dn.ofs_in_node + i);
-			if (compr) {
-				if (__is_valid_data_blkaddr(blkaddr))
-					ret++;
-			} else {
-				if (blkaddr != NULL_ADDR)
-					ret++;
-			}
-		}
-
-		f2fs_bug_on(F2FS_I_SB(inode),
-			!compr && ret != cluster_size &&
-			!is_inode_flag_set(inode, FI_COMPRESS_RELEASED));
+		if (compr_blks)
+			ret = __f2fs_get_cluster_blocks(inode, &dn);
+		else
+			ret = 1;
 	}
 fail:
 	f2fs_put_dnode(&dn);
@@ -987,7 +994,7 @@ static int f2fs_compressed_blocks(struct compress_ctx *cc)
 	return __f2fs_cluster_blocks(cc->inode, cc->cluster_idx, true);
 }
 
-/* return # of valid blocks in compressed cluster */
+/* return whether cluster is compressed one or not */
 int f2fs_is_compressed_cluster(struct inode *inode, pgoff_t index)
 {
 	return __f2fs_cluster_blocks(inode,
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index d54644d386842..1c59a3b2b2c34 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1614,9 +1614,7 @@ int f2fs_map_blocks(struct inode *inode, struct f2fs_map_blocks *map, int flag)
 			map->m_flags |= F2FS_MAP_NEW;
 	} else if (is_hole) {
 		if (f2fs_compressed_file(inode) &&
-		    f2fs_sanity_check_cluster(&dn) &&
-		    (flag != F2FS_GET_BLOCK_FIEMAP ||
-		     IS_ENABLED(CONFIG_F2FS_CHECK_FS))) {
+		    f2fs_sanity_check_cluster(&dn)) {
 			err = -EFSCORRUPTED;
 			f2fs_handle_error(sbi,
 					ERROR_CORRUPTED_CLUSTER);
-- 
2.43.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590634;
	b=C17l+TusgOOAwqVO2J0kXFXlpDRiH6F42ufrJoZyyvrjhWNn211oaaHbkN+0vkyzejyO
	 IA+csA+S5sRwpjNy5r842qstiTSWJortsA4mOn74FSL03B5ubA0Vql0WpP/fdR2g7NnxU
	 M4k5z5p7/Rin74GiiUeSVi0Mm7AvnH1gLmjjgZFDXh8EEIbcQ7Ebh7YCjW9r89diPs5AE
	 jxXVY+tfLVPEpx+ijM/xTBJQpJcuM8AsaoA7w7ttDJKF7U+LoNkoODPbx+1Opqi3WuNt/
	 sIYAiXjOMBS828yVq8n36Jj05Bl3ujA6hHCoL+cHKEThrEcsWKylsTiyupMaI0gQZUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pd/f2co+TT4Be41J3KaoySAWLqcHAyiTYX022oQYwMU=;
	b=iDmpYIuxihPbipA7kOZ/I8+PUufXkxBLZsIqInQTDXELgPOQIKZhybZNWGZCzwtfom5O
	 tn+I4UOkxHtx5nHFctUuPEdeNeLnitKIRLX0DBSYOiUD/W04EVcn5K0h7fMSEH3xrwZ+8
	 YRvYlrjJS4g6Ka6lucmFWTuA4rmtmZbVitz0GyLPIDCQhdPeGJDIH7nwlaS3cT02zybz6
	 TzwYYopL9bMb2lbXkYMroyncjNHvJVlhOCS1GiubRG/Zjh4EG4NdfQFUl9V1bJ8z/BXbE
	 rF7eEW7N2Yug6cLetiOBQ8JLbWGQgQclgjxqMuSbULLsM58YH+uhbK9Ersw8EXO8rcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zAVq8NI1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB7260A3804;
	Fri, 13 Nov 2026 17:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zAVq8NI1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B86A1F000C4;
	Fri, 13 Nov 2026 17:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590634;
	bh=pd/f2co+TT4Be41J3KaoySAWLqcHAyiTYX022oQYwMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zAVq8NI1zknkM552dtqmKVLJA05+L12MV7gXyjfSPP6dUrYAgvSXjpmOHhTJQ6ADx
	 yoFZRPVJXXVyLCrc9FQIAYrUbJVqFDpcpudBPZkGt5sLQJUBvmpnhivrh9/EnUGjbU
	 qlq1Q5qSTLFdIxOOClMEas6k0sXao8mdjFwhW6ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 513/686] f2fs: fix to avoid folio->mapping dereference in is_{meta, node}_folio()
Date: Fri, 13 Nov 2026 10:50:46 -0500
Message-ID: <20261113153838.369716571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit b5a71253c5c7e1139eab2f3e1e13e0bf2cbcaac7 ]

Otherwise, it may cause NULL pointer dereference in race condition:

Thread A			Thread B
				- f2fs_setattr
				 - f2fs_truncate
				  - f2fs_truncate_blocks
			    	   - f2fs_do_truncate_blocks
				    - f2fs_truncate_inode_blocks
				     - truncate_dnode
				      - truncate_node
				       - invalidate_mapping_pages
				        - folio->mapping = NULL
- folio_lock
- is_node_folio
 - F2FS_F_SB(folio): dereference on folio->mapping

Cc: stable@kernel.org
Fixes: 019a8912425e ("f2fs: introduce is_{meta,node}_folio")
Reported-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Closes: https://lore.kernel.org/linux-f2fs-devel/c5d29b31-e764-4782-9639-be84b1b2bfc2@kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: used the existing sbi parameter in f2fs_in_warm_node_list() without changing its signature or callers ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c |  4 ++--
 fs/f2fs/data.c       |  5 +++--
 fs/f2fs/f2fs.h       |  8 ++++----
 fs/f2fs/gc.c         |  2 +-
 fs/f2fs/node.c       | 16 ++++++++--------
 5 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 66d3714dda32a..4c54d75c8981e 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -93,7 +93,7 @@ static struct folio *__get_meta_folio(struct f2fs_sb_info *sbi, pgoff_t index,
 	f2fs_update_iostat(sbi, NULL, FS_META_READ_IO, F2FS_BLKSIZE);
 
 	folio_lock(folio);
-	if (unlikely(!is_meta_folio(folio))) {
+	if (unlikely(!is_meta_folio(sbi, folio))) {
 		f2fs_folio_put(folio, true);
 		goto repeat;
 	}
@@ -439,7 +439,7 @@ long f2fs_sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 
 			folio_lock(folio);
 
-			if (unlikely(!is_meta_folio(folio))) {
+			if (unlikely(!is_meta_folio(sbi, folio))) {
 continue_unlock:
 				folio_unlock(folio);
 				continue;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index eba1e025b9d6e..a9a829315c305 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -153,7 +153,8 @@ static void f2fs_finish_read_bio(struct bio *bio, bool in_task)
 		dec_page_count(F2FS_F_SB(folio), __read_io_type(folio));
 
 		if (bio->bi_status == BLK_STS_OK &&
-			F2FS_F_SB(folio)->node_inode && is_node_folio(folio) &&
+			F2FS_F_SB(folio)->node_inode &&
+			is_node_folio(F2FS_F_SB(folio), folio) &&
 			f2fs_sanity_check_node_footer(F2FS_F_SB(folio),
 				folio, folio->index, NODE_TYPE_REGULAR, true))
 			bio->bi_status = BLK_STS_IOERR;
@@ -359,7 +360,7 @@ static void f2fs_write_end_io(struct bio *bio)
 						STOP_CP_REASON_WRITE_FAIL);
 		}
 
-		if (is_node_folio(folio)) {
+		if (is_node_folio(sbi, folio)) {
 			f2fs_sanity_check_node_footer(sbi, folio,
 				folio->index, NODE_TYPE_REGULAR, true);
 			f2fs_bug_on(sbi, folio->index != nid_of_node(folio));
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index ec1b9831e5afe..82c3c4ebcb3e6 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2222,14 +2222,14 @@ static inline struct address_space *NODE_MAPPING(struct f2fs_sb_info *sbi)
 	return sbi->node_inode->i_mapping;
 }
 
-static inline bool is_meta_folio(struct folio *folio)
+static inline bool is_meta_folio(struct f2fs_sb_info *sbi, struct folio *folio)
 {
-	return folio->mapping == META_MAPPING(F2FS_F_SB(folio));
+	return folio->mapping == META_MAPPING(sbi);
 }
 
-static inline bool is_node_folio(struct folio *folio)
+static inline bool is_node_folio(struct f2fs_sb_info *sbi, struct folio *folio)
 {
-	return folio->mapping == NODE_MAPPING(F2FS_F_SB(folio));
+	return folio->mapping == NODE_MAPPING(sbi);
 }
 
 static inline bool is_sbi_flag_set(struct f2fs_sb_info *sbi, unsigned int type)
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index e85d7f239e7d0..e3ae70e297c82 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1418,7 +1418,7 @@ static int move_data_block(struct inode *inode, block_t bidx,
 							F2FS_BLKSIZE);
 
 		folio_lock(mfolio);
-		if (unlikely(!is_meta_folio(mfolio) ||
+		if (unlikely(!is_meta_folio(fio.sbi, mfolio) ||
 			     !folio_test_uptodate(mfolio))) {
 			err = -EIO;
 			f2fs_folio_put(mfolio, true);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 60969e5f1201b..1b67184df3dd6 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -327,7 +327,7 @@ static unsigned int __gang_lookup_nat_set(struct f2fs_nm_info *nm_i,
 
 bool f2fs_in_warm_node_list(struct f2fs_sb_info *sbi, struct folio *folio)
 {
-	return is_node_folio(folio) && IS_DNODE(folio) && is_cold_node(folio);
+	return is_node_folio(sbi, folio) && IS_DNODE(folio) && is_cold_node(folio);
 }
 
 void f2fs_init_fsync_node_info(struct f2fs_sb_info *sbi)
@@ -1266,7 +1266,7 @@ int f2fs_truncate_inode_blocks(struct inode *inode, pgoff_t from)
 			goto fail;
 		if (offset[1] == 0 && get_nid(folio, offset[0], true)) {
 			folio_lock(folio);
-			BUG_ON(!is_node_folio(folio));
+			BUG_ON(!is_node_folio(sbi, folio));
 			set_nid(folio, offset[0], 0, true);
 			folio_unlock(folio);
 		}
@@ -1579,7 +1579,7 @@ static struct folio *__get_node_folio(struct f2fs_sb_info *sbi, pgoff_t nid,
 
 	folio_lock(folio);
 
-	if (unlikely(!is_node_folio(folio))) {
+	if (unlikely(!is_node_folio(sbi, folio))) {
 		f2fs_folio_put(folio, true);
 		goto repeat;
 	}
@@ -1698,7 +1698,7 @@ static struct folio *last_fsync_dnode(struct f2fs_sb_info *sbi, nid_t ino)
 
 			folio_lock(folio);
 
-			if (unlikely(!is_node_folio(folio))) {
+			if (unlikely(!is_node_folio(sbi, folio))) {
 continue_unlock:
 				folio_unlock(folio);
 				continue;
@@ -1930,7 +1930,7 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 
 			folio_lock(folio);
 
-			if (unlikely(!is_node_folio(folio))) {
+			if (unlikely(!is_node_folio(sbi, folio))) {
 continue_unlock:
 				folio_unlock(folio);
 				continue;
@@ -1988,7 +1988,7 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 		f2fs_debug(sbi, "Retry to write fsync mark: ino=%u, idx=%lx",
 			   ino, last_folio->index);
 		folio_lock(last_folio);
-		if (unlikely(!is_node_folio(last_folio))) {
+		if (unlikely(!is_node_folio(sbi, last_folio))) {
 			f2fs_folio_put(last_folio, true);
 			ret = -EAGAIN;
 			goto out;
@@ -2066,7 +2066,7 @@ void f2fs_flush_inline_data(struct f2fs_sb_info *sbi)
 
 			folio_lock(folio);
 
-			if (unlikely(!is_node_folio(folio)))
+			if (unlikely(!is_node_folio(sbi, folio)))
 				goto unlock;
 			if (!folio_test_dirty(folio))
 				goto unlock;
@@ -2138,7 +2138,7 @@ int f2fs_sync_node_pages(struct f2fs_sb_info *sbi,
 			else if (!folio_trylock(folio))
 				continue;
 
-			if (unlikely(!is_node_folio(folio))) {
+			if (unlikely(!is_node_folio(sbi, folio))) {
 continue_unlock:
 				folio_unlock(folio);
 				continue;
-- 
2.53.0




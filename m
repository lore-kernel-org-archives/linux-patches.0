Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31494777A;
	Thu, 30 Nov 2023 16:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLzbRBra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40888C433C8;
	Thu, 30 Nov 2023 16:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361872;
	bh=Cd4N5hrCa+u6eVMI3dWReon6Qf0hCiXul8acyPm2Kgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLzbRBradL3siuJNnMk83BWUr88obLZvSM+sjglkcSeL94XqmF2PxV2uqwkS6WAgo
	 +lroithSw5+PaMSnQnSUmk5+BDbEFzuhJBllKn1DMPZuRNadGHQKx8Gq8xvHjWo5Nm
	 p9ygrwbGdlkk76rYXWhHi19pS69khnL+HHqy6E78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 47/82] ext4: use pre-allocated es in __es_remove_extent()
Date: Thu, 30 Nov 2023 16:22:18 +0000
Message-ID: <20231130162137.464666932@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit bda3efaf774fb687c2b7a555aaec3006b14a8857 ]

When splitting extent, if the second extent can not be dropped, we return
-ENOMEM and use GFP_NOFAIL to preallocate an extent_status outside of
i_es_lock and pass it to __es_remove_extent() to be used as the second
extent. This ensures that __es_remove_extent() is executed successfully,
thus ensuring consistency in the extent status tree. If the second extent
is not undroppable, we simply drop it and return 0. Then retry is no longer
necessary, remove it.

Now, __es_remove_extent() will always remove what it should, maybe more.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230424033846.4732-6-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 8e387c89e96b ("ext4: make sure allocate pending entry not fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents_status.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index e459a0c2d71ef..682f5e4ce2d00 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -147,7 +147,8 @@ static struct kmem_cache *ext4_pending_cachep;
 static int __es_insert_extent(struct inode *inode, struct extent_status *newes,
 			      struct extent_status *prealloc);
 static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
-			      ext4_lblk_t end, int *reserved);
+			      ext4_lblk_t end, int *reserved,
+			      struct extent_status *prealloc);
 static int es_reclaim_extents(struct ext4_inode_info *ei, int *nr_to_scan);
 static int __es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
 		       struct ext4_inode_info *locked_ei);
@@ -869,7 +870,7 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 	ext4_es_insert_extent_check(inode, &newes);
 
 	write_lock(&EXT4_I(inode)->i_es_lock);
-	err = __es_remove_extent(inode, lblk, end, NULL);
+	err = __es_remove_extent(inode, lblk, end, NULL, NULL);
 	if (err != 0)
 		goto error;
 retry:
@@ -1313,6 +1314,7 @@ static unsigned int get_rsvd(struct inode *inode, ext4_lblk_t end,
  * @lblk - first block in range
  * @end - last block in range
  * @reserved - number of cluster reservations released
+ * @prealloc - pre-allocated es to avoid memory allocation failures
  *
  * If @reserved is not NULL and delayed allocation is enabled, counts
  * block/cluster reservations freed by removing range and if bigalloc
@@ -1320,7 +1322,8 @@ static unsigned int get_rsvd(struct inode *inode, ext4_lblk_t end,
  * error code on failure.
  */
 static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
-			      ext4_lblk_t end, int *reserved)
+			      ext4_lblk_t end, int *reserved,
+			      struct extent_status *prealloc)
 {
 	struct ext4_es_tree *tree = &EXT4_I(inode)->i_es_tree;
 	struct rb_node *node;
@@ -1328,14 +1331,12 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 	struct extent_status orig_es;
 	ext4_lblk_t len1, len2;
 	ext4_fsblk_t block;
-	int err;
+	int err = 0;
 	bool count_reserved = true;
 	struct rsvd_count rc;
 
 	if (reserved == NULL || !test_opt(inode->i_sb, DELALLOC))
 		count_reserved = false;
-retry:
-	err = 0;
 
 	es = __es_tree_search(&tree->root, lblk);
 	if (!es)
@@ -1369,14 +1370,13 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 					orig_es.es_len - len2;
 			ext4_es_store_pblock_status(&newes, block,
 						    ext4_es_status(&orig_es));
-			err = __es_insert_extent(inode, &newes, NULL);
+			err = __es_insert_extent(inode, &newes, prealloc);
 			if (err) {
+				if (!ext4_es_must_keep(&newes))
+					return 0;
+
 				es->es_lblk = orig_es.es_lblk;
 				es->es_len = orig_es.es_len;
-				if ((err == -ENOMEM) &&
-				    __es_shrink(EXT4_SB(inode->i_sb),
-							128, EXT4_I(inode)))
-					goto retry;
 				goto out;
 			}
 		} else {
@@ -1476,7 +1476,7 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 	 * is reclaimed.
 	 */
 	write_lock(&EXT4_I(inode)->i_es_lock);
-	err = __es_remove_extent(inode, lblk, end, &reserved);
+	err = __es_remove_extent(inode, lblk, end, &reserved, NULL);
 	write_unlock(&EXT4_I(inode)->i_es_lock);
 	ext4_es_print_tree(inode);
 	ext4_da_release_space(inode, reserved);
@@ -2021,7 +2021,7 @@ int ext4_es_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk,
 
 	write_lock(&EXT4_I(inode)->i_es_lock);
 
-	err = __es_remove_extent(inode, lblk, lblk, NULL);
+	err = __es_remove_extent(inode, lblk, lblk, NULL, NULL);
 	if (err != 0)
 		goto error;
 retry:
-- 
2.42.0




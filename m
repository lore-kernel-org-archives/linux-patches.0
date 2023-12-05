Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5938BF7;
	Tue,  5 Dec 2023 03:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIuHEJbt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C848DC433C8;
	Tue,  5 Dec 2023 03:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747862;
	bh=yzcRg9CUBwWwCEeLUANFrGu8HGjNP2rjgCIUJMdJ4gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIuHEJbtOgQRE2eou7oTr4J1xnEFRs+Tvhu0WQH4DIK1BDQDwHgfqRH/DTq5sM239
	 khwDq/6tWzEp/39DIq/TwfjLkXsEpjUnwsQm3ln89lcEr/F4RNKpPJuz4keAqfd3Th
	 QphfUTsKlP5Uu9u9PU7AAH9tVZWLFuuxBSyvKwWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/94] ext4: use pre-allocated es in __es_remove_extent()
Date: Tue,  5 Dec 2023 12:16:54 +0900
Message-ID: <20231205031524.369681317@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index eef9f2dc99daa..1bfee9dff9c38 100644
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
@@ -858,7 +859,7 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 	ext4_es_insert_extent_check(inode, &newes);
 
 	write_lock(&EXT4_I(inode)->i_es_lock);
-	err = __es_remove_extent(inode, lblk, end, NULL);
+	err = __es_remove_extent(inode, lblk, end, NULL, NULL);
 	if (err != 0)
 		goto error;
 retry:
@@ -1296,6 +1297,7 @@ static unsigned int get_rsvd(struct inode *inode, ext4_lblk_t end,
  * @lblk - first block in range
  * @end - last block in range
  * @reserved - number of cluster reservations released
+ * @prealloc - pre-allocated es to avoid memory allocation failures
  *
  * If @reserved is not NULL and delayed allocation is enabled, counts
  * block/cluster reservations freed by removing range and if bigalloc
@@ -1303,7 +1305,8 @@ static unsigned int get_rsvd(struct inode *inode, ext4_lblk_t end,
  * error code on failure.
  */
 static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
-			      ext4_lblk_t end, int *reserved)
+			      ext4_lblk_t end, int *reserved,
+			      struct extent_status *prealloc)
 {
 	struct ext4_es_tree *tree = &EXT4_I(inode)->i_es_tree;
 	struct rb_node *node;
@@ -1311,14 +1314,12 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
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
@@ -1352,14 +1353,13 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
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
@@ -1456,7 +1456,7 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 	 * is reclaimed.
 	 */
 	write_lock(&EXT4_I(inode)->i_es_lock);
-	err = __es_remove_extent(inode, lblk, end, &reserved);
+	err = __es_remove_extent(inode, lblk, end, &reserved, NULL);
 	write_unlock(&EXT4_I(inode)->i_es_lock);
 	ext4_es_print_tree(inode);
 	ext4_da_release_space(inode, reserved);
@@ -1997,7 +1997,7 @@ int ext4_es_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk,
 
 	write_lock(&EXT4_I(inode)->i_es_lock);
 
-	err = __es_remove_extent(inode, lblk, lblk, NULL);
+	err = __es_remove_extent(inode, lblk, lblk, NULL, NULL);
 	if (err != 0)
 		goto error;
 retry:
-- 
2.42.0




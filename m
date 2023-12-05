Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D6B6FB0;
	Tue,  5 Dec 2023 03:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgSlxwc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB782C433C8;
	Tue,  5 Dec 2023 03:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747859;
	bh=glTfsYsICF5C0pdt2IC7hb5guoBzbrdwPiHdxRzrF24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgSlxwc5X9nNxhmqad2dF2q6P+DGHGfm9y4Q3uE+13mZaf6bXqPZ3LNX73kKY1LaQ
	 bSkG0nvbnwg/UW31Bi+EjR5Je0LfouGQjru3eiNNM6zoTzK3BiBqceMhT9pmnBnd25
	 R7sb1oGFNcbeuNoo8zjLUz3dtlKptx1k27rXdq5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 25/94] ext4: use pre-allocated es in __es_insert_extent()
Date: Tue,  5 Dec 2023 12:16:53 +0900
Message-ID: <20231205031524.314383403@linuxfoundation.org>
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

[ Upstream commit 95f0b320339a977cf69872eac107122bf536775d ]

Pass a extent_status pointer prealloc to __es_insert_extent(). If the
pointer is non-null, it is used directly when a new extent_status is
needed to avoid memory allocation failures.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230424033846.4732-5-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 8e387c89e96b ("ext4: make sure allocate pending entry not fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents_status.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index dfabb15afd3dd..eef9f2dc99daa 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -144,7 +144,8 @@
 static struct kmem_cache *ext4_es_cachep;
 static struct kmem_cache *ext4_pending_cachep;
 
-static int __es_insert_extent(struct inode *inode, struct extent_status *newes);
+static int __es_insert_extent(struct inode *inode, struct extent_status *newes,
+			      struct extent_status *prealloc);
 static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 			      ext4_lblk_t end, int *reserved);
 static int es_reclaim_extents(struct ext4_inode_info *ei, int *nr_to_scan);
@@ -760,7 +761,8 @@ static inline void ext4_es_insert_extent_check(struct inode *inode,
 }
 #endif
 
-static int __es_insert_extent(struct inode *inode, struct extent_status *newes)
+static int __es_insert_extent(struct inode *inode, struct extent_status *newes,
+			      struct extent_status *prealloc)
 {
 	struct ext4_es_tree *tree = &EXT4_I(inode)->i_es_tree;
 	struct rb_node **p = &tree->root.rb_node;
@@ -800,7 +802,10 @@ static int __es_insert_extent(struct inode *inode, struct extent_status *newes)
 		}
 	}
 
-	es = __es_alloc_extent(false);
+	if (prealloc)
+		es = prealloc;
+	else
+		es = __es_alloc_extent(false);
 	if (!es)
 		return -ENOMEM;
 	ext4_es_init_extent(inode, es, newes->es_lblk, newes->es_len,
@@ -857,7 +862,7 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 	if (err != 0)
 		goto error;
 retry:
-	err = __es_insert_extent(inode, &newes);
+	err = __es_insert_extent(inode, &newes, NULL);
 	if (err == -ENOMEM && __es_shrink(EXT4_SB(inode->i_sb),
 					  128, EXT4_I(inode)))
 		goto retry;
@@ -904,7 +909,7 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
 
 	es = __es_tree_search(&EXT4_I(inode)->i_es_tree.root, lblk);
 	if (!es || es->es_lblk > end)
-		__es_insert_extent(inode, &newes);
+		__es_insert_extent(inode, &newes, NULL);
 	write_unlock(&EXT4_I(inode)->i_es_lock);
 }
 
@@ -1347,7 +1352,7 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 					orig_es.es_len - len2;
 			ext4_es_store_pblock_status(&newes, block,
 						    ext4_es_status(&orig_es));
-			err = __es_insert_extent(inode, &newes);
+			err = __es_insert_extent(inode, &newes, NULL);
 			if (err) {
 				es->es_lblk = orig_es.es_lblk;
 				es->es_len = orig_es.es_len;
@@ -1996,7 +2001,7 @@ int ext4_es_insert_delayed_block(struct inode *inode, ext4_lblk_t lblk,
 	if (err != 0)
 		goto error;
 retry:
-	err = __es_insert_extent(inode, &newes);
+	err = __es_insert_extent(inode, &newes, NULL);
 	if (err == -ENOMEM && __es_shrink(EXT4_SB(inode->i_sb),
 					  128, EXT4_I(inode)))
 		goto retry;
-- 
2.42.0




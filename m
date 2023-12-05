Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6AA79E3;
	Tue,  5 Dec 2023 03:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZUFTN+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFCCC433C8;
	Tue,  5 Dec 2023 03:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747338;
	bh=ag2BH+BIQlS5DmpeLE7UIXQPzWy/IF1/ChoXqLzJbIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZUFTN+cbwLtRAh7tdSJ83D10LLN0ABoGinShpiatRrFwE0CwzUt4dQFi4gWs/OCR
	 NdjsN/IMKZBr8uz/kh6nNKNmgBG8MODexYTVqVB4sVR8PHTD9ja9fovGT6B34jJezY
	 L+Ta6JP56cFhOycr2RlkCNRSGpiWdpIHw/UXQkYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/135] ext4: factor out __es_alloc_extent() and __es_free_extent()
Date: Tue,  5 Dec 2023 12:16:00 +0900
Message-ID: <20231205031533.089171321@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 73a2f033656be11298912201ad50615307b4477a ]

Factor out __es_alloc_extent() and __es_free_extent(), which only allocate
and free extent_status in these two helpers.

The ext4_es_alloc_extent() function is split into __es_alloc_extent()
and ext4_es_init_extent(). In __es_alloc_extent() we allocate memory using
GFP_KERNEL | __GFP_NOFAIL | __GFP_ZERO if the memory allocation cannot
fail, otherwise we use GFP_ATOMIC. and the ext4_es_init_extent() is used to
initialize extent_status and update related variables after a successful
allocation.

This is to prepare for the use of pre-allocated extent_status later.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20230424033846.4732-4-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 8e387c89e96b ("ext4: make sure allocate pending entry not fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents_status.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index cf6a21baddbc4..012033db41062 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -461,14 +461,17 @@ static inline bool ext4_es_must_keep(struct extent_status *es)
 	return false;
 }
 
-static struct extent_status *
-ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
-		     ext4_fsblk_t pblk)
+static inline struct extent_status *__es_alloc_extent(bool nofail)
+{
+	if (!nofail)
+		return kmem_cache_alloc(ext4_es_cachep, GFP_ATOMIC);
+
+	return kmem_cache_zalloc(ext4_es_cachep, GFP_KERNEL | __GFP_NOFAIL);
+}
+
+static void ext4_es_init_extent(struct inode *inode, struct extent_status *es,
+		ext4_lblk_t lblk, ext4_lblk_t len, ext4_fsblk_t pblk)
 {
-	struct extent_status *es;
-	es = kmem_cache_alloc(ext4_es_cachep, GFP_ATOMIC);
-	if (es == NULL)
-		return NULL;
 	es->es_lblk = lblk;
 	es->es_len = len;
 	es->es_pblk = pblk;
@@ -483,8 +486,11 @@ ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
 
 	EXT4_I(inode)->i_es_all_nr++;
 	percpu_counter_inc(&EXT4_SB(inode->i_sb)->s_es_stats.es_stats_all_cnt);
+}
 
-	return es;
+static inline void __es_free_extent(struct extent_status *es)
+{
+	kmem_cache_free(ext4_es_cachep, es);
 }
 
 static void ext4_es_free_extent(struct inode *inode, struct extent_status *es)
@@ -501,7 +507,7 @@ static void ext4_es_free_extent(struct inode *inode, struct extent_status *es)
 					s_es_stats.es_stats_shk_cnt);
 	}
 
-	kmem_cache_free(ext4_es_cachep, es);
+	__es_free_extent(es);
 }
 
 /*
@@ -803,10 +809,12 @@ static int __es_insert_extent(struct inode *inode, struct extent_status *newes)
 		}
 	}
 
-	es = ext4_es_alloc_extent(inode, newes->es_lblk, newes->es_len,
-				  newes->es_pblk);
+	es = __es_alloc_extent(false);
 	if (!es)
 		return -ENOMEM;
+	ext4_es_init_extent(inode, es, newes->es_lblk, newes->es_len,
+			    newes->es_pblk);
+
 	rb_link_node(&es->rb_node, parent, p);
 	rb_insert_color(&es->rb_node, &tree->root);
 
-- 
2.42.0




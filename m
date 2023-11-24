Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813D839FF7;
	Fri, 24 Nov 2023 18:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hr/XHtRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80161C433C7;
	Fri, 24 Nov 2023 18:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850226;
	bh=3FkTIAmOKq8frBfgah70vEyLSVAb2EbMj+sWF4mqMGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hr/XHtROKbUQCxIAKxx/8o/9VRzwvgjoQcRPjDVKEMHl0U9GAgxsuT6XxCHhA/wt7
	 cBadPIEDOOl6t2fEWENJWT81pjPnLaMHWsI7rXHSGqtmaQyNl4jhXEX5EbGacle3Ti
	 y+xHbOkbzdwIAhNAFWE/qjqhCjrqix+kzzndFCqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jianjian <wangjianjian0@foxmail.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 496/530] ext4: no need to generate from free list in mballoc
Date: Fri, 24 Nov 2023 17:51:02 +0000
Message-ID: <20231124172043.251194049@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Wang Jianjian <wangjianjian0@foxmail.com>

commit ebf6cb7c6e1241984f75f29f1bdbfa2fe7168f88 upstream.

Commit 7a2fcbf7f85 ("ext4: don't use blocks freed but not yet committed in
buddy cache init") added a code to mark as used blocks in the list of not yet
committed freed blocks during initialization of a buddy page. However
ext4_mb_free_metadata() makes sure buddy page is already loaded and takes a
reference to it so it cannot happen that ext4_mb_init_cache() is called
when efd list is non-empty. Just remove the
ext4_mb_generate_from_freelist() call.

Fixes: 7a2fcbf7f85('ext4: don't use blocks freed but not yet committed in buddy cache init')
Signed-off-by: Wang Jianjian <wangjianjian0@foxmail.com>
Link: https://lore.kernel.org/r/tencent_53CBCB1668358AE862684E453DF37B722008@qq.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/mballoc.c |   39 ++++++---------------------------------
 1 file changed, 6 insertions(+), 33 deletions(-)

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -417,8 +417,6 @@ static const char * const ext4_groupinfo
 
 static void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap,
 					ext4_group_t group);
-static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
-						ext4_group_t group);
 static void ext4_mb_new_preallocation(struct ext4_allocation_context *ac);
 
 static bool ext4_mb_good_group(struct ext4_allocation_context *ac,
@@ -1361,17 +1359,17 @@ static int ext4_mb_init_cache(struct pag
 		 * We place the buddy block and bitmap block
 		 * close together
 		 */
+		grinfo = ext4_get_group_info(sb, group);
+		if (!grinfo) {
+			err = -EFSCORRUPTED;
+		        goto out;
+		}
 		if ((first_block + i) & 1) {
 			/* this is block of buddy */
 			BUG_ON(incore == NULL);
 			mb_debug(sb, "put buddy for group %u in page %lu/%x\n",
 				group, page->index, i * blocksize);
 			trace_ext4_mb_buddy_bitmap_load(sb, group);
-			grinfo = ext4_get_group_info(sb, group);
-			if (!grinfo) {
-				err = -EFSCORRUPTED;
-				goto out;
-			}
 			grinfo->bb_fragments = 0;
 			memset(grinfo->bb_counters, 0,
 			       sizeof(*grinfo->bb_counters) *
@@ -1398,7 +1396,7 @@ static int ext4_mb_init_cache(struct pag
 
 			/* mark all preallocated blks used in in-core bitmap */
 			ext4_mb_generate_from_pa(sb, data, group);
-			ext4_mb_generate_from_freelist(sb, data, group);
+			WARN_ON_ONCE(!RB_EMPTY_ROOT(&grinfo->bb_free_root));
 			ext4_unlock_group(sb, group);
 
 			/* set incore so that the buddy information can be
@@ -4959,31 +4957,6 @@ try_group_pa:
 }
 
 /*
- * the function goes through all block freed in the group
- * but not yet committed and marks them used in in-core bitmap.
- * buddy must be generated from this bitmap
- * Need to be called with the ext4 group lock held
- */
-static void ext4_mb_generate_from_freelist(struct super_block *sb, void *bitmap,
-						ext4_group_t group)
-{
-	struct rb_node *n;
-	struct ext4_group_info *grp;
-	struct ext4_free_data *entry;
-
-	grp = ext4_get_group_info(sb, group);
-	if (!grp)
-		return;
-	n = rb_first(&(grp->bb_free_root));
-
-	while (n) {
-		entry = rb_entry(n, struct ext4_free_data, efd_node);
-		mb_set_bits(bitmap, entry->efd_start_cluster, entry->efd_count);
-		n = rb_next(n);
-	}
-}
-
-/*
  * the function goes through all preallocation in this group and marks them
  * used in in-core bitmap. buddy must be generated from this bitmap
  * Need to be called with ext4 group lock held



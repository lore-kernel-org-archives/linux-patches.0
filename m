Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45ADCFBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11F3C433D2;
	Mon, 15 May 2023 17:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170617;
	bh=NdQC4j9rbfzgrqJC26PMtR0k2cueOUmcn8kcyzR3voM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wMm1VHc3HWvxPqO19AU2etdAYlwmW3qeqpWl3NUbqAJgy3CXGxOhf9Re+V5A3huy4
	 xbqwyNHVSPkEklcR+0rKC4HWo6oLxsvGpx5RHPxP99egf2uMfjXZ4rhRfcn63WdcMI
	 VUC7P3PipjPGKQNCuzH5OcyFAB3LeYZ3RWTDsj+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 188/239] f2fs: allocate the extent_cache by default
Date: Mon, 15 May 2023 18:27:31 +0200
Message-Id: <20230515161727.298043912@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 72840cccc0a1a0a0dc1bb27b669a9111be6d0f6a ]

Let's allocate it to remove the runtime complexity.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 043d2d00b443 ("f2fs: factor out victim_entry usage from general rb_tree use")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/extent_cache.c | 38 +++++++++++++++++++-------------------
 fs/f2fs/f2fs.h         |  3 ++-
 fs/f2fs/inode.c        |  6 ++++--
 fs/f2fs/namei.c        |  4 ++--
 4 files changed, 27 insertions(+), 24 deletions(-)

diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index 4217076df1024..794a8134687ae 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -47,20 +47,23 @@ static bool __may_read_extent_tree(struct inode *inode)
 	return S_ISREG(inode->i_mode);
 }
 
-static bool __may_extent_tree(struct inode *inode, enum extent_type type)
+static bool __init_may_extent_tree(struct inode *inode, enum extent_type type)
 {
-	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	if (type == EX_READ)
+		return __may_read_extent_tree(inode);
+	return false;
+}
 
+static bool __may_extent_tree(struct inode *inode, enum extent_type type)
+{
 	/*
 	 * for recovered files during mount do not create extents
 	 * if shrinker is not registered.
 	 */
-	if (list_empty(&sbi->s_list))
+	if (list_empty(&F2FS_I_SB(inode)->s_list))
 		return false;
 
-	if (type == EX_READ)
-		return __may_read_extent_tree(inode);
-	return false;
+	return __init_may_extent_tree(inode, type);
 }
 
 static void __try_update_largest_extent(struct extent_tree *et,
@@ -439,20 +442,18 @@ static void __drop_largest_extent(struct extent_tree *et,
 	}
 }
 
-/* return true, if inode page is changed */
-static void __f2fs_init_extent_tree(struct inode *inode, struct page *ipage,
-							enum extent_type type)
+void f2fs_init_read_extent_tree(struct inode *inode, struct page *ipage)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	struct extent_tree_info *eti = &sbi->extent_tree[type];
-	struct f2fs_extent *i_ext = ipage ? &F2FS_INODE(ipage)->i_ext : NULL;
+	struct extent_tree_info *eti = &sbi->extent_tree[EX_READ];
+	struct f2fs_extent *i_ext = &F2FS_INODE(ipage)->i_ext;
 	struct extent_tree *et;
 	struct extent_node *en;
 	struct extent_info ei;
 
-	if (!__may_extent_tree(inode, type)) {
+	if (!__may_extent_tree(inode, EX_READ)) {
 		/* drop largest read extent */
-		if (type == EX_READ && i_ext && i_ext->len) {
+		if (i_ext && i_ext->len) {
 			f2fs_wait_on_page_writeback(ipage, NODE, true, true);
 			i_ext->len = 0;
 			set_page_dirty(ipage);
@@ -460,13 +461,11 @@ static void __f2fs_init_extent_tree(struct inode *inode, struct page *ipage,
 		goto out;
 	}
 
-	et = __grab_extent_tree(inode, type);
+	et = __grab_extent_tree(inode, EX_READ);
 
 	if (!i_ext || !i_ext->len)
 		goto out;
 
-	BUG_ON(type != EX_READ);
-
 	get_read_extent_info(&ei, i_ext);
 
 	write_lock(&et->lock);
@@ -486,14 +485,15 @@ static void __f2fs_init_extent_tree(struct inode *inode, struct page *ipage,
 unlock_out:
 	write_unlock(&et->lock);
 out:
-	if (type == EX_READ && !F2FS_I(inode)->extent_tree[EX_READ])
+	if (!F2FS_I(inode)->extent_tree[EX_READ])
 		set_inode_flag(inode, FI_NO_EXTENT);
 }
 
-void f2fs_init_extent_tree(struct inode *inode, struct page *ipage)
+void f2fs_init_extent_tree(struct inode *inode)
 {
 	/* initialize read cache */
-	__f2fs_init_extent_tree(inode, ipage, EX_READ);
+	if (__init_may_extent_tree(inode, EX_READ))
+		__grab_extent_tree(inode, EX_READ);
 }
 
 static bool __lookup_extent_tree(struct inode *inode, pgoff_t pgofs,
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index cf45af3a44a7a..3fc9d98112166 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4147,7 +4147,7 @@ struct rb_entry *f2fs_lookup_rb_tree_ret(struct rb_root_cached *root,
 		bool force, bool *leftmost);
 bool f2fs_check_rb_tree_consistence(struct f2fs_sb_info *sbi,
 				struct rb_root_cached *root, bool check_key);
-void f2fs_init_extent_tree(struct inode *inode, struct page *ipage);
+void f2fs_init_extent_tree(struct inode *inode);
 void f2fs_drop_extent_tree(struct inode *inode);
 void f2fs_destroy_extent_node(struct inode *inode);
 void f2fs_destroy_extent_tree(struct inode *inode);
@@ -4156,6 +4156,7 @@ int __init f2fs_create_extent_cache(void);
 void f2fs_destroy_extent_cache(void);
 
 /* read extent cache ops */
+void f2fs_init_read_extent_tree(struct inode *inode, struct page *ipage);
 bool f2fs_lookup_read_extent_cache(struct inode *inode, pgoff_t pgofs,
 			struct extent_info *ei);
 void f2fs_update_read_extent_cache(struct dnode_of_data *dn);
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 7bfe29626024d..2bda4e73fc1ce 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -392,8 +392,6 @@ static int do_read_inode(struct inode *inode)
 	fi->i_pino = le32_to_cpu(ri->i_pino);
 	fi->i_dir_level = ri->i_dir_level;
 
-	f2fs_init_extent_tree(inode, node_page);
-
 	get_inline_info(inode, ri);
 
 	fi->i_extra_isize = f2fs_has_extra_attr(inode) ?
@@ -479,6 +477,10 @@ static int do_read_inode(struct inode *inode)
 	}
 
 	init_idisk_time(inode);
+
+	/* Need all the flag bits */
+	f2fs_init_read_extent_tree(inode, node_page);
+
 	f2fs_put_page(node_page, 1);
 
 	stat_inc_inline_xattr(inode);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 51d0030bddb27..d879a295b688e 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -258,8 +258,6 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
 	}
 	F2FS_I(inode)->i_inline_xattr_size = xattr_size;
 
-	f2fs_init_extent_tree(inode, NULL);
-
 	F2FS_I(inode)->i_flags =
 		f2fs_mask_flags(mode, F2FS_I(dir)->i_flags & F2FS_FL_INHERITED);
 
@@ -282,6 +280,8 @@ static struct inode *f2fs_new_inode(struct user_namespace *mnt_userns,
 
 	f2fs_set_inode_flags(inode);
 
+	f2fs_init_extent_tree(inode);
+
 	trace_f2fs_new_inode(inode, 0);
 	return inode;
 
-- 
2.39.2




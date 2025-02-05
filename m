Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199F81FCD05;
	Wed,  5 Feb 2025 14:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767323; cv=none; b=Tg/AytoupVwDrU3GWLEIM+36AgNxPT6BzQGK4duusLnZW+RldDnD39Ftjw8zuVFpuH9CPaw9em10PSophFg6C2M5SNX345Hbp4OpA2CD4Tb590mfJsWlQO+tp4BDiXmFiKHZu61vQpHbf3oGCbg6CJzIx8joAkmHev/9GqnWFFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767323; c=relaxed/simple;
	bh=IlxsqQ+6XefBJ0UbQOjSXCh2L3i8u1VWNxTNnjWxwMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipFHfkMjJZKykKNW4VDB/86aGR7CF9iNyT8Ct+pZdVH0KCSBVNFCDAIGINEi4nSv81j78TnzhUOfHGg1f403BoaMLCuAi4TRvqwDdmB7ClfGEUY642SSSUXi5e2ms5LbN9EzWOZKYvvxDJdCdNjndO7kh5BDItcjQ8RdSPsOIQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLux0LQE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLux0LQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A84CC4CED1;
	Wed,  5 Feb 2025 14:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767322;
	bh=IlxsqQ+6XefBJ0UbQOjSXCh2L3i8u1VWNxTNnjWxwMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLux0LQETpfNYuj4vYe0oAWU5tTW7mKL2dNkTVTZ3CWArFFm7lhxwIjPeyhut/sBc
	 IUpLzMEVHiHBBg0AwsVitIRN6ugi5x58XNfO6W7DEGTrI96563nZvHcVXLlhkL2qcA
	 TWwWQnWuEtmHHvocKGfSZ95989BMnMmrKR2oD85g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 439/590] erofs: get rid of erofs_{find,insert}_workgroup
Date: Wed,  5 Feb 2025 14:43:14 +0100
Message-ID: <20250205134512.062766463@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit b091e8ed24b7965953147a389bac1dc7c3e8a11c ]

Just fold them into the only two callers since
they are simple enough.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241021035323.3280682-1-hsiangkao@linux.alibaba.com
Stable-dep-of: db902986dee4 ("erofs: fix potential return value overflow of z_erofs_shrink_scan()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/internal.h |  5 +----
 fs/erofs/zdata.c    | 38 +++++++++++++++++++++++++---------
 fs/erofs/zutil.c    | 50 +--------------------------------------------
 3 files changed, 30 insertions(+), 63 deletions(-)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 77e785a6dfa7f..b9649e3b2dd56 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -453,10 +453,7 @@ void erofs_release_pages(struct page **pagepool);
 
 #ifdef CONFIG_EROFS_FS_ZIP
 void erofs_workgroup_put(struct erofs_workgroup *grp);
-struct erofs_workgroup *erofs_find_workgroup(struct super_block *sb,
-					     pgoff_t index);
-struct erofs_workgroup *erofs_insert_workgroup(struct super_block *sb,
-					       struct erofs_workgroup *grp);
+bool erofs_workgroup_get(struct erofs_workgroup *grp);
 void erofs_workgroup_free_rcu(struct erofs_workgroup *grp);
 void erofs_shrinker_register(struct super_block *sb);
 void erofs_shrinker_unregister(struct super_block *sb);
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 1a00f061798a3..8c6082fc86b29 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -714,9 +714,10 @@ static int z_erofs_register_pcluster(struct z_erofs_decompress_frontend *fe)
 {
 	struct erofs_map_blocks *map = &fe->map;
 	struct super_block *sb = fe->inode->i_sb;
+	struct erofs_sb_info *sbi = EROFS_SB(sb);
 	bool ztailpacking = map->m_flags & EROFS_MAP_META;
 	struct z_erofs_pcluster *pcl;
-	struct erofs_workgroup *grp;
+	struct erofs_workgroup *grp, *pre;
 	int err;
 
 	if (!(map->m_flags & EROFS_MAP_ENCODED) ||
@@ -752,15 +753,23 @@ static int z_erofs_register_pcluster(struct z_erofs_decompress_frontend *fe)
 		pcl->obj.index = 0;	/* which indicates ztailpacking */
 	} else {
 		pcl->obj.index = erofs_blknr(sb, map->m_pa);
-
-		grp = erofs_insert_workgroup(fe->inode->i_sb, &pcl->obj);
-		if (IS_ERR(grp)) {
-			err = PTR_ERR(grp);
-			goto err_out;
+		while (1) {
+			xa_lock(&sbi->managed_pslots);
+			pre = __xa_cmpxchg(&sbi->managed_pslots, grp->index,
+					   NULL, grp, GFP_KERNEL);
+			if (!pre || xa_is_err(pre) || erofs_workgroup_get(pre)) {
+				xa_unlock(&sbi->managed_pslots);
+				break;
+			}
+			/* try to legitimize the current in-tree one */
+			xa_unlock(&sbi->managed_pslots);
+			cond_resched();
 		}
-
-		if (grp != &pcl->obj) {
-			fe->pcl = container_of(grp,
+		if (xa_is_err(pre)) {
+			err = xa_err(pre);
+			goto err_out;
+		} else if (pre) {
+			fe->pcl = container_of(pre,
 					struct z_erofs_pcluster, obj);
 			err = -EEXIST;
 			goto err_out;
@@ -789,7 +798,16 @@ static int z_erofs_pcluster_begin(struct z_erofs_decompress_frontend *fe)
 	DBG_BUGON(fe->owned_head == Z_EROFS_PCLUSTER_NIL);
 
 	if (!(map->m_flags & EROFS_MAP_META)) {
-		grp = erofs_find_workgroup(sb, blknr);
+		while (1) {
+			rcu_read_lock();
+			grp = xa_load(&EROFS_SB(sb)->managed_pslots, blknr);
+			if (!grp || erofs_workgroup_get(grp)) {
+				DBG_BUGON(grp && blknr != grp->index);
+				rcu_read_unlock();
+				break;
+			}
+			rcu_read_unlock();
+		}
 	} else if ((map->m_pa & ~PAGE_MASK) + map->m_plen > PAGE_SIZE) {
 		DBG_BUGON(1);
 		return -EFSCORRUPTED;
diff --git a/fs/erofs/zutil.c b/fs/erofs/zutil.c
index 37afe20248409..218b0249a4822 100644
--- a/fs/erofs/zutil.c
+++ b/fs/erofs/zutil.c
@@ -214,7 +214,7 @@ void erofs_release_pages(struct page **pagepool)
 	}
 }
 
-static bool erofs_workgroup_get(struct erofs_workgroup *grp)
+bool erofs_workgroup_get(struct erofs_workgroup *grp)
 {
 	if (lockref_get_not_zero(&grp->lockref))
 		return true;
@@ -231,54 +231,6 @@ static bool erofs_workgroup_get(struct erofs_workgroup *grp)
 	return true;
 }
 
-struct erofs_workgroup *erofs_find_workgroup(struct super_block *sb,
-					     pgoff_t index)
-{
-	struct erofs_sb_info *sbi = EROFS_SB(sb);
-	struct erofs_workgroup *grp;
-
-repeat:
-	rcu_read_lock();
-	grp = xa_load(&sbi->managed_pslots, index);
-	if (grp) {
-		if (!erofs_workgroup_get(grp)) {
-			/* prefer to relax rcu read side */
-			rcu_read_unlock();
-			goto repeat;
-		}
-
-		DBG_BUGON(index != grp->index);
-	}
-	rcu_read_unlock();
-	return grp;
-}
-
-struct erofs_workgroup *erofs_insert_workgroup(struct super_block *sb,
-					       struct erofs_workgroup *grp)
-{
-	struct erofs_sb_info *const sbi = EROFS_SB(sb);
-	struct erofs_workgroup *pre;
-
-	DBG_BUGON(grp->lockref.count < 1);
-repeat:
-	xa_lock(&sbi->managed_pslots);
-	pre = __xa_cmpxchg(&sbi->managed_pslots, grp->index,
-			   NULL, grp, GFP_KERNEL);
-	if (pre) {
-		if (xa_is_err(pre)) {
-			pre = ERR_PTR(xa_err(pre));
-		} else if (!erofs_workgroup_get(pre)) {
-			/* try to legitimize the current in-tree one */
-			xa_unlock(&sbi->managed_pslots);
-			cond_resched();
-			goto repeat;
-		}
-		grp = pre;
-	}
-	xa_unlock(&sbi->managed_pslots);
-	return grp;
-}
-
 static void  __erofs_workgroup_free(struct erofs_workgroup *grp)
 {
 	atomic_long_dec(&erofs_global_shrink_cnt);
-- 
2.39.5




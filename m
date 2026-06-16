Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEAA46AEC5;
	Tue, 16 Jun 2026 16:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626578; cv=none; b=WXkP3dZJDUTULpO68YeAxD9x/fKqIQcTGxAzXTyKyMVPhlndNK7roSoIXyMokElnV6zhwndGXh0PNH0FnAhOcSK9qE1pejX6/sCFkNBvFLzrg22UC8/pVxcwsJ3t547orFkm5pyjj8Sb3vDVlaHo8tVX6XoBhIKxMN97XJQxYDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626578; c=relaxed/simple;
	bh=FJyD4ZhEyoPmkQg/X1ux0qg9iQTKAW7h0j1Ss6xH3+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/9njpdYvVrpWDuWjR+rlpICRf/CRLbX/jUpqbjaZDEZZl4QiyznAfrWnmOSvqSdzaocy80jO0VKgNWZyBdcgrRzlqVBUzc6SyNEx6a1tg7AVyKrmqy1PKJQJIZpqB/Xn2u1KAD5ZmTjVzU8e2Lsw51O66VndT1JDjJCwN8P/CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMRpA9h2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMRpA9h2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3591F000E9;
	Tue, 16 Jun 2026 16:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626576;
	bh=0bKSuI9FLAhdnVHltZxb3cw3x8EQaFRuHekW7evcjpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMRpA9h2Hjlx4KhWAC8SbjG+H4iMtVr5L57mOnmlrlvL0oApHsnnBlnI1DSNQ6rRn
	 1Utpvh60SUhXMj9bo9WZmnAgRKJzPo7r5MxDgob78BZoG0eL96mTqg9fuM2nBEwXP2
	 zQDhlqD8+471m1zNDZYcVKybYWlvICtwsQwhk/cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunhai Guo <guochunhai@vivo.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/261] erofs: add sysfs node to drop internal caches
Date: Tue, 16 Jun 2026 20:27:32 +0530
Message-ID: <20260616145045.681277847@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Chunhai Guo <guochunhai@vivo.com>

[ Upstream commit db80b98305f73ca83891e4228ead5f0324118b00 ]

Add a sysfs node to drop compression-related caches, currently used to
drop in-memory pclusters and cached compressed folios.

Signed-off-by: Chunhai Guo <guochunhai@vivo.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241113041148.749129-1-guochunhai@vivo.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Stable-dep-of: 1aee05e814d2 ("erofs: fix use-after-free on sbi->sync_decompress")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-erofs | 11 +++++++++++
 fs/erofs/internal.h                      |  2 ++
 fs/erofs/sysfs.c                         | 17 +++++++++++++++++
 fs/erofs/zdata.c                         |  1 -
 4 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-erofs b/Documentation/ABI/testing/sysfs-fs-erofs
index 284224d1b56fe1..b134146d735bc5 100644
--- a/Documentation/ABI/testing/sysfs-fs-erofs
+++ b/Documentation/ABI/testing/sysfs-fs-erofs
@@ -16,3 +16,14 @@ Description:	Control strategy of sync decompression:
 		  readahead on atomic contexts only.
 		- 1 (force on): enable for readpage and readahead.
 		- 2 (force off): disable for all situations.
+
+What:		/sys/fs/erofs/<disk>/drop_caches
+Date:		November 2024
+Contact:	"Guo Chunhai" <guochunhai@vivo.com>
+Description:	Writing to this will drop compression-related caches,
+		currently used to drop in-memory pclusters and cached
+		compressed folios:
+
+		- 1 : invalidate cached compressed folios
+		- 2 : drop in-memory pclusters
+		- 3 : drop in-memory pclusters and cached compressed folios
diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 1c003412677ef6..24e01d9135c60d 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -443,6 +443,8 @@ static inline void erofs_pagepool_add(struct page **pagepool, struct page *page)
 void erofs_release_pages(struct page **pagepool);
 
 #ifdef CONFIG_EROFS_FS_ZIP
+#define MNGD_MAPPING(sbi)	((sbi)->managed_cache->i_mapping)
+
 extern atomic_long_t erofs_global_shrink_cnt;
 void erofs_shrinker_register(struct super_block *sb);
 void erofs_shrinker_unregister(struct super_block *sb);
diff --git a/fs/erofs/sysfs.c b/fs/erofs/sysfs.c
index 63cffd0fd26195..19d586273b7091 100644
--- a/fs/erofs/sysfs.c
+++ b/fs/erofs/sysfs.c
@@ -10,6 +10,7 @@
 
 enum {
 	attr_feature,
+	attr_drop_caches,
 	attr_pointer_ui,
 	attr_pointer_bool,
 };
@@ -57,11 +58,13 @@ static struct erofs_attr erofs_attr_##_name = {			\
 
 #ifdef CONFIG_EROFS_FS_ZIP
 EROFS_ATTR_RW_UI(sync_decompress, erofs_mount_opts);
+EROFS_ATTR_FUNC(drop_caches, 0200);
 #endif
 
 static struct attribute *erofs_attrs[] = {
 #ifdef CONFIG_EROFS_FS_ZIP
 	ATTR_LIST(sync_decompress),
+	ATTR_LIST(drop_caches),
 #endif
 	NULL,
 };
@@ -163,6 +166,20 @@ static ssize_t erofs_attr_store(struct kobject *kobj, struct attribute *attr,
 			return -EINVAL;
 		*(bool *)ptr = !!t;
 		return len;
+#ifdef CONFIG_EROFS_FS_ZIP
+	case attr_drop_caches:
+		ret = kstrtoul(skip_spaces(buf), 0, &t);
+		if (ret)
+			return ret;
+		if (t < 1 || t > 3)
+			return -EINVAL;
+
+		if (t & 2)
+			z_erofs_shrink_scan(sbi, ~0UL);
+		if (t & 1)
+			invalidate_mapping_pages(MNGD_MAPPING(sbi), 0, -1);
+		return len;
+#endif
 	}
 	return 0;
 }
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index a81b6e6aee59ad..8192eb9b23bc7b 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -109,7 +109,6 @@ static inline unsigned int z_erofs_pclusterpages(struct z_erofs_pcluster *pcl)
 	return PAGE_ALIGN(pcl->pclustersize) >> PAGE_SHIFT;
 }
 
-#define MNGD_MAPPING(sbi)	((sbi)->managed_cache->i_mapping)
 static bool erofs_folio_is_managed(struct erofs_sb_info *sbi, struct folio *fo)
 {
 	return fo->mapping == MNGD_MAPPING(sbi);
-- 
2.53.0




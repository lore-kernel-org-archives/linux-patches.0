Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6668209693;
	Thu, 12 Dec 2024 15:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017168; cv=none; b=VqnrcO7hkl9L3rVO7974qcmnAJwXltk8c4/Xw7cIMmK3ChduZgFLJezfXMqPflXnYuDHA2n0TkmbEl17cdUVUdISYugj7m9AS65j2PjerbS2Lq3v24ddSTx3UZc1G89G1YhPWeL8EaZNGUDDMsuthv+2DyIW7F6VJPMWIenou7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017168; c=relaxed/simple;
	bh=r4RlD3Q0MxYPC54U00LLU92luqU0lajDKst7Dh6WsQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vunq+ZKREVOKAp4lfJdr1as8svuZT7Eh/ARlr5oAJlQek5rkImm/hXOgXIXDAVwUvn5nw5H4daFVsGCf0FImSdRc6S981jrww1pX+FzC/LuuAwjYauqLF9R+jh+fdvqGBbSqqhjxEbHzg0Jvxd77CBGXbmse+vkf06ntXHD7gmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FS/EHH7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FS/EHH7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54080C4CECE;
	Thu, 12 Dec 2024 15:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017167;
	bh=r4RlD3Q0MxYPC54U00LLU92luqU0lajDKst7Dh6WsQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FS/EHH7zlFWhSYFCNqg1r6Sg1RtUbp9A6nzYVHPrMVmdqniaQSL9W8qFN1W2O6znQ
	 nsRNoxZDAbmYOyvAFFyQSNBGjBABTeKKRWu7xgjPhjK7JhilmqJdWvhA1c2ExdDwC7
	 qHzstpoVvG6WU9iIkNhYFdNwQ4DdfOEnhoVx1DGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiuhong Wang <xiuhong.wang@unisoc.com>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 402/466] f2fs: add a sysfs node to limit max read extent count per-inode
Date: Thu, 12 Dec 2024 15:59:31 +0100
Message-ID: <20241212144322.637902573@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 009a8241a8e5a14ea2dd0b8db42dbf283527dd44 ]

Quoted:
"at this time, there are still 1086911 extent nodes in this zombie
extent tree that need to be cleaned up.

crash_arm64_sprd_v8.0.3++> extent_tree.node_cnt ffffff80896cc500
  node_cnt = {
    counter = 1086911
  },
"

As reported by Xiuhong, there will be a huge number of extent nodes
in extent tree, it may potentially cause:
- slab memory fragments
- extreme long time shrink on extent tree
- low mapping efficiency

Let's add a sysfs node to limit max read extent count for each inode,
by default, value of this threshold is 10240, it can be updated
according to user's requirement.

Reported-by: Xiuhong Wang <xiuhong.wang@unisoc.com>
Closes: https://lore.kernel.org/linux-f2fs-devel/20241112110627.1314632-1-xiuhong.wang@unisoc.com/
Signed-off-by: Xiuhong Wang <xiuhong.wang@unisoc.com>
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-fs-f2fs |  6 ++++++
 fs/f2fs/extent_cache.c                  |  5 ++++-
 fs/f2fs/f2fs.h                          |  4 ++++
 fs/f2fs/sysfs.c                         | 10 ++++++++++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/testing/sysfs-fs-f2fs
index 513296bb6f297..3e1630c70d8ae 100644
--- a/Documentation/ABI/testing/sysfs-fs-f2fs
+++ b/Documentation/ABI/testing/sysfs-fs-f2fs
@@ -822,3 +822,9 @@ Description:	It controls the valid block ratio threshold not to trigger excessiv
 		for zoned deivces. The initial value of it is 95(%). F2FS will stop the
 		background GC thread from intiating GC for sections having valid blocks
 		exceeding the ratio.
+
+What:		/sys/fs/f2fs/<disk>/max_read_extent_count
+Date:		November 2024
+Contact:	"Chao Yu" <chao@kernel.org>
+Description:	It controls max read extent count for per-inode, the value of threshold
+		is 10240 by default.
diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index 368d9cbdea743..fb09c8e9bc573 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -674,7 +674,9 @@ static void __update_extent_tree_range(struct inode *inode,
 		}
 
 		if (end < org_end && (type != EX_READ ||
-				org_end - end >= F2FS_MIN_EXTENT_LEN)) {
+			(org_end - end >= F2FS_MIN_EXTENT_LEN &&
+			atomic_read(&et->node_cnt) <
+					sbi->max_read_extent_count))) {
 			if (parts) {
 				__set_extent_info(&ei,
 					end, org_end - end,
@@ -1169,6 +1171,7 @@ void f2fs_init_extent_cache_info(struct f2fs_sb_info *sbi)
 	sbi->hot_data_age_threshold = DEF_HOT_DATA_AGE_THRESHOLD;
 	sbi->warm_data_age_threshold = DEF_WARM_DATA_AGE_THRESHOLD;
 	sbi->last_age_weight = LAST_AGE_WEIGHT;
+	sbi->max_read_extent_count = DEF_MAX_READ_EXTENT_COUNT;
 }
 
 int __init f2fs_create_extent_cache(void)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 93a5e1c24e566..cec3dd205b3df 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -634,6 +634,9 @@ enum {
 #define DEF_HOT_DATA_AGE_THRESHOLD	262144
 #define DEF_WARM_DATA_AGE_THRESHOLD	2621440
 
+/* default max read extent count per inode */
+#define DEF_MAX_READ_EXTENT_COUNT	10240
+
 /* extent cache type */
 enum extent_type {
 	EX_READ,
@@ -1619,6 +1622,7 @@ struct f2fs_sb_info {
 	/* for extent tree cache */
 	struct extent_tree_info extent_tree[NR_EXTENT_CACHES];
 	atomic64_t allocated_data_blocks;	/* for block age extent_cache */
+	unsigned int max_read_extent_count;	/* max read extent count per inode */
 
 	/* The threshold used for hot and warm data seperation*/
 	unsigned int hot_data_age_threshold;
diff --git a/fs/f2fs/sysfs.c b/fs/f2fs/sysfs.c
index c56e8c8739352..d9a44f03e558b 100644
--- a/fs/f2fs/sysfs.c
+++ b/fs/f2fs/sysfs.c
@@ -789,6 +789,13 @@ static ssize_t __sbi_store(struct f2fs_attr *a,
 		return count;
 	}
 
+	if (!strcmp(a->attr.name, "max_read_extent_count")) {
+		if (t > UINT_MAX)
+			return -EINVAL;
+		*ui = (unsigned int)t;
+		return count;
+	}
+
 	if (!strcmp(a->attr.name, "ipu_policy")) {
 		if (t >= BIT(F2FS_IPU_MAX))
 			return -EINVAL;
@@ -1054,6 +1061,8 @@ F2FS_SBI_GENERAL_RW_ATTR(revoked_atomic_block);
 F2FS_SBI_GENERAL_RW_ATTR(hot_data_age_threshold);
 F2FS_SBI_GENERAL_RW_ATTR(warm_data_age_threshold);
 F2FS_SBI_GENERAL_RW_ATTR(last_age_weight);
+/* read extent cache */
+F2FS_SBI_GENERAL_RW_ATTR(max_read_extent_count);
 #ifdef CONFIG_BLK_DEV_ZONED
 F2FS_SBI_GENERAL_RO_ATTR(unusable_blocks_per_sec);
 F2FS_SBI_GENERAL_RW_ATTR(blkzone_alloc_policy);
@@ -1244,6 +1253,7 @@ static struct attribute *f2fs_attrs[] = {
 	ATTR_LIST(hot_data_age_threshold),
 	ATTR_LIST(warm_data_age_threshold),
 	ATTR_LIST(last_age_weight),
+	ATTR_LIST(max_read_extent_count),
 	NULL,
 };
 ATTRIBUTE_GROUPS(f2fs);
-- 
2.43.0




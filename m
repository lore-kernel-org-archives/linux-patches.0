Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69412ECA
	for <patches@lists.linux.dev>; Sat, 28 Oct 2023 06:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.53])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4SHVJz0DJbz1L9Gr;
	Sat, 28 Oct 2023 14:40:19 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500021.china.huawei.com
 (7.185.36.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Sat, 28 Oct
 2023 14:43:14 +0800
From: Baokun Li <libaokun1@huawei.com>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <sashal@kernel.org>, <tytso@mit.edu>,
	<jack@suse.cz>, <ritesh.list@gmail.com>, <patches@lists.linux.dev>,
	<yangerkun@huawei.com>, <libaokun1@huawei.com>
Subject: [PATCH 5.15 1/3] ext4: add two helper functions extent_logical_end() and pa_logical_end()
Date: Sat, 28 Oct 2023 14:47:47 +0800
Message-ID: <20231028064749.833278-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected

commit 43bbddc067883d94de7a43d5756a295439fbe37d upstream.

When we use lstart + len to calculate the end of free extent or prealloc
space, it may exceed the maximum value of 4294967295(0xffffffff) supported
by ext4_lblk_t and cause overflow, which may lead to various problems.

Therefore, we add two helper functions, extent_logical_end() and
pa_logical_end(), to limit the type of end to loff_t, and also convert
lstart to loff_t for calculation to avoid overflow.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20230724121059.11834-2-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Conflicts:
	fs/ext4/mballoc.c

Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 fs/ext4/mballoc.c |  7 +++----
 fs/ext4/mballoc.h | 14 ++++++++++++++
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index e5b81d8be232..33a715532c03 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4079,7 +4079,7 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 
 	/* first, let's learn actual file size
 	 * given current request is allocated */
-	size = ac->ac_o_ex.fe_logical + EXT4_C2B(sbi, ac->ac_o_ex.fe_len);
+	size = extent_logical_end(sbi, &ac->ac_o_ex);
 	size = size << bsbits;
 	if (size < i_size_read(ac->ac_inode))
 		size = i_size_read(ac->ac_inode);
@@ -4419,8 +4419,7 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 		/* all fields in this condition don't change,
 		 * so we can skip locking for them */
 		if (ac->ac_o_ex.fe_logical < pa->pa_lstart ||
-		    ac->ac_o_ex.fe_logical >= (pa->pa_lstart +
-					       EXT4_C2B(sbi, pa->pa_len)))
+		    ac->ac_o_ex.fe_logical >= pa_logical_end(sbi, pa))
 			continue;
 
 		/* non-extent files can't have physical blocks past 2^32 */
@@ -5241,7 +5240,7 @@ static void ext4_mb_group_or_file(struct ext4_allocation_context *ac)
 
 	group_pa_eligible = sbi->s_mb_group_prealloc > 0;
 	inode_pa_eligible = true;
-	size = ac->ac_o_ex.fe_logical + EXT4_C2B(sbi, ac->ac_o_ex.fe_len);
+	size = extent_logical_end(sbi, &ac->ac_o_ex);
 	isize = (i_size_read(ac->ac_inode) + ac->ac_sb->s_blocksize - 1)
 		>> bsbits;
 
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 39da92ceabf8..bf048cbf3986 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -219,6 +219,20 @@ static inline ext4_fsblk_t ext4_grp_offs_to_block(struct super_block *sb,
 		(fex->fe_start << EXT4_SB(sb)->s_cluster_bits);
 }
 
+static inline loff_t extent_logical_end(struct ext4_sb_info *sbi,
+					struct ext4_free_extent *fex)
+{
+	/* Use loff_t to avoid end exceeding ext4_lblk_t max. */
+	return (loff_t)fex->fe_logical + EXT4_C2B(sbi, fex->fe_len);
+}
+
+static inline loff_t pa_logical_end(struct ext4_sb_info *sbi,
+				    struct ext4_prealloc_space *pa)
+{
+	/* Use loff_t to avoid end exceeding ext4_lblk_t max. */
+	return (loff_t)pa->pa_lstart + EXT4_C2B(sbi, pa->pa_len);
+}
+
 typedef int (*ext4_mballoc_query_range_fn)(
 	struct super_block		*sb,
 	ext4_group_t			agno,
-- 
2.31.1


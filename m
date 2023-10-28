Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4699810EA
	for <patches@lists.linux.dev>; Sat, 28 Oct 2023 06:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.53])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SHVPH3j5QzpWRL;
	Sat, 28 Oct 2023 14:44:03 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500021.china.huawei.com
 (7.185.36.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Sat, 28 Oct
 2023 14:48:58 +0800
From: Baokun Li <libaokun1@huawei.com>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <sashal@kernel.org>, <tytso@mit.edu>,
	<jack@suse.cz>, <ritesh.list@gmail.com>, <patches@lists.linux.dev>,
	<yangerkun@huawei.com>, <libaokun1@huawei.com>
Subject: [PATCH 5.4 3/3] ext4: avoid overlapping preallocations due to overflow
Date: Sat, 28 Oct 2023 14:53:31 +0800
Message-ID: <20231028065331.948339-3-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20231028065331.948339-1-libaokun1@huawei.com>
References: <20231028065331.948339-1-libaokun1@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected

commit bedc5d34632c21b5adb8ca7143d4c1f794507e4c upstream.

Let's say we want to allocate 2 blocks starting from 4294966386, after
predicting the file size, start is aligned to 4294965248, len is changed
to 2048, then end = start + size = 0x100000000. Since end is of
type ext4_lblk_t, i.e. uint, end is truncated to 0.

This causes (pa->pa_lstart >= end) to always hold when checking if the
current extent to be allocated crosses already preallocated blocks, so the
resulting ac_g_ex may cross already preallocated blocks. Hence we convert
the end type to loff_t and use pa_logical_end() to avoid overflow.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20230724121059.11834-4-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Conflicts:
	fs/ext4/mballoc.c

Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 fs/ext4/mballoc.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 901302735f1c..a0ec645bd7ed 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3094,8 +3094,7 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	struct ext4_super_block *es = sbi->s_es;
 	int bsbits, max;
-	ext4_lblk_t end;
-	loff_t size, start_off;
+	loff_t size, start_off, end;
 	loff_t orig_size __maybe_unused;
 	ext4_lblk_t start;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
@@ -3203,7 +3202,7 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	/* check we don't cross already preallocated blocks */
 	rcu_read_lock();
 	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
-		ext4_lblk_t pa_end;
+		loff_t pa_end;
 
 		if (pa->pa_deleted)
 			continue;
@@ -3213,8 +3212,7 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 			continue;
 		}
 
-		pa_end = pa->pa_lstart + EXT4_C2B(EXT4_SB(ac->ac_sb),
-						  pa->pa_len);
+		pa_end = pa_logical_end(EXT4_SB(ac->ac_sb), pa);
 
 		/* PA must not overlap original request */
 		BUG_ON(!(ac->ac_o_ex.fe_logical >= pa_end ||
@@ -3243,12 +3241,11 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	/* XXX: extra loop to check we really don't overlap preallocations */
 	rcu_read_lock();
 	list_for_each_entry_rcu(pa, &ei->i_prealloc_list, pa_inode_list) {
-		ext4_lblk_t pa_end;
+		loff_t pa_end;
 
 		spin_lock(&pa->pa_lock);
 		if (pa->pa_deleted == 0) {
-			pa_end = pa->pa_lstart + EXT4_C2B(EXT4_SB(ac->ac_sb),
-							  pa->pa_len);
+			pa_end = pa_logical_end(EXT4_SB(ac->ac_sb), pa);
 			BUG_ON(!(start >= pa_end || end <= pa->pa_lstart));
 		}
 		spin_unlock(&pa->pa_lock);
-- 
2.31.1


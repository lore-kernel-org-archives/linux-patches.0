Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92D81F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F827C433CA;
	Tue,  1 Aug 2023 09:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882919;
	bh=K+c6ZgIpMdNOstUWNKAlRjYro6ySQaDe8wh9ZpH11wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDRYw/BjCxrcclSGe3X7guucl8srES3RBFp04xfp5I39rR6aFWQmnDpNrs7vSyRLJ
	 V6U/yXr24bwxdzJ4aqtceEGdk0QlDPzwMEFVvCy7kGZO4AnbV+a0Ck7YK5btdqFuWx
	 CUEGL7zyBHnH58QAGy46+S1Ws0JwtOHJ08ZoeBCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 049/239] ext4: add EXT4_MB_HINT_GOAL_ONLY test in ext4_mb_use_preallocated
Date: Tue,  1 Aug 2023 11:18:33 +0200
Message-ID: <20230801091927.325093666@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 1eff590489a213a213c57d96b86f48b32cdf8c3a ]

ext4_mb_use_preallocated will ignore the demand to alloc goal blocks,
although the EXT4_MB_HINT_GOAL_ONLY is requested.
For group pa, ext4_mb_group_or_file will not set EXT4_MB_HINT_GROUP_ALLOC
if EXT4_MB_HINT_GOAL_ONLY is set. So we will not alloc goal blocks from
group pa if EXT4_MB_HINT_GOAL_ONLY is set.
For inode pa, ext4_mb_pa_goal_check is added to check if free extent in
found inode pa meets goal blocks when EXT4_MB_HINT_GOAL_ONLY is set.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Suggested-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/r/20230603150327.3596033-6-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 9d3de7ee192a ("ext4: fix rbtree traversal bug in ext4_mb_use_preallocated")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index fd4d12c58c3b4..1f4d00a4308dc 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4528,6 +4528,37 @@ ext4_mb_check_group_pa(ext4_fsblk_t goal_block,
 	return pa;
 }
 
+/*
+ * check if found pa meets EXT4_MB_HINT_GOAL_ONLY
+ */
+static bool
+ext4_mb_pa_goal_check(struct ext4_allocation_context *ac,
+		      struct ext4_prealloc_space *pa)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
+	ext4_fsblk_t start;
+
+	if (likely(!(ac->ac_flags & EXT4_MB_HINT_GOAL_ONLY)))
+		return true;
+
+	/*
+	 * If EXT4_MB_HINT_GOAL_ONLY is set, ac_g_ex will not be adjusted
+	 * in ext4_mb_normalize_request and will keep same with ac_o_ex
+	 * from ext4_mb_initialize_context. Choose ac_g_ex here to keep
+	 * consistent with ext4_mb_find_by_goal.
+	 */
+	start = pa->pa_pstart +
+		(ac->ac_g_ex.fe_logical - pa->pa_lstart);
+	if (ext4_grp_offs_to_block(ac->ac_sb, &ac->ac_g_ex) != start)
+		return false;
+
+	if (ac->ac_g_ex.fe_len > pa->pa_len -
+	    EXT4_B2C(sbi, ac->ac_g_ex.fe_logical - pa->pa_lstart))
+		return false;
+
+	return true;
+}
+
 /*
  * search goal blocks in preallocated space
  */
@@ -4578,7 +4609,8 @@ ext4_mb_use_preallocated(struct ext4_allocation_context *ac)
 
 		/* found preallocated blocks, use them */
 		spin_lock(&tmp_pa->pa_lock);
-		if (tmp_pa->pa_deleted == 0 && tmp_pa->pa_free) {
+		if (tmp_pa->pa_deleted == 0 && tmp_pa->pa_free &&
+		    likely(ext4_mb_pa_goal_check(ac, tmp_pa))) {
 			atomic_inc(&tmp_pa->pa_count);
 			ext4_mb_use_inode_pa(ac, tmp_pa);
 			spin_unlock(&tmp_pa->pa_lock);
-- 
2.39.2




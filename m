Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F79918655
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF303C433C9;
	Wed, 20 Sep 2023 11:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210516;
	bh=5/tUgDrIE/OQZXPMYtVAdKkyb3+WTteRR82p0thjGII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G30jk9vwO9Wf3TEG1uKNSrFLqq5pQCuZPAiSzDc7xtIxRcGeCVjT42KA1WFiyW6pr
	 osCKpgFedIEzBWO8O4hhKUFlCZ/QDQLYsmaoj4yQs20K++5hifG6EDLxHPqn4vd6um
	 +l7PXGoJURiDd6DZXwv13ZSdeusq+td/gGueXX0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 098/211] ext4: avoid overlapping preallocations due to overflow
Date: Wed, 20 Sep 2023 13:29:02 +0200
Message-ID: <20230920112848.845873803@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit bedc5d34632c21b5adb8ca7143d4c1f794507e4c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 627c813cf0759..5c3055a32e57a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4223,12 +4223,13 @@ ext4_mb_pa_rb_next_iter(ext4_lblk_t new_start, ext4_lblk_t cur_start, struct rb_
 
 static inline void
 ext4_mb_pa_assert_overlap(struct ext4_allocation_context *ac,
-			  ext4_lblk_t start, ext4_lblk_t end)
+			  ext4_lblk_t start, loff_t end)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
 	struct ext4_prealloc_space *tmp_pa;
-	ext4_lblk_t tmp_pa_start, tmp_pa_end;
+	ext4_lblk_t tmp_pa_start;
+	loff_t tmp_pa_end;
 	struct rb_node *iter;
 
 	read_lock(&ei->i_prealloc_lock);
@@ -4237,7 +4238,7 @@ ext4_mb_pa_assert_overlap(struct ext4_allocation_context *ac,
 		tmp_pa = rb_entry(iter, struct ext4_prealloc_space,
 				  pa_node.inode_node);
 		tmp_pa_start = tmp_pa->pa_lstart;
-		tmp_pa_end = tmp_pa->pa_lstart + EXT4_C2B(sbi, tmp_pa->pa_len);
+		tmp_pa_end = pa_logical_end(sbi, tmp_pa);
 
 		spin_lock(&tmp_pa->pa_lock);
 		if (tmp_pa->pa_deleted == 0)
@@ -4259,14 +4260,14 @@ ext4_mb_pa_assert_overlap(struct ext4_allocation_context *ac,
  */
 static inline void
 ext4_mb_pa_adjust_overlap(struct ext4_allocation_context *ac,
-			  ext4_lblk_t *start, ext4_lblk_t *end)
+			  ext4_lblk_t *start, loff_t *end)
 {
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	struct ext4_prealloc_space *tmp_pa = NULL, *left_pa = NULL, *right_pa = NULL;
 	struct rb_node *iter;
-	ext4_lblk_t new_start, new_end;
-	ext4_lblk_t tmp_pa_start, tmp_pa_end, left_pa_end = -1, right_pa_start = -1;
+	ext4_lblk_t new_start, tmp_pa_start, right_pa_start = -1;
+	loff_t new_end, tmp_pa_end, left_pa_end = -1;
 
 	new_start = *start;
 	new_end = *end;
@@ -4285,7 +4286,7 @@ ext4_mb_pa_adjust_overlap(struct ext4_allocation_context *ac,
 		tmp_pa = rb_entry(iter, struct ext4_prealloc_space,
 				  pa_node.inode_node);
 		tmp_pa_start = tmp_pa->pa_lstart;
-		tmp_pa_end = tmp_pa->pa_lstart + EXT4_C2B(sbi, tmp_pa->pa_len);
+		tmp_pa_end = pa_logical_end(sbi, tmp_pa);
 
 		/* PA must not overlap original request */
 		spin_lock(&tmp_pa->pa_lock);
@@ -4365,8 +4366,7 @@ ext4_mb_pa_adjust_overlap(struct ext4_allocation_context *ac,
 	}
 
 	if (left_pa) {
-		left_pa_end =
-			left_pa->pa_lstart + EXT4_C2B(sbi, left_pa->pa_len);
+		left_pa_end = pa_logical_end(sbi, left_pa);
 		BUG_ON(left_pa_end > ac->ac_o_ex.fe_logical);
 	}
 
@@ -4405,8 +4405,7 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
 	struct ext4_super_block *es = sbi->s_es;
 	int bsbits, max;
-	ext4_lblk_t end;
-	loff_t size, start_off;
+	loff_t size, start_off, end;
 	loff_t orig_size __maybe_unused;
 	ext4_lblk_t start;
 
-- 
2.40.1




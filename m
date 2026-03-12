Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531B7317142;
	Thu, 12 Mar 2026 20:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346585; cv=none; b=uwc044ACVMABZYcWrTd5+yJypkPr7FRWQdQJRpkua0zXUHz4tpPvqYfdUMjYSkh9JIWDd61kMIkkn71CYo+pbsWA0WbYVfKVVFsTgxaeHeXF0TpesQoUPAEFnYEmqHWdgSgA+vuCv4zDHICO9cpInJs/DjfLasnlyk9LzWXChPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346585; c=relaxed/simple;
	bh=jFqFsv2tj7vAcToUU4DBKFAuWR8eTAnOiEdHnI/Bxec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jk4EslloMKuMTqKWmtu3geoHPOjcWVL+F+HHLv9JjWzuc140aLY4FdB5yKewv0nOatc5MejZUOlcIowXdVAISYkuoxmWfWHXeGOB9Ft4bARI2tprrZ/yqAmBFqvPPt7kS/KVUvqfNw9gOM/GPq6f6NOqgXQTNgrxx75D1a1J0nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Js6Kd1jc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Js6Kd1jc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3224DC4CEF7;
	Thu, 12 Mar 2026 20:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346584;
	bh=jFqFsv2tj7vAcToUU4DBKFAuWR8eTAnOiEdHnI/Bxec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Js6Kd1jc/R7DS5iaBV1pE7PFfaGQarU5JpdKrUMZSfEuROjZJj/n/fdoDnKv/EUrU
	 ksVjOENST7+RE73cF3XRmQkxrMZTNIIqgXVD9UkKk1nqQsOXsmbKD5Jq0akPP1mDiA
	 3QIFpaifUIaeXWaaJFWVgCp9dPN9DhVdD19mT0hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/265] ext4: factor out ext4_mb_scan_group()
Date: Thu, 12 Mar 2026 21:07:43 +0100
Message-ID: <20260312201020.960916047@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 9c08e42db9056d423dcef5e7998c73182180ff83 ]

Extract ext4_mb_scan_group() to make the code clearer and to
prepare for the later conversion of 'choose group' to 'scan groups'.
No functional changes.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20250714130327.1830534-15-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 4865c768b563 ("ext4: always allocate blocks only from groups inode can use")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 93 +++++++++++++++++++++++++----------------------
 fs/ext4/mballoc.h |  2 +
 2 files changed, 51 insertions(+), 44 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index af014b43d0b3f..03c0886da0571 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2861,12 +2861,56 @@ void ext4_mb_prefetch_fini(struct super_block *sb, ext4_group_t group,
 	}
 }
 
+static int ext4_mb_scan_group(struct ext4_allocation_context *ac,
+			      ext4_group_t group)
+{
+	int ret;
+	struct super_block *sb = ac->ac_sb;
+	enum criteria cr = ac->ac_criteria;
+
+	ext4_mb_might_prefetch(ac, group);
+
+	/* prevent unnecessary buddy loading. */
+	if (cr < CR_ANY_FREE && spin_is_locked(ext4_group_lock_ptr(sb, group)))
+		return 0;
+
+	/* This now checks without needing the buddy page */
+	ret = ext4_mb_good_group_nolock(ac, group, cr);
+	if (ret <= 0) {
+		if (!ac->ac_first_err)
+			ac->ac_first_err = ret;
+		return 0;
+	}
+
+	ret = ext4_mb_load_buddy(sb, group, ac->ac_e4b);
+	if (ret)
+		return ret;
+
+	/* skip busy group */
+	if (cr >= CR_ANY_FREE)
+		ext4_lock_group(sb, group);
+	else if (!ext4_try_lock_group(sb, group))
+		goto out_unload;
+
+	/* We need to check again after locking the block group. */
+	if (unlikely(!ext4_mb_good_group(ac, group, cr)))
+		goto out_unlock;
+
+	__ext4_mb_scan_group(ac);
+
+out_unlock:
+	ext4_unlock_group(sb, group);
+out_unload:
+	ext4_mb_unload_buddy(ac->ac_e4b);
+	return ret;
+}
+
 static noinline_for_stack int
 ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 {
 	ext4_group_t ngroups, group, i;
 	enum criteria new_cr, cr = CR_GOAL_LEN_FAST;
-	int err = 0, first_err = 0;
+	int err = 0;
 	struct ext4_sb_info *sbi;
 	struct super_block *sb;
 	struct ext4_buddy e4b;
@@ -2928,6 +2972,7 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 
 	ac->ac_e4b = &e4b;
 	ac->ac_prefetch_ios = 0;
+	ac->ac_first_err = 0;
 repeat:
 	for (; cr < EXT4_MB_NUM_CRS && ac->ac_status == AC_STATUS_CONTINUE; cr++) {
 		ac->ac_criteria = cr;
@@ -2942,7 +2987,6 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 
 		for (i = 0, new_cr = cr; i < ngroups; i++,
 		     ext4_mb_choose_next_group(ac, &new_cr, &group, ngroups)) {
-			int ret = 0;
 
 			cond_resched();
 			if (new_cr != cr) {
@@ -2950,49 +2994,10 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 				goto repeat;
 			}
 
-			ext4_mb_might_prefetch(ac, group);
-
-			/* prevent unnecessary buddy loading. */
-			if (cr < CR_ANY_FREE &&
-			    spin_is_locked(ext4_group_lock_ptr(sb, group)))
-				continue;
-
-			/* This now checks without needing the buddy page */
-			ret = ext4_mb_good_group_nolock(ac, group, cr);
-			if (ret <= 0) {
-				if (!first_err)
-					first_err = ret;
-				continue;
-			}
-
-			err = ext4_mb_load_buddy(sb, group, &e4b);
+			err = ext4_mb_scan_group(ac, group);
 			if (err)
 				goto out;
 
-			/* skip busy group */
-			if (cr >= CR_ANY_FREE) {
-				ext4_lock_group(sb, group);
-			} else if (!ext4_try_lock_group(sb, group)) {
-				ext4_mb_unload_buddy(&e4b);
-				continue;
-			}
-
-			/*
-			 * We need to check again after locking the
-			 * block group
-			 */
-			ret = ext4_mb_good_group(ac, group, cr);
-			if (ret == 0) {
-				ext4_unlock_group(sb, group);
-				ext4_mb_unload_buddy(&e4b);
-				continue;
-			}
-
-			__ext4_mb_scan_group(ac);
-
-			ext4_unlock_group(sb, group);
-			ext4_mb_unload_buddy(&e4b);
-
 			if (ac->ac_status != AC_STATUS_CONTINUE)
 				break;
 		}
@@ -3037,8 +3042,8 @@ ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 	if (sbi->s_mb_stats && ac->ac_status == AC_STATUS_FOUND)
 		atomic64_inc(&sbi->s_bal_cX_hits[ac->ac_criteria]);
 out:
-	if (!err && ac->ac_status != AC_STATUS_FOUND && first_err)
-		err = first_err;
+	if (!err && ac->ac_status != AC_STATUS_FOUND && ac->ac_first_err)
+		err = ac->ac_first_err;
 
 	mb_debug(sb, "Best len %d, origin len %d, ac_status %u, ac_flags 0x%x, cr %d ret %d\n",
 		 ac->ac_b_ex.fe_len, ac->ac_o_ex.fe_len, ac->ac_status,
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 9f66b1d5db67a..83886fc9521b7 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -196,6 +196,8 @@ struct ext4_allocation_context {
 	unsigned int ac_prefetch_ios;
 	unsigned int ac_prefetch_nr;
 
+	int ac_first_err;
+
 	__u32 ac_flags;		/* allocation hints */
 	__u32 ac_groups_linear_remaining;
 	__u16 ac_groups_scanned;
-- 
2.51.0




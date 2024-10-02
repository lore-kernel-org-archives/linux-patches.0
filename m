Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564771D0BBE;
	Wed,  2 Oct 2024 14:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879846; cv=none; b=HdDzTkfxYVVyRWRV7MkCkZ08o4m2LnQ32LxiFq+IHKozHJHa1ye6BK+9egDi7R1+jLClnv/Md9Gd1rL6Wqb4nsoxrWpTMKR7BPQYSgXdHfN4tPsz/K90rNV6sq1AykSuYQuOf5DfolMG5x7r06U7kCMqxEjgm68Md50GVrWQNk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879846; c=relaxed/simple;
	bh=8taHwNiWtetngj0ssQ7HJhaK9xk4xxThTv8EE6LVLb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AuUJYICPffV9/Yy16M/cqxmUYnnuOrmnLGu1XHYyv//qRzTcIppmI15VG8ubgOANUHqyPWfmhSxn5v2qBX9TUVVvRCmA1+HUTTwVwVy2SoiZLpvmrYVu04JUodDt8aB63gZcVcR+6cGUNE9zSy7wlTxWEp9eKtIFSlYJs0F4bfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aiELsACb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aiELsACb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E70C4CEC2;
	Wed,  2 Oct 2024 14:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879846;
	bh=8taHwNiWtetngj0ssQ7HJhaK9xk4xxThTv8EE6LVLb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aiELsACbV0GKKhyuWqYS6oFCHSMeHuAzvR+SjxPRT0gggazUh5QvJ9HwCn/iTyH18
	 KogOQ1z+h5fCkdjB/8ZeY/T+7ZZqZPzAiT8ANG+aln3ff2V28O0z70OaSi4XFLtKiM
	 HRyXtRmr8HTwMdxlq1xlnv5xME5ehIV8eP7S7wPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1ad8bac5af24d01e2cbd@syzkaller.appspotmail.com,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 231/538] ext4: check stripe size compatibility on remount as well
Date: Wed,  2 Oct 2024 14:57:50 +0200
Message-ID: <20241002125801.370454549@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

[ Upstream commit ee85e0938aa8f9846d21e4d302c3cf6a2a75110d ]

We disable stripe size in __ext4_fill_super if it is not a multiple of
the cluster ratio however this check is missed when trying to remount.
This can leave us with cases where stripe < cluster_ratio after
remount:set making EXT4_B2C(sbi->s_stripe) become 0 that can cause some
unforeseen bugs like divide by 0.

Fix that by adding the check in remount path as well.

Reported-by: syzbot+1ad8bac5af24d01e2cbd@syzkaller.appspotmail.com
Tested-by: syzbot+1ad8bac5af24d01e2cbd@syzkaller.appspotmail.com
Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Fixes: c3defd99d58c ("ext4: treat stripe in block unit")
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://patch.msgid.link/3a493bb503c3598e25dcfbed2936bb2dff3fece7.1725002410.git.ojaswin@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5baacb3058abd..46c4f75049791 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5205,6 +5205,18 @@ static int ext4_block_group_meta_init(struct super_block *sb, int silent)
 	return 0;
 }
 
+/*
+ * It's hard to get stripe aligned blocks if stripe is not aligned with
+ * cluster, just disable stripe and alert user to simplify code and avoid
+ * stripe aligned allocation which will rarely succeed.
+ */
+static bool ext4_is_stripe_incompatible(struct super_block *sb, unsigned long stripe)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	return (stripe > 0 && sbi->s_cluster_ratio > 1 &&
+		stripe % sbi->s_cluster_ratio != 0);
+}
+
 static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 {
 	struct ext4_super_block *es = NULL;
@@ -5312,13 +5324,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		goto failed_mount3;
 
 	sbi->s_stripe = ext4_get_stripe_size(sbi);
-	/*
-	 * It's hard to get stripe aligned blocks if stripe is not aligned with
-	 * cluster, just disable stripe and alert user to simpfy code and avoid
-	 * stripe aligned allocation which will rarely successes.
-	 */
-	if (sbi->s_stripe > 0 && sbi->s_cluster_ratio > 1 &&
-	    sbi->s_stripe % sbi->s_cluster_ratio != 0) {
+	if (ext4_is_stripe_incompatible(sb, sbi->s_stripe)) {
 		ext4_msg(sb, KERN_WARNING,
 			 "stripe (%lu) is not aligned with cluster size (%u), "
 			 "stripe is disabled",
@@ -6482,6 +6488,15 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
 
 	}
 
+	if ((ctx->spec & EXT4_SPEC_s_stripe) &&
+	    ext4_is_stripe_incompatible(sb, ctx->s_stripe)) {
+		ext4_msg(sb, KERN_WARNING,
+			 "stripe (%lu) is not aligned with cluster size (%u), "
+			 "stripe is disabled",
+			 ctx->s_stripe, sbi->s_cluster_ratio);
+		ctx->s_stripe = 0;
+	}
+
 	/*
 	 * Changing the DIOREAD_NOLOCK or DELALLOC mount options may cause
 	 * two calls to ext4_should_dioread_nolock() to return inconsistent
-- 
2.43.0




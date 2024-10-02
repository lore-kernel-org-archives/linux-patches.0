Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECCE1D0174;
	Wed,  2 Oct 2024 13:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876057; cv=none; b=Ka5kjO/YmhVXb1mt/4vo1nAGm6Rkc/A/XJXV9TsM5GLugxMbXHhWvT6W5PE3q4jAbeeh8DvcfvRL/DNx7NeG9oxW4iB7F6bOpodpSz5HY5kabI+Cd0MRlkeXfDupGbPrMz97QQR9NI65LxYv84Fka8uDouqt/HikmYyTstljOWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876057; c=relaxed/simple;
	bh=AF+FCp6GAh/eLUIjSwTf9FBL37PBMYLUryElwhqCHKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r60PBXzXaXhVYTrzildm/MhGQffaeEE8f72kYGZcXuV9+HcgPkjGqqe1BJKNt/3JDFWfNS8U2bBv8elMuz5T4YgVcipKp80siof/5b6lVwAo6CN6EuLZuq7NOdIqlcB+5AMq0vWMGSgv8i27oHAThFlgM9K8FG9gZry7IPLiSY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkc0bN5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkc0bN5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A479C4CED5;
	Wed,  2 Oct 2024 13:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876056;
	bh=AF+FCp6GAh/eLUIjSwTf9FBL37PBMYLUryElwhqCHKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkc0bN5WDDBRCb5nK0bg2qHp3za8INh0IrPfOE+bUttnO39W5bJart1a+3vxtdshk
	 FowZVSMgus3nnSgX2rWGAPWqB44Mzq/PNBZxke/ckQPF3nY7KVp6kodEAh6YcvFrir
	 rJbUvyttYizZnKFIdm5N0pKsjrJCJKX7xf4pvx5c=
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
Subject: [PATCH 6.11 313/695] ext4: check stripe size compatibility on remount as well
Date: Wed,  2 Oct 2024 14:55:11 +0200
Message-ID: <20241002125834.944386857@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index e72145c4ae5a0..7e73e13741d1e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5165,6 +5165,18 @@ static int ext4_block_group_meta_init(struct super_block *sb, int silent)
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
@@ -5272,13 +5284,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
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
@@ -6441,6 +6447,15 @@ static int __ext4_remount(struct fs_context *fc, struct super_block *sb)
 
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21483A6B6B;
	Wed,  8 Apr 2026 18:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672356; cv=none; b=p7Y2XYpeJ0r63KqWE4woJr1sX758omaoePeacMCLnOSUWBH/R3JM7WEZaxJjvu25elTwWvGN0LkoG3Nkr3sf9D9rS1VNUv4T1QSDoBcqK2g1KjlAenVpZpdV/mSmqz+DEA5i1oM5d6s/VIxR7QKSqq1DYKTXAYIjqgJH8+giDSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672356; c=relaxed/simple;
	bh=yw8IedZQGlrr7m3f+6riWsrbiGLuz+iSHW2MNWosJwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBWKT2QaWKchpnyA1UrVxzTxVgCoGLFBX/3AHnAW8XQXy1BKBuekN+NFh+QYn7vLRLv2g2zrGGUmSPr1Xh1qgJtTHiyARrKZTCOR20e07cAwr43uL8akixU6T48zi2/PtD7gwwaJf2H4OkUciWAAt7VF3I/laSDK7u7E6EAZKMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1l5njel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1l5njel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A98C19421;
	Wed,  8 Apr 2026 18:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672356;
	bh=yw8IedZQGlrr7m3f+6riWsrbiGLuz+iSHW2MNWosJwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1l5njelOBV4S4jt3m1hA+nmKhbOW+VMuhD3oKmv5Lp5sZRf2u7/cfwj104qBJOBG
	 x+DGEumZJM+NpmhrwSes3muhpMBfwix0vI/kEix4tIdtfwPRarf+mOr1PzZiRyXJ6V
	 sVfj8w1rofDjGoQvSWuvZ/tWH3+iiNHw6JWHiFR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Yan <yanaijie@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 288/312] ext4: factor out ext4_flex_groups_free()
Date: Wed,  8 Apr 2026 20:03:25 +0200
Message-ID: <20260408175944.515772597@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Yan <yanaijie@huawei.com>

[ Upstream commit dcbf87589d90e3bd5a5a4cf832517f22f3c55efb ]

Factor out ext4_flex_groups_free() and it can be used both in
__ext4_fill_super() and ext4_put_super().

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Link: https://lore.kernel.org/r/20230323140517.1070239-5-yanaijie@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 496bb99b7e66 ("ext4: fix the might_sleep() warnings in kvfree()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1249,11 +1249,25 @@ static void ext4_group_desc_free(struct
 	rcu_read_unlock();
 }
 
+static void ext4_flex_groups_free(struct ext4_sb_info *sbi)
+{
+	struct flex_groups **flex_groups;
+	int i;
+
+	rcu_read_lock();
+	flex_groups = rcu_dereference(sbi->s_flex_groups);
+	if (flex_groups) {
+		for (i = 0; i < sbi->s_flex_groups_allocated; i++)
+			kvfree(flex_groups[i]);
+		kvfree(flex_groups);
+	}
+	rcu_read_unlock();
+}
+
 static void ext4_put_super(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
-	struct flex_groups **flex_groups;
 	int aborted = 0;
 	int i, err;
 
@@ -1303,14 +1317,7 @@ static void ext4_put_super(struct super_
 		ext4_commit_super(sb);
 
 	ext4_group_desc_free(sbi);
-	rcu_read_lock();
-	flex_groups = rcu_dereference(sbi->s_flex_groups);
-	if (flex_groups) {
-		for (i = 0; i < sbi->s_flex_groups_allocated; i++)
-			kvfree(flex_groups[i]);
-		kvfree(flex_groups);
-	}
-	rcu_read_unlock();
+	ext4_flex_groups_free(sbi);
 	ext4_percpu_param_destroy(sbi);
 #ifdef CONFIG_QUOTA
 	for (i = 0; i < EXT4_MAXQUOTAS; i++)
@@ -5121,7 +5128,6 @@ static int __ext4_fill_super(struct fs_c
 {
 	struct ext4_super_block *es = NULL;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct flex_groups **flex_groups;
 	ext4_fsblk_t logical_sb_block;
 	struct inode *root;
 	int ret = -ENOMEM;
@@ -5613,14 +5619,7 @@ failed_mount7:
 	ext4_unregister_li_request(sb);
 failed_mount6:
 	ext4_mb_release(sb);
-	rcu_read_lock();
-	flex_groups = rcu_dereference(sbi->s_flex_groups);
-	if (flex_groups) {
-		for (i = 0; i < sbi->s_flex_groups_allocated; i++)
-			kvfree(flex_groups[i]);
-		kvfree(flex_groups);
-	}
-	rcu_read_unlock();
+	ext4_flex_groups_free(sbi);
 	ext4_percpu_param_destroy(sbi);
 failed_mount5:
 	ext4_ext_release(sb);



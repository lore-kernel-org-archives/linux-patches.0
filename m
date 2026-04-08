Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3521B2494F0;
	Wed,  8 Apr 2026 18:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672354; cv=none; b=Ax3XTXsnHga1uDmBf62XhqvvQTuWN8l6j9ohaE/Mewig1T8WMUhwT34qUPnr2ItyGfTi3osUSGponrDtW0v4TsiEqHhMwRSa/Hl8jkCgQnzDdnDEbqBPbdwt4Vzdo3NTrcFpjB7R4gEWTtH8RS9Am0hJDLou9Xo+rgroD41MtRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672354; c=relaxed/simple;
	bh=rB5oS2MqWUgukJ4ZKLyIDbW0noMxlLx5wUw8/T2jLFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAelC9N8J+lHrrlnOeJZGNCNIuMsDzaYDmAmTLfpVhJfWND+FJlAbtKZCUhL9OsdlLm3yUzmI2uxDpgJYRd2p8y02tvnNy/aW4pJ4VfoMJlDBQdgp2AmknLXRVu5rSv8MRJux1pNPvboWrjKosoeMHyj8s3GSemOwvL4vbTXzcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dSBh5X1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dSBh5X1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9CDC19421;
	Wed,  8 Apr 2026 18:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672354;
	bh=rB5oS2MqWUgukJ4ZKLyIDbW0noMxlLx5wUw8/T2jLFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0dSBh5X1L6xmCZSjLhSYIgXO4H13zL1sVoHNmJQnHZGdr35r/L4AZ7faouJORTuUW
	 gOxNrxwRG4TqPmfhyH2246EqY/pDFP4KelNPuKlnp24cvMdRxOX1A23AbgVTDeB7Q0
	 raB4//qDg865oKFDXVFtvwUVOgSbFbdgkrRaEUPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Yan <yanaijie@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 287/312] ext4: use ext4_group_desc_free() in ext4_put_super() to save some duplicated code
Date: Wed,  8 Apr 2026 20:03:24 +0200
Message-ID: <20260408175944.477823070@linuxfoundation.org>
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

[ Upstream commit 6ef684988816fdfa29ceff260c97d725a489a942 ]

The only difference here is that ->s_group_desc and ->s_flex_groups share
the same rcu read lock here but it is not necessary. In other places they
do not share the lock at all.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Link: https://lore.kernel.org/r/20230323140517.1070239-4-yanaijie@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 496bb99b7e66 ("ext4: fix the might_sleep() warnings in kvfree()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1236,11 +1236,23 @@ static void ext4_percpu_param_destroy(st
 	percpu_free_rwsem(&sbi->s_writepages_rwsem);
 }
 
+static void ext4_group_desc_free(struct ext4_sb_info *sbi)
+{
+	struct buffer_head **group_desc;
+	int i;
+
+	rcu_read_lock();
+	group_desc = rcu_dereference(sbi->s_group_desc);
+	for (i = 0; i < sbi->s_gdb_count; i++)
+		brelse(group_desc[i]);
+	kvfree(group_desc);
+	rcu_read_unlock();
+}
+
 static void ext4_put_super(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
-	struct buffer_head **group_desc;
 	struct flex_groups **flex_groups;
 	int aborted = 0;
 	int i, err;
@@ -1290,11 +1302,8 @@ static void ext4_put_super(struct super_
 	if (!sb_rdonly(sb))
 		ext4_commit_super(sb);
 
+	ext4_group_desc_free(sbi);
 	rcu_read_lock();
-	group_desc = rcu_dereference(sbi->s_group_desc);
-	for (i = 0; i < sbi->s_gdb_count; i++)
-		brelse(group_desc[i]);
-	kvfree(group_desc);
 	flex_groups = rcu_dereference(sbi->s_flex_groups);
 	if (flex_groups) {
 		for (i = 0; i < sbi->s_flex_groups_allocated; i++)
@@ -4770,19 +4779,6 @@ static int ext4_geometry_check(struct su
 	return 0;
 }
 
-static void ext4_group_desc_free(struct ext4_sb_info *sbi)
-{
-	struct buffer_head **group_desc;
-	int i;
-
-	rcu_read_lock();
-	group_desc = rcu_dereference(sbi->s_group_desc);
-	for (i = 0; i < sbi->s_gdb_count; i++)
-		brelse(group_desc[i]);
-	kvfree(group_desc);
-	rcu_read_unlock();
-}
-
 static int ext4_group_desc_init(struct super_block *sb,
 				struct ext4_super_block *es,
 				ext4_fsblk_t logical_sb_block,



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38336EB56;
	Thu, 13 Jun 2024 12:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281048; cv=none; b=h0ZwOhtMEtszdg7NcoGgdVp2gglIWA7+pVWiGa2DazzZ1mPqfGLTsfOQ32eExRG+lNRH2IvZa0qBilk+fFjbnNtly+9BVkwgBCjSju2OFUqmi12L41si4UyVlPG0cVrNPsdY8T16UAnRRD39vIaV/WtYQwMrM4tYF872kJvZDuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281048; c=relaxed/simple;
	bh=ruNlz1xeffd650k1Mjmo6e+ncthhtaoIGkov5pFLThA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNL6tm0VT6UdEl8nQFYI0kdc1eUfordzB0wgVFvD5IzzwiCnrwll74WIhyNV0HFdfKVHWDnnpKbyykIGTeLSsW2x/R7PgcYJeYbTDAT1LswOMKxDBbwIrsBrc9f62qJ39YC6gnJVAymL8ZpT/c5Akr/llMQl88zfwyW8PNdi9Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwn/r4Eb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwn/r4Eb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4AFC4AF1A;
	Thu, 13 Jun 2024 12:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281048;
	bh=ruNlz1xeffd650k1Mjmo6e+ncthhtaoIGkov5pFLThA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwn/r4EbRPrmznwZ9K8XMWLvE5OR02EXJsyXwE0eak4MvKBRed9JIhho1flRYzCD8
	 o20RmTresavizgfVA7Hgjae5jsWgl0C3w5pDxxfNStvYlhSJawizy9TUn6aO3M9dS4
	 hcXXuUW6vBcjQD+jbp9nntIySVmrGn/s4kSr6k3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/317] ext4: fix unit mismatch in ext4_mb_new_blocks_simple
Date: Thu, 13 Jun 2024 13:32:20 +0200
Message-ID: <20240613113252.270057140@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 497885f72d930305d8e61b6b616b22b4da1adf90 ]

The "i" returned from mb_find_next_zero_bit is in cluster unit and we
need offset "block" corresponding to "i" in block unit. Convert "i" to
block unit to fix the unit mismatch.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/r/20230603150327.3596033-3-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 3f4830abd236 ("ext4: fix potential unnitialized variable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 26beaf102ce36..f54f23afd93d2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5349,6 +5349,7 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 {
 	struct buffer_head *bitmap_bh;
 	struct super_block *sb = ar->inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_group_t group;
 	ext4_grpblk_t blkoff;
 	ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
@@ -5377,7 +5378,8 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 			if (i >= max)
 				break;
 			if (ext4_fc_replay_check_excluded(sb,
-				ext4_group_first_block_no(sb, group) + i)) {
+				ext4_group_first_block_no(sb, group) +
+				EXT4_C2B(sbi, i))) {
 				blkoff = i + 1;
 			} else
 				break;
@@ -5394,7 +5396,7 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 		return 0;
 	}
 
-	block = ext4_group_first_block_no(sb, group) + i;
+	block = ext4_group_first_block_no(sb, group) + EXT4_C2B(sbi, i);
 	ext4_mb_mark_bb(sb, block, 1, 1);
 	ar->len = 1;
 
-- 
2.43.0




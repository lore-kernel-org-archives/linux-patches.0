Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF941F7557;
	Wed,  6 Nov 2024 13:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898018; cv=none; b=BcE/rtDLpBYdWvACr2Vb+HgvlIBgfLzaHMF/fCCoZwOKvfeLekjzFBQBwS7cmgqsSfrjoH88TwdmGphgYlEOZIGHVctWpDlEQzsOEDA3guxUdCtndNpC6d82FnhbPaXQ9VClcvHJBRb1S1fA3KngCThnrv/C1TwNaCt4PmsULsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898018; c=relaxed/simple;
	bh=ssawlkmPOR/AgV85GZYdwHsRgtLg730pVDLDlyyzK7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D54M5QK7LSl+sMVeTzOLjHXP9OCndj28C4kyC8nlOOJrgP+1SwO+mMF2zAbge23lYgPCD1flCecJJ5CtIxQwmRW5BtR9tANle1wSw84PeKSkraCDOuMiEv6LDXacAteEIHmVwBMcLCdOYhvi6TtzYSyLmQWJN2UwhuNSMGIQWv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9rlZB+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9rlZB+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4E4C4CECD;
	Wed,  6 Nov 2024 13:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898017;
	bh=ssawlkmPOR/AgV85GZYdwHsRgtLg730pVDLDlyyzK7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9rlZB+TwN1sfXmgu3v+bF4jL8C/4HxVO9sNwF7s6wqgokcYavlclcf8miOnHsvX9
	 vYivCZFp/bwETkoulKf4Y8kEj2b2jh7S3Re1RdMVYN/xdV7eFkp8J3PVfZT+ae7Esj
	 hMHJ76bvIRqTIkeCKDi4PctpuamgqcHsd0kj95g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangerkun <yangerkun@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/462] ext4: clear EXT4_GROUP_INFO_WAS_TRIMMED_BIT even mount with discard
Date: Wed,  6 Nov 2024 12:59:49 +0100
Message-ID: <20241106120333.877854443@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yangerkun <yangerkun@huawei.com>

[ Upstream commit 20cee68f5b44fdc2942d20f3172a262ec247b117 ]

Commit 3d56b8d2c74c ("ext4: Speed up FITRIM by recording flags in
ext4_group_info") speed up fstrim by skipping trim trimmed group. We
also has the chance to clear trimmed once there exists some block free
for this group(mount without discard), and the next trim for this group
will work well too.

For mount with discard, we will issue dicard when we free blocks, so
leave trimmed flag keep alive to skip useless trim trigger from
userspace seems reasonable. But for some case like ext4 build on
dm-thinpool(ext4 blocksize 4K, pool blocksize 128K), discard from ext4
maybe unaligned for dm thinpool, and thinpool will just finish this
discard(see process_discard_bio when begein equals to end) without
actually process discard. For this case, trim from userspace can really
help us to free some thinpool block.

So convert to clear trimmed flag for all case no matter mounted with
discard or not.

Fixes: 3d56b8d2c74c ("ext4: Speed up FITRIM by recording flags in ext4_group_info")
Signed-off-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20240817085510.2084444-1-yangerkun@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b268dc0e1df44..032e6519865cd 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2836,11 +2836,8 @@ static void ext4_free_data_in_buddy(struct super_block *sb,
 	/*
 	 * Clear the trimmed flag for the group so that the next
 	 * ext4_trim_fs can trim it.
-	 * If the volume is mounted with -o discard, online discard
-	 * is supported and the free blocks will be trimmed online.
 	 */
-	if (!test_opt(sb, DISCARD))
-		EXT4_MB_GRP_CLEAR_TRIMMED(db);
+	EXT4_MB_GRP_CLEAR_TRIMMED(db);
 
 	if (!db->bb_free_root.rb_node) {
 		/* No more items in the per group rb tree
@@ -4962,8 +4959,9 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 					 " group:%d block:%d count:%lu failed"
 					 " with %d", block_group, bit, count,
 					 err);
-		} else
-			EXT4_MB_GRP_CLEAR_TRIMMED(e4b.bd_info);
+		}
+
+		EXT4_MB_GRP_CLEAR_TRIMMED(e4b.bd_info);
 
 		ext4_lock_group(sb, block_group);
 		mb_clear_bits(bitmap_bh->b_data, bit, count_clusters);
-- 
2.43.0




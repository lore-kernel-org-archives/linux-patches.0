Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0471EF09B;
	Tue, 15 Oct 2024 11:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992735; cv=none; b=Dx0W/G8L1BkHZXFv+19recgJN5oiHx7KJVxm7yavaBDIlwZ8P1qS2rmL2WlNhpF2L6rOusG3mvvSrujAe+kRG9SrJCBmqTUpWDWtbbdfuYVaojJoI+CWV81LF9K65ha8uSMJIuWUjKX5tlxLLQCKrf6J7P63GMJSHN09pM99jog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992735; c=relaxed/simple;
	bh=O1nn4/bNMMgAUcZ9MP3A3PbATfvnChDzF067+mstXVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3ucVd2hffExDT166WY8nqyit8R9+k2EMMMncCXqQO4cNCWZmNZ6KkWz8t+5GRBinx68TRyjakZ1PrwZRZWQm4knbI4vIm2AxU3SLcO1pSZz6n3v4IQXIxx25Ozb+E5YuRRPScf6MTbtcfQ8JeuCElcNNzf8Zjx6C+OqebKmjvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APW7tlDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APW7tlDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153D2C4CEC6;
	Tue, 15 Oct 2024 11:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992735;
	bh=O1nn4/bNMMgAUcZ9MP3A3PbATfvnChDzF067+mstXVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APW7tlDHzoyVKCoAKYTjy7GyReO53XzomGCkenwLoBktphmAUvbZLJYS/o7tKWJjr
	 +JpZ2gXoSb7uuHFADYq4Ml4Z9yPFfiUjBoSlJTjhGJrKce69xPOMIVjiXQJhZ4P+eK
	 j6g92PT70E9ew+FmpXjjTmCkk0GSjbFGrgISI5hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangerkun <yangerkun@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 203/691] ext4: clear EXT4_GROUP_INFO_WAS_TRIMMED_BIT even mount with discard
Date: Tue, 15 Oct 2024 13:22:31 +0200
Message-ID: <20241015112448.416623445@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a48c9cc5aa6e8..6b7d69037b836 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3721,11 +3721,8 @@ static void ext4_free_data_in_buddy(struct super_block *sb,
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
@@ -6127,8 +6124,9 @@ static void ext4_mb_clear_bb(handle_t *handle, struct inode *inode,
 					 " group:%u block:%d count:%lu failed"
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




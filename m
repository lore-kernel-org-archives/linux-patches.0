Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7391D0787;
	Wed,  2 Oct 2024 14:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878109; cv=none; b=nYexzvVpnNzRmoCiLU8/93c9nN9Q3GN+Nal05XQ11jRxXlfcRnGqJvBZ9u7LTRJqLNjIzrMRjaW4T9WOUwO0WxRrPkgQ2xuBuWoJlvuUK3AgUkuWgOWKhIBvNN9u3ai1POP36lEyEper+JuZhfk4gBvw4/qFQLjm4RnW45bKsjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878109; c=relaxed/simple;
	bh=IViy3ZG0YHfJoLvfD7PPxGxGzCXdA/uZ88xInLyjojs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfZwag8l1teOmJo/kvVCkgxFGl+JNEz8+q8i3swFLZODA8+FGcQy673JC8Ca7QSuE1lUr6e191ZGL9vcViSXBUL5+1Tn6HNFvq+9yBFyJ4W/1MPh7F+WOxDRV1d7fNk/pqhWrdavWDcjzypiX3vOg0czEUAYc3axIV0U6uUp7hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWqHMimr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWqHMimr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871EDC4CEC2;
	Wed,  2 Oct 2024 14:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878108;
	bh=IViy3ZG0YHfJoLvfD7PPxGxGzCXdA/uZ88xInLyjojs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWqHMimr3VgjGHiFFibmKyikYGwfKXpA1SqvjeNHurSk0AnFb0YL9Wh3mmkKzOa4p
	 Gtbs/m5OmFz9PXOTJQCX6NxLoaytNyisMOstxRAFe7coa7hl13O2P97xsYnJlUNKlD
	 HPMltSBHLs5sFvHgyeIFWgt4udG3DOd19v7RtnQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangerkun <yangerkun@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 274/634] ext4: clear EXT4_GROUP_INFO_WAS_TRIMMED_BIT even mount with discard
Date: Wed,  2 Oct 2024 14:56:14 +0200
Message-ID: <20241002125821.917212305@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9dda9cd68ab2f..dfecd25cee4ea 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3887,11 +3887,8 @@ static void ext4_free_data_in_buddy(struct super_block *sb,
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
@@ -6515,8 +6512,9 @@ static void ext4_mb_clear_bb(handle_t *handle, struct inode *inode,
 					 " group:%u block:%d count:%lu failed"
 					 " with %d", block_group, bit, count,
 					 err);
-		} else
-			EXT4_MB_GRP_CLEAR_TRIMMED(e4b.bd_info);
+		}
+
+		EXT4_MB_GRP_CLEAR_TRIMMED(e4b.bd_info);
 
 		ext4_lock_group(sb, block_group);
 		mb_free_blocks(inode, &e4b, bit, count_clusters);
-- 
2.43.0




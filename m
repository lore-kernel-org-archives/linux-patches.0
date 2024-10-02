Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74131D0426;
	Wed,  2 Oct 2024 13:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876027; cv=none; b=P4kZDEUwdEv7ylIKtUGrW28BgjQKbFNOkPCVvCKyOTwIr5CNT7NeZCfwlk6XaIVVCtug8IcCTWWSNTuIFRZVTC7wKf28cTgou3fmpT48PgPmg9rNYg3SROI7fWX5jYlMxf4uPTSNNMavKRSMt0uRtNpdrUtLqlehK3aNGNbHIVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876027; c=relaxed/simple;
	bh=rd0DE/63k99mZvYyNMtfj9miKsgrIv74U0qzD0k/vR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7oR5Tz7DBgvQ7pVdmCU4jm/kVquOSVeqXHeYcXzenavFRDIMASW6EQLyHQ58K4Tp1oC+iAvP2pN4uqjdUiGsxrsFD0WHoH1QADMhi/iwE3TNaMJyaQdrXHMAZSe24B8JeYStuByGCGOtgq/hTrr9bZXEJ7+mHGudnivtFGckRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0xWHQbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0xWHQbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55429C4CECD;
	Wed,  2 Oct 2024 13:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876027;
	bh=rd0DE/63k99mZvYyNMtfj9miKsgrIv74U0qzD0k/vR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0xWHQbTn7H4cR8BTcxHYYaNc/WaLgGCncD8DqUpbsVVWGxZoaCSiTQFQc2tCkaZH
	 gROcz/LyqvcCuOEwXTWbYQTWctmDo+kWgmkeCpmhV1SXM19qFnntpcOXQueq+r5ESp
	 xH9LjCweNUXb4wvDMdHShm8ALmlj8BKV0o7OOMYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangerkun <yangerkun@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 304/695] ext4: clear EXT4_GROUP_INFO_WAS_TRIMMED_BIT even mount with discard
Date: Wed,  2 Oct 2024 14:55:02 +0200
Message-ID: <20241002125834.575412647@linuxfoundation.org>
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4E1381AEC;
	Thu, 20 Aug 2026 17:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247203; cv=none; b=kXhb91IrJVYicpBcbTslGTalqTmSyuimE70PDmk+Xv7xG7hSgNeZ69R+SGXlfvWB4oUB8J4ZT8Aaeo6pMeL1A6GDL2nfK9YUtiVbys7SttlS0GqvO0Nm6hAcn2LEw6wvYy1SM0WIs3n0WDmA3YrIKSHOjuf2l6CsbVWxKbmJ9zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247203; c=relaxed/simple;
	bh=nvO9QsMXr1wUKBf4wR8Dcr4+EwIgO37kU9lp3fYu+3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ei3nWxtIfYGjZj3qSB1wMLPGnIwKWwy1R38QSSAWdY4iRL2sFfeW3Ke/eSZha/8G0ZVak6rQH7vwhTcRtl6RxpfLv4t8utD9vbMYIQaQ18GHW7f3+RN/gfHROn/KebMbK153qGhGzkYEkmSIZYxvg5VTQCh4SH7xhBGEZIMpMBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyrC/t+w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyrC/t+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF5C1F000E9;
	Thu, 20 Aug 2026 17:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247201;
	bh=Tdo5C8PMqvhQbNJGayYhdqFyph37Ye2LjZvjp827D2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cyrC/t+wehKtYTzsJjjHwx9rPDcCnihgZHhkgts/kALHrLHNrP9TP1igjsv7fk++c
	 zC2e3mmgpaE5fML9yQNSlBZvGJFbaQKz4YVCiMHVg9X6t81ShbNVhjV2FEN904eVGJ
	 Uya79OyZYR2jFjdpPR6ByYCbb/ROdF+j5s2P0n/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 145/220] btrfs: remove fs_info argument from btrfs_zoned_activate_one_bg()
Date: Thu, 20 Aug 2026 16:55:35 +0200
Message-ID: <20260820145227.829519904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a232ff90d14657c8637c6e94b606bb5d700a2ecb ]

We don't need it since we can grab fs_info from the given space_info.
So remove the fs_info argument.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 8bc4d7209611 ("btrfs: zoned: fix missing chunk metadata reservation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    4 ++--
 fs/btrfs/zoned.c       |    5 ++---
 fs/btrfs/zoned.h       |    6 ++----
 3 files changed, 6 insertions(+), 9 deletions(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -3092,7 +3092,7 @@ int btrfs_inc_block_group_ro(struct btrf
 	 * We have allocated a new chunk. We also need to activate that chunk to
 	 * grant metadata tickets for zoned filesystem.
 	 */
-	ret = btrfs_zoned_activate_one_bg(fs_info, space_info, true);
+	ret = btrfs_zoned_activate_one_bg(space_info, true);
 	if (ret < 0)
 		goto out;
 
@@ -4350,7 +4350,7 @@ static void reserve_chunk_space(struct b
 			 * We have a new chunk. We also need to activate it for
 			 * zoned filesystem.
 			 */
-			ret = btrfs_zoned_activate_one_bg(fs_info, info, true);
+			ret = btrfs_zoned_activate_one_bg(info, true);
 			if (ret < 0)
 				return;
 
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2825,10 +2825,9 @@ int btrfs_zone_finish_one_bg(struct btrf
 	return ret < 0 ? ret : 1;
 }
 
-int btrfs_zoned_activate_one_bg(struct btrfs_fs_info *fs_info,
-				struct btrfs_space_info *space_info,
-				bool do_finish)
+int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_finish)
 {
+	struct btrfs_fs_info *fs_info = space_info->fs_info;
 	struct btrfs_block_group *bg;
 	int index;
 
--- a/fs/btrfs/zoned.h
+++ b/fs/btrfs/zoned.h
@@ -93,8 +93,7 @@ bool btrfs_zoned_should_reclaim(const st
 void btrfs_zoned_release_data_reloc_bg(struct btrfs_fs_info *fs_info, u64 logical,
 				       u64 length);
 int btrfs_zone_finish_one_bg(struct btrfs_fs_info *fs_info);
-int btrfs_zoned_activate_one_bg(struct btrfs_fs_info *fs_info,
-				struct btrfs_space_info *space_info, bool do_finish);
+int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info, bool do_finish);
 void btrfs_check_active_zone_reservation(struct btrfs_fs_info *fs_info);
 #else /* CONFIG_BLK_DEV_ZONED */
 
@@ -258,8 +257,7 @@ static inline int btrfs_zone_finish_one_
 	return 1;
 }
 
-static inline int btrfs_zoned_activate_one_bg(struct btrfs_fs_info *fs_info,
-					      struct btrfs_space_info *space_info,
+static inline int btrfs_zoned_activate_one_bg(struct btrfs_space_info *space_info,
 					      bool do_finish)
 {
 	/* Consider all the block groups are active */



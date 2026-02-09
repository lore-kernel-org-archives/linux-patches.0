Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FBB25DB1C;
	Mon,  9 Feb 2026 14:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648421; cv=none; b=GNqWGtizgYbrRgo82eMGYUiBDmA5AWkErLpe1agaKqvVWa0tq6BcBuGqXA3AGR8uxE39slOWBvb4osxfl6ZhVQJbMvlQvI3w67+x/HoT+gsdT/Ka277Mw2H3ooPwniuQdNiA55PNLde360lxFWiUmD2FO809XP5XYbJYMZHsR/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648421; c=relaxed/simple;
	bh=/iIhMqs3PxYq6Oh1NuMgKMlUA6iHrOMu1jdS6qWDW6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvhDSqdhW41o5CZ8cKZbaWOC6jakAxPSsRsphrS/YnHK0Xn/z3lA7rALYtz802Urfx6Xm0I4TYGdgnjC80+0/3eXC3W7Y/ZtEXhk+VpHcZcS+sHx/f3A8tDjcemq1nqIdR/Gh8IjMc/oE0rEndX9Ee/T68Uj5itA1o0pTTrYse0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hf+T1lAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hf+T1lAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B94AC16AAE;
	Mon,  9 Feb 2026 14:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648421;
	bh=/iIhMqs3PxYq6Oh1NuMgKMlUA6iHrOMu1jdS6qWDW6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hf+T1lAxGAvoTqBzdDGqfE9hptGSfnIkBGNe6V+/176rWPNUT282NVPr0ylrrSmWR
	 459keMPHYIzgqnNF3NUWSfE5oify5Y9D9SxkcfE2dPaiHbKp0x/2J9k9Gq2rm/b89Y
	 8ey5lWN+rsHOOYWhg9IIqAIOtgtJvbAN4jSlVTtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 33/86] btrfs: fix reservation leak in some error paths when inserting inline extent
Date: Mon,  9 Feb 2026 15:23:56 +0100
Message-ID: <20260209142305.977033122@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit c1c050f92d8f6aac4e17f7f2230160794fceef0c ]

If we fail to allocate a path or join a transaction, we return from
__cow_file_range_inline() without freeing the reserved qgroup data,
resulting in a leak. Fix this by ensuring we call btrfs_qgroup_free_data()
in such cases.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 68bb5079aef74..96edac307408c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -619,7 +619,7 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 size,
 	struct btrfs_drop_extents_args drop_args = { 0 };
 	struct btrfs_root *root = inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_trans_handle *trans;
+	struct btrfs_trans_handle *trans = NULL;
 	u64 data_len = (compressed_size ?: size);
 	int ret;
 	struct btrfs_path *path;
@@ -637,13 +637,16 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 size,
 		return 1;
 
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
-		btrfs_free_path(path);
-		return PTR_ERR(trans);
+		ret = PTR_ERR(trans);
+		trans = NULL;
+		goto out;
 	}
 	trans->block_rsv = &inode->block_rsv;
 
@@ -690,7 +693,8 @@ static noinline int cow_file_range_inline(struct btrfs_inode *inode, u64 size,
 	 */
 	btrfs_qgroup_free_data(inode, NULL, 0, PAGE_SIZE, NULL);
 	btrfs_free_path(path);
-	btrfs_end_transaction(trans);
+	if (trans)
+		btrfs_end_transaction(trans);
 	return ret;
 }
 
-- 
2.51.0




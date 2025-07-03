Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC1A2D4B63;
	Thu,  3 Jul 2025 15:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554803; cv=none; b=ZieH0uGNeZDIoeL96pykQ80rhjxtj1P+w8hbFD4cV2PzB73g7uZdYr2YTBQ/36zcDwA2Y4zz4Ygx190qJrwKM19WdqyX4XmLQiwQM0MjlOuxNAUciGqoYedh4GgrHBzrE+2JBLmEM8eJboWNbFzuQt6P9uozPsDwpC2qaAFdkEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554803; c=relaxed/simple;
	bh=v5Fq4TJMeZZVoYsCBNlouL1uqdsgUkNBbwc9bVQATLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcaPnAOZfyYLf69N3wfow8tyHGoiN8S+/9AAnb8/cBLoX8HWIKAg+gD4DzwuU/75Tx1Aq2NQopGepBysXvbOs2Zvht4P7g4/3rB2H4m0UjpraQg0YQh3I0TeUzll1v/GYxKt9GEDHJ0jXqMrj3OA1ZezLxtqlwODDnftZnz5ck0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1p2fzBPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1p2fzBPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A656C4CEE3;
	Thu,  3 Jul 2025 15:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554802;
	bh=v5Fq4TJMeZZVoYsCBNlouL1uqdsgUkNBbwc9bVQATLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1p2fzBPB7cTfNhXs0AM7kGmo3BlrBkwlr02FljjSxWwgvyDYvgVqVUbSUOgA/NC0W
	 BfjX9YwzlYOd4OqEXkpiZSyUbpFiAmfHePG0IK3S4osq7zT/FNWAKSXSl9yVp1FD8Q
	 ppPdo8V8IvozmNVYFmpZoL1CUG0OrkWczyHP6In0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 083/263] btrfs: fix qgroup reservation leak on failure to allocate ordered extent
Date: Thu,  3 Jul 2025 16:40:03 +0200
Message-ID: <20250703144007.631919963@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 1f2889f5594a2bc4c6a52634c4a51b93e785def5 ]

If we fail to allocate an ordered extent for a COW write we end up leaking
a qgroup data reservation since we called btrfs_qgroup_release_data() but
we didn't call btrfs_qgroup_free_refroot() (which would happen when
running the respective data delayed ref created by ordered extent
completion or when finishing the ordered extent in case an error happened).

So make sure we call btrfs_qgroup_free_refroot() if we fail to allocate an
ordered extent for a COW write.

Fixes: 7dbeaad0af7d ("btrfs: change timing for qgroup reserved space for ordered extents to fix reserved space leak")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Boris Burkov <boris@bur.io>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ordered-data.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index f61b0bb1faccf..1d7ddd664c0d3 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -153,9 +153,10 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 	struct btrfs_ordered_extent *entry;
 	int ret;
 	u64 qgroup_rsv = 0;
+	const bool is_nocow = (flags &
+	       ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALLOC)));
 
-	if (flags &
-	    ((1U << BTRFS_ORDERED_NOCOW) | (1U << BTRFS_ORDERED_PREALLOC))) {
+	if (is_nocow) {
 		/* For nocow write, we can release the qgroup rsv right now */
 		ret = btrfs_qgroup_free_data(inode, NULL, file_offset, num_bytes, &qgroup_rsv);
 		if (ret < 0)
@@ -170,8 +171,13 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 			return ERR_PTR(ret);
 	}
 	entry = kmem_cache_zalloc(btrfs_ordered_extent_cache, GFP_NOFS);
-	if (!entry)
+	if (!entry) {
+		if (!is_nocow)
+			btrfs_qgroup_free_refroot(inode->root->fs_info,
+						  btrfs_root_id(inode->root),
+						  qgroup_rsv, BTRFS_QGROUP_RSV_DATA);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	entry->file_offset = file_offset;
 	entry->num_bytes = num_bytes;
-- 
2.39.5




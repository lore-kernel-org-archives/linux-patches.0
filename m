Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2782C028F;
	Thu, 15 Jan 2026 17:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496611; cv=none; b=DhY3SwGvQ0mAzrnQnfMjRufOt+DbGSYNStT5qa2GGSnpLtgEN23qYSihrPL6+tHYxZRu523CIPMiMXu4pUR7zuqljXjz8HWwKqylGG7sf/mBEsbbGhgTz7PY0icwtQLT3GOc0MP3h/r5t1+MVbxZFRIaQdG0/eQhoPYklYhgj7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496611; c=relaxed/simple;
	bh=R3PgzPkxiVJyRkHu9PsZEjs2rFec2nI///XnXVyPhLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2LXql7rM6qV2O1Ec5epBWBKe3DGB8tbbKSRJX2g8ameSGSABRTOeMIvrGXP6q36mL/kAtXRB1SBmc4XBasnGFQt+LaMgr4RCiSZ/3AemMyDgE14I+qnD41Ei4DG5z4yko7xjXK8yvHrk8uz2una+yOB6z3TTUL0c0jWNwmp+KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1VOtrpA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1VOtrpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62096C116D0;
	Thu, 15 Jan 2026 17:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496611;
	bh=R3PgzPkxiVJyRkHu9PsZEjs2rFec2nI///XnXVyPhLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y1VOtrpAJ3oC+jZx4WIhWY/S5Oe2nHOf9ntJ+zuLTjkco6wacjmYqdIzW0yl0f+HB
	 YktJ0M6Y7SBftQXuULCcF1RVa+3Q1mEwFppsI3s4GKCiJh/ZhqO7Oacnu1ph9J3WXI
	 UDmcgYWmguWdhVXaMBQy/4D3/kTsWhuxrNf2TG04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/119] btrfs: only enforce free space tree if v1 cache is required for bs < ps cases
Date: Thu, 15 Jan 2026 17:48:09 +0100
Message-ID: <20260115164154.623428703@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 30bcf4e824aa37d305502f52e1527c7b1eabef3d ]

[BUG]
Since the introduction of btrfs bs < ps support, v1 cache was never on
the plan due to its hard coded PAGE_SIZE usage, and the future plan to
properly deprecate it.

However for bs < ps cases, even if 'nospace_cache,clear_cache' mount
option is specified, it's never respected and free space tree is always
enabled:

  mkfs.btrfs -f -O ^bgt,fst $dev
  mount $dev $mnt -o clear_cache,nospace_cache
  umount $mnt
  btrfs ins dump-super $dev
  ...
  compat_ro_flags		0x3
         		( FREE_SPACE_TREE |
         		  FREE_SPACE_TREE_VALID )
  ...

This means a different behavior compared to bs >= ps cases.

[CAUSE]
The forcing usage of v2 space cache is done inside
btrfs_set_free_space_cache_settings(), however it never checks if we're
even using space cache but always enabling v2 cache.

[FIX]
Instead unconditionally enable v2 cache, only forcing v2 cache if the
old v1 cache is required.

Now v2 space cache can be properly disabled on bs < ps cases:

  mkfs.btrfs -f -O ^bgt,fst $dev
  mount $dev $mnt -o clear_cache,nospace_cache
  umount $mnt
  btrfs ins dump-super $dev
  ...
  compat_ro_flags		0x0
  ...

Fixes: 9f73f1aef98b ("btrfs: force v2 space cache usage for subpage mount")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/super.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b0d4ad7fbe489..833602511f62d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -722,14 +722,12 @@ bool btrfs_check_options(const struct btrfs_fs_info *info,
  */
 void btrfs_set_free_space_cache_settings(struct btrfs_fs_info *fs_info)
 {
-	if (fs_info->sectorsize < PAGE_SIZE) {
+	if (fs_info->sectorsize < PAGE_SIZE && btrfs_test_opt(fs_info, SPACE_CACHE)) {
+		btrfs_info(fs_info,
+			   "forcing free space tree for sector size %u with page size %lu",
+			   fs_info->sectorsize, PAGE_SIZE);
 		btrfs_clear_opt(fs_info->mount_opt, SPACE_CACHE);
-		if (!btrfs_test_opt(fs_info, FREE_SPACE_TREE)) {
-			btrfs_info(fs_info,
-				   "forcing free space tree for sector size %u with page size %lu",
-				   fs_info->sectorsize, PAGE_SIZE);
-			btrfs_set_opt(fs_info->mount_opt, FREE_SPACE_TREE);
-		}
+		btrfs_set_opt(fs_info->mount_opt, FREE_SPACE_TREE);
 	}
 
 	/*
-- 
2.51.0




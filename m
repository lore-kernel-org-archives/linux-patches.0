Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F93F33993;
	Thu, 15 Jan 2026 16:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496208; cv=none; b=WDcB/GEDOd0piGymyZXV2gzR4ZI8oUnsM2xBPrlRG0hPVRRydN2IJiwbDMkLdYSsl7tv7OdxghxvV4jdomTwE3P2HnmfmF1UIT5IvDWjR91pnKDp6FPViazGZJCdL8e8+SZRx7cQnqREHuGzZtpFu8NLy5iGv9d4VzIUpWSAl6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496208; c=relaxed/simple;
	bh=zOsrQULvx+ZzHeFOdQhsXaQX3m64bs8YquzoA9+xseI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+Q2KDgX3IQwcRxMeBVibvpHuq9UTh9DuLbjKGUEfhDeZyEzcu7ZYHIQYZjSllFHsK98SHRX/Vk8Il8cwHoHM3hHr7kNa/8gAPEZ1wEvK2kII2u//owCVZwjsa7Ku/2haB/Twffn8UJd1NUVJb8EI3ZnZLcAcMa6JjsSG1Oep2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pvE1yoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pvE1yoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE01C116D0;
	Thu, 15 Jan 2026 16:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496207;
	bh=zOsrQULvx+ZzHeFOdQhsXaQX3m64bs8YquzoA9+xseI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1pvE1yoXcL29+qyp2h0VyNYvT8nx95hXYE1JjCUzlm48ROopFnjaDLzE3KGQgzTR8
	 uGi1Ha122h2iuhx+ZmzoEfHzyR+JH8YmtBPV7vPwtxATNbkW3xBrLFjXd9dVpololI
	 NP2ddsz7lKpnJdt+EbtNOptR7BY2VFQIsKk13GN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 116/181] btrfs: only enforce free space tree if v1 cache is required for bs < ps cases
Date: Thu, 15 Jan 2026 17:47:33 +0100
Message-ID: <20260115164206.503365697@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 430e7419349c9..c40944ca7b948 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -736,14 +736,12 @@ bool btrfs_check_options(const struct btrfs_fs_info *info,
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




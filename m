Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E882F5A2D;
	Wed, 28 Jan 2026 15:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614968; cv=none; b=n/ZZAgHawFSqdR9EQcv1BKN6rYzWNh/x0dvhe/Y2ARiq8lL5lhhNle5zRoglQuVaoVJZ1eB3FuCdkBKrS29i3bxhAiZsWFjQvFsLbeBywvBe/rhAN1WIGO9jq8wBpvRdX/pHgrfRs3mpjW1tV3v4/guj4Q6zOZ67h39I1KJDGKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614968; c=relaxed/simple;
	bh=UI25O4yvcvzJoekYTroFUwjYIjkhhS9QsXdMpG4xuV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxgpRIhvrMv2APSAo4ZxqZcIFcTTDw8//6supMaGnPXOoSKxEk0mhuV1Ov6mV0AnaxJmINqUs9GdcBL2fsOg9lwY/gzV/K9hNcOX54sly9tNhpN9GpmD+g0bzJDUYWSlfZHUuBxMypXErjMw1YDhOASxjg0SSEoGP4LBOKuC5os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhCggK1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhCggK1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA17FC4CEF7;
	Wed, 28 Jan 2026 15:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614968;
	bh=UI25O4yvcvzJoekYTroFUwjYIjkhhS9QsXdMpG4xuV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhCggK1iWkYuZQsO3+ch/OKJPVPCB2wKz8bb8Ag3Y2lpaATGaQrL10kWLGDjpP01k
	 xVJA9bjjeK7ppgdBXHtx5ILklWl1wR7cq7M3OEWh8XbePmZ9hbuICz2NlZgAQr8W10
	 s480EcEwVvn9R/FpQXM9hyOrEZqEqSztZjb8JmI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/169] btrfs: fix missing fields in superblock backup with BLOCK_GROUP_TREE
Date: Wed, 28 Jan 2026 16:21:35 +0100
Message-ID: <20260128145334.458102893@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 1d8f69f453c2e8a2d99b158e58e02ed65031fa6d ]

When the BLOCK_GROUP_TREE compat_ro flag is set, the extent root and
csum root fields are getting missed.

This is because EXTENT_TREE_V2 treated these differently, and when
they were split off this special-casing was mistakenly assigned to
BGT rather than the rump EXTENT_TREE_V2. There's no reason why the
existence of the block group tree should mean that we don't record the
details of the last commit's extent root and csum root.

Fix the code in backup_super_roots() so that the correct check gets
made.

Fixes: 1c56ab991903 ("btrfs: separate BLOCK_GROUP_TREE compat RO flag from EXTENT_TREE_V2")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 39fe4385ed361..93300c3fe0cab 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1676,7 +1676,7 @@ static void backup_super_roots(struct btrfs_fs_info *info)
 	btrfs_set_backup_chunk_root_level(root_backup,
 			       btrfs_header_level(info->chunk_root->node));
 
-	if (!btrfs_fs_compat_ro(info, BLOCK_GROUP_TREE)) {
+	if (!btrfs_fs_incompat(info, EXTENT_TREE_V2)) {
 		struct btrfs_root *extent_root = btrfs_extent_root(info, 0);
 		struct btrfs_root *csum_root = btrfs_csum_root(info, 0);
 
-- 
2.51.0




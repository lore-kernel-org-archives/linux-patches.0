Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE1423EAB7;
	Wed, 28 Jan 2026 15:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614327; cv=none; b=BFcUTW6HHo0aoc2k0sN/vTjoANiGZWsQSH690ZFj+woKQkpZh89/QU0duPCfGf+/fJeIHL8U4yS5Xmau4RdAnebGP0TPNJL8YmDhj2Jp747FE9EehcolJA83nx5HfYWmrMeYsxWCf7u+DdxO44buLnsMcDXKYVdERZ1GUF3bVJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614327; c=relaxed/simple;
	bh=zJB7Xq5WMU221PzVm66PIxTcfQdNQ13IoLvNKGVqOrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShtYN3dLgDG5z1i+IFfk70yRQsj4bbVL+Yug3Kv+GTYBnUT0uCtwSJwpoLdB9v16xrPOgHeeNsvzAGz8L7oNaI1GEdUy/rct4neyaXaBL0C7gXhEbNsLknlc4yCE2VdpRNPSm5Oqj2QOofdos9QVfatSFSrD4sZyFaVv97B4V7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+gg0O2a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+gg0O2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AC6C4CEF1;
	Wed, 28 Jan 2026 15:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614327;
	bh=zJB7Xq5WMU221PzVm66PIxTcfQdNQ13IoLvNKGVqOrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+gg0O2aWD/yVq7GTN16omrTfth02PndF09J0Sq2lSfEHpOj1lkzIRFybzy6WHO0o
	 EDxAGv2VrgvG0wo3hIdZG3FLsP4oHd78dOnYk7uFrKikOmVjb5pK/VGBczluqueKCe
	 CnJoffAUdlHNkaxLBsJOqIgdIxHSfgjLro3uultc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/254] btrfs: fix missing fields in superblock backup with BLOCK_GROUP_TREE
Date: Wed, 28 Jan 2026 16:21:17 +0100
Message-ID: <20260128145348.459634922@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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
index 7ad1734cbbfc9..3c26e91a8055f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1654,7 +1654,7 @@ static void backup_super_roots(struct btrfs_fs_info *info)
 	btrfs_set_backup_chunk_root_level(root_backup,
 			       btrfs_header_level(info->chunk_root->node));
 
-	if (!btrfs_fs_compat_ro(info, BLOCK_GROUP_TREE)) {
+	if (!btrfs_fs_incompat(info, EXTENT_TREE_V2)) {
 		struct btrfs_root *extent_root = btrfs_extent_root(info, 0);
 		struct btrfs_root *csum_root = btrfs_csum_root(info, 0);
 
-- 
2.51.0




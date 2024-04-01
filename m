Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CB11CA8F;
	Mon,  1 Apr 2024 16:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987566; cv=none; b=Y10GREZKSBrVPxL3LoTpwu+UUTJmVKukdYWiJ556Ch8yWkYcEr0k3nE7RuTL1teB2YzDNvsc2IJuaJbPO88QIBaXmrmxQYh8egfZy64gGvVlG2k3QiC5mwpjRwSNhwvnvcFwwuk+cNtwORPpMUaAjE/hASV0D++G2pbZUuXPVr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987566; c=relaxed/simple;
	bh=Z3voKbpllvrOk3Owo4hK+ByfABGccYWW+ahdcC8xus0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwawwFSVvJ1U2kjmUIVJlZiIGFaaDmmx5CQhCdNjkiINQDeQNLtPRNMPqiZFgttBvxXeIIggnr0s+bKVnRri6d+95VZ0vMlK7JYGXEhSBlYMRUT+uokmAWec7C6Yol6n+sw68JCxI95wvBak1ULVDwXLYUgzaGTBC2IPE5zH8eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVe4F9Gh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVe4F9Gh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84C4C43390;
	Mon,  1 Apr 2024 16:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987566;
	bh=Z3voKbpllvrOk3Owo4hK+ByfABGccYWW+ahdcC8xus0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVe4F9GhEpj02GjqUz28VC/FSUhN4V7WDrOtiaQo+e3Kr62+0UtIuSx1RePUgRW8k
	 Lt+O3WNjEpX90Y9XEq+JZ1mgnfRkuv5zRT/Nw8zSJakydbTXlUoHHDYTZ3Mr3y6h+/
	 xPPsYQ+AomJekWfMSCRkZ/tQPBcvYlitaO7NEGus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.8 296/399] btrfs: zoned: dont skip block groups with 100% zone unusable
Date: Mon,  1 Apr 2024 17:44:22 +0200
Message-ID: <20240401152558.028179536@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit a8b70c7f8600bc77d03c0b032c0662259b9e615e upstream.

Commit f4a9f219411f ("btrfs: do not delete unused block group if it may be
used soon") changed the behaviour of deleting unused block-groups on zoned
filesystems. Starting with this commit, we're using
btrfs_space_info_used() to calculate the number of used bytes in a
space_info. But btrfs_space_info_used() also accounts
btrfs_space_info::bytes_zone_unusable as used bytes.

So if a block group is 100% zone_unusable it is skipped from the deletion
step.

In order not to skip fully zone_unusable block-groups, also check if the
block-group has bytes left that can be used on a zoned filesystem.

Fixes: f4a9f219411f ("btrfs: do not delete unused block group if it may be used soon")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/block-group.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1550,7 +1550,8 @@ void btrfs_delete_unused_bgs(struct btrf
 		 * needing to allocate extents from the block group.
 		 */
 		used = btrfs_space_info_used(space_info, true);
-		if (space_info->total_bytes - block_group->length < used) {
+		if (space_info->total_bytes - block_group->length < used &&
+		    block_group->zone_unusable < block_group->length) {
 			/*
 			 * Add a reference for the list, compensate for the ref
 			 * drop under the "next" label for the



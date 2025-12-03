Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6DD3570C8;
	Wed,  3 Dec 2025 16:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778698; cv=none; b=BBOCRzx8p+Pedym6WP1rUE7vG8O7WKpayggXVdqiAiVog/8e3+l2yomtrBBj1neyeP+H2SnP/bf920q3oW5yz/vS/p0QMzjDbUDrjjkyAxgjldquye/ZVZG5tNSih95JxfR4xXMDewCNU0OLBy1zE4kbxj4/5NfZ2KDcd7cWy7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778698; c=relaxed/simple;
	bh=hTF1Dp8kfHUFwVwXvPpM61HsKEtZ9faSCiIwkqMvpkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ln1qm5/xI0dA+Wk0ht5glh/yfsMf7ZiZ8K5Yn7FGWzGPE3l1NYYhOtLkygZFidz2auwMC3oxP3ygJgyQmKtjPQ8Ri4r+YHgmn8lyqgvvxcoI8ByHxns0KIVSLP1tmJxcgX6KQUiStYhyPi9d8YBH4sTqohLJcvQKFpzL7NQ25OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymmxpwTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymmxpwTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098FCC4CEF5;
	Wed,  3 Dec 2025 16:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778698;
	bh=hTF1Dp8kfHUFwVwXvPpM61HsKEtZ9faSCiIwkqMvpkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymmxpwThdtOHghG1PBERs7DlVSanoXdVNyccwwrvkE9MGosxBEiYYqP6JjcH+dlej
	 3v1UflSVc0rnIxFacMPmnLZFK2zojQNJWlwjtXJf8UrakTQi6fe87HmPgrZwNEcQQb
	 SGsEojFWJ4uIYg53zpKTM+KXRmgACtqFZkKZGCEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/568] btrfs: zoned: refine extent allocator hint selection
Date: Wed,  3 Dec 2025 16:20:07 +0100
Message-ID: <20251203152440.853307566@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 0d703963d297964451783e1a0688ebdf74cd6151 ]

The hint block group selection in the extent allocator is wrong in the
first place, as it can select the dedicated data relocation block group for
the normal data allocation.

Since we separated the normal data space_info and the data relocation
space_info, we can easily identify a block group is for data relocation or
not. Do not choose it for the normal data allocation.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5395e27f9e89a..7985ca56f6b70 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4224,7 +4224,8 @@ static int prepare_allocation_clustered(struct btrfs_fs_info *fs_info,
 }
 
 static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
-				    struct find_free_extent_ctl *ffe_ctl)
+				    struct find_free_extent_ctl *ffe_ctl,
+				    struct btrfs_space_info *space_info)
 {
 	if (ffe_ctl->for_treelog) {
 		spin_lock(&fs_info->treelog_bg_lock);
@@ -4248,6 +4249,7 @@ static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
 			u64 avail = block_group->zone_capacity - block_group->alloc_offset;
 
 			if (block_group_bits(block_group, ffe_ctl->flags) &&
+			    block_group->space_info == space_info &&
 			    avail >= ffe_ctl->num_bytes) {
 				ffe_ctl->hint_byte = block_group->start;
 				break;
@@ -4269,7 +4271,7 @@ static int prepare_allocation(struct btrfs_fs_info *fs_info,
 		return prepare_allocation_clustered(fs_info, ffe_ctl,
 						    space_info, ins);
 	case BTRFS_EXTENT_ALLOC_ZONED:
-		return prepare_allocation_zoned(fs_info, ffe_ctl);
+		return prepare_allocation_zoned(fs_info, ffe_ctl, space_info);
 	default:
 		BUG();
 	}
-- 
2.51.0




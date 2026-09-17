Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFCC3DD521;
	Thu, 17 Sep 2026 18:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789669028; cv=none; b=pV4R0CwM6Ec0rOsSntzSWj2nH1X9Ds0vpnaVLsEt80ME5b05fxpQOeFTXYwQvmJn0GjfRd9ogezLQr2YL2Lv4yX0gaWZPC6StRozeTssdIR2pXTi8bVnjRmKE3wn9ZXG4b+ked5Q4dCTlFpZdCHy0gNlR/GFqxKRY/rXr1zQbKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789669028; c=relaxed/simple;
	bh=5FtyTFHAza7da6myrYrMuM/jIXOb7eV18FPvQyGZvLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOsUkNJU1YPgqcb9/w+82fjqVdgq8+DXakkKcFNo0WGlVc1t9YYiopUZTdjXb008xFAZTQTuqk0N4IkgSuU+TCxVpUBZG951PPwdyTaE5dToio+O9hrs4BgHgZYVY7pBmSErAJ3umY2ZnqAeZd5Ls9AbjRDC+rJS2lCx2k7RO4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZmuIX/nS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZmuIX/nS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739931F000FF;
	Thu, 17 Sep 2026 18:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789669027;
	bh=KFPra3iW4uFKfPLbxXbe/hIeDq7ZD7Ji1nD1Z2HlatA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZmuIX/nSkO6kSV62WdlQ9ISFxVo74DbvyZH44JYfAF2EC2fFekHo6V7APek4olk21
	 UzAF3W65NQ3OrBniu12zwu911OjWl6zm9jDbDCub6+vBozKPXU+XcWMzRXYbJNNG4A
	 FyiSbwxP0/zDdDZMxG8muDzr5M3XyrRLb2zqJGC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0620/1102] btrfs: return proper negative error code for update_raid_extent_item()
Date: Thu, 17 Sep 2026 16:09:23 +0100
Message-ID: <20260917151555.637378467@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

[ Upstream commit a03fa65184545837d6461413275da71f30527385 ]

The function btrfs_abort_transaction() only accepts negative error code,
and have the macro VERIFY_NEGATIVE_ERROR() to verify that error code.

But inside update_raid_extent_item(), if there is such key found, we
return 1, breaking the negative error code scheme.

Furthermore if we hit some real error during the tree search, e.g. -EIO,
then the error code is always over-written to -EINVAL.

Fix both problems by following other call sites by overwriting @ret to
-ENOENT if the btrfs_search_slot() failed to locate the key.

This is very unlikely to hit, as we only enter update_raid_extent_item()
if there is a conflicting key already in the raid stripe tree.

This was reported by Sashiko when reviewing another patch.

Link: https://sashiko.dev/#/patchset/20260817021512.3010812-1-shuangpeng.kernel%40gmail.com
Fixes: 8c4cba2adbb0 ("btrfs: update stripe extents for existing logical addresses")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/raid-stripe-tree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
index 6b362763d5496..5b052c09360b1 100644
--- a/fs/btrfs/raid-stripe-tree.c
+++ b/fs/btrfs/raid-stripe-tree.c
@@ -94,8 +94,10 @@ static int update_raid_extent_item(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_search_slot(trans, trans->fs_info->stripe_root, key, path,
 				0, 1);
-	if (ret)
-		return (ret == 1 ? ret : -EINVAL);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret < 0)
+		return ret;
 
 	leaf = path->nodes[0];
 	slot = path->slots[0];
-- 
2.53.0




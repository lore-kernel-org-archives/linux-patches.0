Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CC422578A;
	Thu,  3 Jul 2025 14:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554488; cv=none; b=AFtQ6RJVFE7KshHs24iwr9Ua3ObZE8rL1Zvh0nuzUdC8jlhM6AAVBWe/KVDUkYJgngiLiE7K5yXqwedm8SQOwen5IGdjpjSIMWQfHcrTTRrixDBndiYcq4QAJdgC9T3YoreqINTZiuvaJysORdCnDKzbwv5fvHfaHO9QtJoeEi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554488; c=relaxed/simple;
	bh=qxoZ1HuXTRcx4N7vqh+YxTHlD6JvgklChiO+s/+kqVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moh95PMoXfo7KcVZnUmduW92K5R7IDxaFSaKUyCUS6+NywUlKgdd/am3nd7bKTlcIKt49OaqwEDN/6WRnLXTffiBcg87B8g30Cdx7HRixtyb+CjASuZoW/Wikn6kFEbLve/VNyyKC55XQkJWOszkNwCOw2no9ll4SXdC2TI8h0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QmtU2dP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmtU2dP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E18C4CEE3;
	Thu,  3 Jul 2025 14:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554488;
	bh=qxoZ1HuXTRcx4N7vqh+YxTHlD6JvgklChiO+s/+kqVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmtU2dP6IEHBUK6pvPBA5sxv4XSskEA2mPpEVhUisbomgijKUa5MXgNz2E14e5YrG
	 Jf0X++VadFo1YFIW2+D6E5gGmFUq4updaMJ6qqJrn4X6IOxRp9S8e3m68idYs+jHym
	 +RT0P6JP2pLbgMug+5SqBKGbjwTQk76pbT6y/Izo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Shapovalov <intelfx@intelfx.name>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 204/218] btrfs: do regular iput instead of delayed iput during extent map shrinking
Date: Thu,  3 Jul 2025 16:42:32 +0200
Message-ID: <20250703144004.379344109@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 15b3b3254d1453a8db038b7d44b311a2d6c71f98 ]

The extent map shrinker now runs in the system unbound workqueue and no
longer in kswapd context so it can directly do an iput() on inodes even
if that blocks or needs to acquire any lock (we aren't holding any locks
when requesting the delayed iput from the shrinker). So we don't need to
add a delayed iput, wake up the cleaner and delegate the iput() to the
cleaner, which also adds extra contention on the spinlock that protects
the delayed iputs list.

Reported-by: Ivan Shapovalov <intelfx@intelfx.name>
Tested-by: Ivan Shapovalov <intelfx@intelfx.name>
Link: https://lore.kernel.org/linux-btrfs/0414d690ac5680d0d77dfc930606cdc36e42e12f.camel@intelfx.name/
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 61477cb69a6fd..93043edc8ff93 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -1261,7 +1261,7 @@ static long btrfs_scan_root(struct btrfs_root *root, struct btrfs_em_shrink_ctx
 
 		min_ino = btrfs_ino(inode) + 1;
 		ctx->last_ino = btrfs_ino(inode);
-		btrfs_add_delayed_iput(inode);
+		iput(&inode->vfs_inode);
 
 		if (ctx->scanned >= ctx->nr_to_scan ||
 		    btrfs_fs_closing(inode->root->fs_info))
-- 
2.39.5




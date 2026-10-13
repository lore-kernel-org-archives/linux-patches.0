Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069384F3EAF;
	Tue, 13 Oct 2026 12:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893772; cv=none; b=pmIiuPDnUr8zmz2bkp3exAHOpcSWEWiQ+rjAwYRrcMSyQ7IwXb3WeY4homMyt4mtkM+/KAfU045lc8R0OPHKEVNTkC1NRlmTGxPepvQFf9uEtS2h1kRGERfOKsjbj6W4YGzuz8QJYaPMt7kzyBi+xPdImE8Znf4yMXA9TnV/7Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893772; c=relaxed/simple;
	bh=4IExvaIbMUdEK4KYOSWFwnEB7bOiNieKXzY+8baAOGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJ++qUZk7tg5YxGHs8aMymkTtYkP5VQKd397y+JK2b4tMkczREvRJk6kWsMZTkL9XK7V/97UgVUErOC39NWBaKIeZBpjIM+/EZYDI1hDANC7TTI9sYoCGFNqeQoDgoqnUw6rYxkL9rg0PQmuczsIVanR+YREazIDHeyxy9KbSDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwlcgAbJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwlcgAbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5535C1F000FF;
	Tue, 13 Oct 2026 12:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893770;
	bh=R2PfXleFELrp513Nmlyl7KW9uhj24JCCQ9+JZi60Zds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwlcgAbJC5TvQDZ0jUfB/i/nkN3ABbqNuItw30UVJy8kfEYM8RqkHOuXJEgGs/+l4
	 sKailrUEBVpxNALWcK75SXDHVr1E8dLrac68fiP1QcagZEITgmbrFtDlcnsP1FKi4y
	 P4Mibiuame1QCKU247Sph8a8+Y9ofvpUHeqoZ1NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Jain <asj@kernel.org>,
	Filipe Manana <fdmanana@suse.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 335/621] btrfs: only invalidate btree inode pages after all ebs are released
Date: Tue, 13 Oct 2026 13:35:30 +0200
Message-ID: <20261013112928.801917597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

[ Upstream commit 48aa5c0e2bb85dae61a6cb405094eb135c711a04 ]

In close_ctree(), we call invalidate_inode_pages2() to invalidate all
pages from btree inode.

But the problem is, it never returns 0, but always -EBUSY.

The problem is that we are still holding all the essential tree root
nodes, thus pages holding those tree blocks can not be invalidated thus
invalidate_inode_pages2() always returns -EBUSY.

This is also against the error cleanup path of open_ctree(), which
properly frees all root pointers before calling invalidate_inode_pages().

So fix the order by delaying invalidate_inode_pages2() until we have
freed all root pointers.

Reviewed-by: Anand Jain <asj@kernel.org>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 51a0e8399858 ("btrfs: skip global block reserve accounting for rescue mounts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5396f900d5f12..976c57e5d21d9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4412,13 +4412,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 
 	btrfs_put_block_group_cache(fs_info);
 
-	/*
-	 * we must make sure there is not any read request to
-	 * submit after we stopping all workers.
-	 */
-	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
-	btrfs_stop_all_workers(fs_info);
-
 	/* We shouldn't have any transaction open at this point */
 	warn_about_uncommitted_trans(fs_info);
 
@@ -4426,6 +4419,13 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	free_root_pointers(fs_info, true);
 	btrfs_free_fs_roots(fs_info);
 
+	/*
+	 * We must make sure there is not any read request to
+	 * submit after we stop all workers.
+	 */
+	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
+	btrfs_stop_all_workers(fs_info);
+
 	/*
 	 * We must free the block groups after dropping the fs_roots as we could
 	 * have had an IO error and have left over tree log blocks that aren't
-- 
2.53.0




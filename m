Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBA945D92D;
	Sat, 12 Sep 2026 10:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210091; cv=none; b=BJ4GujJsZyTVhUK1HMOXPj1l1AJmc+KqHECVjCC+B6bNWXqrqYAgUBG8F4dhEoLIUK5g0aF73mmIix507UP3LXFFmqlzg6GiHfgJwqTZJ5aZlUYHyXe4G0TLxkxBAaNIncdCtE2UL0UaLeJa2/LALzlgbeREyM7dnvGRxEUkevw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210091; c=relaxed/simple;
	bh=u/7/5DjNvdRrTu+qenTYrqROz2zsX5E3SDK/o2t7OSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5Au6/wneU4xGfWOqmhhI69E7x4W4sGOFSyIJZ4DGfziGvskcDHNSrE6Rw0/DQjW+lZ1LtqIhdAGBhf5FyNUw/LhC+V3Q+NgsThb63NfzHN35uQq7GOUUvjTIveEsfA/N8Rw1iaFq3igfD9DeQ2fgJEuB0PDqaXGcsHchRrmziE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NvwZQ7ve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvwZQ7ve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017AF1F000FF;
	Sat, 12 Sep 2026 10:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210089;
	bh=NldoUPAN8nm3C1TUZwJKCucLeXhaVCb+0updCuAKnJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvwZQ7veK9wsv0mEEr9RCA+ybJu5eRIHzmk14FYd1Q4lwIy1DWhpVxhBRFBmZfkcQ
	 WI7S2rfh24frL6ZX9iUaT98wibGHKcFBSp6g2njBWQj84FBKc+4tQ2Ob17uF8p9XqM
	 oFvdCg5EAFFIuPnKeUqs86TgpcoqHAw9TyZoKYiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0954/1518] hugetlbfs: release subpool on fill_super failure
Date: Sat, 12 Sep 2026 08:52:03 +0200
Message-ID: <20260912065645.038476517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 308ab73e97c87bd0e142b11758faab7f88d82854 ]

hugetlbfs_fill_super() allocates a hugepage subpool when size or min_size
mount options are specified.  hugepage_new_subpool() may also reserve huge
pages for min_size.

If root dentry creation fails after the subpool is created, the failure
path frees the subpool with kfree().  This bypasses hugepage_put_subpool()
and can leave min_size reservations charged.

Use hugepage_put_subpool() on the failure path, matching the normal
put_super path.

Link: https://lore.kernel.org/20260720021900.1376309-1-chenyichong@uniontech.com
Fixes: 7ca02d0ae586 ("hugetlbfs: accept subpool min_size mount option and setup accordingly")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hugetlbfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index f42548ee9083c..34ed9966f2ea8 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1433,7 +1433,8 @@ hugetlbfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto out_free;
 	return 0;
 out_free:
-	kfree(sbinfo->spool);
+	if (sbinfo->spool)
+		hugepage_put_subpool(sbinfo->spool);
 	kfree(sbinfo);
 	return -ENOMEM;
 }
-- 
2.53.0




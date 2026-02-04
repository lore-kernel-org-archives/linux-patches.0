Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D31423A71;
	Wed,  4 Feb 2026 15:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217566; cv=none; b=uDKAXQW2N+yv5L048Q2wma5e6XVoSrKsPR6VYc/beIOii731U0NRwot8cHL5RV62POwR4J0wfffrqvwwXzU65uCLVmiYCQGOgRXSlQw+Wm2N43mQIUmSHu+2fPtWUE18rxXJ/Je+hQDkg8wG8ba4MDGEnK2XwHMhjIMyrLwtZZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217566; c=relaxed/simple;
	bh=+3D83u3v9UhlKPz8f7AriLTdNXZ2PfysRxkWBra5kec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSasuoh2HoWqk6yAuAgqvKASZWiZyiBmRARtwGW1O+A/czeAJRL2ZehpX6GTaKNwkRCnlAb3VHo447SscKGcWcO4NqA6f/fNo14vzJU58mNMq0lYBhmLyDRjjd/AlxHJC1VKztwmMMc4/Ota7PDVykbPy4KTgZ1+ywypB7/oegU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aisucc9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aisucc9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE690C116C6;
	Wed,  4 Feb 2026 15:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217566;
	bh=+3D83u3v9UhlKPz8f7AriLTdNXZ2PfysRxkWBra5kec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aisucc9OLVY0yW/kiRZ4OXeSfiWiP2Aw8j8HikqFWDwCmhdfR4Eg2PU3KyZpGSu82
	 OfHjJnwBSsYo/22aiXDHsykd/ZFMvauogiCejF0ldil+1uhujcnaTmL9Kzopr5B05o
	 kun9hr8+0v3M3qU0emyRhkbW2kWqVVsmz8AWtAFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/280] btrfs: factor out check_removing_space_info() from btrfs_free_block_groups()
Date: Wed,  4 Feb 2026 15:36:33 +0100
Message-ID: <20260204143910.323382272@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

[ Upstream commit 1cfdbe0d53b27b4b4a4f4cf2a4e430bc65ba2ba5 ]

Factor out check_removing_space_info() from btrfs_free_block_groups(). It
sanity checks a to-be-removed space_info. There is no functional change.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: a11224a016d6 ("btrfs: fix memory leaks in create_space_info() error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 49 +++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 3295fb978a35b..797df5ddbcd12 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4145,6 +4145,32 @@ void btrfs_put_block_group_cache(struct btrfs_fs_info *info)
 	}
 }
 
+static void check_removing_space_info(struct btrfs_space_info *space_info)
+{
+	struct btrfs_fs_info *info = space_info->fs_info;
+
+	/*
+	 * Do not hide this behind enospc_debug, this is actually important and
+	 * indicates a real bug if this happens.
+	 */
+	if (WARN_ON(space_info->bytes_pinned > 0 || space_info->bytes_may_use > 0))
+		btrfs_dump_space_info(info, space_info, 0, 0);
+
+	/*
+	 * If there was a failure to cleanup a log tree, very likely due to an
+	 * IO failure on a writeback attempt of one or more of its extent
+	 * buffers, we could not do proper (and cheap) unaccounting of their
+	 * reserved space, so don't warn on bytes_reserved > 0 in that case.
+	 */
+	if (!(space_info->flags & BTRFS_BLOCK_GROUP_METADATA) ||
+	    !BTRFS_FS_LOG_CLEANUP_ERROR(info)) {
+		if (WARN_ON(space_info->bytes_reserved > 0))
+			btrfs_dump_space_info(info, space_info, 0, 0);
+	}
+
+	WARN_ON(space_info->reclaim_size > 0);
+}
+
 /*
  * Must be called only after stopping all workers, since we could have block
  * group caching kthreads running, and therefore they could race with us if we
@@ -4235,28 +4261,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 					struct btrfs_space_info,
 					list);
 
-		/*
-		 * Do not hide this behind enospc_debug, this is actually
-		 * important and indicates a real bug if this happens.
-		 */
-		if (WARN_ON(space_info->bytes_pinned > 0 ||
-			    space_info->bytes_may_use > 0))
-			btrfs_dump_space_info(info, space_info, 0, 0);
-
-		/*
-		 * If there was a failure to cleanup a log tree, very likely due
-		 * to an IO failure on a writeback attempt of one or more of its
-		 * extent buffers, we could not do proper (and cheap) unaccounting
-		 * of their reserved space, so don't warn on bytes_reserved > 0 in
-		 * that case.
-		 */
-		if (!(space_info->flags & BTRFS_BLOCK_GROUP_METADATA) ||
-		    !BTRFS_FS_LOG_CLEANUP_ERROR(info)) {
-			if (WARN_ON(space_info->bytes_reserved > 0))
-				btrfs_dump_space_info(info, space_info, 0, 0);
-		}
-
-		WARN_ON(space_info->reclaim_size > 0);
+		check_removing_space_info(space_info);
 		list_del(&space_info->list);
 		btrfs_sysfs_remove_space_info(space_info);
 	}
-- 
2.51.0




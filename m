Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0829D37F8AB;
	Wed, 21 Jan 2026 18:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019631; cv=none; b=fZnhg/MCDzwrNXkpcc6JZO533oW2tScfNIu2Vm/KcTKP8XFmvZxuE83KtEua7O4Vnme8Q7Y6qFuLNs1uXJRpseSM4ofJ8nyqWOpi1Durmw8E1clBD/w0H8UQGY5K7Dfl0X3+J3hvgUZV7q/UARBZUzEtS8EsWkdsEuaDsnFfcQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019631; c=relaxed/simple;
	bh=Q13g6Bym4MB7TRHtkbQQnV2rScJrpzmpR6nWPLbRxEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9HzstFaxA97JEpgd5FmCaEZcT3KjVocwH2IwHrCJaxXLPs3s0/zsSPtTsMlrkiVxHiHKryag9Z6O2L5V6QViJK2AYuJkkTspLawd5kILrA65sDJTvT8n94gmOtJkPQNO03tWl4yQf5LKOnZruVzthvAGzKhWNx2Rrafo6dGhfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=byVFxYUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="byVFxYUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B80C4CEF1;
	Wed, 21 Jan 2026 18:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019630;
	bh=Q13g6Bym4MB7TRHtkbQQnV2rScJrpzmpR6nWPLbRxEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=byVFxYUre06hR0av66cWJhNGKoKHQtL7sG6PsRZP0Jb+gVENENTPcTxJ4TeXiyCIO
	 O+oycqzjXPmFKRc959n08Q+uMvvIp4lOQZV80ZVr+c0rtTT9IXNRezYy0ITc8GE/u7
	 XY1SiKVsPUPXiOsQEm6SV7N6fdRx2hWiZ52pmTeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/139] btrfs: factor out check_removing_space_info() from btrfs_free_block_groups()
Date: Wed, 21 Jan 2026 19:14:36 +0100
Message-ID: <20260121181412.469014284@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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
index 83a196521670b..8dce7046940c4 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4416,6 +4416,32 @@ void btrfs_put_block_group_cache(struct btrfs_fs_info *info)
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
@@ -4517,28 +4543,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42CC368297;
	Wed, 28 Jan 2026 15:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614051; cv=none; b=LI9w7ycN9n75OcyNW4/wUJe512Wvp6jtIRFyOu6RXjTuCgJJlZW7mPJfVMF/+maZCQV3X2zQYbnU+6T8sxu0MCZiYgpkxuKtJaRo+maIfGeIqZXGeTRTbjn19IA02XnGIctq/Tl2y7R8zMTU1f3gCg78WF3idd9Uun/LWukmBHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614051; c=relaxed/simple;
	bh=QCdeRAO++ppzFEFAbQTFBcGhmaYEASILLPqczibm8Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmmf+Keku8mrrLWAZfu3rK0pC0d0Pr07HjhH6qGLO+qIUlMNNtWQg4MGHVHS6ydnfQ7apAbUm9pUZ2t9EOWCuU/M9sUy0gc0QpuRJp2qpbMrkv9Xy5ITlNPoYe5aY8rW6Cqam2yyh92irMUjkb81iakI0kEIiOozOESeQGf/0M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUAxC3MX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUAxC3MX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ECAC4CEF7;
	Wed, 28 Jan 2026 15:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614051;
	bh=QCdeRAO++ppzFEFAbQTFBcGhmaYEASILLPqczibm8Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUAxC3MXP9Jyj1+28EjL/rZbkUaFtUzU+MZO/wD3MVr35uDqIARmymwWh3d8EhKql
	 yIoOpgeArsYoOty0YvxmRhAEK52oLcSlgiV/gjW0CTlzIoNV96Vdan1pqBfGaEcOch
	 gJsFkDKD4nbW5hnMEAdvO/0n99fewy+Mw6DaUdes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/254] btrfs: factor out check_removing_space_info() from btrfs_free_block_groups()
Date: Wed, 28 Jan 2026 16:19:57 +0100
Message-ID: <20260128145345.468672714@linuxfoundation.org>
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
index 5a3a41c6d509f..18409b6beaedc 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4377,6 +4377,32 @@ void btrfs_put_block_group_cache(struct btrfs_fs_info *info)
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
@@ -4478,28 +4504,7 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
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




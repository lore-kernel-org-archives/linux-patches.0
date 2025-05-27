Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F7727D776;
	Tue, 27 May 2025 17:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366649; cv=none; b=nHPNZHGu1Pq58Bff55yb65fPun3n3GSk82TeOKAJda1geKwJpgqFYgNCvCUP/X439cE/YZgJ7OAZmOiNhAZqQI1sRLeJEjVEe8r9TgPRTfTKuwmjm/yrDlk/7IVFDgLYnC6VLw13xxZv/b03tak1FUehBFhGEOawa4AhnRj/r48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366649; c=relaxed/simple;
	bh=y4zcJmNDPx+cuvzqoiivT3r4JmWnUb/WLU1fmfTutDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KH0NXyv3pHjEB5PKy7Dzdw9yZKMtj1ekigu//zsYxyd6pgz4ryYeJIuuP0VMxbMLppxUxFaa1CE0+VjiuhWcZdchxmIwL13+4MlQ8V46GdklBpKVWcjhaSLNRDiIh0+uCkG5EjlAoGeUopJj7uXV5tpY/IyUGyU4caKkbAxvgAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlEw6P9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlEw6P9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FB6C4CEE9;
	Tue, 27 May 2025 17:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366649;
	bh=y4zcJmNDPx+cuvzqoiivT3r4JmWnUb/WLU1fmfTutDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlEw6P9Yq3FxDZswIn5zmkTTZuEh2shDoG8MAid8+NqANEofbtJVqllZGFWLO9Hy+
	 8G1+W4nCs1BOgrqYh6nLuoUBoNAjexx2BGeKpTpHSiAe/j+GJPNI/fdt5cyGUWRuVQ
	 PYeRes36rM6ipTmpXYUTjBALe2cjfHcppKiDFzkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 136/783] btrfs: run btrfs_error_commit_super() early
Date: Tue, 27 May 2025 18:18:53 +0200
Message-ID: <20250527162518.697175465@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit df94a342efb451deb0e32b495d1d6cd4bb3a1648 ]

[BUG]
Even after all the error fixes related the
"ASSERT(list_empty(&fs_info->delayed_iputs));" in close_ctree(), I can
still hit it reliably with my experimental 2K block size.

[CAUSE]
In my case, all the error is triggered after the fs is already in error
status.

I find the following call trace to be the cause of race:

           Main thread                       |     endio_write_workers
---------------------------------------------+---------------------------
close_ctree()                                |
|- btrfs_error_commit_super()                |
|  |- btrfs_cleanup_transaction()            |
|  |  |- btrfs_destroy_all_ordered_extents() |
|  |     |- btrfs_wait_ordered_roots()       |
|  |- btrfs_run_delayed_iputs()              |
|                                            | btrfs_finish_ordered_io()
|                                            | |- btrfs_put_ordered_extent()
|                                            |    |- btrfs_add_delayed_iput()
|- ASSERT(list_empty(delayed_iputs))         |
   !!! Triggered !!!

The root cause is that, btrfs_wait_ordered_roots() only wait for
ordered extents to finish their IOs, not to wait for them to finish and
removed.

[FIX]
Since btrfs_error_commit_super() will flush and wait for all ordered
extents, it should be executed early, before we start flushing the
workqueues.

And since btrfs_error_commit_super() now runs early, there is no need to
run btrfs_run_delayed_iputs() inside it, so just remove the
btrfs_run_delayed_iputs() call from btrfs_error_commit_super().

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ca821e5966bd3..e4eda8b0f9381 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4328,6 +4328,14 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	/* clear out the rbtree of defraggable inodes */
 	btrfs_cleanup_defrag_inodes(fs_info);
 
+	/*
+	 * Handle the error fs first, as it will flush and wait for all ordered
+	 * extents.  This will generate delayed iputs, thus we want to handle
+	 * it first.
+	 */
+	if (unlikely(BTRFS_FS_ERROR(fs_info)))
+		btrfs_error_commit_super(fs_info);
+
 	/*
 	 * Wait for any fixup workers to complete.
 	 * If we don't wait for them here and they are still running by the time
@@ -4418,9 +4426,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 			btrfs_err(fs_info, "commit super ret %d", ret);
 	}
 
-	if (BTRFS_FS_ERROR(fs_info))
-		btrfs_error_commit_super(fs_info);
-
 	kthread_stop(fs_info->transaction_kthread);
 	kthread_stop(fs_info->cleaner_kthread);
 
@@ -4543,10 +4548,6 @@ static void btrfs_error_commit_super(struct btrfs_fs_info *fs_info)
 	/* cleanup FS via transaction */
 	btrfs_cleanup_transaction(fs_info);
 
-	mutex_lock(&fs_info->cleaner_mutex);
-	btrfs_run_delayed_iputs(fs_info);
-	mutex_unlock(&fs_info->cleaner_mutex);
-
 	down_write(&fs_info->cleanup_work_sem);
 	up_write(&fs_info->cleanup_work_sem);
 }
-- 
2.39.5




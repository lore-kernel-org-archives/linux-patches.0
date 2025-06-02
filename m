Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7D8230BD9;
	Mon,  2 Jun 2025 15:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876724; cv=none; b=Y77meRkvXluS0bgqKLSFPDCzWaqVA1uy/eMi2tY/gLYdPX8LxS4f0eQRoyUdisENsMs4QgCRy3m0/cNNccpnjMt/2hK2SQJE1QP6USyGIh/XZW2/ZJnanvXpmlW6z2MdsnwnFBqYWk/h2nrkTn/qAK5dnAlwdhxOsvykksAN5pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876724; c=relaxed/simple;
	bh=a1maBjJ89L4+5wRlRHVMfZyG/gWb5+ThfNEZLPsK/LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ey7CPW3MgPr/3Pl8kbu7gfYWgysdV1zXcDbNlI8d1MIkc+XKlHIGqtfb1S6pzkms2kK4RtvJgT3iS/Z3P59pDADyX4qrK9VN8QLOlWeAVPx7WO+NLI/zrMVZVRHHIifFOhkmtz1ILtHmogE2Su0IyJMYE4QXAW+u/JOUYLxfaGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmGpLhk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmGpLhk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB9EC4CEEB;
	Mon,  2 Jun 2025 15:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876723;
	bh=a1maBjJ89L4+5wRlRHVMfZyG/gWb5+ThfNEZLPsK/LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmGpLhk2/VGwUkwRSWDk0VFPnVGfnUDFpuIoFhNV7RVK47G+/gsw3m7RsKVDxsmUv
	 ZqZB0jzBXbqVqdbAM2c10BkVZJMB9/JA3SuqGIjHjTflOFf5hHh8u1zJCEwqm+7UbU
	 9sq2qFuNvLt6kFKQlGNl3Qy8+Yxq89ZjNZv31EBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/325] btrfs: fix non-empty delayed iputs list on unmount due to async workers
Date: Mon,  2 Jun 2025 15:45:30 +0200
Message-ID: <20250602134321.959863998@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit cda76788f8b0f7de3171100e3164ec1ce702292e ]

At close_ctree() after we have ran delayed iputs either explicitly through
calling btrfs_run_delayed_iputs() or later during the call to
btrfs_commit_super() or btrfs_error_commit_super(), we assert that the
delayed iputs list is empty.

We have (another) race where this assertion might fail because we have
queued an async write into the fs_info->workers workqueue. Here's how it
happens:

1) We are submitting a data bio for an inode that is not the data
   relocation inode, so we call btrfs_wq_submit_bio();

2) btrfs_wq_submit_bio() submits a work for the fs_info->workers queue
   that will run run_one_async_done();

3) We enter close_ctree(), flush several work queues except
   fs_info->workers, explicitly run delayed iputs with a call to
   btrfs_run_delayed_iputs() and then again shortly after by calling
   btrfs_commit_super() or btrfs_error_commit_super(), which also run
   delayed iputs;

4) run_one_async_done() is executed in the work queue, and because there
   was an IO error (bio->bi_status is not 0) it calls btrfs_bio_end_io(),
   which drops the final reference on the associated ordered extent by
   calling btrfs_put_ordered_extent() - and that adds a delayed iput for
   the inode;

5) At close_ctree() we find that after stopping the cleaner and
   transaction kthreads the delayed iputs list is not empty, failing the
   following assertion:

      ASSERT(list_empty(&fs_info->delayed_iputs));

Fix this by flushing the fs_info->workers workqueue before running delayed
iputs at close_ctree().

David reported this when running generic/648, which exercises IO error
paths by using the DM error table.

Reported-by: David Sterba <dsterba@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6670188b9eb6b..8c0da0025bc71 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4669,6 +4669,19 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	 */
 	btrfs_flush_workqueue(fs_info->delalloc_workers);
 
+	/*
+	 * We can have ordered extents getting their last reference dropped from
+	 * the fs_info->workers queue because for async writes for data bios we
+	 * queue a work for that queue, at btrfs_wq_submit_bio(), that runs
+	 * run_one_async_done() which calls btrfs_bio_end_io() in case the bio
+	 * has an error, and that later function can do the final
+	 * btrfs_put_ordered_extent() on the ordered extent attached to the bio,
+	 * which adds a delayed iput for the inode. So we must flush the queue
+	 * so that we don't have delayed iputs after committing the current
+	 * transaction below and stopping the cleaner and transaction kthreads.
+	 */
+	btrfs_flush_workqueue(fs_info->workers);
+
 	/*
 	 * When finishing a compressed write bio we schedule a work queue item
 	 * to finish an ordered extent - btrfs_finish_compressed_write_work()
-- 
2.39.5




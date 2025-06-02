Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723151DE881;
	Mon,  2 Jun 2025 14:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873332; cv=none; b=fBvECBWTkXeDIs7kJ4sSqDewcUwLYQad2aKSVb+Q/3eAeISGfvKnzNtYuKT6ttOWZ1EFdYpe+udvzHilSkTq6Ta+zqkYuZ3/6Mq6IGNc7M8XruNpNXnCaJ8ZQqUcAcN8kLTDa5pJ8dE4YftkBDLmIIVCaavI8ojBMxbUGe3Km1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873332; c=relaxed/simple;
	bh=icP6gA02admpb+7oEGnojsDy1FeGQ16qgKN7vQ2fIC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARqTAdpaVQe93Jn+dNxbXlFtPA0EvtbCVyAKgQEs2gleNmjFGC40Rz0/+5D91Fg5KEecHRvk/0/EmquAvlC7oWIBGeBMsuVncdafJgmeYVUHHDQt5ao8Xw9B0NhrecySVxWfZRzaI6M2ifauzfB/tDxJu5uflWBOrr4Kapf9yDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRH3mqxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRH3mqxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7F2C4CEEB;
	Mon,  2 Jun 2025 14:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873332;
	bh=icP6gA02admpb+7oEGnojsDy1FeGQ16qgKN7vQ2fIC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRH3mqxWa6+qRYxaA/Lgm0teIVazuToyiPrnRbo8Fj2ORMncrE355h7BgZ+I2SlQ7
	 hI8udZvCPEEHe0QQxpup3wCbDiHP3zEk5s8K55Bn7QAfV/rZW3tHB4mJuIBFGN6hjf
	 uNUezz3W3rj8tx7Aot4CkTFluRJ5mGdePrnPUdWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/444] btrfs: fix non-empty delayed iputs list on unmount due to async workers
Date: Mon,  2 Jun 2025 15:42:22 +0200
Message-ID: <20250602134344.074684379@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1e1650012606e..34a30d61b470c 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4341,6 +4341,19 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
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




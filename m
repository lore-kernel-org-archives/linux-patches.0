Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F46256C7B;
	Thu, 17 Apr 2025 18:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916028; cv=none; b=ho3CrRZL3+8f8GG1htfG3gs477X9DV54EESepLWT1inC3XvCUyxJHlltzdCHLGbWhdSG03oKq/aOOs5miU0L2gpFZm5Z9+hlgQsYwwEc5U86mJkvJdVbq9suYCZ27RsoTRJSRDtsz97FrL8T19pQjWz/c1UlkU2nSff2qhHuEho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916028; c=relaxed/simple;
	bh=9lilJutzC3SdijP+R3V1dl29tNIGCbP9yINndBN9fYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pcZMjUw/kSJOlDCYyT0Q7eZzMtfHJvk1hRRYv2DnqBi5HY9hBZXi7EAB9bPsO5N4fJJb48MvxLChVlb5HDeV71sWfWzZHhRmyW7WivtbstXMoNXB/4s+3BkJsyK8TisMSWgIKE1qKePGauAmpwy5QNz1NgmW/Hi3FJtcRvKDJKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9Yxk1Rs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9Yxk1Rs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB884C4CEE4;
	Thu, 17 Apr 2025 18:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916028;
	bh=9lilJutzC3SdijP+R3V1dl29tNIGCbP9yINndBN9fYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9Yxk1RskQCr1S6WUvnJVss3JMa7hRihGmDO+H+E9Nu+hvCyxNm0a1QvfAabXX7Zp
	 8JDXENqETbFliEsmuIot2vbWMwZgvGcqBcRL2G6DZgKzdD8Nmlef07cqZtpc9pUYpg
	 F9nxraOkJM/EmFHt2e9Tsln0Lye/KpxI9sA1wPiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 290/393] btrfs: fix non-empty delayed iputs list on unmount due to compressed write workers
Date: Thu, 17 Apr 2025 19:51:39 +0200
Message-ID: <20250417175119.277939034@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

commit 4c782247b89376a83fa132f7d45d6977edae0629 upstream.

At close_ctree() after we have ran delayed iputs either through explicitly
calling btrfs_run_delayed_iputs() or later during the call to
btrfs_commit_super() or btrfs_error_commit_super(), we assert that the
delayed iputs list is empty.

When we have compressed writes this assertion may fail because delayed
iputs may have been added to the list after we last ran delayed iputs.
This happens like this:

1) We have a compressed write bio executing;

2) We enter close_ctree() and flush the fs_info->endio_write_workers
   queue which is the queue used for running ordered extent completion;

3) The compressed write bio finishes and enters
   btrfs_finish_compressed_write_work(), where it calls
   btrfs_finish_ordered_extent() which in turn calls
   btrfs_queue_ordered_fn(), which queues a work item in the
   fs_info->endio_write_workers queue that we have flushed before;

4) At close_ctree() we proceed, run all existing delayed iputs and
   call btrfs_commit_super() (which also runs delayed iputs), but before
   we run the following assertion below:

      ASSERT(list_empty(&fs_info->delayed_iputs))

   A delayed iput is added by the step below...

5) The ordered extent completion job queued in step 3 runs and results in
   creating a delayed iput when dropping the last reference of the ordered
   extent (a call to btrfs_put_ordered_extent() made from
   btrfs_finish_one_ordered());

6) At this point the delayed iputs list is not empty, so the assertion at
   close_ctree() fails.

Fix this by flushing the fs_info->compressed_write_workers queue at
close_ctree() before flushing the fs_info->endio_write_workers queue,
respecting the queue dependency as the later is responsible for the
execution of ordered extent completion.

CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4275,6 +4275,18 @@ void __cold close_ctree(struct btrfs_fs_
 	btrfs_flush_workqueue(fs_info->delalloc_workers);
 
 	/*
+	 * When finishing a compressed write bio we schedule a work queue item
+	 * to finish an ordered extent - btrfs_finish_compressed_write_work()
+	 * calls btrfs_finish_ordered_extent() which in turns does a call to
+	 * btrfs_queue_ordered_fn(), and that queues the ordered extent
+	 * completion either in the endio_write_workers work queue or in the
+	 * fs_info->endio_freespace_worker work queue. We flush those queues
+	 * below, so before we flush them we must flush this queue for the
+	 * workers of compressed writes.
+	 */
+	flush_workqueue(fs_info->compressed_write_workers);
+
+	/*
 	 * After we parked the cleaner kthread, ordered extents may have
 	 * completed and created new delayed iputs. If one of the async reclaim
 	 * tasks is running and in the RUN_DELAYED_IPUTS flush state, then we



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17C329DB62;
	Wed, 23 Apr 2025 15:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421481; cv=none; b=ob46fSHnbfCzV32ZOXqL+ULJt3HNxAlRtIi/zCsjnJxgLhQxD1JY2ZnXi7t9RbTZgH7v2N3mjxEhyU/ssPoPZ/sJYHf8sgw1DJ1OPuJw4zy23FkCBVWoy2P5iktM14zG9GGRARbxOTcGoggu1IbDYcuQciSu5blwfRtsq4dcRNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421481; c=relaxed/simple;
	bh=0Ur5enve2dh+3rCchzTlz5nf0DwtdyIIzqbC4KBTG0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpjP+Z3I02NSXpG7D2YaHKw5cBu78ml4Whix97Y54Cq054wv/f2ImxIJ6m090B3F4rJLhenupFY4pA4yhNi9I+xidD5CPvjNsK69lS967dvX0xh6HdpICxYK2BOyTBDqpN/HA+LBJjQv0TX/UwdjHNa03Q+4FikwggXmmcCwqQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q+nC5f5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q+nC5f5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F6BC4CEE2;
	Wed, 23 Apr 2025 15:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421481;
	bh=0Ur5enve2dh+3rCchzTlz5nf0DwtdyIIzqbC4KBTG0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q+nC5f5eHIxAL/wY1WZl2M1vrurHZmmUp8gAY3l/UmvfwBWKqmTBWdp/iyBoVsYMy
	 4ES7W8QMVD8bzeyCKkQrEgNWXW8cAWiPYBBGkzBGiMkaxNssb+5EBqxhlQwwRalFL2
	 xhzxnxCd4Vwy7P2HNJBsErpDWL0vxtlee/LfGhM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 183/393] btrfs: fix non-empty delayed iputs list on unmount due to compressed write workers
Date: Wed, 23 Apr 2025 16:41:19 +0200
Message-ID: <20250423142650.935311588@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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
@@ -4334,6 +4334,18 @@ void __cold close_ctree(struct btrfs_fs_
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



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6105C2561A2;
	Thu, 17 Apr 2025 18:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913449; cv=none; b=XV70wy62S7hzbqCS+5JKUOGYTNd8+NWJcngwHJyskXM+b5sM8JwTdkgKkLHkEyH8e/OpCMbAQu7PD8VW/etO3bfgwpd/LFPWUpwT6CeP1heUe7sYYfrKWGkJVLX5fIIQiVEPwaIEiNeeOO2WAfI8jSi5tw0O8Dwuk3cx20YkajA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913449; c=relaxed/simple;
	bh=vj1d9KdFv4M1mv3xwsX+SWM9rB5vijeBtY4uasyAldU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YAIZfHffqW5p3lp8YwCZGOw2ufDBO99PZ7fBi2YUw6hXFVS+lcSRZVBcThBN/PFOqDi+Ba7PBTskGKAX5A+gKWta5qeHLoDXPXVGIWny5MRQ1RLlaI2SiqKtR1R/RkGWInmzuS4p717NBYCUlAvrA69l8G+CcnqGt5EmfMHRxkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lgsPfnIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lgsPfnIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E907CC4CEE7;
	Thu, 17 Apr 2025 18:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913449;
	bh=vj1d9KdFv4M1mv3xwsX+SWM9rB5vijeBtY4uasyAldU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgsPfnIeovMemXBdIqczGkRax6trHXrPT3XVvfUHYpBUovm/yw5YkP6gEab/lLAQn
	 /Ub0+DYT6Uv1ouCyvPkH2QaUxKIl9Eg43byxxBdMAlzq6LwtbIn1R3fxyjTGY0SofR
	 9Oojbr0uB6IF6IFhpr5Cfd6dx6amXNs7aIdZ0s6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.14 343/449] btrfs: fix non-empty delayed iputs list on unmount due to compressed write workers
Date: Thu, 17 Apr 2025 19:50:31 +0200
Message-ID: <20250417175132.006175627@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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
@@ -4349,6 +4349,18 @@ void __cold close_ctree(struct btrfs_fs_
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



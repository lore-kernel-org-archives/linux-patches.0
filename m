Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D5B15821E;
	Tue, 23 Jul 2024 18:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759822; cv=none; b=IAI5S3V/tYAKohp8YbsiZLmYjBF8DWBCrT5vDmGU5XfOwOyCqKQPWMcGZ/NZrXISzDBM/XVuc5Cy9wQXYaryTpufinlZvRsZYLfDDKUfhzyEru6RIvE9D852WNn6jo9e5KCU8fJ9mUskhyM5w4p0ZMXr99i44pmt17FFxyeymoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759822; c=relaxed/simple;
	bh=OTcnjhT7WhE2nIxFuB6jPgBOcBaVYUFOjuz3DbBRdtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNOMiqASDG6Kw3nH9wv3FGEVA4TX1350bEGx0OXZLmXyo/04ibIYvTQBVB6tTHWrg6BNc91AOH6QoaJSMIsIlSjDlM30xZGmA42hsa26XXlxb4rZD3GJff6F0mTT0Om35YT858q0mDaMPg/ZAS+0pP6R46hOhfiXnKlYZMweD74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNMGmaMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNMGmaMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1234C4AF0A;
	Tue, 23 Jul 2024 18:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759822;
	bh=OTcnjhT7WhE2nIxFuB6jPgBOcBaVYUFOjuz3DbBRdtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNMGmaMBsZX/LJgIvxmpIBCDZ4RW8mrphvrSnxDe8MlQI6rBioGLsyDP7ByYwx77Z
	 AEl/fp9FYhsrbg89Y1HwytgCXrtDM0+g9Ti0RBVw+Nnqkx6mgwWgBSDUoPMSqXFL6Y
	 8aL/82vsEJlOMdFiUGcA4EmWK09/lFMXX/A3d7p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 010/163] btrfs: ensure fast fsync waits for ordered extents after a write failure
Date: Tue, 23 Jul 2024 20:22:19 +0200
Message-ID: <20240723180143.865291137@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit f13e01b89daf42330a4a722f451e48c3e2edfc8d ]

If a write path in COW mode fails, either before submitting a bio for the
new extents or an actual IO error happens, we can end up allowing a fast
fsync to log file extent items that point to unwritten extents.

This is because dropping the extent maps happens when completing ordered
extents, at btrfs_finish_one_ordered(), and the completion of an ordered
extent is executed in a work queue.

This can result in a fast fsync to start logging file extent items based
on existing extent maps before the ordered extents complete, therefore
resulting in a log that has file extent items that point to unwritten
extents, resulting in a corrupt file if a crash happens after and the log
tree is replayed the next time the fs is mounted.

This can happen for both direct IO writes and buffered writes.

For example consider a direct IO write, in COW mode, that fails at
btrfs_dio_submit_io() because btrfs_extract_ordered_extent() returned an
error:

1) We call btrfs_finish_ordered_extent() with the 'uptodate' parameter
   set to false, meaning an error happened;

2) That results in marking the ordered extent with the BTRFS_ORDERED_IOERR
   flag;

3) btrfs_finish_ordered_extent() queues the completion of the ordered
   extent - so that btrfs_finish_one_ordered() will be executed later in
   a work queue. That function will drop extent maps in the range when
   it's executed, since the extent maps point to unwritten locations
   (signaled by the BTRFS_ORDERED_IOERR flag);

4) After calling btrfs_finish_ordered_extent() we keep going down the
   write path and unlock the inode;

5) After that a fast fsync starts and locks the inode;

6) Before the work queue executes btrfs_finish_one_ordered(), the fsync
   task sees the extent maps that point to the unwritten locations and
   logs file extent items based on them - it does not know they are
   unwritten, and the fast fsync path does not wait for ordered extents
   to complete, which is an intentional behaviour in order to reduce
   latency.

For the buffered write case, here's one example:

1) A fast fsync begins, and it starts by flushing delalloc and waiting for
   the writeback to complete by calling filemap_fdatawait_range();

2) Flushing the dellaloc created a new extent map X;

3) During the writeback some IO error happened, and at the end io callback
   (end_bbio_data_write()) we call btrfs_finish_ordered_extent(), which
   sets the BTRFS_ORDERED_IOERR flag in the ordered extent and queues its
   completion;

4) After queuing the ordered extent completion, the end io callback clears
   the writeback flag from all pages (or folios), and from that moment the
   fast fsync can proceed;

5) The fast fsync proceeds sees extent map X and logs a file extent item
   based on extent map X, resulting in a log that points to an unwritten
   data extent - because the ordered extent completion hasn't run yet, it
   happens only after the logging.

To fix this make btrfs_finish_ordered_extent() set the inode flag
BTRFS_INODE_NEEDS_FULL_SYNC in case an error happened for a COW write,
so that a fast fsync will wait for ordered extent completion.

Note that this issues of using extent maps that point to unwritten
locations can not happen for reads, because in read paths we start by
locking the extent range and wait for any ordered extents in the range
to complete before looking for extent maps.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/btrfs_inode.h  | 10 ++++++++++
 fs/btrfs/file.c         | 16 ++++++++++++++++
 fs/btrfs/ordered-data.c | 31 +++++++++++++++++++++++++++++++
 3 files changed, 57 insertions(+)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 100020ca4658e..787ca2892d7a6 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -89,6 +89,16 @@ enum {
 	BTRFS_INODE_FREE_SPACE_INODE,
 	/* Set when there are no capabilities in XATTs for the inode. */
 	BTRFS_INODE_NO_CAP_XATTR,
+	/*
+	 * Set if an error happened when doing a COW write before submitting a
+	 * bio or during writeback. Used for both buffered writes and direct IO
+	 * writes. This is to signal a fast fsync that it has to wait for
+	 * ordered extents to complete and therefore not log extent maps that
+	 * point to unwritten extents (when an ordered extent completes and it
+	 * has the BTRFS_ORDERED_IOERR flag set, it drops extent maps in its
+	 * range).
+	 */
+	BTRFS_INODE_COW_WRITE_ERROR,
 };
 
 /* in memory btrfs inode */
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f9d76072398da..97f6133b6eee8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1875,6 +1875,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	 */
 	if (full_sync || btrfs_is_zoned(fs_info)) {
 		ret = btrfs_wait_ordered_range(inode, start, len);
+		clear_bit(BTRFS_INODE_COW_WRITE_ERROR, &BTRFS_I(inode)->runtime_flags);
 	} else {
 		/*
 		 * Get our ordered extents as soon as possible to avoid doing
@@ -1884,6 +1885,21 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		btrfs_get_ordered_extents_for_logging(BTRFS_I(inode),
 						      &ctx.ordered_extents);
 		ret = filemap_fdatawait_range(inode->i_mapping, start, end);
+		if (ret)
+			goto out_release_extents;
+
+		/*
+		 * Check and clear the BTRFS_INODE_COW_WRITE_ERROR now after
+		 * starting and waiting for writeback, because for buffered IO
+		 * it may have been set during the end IO callback
+		 * (end_bbio_data_write() -> btrfs_finish_ordered_extent()) in
+		 * case an error happened and we need to wait for ordered
+		 * extents to complete so that any extent maps that point to
+		 * unwritten locations are dropped and we don't log them.
+		 */
+		if (test_and_clear_bit(BTRFS_INODE_COW_WRITE_ERROR,
+				       &BTRFS_I(inode)->runtime_flags))
+			ret = btrfs_wait_ordered_range(inode, start, len);
 	}
 
 	if (ret)
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index c2a42bcde98e0..7dbf4162c75a5 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -382,6 +382,37 @@ bool btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
 	ret = can_finish_ordered_extent(ordered, page, file_offset, len, uptodate);
 	spin_unlock_irqrestore(&inode->ordered_tree_lock, flags);
 
+	/*
+	 * If this is a COW write it means we created new extent maps for the
+	 * range and they point to unwritten locations if we got an error either
+	 * before submitting a bio or during IO.
+	 *
+	 * We have marked the ordered extent with BTRFS_ORDERED_IOERR, and we
+	 * are queuing its completion below. During completion, at
+	 * btrfs_finish_one_ordered(), we will drop the extent maps for the
+	 * unwritten extents.
+	 *
+	 * However because completion runs in a work queue we can end up having
+	 * a fast fsync running before that. In the case of direct IO, once we
+	 * unlock the inode the fsync might start, and we queue the completion
+	 * before unlocking the inode. In the case of buffered IO when writeback
+	 * finishes (end_bbio_data_write()) we queue the completion, so if the
+	 * writeback was triggered by a fast fsync, the fsync might start
+	 * logging before ordered extent completion runs in the work queue.
+	 *
+	 * The fast fsync will log file extent items based on the extent maps it
+	 * finds, so if by the time it collects extent maps the ordered extent
+	 * completion didn't happen yet, it will log file extent items that
+	 * point to unwritten extents, resulting in a corruption if a crash
+	 * happens and the log tree is replayed. Note that a fast fsync does not
+	 * wait for completion of ordered extents in order to reduce latency.
+	 *
+	 * Set a flag in the inode so that the next fast fsync will wait for
+	 * ordered extents to complete before starting to log.
+	 */
+	if (!uptodate && !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
+		set_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flags);
+
 	if (ret)
 		btrfs_queue_ordered_fn(ordered);
 	return ret;
-- 
2.43.0




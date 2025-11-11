Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F073726D4C7;
	Tue, 11 Nov 2025 01:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824698; cv=none; b=rcVM8aJUoanOYnFvxVbvP1g984i8bl3mfmux6HKQrVcSmtkClXM6QmOssCPk0504OULr5yVy6RqYGRA30UNCKgOGdTrCMvOlxQXrzPxXboURfamRqZuIkLnRQVW4Pj031mj+m1qFp8SNVR9r3AOWuYRNsQdt0z5Pm2eIxZ4fqXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824698; c=relaxed/simple;
	bh=bhFDN3PWoj8/3OXaqyoO1CCY7Aj/ZdVs77DZl7y9SeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3GVDv+zWfB/OFfhd/zfLJHRcsGpEzztQx7r01fEBxesTxcCBOveBTh4FCXkRBSrTCFGZlO4y76uMBaIuni3Z1I31UGPZM54ej+2Bj5iSe0Tl8jRVE76T+l3Qx1/mtf2Y+rWFgsWeRVSnBJLpOju3Fonh2SL7QH4xizbo9gPOew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWJLrIjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWJLrIjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926CFC4CEFB;
	Tue, 11 Nov 2025 01:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824697;
	bh=bhFDN3PWoj8/3OXaqyoO1CCY7Aj/ZdVs77DZl7y9SeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWJLrIjM/bGiHWey+Wf9yZlLb7SlInyVUs51J7Gl9Y0zv5X8XDEWC0W9X/WekuOOf
	 3wfaNAPag5FMhkQGawxnc47zKtU9RmA4SXCgznG2hPjF3PiRE9DOsR6buhZhJc38YC
	 aYVtMNKGDGlT1W8vBZVg/e3VRy3A50kIqJM+H8Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.12 500/565] btrfs: ensure no dirty metadata is written back for an fs with errors
Date: Tue, 11 Nov 2025 09:45:56 +0900
Message-ID: <20251111004538.188042778@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit 2618849f31e7cf51fadd4a5242458501a6d5b315 upstream.

[BUG]
During development of a minor feature (make sure all btrfs_bio::end_io()
is called in task context), I noticed a crash in generic/388, where
metadata writes triggered new works after btrfs_stop_all_workers().

It turns out that it can even happen without any code modification, just
using RAID5 for metadata and the same workload from generic/388 is going
to trigger the use-after-free.

[CAUSE]
If btrfs hits an error, the fs is marked as error, no new
transaction is allowed thus metadata is in a frozen state.

But there are some metadata modifications before that error, and they are
still in the btree inode page cache.

Since there will be no real transaction commit, all those dirty folios
are just kept as is in the page cache, and they can not be invalidated
by invalidate_inode_pages2() call inside close_ctree(), because they are
dirty.

And finally after btrfs_stop_all_workers(), we call iput() on btree
inode, which triggers writeback of those dirty metadata.

And if the fs is using RAID56 metadata, this will trigger RMW and queue
new works into rmw_workers, which is already stopped, causing warning
from queue_work() and use-after-free.

[FIX]
Add a special handling for write_one_eb(), that if the fs is already in
an error state, immediately mark the bbio as failure, instead of really
submitting them.

Then during close_ctree(), iput() will just discard all those dirty
tree blocks without really writing them back, thus no more new jobs for
already stopped-and-freed workqueues.

The extra discard in write_one_eb() also acts as an extra safenet.
E.g. the transaction abort is triggered by some extent/free space
tree corruptions, and since extent/free space tree is already corrupted
some tree blocks may be allocated where they shouldn't be (overwriting
existing tree blocks). In that case writing them back will further
corrupting the fs.

CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1882,6 +1882,14 @@ static noinline_for_stack void write_one
 			folio_unlock(folio);
 		}
 	}
+	/*
+	 * If the fs is already in error status, do not submit any writeback
+	 * but immediately finish it.
+	 */
+	if (unlikely(BTRFS_FS_ERROR(fs_info))) {
+		btrfs_bio_end_io(bbio, errno_to_blk_status(BTRFS_FS_ERROR(fs_info)));
+		return;
+	}
 	btrfs_submit_bbio(bbio, 0);
 }
 



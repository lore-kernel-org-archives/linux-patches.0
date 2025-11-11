Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC80E334C39;
	Tue, 11 Nov 2025 01:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825298; cv=none; b=SYvUMVXWKWm9mXkoWYNNwLTshHzWe8OtQB7HZsYBHTnSju3dKlHZ7RKlEd77EfaNk5hvV3lscfaNG/ItlvCQjJ51IbzSPVXY3HzoRfYcJRAhZKMZoBKUo8XBe+0MmzG/Vk9TWYXSd7gW2N2A6rQ3pI3FaftTv9JarQrOfDNT7gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825298; c=relaxed/simple;
	bh=02RkV+t2o9Krzs5IMWRrj56xDQ1aOXGmmhSc24S5YME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlUsgk8V68URc+BHvGvbzXVOhcM5n6Mn12Q6rVZ6iD9IItprhgZLVSadzl+Rq1l0zHcxdPNeMgUlGj8gVlMUgtOCpoJADlmybe+3317Ko+C9RS48ZJEEwGTtFQV0bQnnqtRLEellJCGLTBEomxhrgahP47D4O9rLn3zWIdwUiTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SD0LZYH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SD0LZYH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BD4C116B1;
	Tue, 11 Nov 2025 01:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825297;
	bh=02RkV+t2o9Krzs5IMWRrj56xDQ1aOXGmmhSc24S5YME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SD0LZYH/uC7u7SDKNYrXzjGFDK9dEWMJQJj6btLV1jv5NkUuYOJ2XfRz/bMLOgh3n
	 UOK8qkCDIPsxL9veR16/WSho+A0GeSIrpa5H6PIaeMt+Kqv5QCIMZ4WaWrwRKXioGc
	 6tBz88UD6gdBG46CPdPQiF50sy500JGap/PW4qT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.17 742/849] btrfs: ensure no dirty metadata is written back for an fs with errors
Date: Tue, 11 Nov 2025 09:45:12 +0900
Message-ID: <20251111004554.377344728@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2167,6 +2167,14 @@ static noinline_for_stack void write_one
 		wbc_account_cgroup_owner(wbc, folio, range_len);
 		folio_unlock(folio);
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
 



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DD82D73B0;
	Fri, 21 Nov 2025 13:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733592; cv=none; b=Cp/iXQYIgtUTIBpMvJPE1ywfFnzOLWcyzp+q2unh1leY4DeAu/fj1paHmPGgndCr5sOO/baXKGruaGpQVoHB4dA0rZdpWLonYIP5/Fp/NvP5wX/IKh+1k0Z+PRsf2C60fWTMhveaEFkwzZ3FW8f2BzIZcb4sngNCsTCO10BM0vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733592; c=relaxed/simple;
	bh=OaktdN7sQaucr+EbkR0UItVCnanBVB8Pg6lGwBsSruw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hl0DDKMV4AVOVQVMAFHlgMpCZ57yoSeyU+KcaqCGUqP53JF/kQQfP/fyobtNUnppl+P9ZGpVnrLZKc7s4Ze1RxbisUB5+o6k+8XvQl6PEAz1b0cyVMt9Q1hkQPGU8y+n8b+JwtXBfgLkNpb8Hvw/evJtdJiuj1TDH3UJqffRN0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shCOt52Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shCOt52Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA343C4CEF1;
	Fri, 21 Nov 2025 13:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733592;
	bh=OaktdN7sQaucr+EbkR0UItVCnanBVB8Pg6lGwBsSruw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=shCOt52ZdeLHfOvgqlLcMR9/IwAXMSk6UG+uF5SIIjMKvwwl8TbH53kFCTsJdnJCr
	 QnD8GJ3FBuBmnBj21RMdy6mULgWmZ8ro9kioaFpkSdrOO3Aydk23+rioQjoOMn37Ij
	 igGVtoW6+9Q+ai27d5gpy5s0WAS7Tt2npV9SVTM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 494/529] btrfs: ensure no dirty metadata is written back for an fs with errors
Date: Fri, 21 Nov 2025 14:13:13 +0100
Message-ID: <20251121130248.586791272@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 2618849f31e7cf51fadd4a5242458501a6d5b315 ]

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
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1751,6 +1751,14 @@ static noinline_for_stack void write_one
 			unlock_page(p);
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
 	btrfs_submit_bio(bbio, 0);
 }
 



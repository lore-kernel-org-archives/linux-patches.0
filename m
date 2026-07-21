Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1974231829;
	Tue, 21 Jul 2026 22:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672980; cv=none; b=NFSF0o0NkVSEfay9TqpLjIchsmDmrpf7BFt2cRc82sVtcn5Y5YFErnQ6Z6edD+QqWf9HhyFVsNtC4pOy1/LLYzNz7zN7WfVH2ZWqA8nYoEz+JXytS/Vu7eMyuOiqh1tNVaQPIXZdjGwGRUgYz5d2ZsX5qAmcDdyLVMfMMxbzYmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672980; c=relaxed/simple;
	bh=jXQwP4yDqdsf4NTfL3WFmtmpMC9BgTimI7oHaBkX59M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMnzXS/YFSD7EKmwsRzdtmpsCg183oJP7J2uUfXXjE913gt7MCgUeJ0IOTUcTksgPbueJt1/18EBHZkNdVjs8P6FlxHWsEPHO6TgdSIN9Js+ZBfbX/RAfnUf95tOnbok9RAdkoBX7qw7SlEU2ezKjMbTTYFxCW22brtbGb8ONBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLMReMRu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLMReMRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDB61F000E9;
	Tue, 21 Jul 2026 22:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672978;
	bh=6NcYB1JlIqm3lVPOkc8KLb+hsKv3fgpj/pKx7CohxYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gLMReMRuJVtalKuYJ0X5ZLHKokUPxFHRfkYq55fvjr2om1CxHHyxnVgz1LUOgZErT
	 y0otRzumEGuKfeicC+Yzn8kBzAs4a37VsP6ryfXxwHmiDjXBrSmTAjzPidT1G/7fwb
	 nnEWHE/1ihhvz+BKWrdJIwPhOoeizlvumOCy6WH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 830/843] btrfs: fix incorrect buffered IO fallback for append direct writes
Date: Tue, 21 Jul 2026 17:27:45 +0200
Message-ID: <20260721152424.748897876@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit ff66fe6662330226b3f486014c375538d91c44aa ]

[BUG]
With the previous bug of short direct writes fixed, test case
generic/362 (*) still fails with the following error with nodatasum
mount option:

# generic/362  0s ... - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
# - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
#    --- tests/generic/362.out	2024-08-24 15:31:37.200000000 +0930
#    +++ /home/adam/xfstests/results//generic/362.out.bad	2026-05-27 10:13:09.072485767 +0930
#    @@ -1,2 +1,3 @@
#     QA output created by 362
#    +Wrong file size after first write, got 8192 expected 4096
#     Silence is golden
#    ...

*: If the test case has been executed before with default data checksum,
the failure will not reproduce. Need the following fix to make it
reliably reproducible:
https://lore.kernel.org/linux-btrfs/20260528111659.87113-1-wqu@suse.com/

[CAUSE]
Inside btrfs_dio_iomap_begin() for a direct write, we increase the isize
if it's beyond the current isize.

But if the direct io finished short, we do not revert the isize to the
previous value nor to the short write end.

Then if we need to fall back to buffered writes, and the write has
IOCB_APPEND flag, then the buffered write will be positioned at the
incorrect isize.

The call chain looks like this:

 btrfs_direct_write(pos=0, length=4K)
 |- __iomap_dio_rw()
 |  |- iomap_iter()
 |  |  |- btrfs_dio_iomap_begin()
 |  |     |- btrfs_get_blocks_direct_write()
 |  |        |- i_size_write()
 |  |           Which updates the isize to the write end (4K).
 |  |
 |  |- iomap_dio_iter()
 |  |  Failed with -EFAULT on the first page.
 |  |
 |  |- iomap_iter()
 |  |  |- btrfs_dio_iomap_end()
 |  |     Detects a short write, return -ENOTBLK
 |  |- if (ret == -ENOTBLK) { ret = 0;}
 |     Which resets the return value.
 |
 |- ret = iomap_dio_complet()
 |  Which returns 0.
 |
 |- btrfs_buffered_write(iocb, from);
    |- generic_write_checks()
       |- iocb->ki_pos = i_size_read()
          Which is still the new size (4K), other than the original
	  isize 0.

[FIX]
Introduce the following btrfs_dio_data members:

- old_isize

- updated_isize
  If the direct write has enlarged the isize.

Then if we got a short write, and btrfs_dio_data::updated_isize is set,
revert to the correct isize based on old_isize and current file
position.

And here we call i_size_write() without holding an extent lock, which is
a very special case that we're safe to do:

 - Only a single writer can be enlarging isize
   Enlarging isize will take the exclusive inode lock.

 - Buffered readers need to wait for the OE we're holding
   Buffered readers will lock extent and wait for OE of the folio range.
   Sometimes we can skip the OE wait, but since all page cache is
   invalidated, the OE wait can not be skipped.

But I do not think this is the most elegant solution, nor covers all
cases. E.g. if the bio is submitted but IO failed, we are unable to do
the revert.

I believe the more elegant one would be extend the EXTENT_DIO_LOCKED
lifespan for direct writes, so that we can update the isize when a
write beyond EOF finished successfully.

However that change is too huge for a small bug fix.
So only implement the minimal partial fix for now.

[REASON FOR NO FIXES TAG]
The bug is again very old, before commit f85781fb505e ("btrfs: switch to
iomap for direct IO") we are already increasing isize without a
proper rollback for short writes.

Thus only a CC to stable.

CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |   43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -61,7 +61,9 @@ struct btrfs_iget_args {
 
 struct btrfs_dio_data {
 	ssize_t submitted;
+	loff_t old_isize;
 	struct extent_changeset *data_reserved;
+	bool updated_isize;
 };
 
 static const struct inode_operations btrfs_dir_inode_operations;
@@ -7904,6 +7906,7 @@ static int btrfs_get_blocks_direct_write
 	bool can_nocow = false;
 	bool space_reserved = false;
 	u64 prev_len;
+	loff_t old_isize;
 	int ret = 0;
 
 	/*
@@ -7997,8 +8000,14 @@ static int btrfs_get_blocks_direct_write
 	 * Need to update the i_size under the extent lock so buffered
 	 * readers will get the updated i_size when we unlock.
 	 */
-	if (start + len > i_size_read(inode))
+	old_isize = i_size_read(inode);
+	if (start + len > old_isize) {
+		if (!dio_data->updated_isize) {
+			dio_data->old_isize = old_isize;
+			dio_data->updated_isize = true;
+		}
 		i_size_write(inode, start + len);
+	}
 out:
 	if (ret && space_reserved) {
 		btrfs_delalloc_release_extents(BTRFS_I(inode), len);
@@ -8211,6 +8220,38 @@ static int btrfs_dio_iomap_end(struct in
 			struct btrfs_ordered_extent *ordered;
 
 			/*
+			 * Got a short write and have updated the isize, need to
+			 * revert the isize change.
+			 *
+			 * Normally we need to update isize with extent lock hold,
+			 * but we're safe due to the following factors:
+			 *
+			 * - Only a single writer can be enlarging isize
+			 *   Enlarging isize will take the exclusive inode lock.
+			 *
+			 * - Buffered readers need to wait for the OE we're holding
+			 *   Buffered readers will lock extent and wait for OE
+			 *   of the folio range, and since page cache is invalidated
+			 *   the OE wait can not be skipped.
+			 *
+			 * So here we are safe to revert the isize before
+			 * finishing the OE, and no reader of the remaining range
+			 * can see the enlarged size.
+			 *
+			 * TODO: Extend the DIO_LOCKED lifespan for direct writes,
+			 * and only enlarge isize after a successful write.
+			 */
+			if (dio_data->updated_isize) {
+				u64 new_isize;
+
+				if (submitted == 0)
+					new_isize = dio_data->old_isize;
+				else
+					new_isize = max(dio_data->old_isize, pos);
+				i_size_write(inode, new_isize);
+				dio_data->updated_isize = false;
+			}
+			/*
 			 * We have a short write. Any range that was properly
 			 * submitted will be finished through the bio
 			 * completion path with an uptodate status matching



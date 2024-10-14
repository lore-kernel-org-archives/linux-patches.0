Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BB43B298;
	Mon, 14 Oct 2024 15:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919544; cv=none; b=tBU/VlcA4NHF4gN27kXo5FRJiwpGX+fEPBU7emNgBnIHq11UCl3DfJS7+2sfi48PAW12pIWYBg70F/XlTYSCQD98eMod8kixD501ZZ81EhmHTaYkZd2dc9TCOXEU/BG8DdbFrpJCjKDXh572wjSyM9PUImM+bAL0/dDKIt1A/3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919544; c=relaxed/simple;
	bh=p75u0bzuxcyuJgdQM4uq6QWhi+3U3tuyT25NJnzcPQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5tpdvHl9lG2uOXHNMzeEKyC8FWFuxbWdiLLwwaZPeRmHdMqe7+IHwGdaC4zeZ0l2acr7LkvcbrFB5EiBjTB9RVUuEGRa88QWg1MoIVRDIj5sQkhEfxQ3NqImAb6nUAsZSF+nTzM3ouL9WGO9heosT0V9Z2iGd9OJ7cNzneGEvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrWNI8xc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrWNI8xc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BD0C4CEC3;
	Mon, 14 Oct 2024 15:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919544;
	bh=p75u0bzuxcyuJgdQM4uq6QWhi+3U3tuyT25NJnzcPQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrWNI8xc8vPt6/qnqpl/8z2dCjwN+GVHwFSnyCv10C+otmxIUJIWbgdpU8YCjodTC
	 HK//2jhbonNs0+sjukIAB8It8eWLNO5CpzbXE9TdIWPXjAidAFSlHI5geN1IO4SJmc
	 zmud+3ftsLZlL7/dGz+K3ELxKH7MgPzElAcVZJcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Millwood <thebenmachine@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 605/798] btrfs: send: fix invalid clone operation for file that got its size decreased
Date: Mon, 14 Oct 2024 16:19:19 +0200
Message-ID: <20241014141241.779057768@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit fa630df665aa9ddce3a96ce7b54e10a38e4d2a2b upstream.

During an incremental send we may end up sending an invalid clone
operation, for the last extent of a file which ends at an unaligned offset
that matches the final i_size of the file in the send snapshot, in case
the file had its initial size (the size in the parent snapshot) decreased
in the send snapshot. In this case the destination will fail to apply the
clone operation because its end offset is not sector size aligned and it
ends before the current size of the file.

Sending the truncate operation always happens when we finish processing an
inode, after we process all its extents (and xattrs, names, etc). So fix
this by ensuring the file has a valid size before we send a clone
operation for an unaligned extent that ends at the final i_size of the
file. The size we truncate to matches the start offset of the clone range
but it could be any value between that start offset and the final size of
the file since the clone operation will expand the i_size if the current
size is smaller than the end offset. The start offset of the range was
chosen because it's always sector size aligned and avoids a truncation
into the middle of a page, which results in dirtying the page due to
filling part of it with zeroes and then making the clone operation at the
receiver trigger IO.

The following test reproduces the issue:

  $ cat test.sh
  #!/bin/bash

  DEV=/dev/sdi
  MNT=/mnt/sdi

  mkfs.btrfs -f $DEV
  mount $DEV $MNT

  # Create a file with a size of 256K + 5 bytes, having two extents, one
  # with a size of 128K and another one with a size of 128K + 5 bytes.
  last_ext_size=$((128 * 1024 + 5))
  xfs_io -f -d -c "pwrite -S 0xab -b 128K 0 128K" \
         -c "pwrite -S 0xcd -b $last_ext_size 128K $last_ext_size" \
         $MNT/foo

  # Another file which we will later clone foo into, but initially with
  # a larger size than foo.
  xfs_io -f -c "pwrite -S 0xef 0 1M" $MNT/bar

  btrfs subvolume snapshot -r $MNT/ $MNT/snap1

  # Now resize bar and clone foo into it.
  xfs_io -c "truncate 0" \
         -c "reflink $MNT/foo" $MNT/bar

  btrfs subvolume snapshot -r $MNT/ $MNT/snap2

  rm -f /tmp/send-full /tmp/send-inc
  btrfs send -f /tmp/send-full $MNT/snap1
  btrfs send -p $MNT/snap1 -f /tmp/send-inc $MNT/snap2

  umount $MNT
  mkfs.btrfs -f $DEV
  mount $DEV $MNT

  btrfs receive -f /tmp/send-full $MNT
  btrfs receive -f /tmp/send-inc $MNT

  umount $MNT

Running it before this patch:

  $ ./test.sh
  (...)
  At subvol snap1
  At snapshot snap2
  ERROR: failed to clone extents to bar: Invalid argument

A test case for fstests will be sent soon.

Reported-by: Ben Millwood <thebenmachine@gmail.com>
Link: https://lore.kernel.org/linux-btrfs/CAJhrHS2z+WViO2h=ojYvBPDLsATwLbg+7JaNCyYomv0fUxEpQQ@mail.gmail.com/
Fixes: 46a6e10a1ab1 ("btrfs: send: allow cloning non-aligned extent if it ends at i_size")
CC: stable@vger.kernel.org # 6.11
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/send.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -5941,8 +5941,29 @@ static int send_write_or_clone(struct se
 	if (ret < 0)
 		return ret;
 
-	if (clone_root->offset + num_bytes == info.size)
+	if (clone_root->offset + num_bytes == info.size) {
+		/*
+		 * The final size of our file matches the end offset, but it may
+		 * be that its current size is larger, so we have to truncate it
+		 * to any value between the start offset of the range and the
+		 * final i_size, otherwise the clone operation is invalid
+		 * because it's unaligned and it ends before the current EOF.
+		 * We do this truncate to the final i_size when we finish
+		 * processing the inode, but it's too late by then. And here we
+		 * truncate to the start offset of the range because it's always
+		 * sector size aligned while if it were the final i_size it
+		 * would result in dirtying part of a page, filling part of a
+		 * page with zeroes and then having the clone operation at the
+		 * receiver trigger IO and wait for it due to the dirty page.
+		 */
+		if (sctx->parent_root != NULL) {
+			ret = send_truncate(sctx, sctx->cur_ino,
+					    sctx->cur_inode_gen, offset);
+			if (ret < 0)
+				return ret;
+		}
 		goto clone_data;
+	}
 
 write_data:
 	ret = send_extent_data(sctx, path, offset, num_bytes);



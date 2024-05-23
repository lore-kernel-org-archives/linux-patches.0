Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501381E504;
	Thu, 23 May 2024 13:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470400; cv=none; b=ELuQwSkH8lV2addtdW5w1j8G9VYcXcpxNjyWKQKSzFlmtLP7SGtiLCQr0yA8ato7+dun3wKjSj3w6mqr/SyWtfmK/yZlGs3sQPD0HcJkUwwFAYrvUKCGP+ZhwNY40vDxI3uKz50aKDybJXy/OSflBG+MNJR7gcYnXqHyZ+xWXQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470400; c=relaxed/simple;
	bh=LmUw0KQKcknYVdYJgOYbstn+3rTGBRb1eRTBRE0bpxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyIR4TQ5n+QrBT8Z/O/COtZKk9S1CrzYdwX+BsgaY+nWS4uEN+BZMvih8gmpFzT3R35hWaQV4j+lLFw6tG9C2rhcC9+6ud0XGPIkvZcASe5FpyYNfR2VV2mnZFai6nyceOaCgRfuNGvSDqJBSgjKdVXv+DM3IowAPzRBThNxN90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnO1vB4i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnO1vB4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96FFC3277B;
	Thu, 23 May 2024 13:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470400;
	bh=LmUw0KQKcknYVdYJgOYbstn+3rTGBRb1eRTBRE0bpxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnO1vB4ilwkSvT832VdkmKNREwGQmR+YJ37QAHNttI7B7GSlmUxLM+ubM9GnkDQkE
	 1zK6N3txnXKR5vGQuxOs9+vyOqiZB8T27xo9BUI2vnT7/C3X2434NCtUKbr2b1otb2
	 O7j0yVj4v7sEPNIMyrI43i730uPpTwfosLGmRCyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 23/45] xfs: invalidate block device page cache during unmount
Date: Thu, 23 May 2024 15:13:14 +0200
Message-ID: <20240523130333.371532357@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 032e160305f6872e590c77f11896fb28365c6d6c ]

Every now and then I see fstests failures on aarch64 (64k pages) that
trigger on the following sequence:

mkfs.xfs $dev
mount $dev $mnt
touch $mnt/a
umount $mnt
xfs_db -c 'path /a' -c 'print' $dev

99% of the time this succeeds, but every now and then xfs_db cannot find
/a and fails.  This turns out to be a race involving udev/blkid, the
page cache for the block device, and the xfs_db process.

udev is triggered whenever anyone closes a block device or unmounts it.
The default udev rules invoke blkid to read the fs super and create
symlinks to the bdev under /dev/disk.  For this, it uses buffered reads
through the page cache.

xfs_db also uses buffered reads to examine metadata.  There is no
coordination between xfs_db and udev, which means that they can run
concurrently.  Note there is no coordination between the kernel and
blkid either.

On a system with 64k pages, the page cache can cache the superblock and
the root inode (and hence the root dir) with the same 64k page.  If
udev spawns blkid after the mkfs and the system is busy enough that it
is still running when xfs_db starts up, they'll both read from the same
page in the pagecache.

The unmount writes updated inode metadata to disk directly.  The XFS
buffer cache does not use the bdev pagecache, nor does it invalidate the
pagecache on umount.  If the above scenario occurs, the pagecache no
longer reflects what's on disk, xfs_db reads the stale metadata, and
fails to find /a.  Most of the time this succeeds because closing a bdev
invalidates the page cache, but when processes race, everyone loses.

Fix the problem by invalidating the bdev pagecache after flushing the
bdev, so that xfs_db will see up to date metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_buf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1945,6 +1945,7 @@ xfs_free_buftarg(
 	list_lru_destroy(&btp->bt_lru);
 
 	blkdev_issue_flush(btp->bt_bdev);
+	invalidate_bdev(btp->bt_bdev);
 	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
 
 	kmem_free(btp);



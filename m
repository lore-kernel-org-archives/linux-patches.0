Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF001494D9;
	Fri,  6 Dec 2024 14:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733495965; cv=none; b=XhxFWTt3FPwPHBRyoO9+QGjrChYkI1nbd7bHBioSzLJ/gZ8myLhSFtoPQIUQOjTz30nv3/koiKLXOHueRtvIJwWzIGlvR4ZIdew0IMQzXqlq3jPbrRWBhDVfTULEL7LVHT/f5d/pv6cUqocIv8Lu/sK0g6kQrix9DBcf/2OMfWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733495965; c=relaxed/simple;
	bh=7JbMeVMZY6NLuzqvIuIKpaorQFkezHkFlMsYylqaW0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBBCE5A52aLbZ4ilMUs4JFrIitt5/MC6IpJVacbeHnyzARPUc3kuf2/2ZDbOqH9DkL7RZPLKHikQQ008L40uq9GXq7FNKb8IRxk/O5dy27Vrw/ikDihT6DHJMXzZkNhI4Xa8Oo0B7wcveN5u/HRxeTlPADhKCuhs7QEjI761ZeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1mNELh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1mNELh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9A7C4CED1;
	Fri,  6 Dec 2024 14:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733495965;
	bh=7JbMeVMZY6NLuzqvIuIKpaorQFkezHkFlMsYylqaW0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1mNELh5AaWyCnnSPSFNfzhohbFbBcPfWJcFOaL0rK6bjbS1UljZid6vdEaKMBGEW
	 6MMoAHxpcMia/wYR6GuL8RvlAjADZ8iDOW+QvtXWnAAyshV+wFFuPMOXH/+2oWVT2o
	 6sMOF2cCRTT4a+Y7KwRw9zcPf1uxh10uCqgEgjhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Harmstone <maharmstone@fb.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/146] btrfs: move priv off stack in btrfs_encoded_read_regular_fill_pages()
Date: Fri,  6 Dec 2024 15:35:36 +0100
Message-ID: <20241206143527.870210952@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <maharmstone@fb.com>

[ Upstream commit 68d3b27e05c7ca5545e88465f5e2be6eda0e11df ]

Change btrfs_encoded_read_regular_fill_pages() so that the priv struct
is allocated rather than stored on the stack, in preparation for adding
an asynchronous mode to the function.

Signed-off-by: Mark Harmstone <maharmstone@fb.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 05b36b04d74a ("btrfs: fix use-after-free in btrfs_encoded_read_endio()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9c4f1a3742f3f..857cbe9b07d28 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9136,16 +9136,21 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 					  struct page **pages)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	struct btrfs_encoded_read_private priv = {
-		.pending = ATOMIC_INIT(1),
-	};
+	struct btrfs_encoded_read_private *priv;
 	unsigned long i = 0;
 	struct btrfs_bio *bbio;
+	int ret;
 
-	init_waitqueue_head(&priv.wait);
+	priv = kmalloc(sizeof(struct btrfs_encoded_read_private), GFP_NOFS);
+	if (!priv)
+		return -ENOMEM;
+
+	init_waitqueue_head(&priv->wait);
+	atomic_set(&priv->pending, 1);
+	priv->status = 0;
 
 	bbio = btrfs_bio_alloc(BIO_MAX_VECS, REQ_OP_READ, fs_info,
-			       btrfs_encoded_read_endio, &priv);
+			       btrfs_encoded_read_endio, priv);
 	bbio->bio.bi_iter.bi_sector = disk_bytenr >> SECTOR_SHIFT;
 	bbio->inode = inode;
 
@@ -9153,11 +9158,11 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 		size_t bytes = min_t(u64, disk_io_size, PAGE_SIZE);
 
 		if (bio_add_page(&bbio->bio, pages[i], bytes, 0) < bytes) {
-			atomic_inc(&priv.pending);
+			atomic_inc(&priv->pending);
 			btrfs_submit_bbio(bbio, 0);
 
 			bbio = btrfs_bio_alloc(BIO_MAX_VECS, REQ_OP_READ, fs_info,
-					       btrfs_encoded_read_endio, &priv);
+					       btrfs_encoded_read_endio, priv);
 			bbio->bio.bi_iter.bi_sector = disk_bytenr >> SECTOR_SHIFT;
 			bbio->inode = inode;
 			continue;
@@ -9168,13 +9173,15 @@ int btrfs_encoded_read_regular_fill_pages(struct btrfs_inode *inode,
 		disk_io_size -= bytes;
 	} while (disk_io_size);
 
-	atomic_inc(&priv.pending);
+	atomic_inc(&priv->pending);
 	btrfs_submit_bbio(bbio, 0);
 
-	if (atomic_dec_return(&priv.pending))
-		io_wait_event(priv.wait, !atomic_read(&priv.pending));
+	if (atomic_dec_return(&priv->pending))
+		io_wait_event(priv->wait, !atomic_read(&priv->pending));
 	/* See btrfs_encoded_read_endio() for ordering. */
-	return blk_status_to_errno(READ_ONCE(priv.status));
+	ret = blk_status_to_errno(READ_ONCE(priv->status));
+	kfree(priv);
+	return ret;
 }
 
 ssize_t btrfs_encoded_read_regular(struct kiocb *iocb, struct iov_iter *iter,
-- 
2.43.0




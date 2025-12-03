Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343103587AF;
	Wed,  3 Dec 2025 16:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778839; cv=none; b=qDtOgsr1vOmaIRFsBSPWz6nzpT5YJFcXz8Tv3sAI2YOwhG9ZJBp7Z0q5EkXoZwAtv1lBskzPETDQwc5h9dB+SNRoyZ4BbGQ+Fxqze20wYhqYZ+ky2x2KyHuLlWb2tGBSAr/pUEjVlBU5w88B2TYeKCP2uyVQBJjzlju7McuqE4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778839; c=relaxed/simple;
	bh=cIxzstFhh+0koeZ4acNkmGPcS71ChRuI5PLzIjRPuik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DK7hvePGSBD0kBBxhzvRu0uixKCzZf1yMw6kivvJmBHQanc0eGRBMo6bf+7yDOTWd5Ubm8pVPPCgNcnbCgLaGKDt6qqEyLzHziY3wo6ZRa7LRT/ygn7r3zzXEDnonV7dSlCL1cy4+uHgA1H7MHRAjm8yJxMx2Rlm/wMR8ZteQNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/XzSMJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/XzSMJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EDDC4CEF5;
	Wed,  3 Dec 2025 16:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778838;
	bh=cIxzstFhh+0koeZ4acNkmGPcS71ChRuI5PLzIjRPuik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/XzSMJ/NF16ONT2SjfYmhESVepAtIVEDNVNDVmEx54594JUI9drfBKBnDpWGbrqb
	 FGdnU05t6VFw8o/Eie3s2qE19zOsj9B/pAqwb828fYg2UB9/g2anKzEZWm75DF5mlT
	 x2WhJ/4MtxWJt9IcYhnySujItenA/q2edqUt0d6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Anna Schumaker <anna@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Theodore Tso <tytso@mit.edu>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Xiubo Li <xiubli@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mahmoud Adam <mngyadam@amazon.de>
Subject: [PATCH 6.1 076/568] filemap: add a kiocb_invalidate_post_direct_write helper
Date: Wed,  3 Dec 2025 16:21:18 +0100
Message-ID: <20251203152443.502200290@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit c402a9a9430b670926decbb284b756ee6f47c1ec upstream.

Add a helper to invalidate page cache after a dio write.

Link: https://lkml.kernel.org/r/20230601145904.1385409-7-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/direct-io.c          |   10 ++--------
 fs/iomap/direct-io.c    |   12 ++----------
 include/linux/fs.h      |    5 -----
 include/linux/pagemap.h |    1 +
 mm/filemap.c            |   37 ++++++++++++++++++++-----------------
 5 files changed, 25 insertions(+), 40 deletions(-)

--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -286,14 +286,8 @@ static ssize_t dio_complete(struct dio *
 	 * zeros from unwritten extents.
 	 */
 	if (flags & DIO_COMPLETE_INVALIDATE &&
-	    ret > 0 && dio_op == REQ_OP_WRITE &&
-	    dio->inode->i_mapping->nrpages) {
-		err = invalidate_inode_pages2_range(dio->inode->i_mapping,
-					offset >> PAGE_SHIFT,
-					(offset + ret - 1) >> PAGE_SHIFT);
-		if (err)
-			dio_warn_stale_pagecache(dio->iocb->ki_filp);
-	}
+	    ret > 0 && dio_op == REQ_OP_WRITE)
+		kiocb_invalidate_post_direct_write(dio->iocb, ret);
 
 	inode_dio_end(dio->inode);
 
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -81,7 +81,6 @@ ssize_t iomap_dio_complete(struct iomap_
 {
 	const struct iomap_dio_ops *dops = dio->dops;
 	struct kiocb *iocb = dio->iocb;
-	struct inode *inode = file_inode(iocb->ki_filp);
 	loff_t offset = iocb->ki_pos;
 	ssize_t ret = dio->error;
 
@@ -108,15 +107,8 @@ ssize_t iomap_dio_complete(struct iomap_
 	 * ->end_io() when necessary, otherwise a racing buffer read would cache
 	 * zeros from unwritten extents.
 	 */
-	if (!dio->error && dio->size &&
-	    (dio->flags & IOMAP_DIO_WRITE) && inode->i_mapping->nrpages) {
-		int err;
-		err = invalidate_inode_pages2_range(inode->i_mapping,
-				offset >> PAGE_SHIFT,
-				(offset + dio->size - 1) >> PAGE_SHIFT);
-		if (err)
-			dio_warn_stale_pagecache(iocb->ki_filp);
-	}
+	if (!dio->error && dio->size && (dio->flags & IOMAP_DIO_WRITE))
+		kiocb_invalidate_post_direct_write(iocb, dio->size);
 
 	inode_dio_end(file_inode(iocb->ki_filp));
 	if (ret > 0) {
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3371,11 +3371,6 @@ static inline void inode_dio_end(struct
 		wake_up_bit(&inode->i_state, __I_DIO_WAKEUP);
 }
 
-/*
- * Warn about a page cache invalidation failure diring a direct I/O write.
- */
-void dio_warn_stale_pagecache(struct file *filp);
-
 extern void inode_set_flags(struct inode *inode, unsigned int flags,
 			    unsigned int mask);
 
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -31,6 +31,7 @@ int invalidate_inode_pages2(struct addre
 int invalidate_inode_pages2_range(struct address_space *mapping,
 		pgoff_t start, pgoff_t end);
 int kiocb_invalidate_pages(struct kiocb *iocb, size_t count);
+void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count);
 int write_inode_now(struct inode *, int sync);
 int filemap_fdatawrite(struct address_space *);
 int filemap_flush(struct address_space *);
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3733,7 +3733,7 @@ EXPORT_SYMBOL(read_cache_page_gfp);
 /*
  * Warn about a page cache invalidation failure during a direct I/O write.
  */
-void dio_warn_stale_pagecache(struct file *filp)
+static void dio_warn_stale_pagecache(struct file *filp)
 {
 	static DEFINE_RATELIMIT_STATE(_rs, 86400 * HZ, DEFAULT_RATELIMIT_BURST);
 	char pathname[128];
@@ -3750,19 +3750,23 @@ void dio_warn_stale_pagecache(struct fil
 	}
 }
 
+void kiocb_invalidate_post_direct_write(struct kiocb *iocb, size_t count)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+
+	if (mapping->nrpages &&
+	    invalidate_inode_pages2_range(mapping,
+			iocb->ki_pos >> PAGE_SHIFT,
+			(iocb->ki_pos + count - 1) >> PAGE_SHIFT))
+		dio_warn_stale_pagecache(iocb->ki_filp);
+}
+
 ssize_t
 generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
 {
-	struct file	*file = iocb->ki_filp;
-	struct address_space *mapping = file->f_mapping;
-	struct inode	*inode = mapping->host;
-	loff_t		pos = iocb->ki_pos;
-	ssize_t		written;
-	size_t		write_len;
-	pgoff_t		end;
-
-	write_len = iov_iter_count(from);
-	end = (pos + write_len - 1) >> PAGE_SHIFT;
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	size_t write_len = iov_iter_count(from);
+	ssize_t written;
 
 	/*
 	 * If a page can not be invalidated, return 0 to fall back
@@ -3772,7 +3776,7 @@ generic_file_direct_write(struct kiocb *
 	if (written) {
 		if (written == -EBUSY)
 			return 0;
-		goto out;
+		return written;
 	}
 
 	written = mapping->a_ops->direct_IO(iocb, from);
@@ -3794,11 +3798,11 @@ generic_file_direct_write(struct kiocb *
 	 *
 	 * Skip invalidation for async writes or if mapping has no pages.
 	 */
-	if (written > 0 && mapping->nrpages &&
-	    invalidate_inode_pages2_range(mapping, pos >> PAGE_SHIFT, end))
-		dio_warn_stale_pagecache(file);
-
 	if (written > 0) {
+		struct inode *inode = mapping->host;
+		loff_t pos = iocb->ki_pos;
+
+		kiocb_invalidate_post_direct_write(iocb, written);
 		pos += written;
 		write_len -= written;
 		if (pos > i_size_read(inode) && !S_ISBLK(inode->i_mode)) {
@@ -3809,7 +3813,6 @@ generic_file_direct_write(struct kiocb *
 	}
 	if (written != -EIOCBQUEUED)
 		iov_iter_revert(from, write_len - iov_iter_count(from));
-out:
 	return written;
 }
 EXPORT_SYMBOL(generic_file_direct_write);



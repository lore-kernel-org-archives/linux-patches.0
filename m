Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4650C328627;
	Mon, 27 Oct 2025 18:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591546; cv=none; b=skMXRF1oQt/NOLY/nU+7kUebIHuT/d0sU9Lvu7HY6X2gBwhI+I5+rBn8PhWRvZ5p0dIQLgJTU7/5ITZm9U/oWxlC6FqOg1T4aYp6MPkHe/5Sy2zKonvX58R+NsxnkkZnkjx0NsfjORm16/ooVpYdkHQkupVWdyCb64zoRwSguPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591546; c=relaxed/simple;
	bh=wg/5ZqdqDxzDT8EVU8Eu7P+pdRTNpvTaXchX7HVsUZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcynfXfs7E/T/srAzOiqTZaEYc64vHT7uYDMTLzv8UfkXRv1SST+4Zu2NTQPGz2XLyjcxu0YHJMZoHyfMHjcWR6fEFNgQZsISWiv1yhRoSXWm4PVe3RGhCQkgngAjesG4k+sZ/xQABmN6ZPg4YS85VgxBYnFp4ZGiLQhJxSnxQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8ACcd5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8ACcd5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC2EC4CEF1;
	Mon, 27 Oct 2025 18:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591546;
	bh=wg/5ZqdqDxzDT8EVU8Eu7P+pdRTNpvTaXchX7HVsUZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8ACcd5IZKNSdtwTDcdl4IZAh6yLuOtWg4EgBO7CwzlP81jIAldiZQhyG3I9PNYAL
	 wb1rxzgJNQ+5drB92/i4+QPjKtR/xQZ5Kr91IhRTpe86yPjK3+QH+AksqEbX5MJoPN
	 F88YOUwi9NCKEw826PTMKohTHrHhiojJeUEltGck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 239/332] fsdax: switch dax_iomap_rw to use iomap_iter
Date: Mon, 27 Oct 2025 19:34:52 +0100
Message-ID: <20251027183531.141165261@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit ca289e0b95afa973d204c77a4ad5c37e06145fbf ]

Switch the dax_iomap_rw implementation to use iomap_iter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Stable-dep-of: 154d1e7ad9e5 ("dax: skip read lock assertion for read-only filesystems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 49 ++++++++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 3e7e9a57fd28c..6619a71b57bbe 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1104,20 +1104,21 @@ s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
 	return size;
 }
 
-static loff_t
-dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
-		struct iomap *iomap, struct iomap *srcmap)
+static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
+		struct iov_iter *iter)
 {
+	const struct iomap *iomap = &iomi->iomap;
+	loff_t length = iomap_length(iomi);
+	loff_t pos = iomi->pos;
 	struct block_device *bdev = iomap->bdev;
 	struct dax_device *dax_dev = iomap->dax_dev;
-	struct iov_iter *iter = data;
 	loff_t end = pos + length, done = 0;
 	ssize_t ret = 0;
 	size_t xfer;
 	int id;
 
 	if (iov_iter_rw(iter) == READ) {
-		end = min(end, i_size_read(inode));
+		end = min(end, i_size_read(iomi->inode));
 		if (pos >= end)
 			return 0;
 
@@ -1134,7 +1135,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	 * written by write(2) is visible in mmap.
 	 */
 	if (iomap->flags & IOMAP_F_NEW) {
-		invalidate_inode_pages2_range(inode->i_mapping,
+		invalidate_inode_pages2_range(iomi->inode->i_mapping,
 					      pos >> PAGE_SHIFT,
 					      (end - 1) >> PAGE_SHIFT);
 	}
@@ -1210,31 +1211,29 @@ ssize_t
 dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops)
 {
-	struct address_space *mapping = iocb->ki_filp->f_mapping;
-	struct inode *inode = mapping->host;
-	loff_t pos = iocb->ki_pos, ret = 0, done = 0;
-	unsigned flags = 0;
+	struct iomap_iter iomi = {
+		.inode		= iocb->ki_filp->f_mapping->host,
+		.pos		= iocb->ki_pos,
+		.len		= iov_iter_count(iter),
+	};
+	loff_t done = 0;
+	int ret;
 
 	if (iov_iter_rw(iter) == WRITE) {
-		lockdep_assert_held_write(&inode->i_rwsem);
-		flags |= IOMAP_WRITE;
+		lockdep_assert_held_write(&iomi.inode->i_rwsem);
+		iomi.flags |= IOMAP_WRITE;
 	} else {
-		lockdep_assert_held(&inode->i_rwsem);
+		lockdep_assert_held(&iomi.inode->i_rwsem);
 	}
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
-		flags |= IOMAP_NOWAIT;
+		iomi.flags |= IOMAP_NOWAIT;
 
-	while (iov_iter_count(iter)) {
-		ret = iomap_apply(inode, pos, iov_iter_count(iter), flags, ops,
-				iter, dax_iomap_actor);
-		if (ret <= 0)
-			break;
-		pos += ret;
-		done += ret;
-	}
+	while ((ret = iomap_iter(&iomi, ops)) > 0)
+		iomi.processed = dax_iomap_iter(&iomi, iter);
 
-	iocb->ki_pos += done;
+	done = iomi.pos - iocb->ki_pos;
+	iocb->ki_pos = iomi.pos;
 	return done ? done : ret;
 }
 EXPORT_SYMBOL_GPL(dax_iomap_rw);
@@ -1308,7 +1307,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	}
 
 	/*
-	 * Note that we don't bother to use iomap_apply here: DAX required
+	 * Note that we don't bother to use iomap_iter here: DAX required
 	 * the file system block size to be equal the page size, which means
 	 * that we never have to deal with more than a single extent here.
 	 */
@@ -1562,7 +1561,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	}
 
 	/*
-	 * Note that we don't use iomap_apply here.  We aren't doing I/O, only
+	 * Note that we don't use iomap_iter here.  We aren't doing I/O, only
 	 * setting up a mapping, so really we're using iomap_begin() as a way
 	 * to look up our filesystem block.
 	 */
-- 
2.51.0




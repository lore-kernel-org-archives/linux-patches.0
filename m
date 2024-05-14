Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E543422094
	for <patches@lists.linux.dev>; Tue, 14 May 2024 08:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715676144; cv=none; b=GmvHStKEGfAFlL8rJlzL5fPaEvTHzLvstS7BQ7m5Odle+FPKUevCSeO7eeXv1g/d0KlaFvWj6U+fjaPW2y8vRa8nyHK59I4ymz2YEBeCp1Y8uFGj1jtZCYYQGg/COf4yz7F1JkwTBR04o3BNdBJ0kSkusIs+z4dS5edkye7xjKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715676144; c=relaxed/simple;
	bh=SeVV9FhbB29OG4btT1lTkRzddM1ihh1QxCicmBZXlaA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AkpggIrk9o7fekCvDMbxqA/g+uk8U6chrKFw7CaZnvjzxEj2fyegAb6348CdsflVrTDnJmOMzHQpiBmLXH6Kryj79Kh+4EknLN4zOA2x7pnf+Vc8s5CwbwzpTvS92LxxiA5z6WACozwonYDLzaWvBKr2QpKcGlBtrOsdwAGaCeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Aa/tXa5h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Aa/tXa5h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ymLWmyIeGjeOM9B90q5i5XnOlmrM18ubuH169tVPW/M=; b=Aa/tXa5hhKTcrVxwkIPiH/rlTO
	z1y2GV68muYBPUIgLSYOefrJY5w2XRCN1FM5S2Djva4jONeDd0WR1/Zk7vGv2X28P3sWJ4vScQpl+
	QCwohqX/nfnhKCGwCy8zaHMDgq9mDGyWOHNxOQlEBMgo2YktFADGAe6uT8+bOgP2uRUAn+SeT6LuM
	6AdRyvHwHXCnz1kLCUxMsB/6M6hj6rNIDxlMBGr9ayi+4sm95Zcl9aa/hJNbnwkIx3uJdcguLt0oY
	O5QikobAOBltLmzF3QYkmy70r1lXbTH7jNL/lhu7h5ko9Ox++ciKUUhMvkH1Vl+DhdRh1D2N1d5K7
	D1HomNDQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s6njq-0000000FNIe-1im1;
	Tue, 14 May 2024 08:42:22 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: torvalds@linux-foundation.org,
	patches@lists.linux.dev
Cc: mcgrof@kernel.org
Subject: [PATCH] filemap: small read filemap_read() stack optimization
Date: Tue, 14 May 2024 01:42:21 -0700
Message-ID: <20240514084221.3664475-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

[ mcgrof: pick up 128 byte stack space (on 64-bit) filemap opt ].

https://lkml.kernel.org/r/CAHk-=wjOogaW0yLoUqQ0WfQ=etPA4cOFLy56VYCnHVU_DOMLrg@mail.gmail.com

So, just hypothetically, let's say that *before* we start using that
folio batch buffer for folios, we use it as a dummy buffer for small
reads.

So we'd make that 'fbatch' thing be a union with a temporary byte
buffer.

That hypothetical patch might look something like this TOTALLY UNTESTED
CRAP.

Anybody interested in seeing if something like this might actually
work? I do want to emphasize the "something like this".

This pile of random thoughts ends up compiling for me, and I _tried_
to think of all the cases, but there might be obvious thinkos, and
there might be things I just didn't think about at all.

I really haven't tested this AT ALL. I'm much too scared. But I don't
actually hate how the code looks nearly as much as I *thought* I'd
hate it.

Linus

[ mcgrof: posting this to allow easier testing with automation ]

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 mm/filemap.c | 117 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 107 insertions(+), 10 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 30de18c4fd28..7da759e53a16 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2550,6 +2550,85 @@ static inline bool pos_same_folio(loff_t pos1, loff_t pos2, struct folio *folio)
 	return (pos1 >> shift == pos2 >> shift);
 }
 
+/*
+ * I can't be bothered to care about HIGHMEM for the fast read case
+ */
+#ifdef CONFIG_HIGHMEM
+#define filemap_fast_read(mapping, pos, buffer, size) 0
+#else
+
+/*
+ * Called under RCU with size limited to the file size and one
+ */
+static unsigned long filemap_folio_copy_rcu(struct address_space *mapping, loff_t pos, char *buffer, size_t size)
+{
+	XA_STATE(xas, &mapping->i_pages, pos >> PAGE_SHIFT);
+	struct folio *folio;
+	size_t offset;
+
+	xas_reset(&xas);
+	folio = xas_load(&xas);
+	if (xas_retry(&xas, folio))
+		return 0;
+
+	if (!folio || xa_is_value(folio))
+		return 0;
+
+	if (!folio_test_uptodate(folio))
+		return 0;
+
+	/* No fast-case if we are supposed to start readahead */
+	if (folio_test_readahead(folio))
+		return 0;
+	/* .. or mark it accessed */
+	if (!folio_test_referenced(folio))
+		return 0;
+
+	/* Do the data copy */
+	offset = pos & (folio_size(folio) - 1);
+	memcpy(buffer, folio_address(folio) + offset, size);
+
+	/* We should probably do some silly memory barrier here */
+	if (unlikely(folio != xas_reload(&xas)))
+		return 0;
+
+	return size;
+}
+
+/*
+ * Iff we can complete the read completely in one atomic go under RCU,
+ * do so here. Otherwise return 0 (no partial reads, please - this is
+ * purely for the trivial fast case).
+ */
+static unsigned long filemap_fast_read(struct address_space *mapping, loff_t pos, char *buffer, size_t size)
+{
+	struct inode *inode;
+	loff_t file_size;
+	unsigned long pgoff;
+
+	/* Don't even try for page-crossers */
+	pgoff = pos & ~PAGE_MASK;
+	if (pgoff + size > PAGE_SIZE)
+		return 0;
+
+	/* Limit it to the file size */
+	inode = mapping->host;
+	file_size = i_size_read(inode);
+	if (unlikely(pos >= file_size))
+		return 0;
+	file_size -= pos;
+	if (file_size < size)
+		size = file_size;
+
+	/* Let's see if we can just do the read under RCU */
+	rcu_read_lock();
+	size = filemap_folio_copy_rcu(mapping, pos, buffer, size);
+	rcu_read_unlock();
+
+	return size;
+}
+#endif /* !HIGHMEM */
+
 /**
  * filemap_read - Read data from the page cache.
  * @iocb: The iocb to read.
@@ -2570,7 +2649,10 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 	struct file_ra_state *ra = &filp->f_ra;
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
-	struct folio_batch fbatch;
+	union {
+		struct folio_batch fbatch;
+		__DECLARE_FLEX_ARRAY(char, buffer);
+	} area;
 	int i, error = 0;
 	bool writably_mapped;
 	loff_t isize, end_offset;
@@ -2582,7 +2664,22 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		return 0;
 
 	iov_iter_truncate(iter, inode->i_sb->s_maxbytes);
-	folio_batch_init(&fbatch);
+
+	if (iov_iter_count(iter) < sizeof(area)) {
+		unsigned long count = iov_iter_count(iter);
+
+		count = filemap_fast_read(mapping, iocb->ki_pos, area.buffer, count);
+		if (count) {
+			size_t copied = copy_to_iter(area.buffer, count, iter);
+			if (unlikely(!copied))
+				return already_read ? already_read : -EFAULT;
+			ra->prev_pos = iocb->ki_pos += copied;
+			file_accessed(filp);
+			return copied + already_read;
+		}
+	}
+
+	folio_batch_init(&area.fbatch);
 
 	do {
 		cond_resched();
@@ -2598,7 +2695,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		if (unlikely(iocb->ki_pos >= i_size_read(inode)))
 			break;
 
-		error = filemap_get_pages(iocb, iter->count, &fbatch, false);
+		error = filemap_get_pages(iocb, iter->count, &area.fbatch, false);
 		if (error < 0)
 			break;
 
@@ -2626,11 +2723,11 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		 * mark it as accessed the first time.
 		 */
 		if (!pos_same_folio(iocb->ki_pos, last_pos - 1,
-				    fbatch.folios[0]))
-			folio_mark_accessed(fbatch.folios[0]);
+				    area.fbatch.folios[0]))
+			folio_mark_accessed(area.fbatch.folios[0]);
 
-		for (i = 0; i < folio_batch_count(&fbatch); i++) {
-			struct folio *folio = fbatch.folios[i];
+		for (i = 0; i < folio_batch_count(&area.fbatch); i++) {
+			struct folio *folio = area.fbatch.folios[i];
 			size_t fsize = folio_size(folio);
 			size_t offset = iocb->ki_pos & (fsize - 1);
 			size_t bytes = min_t(loff_t, end_offset - iocb->ki_pos,
@@ -2661,9 +2758,9 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 			}
 		}
 put_folios:
-		for (i = 0; i < folio_batch_count(&fbatch); i++)
-			folio_put(fbatch.folios[i]);
-		folio_batch_init(&fbatch);
+		for (i = 0; i < folio_batch_count(&area.fbatch); i++)
+			folio_put(area.fbatch.folios[i]);
+		folio_batch_init(&area.fbatch);
 	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
 
 	file_accessed(filp);
-- 
2.43.0


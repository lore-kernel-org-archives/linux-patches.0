Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D046035BDB7;
	Wed,  3 Dec 2025 16:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778942; cv=none; b=g2bnnGL7Yagodz+Cn6coo5AxY4KffsTlJ0rN4/GhkrK6xhjtrCRuB+aJRji3J5xo7zeUNvA7MdH2N5U8wW/i1KmvhJToKK2p/INCMKryyc3Uu4l4ymKEeTEZdUbwD1lie0xMJu0JspkxohaV2TPAeu2qUn3befhv8NG1lMYIoBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778942; c=relaxed/simple;
	bh=ALXgtfDOMBNDD4pXARpdK/thigiAm3BEnjS9H0togzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQOPNc7HJD+s6gn+BZmNDO7Cbr446epge6LFcuNhbe20xPSVlduqNbXZQddMoDqfHjMyW6WmHbRjSoWYdHNkKV11cJT5WT+mJDSTEqObL0Bc8qOVpQ4Hu5wDfrz3G/tMEWP7vwm0UHeZjNm732Jk0eREP+FfESOKRdYzhCUWpVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjVIM/8b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjVIM/8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E58C4CEF5;
	Wed,  3 Dec 2025 16:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778942;
	bh=ALXgtfDOMBNDD4pXARpdK/thigiAm3BEnjS9H0togzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjVIM/8biahyY5J4+DHd6op0RW4A/4FV2/t6vTt5Ag4O61wrzQcKoB6PCsf1PS+bj
	 ffUFr93QzdkaP7qhZdYezqnJbUA7V6NAZu/g7UG0H3phLuEmT1ePxcfsVXnxoqmzTw
	 mTkWTGZo097jT731ThU9CzEnzFEQHRTySKQ2omek=
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
Subject: [PATCH 6.1 075/568] filemap: add a kiocb_invalidate_pages helper
Date: Wed,  3 Dec 2025 16:21:17 +0100
Message-ID: <20251203152443.464932328@linuxfoundation.org>
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

commit e003f74afbd2feadbb9ffbf9135e2d2fb5d320a5 upstream.

Factor out a helper that calls filemap_write_and_wait_range and
invalidate_inode_pages2_range for the range covered by a write kiocb or
returns -EAGAIN if the kiocb is marked as nowait and there would be pages
to write or invalidate.

Link: https://lkml.kernel.org/r/20230601145904.1385409-6-hch@lst.de
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
 include/linux/pagemap.h |    1 +
 mm/filemap.c            |   48 ++++++++++++++++++++++++++++--------------------
 2 files changed, 29 insertions(+), 20 deletions(-)

--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -30,6 +30,7 @@ static inline void invalidate_remote_ino
 int invalidate_inode_pages2(struct address_space *mapping);
 int invalidate_inode_pages2_range(struct address_space *mapping,
 		pgoff_t start, pgoff_t end);
+int kiocb_invalidate_pages(struct kiocb *iocb, size_t count);
 int write_inode_now(struct inode *, int sync);
 int filemap_fdatawrite(struct address_space *);
 int filemap_flush(struct address_space *);
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2839,6 +2839,33 @@ put_folios:
 }
 EXPORT_SYMBOL_GPL(filemap_read);
 
+int kiocb_invalidate_pages(struct kiocb *iocb, size_t count)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	loff_t pos = iocb->ki_pos;
+	loff_t end = pos + count - 1;
+	int ret;
+
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		/* we could block if there are any pages in the range */
+		if (filemap_range_has_page(mapping, pos, end))
+			return -EAGAIN;
+	} else {
+		ret = filemap_write_and_wait_range(mapping, pos, end);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * After a write we want buffered reads to be sure to go to disk to get
+	 * the new data.  We invalidate clean cached page from the region we're
+	 * about to write.  We do this *before* the write so that we can return
+	 * without clobbering -EIOCBQUEUED from ->direct_IO().
+	 */
+	return invalidate_inode_pages2_range(mapping, pos >> PAGE_SHIFT,
+					     end >> PAGE_SHIFT);
+}
+
 /**
  * generic_file_read_iter - generic filesystem read routine
  * @iocb:	kernel I/O control block
@@ -3737,30 +3764,11 @@ generic_file_direct_write(struct kiocb *
 	write_len = iov_iter_count(from);
 	end = (pos + write_len - 1) >> PAGE_SHIFT;
 
-	if (iocb->ki_flags & IOCB_NOWAIT) {
-		/* If there are pages to writeback, return */
-		if (filemap_range_has_page(file->f_mapping, pos,
-					   pos + write_len - 1))
-			return -EAGAIN;
-	} else {
-		written = filemap_write_and_wait_range(mapping, pos,
-							pos + write_len - 1);
-		if (written)
-			goto out;
-	}
-
-	/*
-	 * After a write we want buffered reads to be sure to go to disk to get
-	 * the new data.  We invalidate clean cached page from the region we're
-	 * about to write.  We do this *before* the write so that we can return
-	 * without clobbering -EIOCBQUEUED from ->direct_IO().
-	 */
-	written = invalidate_inode_pages2_range(mapping,
-					pos >> PAGE_SHIFT, end);
 	/*
 	 * If a page can not be invalidated, return 0 to fall back
 	 * to buffered write.
 	 */
+	written = kiocb_invalidate_pages(iocb, write_len);
 	if (written) {
 		if (written == -EBUSY)
 			return 0;



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5864C39FE1;
	Fri, 24 Nov 2023 18:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntaY1P+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8581DC433C8;
	Fri, 24 Nov 2023 18:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848847;
	bh=YfbHxDn6MjLgbLYFcIgDcKM/gTDABIKgf/bND8AzeRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntaY1P+Z/EKDmhVthaTIz4YpxHCWVgacZNSyuYVRfmObrqasVAkDU25Xi4xGQSJAK
	 oqiKV8+oqT9QtjTvUd30LzxGbAt7TllLKIX1dUsRR5Jjyp+frKylumWCeiF3WyGZzT
	 sFedpL60Y/ii+KLlCJhmtjcgN3V4raSBzgp9H+vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Qian Cai <cai@redhat.com>,
	Brian Foster <bfoster@redhat.com>,
	Gao Xiang <hsiangkao@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Shida Zhang <zhangshida@kylinos.cn>
Subject: [PATCH 4.19 96/97] iomap: Set all uptodate bits for an Uptodate page
Date: Fri, 24 Nov 2023 17:51:09 +0000
Message-ID: <20231124171937.789554098@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171934.122298957@linuxfoundation.org>
References: <20231124171934.122298957@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 4595a298d5563cf76c1d852970f162051fd1a7a6 upstream.

For filesystems with block size < page size, we need to set all the
per-block uptodate bits if the page was already uptodate at the time
we create the per-block metadata.  This can happen if the page is
invalidated (eg by a write to drop_caches) but ultimately not removed
from the page cache.

This is a data corruption issue as page writeback skips blocks which
are marked !uptodate.

Fixes: 9dc55f1389f9 ("iomap: add support for sub-pagesize buffered I/O without buffer heads")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Qian Cai <cai@redhat.com>
Cc: Brian Foster <bfoster@redhat.com>
Reviewed-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -109,6 +109,7 @@ static struct iomap_page *
 iomap_page_create(struct inode *inode, struct page *page)
 {
 	struct iomap_page *iop = to_iomap_page(page);
+	unsigned int nr_blocks = PAGE_SIZE / i_blocksize(inode);
 
 	if (iop || i_blocksize(inode) == PAGE_SIZE)
 		return iop;
@@ -118,6 +119,8 @@ iomap_page_create(struct inode *inode, s
 	atomic_set(&iop->write_count, 0);
 	spin_lock_init(&iop->uptodate_lock);
 	bitmap_zero(iop->uptodate, PAGE_SIZE / SECTOR_SIZE);
+	if (PageUptodate(page))
+		bitmap_fill(iop->uptodate, nr_blocks);
 
 	/*
 	 * migrate_page_move_mapping() assumes that pages with private data have



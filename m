Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8341313B798;
	Tue, 27 Feb 2024 14:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043903; cv=none; b=H79zImbe1/fGjIzuwEBKwhetLhDvc9BG3VtNcNgjYNdsb/lJf0BiMhrMZdFiUX30kg27gw3QO8+XRA1qDyVxZE/G8iurHGI7lFGIMxX0hOgLmoXnQyi/3Yupd2bJH6/8skjcUVA9OT/pmV5EVumenWFrhzOKSTGvYoFKRwDvb/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043903; c=relaxed/simple;
	bh=j9HgWxnUV/ukXj363mktYSdEUtLl5DotR6u8ejNZpQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJKJ+lic0v4A9zGVbXZ0Vn+yGDfeW8vfDahzgrnWffuxt95pglfZMM/fOUV0m3XQLos+8TbcLBv5UW9rp0mGFevvOFefp0PbAy9Khr5OQv1UBAM8154r/HEE8VCa/ENU8Ven5KocY/Ul6Eywu4ZUN8OvZWjfdvxIzTk51J19e5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OgJOXHZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OgJOXHZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10516C433F1;
	Tue, 27 Feb 2024 14:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043903;
	bh=j9HgWxnUV/ukXj363mktYSdEUtLl5DotR6u8ejNZpQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OgJOXHZRzyDPyLKuXXyGfRDLfZNxsVHFv0jUlhAxyK2ZB5V9U+ZVssGloGTc1nc0N
	 VZqHIjqu5HyWlK8StXjwFOpLY9bfsVe+QWtquKzUC4UIdqdBeILwXmAsVPq5s0To6+
	 wmpFgeCoEQZxZ8+VC5loTn8bKscKGGXINJP7oRNc=
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
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 48/84] iomap: Set all uptodate bits for an Uptodate page
Date: Tue, 27 Feb 2024 14:27:15 +0100
Message-ID: <20240227131554.435924966@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 4595a298d5563cf76c1d852970f162051fd1a7a6 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 53cd7b2bb580b..c28ba474a25e7 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -23,6 +23,7 @@ static struct iomap_page *
 iomap_page_create(struct inode *inode, struct page *page)
 {
 	struct iomap_page *iop = to_iomap_page(page);
+	unsigned int nr_blocks = PAGE_SIZE / i_blocksize(inode);
 
 	if (iop || i_blocksize(inode) == PAGE_SIZE)
 		return iop;
@@ -32,6 +33,8 @@ iomap_page_create(struct inode *inode, struct page *page)
 	atomic_set(&iop->write_count, 0);
 	spin_lock_init(&iop->uptodate_lock);
 	bitmap_zero(iop->uptodate, PAGE_SIZE / SECTOR_SIZE);
+	if (PageUptodate(page))
+		bitmap_fill(iop->uptodate, nr_blocks);
 
 	/*
 	 * migrate_page_move_mapping() assumes that pages with private data have
-- 
2.43.0




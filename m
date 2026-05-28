Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770BB3016E1;
	Thu, 28 May 2026 20:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000918; cv=none; b=ZKWtDuZpXzPKqD6KWLWvF4kIOB8v7N5pbna2mCf/GX6LYPYGdKH2hgA69/ZZp3c5eIF/qnSp5nd9+1CxYgaLkRw2G243PAq7bA/1ez5v9WgSnH0IGJKDdNl4zQLN+Z3hmtJJuUHT2qcuzkVB1KTMiCZuUAZVuTex8O1pcLAHxNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000918; c=relaxed/simple;
	bh=jHej8zqaKc+Uejz+i5jWTcVbJqPTbhnYMYaX7iklHUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xotduxb2uaAsrSY7kDTeurwhDJYqEO401IF5RGrQ59bAmogn3jWyJ1I/oelx62EFOuG+7nh5UvsIT9Wzx/GJ71FEK44xg+fOrhQWzW0Fauay/sLIi7KzsCahozpcI3Qm0lDVN+W0x1yqHrqpdHuAXRJybLO03wUtZUs89OnqhPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdVqlPj1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdVqlPj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49B71F000E9;
	Thu, 28 May 2026 20:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000917;
	bh=r/JLzEhuhHQC+BwFzp0u/RJsGJS8J0Iz0J4tOEkd87E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DdVqlPj1EvOjoHto4RduHDSm4zZ+D0lckBUnL7r4649HUCwxrM308YKBfoOlZ8Quu
	 K2/xMrOYUKYSc1+xQExF3xswbWVyIBgow8XGnGpnUIOkP5Yi6AABuwZWo/PgqZVfm+
	 MHnlIoX6Yomf0p5J9wlkG1R/XoMT8wlM8fV0lOfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 216/272] blk-integrity: enable p2p source and destination
Date: Thu, 28 May 2026 21:49:50 +0200
Message-ID: <20260528194635.260326802@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 05ceea5d3ec9a1b1d6858ffd4739fdb0ed1b8eaf ]

Set the extraction flags to allow p2p pages for the metadata buffer if
the block device allows it. Similar to data payloads, ensure the bio
does not use merging if we see a p2p page.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 8582792cf23b ("block: bio-integrity: Fix null-ptr-deref in bio_integrity_map_user()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index a7788bbe35979..2a02222f4298c 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -268,7 +268,8 @@ static int bio_integrity_init_user(struct bio *bio, struct bio_vec *bvec,
 }
 
 static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
-				    int nr_vecs, ssize_t bytes, ssize_t offset)
+				    int nr_vecs, ssize_t bytes, ssize_t offset,
+				    bool *is_p2p)
 {
 	unsigned int nr_bvecs = 0;
 	int i, j;
@@ -289,6 +290,9 @@ static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
 			bytes -= next;
 		}
 
+		if (is_pci_p2pdma_page(pages[i]))
+			*is_p2p = true;
+
 		bvec_set_page(&bvec[nr_bvecs], pages[i], size, offset);
 		offset = 0;
 		nr_bvecs++;
@@ -302,10 +306,11 @@ int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 	struct page *stack_pages[UIO_FASTIOV], **pages = stack_pages;
 	struct bio_vec stack_vec[UIO_FASTIOV], *bvec = stack_vec;
+	iov_iter_extraction_t extraction_flags = 0;
 	size_t offset, bytes = iter->count;
+	bool copy, is_p2p = false;
 	unsigned int nr_bvecs;
 	int ret, nr_vecs;
-	bool copy;
 
 	if (bio_integrity(bio))
 		return -EINVAL;
@@ -324,15 +329,23 @@ int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 
 	copy = iov_iter_alignment(iter) &
 			blk_lim_dma_alignment_and_pad(&q->limits);
-	ret = iov_iter_extract_pages(iter, &pages, bytes, nr_vecs, 0, &offset);
+
+	if (blk_queue_pci_p2pdma(q))
+		extraction_flags |= ITER_ALLOW_P2PDMA;
+
+	ret = iov_iter_extract_pages(iter, &pages, bytes, nr_vecs,
+					extraction_flags, &offset);
 	if (unlikely(ret < 0))
 		goto free_bvec;
 
-	nr_bvecs = bvec_from_pages(bvec, pages, nr_vecs, bytes, offset);
+	nr_bvecs = bvec_from_pages(bvec, pages, nr_vecs, bytes, offset,
+				   &is_p2p);
 	if (pages != stack_pages)
 		kvfree(pages);
 	if (nr_bvecs > queue_max_integrity_segments(q))
 		copy = true;
+	if (is_p2p)
+		bio->bi_opf |= REQ_NOMERGE;
 
 	if (copy)
 		ret = bio_integrity_copy_user(bio, bvec, nr_bvecs, bytes);
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A657033F8B2;
	Thu, 28 May 2026 20:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000915; cv=none; b=hWrS9Nud4GjxQy0T80AbVEIEdh+NNpszLZAUL0iBSlDiNiPmN5bj3B1nuuUh7gAUgH5XRvxQ5T++8MB7UCLCeGuImI56nhrRhhOhvwe2hm9k8QhZk7kSgQJ/9vECipqerqv5E+l/OSZ4AUcBH0YxDxp6xlJ5WJnqZaKV4Mdw0Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000915; c=relaxed/simple;
	bh=wOCQ5S9wZNEJ5VWkDF0/KhZZ/FQYnADJqjwCn+DBshc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dR32XVetzxlUSFgjhwV8OI0QuGsaK5fDMfA7l8dBzxhp9r7ni2bdTeeFYCy4aI5knaz9UUoXFNBACUTd6PWqMfikQQSJ4+r30SuWXrLio5X2dRS3CHNpxfWws6U1OetOEXARupdwMRjVr3lwVENtfz0OQpDRoDy6O3Af/MCZ+xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bC8zFYO1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bC8zFYO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169B41F000E9;
	Thu, 28 May 2026 20:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000914;
	bh=ZxcOmQfHyopmpYED3avzUxZSAQNbGf94oRd3b0fKt5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bC8zFYO1+T2nNqyMIhYcl63udei66egDshDkvg8ZbusFzsYvRDMs2eb+T0Xr1iE+1
	 JxBTn6Tf8RKX8XUVYQmLHhxcScnuFJMPEd/fj4iA3smUTPLHy66KR9cDTGcbYGbUBO
	 vBftNrX1c+A4HlklhOQd0lCPnVdfOWoZdQ06dvdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 215/272] blk-integrity: use simpler alignment check
Date: Thu, 28 May 2026 21:49:49 +0200
Message-ID: <20260528194635.234780815@linuxfoundation.org>
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

[ Upstream commit 69d7ed5b9ef661230264bfa0db4c96fa25b8efa4 ]

We're checking length and addresses against the same alignment value, so
use the more simple iterator check.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 8582792cf23b ("block: bio-integrity: Fix null-ptr-deref in bio_integrity_map_user()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio-integrity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 6801754838bc1..a7788bbe35979 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -300,7 +300,6 @@ static unsigned int bvec_from_pages(struct bio_vec *bvec, struct page **pages,
 int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 {
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	unsigned int align = blk_lim_dma_alignment_and_pad(&q->limits);
 	struct page *stack_pages[UIO_FASTIOV], **pages = stack_pages;
 	struct bio_vec stack_vec[UIO_FASTIOV], *bvec = stack_vec;
 	size_t offset, bytes = iter->count;
@@ -323,7 +322,8 @@ int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 		pages = NULL;
 	}
 
-	copy = !iov_iter_is_aligned(iter, align, align);
+	copy = iov_iter_alignment(iter) &
+			blk_lim_dma_alignment_and_pad(&q->limits);
 	ret = iov_iter_extract_pages(iter, &pages, bytes, nr_vecs, 0, &offset);
 	if (unlikely(ret < 0))
 		goto free_bvec;
-- 
2.53.0




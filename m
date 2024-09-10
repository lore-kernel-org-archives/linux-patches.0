Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2561546444;
	Tue, 10 Sep 2024 09:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725960980; cv=none; b=YYNbe6iJqcXzwsXoWLcPN7b+6jU2VsE35sII6NvJvSB5rx1x+r2LZE8oQ2lK2AzzWe2oHRHF7KBL0nN/QBnl7HUOmYREWFYlETPABGJ2ADeosD0xjajQK69Y8D4j1kq4pWp67uST8QCJnB3QJqzzdnxSR7tzdemlDzp2Xei4K4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725960980; c=relaxed/simple;
	bh=VeIhCLhbl2dZHyTpfSg9KcZC2kjnkxjTS4ewwlrcSsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Et6DBh5vZpBWR4e/+jFlGSZliCUYEpNE0PQkahmr0vnFidzHPf+xSLJVv9l/V2C8LZX6Axyd2b5SqN379fXHe6KuSarFWe/SyeBRFLjnZ8EpTn324ZTUU8H7LpLDFBxno3EJovPe6Nc/Xot+pTrGWKNAia3IlSKlxYm+hO6z3c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bql/aF8U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bql/aF8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7DFC4CEC3;
	Tue, 10 Sep 2024 09:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725960980;
	bh=VeIhCLhbl2dZHyTpfSg9KcZC2kjnkxjTS4ewwlrcSsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bql/aF8UBlPiWISoDTaHOGd61ucrDRCUSjjOlQw6E63snv+B0JAo8yJdTaWvG17I6
	 I2xb7kgAkf5HpTjEqKZ3XRF6CjGYrSqsrholQZqs6HYgPp3VkbsB/NB9tTijxe4qaA
	 mBXbdEZjD80Y+wa0rdrUVlBd2TENi1Fze6G3yNKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 4.19 13/96] block: initialize integrity buffer to zero before writing it to media
Date: Tue, 10 Sep 2024 11:31:15 +0200
Message-ID: <20240910092541.996999705@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 899ee2c3829c5ac14bfc7d3c4a5846c0b709b78f upstream.

Metadata added by bio_integrity_prep is using plain kmalloc, which leads
to random kernel memory being written media.  For PI metadata this is
limited to the app tag that isn't used by kernel generated metadata,
but for non-PI metadata the entire buffer leaks kernel memory.

Fix this by adding the __GFP_ZERO flag to allocations for writes.

Fixes: 7ba1ba12eeef ("block: Block layer data integrity support")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20240613084839.1044015-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio-integrity.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -227,6 +227,7 @@ bool bio_integrity_prep(struct bio *bio)
 	unsigned int bytes, offset, i;
 	unsigned int intervals;
 	blk_status_t status;
+	gfp_t gfp = GFP_NOIO;
 
 	if (!bi)
 		return true;
@@ -249,12 +250,20 @@ bool bio_integrity_prep(struct bio *bio)
 		if (!bi->profile->generate_fn ||
 		    !(bi->flags & BLK_INTEGRITY_GENERATE))
 			return true;
+
+		/*
+		 * Zero the memory allocated to not leak uninitialized kernel
+		 * memory to disk.  For PI this only affects the app tag, but
+		 * for non-integrity metadata it affects the entire metadata
+		 * buffer.
+		 */
+		gfp |= __GFP_ZERO;
 	}
 	intervals = bio_integrity_intervals(bi, bio_sectors(bio));
 
 	/* Allocate kernel buffer for protection data */
 	len = intervals * bi->tuple_size;
-	buf = kmalloc(len, GFP_NOIO | q->bounce_gfp);
+	buf = kmalloc(len, gfp | q->bounce_gfp);
 	status = BLK_STS_RESOURCE;
 	if (unlikely(buf == NULL)) {
 		printk(KERN_ERR "could not allocate integrity buffer\n");



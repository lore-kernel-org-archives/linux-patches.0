Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC6878B61;
	Tue, 27 Feb 2024 14:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043390; cv=none; b=T23L/tKPOsxgdDZvZkqrfo/QgxYVL5gJFDRmGIwUn1yhvldjtYfa5QffN36JAsH7Q7rJUqW0hHnxq434NoRYiN0BKaats+DkO9BRwpNuBZCVBlNdq2r1LojTSXprIPkWW3dLzJVoHHmgMJNl/GuVG+oZLIH/mS5i/XoYj2zdCLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043390; c=relaxed/simple;
	bh=1NyIjfI4HmbvcwhihFAJpRHt6ciRpYQSYpPE1bsNMkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o525SQVJZdpVjulpSq5wvM5oZrhDnxN6/XLUUsW3HVaQEqntYOrX3s7xx0MBASsgxJWYY5YilS8lXNNd69wRY7Mt7sY9Tsn1YD8h8wbWN2KdtJLyzHcAF27suKiay2nlfFsTnAfvKVraglU/8wAgb7+BecQahHn+loLmMALOLco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/x9wU6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/x9wU6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F92C433A6;
	Tue, 27 Feb 2024 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043390;
	bh=1NyIjfI4HmbvcwhihFAJpRHt6ciRpYQSYpPE1bsNMkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/x9wU6C2hJ7WDxazH9f4K3Lzr7fb3GJ3rvLhS/VIClG18KF3IeqTw56YXM1isTri
	 8rtM9dmBuisliti5W8dPgAz0mXs9vMhABTzDjvgUhz5zWco/KX3Zg+KOUcWL+3Z8XJ
	 bwPjE1UU6FQvdAvJq7UdIyxpur3J4FfQUNYZ86ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.1 090/195] dm-integrity: recheck the integrity tag after a failure
Date: Tue, 27 Feb 2024 14:25:51 +0100
Message-ID: <20240227131613.453026115@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit c88f5e553fe38b2ffc4c33d08654e5281b297677 upstream.

If a userspace process reads (with O_DIRECT) multiple blocks into the same
buffer, dm-integrity reports an error [1]. The error is reported in a log
and it may cause RAID leg being kicked out of the array.

This commit fixes dm-integrity, so that if integrity verification fails,
the data is read again into a kernel buffer (where userspace can't modify
it) and the integrity tag is rechecked. If the recheck succeeds, the
content of the kernel buffer is copied into the user buffer; if the
recheck fails, an integrity error is reported.

[1] https://people.redhat.com/~mpatocka/testcases/blk-auth-modify/read2.c

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |   93 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 84 insertions(+), 9 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -279,6 +279,8 @@ struct dm_integrity_c {
 
 	atomic64_t number_of_mismatches;
 
+	mempool_t recheck_pool;
+
 	struct notifier_block reboot_notifier;
 };
 
@@ -1699,6 +1701,79 @@ failed:
 	get_random_bytes(result, ic->tag_size);
 }
 
+static void integrity_recheck(struct dm_integrity_io *dio)
+{
+	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
+	struct dm_integrity_c *ic = dio->ic;
+	struct bvec_iter iter;
+	struct bio_vec bv;
+	sector_t sector, logical_sector, area, offset;
+	char checksum_onstack[max_t(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+	struct page *page;
+	void *buffer;
+
+	get_area_and_offset(ic, dio->range.logical_sector, &area, &offset);
+	dio->metadata_block = get_metadata_sector_and_offset(ic, area, offset,
+							     &dio->metadata_offset);
+	sector = get_data_sector(ic, area, offset);
+	logical_sector = dio->range.logical_sector;
+
+	page = mempool_alloc(&ic->recheck_pool, GFP_NOIO);
+	buffer = page_to_virt(page);
+
+	__bio_for_each_segment(bv, bio, iter, dio->bio_details.bi_iter) {
+		unsigned pos = 0;
+
+		do {
+			char *mem;
+			int r;
+			struct dm_io_request io_req;
+			struct dm_io_region io_loc;
+			io_req.bi_opf = REQ_OP_READ;
+			io_req.mem.type = DM_IO_KMEM;
+			io_req.mem.ptr.addr = buffer;
+			io_req.notify.fn = NULL;
+			io_req.client = ic->io;
+			io_loc.bdev = ic->dev->bdev;
+			io_loc.sector = sector;
+			io_loc.count = ic->sectors_per_block;
+
+			r = dm_io(&io_req, 1, &io_loc, NULL);
+			if (unlikely(r)) {
+				dio->bi_status = errno_to_blk_status(r);
+				goto free_ret;
+			}
+
+			integrity_sector_checksum(ic, logical_sector, buffer,
+						  checksum_onstack);
+			r = dm_integrity_rw_tag(ic, checksum_onstack, &dio->metadata_block,
+						&dio->metadata_offset, ic->tag_size, TAG_CMP);
+			if (r) {
+				if (r > 0) {
+					DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx",
+						    bio->bi_bdev, logical_sector);
+					atomic64_inc(&ic->number_of_mismatches);
+					dm_audit_log_bio(DM_MSG_PREFIX, "integrity-checksum",
+							 bio, logical_sector, 0);
+					r = -EILSEQ;
+				}
+				dio->bi_status = errno_to_blk_status(r);
+				goto free_ret;
+			}
+
+			mem = bvec_kmap_local(&bv);
+			memcpy(mem + pos, buffer, ic->sectors_per_block << SECTOR_SHIFT);
+			kunmap_local(mem);
+
+			pos += ic->sectors_per_block << SECTOR_SHIFT;
+			sector += ic->sectors_per_block;
+			logical_sector += ic->sectors_per_block;
+		} while (pos < bv.bv_len);
+	}
+free_ret:
+	mempool_free(page, &ic->recheck_pool);
+}
+
 static void integrity_metadata(struct work_struct *w)
 {
 	struct dm_integrity_io *dio = container_of(w, struct dm_integrity_io, work);
@@ -1784,15 +1859,8 @@ again:
 						checksums_ptr - checksums, dio->op == REQ_OP_READ ? TAG_CMP : TAG_WRITE);
 			if (unlikely(r)) {
 				if (r > 0) {
-					sector_t s;
-
-					s = sector - ((r + ic->tag_size - 1) / ic->tag_size);
-					DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx",
-						    bio->bi_bdev, s);
-					r = -EILSEQ;
-					atomic64_inc(&ic->number_of_mismatches);
-					dm_audit_log_bio(DM_MSG_PREFIX, "integrity-checksum",
-							 bio, s, 0);
+					integrity_recheck(dio);
+					goto skip_io;
 				}
 				if (likely(checksums != checksums_onstack))
 					kfree(checksums);
@@ -4208,6 +4276,12 @@ static int dm_integrity_ctr(struct dm_ta
 		goto bad;
 	}
 
+	r = mempool_init_page_pool(&ic->recheck_pool, 1, 0);
+	if (r) {
+		ti->error = "Cannot allocate mempool";
+		goto bad;
+	}
+
 	ic->metadata_wq = alloc_workqueue("dm-integrity-metadata",
 					  WQ_MEM_RECLAIM, METADATA_WORKQUEUE_MAX_ACTIVE);
 	if (!ic->metadata_wq) {
@@ -4572,6 +4646,7 @@ static void dm_integrity_dtr(struct dm_t
 	kvfree(ic->bbs);
 	if (ic->bufio)
 		dm_bufio_client_destroy(ic->bufio);
+	mempool_exit(&ic->recheck_pool);
 	mempool_exit(&ic->journal_io_mempool);
 	if (ic->io)
 		dm_io_client_destroy(ic->io);



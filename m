Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CFD25B0BE;
	Thu, 20 Aug 2026 17:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248179; cv=none; b=bv1ABh5OfwDwu6G2fcCQYbVlPzwl3IsgZaLPburZ9FCnLb1LRcNEqkn/RM4/qf0vn2OFA+AUoO+UvdjKi7pOWt1Dw4/pOyYtXNGq2CvRXotdmeaXBHwcItleiR+KLSnPi8pf7hqI1WEiLsN3k32+S92QTXHw2Pm4R0v2nEThPx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248179; c=relaxed/simple;
	bh=B9bSvaU8IAFyCyIHH6BTKbBqvSYFXhkNbQ62kbqzQO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1yElWwd/elKFwaPJB4uru44WdJOf4CddxDCiBnTwTI46PTCpDas6SzwZGvFkOGMLKevF9Au3N5MTO2YtoqaOaMd2lgExlhSUyJ1pi3TihhewZWQUefdMM5QVi4hzjO2wXSmNGF2DXzvIU1U218zUMAryIjfQ/VhFb4t0t3NrR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0P1GTgP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0P1GTgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7249D1F000E9;
	Thu, 20 Aug 2026 17:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248178;
	bh=kcA0f68AP/wUCvGIHhEIHI05zcLmXnS/7BtVKNBRCpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X0P1GTgPq9JkeG0qrPYfYkBazpqEt2fNeSTkqnQKigMNc8+ZpxhcMhlqP909uW66u
	 NLOOsaBwDk5xRXaLxLVGniJIxbJ5DECI99e7QLAOZcMvWGfBodBPq2scysn31riTAj
	 PKrufAgs/eQGcBbqd6csueUlgFjnpI4HT875bThA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heinz Mauelshagen <heinzm@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/303] dm: fix trailing statements
Date: Thu, 20 Aug 2026 16:54:32 +0200
Message-ID: <20260820145257.360568764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

From: Heinz Mauelshagen <heinzm@redhat.com>

[ Upstream commit 03b18887703c5fa342896e52e873812ea33d964b ]

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Stable-dep-of: edf025f08385 ("dm-integrity: don't increment hash_offset twice")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-flakey.c          |    3 --
 drivers/md/dm-integrity.c       |   54 ++++++++++++++++++++--------------------
 drivers/md/dm-io.c              |   24 +++++++++--------
 drivers/md/dm-snap-persistent.c |   20 ++++++++------
 drivers/md/dm-snap.c            |    3 --
 drivers/md/dm-table.c           |    3 --
 drivers/md/dm-verity-target.c   |    6 +---
 drivers/md/dm-writecache.c      |   12 +++++---
 8 files changed, 65 insertions(+), 60 deletions(-)

--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -356,8 +356,7 @@ static int flakey_map(struct dm_target *
 		if (test_bit(DROP_WRITES, &fc->flags)) {
 			bio_endio(bio);
 			return DM_MAPIO_SUBMITTED;
-		}
-		else if (test_bit(ERROR_WRITES, &fc->flags)) {
+		} else if (test_bit(ERROR_WRITES, &fc->flags)) {
 			bio_io_error(bio);
 			return DM_MAPIO_SUBMITTED;
 		}
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -680,16 +680,18 @@ repeat:
 	} else if (mode == BITMAP_OP_CLEAR) {
 		if (!bit && this_end_bit == PAGE_SIZE * 8 - 1)
 			clear_page(data);
-		else while (bit <= this_end_bit) {
-			if (!(bit % BITS_PER_LONG) && this_end_bit >= bit + BITS_PER_LONG - 1) {
-				do {
-					data[bit / BITS_PER_LONG] = 0;
-					bit += BITS_PER_LONG;
-				} while (this_end_bit >= bit + BITS_PER_LONG - 1);
-				continue;
+		else {
+			while (bit <= this_end_bit) {
+				if (!(bit % BITS_PER_LONG) && this_end_bit >= bit + BITS_PER_LONG - 1) {
+					do {
+						data[bit / BITS_PER_LONG] = 0;
+						bit += BITS_PER_LONG;
+					} while (this_end_bit >= bit + BITS_PER_LONG - 1);
+					continue;
+				}
+				__clear_bit(bit, data);
+				bit++;
 			}
-			__clear_bit(bit, data);
-			bit++;
 		}
 	} else {
 		BUG();
@@ -2084,23 +2086,23 @@ retry_kmap:
 				unsigned int tag_todo = ic->tag_size;
 				char *tag_ptr = journal_entry_tag(ic, je);
 
-				if (bip) do {
-					struct bio_vec biv = bvec_iter_bvec(bip->bip_vec, bip->bip_iter);
-					unsigned int tag_now = min(biv.bv_len, tag_todo);
-					char *tag_addr;
-					BUG_ON(PageHighMem(biv.bv_page));
-					tag_addr = bvec_virt(&biv);
-					if (likely(dio->op == REQ_OP_WRITE))
-						memcpy(tag_ptr, tag_addr, tag_now);
-					else
-						memcpy(tag_addr, tag_ptr, tag_now);
-					bvec_iter_advance(bip->bip_vec, &bip->bip_iter, tag_now);
-					tag_ptr += tag_now;
-					tag_todo -= tag_now;
-				} while (unlikely(tag_todo)); else {
-					if (likely(dio->op == REQ_OP_WRITE))
-						memset(tag_ptr, 0, tag_todo);
-				}
+				if (bip) {
+					do {
+						struct bio_vec biv = bvec_iter_bvec(bip->bip_vec, bip->bip_iter);
+						unsigned int tag_now = min(biv.bv_len, tag_todo);
+						char *tag_addr;
+						BUG_ON(PageHighMem(biv.bv_page));
+						tag_addr = bvec_virt(&biv);
+						if (likely(dio->op == REQ_OP_WRITE))
+							memcpy(tag_ptr, tag_addr, tag_now);
+						else
+							memcpy(tag_addr, tag_ptr, tag_now);
+						bvec_iter_advance(bip->bip_vec, &bip->bip_iter, tag_now);
+						tag_ptr += tag_now;
+						tag_todo -= tag_now;
+					} while (unlikely(tag_todo));
+				} else if (likely(dio->op == REQ_OP_WRITE))
+					memset(tag_ptr, 0, tag_todo);
 			}
 
 			if (likely(dio->op == REQ_OP_WRITE)) {
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -351,18 +351,20 @@ static void do_region(const blk_opf_t op
 			num_sectors = min_t(sector_t, special_cmd_max_sectors, remaining);
 			bio->bi_iter.bi_size = num_sectors << SECTOR_SHIFT;
 			remaining -= num_sectors;
-		} else while (remaining) {
-			/*
-			 * Try and add as many pages as possible.
-			 */
-			dp->get_page(dp, &page, &len, &offset);
-			len = min(len, to_bytes(remaining));
-			if (!bio_add_page(bio, page, len, offset))
-				break;
+		} else {
+			while (remaining) {
+				/*
+				 * Try and add as many pages as possible.
+				 */
+				dp->get_page(dp, &page, &len, &offset);
+				len = min(len, to_bytes(remaining));
+				if (!bio_add_page(bio, page, len, offset))
+					break;
 
-			offset = 0;
-			remaining -= to_sector(len);
-			dp->next_page(dp);
+				offset = 0;
+				remaining -= to_sector(len);
+				dp->next_page(dp);
+			}
 		}
 
 		atomic_inc(&io->count);
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -514,15 +514,17 @@ static int read_exceptions(struct pstore
 		if (unlikely(prefetch_area < ps->current_area))
 			prefetch_area = ps->current_area;
 
-		if (DM_PREFETCH_CHUNKS) do {
-			chunk_t pf_chunk = area_location(ps, prefetch_area);
-			if (unlikely(pf_chunk >= dm_bufio_get_device_size(client)))
-				break;
-			dm_bufio_prefetch(client, pf_chunk, 1);
-			prefetch_area++;
-			if (unlikely(!prefetch_area))
-				break;
-		} while (prefetch_area <= ps->current_area + DM_PREFETCH_CHUNKS);
+		if (DM_PREFETCH_CHUNKS) {
+			do {
+				chunk_t pf_chunk = area_location(ps, prefetch_area);
+				if (unlikely(pf_chunk >= dm_bufio_get_device_size(client)))
+					break;
+				dm_bufio_prefetch(client, pf_chunk, 1);
+				prefetch_area++;
+				if (unlikely(!prefetch_area))
+					break;
+			} while (prefetch_area <= ps->current_area + DM_PREFETCH_CHUNKS);
+		}
 
 		chunk = area_location(ps, ps->current_area);
 
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2339,8 +2339,7 @@ static void snapshot_status(struct dm_ta
 				       (unsigned long long)sectors_allocated,
 				       (unsigned long long)total_sectors,
 				       (unsigned long long)metadata_sectors);
-			}
-			else
+			} else
 				DMEMIT("Unknown");
 		}
 
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1982,8 +1982,7 @@ int dm_table_set_restrictions(struct dm_
 		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
 		if (dm_table_supports_dax(t, device_not_dax_synchronous_capable))
 			set_dax_synchronous(t->md->dax_dev);
-	}
-	else
+	} else
 		blk_queue_flag_clear(QUEUE_FLAG_DAX, q);
 
 	if (dm_table_any_dev_attr(t, device_dax_write_cache_enabled, NULL))
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -333,10 +333,8 @@ static int verity_verify_level(struct dm
 			 */
 			r = -EAGAIN;
 			goto release_ret_r;
-		}
-		else if (verity_fec_decode(v, io,
-					   DM_VERITY_BLOCK_TYPE_METADATA,
-					   hash_block, data, NULL) == 0)
+		} else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_METADATA,
+					     hash_block, data, NULL) == 0)
 			aux->hash_verified = 1;
 		else if (verity_handle_err(v,
 					   DM_VERITY_BLOCK_TYPE_METADATA,
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -941,7 +941,8 @@ static void writecache_suspend(struct dm
 	wc_lock(wc);
 	if (flush_on_suspend)
 		wc->writeback_all--;
-	while (writecache_wait_for_writeback(wc));
+	while (writecache_wait_for_writeback(wc))
+		;
 
 	if (WC_MODE_PMEM(wc))
 		persistent_memory_flush_cache(wc->memory_map, wc->memory_map_size);
@@ -2087,7 +2088,8 @@ restart:
 
 	if (unlikely(wc->writeback_all)) {
 		wc_lock(wc);
-		while (writecache_wait_for_writeback(wc));
+		while (writecache_wait_for_writeback(wc))
+			;
 		wc_unlock(wc);
 	}
 }
@@ -2445,12 +2447,14 @@ static int writecache_ctr(struct dm_targ
 			if (WC_MODE_PMEM(wc)) {
 				wc->writeback_fua = true;
 				wc->writeback_fua_set = true;
-			} else goto invalid_optional;
+			} else
+				goto invalid_optional;
 		} else if (!strcasecmp(string, "nofua")) {
 			if (WC_MODE_PMEM(wc)) {
 				wc->writeback_fua = false;
 				wc->writeback_fua_set = true;
-			} else goto invalid_optional;
+			} else
+				goto invalid_optional;
 		} else if (!strcasecmp(string, "metadata_only")) {
 			wc->metadata_only = true;
 		} else if (!strcasecmp(string, "pause_writeback") && opt_params >= 1) {



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6E02550A1;
	Thu, 17 Apr 2025 18:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913712; cv=none; b=tlVN+M9Bzmy393btlu+s9z8xKUfj77Ukv9bK4S/ubs3L0b1YUBbvHIJUQkHR2Mq6KrlstIuYY2MR6NFSaL416UtGEIE7xp5TRx6uO1YvK7ROlXny3EeSfnab67UrLiaXkr5xjpZJyoSWdFXeclnfk7lT2oLYei7ShjaGmQeUDLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913712; c=relaxed/simple;
	bh=wL4UK4POvD20JYNr0/5WEP7jL4rJ27SAAyHrgdXtA0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPGJPNvhDjT8CC4Z96OshnniKeeoFc9T4dazwrSKeFlsUFIpa5CSoZmJdf7diNjinb2s5HTQirdsGfd3izXBvmJJRtWdeXVWZokfss2BhEvrMeB8vuVN9JAIhnFRIiCLczz+3peMxJD7VZAIr3TfGtTHJ4APHkzpO+aXtDV5c+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CA5iEVQ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CA5iEVQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCE4C4CEE4;
	Thu, 17 Apr 2025 18:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913712;
	bh=wL4UK4POvD20JYNr0/5WEP7jL4rJ27SAAyHrgdXtA0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CA5iEVQ2UdZ3jeDkeFIWJg8IASdyoM4gZdXweLYdxT2wpw+T8NuUZyVxS7GoQSBKj
	 csVzkZg1T3LR3uqGVD0MtoEaF8ayvmvxDZtja//Or5rW8VeyXwNoJ3ZeWUFGkxE7nh
	 gfYVRNT8AictFQFRZ2HKpii/nV9WBF1fq3M8D7Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Wilke <work@luca-wilke.com>,
	Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.14 389/449] dm-integrity: fix non-constant-time tag verification
Date: Thu, 17 Apr 2025 19:51:17 +0200
Message-ID: <20250417175133.924386507@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jo Van Bulck <jo.vanbulck@kuleuven.be>

commit 8bde1033f9cfc1c08628255cc434c6cf39c9d9ba upstream.

When using dm-integrity in standalone mode with a keyed hmac algorithm,
integrity tags are calculated and verified internally.

Using plain memcmp to compare the stored and computed tags may leak the
position of the first byte mismatch through side-channel analysis,
allowing to brute-force expected tags in linear time (e.g., by counting
single-stepping interrupts in confidential virtual machine environments).

Co-developed-by: Luca Wilke <work@luca-wilke.com>
Signed-off-by: Luca Wilke <work@luca-wilke.com>
Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |   45 ++++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -21,6 +21,7 @@
 #include <linux/reboot.h>
 #include <crypto/hash.h>
 #include <crypto/skcipher.h>
+#include <crypto/utils.h>
 #include <linux/async_tx.h>
 #include <linux/dm-bufio.h>
 
@@ -516,7 +517,7 @@ static int sb_mac(struct dm_integrity_c
 			dm_integrity_io_error(ic, "crypto_shash_digest", r);
 			return r;
 		}
-		if (memcmp(mac, actual_mac, mac_size)) {
+		if (crypto_memneq(mac, actual_mac, mac_size)) {
 			dm_integrity_io_error(ic, "superblock mac", -EILSEQ);
 			dm_audit_log_target(DM_MSG_PREFIX, "mac-superblock", ic->ti, 0);
 			return -EILSEQ;
@@ -859,7 +860,7 @@ static void rw_section_mac(struct dm_int
 		if (likely(wr))
 			memcpy(&js->mac, result + (j * JOURNAL_MAC_PER_SECTOR), JOURNAL_MAC_PER_SECTOR);
 		else {
-			if (memcmp(&js->mac, result + (j * JOURNAL_MAC_PER_SECTOR), JOURNAL_MAC_PER_SECTOR)) {
+			if (crypto_memneq(&js->mac, result + (j * JOURNAL_MAC_PER_SECTOR), JOURNAL_MAC_PER_SECTOR)) {
 				dm_integrity_io_error(ic, "journal mac", -EILSEQ);
 				dm_audit_log_target(DM_MSG_PREFIX, "mac-journal", ic->ti, 0);
 			}
@@ -1401,10 +1402,9 @@ static bool find_newer_committed_node(st
 static int dm_integrity_rw_tag(struct dm_integrity_c *ic, unsigned char *tag, sector_t *metadata_block,
 			       unsigned int *metadata_offset, unsigned int total_size, int op)
 {
-#define MAY_BE_FILLER		1
-#define MAY_BE_HASH		2
 	unsigned int hash_offset = 0;
-	unsigned int may_be = MAY_BE_HASH | (ic->discard ? MAY_BE_FILLER : 0);
+	unsigned char mismatch_hash = 0;
+	unsigned char mismatch_filler = !ic->discard;
 
 	do {
 		unsigned char *data, *dp;
@@ -1425,7 +1425,7 @@ static int dm_integrity_rw_tag(struct dm
 		if (op == TAG_READ) {
 			memcpy(tag, dp, to_copy);
 		} else if (op == TAG_WRITE) {
-			if (memcmp(dp, tag, to_copy)) {
+			if (crypto_memneq(dp, tag, to_copy)) {
 				memcpy(dp, tag, to_copy);
 				dm_bufio_mark_partial_buffer_dirty(b, *metadata_offset, *metadata_offset + to_copy);
 			}
@@ -1433,29 +1433,30 @@ static int dm_integrity_rw_tag(struct dm
 			/* e.g.: op == TAG_CMP */
 
 			if (likely(is_power_of_2(ic->tag_size))) {
-				if (unlikely(memcmp(dp, tag, to_copy)))
-					if (unlikely(!ic->discard) ||
-					    unlikely(memchr_inv(dp, DISCARD_FILLER, to_copy) != NULL)) {
-						goto thorough_test;
-				}
+				if (unlikely(crypto_memneq(dp, tag, to_copy)))
+					goto thorough_test;
 			} else {
 				unsigned int i, ts;
 thorough_test:
 				ts = total_size;
 
 				for (i = 0; i < to_copy; i++, ts--) {
-					if (unlikely(dp[i] != tag[i]))
-						may_be &= ~MAY_BE_HASH;
-					if (likely(dp[i] != DISCARD_FILLER))
-						may_be &= ~MAY_BE_FILLER;
+					/*
+					 * Warning: the control flow must not be
+					 * dependent on match/mismatch of
+					 * individual bytes.
+					 */
+					mismatch_hash |= dp[i] ^ tag[i];
+					mismatch_filler |= dp[i] ^ DISCARD_FILLER;
 					hash_offset++;
 					if (unlikely(hash_offset == ic->tag_size)) {
-						if (unlikely(!may_be)) {
+						if (unlikely(mismatch_hash) && unlikely(mismatch_filler)) {
 							dm_bufio_release(b);
 							return ts;
 						}
 						hash_offset = 0;
-						may_be = MAY_BE_HASH | (ic->discard ? MAY_BE_FILLER : 0);
+						mismatch_hash = 0;
+						mismatch_filler = !ic->discard;
 					}
 				}
 			}
@@ -1476,8 +1477,6 @@ thorough_test:
 	} while (unlikely(total_size));
 
 	return 0;
-#undef MAY_BE_FILLER
-#undef MAY_BE_HASH
 }
 
 struct flush_request {
@@ -2076,7 +2075,7 @@ retry_kmap:
 					char checksums_onstack[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
 					integrity_sector_checksum(ic, logical_sector, mem + bv.bv_offset, checksums_onstack);
-					if (unlikely(memcmp(checksums_onstack, journal_entry_tag(ic, je), ic->tag_size))) {
+					if (unlikely(crypto_memneq(checksums_onstack, journal_entry_tag(ic, je), ic->tag_size))) {
 						DMERR_LIMIT("Checksum failed when reading from journal, at sector 0x%llx",
 							    logical_sector);
 						dm_audit_log_bio(DM_MSG_PREFIX, "journal-checksum",
@@ -2595,7 +2594,7 @@ static void dm_integrity_inline_recheck(
 		bio_put(outgoing_bio);
 
 		integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, outgoing_data, digest);
-		if (unlikely(memcmp(digest, dio->integrity_payload, min(crypto_shash_digestsize(ic->internal_hash), ic->tag_size)))) {
+		if (unlikely(crypto_memneq(digest, dio->integrity_payload, min(crypto_shash_digestsize(ic->internal_hash), ic->tag_size)))) {
 			DMERR_LIMIT("%pg: Checksum failed at sector 0x%llx",
 				ic->dev->bdev, dio->bio_details.bi_iter.bi_sector);
 			atomic64_inc(&ic->number_of_mismatches);
@@ -2634,7 +2633,7 @@ static int dm_integrity_end_io(struct dm
 				char *mem = bvec_kmap_local(&bv);
 				//memset(mem, 0xff, ic->sectors_per_block << SECTOR_SHIFT);
 				integrity_sector_checksum(ic, dio->bio_details.bi_iter.bi_sector, mem, digest);
-				if (unlikely(memcmp(digest, dio->integrity_payload + pos,
+				if (unlikely(crypto_memneq(digest, dio->integrity_payload + pos,
 						min(crypto_shash_digestsize(ic->internal_hash), ic->tag_size)))) {
 					kunmap_local(mem);
 					dm_integrity_free_payload(dio);
@@ -2911,7 +2910,7 @@ static void do_journal_write(struct dm_i
 
 					integrity_sector_checksum(ic, sec + ((l - j) << ic->sb->log2_sectors_per_block),
 								  (char *)access_journal_data(ic, i, l), test_tag);
-					if (unlikely(memcmp(test_tag, journal_entry_tag(ic, je2), ic->tag_size))) {
+					if (unlikely(crypto_memneq(test_tag, journal_entry_tag(ic, je2), ic->tag_size))) {
 						dm_integrity_io_error(ic, "tag mismatch when replaying journal", -EILSEQ);
 						dm_audit_log_target(DM_MSG_PREFIX, "integrity-replay-journal", ic->ti, 0);
 					}



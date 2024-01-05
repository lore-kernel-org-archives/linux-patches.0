Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64AE2D051;
	Fri,  5 Jan 2024 14:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ueshYNt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B83C433C7;
	Fri,  5 Jan 2024 14:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465590;
	bh=JyQvpQ5QY4Ki5CAjqIJz6pzmJzc3ATVF4/dMFbv7198=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ueshYNt9GlyrQWdvWRwl1aayFugqzDubpJ9VRkUm6wEEja2+2q4o89IimiWvw7Gei
	 QGcrcmeVfCcQpyMoggaanmXmhlQf0nMHxNphnN2A9Apkns0HFxDuMzKOt5fEvNuzpY
	 7YwdlkYohYedx1+xQuXbckXkRrhz4YAwPOzctpTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.14 20/21] dm-integrity: dont modify bios immutable bio_vec in integrity_metadata()
Date: Fri,  5 Jan 2024 15:39:07 +0100
Message-ID: <20240105143812.436516701@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143811.536282337@linuxfoundation.org>
References: <20240105143811.536282337@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit b86f4b790c998afdbc88fe1aa55cfe89c4068726 upstream.

__bio_for_each_segment assumes that the first struct bio_vec argument
doesn't change - it calls "bio_advance_iter_single((bio), &(iter),
(bvl).bv_len)" to advance the iterator. Unfortunately, the dm-integrity
code changes the bio_vec with "bv.bv_len -= pos". When this code path
is taken, the iterator would be out of sync and dm-integrity would
report errors. This happens if the machine is out of memory and
"kmalloc" fails.

Fix this bug by making a copy of "bv" and changing the copy instead.

Fixes: 7eada909bfd7 ("dm: add integrity target")
Cc: stable@vger.kernel.org	# v4.12+
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1257,11 +1257,12 @@ static void integrity_metadata(struct wo
 			checksums = checksums_onstack;
 
 		__bio_for_each_segment(bv, bio, iter, dio->orig_bi_iter) {
+			struct bio_vec bv_copy = bv;
 			unsigned pos;
 			char *mem, *checksums_ptr;
 
 again:
-			mem = (char *)kmap_atomic(bv.bv_page) + bv.bv_offset;
+			mem = (char *)kmap_atomic(bv_copy.bv_page) + bv_copy.bv_offset;
 			pos = 0;
 			checksums_ptr = checksums;
 			do {
@@ -1270,7 +1271,7 @@ again:
 				sectors_to_process -= ic->sectors_per_block;
 				pos += ic->sectors_per_block << SECTOR_SHIFT;
 				sector += ic->sectors_per_block;
-			} while (pos < bv.bv_len && sectors_to_process && checksums != checksums_onstack);
+			} while (pos < bv_copy.bv_len && sectors_to_process && checksums != checksums_onstack);
 			kunmap_atomic(mem);
 
 			r = dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->metadata_offset,
@@ -1290,9 +1291,9 @@ again:
 			if (!sectors_to_process)
 				break;
 
-			if (unlikely(pos < bv.bv_len)) {
-				bv.bv_offset += pos;
-				bv.bv_len -= pos;
+			if (unlikely(pos < bv_copy.bv_len)) {
+				bv_copy.bv_offset += pos;
+				bv_copy.bv_len -= pos;
 				goto again;
 			}
 		}



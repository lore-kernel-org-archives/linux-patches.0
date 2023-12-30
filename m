Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9162479DE;
	Sat, 30 Dec 2023 12:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykTWDBTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CDFC433C7;
	Sat, 30 Dec 2023 12:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937992;
	bh=/E1q+mNnkbZJDixEczimPNJPOknVjqo1+3f7Tfow3Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykTWDBTwoJlm8k0HWhqZete2HZPM3+Q8bTFGeFBAMSMOwGpgnUZlk0aH7iZ2X6wbJ
	 ZHrNHVHMQ+ZVDKjBqEFGDnx0tU+Bg2uMJGyuc2vY7z1p8B1vfCD/QlY9NIIryzzcLL
	 odDhNQhIYQn+7ENkrQngNKGfLZWFtEjZ76Dpzb4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.6 142/156] dm-integrity: dont modify bios immutable bio_vec in integrity_metadata()
Date: Sat, 30 Dec 2023 11:59:56 +0000
Message-ID: <20231230115816.967594033@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1765,11 +1765,12 @@ static void integrity_metadata(struct wo
 		sectors_to_process = dio->range.n_sectors;
 
 		__bio_for_each_segment(bv, bio, iter, dio->bio_details.bi_iter) {
+			struct bio_vec bv_copy = bv;
 			unsigned int pos;
 			char *mem, *checksums_ptr;
 
 again:
-			mem = bvec_kmap_local(&bv);
+			mem = bvec_kmap_local(&bv_copy);
 			pos = 0;
 			checksums_ptr = checksums;
 			do {
@@ -1778,7 +1779,7 @@ again:
 				sectors_to_process -= ic->sectors_per_block;
 				pos += ic->sectors_per_block << SECTOR_SHIFT;
 				sector += ic->sectors_per_block;
-			} while (pos < bv.bv_len && sectors_to_process && checksums != checksums_onstack);
+			} while (pos < bv_copy.bv_len && sectors_to_process && checksums != checksums_onstack);
 			kunmap_local(mem);
 
 			r = dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->metadata_offset,
@@ -1803,9 +1804,9 @@ again:
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



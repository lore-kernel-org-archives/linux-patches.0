Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7932213B2A2;
	Tue, 27 Feb 2024 13:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041045; cv=none; b=lLkPy158o7pO3PytudFJhI8yZjhcnx+q/aj6VFtCWZ6+ES9bhhUfhoUL0p0KFtetGOOoiLExiXNuXzNNEtiVm5aEqfVjS/cYFMIQ5+2m+SWmnOUbj6ykKFPQJ/nsG7Mt2jGTeYyf35yQW5lXL28CHlZCBAww3HdfpPG4bCUWLSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041045; c=relaxed/simple;
	bh=IVjK35xzIpEjQugnvd5WPBhDRfjIhGJtD9rpwdCqGbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqoKkUOChlJmHTcJcCfdc4kUvijEOO+CS+cyGd+WsAnyCx+HX1hHfVHxiJU8V0e70sHD0mgKZnZpHXy2LSGSkgBkLm9XScblBMqU6PEQUEDsQYSnFvRaUXhlYemFMx2nwUdk5zb8073Lwi54ZT+bvVO12jNUX3B8Xtu+KlEvJ9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehDeSnSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehDeSnSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C687EC43394;
	Tue, 27 Feb 2024 13:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041044;
	bh=IVjK35xzIpEjQugnvd5WPBhDRfjIhGJtD9rpwdCqGbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehDeSnSQGL/dBGzmHsA/3Ripr+1oXJ9p1FmAAPECNfH1rnDxDfAmOYvqiB4GGZNSm
	 i6zueR/IHuCb2wq5HpNBDWgyeQ5T+3ET/Wcnc0zNVqxSnDG1dguMUEf2UfYXF6wWme
	 X3e/uqCvbwMlAyo1g6D9OztFnw0aV2SPyDirctDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.7 199/334] dm-integrity, dm-verity: reduce stack usage for recheck
Date: Tue, 27 Feb 2024 14:20:57 +0100
Message-ID: <20240227131637.140887165@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 66ad2fbcdbeab0edfd40c5d94f32f053b98c2320 upstream.

The newly added integrity_recheck() function has another larger stack
allocation, just like its caller integrity_metadata(). When it gets
inlined, the combination of the two exceeds the warning limit for 32-bit
architectures and possibly risks an overflow when this is called from
a deep call chain through a file system:

drivers/md/dm-integrity.c:1767:13: error: stack frame size (1048) exceeds limit (1024) in 'integrity_metadata' [-Werror,-Wframe-larger-than]
 1767 | static void integrity_metadata(struct work_struct *w)

Since the caller at this point is done using its checksum buffer,
just reuse the same buffer in the new function to avoid the double
allocation.

[Mikulas: add "noinline" to integrity_recheck and verity_recheck.
These functions are only called on error, so they shouldn't bloat the
stack frame or code size of the caller.]

Fixes: c88f5e553fe3 ("dm-integrity: recheck the integrity tag after a failure")
Fixes: 9177f3c0dea6 ("dm-verity: recheck the hash after a failure")
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c     |   10 ++++------
 drivers/md/dm-verity-target.c |    4 ++--
 2 files changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1691,14 +1691,13 @@ failed:
 	get_random_bytes(result, ic->tag_size);
 }
 
-static void integrity_recheck(struct dm_integrity_io *dio)
+static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checksum)
 {
 	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 	struct dm_integrity_c *ic = dio->ic;
 	struct bvec_iter iter;
 	struct bio_vec bv;
 	sector_t sector, logical_sector, area, offset;
-	char checksum_onstack[max_t(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 	struct page *page;
 	void *buffer;
 
@@ -1734,9 +1733,8 @@ static void integrity_recheck(struct dm_
 				goto free_ret;
 			}
 
-			integrity_sector_checksum(ic, logical_sector, buffer,
-						  checksum_onstack);
-			r = dm_integrity_rw_tag(ic, checksum_onstack, &dio->metadata_block,
+			integrity_sector_checksum(ic, logical_sector, buffer, checksum);
+			r = dm_integrity_rw_tag(ic, checksum, &dio->metadata_block,
 						&dio->metadata_offset, ic->tag_size, TAG_CMP);
 			if (r) {
 				if (r > 0) {
@@ -1851,7 +1849,7 @@ again:
 						checksums_ptr - checksums, dio->op == REQ_OP_READ ? TAG_CMP : TAG_WRITE);
 			if (unlikely(r)) {
 				if (r > 0) {
-					integrity_recheck(dio);
+					integrity_recheck(dio, checksums);
 					goto skip_io;
 				}
 				if (likely(checksums != checksums_onstack))
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -491,8 +491,8 @@ static int verity_recheck_copy(struct dm
 	return 0;
 }
 
-static int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
-			  struct bvec_iter start, sector_t cur_block)
+static noinline int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
+				   struct bvec_iter start, sector_t cur_block)
 {
 	struct page *page;
 	void *buffer;



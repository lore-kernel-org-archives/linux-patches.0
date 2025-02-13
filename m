Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527A61411DE;
	Thu, 13 Feb 2025 15:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460569; cv=none; b=WNKi1Ni43cFfwUoIpNprfcnCqailMCXJU91ll+oUuvTOzfCp/J7nl1ArQP59VKm10Mxcl/ReOYgTymB/ZTWTp9RxtqetsImvxA2mauic6W5DAGI6q08f1jv51kaaj/sDbj8icEnuMIPAXizu+M05WP31PSGtbrFj5aOn9QGeG/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460569; c=relaxed/simple;
	bh=2TaKF1qckxmrYBWU4QgtVpCkhWixs/2tMIEOtJVVgNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6IgPJekUMkU1DTRBreGY8B5idGRCgB2gSJAgNga6iJLcrcLYc8aSL0uXUQg7nKzBHAVfq5L+U9oerbRUbpN4FHGElilXbDEePDdZmgzNtha2DyZul75vHctjGDVe77qsE3dclAiIkeN2o/xJAhYucpE/CSX7MvX02pl9mOsdh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aix9yi0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aix9yi0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EAFC4CED1;
	Thu, 13 Feb 2025 15:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460569;
	bh=2TaKF1qckxmrYBWU4QgtVpCkhWixs/2tMIEOtJVVgNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aix9yi0CQX1sVWaDCxKfdccM58k5GKFh6+/8vNrG0SGTopYh3t8TbXYxUg/GOjmrS
	 rLvHF05FTnqG3Qw8aXlCbSOK4o06RoASeoZLofDpH2YQHzC5Lqt8RVgOM4T3SifCGl
	 uIEeoFJRGXD5OUVAiuJ5N2WHq8Pgz+TIxd6CaItI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 150/273] dm-crypt: dont update io->sector after kcryptd_crypt_write_io_submit()
Date: Thu, 13 Feb 2025 15:28:42 +0100
Message-ID: <20250213142413.263738922@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

commit 9fdbbdbbc92b1474a87b89f8b964892a63734492 upstream.

The updates of io->sector are the leftovers when dm-crypt allocated
pages for partial write request. However, since commit cf2f1abfbd0db
("dm crypt: don't allocate pages for a partial request"), there is no
partial request anymore.

After the introduction of write request rb-tree, the updates of
io->sectors may interfere the insertion procedure, because ->sectors of
these write requests which have already been added in the rb-tree may be
changed during the insertion of new write request.

Fix it by removing these buggy updates of io->sectors. Considering these
updates only effect the write request rb-tree, the commit which
introduces the write request rb-tree is used as the fix tag.

Fixes: b3c5fd305249 ("dm crypt: sort writes")
Cc: stable@vger.kernel.org
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-crypt.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2068,7 +2068,6 @@ static void kcryptd_crypt_write_continue
 	struct crypt_config *cc = io->cc;
 	struct convert_context *ctx = &io->ctx;
 	int crypt_finished;
-	sector_t sector = io->sector;
 	blk_status_t r;
 
 	wait_for_completion(&ctx->restart);
@@ -2085,10 +2084,8 @@ static void kcryptd_crypt_write_continue
 	}
 
 	/* Encryption was already finished, submit io now */
-	if (crypt_finished) {
+	if (crypt_finished)
 		kcryptd_crypt_write_io_submit(io, 0);
-		io->sector = sector;
-	}
 
 	crypt_dec_pending(io);
 }
@@ -2099,14 +2096,13 @@ static void kcryptd_crypt_write_convert(
 	struct convert_context *ctx = &io->ctx;
 	struct bio *clone;
 	int crypt_finished;
-	sector_t sector = io->sector;
 	blk_status_t r;
 
 	/*
 	 * Prevent io from disappearing until this function completes.
 	 */
 	crypt_inc_pending(io);
-	crypt_convert_init(cc, ctx, NULL, io->base_bio, sector);
+	crypt_convert_init(cc, ctx, NULL, io->base_bio, io->sector);
 
 	clone = crypt_alloc_buffer(io, io->base_bio->bi_iter.bi_size);
 	if (unlikely(!clone)) {
@@ -2123,8 +2119,6 @@ static void kcryptd_crypt_write_convert(
 		io->ctx.iter_in = clone->bi_iter;
 	}
 
-	sector += bio_sectors(clone);
-
 	crypt_inc_pending(io);
 	r = crypt_convert(cc, ctx,
 			  test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags), true);
@@ -2148,10 +2142,8 @@ static void kcryptd_crypt_write_convert(
 	}
 
 	/* Encryption was already finished, submit io now */
-	if (crypt_finished) {
+	if (crypt_finished)
 		kcryptd_crypt_write_io_submit(io, 0);
-		io->sector = sector;
-	}
 
 dec:
 	crypt_dec_pending(io);



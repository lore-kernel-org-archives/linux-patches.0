Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4621494BB;
	Tue, 11 Mar 2025 15:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706869; cv=none; b=VHNGjqhJ0Dzjcg+xxIgNsJIYa8vRF83P2ZclNLAd08jnPKj7xACSCcEwOPos+/jjyxLO4YbmAORSgTBk7v6kioPg7zXffUziF2GUD3/8J3aXoVlKHEZq3jC0ZLdRy7IFMIK3mZan5d+FrAU/3nOR5FAhrT/efQFxiVmAQUX25bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706869; c=relaxed/simple;
	bh=rAwzPdP1XB3LDjQ7VnLYDFOVlNwMIVlpu12NWlSSo9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JE6jJ1iH121jG0DVl9ckNLnCJbpS8Al7+ZY2+OZSR4rlxDcGZOXXk/3AOK3BShDzv6/7i+DHNcdokIsQd73W/4HjIgca7AbQkSPEPVJm26uRRQwdV6Y2+IsMR2xqXd60nUu0m64lsTUlyZvF6dN8jM6f2h8TN3yUX+YnzJXUL18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A05PDiqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A05PDiqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260F6C4CEE9;
	Tue, 11 Mar 2025 15:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706869;
	bh=rAwzPdP1XB3LDjQ7VnLYDFOVlNwMIVlpu12NWlSSo9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A05PDiqviLBgTuEUHySPQDM8yZwAN6unGna3UriwB2c8UrrrkH05NL8SouyIe2sY4
	 iaATj0prbMQ8LbwexInbsFCOI5rtAPtMQfqeoWqrhO/mTI+bG6/6GrOyyRjMZQlB10
	 kxpdYAG3JbtH2ZnUEb0rfuPcJxtxfMk9GExNdrsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 195/462] dm-crypt: dont update io->sector after kcryptd_crypt_write_io_submit()
Date: Tue, 11 Mar 2025 15:57:41 +0100
Message-ID: <20250311145806.060956080@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2015,7 +2015,6 @@ static void kcryptd_crypt_write_continue
 	struct crypt_config *cc = io->cc;
 	struct convert_context *ctx = &io->ctx;
 	int crypt_finished;
-	sector_t sector = io->sector;
 	blk_status_t r;
 
 	wait_for_completion(&ctx->restart);
@@ -2032,10 +2031,8 @@ static void kcryptd_crypt_write_continue
 	}
 
 	/* Encryption was already finished, submit io now */
-	if (crypt_finished) {
+	if (crypt_finished)
 		kcryptd_crypt_write_io_submit(io, 0);
-		io->sector = sector;
-	}
 
 	crypt_dec_pending(io);
 }
@@ -2046,14 +2043,13 @@ static void kcryptd_crypt_write_convert(
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
@@ -2070,8 +2066,6 @@ static void kcryptd_crypt_write_convert(
 		io->ctx.iter_in = clone->bi_iter;
 	}
 
-	sector += bio_sectors(clone);
-
 	crypt_inc_pending(io);
 	r = crypt_convert(cc, ctx,
 			  test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags), true);
@@ -2095,10 +2089,8 @@ static void kcryptd_crypt_write_convert(
 	}
 
 	/* Encryption was already finished, submit io now */
-	if (crypt_finished) {
+	if (crypt_finished)
 		kcryptd_crypt_write_io_submit(io, 0);
-		io->sector = sector;
-	}
 
 dec:
 	crypt_dec_pending(io);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FD31BEF77;
	Wed, 19 Feb 2025 09:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957144; cv=none; b=tnL8Po5skhbdFXerCdORirMnXjVGaN6nm+AAEelPMGLfQO5r9eR5+1lJ1ZKVisBzHLIArekcVVDd293mi8AsZn/b8rhTmpAMJEELar0pTzE4hlpzbK2DD89mOy9Z4Z6py63+PAUD/ozcyr6UydekT5QOXsWOd16SWjZp2H6x6eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957144; c=relaxed/simple;
	bh=6NiSsHeo+xskx4Xw/qByjcG6ylA1zU1ECLnSKJQmdf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/+a/sBTn23PMNOKp8jm6Qz+NSvFxHQOCQFlTbr8U4ZNxrbRgmtIZoQnabLfBRftayFriNKznli1x+DX464Eup5K/OliJzyyC8OjQLoBdM5UsdsJa4m7uoNQwkWEtIpNhPpmxyljRCmOLQ7+6MEGsoHfBkk+YzgBSJ9+I9lTn+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wELKlUkk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wELKlUkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C222C4CED1;
	Wed, 19 Feb 2025 09:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957143;
	bh=6NiSsHeo+xskx4Xw/qByjcG6ylA1zU1ECLnSKJQmdf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wELKlUkkGt86ZO9XrG1BpBtz6HUrmtYTquaJvukWofXVbX/SqsoVLCndXe3IFwBxO
	 61AvYQYthPBYE9u6OKOEizrPfNUMJdwnHUCPBR0BKCTls/zqQYSIPIXe/+4gIu3sZH
	 6LD9Wg18MOjNKHYwURvL9BztqghbtUtAqStHzL5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 382/578] dm-crypt: dont update io->sector after kcryptd_crypt_write_io_submit()
Date: Wed, 19 Feb 2025 09:26:26 +0100
Message-ID: <20250219082708.043741951@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2029,7 +2029,6 @@ static void kcryptd_crypt_write_continue
 	struct crypt_config *cc = io->cc;
 	struct convert_context *ctx = &io->ctx;
 	int crypt_finished;
-	sector_t sector = io->sector;
 	blk_status_t r;
 
 	wait_for_completion(&ctx->restart);
@@ -2046,10 +2045,8 @@ static void kcryptd_crypt_write_continue
 	}
 
 	/* Encryption was already finished, submit io now */
-	if (crypt_finished) {
+	if (crypt_finished)
 		kcryptd_crypt_write_io_submit(io, 0);
-		io->sector = sector;
-	}
 
 	crypt_dec_pending(io);
 }
@@ -2060,14 +2057,13 @@ static void kcryptd_crypt_write_convert(
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
@@ -2084,8 +2080,6 @@ static void kcryptd_crypt_write_convert(
 		io->ctx.iter_in = clone->bi_iter;
 	}
 
-	sector += bio_sectors(clone);
-
 	crypt_inc_pending(io);
 	r = crypt_convert(cc, ctx,
 			  test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags), true);
@@ -2109,10 +2103,8 @@ static void kcryptd_crypt_write_convert(
 	}
 
 	/* Encryption was already finished, submit io now */
-	if (crypt_finished) {
+	if (crypt_finished)
 		kcryptd_crypt_write_io_submit(io, 0);
-		io->sector = sector;
-	}
 
 dec:
 	crypt_dec_pending(io);



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1661C158A3F;
	Tue, 23 Jul 2024 18:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760134; cv=none; b=Jv7hA/gzLTpTJbWuuVvTqJuZPH1G47sDQyS2APXUr6LK9EGqYlw/bcWQi2bXebj4uqsJo4MHiYBOpXiTgRqnFpY+JAzI40/3Gg53/8K+ykEdN9ti82wyCiSLPZtvDbg1mLgwKv4QnAQpZZVazjGfEsFxk0xRFMZ2TpBa9P/KF6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760134; c=relaxed/simple;
	bh=9o2uyzxOAgHx7B9rrgMlsYi1GeH0r1YS/s7NOpQiHP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2w7p8fq5aS2bUlgQ+f+7dtdBr01xeeXNWmxwCajAzONmoS1HCDsY5JRgDC1hZNi2wum8ntQUyA3iwjtMDPIPfM0Wf/xjMow6CQbArJRakHGMXr2o5nK7eH0AjeIzq2piFyAknn40QOmucJvCQbLUV9O/ACmyt4Zuhp3WQmBRwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hr9vmoEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hr9vmoEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F64EC4AF09;
	Tue, 23 Jul 2024 18:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760134;
	bh=9o2uyzxOAgHx7B9rrgMlsYi1GeH0r1YS/s7NOpQiHP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hr9vmoEVHOoSm0FSAZpk2gMeQoeSqlD1X4tf0DUt/QTdKrM87gnL8DOTWfAed2cgL
	 Jaoa48d5cfTb2ZuN1bScQBPiZayFZYIPOgPPwZjGWHpt+EiL5IAdtJHG7oqizOY/KT
	 t+dZZ+bBs1tlGYoz/QveIPxTpklwVLlTODBizHUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 114/163] btrfs: scrub: handle RST lookup error correctly
Date: Tue, 23 Jul 2024 20:24:03 +0200
Message-ID: <20240723180147.878755416@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 2c49908634a2b97b1c3abe0589be2739ac5e7fd5 ]

[BUG]
When running btrfs/060 with forced RST feature, it would crash the
following ASSERT() inside scrub_read_endio():

	ASSERT(sector_nr < stripe->nr_sectors);

Before that, we would have tree dump from
btrfs_get_raid_extent_offset(), as we failed to find the RST entry for
the range.

[CAUSE]
Inside scrub_submit_extent_sector_read() every time we allocated a new
bbio we immediately called btrfs_map_block() to make sure there was some
RST range covering the scrub target.

But if btrfs_map_block() fails, we immediately call endio for the bbio,
while the bbio is newly allocated, it's completely empty.

Then inside scrub_read_endio(), we go through the bvecs to find
the sector number (as bi_sector is no longer reliable if the bio is
submitted to lower layers).

And since the bio is empty, such bvecs iteration would not find any
sector matching the sector, and return sector_nr == stripe->nr_sectors,
triggering the ASSERT().

[FIX]
Instead of calling btrfs_map_block() after allocating a new bbio, call
btrfs_map_block() first.

Since our only objective of calling btrfs_map_block() is only to update
stripe_len, there is really no need to do that after btrfs_alloc_bio().

This new timing would avoid the problem of handling empty bbio
completely, and in fact fixes a possible race window for the old code,
where if the submission thread is the only owner of the pending_io, the
scrub would never finish (since we didn't decrease the pending_io
counter).

Although the root cause of RST lookup failure still needs to be
addressed.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index afd6932f5e895..d7caa3732f074 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1688,20 +1688,24 @@ static void scrub_submit_extent_sector_read(struct scrub_ctx *sctx,
 					    (i << fs_info->sectorsize_bits);
 			int err;
 
-			bbio = btrfs_bio_alloc(stripe->nr_sectors, REQ_OP_READ,
-					       fs_info, scrub_read_endio, stripe);
-			bbio->bio.bi_iter.bi_sector = logical >> SECTOR_SHIFT;
-
 			io_stripe.is_scrub = true;
+			stripe_len = (nr_sectors - i) << fs_info->sectorsize_bits;
+			/*
+			 * For RST cases, we need to manually split the bbio to
+			 * follow the RST boundary.
+			 */
 			err = btrfs_map_block(fs_info, BTRFS_MAP_READ, logical,
-					      &stripe_len, &bioc, &io_stripe,
-					      &mirror);
+					      &stripe_len, &bioc, &io_stripe, &mirror);
 			btrfs_put_bioc(bioc);
-			if (err) {
-				btrfs_bio_end_io(bbio,
-						 errno_to_blk_status(err));
-				return;
+			if (err < 0) {
+				set_bit(i, &stripe->io_error_bitmap);
+				set_bit(i, &stripe->error_bitmap);
+				continue;
 			}
+
+			bbio = btrfs_bio_alloc(stripe->nr_sectors, REQ_OP_READ,
+					       fs_info, scrub_read_endio, stripe);
+			bbio->bio.bi_iter.bi_sector = logical >> SECTOR_SHIFT;
 		}
 
 		__bio_add_page(&bbio->bio, page, fs_info->sectorsize, pgoff);
-- 
2.43.0




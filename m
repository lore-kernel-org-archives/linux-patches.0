Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C0C4C10FA;
	Thu, 17 Sep 2026 15:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659251; cv=none; b=JCtrsy/BIoY5V79VpCbzsqzVFYrG7kdtO/KewYZh8Z7Aw+h7WcnLrvUyXYM1HoutooC+U5ERHRdIJzloUjfvkGmRsOTRekk80z39vce04phEc1lElHkym6X776jLev7wYEonhI9treRoTkTkIEst7IX7f319dR/bunS9Ai4p4NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659251; c=relaxed/simple;
	bh=5Onsmavx3uL5QsIurZKjj2hya+GFmgET6gWT8FdEIMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+hwZtsOsCgc8+Zdlvq7KBmpO4TuXzNEHXn1pwCS+v8ZFDmIZ/HG1ay9t/o8D1S7tFjRLwSj02DS/H2G3f7FL62BVyqx5W1NRLgZHCuUcjxBE9N9xi/VkXf/TM2Va0O4IrvMKQd6WF217e/rqxxsodXDE0CV8Xr5kIMrMr9o5JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfR9KrHX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfR9KrHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE3C1F0089A;
	Thu, 17 Sep 2026 15:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659245;
	bh=nAW+c2yBuY0q3CGlJc35fRXcoUUkJzo8Vk1ZtojW71I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfR9KrHXlBClGHhe2lLsowjxSYNOrQxtXOKW5kBxo0TP1A9EG4NTIiwOcXq9fq/4q
	 vTsqfxuL/edjh1F2St+V/2bkrIBS+Y8nJGfyG/k63mkbSXNpaKqwTdJUIcj7FAtEdM
	 OIZw6MWGIVje22skKaRva8X4GQWsBQE3nIwsjjdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	"James C. Owens" <jamesowens@optonline.net>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 191/733] btrfs: scrub: report the failing sectors address, not the stripe base
Date: Thu, 17 Sep 2026 16:08:19 +0100
Message-ID: <20260917151355.906055126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James C. Owens <jamesowens@optonline.net>

[ Upstream commit 33ce0aa4c57611c3a3485ec7c01ad67b3751447d ]

scrub_stripe_report_errors() iterates over the sectors of a stripe, but
every message it emits passes stripe->logical, the address of the first
sector of the 64KiB stripe, rather than the address of the sector being
reported. The physical address is likewise computed once, before the
loop, from stripe->logical.

This matters because scrub_print_common_warning() uses that logical
address for the backref walk which produces the "root %llu inode %llu
offset %llu ... (path: ...)" part of the message. As the address is
always the stripe base, the reported root/inode/offset/path can identify
a different file from the one whose sector actually failed.

A 64KiB stripe routinely spans several extents belonging to unrelated
files. On the machine where this was found, the stripe at logical
0x17D9380000 holds four sectors of /usr/share/plasma/emoji/bg.dict, then
a file inside a docker volume, then sectors referenced only by
snapshots. Every error anywhere in that stripe is attributed to bg.dict.

The effect is visible statistically: across ten months and four kernel
series that machine logged 81 distinct flagged logical addresses, and
every one of them is exactly 64KiB aligned. Since BTRFS_STRIPE_LEN is
64KiB and stripe->logical is stripe aligned by construction, real
failures distributed across sectors could not produce that.

Report the address of the sector actually being examined. Adding the
sector offset to the physical address is valid because BTRFS_STRIPE_LEN
is the unit contiguous on a single device for every profile, so a stripe
never crosses a device boundary.

Fixes: 0096580713ff ("btrfs: scrub: introduce error reporting functionality for scrub_stripe")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: James C. Owens <jamesowens@optonline.net>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index d2f7ac5b6e961..3b3f04521369d 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1041,6 +1041,10 @@ static void scrub_stripe_report_errors(struct scrub_ctx *sctx,
 
 skip:
 	for_each_set_bit(sector_nr, &extent_bitmap, stripe->nr_sectors) {
+		const u64 sector_logical = stripe->logical +
+					   ((u64)sector_nr << fs_info->sectorsize_bits);
+		const u64 sector_physical = physical +
+					   ((u64)sector_nr << fs_info->sectorsize_bits);
 		bool repaired = false;
 
 		if (scrub_bitmap_test_bit_is_metadata(stripe, sector_nr)) {
@@ -1069,12 +1073,12 @@ static void scrub_stripe_report_errors(struct scrub_ctx *sctx,
 			if (dev) {
 				btrfs_err_rl(fs_info,
 		"scrub: fixed up error at logical %llu on dev %s physical %llu",
-					    stripe->logical, btrfs_dev_name(dev),
-					    physical);
+					    sector_logical, btrfs_dev_name(dev),
+					    sector_physical);
 			} else {
 				btrfs_err_rl(fs_info,
 			   "scrub: fixed up error at logical %llu on mirror %u",
-					    stripe->logical, stripe->mirror_num);
+					    sector_logical, stripe->mirror_num);
 			}
 			continue;
 		}
@@ -1083,30 +1087,30 @@ static void scrub_stripe_report_errors(struct scrub_ctx *sctx,
 		if (dev) {
 			btrfs_err_rl(fs_info,
 "scrub: unable to fixup (regular) error at logical %llu on dev %s physical %llu",
-					    stripe->logical, btrfs_dev_name(dev),
-					    physical);
+					    sector_logical, btrfs_dev_name(dev),
+					    sector_physical);
 		} else {
 			btrfs_err_rl(fs_info,
 	  "scrub: unable to fixup (regular) error at logical %llu on mirror %u",
-					    stripe->logical, stripe->mirror_num);
+					    sector_logical, stripe->mirror_num);
 		}
 
 		if (scrub_bitmap_test_bit_io_error(stripe, sector_nr))
 			if (__ratelimit(&rs) && dev)
 				scrub_print_common_warning("i/o error", dev, false,
-						     stripe->logical, physical);
+						     sector_logical, sector_physical);
 		if (scrub_bitmap_test_bit_csum_error(stripe, sector_nr))
 			if (__ratelimit(&rs) && dev)
 				scrub_print_common_warning("checksum error", dev, false,
-						     stripe->logical, physical);
+						     sector_logical, sector_physical);
 		if (scrub_bitmap_test_bit_meta_error(stripe, sector_nr))
 			if (__ratelimit(&rs) && dev)
 				scrub_print_common_warning("header error", dev, false,
-						     stripe->logical, physical);
+						     sector_logical, sector_physical);
 		if (scrub_bitmap_test_bit_meta_gen_error(stripe, sector_nr))
 			if (__ratelimit(&rs) && dev)
 				scrub_print_common_warning("generation error", dev, false,
-						     stripe->logical, physical);
+						     sector_logical, sector_physical);
 	}
 
 	/* Update the device stats. */
-- 
2.53.0




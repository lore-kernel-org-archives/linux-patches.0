Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F31C47CA79;
	Thu, 20 Aug 2026 16:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244218; cv=none; b=riBxptsKyMr8wkZiH+cDuIPLCQsseJGcFDcZbsRHWVJxVB2lfGewYCmS5mRhw7bANxNpb+EJ0h1l8RRssuETfylp31ZuKl4CTt+OA4Mf/mcsB+rZGHql7m13i/uOIbaCWD0Jr/P1J7bduREfPw+HZagUjq0rwU9OAonkd3soznk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244218; c=relaxed/simple;
	bh=TSd1jPe92BShuyfX0Cco4LpIv0X3lrFEzFXV+voh0O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2aBLOpbbCBQpE/iK5oqA6I1HdBITMdOmv5FJtbv9QJ8UVrapZ6+VJSroUnlTpLMNj9or0J3dR8NEiP0IB2xliodpIP8Z0fyzxNfT5FbEaPVlyxp6C0J5H4PQgq5XKRdbvrW31WHwZ60fLo5K57QS5lVptGlk+iidjrhh2TrUrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pojgfTRx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pojgfTRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F081F000E9;
	Thu, 20 Aug 2026 16:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244217;
	bh=p/CM70jWYzvcDDhkQBkQlCv3v4HIeL6Sv193HH6gzNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pojgfTRxx/PBVARdtnyXipNd3T8IjEHyB5yi+n8y+RWymaC/ZfFzcVbP0cNnFVBpd
	 IE40fZ+BtPYJMYnJJDJAJEkVecEbMwyGKEgOtHyZ86DjSWln+IQpwBzqt3SoYYiqPC
	 4K1oUQoqOw1N2rhp8MBT7GoY8zgYWCQxUjj6JX6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/235] mtd: spi-nor: sst: remove global protection flag
Date: Thu, 20 Aug 2026 16:55:27 +0200
Message-ID: <20260820145219.217543695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <michael@walle.cc>

[ Upstream commit a833383732116c2afe665520bbe6951999631ef1 ]

This is considered bad for the following reasons:
 (1) We only support the block protection with BPn bits for write
     protection. Not all SST parts support this.
 (2) Newly added flash chip will automatically inherit the "has
     locking" support and thus needs to explicitly tested. Better
     be opt-in instead of opt-out.
 (3) There are already supported flashes which doesn't support
     the locking scheme. So I assume this wasn't properly tested
     before adding that chip; which enforces my previous argument
     that locking support should be an opt-in.

Remove the global flag and add individual flags to all flashes
which supports BP locking. In particular the following flashes
don't support the BP scheme:
 - SST26VF016B
 - SST26WF016B
 - SST26VF064B

Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20201203162959.29589-5-michael@walle.cc
Stable-dep-of: e1d456b26bf2 ("mtd: spi-nor: swp: Improve locking user experience")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/sst.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

--- a/drivers/mtd/spi-nor/sst.c
+++ b/drivers/mtd/spi-nor/sst.c
@@ -11,27 +11,27 @@
 static const struct flash_info sst_parts[] = {
 	/* SST -- large erase sizes are "overlays", "sectors" are 4K */
 	{ "sst25vf040b", INFO(0xbf258d, 0, 64 * 1024,  8,
-			      SECT_4K | SST_WRITE) },
+			      SECT_4K | SST_WRITE | SPI_NOR_HAS_LOCK) },
 	{ "sst25vf080b", INFO(0xbf258e, 0, 64 * 1024, 16,
-			      SECT_4K | SST_WRITE) },
+			      SECT_4K | SST_WRITE | SPI_NOR_HAS_LOCK) },
 	{ "sst25vf016b", INFO(0xbf2541, 0, 64 * 1024, 32,
-			      SECT_4K | SST_WRITE) },
+			      SECT_4K | SST_WRITE | SPI_NOR_HAS_LOCK) },
 	{ "sst25vf032b", INFO(0xbf254a, 0, 64 * 1024, 64,
-			      SECT_4K | SST_WRITE) },
+			      SECT_4K | SST_WRITE | SPI_NOR_HAS_LOCK) },
 	{ "sst25vf064c", INFO(0xbf254b, 0, 64 * 1024, 128,
-			      SECT_4K | SPI_NOR_4BIT_BP) },
+			      SECT_4K | SPI_NOR_4BIT_BP | SPI_NOR_HAS_LOCK) },
 	{ "sst25wf512",  INFO(0xbf2501, 0, 64 * 1024,  1,
-			      SECT_4K | SST_WRITE) },
+			      SECT_4K | SST_WRITE | SPI_NOR_HAS_LOCK) },
 	{ "sst25wf010",  INFO(0xbf2502, 0, 64 * 1024,  2,
-			      SECT_4K | SST_WRITE) },
+			      SECT_4K | SST_WRITE | SPI_NOR_HAS_LOCK) },
 	{ "sst25wf020",  INFO(0xbf2503, 0, 64 * 1024,  4,
-			      SECT_4K | SST_WRITE) },
-	{ "sst25wf020a", INFO(0x621612, 0, 64 * 1024,  4, SECT_4K) },
-	{ "sst25wf040b", INFO(0x621613, 0, 64 * 1024,  8, SECT_4K) },
+			      SECT_4K | SST_WRITE | SPI_NOR_HAS_LOCK) },
+	{ "sst25wf020a", INFO(0x621612, 0, 64 * 1024,  4, SECT_4K | SPI_NOR_HAS_LOCK) },
+	{ "sst25wf040b", INFO(0x621613, 0, 64 * 1024,  8, SECT_4K | SPI_NOR_HAS_LOCK) },
 	{ "sst25wf040",  INFO(0xbf2504, 0, 64 * 1024,  8,
-			      SECT_4K | SST_WRITE) },
+			      SECT_4K | SST_WRITE | SPI_NOR_HAS_LOCK) },
 	{ "sst25wf080",  INFO(0xbf2505, 0, 64 * 1024, 16,
-			      SECT_4K | SST_WRITE) },
+			      SECT_4K | SST_WRITE | SPI_NOR_HAS_LOCK) },
 	{ "sst26wf016b", INFO(0xbf2651, 0, 64 * 1024, 32,
 			      SECT_4K | SPI_NOR_DUAL_READ |
 			      SPI_NOR_QUAD_READ) },
@@ -141,11 +141,6 @@ out:
 	return ret;
 }
 
-static void sst_default_init(struct spi_nor *nor)
-{
-	nor->flags |= SNOR_F_HAS_LOCK;
-}
-
 static void sst_post_sfdp_fixups(struct spi_nor *nor)
 {
 	if (nor->info->flags & SST_WRITE)
@@ -153,7 +148,6 @@ static void sst_post_sfdp_fixups(struct
 }
 
 static const struct spi_nor_fixups sst_fixups = {
-	.default_init = sst_default_init,
 	.post_sfdp = sst_post_sfdp_fixups,
 };
 



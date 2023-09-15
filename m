Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B243018E1B
	for <patches@lists.linux.dev>; Fri, 15 Sep 2023 22:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OTSjAv0PEMH+tCuP3ffDEqRz+yWbCz97RfaFT2lMORg=; b=xX7TFA9kztVjOz7d+p1P/TM7Ay
	nomWAhSivQ5lCdYaAeQK3cLiJwl2lWQjj7B6LNKYf1vfNWGbzkrCZMyNLm6Xz2TU9IbPPJp2V9vDp
	sQRh+Sstun+Z0VSd9LRO9XmHZ18g7f+6Gk3qAyBGtCb7Db23OD+grSKpMAjzWlAHpruUvoReSSHoL
	FVA7AVwZFM51kSRVjdptDf4W4Ul1PNFHmTYueINUMel+3WCyzzfPJyYQBgAqmZUxP6GWv6YGQdUCU
	nybG1VZrotzL0I0hsJgT58ibcJ778KXSwP4LuGA3/rm7WCzSQLcDIh/QqPl2oLQ441Z3Dm7mjfkmU
	FcOwZwkA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qhHXM-00BUtT-38;
	Fri, 15 Sep 2023 22:43:44 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com,
	christoph.boehmwalder@linbit.com,
	hch@infradead.org,
	djwong@kernel.org,
	minchan@kernel.org,
	senozhatsky@chromium.org
Cc: patches@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com,
	drbd-dev@lists.linbit.com,
	linux-kernel@vger.kernel.org,
	willy@infradead.org,
	hare@suse.de,
	p.raghav@samsung.com,
	da.gomez@samsung.com,
	rohan.puri@samsung.com,
	rpuri.linux@gmail.com,
	kbusch@kernel.org,
	mcgrof@kernel.org
Subject: [PATCH v3 4/4] zram: use generic PAGE_SECTORS and PAGE_SECTORS_SHIFT
Date: Fri, 15 Sep 2023 15:43:43 -0700
Message-Id: <20230915224343.2740317-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230915224343.2740317-1-mcgrof@kernel.org>
References: <20230915224343.2740317-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Instead of re-defining the already existing constants use the provided ones:

So replace:

 o SECTORS_PER_PAGE_SHIFT with PAGE_SECTORS_SHIFT
 o SECTORS_PER_PAGE       with PAGE_SECTORS
 o SECTORS_PER_PAGE - 1   with SECTOR_MASK

This produces no functional changes.

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/zram/zram_drv.c | 15 ++++++---------
 drivers/block/zram/zram_drv.h |  2 --
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 06673c6ca255..58d36c8574d4 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1834,9 +1834,8 @@ static ssize_t recompress_store(struct device *dev,
 static void zram_bio_discard(struct zram *zram, struct bio *bio)
 {
 	size_t n = bio->bi_iter.bi_size;
-	u32 index = bio->bi_iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
-	u32 offset = (bio->bi_iter.bi_sector & (SECTORS_PER_PAGE - 1)) <<
-			SECTOR_SHIFT;
+	u32 index = bio->bi_iter.bi_sector >> PAGE_SECTORS_SHIFT;
+	u32 offset = (bio->bi_iter.bi_sector & SECTOR_MASK) << SECTOR_SHIFT;
 
 	/*
 	 * zram manages data in physical block size units. Because logical block
@@ -1874,9 +1873,8 @@ static void zram_bio_read(struct zram *zram, struct bio *bio)
 	struct bvec_iter iter = bio->bi_iter;
 
 	do {
-		u32 index = iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
-		u32 offset = (iter.bi_sector & (SECTORS_PER_PAGE - 1)) <<
-				SECTOR_SHIFT;
+		u32 index = iter.bi_sector >> PAGE_SECTORS_SHIFT;
+		u32 offset = (iter.bi_sector & SECTOR_MASK) << SECTOR_SHIFT;
 		struct bio_vec bv = bio_iter_iovec(bio, iter);
 
 		bv.bv_len = min_t(u32, bv.bv_len, PAGE_SIZE - offset);
@@ -1905,9 +1903,8 @@ static void zram_bio_write(struct zram *zram, struct bio *bio)
 	struct bvec_iter iter = bio->bi_iter;
 
 	do {
-		u32 index = iter.bi_sector >> SECTORS_PER_PAGE_SHIFT;
-		u32 offset = (iter.bi_sector & (SECTORS_PER_PAGE - 1)) <<
-				SECTOR_SHIFT;
+		u32 index = iter.bi_sector >> PAGE_SECTORS_SHIFT;
+		u32 offset = (iter.bi_sector & SECTOR_MASK) << SECTOR_SHIFT;
 		struct bio_vec bv = bio_iter_iovec(bio, iter);
 
 		bv.bv_len = min_t(u32, bv.bv_len, PAGE_SIZE - offset);
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index ca7a15bd4845..9f2543af5c76 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -21,8 +21,6 @@
 
 #include "zcomp.h"
 
-#define SECTORS_PER_PAGE_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
-#define SECTORS_PER_PAGE	(1 << SECTORS_PER_PAGE_SHIFT)
 #define ZRAM_LOGICAL_BLOCK_SHIFT 12
 #define ZRAM_LOGICAL_BLOCK_SIZE	(1 << ZRAM_LOGICAL_BLOCK_SHIFT)
 #define ZRAM_SECTOR_PER_LOGICAL_BLOCK	\
-- 
2.39.2


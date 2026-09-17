Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B323B14A2;
	Thu, 17 Sep 2026 18:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671547; cv=none; b=Q/krizUia+NmPmjDC5rVpLNkRwWPZcNBKJKtJFB2EBpVeCcKGOR6nNWwzK/6Ec7xk6D3nIuTAIndi1WCmxixlz1QvfdeR5Bk6JC2djDUmMsmSVXCvFxMUpwVKd4aInL9hyNUB8OLzSWJNIsQ7+rvELKaKN2O7/I7IHYY7Ub2zv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671547; c=relaxed/simple;
	bh=cYB4o/tYFhitt2cXLS7TdpP5q3dpJ2Vmyjrii5HpOWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ksf64ENLPsez7gUmBV1s4Fz5h/MZnLe8wNCF3xbJBSN08I3NAed+0RVpXLE6b0teLPgGl1fjjiap9Vp0rZOFT7yVODqQurtYQaOiDWa46LmFsIWxkwXqN5nqAWXBs4vJY2w2JBmYwAqzAJzu9TFIUVHGivBf8vzeg9LRSPvwG2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKYFgpgN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKYFgpgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FF31F000FF;
	Thu, 17 Sep 2026 18:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671546;
	bh=voU5bdB/FHxu09vqlATm05DYREYDzvs3s/W8R/tKs1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aKYFgpgNw9KBhLvHRgEgOy3WNGgmgpiE+v/E3eCWwZ4yMCIqMnyxh6j7c0IrBVU4x
	 vcuqc/8zvbm0i61D7naIlaJN3OU8RlATmiyTkAI1Nbp7W72w7Kr2HSuali5Fp3LEyV
	 ZKqdfflpO3PPl34ME/j9PZTXIaYKhsgLZ/Qr8DDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1013/1102] zram: remove entry element member
Date: Thu, 17 Sep 2026 16:15:56 +0100
Message-ID: <20260917151606.182637368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit b4444a849f1827c04df81a6f1ef26ddb6f072a94 ]

Element is in the same anon union as handle and hence holds the same
value, which makes code below sort of confusing

    handle = zram_get_handle()
    if (!handle)
	element = zram_get_element()

Element doesn't really simplify the code, let's just remove it.  We
already re-purpose handle to store the block id a written back page.

Link: https://lkml.kernel.org/r/20241218063513.297475-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 894913e2d35c ("zram: fix out-of-bounds access in writeback_store()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |   23 +++++------------------
 drivers/block/zram/zram_drv.h |    5 +----
 2 files changed, 6 insertions(+), 22 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -112,17 +112,6 @@ static void zram_clear_flag(struct zram
 	zram->table[index].flags &= ~BIT(flag);
 }
 
-static inline void zram_set_element(struct zram *zram, u32 index,
-			unsigned long element)
-{
-	zram->table[index].element = element;
-}
-
-static unsigned long zram_get_element(struct zram *zram, u32 index)
-{
-	return zram->table[index].element;
-}
-
 static size_t zram_get_obj_size(struct zram *zram, u32 index)
 {
 	return zram->table[index].flags & (BIT(ZRAM_FLAG_SHIFT) - 1);
@@ -762,7 +751,7 @@ static ssize_t writeback_store(struct de
 		zram_free_page(zram, index);
 		zram_clear_flag(zram, index, ZRAM_UNDER_WB);
 		zram_set_flag(zram, index, ZRAM_WB);
-		zram_set_element(zram, index, blk_idx);
+		zram_set_handle(zram, index, blk_idx);
 		blk_idx = 0;
 		atomic64_inc(&zram->stats.pages_stored);
 		spin_lock(&zram->wb_limit_lock);
@@ -1390,7 +1379,7 @@ static void zram_free_page(struct zram *
 
 	if (zram_test_flag(zram, index, ZRAM_WB)) {
 		zram_clear_flag(zram, index, ZRAM_WB);
-		free_block_bdev(zram, zram_get_element(zram, index));
+		free_block_bdev(zram, zram_get_handle(zram, index));
 		goto out;
 	}
 
@@ -1436,12 +1425,10 @@ static int zram_read_from_zspool(struct
 
 	handle = zram_get_handle(zram, index);
 	if (!handle || zram_test_flag(zram, index, ZRAM_SAME)) {
-		unsigned long value;
 		void *mem;
 
-		value = handle ? zram_get_element(zram, index) : 0;
 		mem = kmap_local_page(page);
-		zram_fill_page(mem, PAGE_SIZE, value);
+		zram_fill_page(mem, PAGE_SIZE, handle);
 		kunmap_local(mem);
 		return 0;
 	}
@@ -1487,7 +1474,7 @@ static int zram_read_page(struct zram *z
 		 */
 		zram_slot_unlock(zram, index);
 
-		ret = read_from_bdev(zram, page, zram_get_element(zram, index),
+		ret = read_from_bdev(zram, page, zram_get_handle(zram, index),
 				     parent);
 	}
 
@@ -1639,7 +1626,7 @@ out:
 
 	if (flags) {
 		zram_set_flag(zram, index, flags);
-		zram_set_element(zram, index, element);
+		zram_set_handle(zram, index, element);
 	}  else {
 		zram_set_handle(zram, index, handle);
 		zram_set_obj_size(zram, index, comp_len);
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -62,10 +62,7 @@ enum zram_pageflags {
 
 /* Allocated for each disk page */
 struct zram_table_entry {
-	union {
-		unsigned long handle;
-		unsigned long element;
-	};
+	unsigned long handle;
 	unsigned int flags;
 	spinlock_t lock;
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME



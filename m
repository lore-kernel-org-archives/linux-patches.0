Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9394ABBA6;
	Thu, 17 Sep 2026 18:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671550; cv=none; b=bD6kC5BO2wDgtBByaL31Xw15rmD4rVMh6pd5QC3oKEvU3oFuqGQuaQzJW4tEOLn3DpYdZ2TPbQ/NpIFb+vclDI18mNcMVZQQ4s4OMHnZFsCA3Eq6hTJveil5NeeVS/Zn1S8rurjbIutxC8tRlvWUBMZOIv6Jh6QxOcdtmFERRtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671550; c=relaxed/simple;
	bh=/s1MkiFkWYuWdmohgVQeSwO7SVtmLYSHhmff7IwJgYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USwIof7LND1V8dVP7ApWx0KhoGXTQF8fN/0Wp5Eb9sM2NYF6MmzKWpgvnvyHyvwuQKWES40SEALBtzziLUwbAKa4EYk7jeoYOUOz+rKQU9K5j9iBBZgD0MgkbQq4kTBn87JT5hPyTUlSLcwCCaH1KbY54zdXXlHXJuO8SppQ3Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdYqkwah; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdYqkwah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC551F000FF;
	Thu, 17 Sep 2026 18:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671549;
	bh=Ulykztom3hwL2qTITFbsbPWtlQjCkbMPtM+JN5k1rNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdYqkwahonhKZXNfKghFhvb6mjH0IaFLtJuzvpktv6hIBahnVs/4peqFtPePJ0FM3
	 Xj1pAhlWLZhYVDp7Ya9XupZrzITFhK27wGCogKI43+5fBtD2SNxANwckzHxz/VPUSu
	 q7wEOKTUG83w/9QuBKuMvwSb2IISRjTxcdYB0rNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1014/1102] zram: use zram_read_from_zspool() in writeback
Date: Thu, 17 Sep 2026 16:15:57 +0100
Message-ID: <20260917151606.208692707@linuxfoundation.org>
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

[ Upstream commit b8d3ff7bb5111c6a88d5672469de445d9b46cf22 ]

We only can read pages from zspool in writeback, zram_read_page() is not
really right in that context not only because it's a more generic function
that handles ZRAM_WB pages, but also because it requires us to unlock slot
between slot flag check and actual page read.  Use zram_read_from_zspool()
instead and do slot flags check and page read under the same slot lock.

Link: https://lkml.kernel.org/r/20241218063513.297475-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 894913e2d35c ("zram: fix out-of-bounds access in writeback_store()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -55,8 +55,8 @@ static size_t huge_class_size;
 static const struct block_device_operations zram_devops;
 
 static void zram_free_page(struct zram *zram, size_t index);
-static int zram_read_page(struct zram *zram, struct page *page, u32 index,
-			  struct bio *parent);
+static int zram_read_from_zspool(struct zram *zram, struct page *page,
+				 u32 index);
 
 static int zram_slot_trylock(struct zram *zram, u32 index)
 {
@@ -694,14 +694,12 @@ static ssize_t writeback_store(struct de
 		zram_set_flag(zram, index, ZRAM_UNDER_WB);
 		/* Need for hugepage writeback racing */
 		zram_set_flag(zram, index, ZRAM_IDLE);
-		zram_slot_unlock(zram, index);
-		if (zram_read_page(zram, page, index, NULL)) {
-			zram_slot_lock(zram, index);
+		if (zram_read_from_zspool(zram, page, index)) {
 			zram_clear_flag(zram, index, ZRAM_UNDER_WB);
 			zram_clear_flag(zram, index, ZRAM_IDLE);
-			zram_slot_unlock(zram, index);
-			continue;
+			goto next;
 		}
+		zram_slot_unlock(zram, index);
 
 		bio_init(&bio, zram->bdev, &bio_vec, 1,
 			 REQ_OP_WRITE | REQ_SYNC);



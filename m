Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39391A682B;
	Tue, 16 Jun 2026 15:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623829; cv=none; b=KRHMBbdjuODx0SJ2Z5XUa+eSoxZ0GoHEIZVArT4o+27R+ykz7UJYeMPhIHrlgkOyHi5uvIrEyK0bYTze9aetZTG2hkr2bdr9HBvIRNebED5sHcdJSXP3m8lYhG/k7YmC2ZyhM4eKj8kCWdRsvrHJOxgTZZ7cbsTSgdW3DTm8yT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623829; c=relaxed/simple;
	bh=4D4CNaxG7lffIp7CNxA/ZBLNKDW5r//pI83t2ouT4bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjEaowX5uOy0S4eLzFk7WdVI0CxT1SV4EZEk4VrgDcDRO7vZW2wZM8vQTFOJeWpgJqGExh+TxwG41e8rtIt1UHTnwg+bF0zg5T/16tsA53f6EDNOywvCpeyCLcKcq7MFTSbGkv1BXKHMUjLmI5H2AGvWn7tX50w1I3sJYqdqL9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXBzhVVo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXBzhVVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759031F000E9;
	Tue, 16 Jun 2026 15:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623828;
	bh=yxjtx5WDZ9+Tb4gWr6WX7Y7l4558BcwN/MlUk7N06M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QXBzhVVonGgOKP8lmF2rf0QFc8oe//eya2AGQodPCB6CZGgDJBuHaByo89dRx4Bij
	 pHpIlbtLbqDv9O/ZOrRZ+0lHJ2IFcQkptU64hxJ2ZjMk57sFYNASJ5QhSMDmFvk5Bs
	 k6s2XUn1mNZ3wV2dr8SC9xk0m/TTI8LE94qtxrdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Cunlong Li <shenxiaogll@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Yisheng Xie <xieyisheng1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 224/378] zram: fix use-after-free in zram_bvec_write_partial()
Date: Tue, 16 Jun 2026 20:27:35 +0530
Message-ID: <20260616145122.088855063@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cunlong Li <shenxiaogll@gmail.com>

commit 732fd9f0b9c1cdc6dfd77162ded60df005182cc0 upstream.

zram_read_page() picks the sync or async backing device read path based on
whether the parent bio is NULL.  zram_bvec_write_partial() passes its
parent bio down, so for ZRAM_WB slots the read is dispatched
asynchronously and zram_read_page() returns 0 while the bio is still in
flight.  The caller then runs memcpy_from_bvec(), zram_write_page() and
__free_page() on the buffer, leaving the async read to write into a freed
page.

zram_bvec_read_partial() was switched to NULL in commit 4e3c87b9421d
("zram: fix synchronous reads") for the same reason; the write_partial
counterpart was missed.

Link: https://lore.kernel.org/20260528-zram-v3-1-cab86eef8764@gmail.com
Fixes: 8e654f8fbff5 ("zram: read page from backing device")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Cunlong Li <shenxiaogll@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2321,7 +2321,7 @@ static int zram_bvec_write_partial(struc
 	if (!page)
 		return -ENOMEM;
 
-	ret = zram_read_page(zram, page, index, bio);
+	ret = zram_read_page(zram, page, index, NULL);
 	if (!ret) {
 		memcpy_from_bvec(page_address(page) + offset, bvec);
 		ret = zram_write_page(zram, page, index);



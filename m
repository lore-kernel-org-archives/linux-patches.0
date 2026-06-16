Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5528347AF49;
	Tue, 16 Jun 2026 17:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629721; cv=none; b=O4Th84EiPUg/XfQutCRx5oeDp2W8uJtWRahXwJaRlgyvGQsvbbs6fFwYTHXBGmdAAw4FFinFzMjrLN6WvM0SbYWH/fr6p2E9pY5m70atYv9CmnUmcq9QPcS01yIn2j3S+N3QgBqSDXTKwb3oDRhgd4IrzlH6z4irQzFlxSXHIJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629721; c=relaxed/simple;
	bh=jDEkjm1qU/s003fqhwXd+5IRNxYcwgEoaa0eq3K+pE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxiQTwUwNalxPjbURnDLd3c7yzRVcdg+EN/MfkQNRwzdWpa45jKGzGPADHzw87k6gbUtIIYw1rBTFgpKghsazLila9WDr3HxhlndQ/bpzkvBH2SE48vDLYe5a+9ADZSHYtdEPD+1lp9OsjLiFY60P82ndTI5ZYWb/wlx93wwyA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZ/9Riso; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZ/9Riso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113FC1F000E9;
	Tue, 16 Jun 2026 17:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629720;
	bh=XHhiWBPstCRLpjcNUGQqvDvs74TZXO3WmngVOw1OIw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZ/9RisoahvQFl4hcdgEW7bB0e9jP9Oe4FSri7Qx7eh1mTS4Np/ao4DYpNpLziPW4
	 qhzdJ7kJ9cXgSBYsWFbtX3heWkvlEkq8CSdgk6XzuGbsG6m83CU0nQ/9OcZbyQRVy6
	 s91Pcdoi4gfJyvVRNEVAxOdlcGJRv7yXEvqJbv+s=
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
Subject: [PATCH 6.6 309/452] zram: fix use-after-free in zram_bvec_write_partial()
Date: Tue, 16 Jun 2026 20:28:56 +0530
Message-ID: <20260616145133.741172046@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1569,7 +1569,7 @@ static int zram_bvec_write_partial(struc
 	if (!page)
 		return -ENOMEM;
 
-	ret = zram_read_page(zram, page, index, bio);
+	ret = zram_read_page(zram, page, index, NULL);
 	if (!ret) {
 		memcpy_from_bvec(page_address(page) + offset, bvec);
 		ret = zram_write_page(zram, page, index);



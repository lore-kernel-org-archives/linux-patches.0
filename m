Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31F46FC3
	for <patches@lists.linux.dev>; Fri, 21 Apr 2023 19:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YNaeywPG0hf9vLC0oGzgXUzMq14M1rf2z1Pu3jCjc18=; b=ngzYAuBKDLAoLCg9a3fSYyxaF7
	Psmp6RNidLp/Hoz9Sz3Yaw4hJW6ICtW0d4gYHRtDbEVmUURusmziBCiUS8bTLXRjIGpepiBVYvy4V
	AwpjQ3WoHeBlc3DLTnq8Mlk6ISbisM8Dq/dyJwP58qth31M8tqk7cOBV5m4mcx0Eb3/Yq37hx40Q1
	sTKkHJsz0qslYzsxgNwgcjkPJnjnr4qcRujKf1sQeDcoSvwEN+/9SSuTrxHTTWDLBYGm0TSLjdm/O
	l/CPxIM1wE772UFBPe1DRj82PuNz0beeob2viWswsRu9DrjB2lpvHI+yRXpn9Gc4ldGRFkXpKwslh
	E2nlol0A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1ppwtU-00BlaZ-1j;
	Fri, 21 Apr 2023 19:58:08 +0000
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
	kbusch@kernel.org,
	mcgrof@kernel.org
Subject: [PATCH 2/5] drbd: use PAGE_SECTORS_SHIFT and PAGE_SECTORS
Date: Fri, 21 Apr 2023 12:58:04 -0700
Message-Id: <20230421195807.2804512-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230421195807.2804512-1-mcgrof@kernel.org>
References: <20230421195807.2804512-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Replace common constants with generic versions.
This produces no functional changes.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/drbd/drbd_bitmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 6ac8c54b44c7..b556e6634f13 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1000,7 +1000,7 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 	unsigned int len;
 
 	first_bm_sect = device->ldev->md.md_offset + device->ldev->md.bm_offset;
-	on_disk_sector = first_bm_sect + (((sector_t)page_nr) << (PAGE_SHIFT-SECTOR_SHIFT));
+	on_disk_sector = first_bm_sect + (((sector_t)page_nr) << PAGE_SECTORS_SHIFT);
 
 	/* this might happen with very small
 	 * flexible external meta data device,
@@ -1008,7 +1008,7 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 	last_bm_sect = drbd_md_last_bitmap_sector(device->ldev);
 	if (first_bm_sect <= on_disk_sector && last_bm_sect >= on_disk_sector) {
 		sector_t len_sect = last_bm_sect - on_disk_sector + 1;
-		if (len_sect < PAGE_SIZE/SECTOR_SIZE)
+		if (len_sect < PAGE_SECTORS)
 			len = (unsigned int)len_sect*SECTOR_SIZE;
 		else
 			len = PAGE_SIZE;
-- 
2.39.2


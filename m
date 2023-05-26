Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C278498
	for <patches@lists.linux.dev>; Fri, 26 May 2023 07:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=E+NZJmg2wGtl9UTyedalDySM8eWxNnKVjwcpkkZSi1c=; b=k7xswGivErozFTM0k3Rp4cWzQN
	Dude5lKSUZQHlx044tzpe9pekiIonmIyRsCOSAE/ne2v3XWULeyuNagveDJKhCzwzIwpSet/GGPTJ
	8L/umLYOEmo939tVe8b1LzFSz79yTjVEuVIgi+ODI0gNHPJzRXAzmGEU0uy4w/FXD8FDw1HodRkaX
	btZ7Pstk2ZQrBoYKCxDF4cnrUuEu7/zPG5VMnZ4MmRE8wjWzPVYHyD4I14U/h9QOMlW+outkkAGYH
	SVGlcZvTv6O1xgbkdMhgnkGWCImDJG2q5kh2QMmZXxgVfAIEwdNjbjI5gtlCTmuU6FJUWDjjt1SoK
	m8YH8JIg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q2RxB-001RdY-0Z;
	Fri, 26 May 2023 07:33:37 +0000
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
Subject: [PATCH v2 4/5] dm bufio: simplify by using PAGE_SECTORS_SHIFT
Date: Fri, 26 May 2023 00:33:35 -0700
Message-Id: <20230526073336.344543-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230526073336.344543-1-mcgrof@kernel.org>
References: <20230526073336.344543-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

The PAGE_SHIFT - SECTOR_SHIFT constant be replaced with PAGE_SECTORS_SHIFT
defined in linux/blt_types.h, which is included by linux/blkdev.h.

This produces no functional changes.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/md/dm-bufio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index eea977662e81..08c4730e1819 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1152,7 +1152,7 @@ static void *alloc_buffer_data(struct dm_bufio_client *c, gfp_t gfp_mask,
 	    gfp_mask & __GFP_NORETRY) {
 		*data_mode = DATA_MODE_GET_FREE_PAGES;
 		return (void *)__get_free_pages(gfp_mask,
-						c->sectors_per_block_bits - (PAGE_SHIFT - SECTOR_SHIFT));
+						c->sectors_per_block_bits - (PAGE_SECTORS_SHIFT));
 	}
 
 	*data_mode = DATA_MODE_VMALLOC;
@@ -1190,7 +1190,7 @@ static void free_buffer_data(struct dm_bufio_client *c,
 
 	case DATA_MODE_GET_FREE_PAGES:
 		free_pages((unsigned long)data,
-			   c->sectors_per_block_bits - (PAGE_SHIFT - SECTOR_SHIFT));
+			   c->sectors_per_block_bits - (PAGE_SECTORS_SHIFT));
 		break;
 
 	case DATA_MODE_VMALLOC:
-- 
2.39.2


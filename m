Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A714133065C;
	Thu, 28 May 2026 20:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998758; cv=none; b=b+0aDKkmBGmKZfGySecK27bEmi203NoDgPKd55fHTAlC654bi65zpLPd/NorFEN+i494iEh/oGejY/Pv7tCa6NZnS83pqGSXl4HgHzl8vKWefQsSN4xJuJ/CxzIvXOhI9xv0WsAZXtSD1aL3HQ0DE5eWTQgu1rjPTcMY3ZHoDWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998758; c=relaxed/simple;
	bh=5NFXC6rqY8Qrj68lk+wrY23ll1WmZZ7OEutBy+qtO1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CidumOOune2UiqO9fRb8lsgaze6lbXBqEhUEYcZ5/HcHsFzyaTrABe3k6qi9ma83WIbWY20BDatBJVj3N8AO2nMEoBocclrHwBEXUPulNCFFG0IcE9wcS996ruuVzwR39uMYPToNMrxh+COaMlMUpFaIWjrY1guhmKMRz6c2FfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzZ5DFFh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzZ5DFFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1277E1F000E9;
	Thu, 28 May 2026 20:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998757;
	bh=c/yGDM3L2pT1jjbXbuSVuqj5Bck9GfS9FQxr5Ar/1gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QzZ5DFFhPznJqFUK0feVhmBUPf4Z6oKVzylBoN3anoDRqP1DCx/k8pPAK/DsSFMW1
	 +kKAQl1OmXHUFCFp96jxM70cmO8YJhFpIUFzk14IS9WsEhD/MS3Fld7P0BOFo5kEX+
	 RPiGVoyg4/ex5UxJSqReOs60k6Ts+8cMSjMWQ07o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Chen <cachen@purestorage.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 288/461] block: recompute nr_integrity_segments in blk_insert_cloned_request
Date: Thu, 28 May 2026 21:46:57 +0200
Message-ID: <20260528194655.543095841@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Casey Chen <cachen@purestorage.com>

[ Upstream commit 2c6e6a18a37b905cb584eb0dda3ae482162a81ca ]

blk_insert_cloned_request() already recomputes nr_phys_segments
against the bottom queue, because "the queue settings related to
segment counting may differ from the original queue." The exact same
reasoning applies to integrity segments: a stacked driver's underlying
queue can have tighter virt_boundary_mask, seg_boundary_mask, or
max_segment_size than the top queue, in which case
blk_rq_count_integrity_sg() against the bottom queue produces a
different count than the cached rq->nr_integrity_segments inherited
from the source request by blk_rq_prep_clone().

When the cached count is lower than the bottom queue's actual count,
blk_rq_map_integrity_sg() trips

	BUG_ON(segments > rq->nr_integrity_segments);

on dispatch. The same families of stacked setups that motivated the
existing nr_phys_segments recompute -- dm-multipath fanning out to
nvme-rdma in particular -- can produce this.

Mirror the nr_phys_segments handling: when the request carries
integrity, recompute nr_integrity_segments against the bottom queue
and reject the request if it exceeds the bottom queue's
max_integrity_segments. blk_rq_count_integrity_sg() and
queue_max_integrity_segments() are both already available via
<linux/blk-integrity.h>, which blk-mq.c includes.

This closes a latent gap in the stacking contract and brings the
integrity-segment accounting in line with the existing
phys-segment accounting.

Fixes: 76c313f658d2 ("blk-integrity: improved sg segment mapping")
Signed-off-by: Casey Chen <cachen@purestorage.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260511212230.27511-1-cachen@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3da2215b29125..7a7d8d536841d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3305,6 +3305,25 @@ blk_status_t blk_insert_cloned_request(struct request *rq)
 		return BLK_STS_IOERR;
 	}
 
+	/*
+	 * Integrity segment counting depends on the same queue limits
+	 * (virt_boundary_mask, seg_boundary_mask, max_segment_size) that
+	 * vary across stacked queues, so recompute against the bottom
+	 * queue just like nr_phys_segments above.
+	 */
+	if (blk_integrity_rq(rq) && rq->bio) {
+		unsigned short max_int_segs = queue_max_integrity_segments(q);
+
+		rq->nr_integrity_segments =
+			blk_rq_count_integrity_sg(rq->q, rq->bio);
+		if (rq->nr_integrity_segments > max_int_segs) {
+			printk(KERN_ERR "%s: over max integrity segments limit. (%u > %u)\n",
+				__func__, rq->nr_integrity_segments,
+				max_int_segs);
+			return BLK_STS_IOERR;
+		}
+	}
+
 	if (q->disk && should_fail_request(q->disk->part0, blk_rq_bytes(rq)))
 		return BLK_STS_IOERR;
 
-- 
2.53.0




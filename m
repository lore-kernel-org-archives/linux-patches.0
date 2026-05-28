Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A572E7379;
	Thu, 28 May 2026 20:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000002; cv=none; b=KrmpruXL93fCtw1D7tXdxD7A015R4yk3MnQvRTJ7gbVBkQIGMPpaNDf9TwRd8VYjnmLYml0OF38roeuz9nJ401mwxVkB7sPt0ZIt0UNq3D2IAUOfclx/mEECzKO1wILVN4T+ZW7ZN14g231wCOU1vuMc4IFeIzZvt8U2BRAnl7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000002; c=relaxed/simple;
	bh=1rb52goNTsns9U0eXUl6PcnIwzeAw1BsOR95tjse2wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKHj1Hla0Upyn+DR5jFaAJZ/XdjZqc2NxynS6qF0eonqrpZ9dtimfjYQrY7/PP5vFj1pKY0emXJC69sMFmP/xZjykn568fldMhEWJw/MS7VBLSLpi7MKqNYyRMWWiTKPU71heyYDn3bMgfwYbp/ZhUkPfPxFr4I8z8OpEJwfV/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cAG4H3BL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cAG4H3BL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9225D1F000E9;
	Thu, 28 May 2026 20:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000001;
	bh=Jz+ViVwfkq3ypUQkAsq4WENF1dVNXPmX8sQeOuQ/eIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cAG4H3BLgWuHGu/zP+di6wtaLQnGcrpX9c+vNWAZjEFhkDSdSm6hn9yZoY0BeVTkp
	 mz86rXtc7mAjhHNOeEAOayrxR+QX5TaUs41IVZlAgJGZ4UMX/gkSt+EExSxOfRRzym
	 ggj67LLYySM3ODygorUllmCx56r8Iwj+HklzJwp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Chen <cachen@purestorage.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 266/377] block: recompute nr_integrity_segments in blk_insert_cloned_request
Date: Thu, 28 May 2026 21:48:24 +0200
Message-ID: <20260528194646.069836352@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4ebb92014eae1..ab05c5c9e6ae2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3285,6 +3285,25 @@ blk_status_t blk_insert_cloned_request(struct request *rq)
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




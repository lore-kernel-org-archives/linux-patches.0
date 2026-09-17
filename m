Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE1B4848B5;
	Thu, 17 Sep 2026 15:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659157; cv=none; b=FTw6/ptdAHY6YnLhDYHs5ZlppeBGv8mwhvAn7Qvty+JWN++N4uPpSH6/hdhWiCewcm021MIpv1pPDgqHNufG1aMMeZT6uzasS4wJM+JV7YQxSgF9bu5iT1+FbfthP9QvAfrI/k5qQNChsyTa8EcED12SwnJHMIe4ghxX8+G97xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659157; c=relaxed/simple;
	bh=VvmDxbXA7CRWLWJQQnO2FrBliKXMWGSUyCpeAYjgMys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3lijdQy4oaVgN5+piJqGbCrpFqJixWcmGA7P4yL2mL7Jr5dyh2q2X0AXJke75Md0rQG134aILDcG6tjEGQx9OxYhAX0WvgLGrC6LFNrgu4mF2wqeuTr+mz8TGsgu1EtSdDgOHbYrKmRklr2s7E0/MfVqdmP71N9i6q5QOv3yIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOTeBP0V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOTeBP0V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B0F1F0089A;
	Thu, 17 Sep 2026 15:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659147;
	bh=1HuOlMj0EwhfggARsl3jh8EuniPnEfj69PfY6TbUOO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hOTeBP0VX8dy+4VAvhZzFyjIGjSVcfBj1vXh1NeWH58vg/D2c5QzjmsBnrCtPTHmN
	 9S4kQ6BjLuSCSsMAevyuvxDJa6D4N2gXfH6phd+alqNV95kd8QdOo5FQKAVHpRwQYp
	 jrq/0iXbTByQf1aJTLSzBZDAs8snff0L745Cgp3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Auger <eauger@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 158/733] block: save page offset gaps in cloned bio
Date: Thu, 17 Sep 2026 16:07:46 +0100
Message-ID: <20260917151355.002906661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 96c8ea3c5add7920b3c43840d1ea76b3354c8d2d ]

The cloned bio needs to inherit the accumulated gaps between vectors so
that we can know if this bio can subscribe to the iova coalescing
optimization.

When cloning for a split, the gap only applies to the front bio since
that's as far as has been processed. The remaining bio can reset its
gaps to 0 since it advanced past the checked vectors, and will start its
accounting from there on the next split check.

Fixes: 2f6b2565d43c ("block: accumulate memory segment gaps per bio")
Reported-by: Eric Auger <eauger@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260819154937.3903312-1-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 5018a6fc2f36b..bdcb60cb8d88f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -859,6 +859,7 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 	bio->bi_ioprio = bio_src->bi_ioprio;
 	bio->bi_write_hint = bio_src->bi_write_hint;
 	bio->bi_write_stream = bio_src->bi_write_stream;
+	bio->bi_bvec_gap_bit = bio_src->bi_bvec_gap_bit;
 	bio->bi_iter = bio_src->bi_iter;
 
 	if (bio->bi_bdev) {
@@ -1913,6 +1914,14 @@ struct bio *bio_split(struct bio *bio, int sectors,
 
 	bio_advance(bio, split->bi_iter.bi_size);
 
+	/*
+	 * The gap bit is set when splitting to limits and only applies to the
+	 * front bio that was split off. The remaining bio will calcualte its
+	 * gap value when it is subsequently split to limits, so it is safe to
+	 * re-initialize the value back to 0.
+	 */
+	bio->bi_bvec_gap_bit = 0;
+
 	if (bio_flagged(bio, BIO_TRACE_COMPLETION))
 		bio_set_flag(split, BIO_TRACE_COMPLETION);
 
-- 
2.53.0




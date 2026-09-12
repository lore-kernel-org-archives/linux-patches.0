Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A4C353A75;
	Sat, 12 Sep 2026 11:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212732; cv=none; b=dvhvtqu+IMxz+lG+JMNXn3qeS3MbDFE/t7PtU1km8kEgMfZwmozJT4c8ptAnsz85PK+r4YKRAc1FH9+v87gGUBlac8lqck2eCeJVtfdWee2ir0IDb8AxeCSxXjEFo+UD4s5UhDkz28Cj4v6C7IwyVVp6Z3c31CsKH7ZdhlCat50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212732; c=relaxed/simple;
	bh=wLHro7qXp1TCqT/GR7tRJ2KmyXzQXA10f+25XMrAke0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCU45x1gcwy4SRJqDKwYV9T5lWXwF0uINaREMkfKHhHcV5LAjgAUvoqWPLbf6o87LxyVXch702q3HyVwNBxXDpldOcw1/znMsKARY6eX6+FIIH3F9+kjFTVMNAed9388208JLMwDbUeATr/voIgsMc/if4oUTLvlSvzRvX42H6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LqdosQ45; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LqdosQ45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E0B1F000FF;
	Sat, 12 Sep 2026 11:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212730;
	bh=L3lbQhGrmp8xJMcz/4ayqizsvO5djO0L+7go/hG6CWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LqdosQ45W7JFKhBDcyvHnoVYgji+krosfBmDIY7zDnSVUuw5uLTs+kqeCC03nIWhY
	 snCYIIp0EM64pJB3qAaco690tNBe5BtqXzWTGQb21vS6uDob1Fj7GYAesv6mw3eunG
	 bvqTQPoomntXGUD+xTfI0XTbuAAjkpcUXsdUNhHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Wilcox <willy@infradead.org>,
	Keith Busch <kbusch@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1496/1518] block: fix merging data-less bios
Date: Sat, 12 Sep 2026 09:01:05 +0200
Message-ID: <20260912065657.404386461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit fd9ecd005252b595fd02ff7fcc4056251027404d ]

The data segment gaps the block layer tracks doesn't apply to bio's that
don't have data. Skip calculating this to fix a NULL pointer access.

Fixes: 2f6b2565d43cdb5 ("block: accumulate memory segment gaps per bio")
Reported-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index c2f47522be856..5d895c7898984 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -748,6 +748,9 @@ u8 bio_seg_gap(struct request_queue *q, struct bio *prev, struct bio *next,
 {
 	struct bio_vec pb, nb;
 
+	if (!bio_has_data(prev))
+		return 0;
+
 	gaps_bit = min_not_zero(gaps_bit, prev->bi_bvec_gap_bit);
 	gaps_bit = min_not_zero(gaps_bit, next->bi_bvec_gap_bit);
 
-- 
2.53.0




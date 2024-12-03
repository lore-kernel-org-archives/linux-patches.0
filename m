Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AF1202F86;
	Tue,  3 Dec 2024 15:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240183; cv=none; b=axeBp892ipKK2KW3BaGFOxFEAh5UGmHvb1d3uC+WtB1N3gqxEX9XIn20tl6h4+jE642NT4VRROwBNdsacYPoAgwl+aGFbl5ZnlE98hQT7NVfEpngVx2RRpClbh5ejrZsEEhrE6qNN/Sz16uwiNCwgWclOnE+7jjSvR9wVgFmp6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240183; c=relaxed/simple;
	bh=IiO68JX2kcHsNY3/V0NmNn/JWiJXAePFgtPPiddhEMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEpoVNIGGbIiOI2ni/1nsgAVisc5CXXe5/o2xVU2ClpngN+DNYKer/rLTgPwSiH4aa03yGzZuTPuuYt46YZebxiFijpFiOh1fV6GElw1u1Qphx6N1d0xihs5Y8LMyTS50uaCH2LagZ4ODFXeCvrcuWmBBr48ohHOTB1h9B8unUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8sKCF0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8sKCF0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B62C4CECF;
	Tue,  3 Dec 2024 15:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240183;
	bh=IiO68JX2kcHsNY3/V0NmNn/JWiJXAePFgtPPiddhEMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8sKCF0sRZ/7OqQlb63/ynjWvHWfjeDUSTSr5eNHL2gtPl3rZ3sl2d4knbc50ybow
	 q5CstYPUKOGlxWZB1wc65LKQfv4HYHb2e43uy4ADcucENR46rX+34IWq7OChEA/mLk
	 Q6FjFB1jvJM3iQu92ssfbYjlB96bGjAoZ1It4zAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 034/826] block: fix bio_split_rw_at to take zone_write_granularity into account
Date: Tue,  3 Dec 2024 15:36:01 +0100
Message-ID: <20241203144744.794560885@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7ecd2cd4fae3e8410c0a6620f3a83dcdbb254f02 ]

Otherwise it can create unaligned writes on zoned devices.

Fixes: a805a4fa4fa3 ("block: introduce zone_write_granularity limit")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20241104062647.91160-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 75d2461b69e40..5baa950f34fe2 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -287,6 +287,14 @@ static bool bvec_split_segs(const struct queue_limits *lim,
 	return len > 0 || bv->bv_len > max_len;
 }
 
+static unsigned int bio_split_alignment(struct bio *bio,
+		const struct queue_limits *lim)
+{
+	if (op_is_write(bio_op(bio)) && lim->zone_write_granularity)
+		return lim->zone_write_granularity;
+	return lim->logical_block_size;
+}
+
 /**
  * bio_split_rw_at - check if and where to split a read/write bio
  * @bio:  [in] bio to be split
@@ -349,7 +357,7 @@ int bio_split_rw_at(struct bio *bio, const struct queue_limits *lim,
 	 * split size so that each bio is properly block size aligned, even if
 	 * we do not use the full hardware limits.
 	 */
-	bytes = ALIGN_DOWN(bytes, lim->logical_block_size);
+	bytes = ALIGN_DOWN(bytes, bio_split_alignment(bio, lim));
 
 	/*
 	 * Bio splitting may cause subtle trouble such as hang when doing sync
-- 
2.43.0




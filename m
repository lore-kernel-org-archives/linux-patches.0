Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEE221B90F;
	Thu, 12 Dec 2024 15:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018997; cv=none; b=Jd9btOs286mCnrnZycruEykGcn2tCc+5p3NSzWZ5odtnyms3qKfqGIEPDzWPcGNhu3CmC8VnGVdTpKP6BzcO4gZ0WbPl98CIn6oCAmXwPiQIsEWjWCzEh1tbH6yaou0X3hI8o83eXDHDHfEPhvdq7fEfScLNbtghcxKXWAEyPlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018997; c=relaxed/simple;
	bh=Il2HDdsWMFHSg7G24PTd3xh79lDDSOnNYRN+BggsUwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3BgqHRLDkQDHFcc4ckm1ukkyik/2iLchyAwQKQtRLHWZA3TE1IFeZmSdyu8OXBpR3NFdenzIwITnqGdeV8q5ZmbiqIcw4fgyym8S+MLp7GrUvuB5GuKTHIcPKdo8NMAMaah+zsw5H0u7NmQPUgsW4/OobpktYD7jSLdcq4IUNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrexqQnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrexqQnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF73C4CED3;
	Thu, 12 Dec 2024 15:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018997;
	bh=Il2HDdsWMFHSg7G24PTd3xh79lDDSOnNYRN+BggsUwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrexqQnS9C+mJGEkdXdRBfdnUewRfHGRd1N/9cKAlKKN3NK/REhvZKo1jTQxhraaP
	 2uUVAJ+42CNX3LJB2cphKe3OI9rJfTHfXZlSKd5KUBnEbwSoM8VAFhtxb59VGVZu8E
	 D1D99aEmwzAw60v3SDhGzegHAITBA3P7B5XTjaxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/772] block: fix bio_split_rw_at to take zone_write_granularity into account
Date: Thu, 12 Dec 2024 15:50:07 +0100
Message-ID: <20241212144352.507096163@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 13a47b37acb7d..b90c413c83c44 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -247,6 +247,14 @@ static bool bvec_split_segs(struct queue_limits *lim, const struct bio_vec *bv,
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
  * bio_split_rw - split a bio in two bios
  * @bio:  [in] bio to be split
@@ -317,7 +325,7 @@ static struct bio *bio_split_rw(struct bio *bio, struct queue_limits *lim,
 	 * split size so that each bio is properly block size aligned, even if
 	 * we do not use the full hardware limits.
 	 */
-	bytes = ALIGN_DOWN(bytes, lim->logical_block_size);
+	bytes = ALIGN_DOWN(bytes, bio_split_alignment(bio, lim));
 
 	/*
 	 * Bio splitting may cause subtle trouble such as hang when doing sync
-- 
2.43.0




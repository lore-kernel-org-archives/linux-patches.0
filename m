Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634571DF251;
	Wed,  6 Nov 2024 12:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896274; cv=none; b=pr4YXrzb/410qf68NF+zxDXZMHupMTxG/Mwt2HDtzT/WBFCsyzBgSeY0SKInnVt11cBMarqXZsS7uPAPuOTXTcDg9v750pq8CmDa0VR/32SjCHYpnN0Mm+e1Y46FjY1zlDETfBEeMeap8ianTYJxEmlFG5DWFsHJrVeq4SD/YKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896274; c=relaxed/simple;
	bh=muEea+tRuyuNvZ3HFkFrS7U7o3Bqc4XBcvaYSuzL34s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foS+3hWm0ioVJ8Oantob/S1p7rU/dcP1xhYd7T/g6hE5pTyu1K4nLKkWDEKPpfo0jhfvPbtYXMgRAaMxKonN7cOyQnxUJhT51lXpvjdYIpbCify3KdGdlVUvSVcaDDwj27fGLK5X6mPCS4Kc2yRTEJPPlgwaBnpTd0o6jXCMMgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GsiPCfE+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GsiPCfE+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8554C4CED6;
	Wed,  6 Nov 2024 12:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896274;
	bh=muEea+tRuyuNvZ3HFkFrS7U7o3Bqc4XBcvaYSuzL34s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GsiPCfE+x+iDFxnFbxAlKtLTh0RbK5bO7s9qaiUtcYhISffo+6p8dK2YYr03QENim
	 IeEgez+BHcbTSzH5rQuIcjQFUbjcV464paOPuIbghtjTsrVH92HkJJ3kkeAnj66SBV
	 ZX/XIHpu9JgMckaSkuttpiIoEGKPxHfmAEqzAqPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinyu Zhang <xizhang@purestorage.com>,
	Uday Shankar <ushankar@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 147/245] block: fix sanity checks in blk_rq_map_user_bvec
Date: Wed,  6 Nov 2024 13:03:20 +0100
Message-ID: <20241106120322.845297178@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xinyu Zhang <xizhang@purestorage.com>

[ Upstream commit 2ff949441802a8d076d9013c7761f63e8ae5a9bd ]

blk_rq_map_user_bvec contains a check bytes + bv->bv_len > nr_iter which
causes unnecessary failures in NVMe passthrough I/O, reproducible as
follows:

- register a 2 page, page-aligned buffer against a ring
- use that buffer to do a 1 page io_uring NVMe passthrough read

The second (i = 1) iteration of the loop in blk_rq_map_user_bvec will
then have nr_iter == 1 page, bytes == 1 page, bv->bv_len == 1 page, so
the check bytes + bv->bv_len > nr_iter will succeed, causing the I/O to
fail. This failure is unnecessary, as when the check succeeds, it means
we've checked the entire buffer that will be used by the request - i.e.
blk_rq_map_user_bvec should complete successfully. Therefore, terminate
the loop early and return successfully when the check bytes + bv->bv_len
> nr_iter succeeds.

While we're at it, also remove the check that all segments in the bvec
are single-page. While this seems to be true for all users of the
function, it doesn't appear to be required anywhere downstream.

CC: stable@vger.kernel.org
Signed-off-by: Xinyu Zhang <xizhang@purestorage.com>
Co-developed-by: Uday Shankar <ushankar@purestorage.com>
Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Fixes: 37987547932c ("block: extend functionality to map bvec iterator")
Link: https://lore.kernel.org/r/20241023211519.4177873-1-ushankar@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-map.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 0e1167b239342..6ef2ec1f7d78b 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -600,9 +600,7 @@ static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter)
 		if (nsegs >= nr_segs || bytes > UINT_MAX - bv->bv_len)
 			goto put_bio;
 		if (bytes + bv->bv_len > nr_iter)
-			goto put_bio;
-		if (bv->bv_offset + bv->bv_len > PAGE_SIZE)
-			goto put_bio;
+			break;
 
 		nsegs++;
 		bytes += bv->bv_len;
-- 
2.43.0




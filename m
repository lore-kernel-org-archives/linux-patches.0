Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD63034A76F;
	Fri, 21 Nov 2025 13:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732216; cv=none; b=cojqTi1r939ygtgbW0pLeqS9roJ+60ZyF5JjYkfzNcwHPEoNP8krH9m/UACAyUvHdM5qbFP7mOySzlyD0fKr5eQ4I7kF1E8iPRoq3T2adJRawQB7PlgNPy5HesKjC+dybZDmkSOw39Rm2cKMMHx5yV5aswoRCRtqYuxAqq1eX94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732216; c=relaxed/simple;
	bh=4RVW9ZrdLa8gciGRHRcfIK/bnJ6XKPqowZVI75tcFug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8GjuSHM/4OUnmDLUw8KIzqS74Pg+n/6GA3dbTz0X3pnCZGJiTTXvdYyXeRifAKcmo+4pHn9bQnRiw8LJCB9vZG4gs7IXqTOwxp473oLLz+CdIliYHOACmU3nfg0te5pgDRu7CKWBBr3zdMKRmYQKM/K7S8qkoVQkXyZsioChcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qszLaPIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qszLaPIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62554C4CEFB;
	Fri, 21 Nov 2025 13:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732215;
	bh=4RVW9ZrdLa8gciGRHRcfIK/bnJ6XKPqowZVI75tcFug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qszLaPIMOUB7AmCvwoEbu64XScgfBfa43w6RNai0bY/gD4koQsl9MVGuMB6EO3g+w
	 B3sAo9cR7gzXkQZhlrIKjQy2hlqlAut34gaammJY/BdzD2vObqqNjMaVzP3WbWdqFq
	 Ze9Lbx1ShajsJct5QNZoATyA4KQGRCBvc65Qi/e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 043/529] block: make REQ_OP_ZONE_OPEN a write operation
Date: Fri, 21 Nov 2025 14:05:42 +0100
Message-ID: <20251121130232.534538894@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit 19de03b312d69a7e9bacb51c806c6e3f4207376c upstream.

A REQ_OP_OPEN_ZONE request changes the condition of a sequential zone of
a zoned block device to the explicitly open condition
(BLK_ZONE_COND_EXP_OPEN). As such, it should be considered a write
operation.

Change this operation code to be an odd number to reflect this. The
following operation numbers are changed to keep the numbering compact.

No problems were reported without this change as this operation has no
data. However, this unifies the zone operation to reflect that they
modify the device state and also allows strengthening checks in the
block layer, e.g. checking if this operation is not issued against a
read-only device.

Fixes: 6c1b1da58f8c ("block: add zone open, close and finish operations")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blk_types.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -384,15 +384,15 @@ enum req_op {
 	/* write the zero filled sector many times */
 	REQ_OP_WRITE_ZEROES	= (__force blk_opf_t)9,
 	/* Open a zone */
-	REQ_OP_ZONE_OPEN	= (__force blk_opf_t)10,
+	REQ_OP_ZONE_OPEN	= (__force blk_opf_t)11,
 	/* Close a zone */
-	REQ_OP_ZONE_CLOSE	= (__force blk_opf_t)11,
+	REQ_OP_ZONE_CLOSE	= (__force blk_opf_t)13,
 	/* Transition a zone to full */
-	REQ_OP_ZONE_FINISH	= (__force blk_opf_t)13,
+	REQ_OP_ZONE_FINISH	= (__force blk_opf_t)15,
 	/* reset a zone write pointer */
-	REQ_OP_ZONE_RESET	= (__force blk_opf_t)15,
+	REQ_OP_ZONE_RESET	= (__force blk_opf_t)17,
 	/* reset all the zone present on the device */
-	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)17,
+	REQ_OP_ZONE_RESET_ALL	= (__force blk_opf_t)19,
 
 	/* Driver private requests */
 	REQ_OP_DRV_IN		= (__force blk_opf_t)34,



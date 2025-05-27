Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E57284678;
	Tue, 27 May 2025 17:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365905; cv=none; b=FgAisK+gokOq+epjVJqy7ib5LF8M8O508pOBgbgCeWWBafMyTeanXb6gb/8mm4g9EO6pDiukYf3JJQY+QpTElYZ6Th0puXmQhoi8y6J1EOvrQNC2sxRuikuYGQVLHBJ4JTi5KhpFxrHZ/W38nKGp4MtcW44mYRk5Fh7m22LZMdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365905; c=relaxed/simple;
	bh=siucmIS8t1hKkmVIgc0hJX6OkehQkCHOZrouSqUrAS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNnpmozD0fWfIiW6JE+1odzoWSXgjSdqTdDbLS9CwB88n2nyLQo8mzcrE0raBEjFfgkSQgeBkBWDuUhyCmFZGDSLG2rz5Mo7ZgJP7le1lzYc8nJ8VPS5FfzEz31OYdez7G2XUerHdPu+DL5UsTWw9rNo4PFdNWYvKAy4h74h2ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5GP6PHd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5GP6PHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC92C4CEE9;
	Tue, 27 May 2025 17:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365905;
	bh=siucmIS8t1hKkmVIgc0hJX6OkehQkCHOZrouSqUrAS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5GP6PHddUdxaJNakrPA6fAUmBKweCgHttZezXD5W3mTnNpAlK3m+JKQiLMwew5jI
	 xr4buzDaKLDseXVOLBD/ScBxe9l2TI4T2Y/5TCaDG3KujWTNX0pTrvt/h4UztvTbCk
	 8pZQyZnAG8LVC4POORwPkKe9+1U+WHSqU7IWELKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 528/626] block: only update request sector if needed
Date: Tue, 27 May 2025 18:27:01 +0200
Message-ID: <20250527162506.445380390@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit db492e24f9b05547ba12b4783f09c9d943cf42fe ]

In case of a ZONE APPEND write, regardless of native ZONE APPEND or the
emulation layer in the zone write plugging code, the sector the data got
written to by the device needs to be updated in the bio.

At the moment, this is done for every native ZONE APPEND write and every
request that is flagged with 'BIO_ZONE_WRITE_PLUGGING'. But thus
superfluously updates the sector for regular writes to a zoned block
device.

Check if a bio is a native ZONE APPEND write or if the bio is flagged as
'BIO_EMULATES_ZONE_APPEND', meaning the block layer's zone write plugging
code handles the ZONE APPEND and translates it into a regular write and
back. Only if one of these two criterion is met, update the sector in the
bio upon completion.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/dea089581cb6b777c1cd1500b38ac0b61df4b2d1.1746530748.git.jth@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk.h b/block/blk.h
index 1426f9c281973..e91012247ff29 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -482,7 +482,8 @@ static inline void blk_zone_update_request_bio(struct request *rq,
 	 * the original BIO sector so that blk_zone_write_plug_bio_endio() can
 	 * lookup the zone write plug.
 	 */
-	if (req_op(rq) == REQ_OP_ZONE_APPEND || bio_zone_write_plugging(bio))
+	if (req_op(rq) == REQ_OP_ZONE_APPEND ||
+	    bio_flagged(bio, BIO_EMULATES_ZONE_APPEND))
 		bio->bi_iter.bi_sector = rq->__sector;
 }
 void blk_zone_write_plug_bio_endio(struct bio *bio);
-- 
2.39.5




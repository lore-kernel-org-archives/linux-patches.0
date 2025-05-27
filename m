Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145CA1FB3;
	Tue, 27 May 2025 17:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368391; cv=none; b=t+Zb0VJCwQEi/EeNIYEyUDTcYGkiC7Z/WhJXneyEGCdYNDLmXSEZT3QSpQRxHsIB5xAV0WJeBn2mWw6FHdrv+qFnD+lwowScC0HCvd6i5X2smQP+Nr6IDwC7XCvRKtXZcAzo9hvJegl+w2Pp37ysX0qBLl9L5LlWgH2TnWemAY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368391; c=relaxed/simple;
	bh=NPu79AoxdIeyydRaFO8htt2LCJD4a6MGXhylb9mkYGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tung+S0+cYfN+bFbDTJ5XOIUvmEVxqyrKAHa8p4yyo3kUCDmELS9GwuYptSqAjvIgCSlFvKG921DNRqoODgLJW7T6UoT2UYbTTiGzoYf5bC3lLIs2LtW90wde3YxOY18SWQL8KzcGEiQcMByRxeB2EPqzr9dLWkrRWWnxokUKXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMJ2ZoXu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMJ2ZoXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74704C4CEE9;
	Tue, 27 May 2025 17:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368390;
	bh=NPu79AoxdIeyydRaFO8htt2LCJD4a6MGXhylb9mkYGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMJ2ZoXujaR8HkgBZnBF+jEamJEr29QLN5v4aSxNMBuq8PEzvlebfz0tAAWJE8+pL
	 KitOiuS9O+2gsBGnQzMgo8HBTfDOqoC1CFVeEjHxTFXOtv9iiL0EYjWgYMfdokvNbi
	 qyeLn/LE4i6U6OIRrVWDEv6Zo634b8RYOE1JiXEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 675/783] block: only update request sector if needed
Date: Tue, 27 May 2025 18:27:52 +0200
Message-ID: <20250527162540.616053507@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 9dcc92c7f2b50..c14f415de5228 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -480,7 +480,8 @@ static inline void blk_zone_update_request_bio(struct request *rq,
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




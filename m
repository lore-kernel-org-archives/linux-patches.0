Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABDB29A326;
	Mon, 12 May 2025 18:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073080; cv=none; b=QPWdMGG2g8fSuNBsRnHj1dA1M+0TBHxM654uGmLvHKXRmDG6OKJ/aWH69Ycpduc3NE7VTtjlEMqq+8NJAFJEa3YL7SxNCmsOHv3fZ/AzsMgnvjsONM9eZl7fkL7ge0midXAA5DT6RQMp5ghJCreLVtIpM2mynsGXS0/GFrOBb5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073080; c=relaxed/simple;
	bh=q2GbhTnqw4HSKUD14vcZX5VevC9i7BETntU11kPDREM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PuaFCRrjuSVeDASSG7L/kB/1GNlUnaHfMqfjp759MjwrRX4h1ez/2oxraRnC7/2Uw7EW3OoG2HT3wAdI4tp48UQ9RNue7SUxOYccCrL8IEPNh8CLS7AD1vTYVISKVzYQS+IvPA7vxcONiCj1XuZP52criaVV7ibyRI9ur1CoH2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CO7lEdgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CO7lEdgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B2EC4CEF0;
	Mon, 12 May 2025 18:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747073080;
	bh=q2GbhTnqw4HSKUD14vcZX5VevC9i7BETntU11kPDREM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CO7lEdgpABoI3UBXn8585HRIE5IrHNeF257GfqmKXgD+mcE2qT+h76iwlrIRwxZXG
	 lFU2ndoDqcUAzVb44BSstxN5L1NLHCI9lpDgQforqIQ90FFyjVY/X3tp3lDo/yc2k3
	 c03saBaapvFbQ+aS5HdMEH8XUca0UE4Od2dP01VAhbQhHZq/A540l25U3sTbxeuowu
	 20/QEi/5A0ME++qDnQm81mr+BjWj5SQKDq/otLYmDsCdiTTNPYXOvjrWMTo7pmNCM/
	 Y8/XUA/eeJs+hMMR7Cxr7zTAvsCwzy7BvjKWTQZY+6x6w9U5rS3naZNsWKmNS05+F9
	 B4dpGquKYhlNw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 06/11] block: only update request sector if needed
Date: Mon, 12 May 2025 14:04:21 -0400
Message-Id: <20250512180426.437627-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250512180426.437627-1-sashal@kernel.org>
References: <20250512180426.437627-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.28
Content-Transfer-Encoding: 8bit

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


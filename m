Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D4D298242;
	Mon, 12 May 2025 18:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073054; cv=none; b=fB6zlKIjP51vLfi2i17+Fxl7smkkNcn01g5nin2aXiYiIWJtlH4kwnXRjgPvolay90hhDG0khBxXEQoApDkoYFRou+FrtT7kx8fHHDZP1oJmidrDU9JM1bLZGfGXmFiEub3YeUaXIKQtQB/4PBOY1iFYzQjg4XXTSuK45nFVIek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073054; c=relaxed/simple;
	bh=L2k7cRkMJazui1TkT/w4yjvjzTYhEraMo91sqqKHc0A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EfgsczNzdjvOYVFERi2VwArA7mhJS8jmKuPtqVwGu7NKlu0oG4ErImDIJ2yon5qcT2ej5/T4Ncnlx3a3wEMyptPhK/8UrY7XE9mapXuT54OFBs4Py0eDfxZJjg9XJsH4sDXbwDp5doAbOqhLNzlv6hV5v/ai1KEsMThgTe5/aVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tNib/Eek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tNib/Eek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACCAC4CEF0;
	Mon, 12 May 2025 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747073053;
	bh=L2k7cRkMJazui1TkT/w4yjvjzTYhEraMo91sqqKHc0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNib/Eekp66m5LPPzZWoExUbqNvHYCrju1FWqQ+HzyB1i4ux3iQteYIMX17slpdPC
	 kdI5tAU2Dvi250OBMF04SaCcrPP6IVizJ35Li0k/IVxjJearTxJ8chnE/OFPMJGsda
	 FEFP8Akzz4DgoLCg1yNdhpRdij1NiHnrRBVOh8NLbn/xTCX6VvB5uxRgWhO3ayv0lz
	 qPseUQcTu0ZXr5XiiX++Eo7RE4dIMVmdjJpsv2+MnQpQ6KjD6Xl+ELgO0mMO02DrxH
	 TC5L9H6QO9yU5DC1igvZsklFHTz+LGtOFGjK0kqxQ+GL5GWlF7+WEfXENcNp5uD7TP
	 lCQ8mCWVS+sAQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 10/15] block: only update request sector if needed
Date: Mon, 12 May 2025 14:03:45 -0400
Message-Id: <20250512180352.437356-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250512180352.437356-1-sashal@kernel.org>
References: <20250512180352.437356-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.6
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


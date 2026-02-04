Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AEE2D8768;
	Wed,  4 Feb 2026 15:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219044; cv=none; b=X96bnKtbzBRFmDejIDZvwENwlvRTnKdRP1EmAfBIVtsFB4WVWfHJCH659/XJDqqOo9/4wJTAd8/I4d3FPIxAwaNIR4FpFwUWqWt5g1LbWlkzR8yQd7jqq5NMkEvFJBwxROwA1C7ya11MgnAiSde73+ISfG40NGY9NleWmmIWPg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219044; c=relaxed/simple;
	bh=MLZAk5Xtr51M9d0fjWomJ67di+I1lGWYEiZx2rX5xoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzSabKwRCpSTOtb51DyZtw5RuUD8gw5LpNDjghC3dPzMooJSFY4DVMMcWX2Z6c45XjaRXVFxxRFV7ywPY6sOr7/0CIKA1PFY50msh72q6F0bjvtyavCOLArtRfIme3vWNpHt0rDe6NdA0a7rULifmvRoRu0NnM0ksDpCqtVUvvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DX3qZHml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DX3qZHml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937FDC116C6;
	Wed,  4 Feb 2026 15:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219044;
	bh=MLZAk5Xtr51M9d0fjWomJ67di+I1lGWYEiZx2rX5xoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DX3qZHmlyVYHjV/xmZ2hG9Bc+GXpp5BMX1v53gUU3SDZ7lwzVemau68NlLd/Chjva
	 pCTpcEDDgkasadhYQqM3rcpSEhDCekB/hDLpMnmQ7dHLUUJa/G5efuG7ZBomCr5ZFr
	 T9S2X53Z1KBTaSPv94YcwvSg2xDuqCVWxu0NKjWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Shida Zhang <zhangshida@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 050/122] bcache: fix improper use of bi_end_io
Date: Wed,  4 Feb 2026 15:40:32 +0100
Message-ID: <20260204143853.657011920@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Shida Zhang <zhangshida@kylinos.cn>

[ Upstream commit 53280e398471f0bddbb17b798a63d41264651325 ]

Don't call bio->bi_end_io() directly. Use the bio_endio() helper
function instead, which handles completion more safely and uniformly.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 4da7c5c3ec34 ("bcache: fix I/O accounting leak in detached_dev_do_request")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/request.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index af345dc6fde14..82fdea7dea7aa 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1104,7 +1104,7 @@ static void detached_dev_end_io(struct bio *bio)
 	}
 
 	kfree(ddip);
-	bio->bi_end_io(bio);
+	bio_endio(bio);
 }
 
 static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
@@ -1121,7 +1121,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
 	if (!ddip) {
 		bio->bi_status = BLK_STS_RESOURCE;
-		bio->bi_end_io(bio);
+		bio_endio(bio);
 		return;
 	}
 
@@ -1136,7 +1136,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 
 	if ((bio_op(bio) == REQ_OP_DISCARD) &&
 	    !bdev_max_discard_sectors(dc->bdev))
-		bio->bi_end_io(bio);
+		detached_dev_end_io(bio);
 	else
 		submit_bio_noacct(bio);
 }
-- 
2.51.0




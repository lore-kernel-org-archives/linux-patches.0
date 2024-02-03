Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF1011181;
	Sat,  3 Feb 2024 04:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933377; cv=none; b=Mtpe7DPmWjyt01m5yVPyeOzbz9qKquZliaVzF5mtUW7X1ZrfXsFavEsPQQrGFWs75lOIEqYA4ICSqNW5hfc49uyH9Hkd3wTUYpOrYch197zK2cYSDrTAlozm5xs06v5GhN0PuCTgYXqw3oKCVb87d5GnAC/abfn6DVvnoUpakwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933377; c=relaxed/simple;
	bh=06KqJUgZxp3QR+iUqdGIar+59qXuTCFxVsl+XgL3xek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUQHO41/s+60YviXzVrDssjNzhSWCJ4dlu8zWp4cpK1nNx33D1Z0sA12rY3HvLtJ5LI1Y7jXytjhAymNO3ouXY3ZWRzBX/AWvT+BGZBXiJr8G1aFJxRbhDAPLuocc/KrC7KQ13gP7YLqJSD26X5fpSL+KZI1jWpFj5bXT/5ZReM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DvxVkw8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DvxVkw8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F60C433A6;
	Sat,  3 Feb 2024 04:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933376;
	bh=06KqJUgZxp3QR+iUqdGIar+59qXuTCFxVsl+XgL3xek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DvxVkw8Yn/sUEar07keHtYs03OTxOXrpWFK/rOkSJMdxl2x2yfkB2kBecVEAGgT7j
	 8ww+XKR9/1uy3W1G6zZcoXw9uxBz77zKD7uHgUH294TB00IRQgZmaQafCnaPdAd/ui
	 /RGPl6R+jb5B62cVwoFW6H6NKhGgnbQov55xALkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/219] block: prevent an integer overflow in bvec_try_merge_hw_page
Date: Fri,  2 Feb 2024 20:04:19 -0800
Message-ID: <20240203035329.343315459@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

[ Upstream commit 3f034c374ad55773c12dd8f3c1607328e17c0072 ]

Reordered a check to avoid a possible overflow when adding len to bv_len.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20231204173419.782378-2-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 6c22dd7b6f27..74c2818c7ec9 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -927,7 +927,7 @@ static bool bio_try_merge_hw_seg(struct request_queue *q, struct bio *bio,
 
 	if ((addr1 | mask) != (addr2 | mask))
 		return false;
-	if (bv->bv_len + len > queue_max_segment_size(q))
+	if (len > queue_max_segment_size(q) - bv->bv_len)
 		return false;
 	return __bio_try_merge_page(bio, page, len, offset, same_page);
 }
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10253334C02;
	Mon, 27 Oct 2025 19:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591607; cv=none; b=pzlv/qAeg190ieRx5GQOjvIcen00L+/fxGvjhkdL94amYhLK16GAkI3/ZrB0fhrAm650BkzCvKkfcejNvYU155VUL6uUvUgtaf6PAhcdTB+tgySSdbYChzaOKYS0lHE7CNARLoI1AeN0um2vKNTh6x1WkSUGxQIgXPk8Qn7Q6cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591607; c=relaxed/simple;
	bh=R0jHBE+vcDkocBenbjmnrAhht8WV2iZXW2KWG3QXM6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UB2q/gWy/Al7jrB4ByT8wa0/dyFgczIGJ9e9DiF5gG0CoE3QCWOXVGpCXCdtIjVxkTE9T70eF6R40f1oxGWJBKz43uUwm3Tw9Pz1HA9Vd2vJHFOUJbF3xicqm0U1buAdQnz06HxCRp6jm4zAUovO8GZPh5Od+IX/v8rQcvIY9vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WpUIj1BP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WpUIj1BP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8895AC4CEF1;
	Mon, 27 Oct 2025 19:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591606;
	bh=R0jHBE+vcDkocBenbjmnrAhht8WV2iZXW2KWG3QXM6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpUIj1BPrPRWljCDW8YchT0oxh2Xpqfy5YRXCWZcBSot/1ty+t3LMPa98uGRfRmmr
	 cjxcqIKyhlbcR52NleCBQkX7vtRQbgk04Fc0oAQ/64pu42x5iaHwBwvKZtJMh4Ps5y
	 117I3rhaanXQyVww/owBAGRGTpNhEjjSS4YfHN+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 230/332] blk-crypto: fix missing blktrace bio split events
Date: Mon, 27 Oct 2025 19:34:43 +0100
Message-ID: <20251027183530.873638933@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 06d712d297649f48ebf1381d19bd24e942813b37 ]

trace_block_split() is missing, resulting in blktrace inability to catch
BIO split events and making it harder to analyze the BIO sequence.

Cc: stable@vger.kernel.org
Fixes: 488f6682c832 ("block: blk-crypto-fallback for Inline Encryption")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ added queue parameter to trace_block_split() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-crypto-fallback.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -18,6 +18,7 @@
 #include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/random.h>
+#include <trace/events/block.h>
 
 #include "blk-crypto-internal.h"
 
@@ -227,7 +228,9 @@ static bool blk_crypto_split_bio_if_need
 			bio->bi_status = BLK_STS_RESOURCE;
 			return false;
 		}
+
 		bio_chain(split_bio, bio);
+		trace_block_split(bio->bi_disk->queue, split_bio, bio->bi_iter.bi_sector);
 		submit_bio_noacct(bio);
 		*bio_ptr = split_bio;
 	}



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC0532C93E;
	Fri, 17 Oct 2025 15:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715381; cv=none; b=gNrANmuYi5ShlYgYV6xyPG3mDmxQg3D9weW6pP/2/5JmqY/V3lDUnCW4OuhW3uKcNBeMuoUBibvkFAApMi54L0s6g3ICItTpn9+U1VWsRgb5EYp3u5IZ7BMXsrg4SFYaq+IXno4ojhHNMhPzBcxYCrYJSoz6EprWSEmAN8VuH8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715381; c=relaxed/simple;
	bh=pO9Jkrl8XlQavQEogGarEj2L66UnOC7UMVdSpkTJSEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxJ2Usqe1oj3YF266lBk7r6OHGOEn8yYHa4DZcIi4dO+Z8me6dDs1GTTcdR7YMeq2cYzYquRJ3jkwp9/LiMIOS7AGN6jyVxR1UN85miL/KtxsZGuwZ8Rrwj0PUuaCK+f3dTTDM2H5FFYxt8bCiw+Jw8YfWjmgvvSlr+v8xaCrRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYr9d4LU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYr9d4LU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93C0C4CEE7;
	Fri, 17 Oct 2025 15:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715381;
	bh=pO9Jkrl8XlQavQEogGarEj2L66UnOC7UMVdSpkTJSEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYr9d4LUVQBKPjFlFG78c4mIeec/W/k/FMoRyxnok8Zheg1YCWA88vGulEJweozL9
	 RmXBoySUzJK/DyhXe8rrypKNj09lCR8jln0fqQ2AdeoBpOme1WNPys6m5AQEYHNdYO
	 4+meMyB0fZwXgGiSyhHW+bo86Gdfq8NitH6eeMZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.17 195/371] blk-crypto: fix missing blktrace bio split events
Date: Fri, 17 Oct 2025 16:52:50 +0200
Message-ID: <20251017145208.982891952@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 06d712d297649f48ebf1381d19bd24e942813b37 upstream.

trace_block_split() is missing, resulting in blktrace inability to catch
BIO split events and making it harder to analyze the BIO sequence.

Cc: stable@vger.kernel.org
Fixes: 488f6682c832 ("block: blk-crypto-fallback for Inline Encryption")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-crypto-fallback.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/scatterlist.h>
+#include <trace/events/block.h>
 
 #include "blk-cgroup.h"
 #include "blk-crypto-internal.h"
@@ -231,7 +232,9 @@ static bool blk_crypto_fallback_split_bi
 			bio->bi_status = BLK_STS_RESOURCE;
 			return false;
 		}
+
 		bio_chain(split_bio, bio);
+		trace_block_split(split_bio, bio->bi_iter.bi_sector);
 		submit_bio_noacct(bio);
 		*bio_ptr = split_bio;
 	}



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93966335084;
	Fri, 17 Oct 2025 15:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714367; cv=none; b=OtjwmcPqsDjoFhn5ydlrVHInKvuOJrLBcUWyPCV181jEYHb7BYGniCtJ4dof818BtW01lw1985c2oy2juOfMk804NZC94aSZbTISLUcSAkqsu9KJk6VhR4yjUan4kNB24wOeCCOvLwzGsVGV3r/zEeDLcRz6Teu94RoHzWPAUkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714367; c=relaxed/simple;
	bh=1QoD1IIR1jfwwIzVio6d4hfwJ6pZoWZMcjeueHoIp7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgurn5yAdeK2e4i1/2CCBI8xfTVlRI3F1b5jJ7AUErejtx9ak4gNfrfaWrmrbxsz/cL9Dq0b4+QntNsQ9Yz0aOtzvBy9vk9/f8pd46qNGeeGtpvtE/Z4CINSn3ufhRZkPnneZqJdTRGxSBRsIYaLB084jbyQOHbwxMBl1oTAxhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PXECxm79; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PXECxm79"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17316C116B1;
	Fri, 17 Oct 2025 15:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714367;
	bh=1QoD1IIR1jfwwIzVio6d4hfwJ6pZoWZMcjeueHoIp7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PXECxm79QT28QbN3UUy+gqJ23xv4dxjHjh3hIH1ltZDkif638595iRIK6rtKCcFZP
	 T35hmK6Hqm9qNUxUtn08nXDYzOAHdtsxXTq0ApLmeF8QUVXPHpauPeCCh6xlLukIZz
	 cSxzUVA6yWDSZeMSH/WPyqLO+1S71ebG3AdgSOsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 120/277] blk-crypto: fix missing blktrace bio split events
Date: Fri, 17 Oct 2025 16:52:07 +0200
Message-ID: <20251017145151.506943464@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -230,7 +231,9 @@ static bool blk_crypto_fallback_split_bi
 			bio->bi_status = BLK_STS_RESOURCE;
 			return false;
 		}
+
 		bio_chain(split_bio, bio);
+		trace_block_split(split_bio, bio->bi_iter.bi_sector);
 		submit_bio_noacct(bio);
 		*bio_ptr = split_bio;
 	}



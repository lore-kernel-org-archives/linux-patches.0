Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B2D327783;
	Mon, 27 Oct 2025 19:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591873; cv=none; b=sSaM5JyeZgFkSQ6FuN49qs/zKTV1LxoPSr4zlYBB6Zj9Psmtzo8rkt2Tqy+PXWdjQ59UJ5KZNWvdGm2zihXT+M649tae2iHhTxSjxwPUVZfHYJjcTRN9JW3s1O3fEk+JqdoaGtwsqaWssk9EiAmJYixNwoiDWqcWg/krBO4KPHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591873; c=relaxed/simple;
	bh=En8yRtAgrJJDhG+lJWpi91gQqwDOtOqyfkQRyiozwGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkxY0FCrPD5DuH0MX1ML+btb1kagpQUyagl+IQqYNp9tDfUJWTEmvN68eTbK8LEPELb1/WQD70G1E493v9nj79r9KGyZJrAMH5zfLY3/1jAglQmpXrRRAE3uVkHHt8/CKmjbjyq5kTcTMleq7RL/AES6Y4FFobXpnA0GLHhZya4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJZY2Mw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJZY2Mw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D165DC4CEF1;
	Mon, 27 Oct 2025 19:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591873;
	bh=En8yRtAgrJJDhG+lJWpi91gQqwDOtOqyfkQRyiozwGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJZY2Mw3DyrR5geenyztVEIu3jUxupxZpdPgELZ5rXiu3t5kdJ2MuDVosM/ZTw1ko
	 sUlr5ZWf/FXavpqYAUxyWwGK888iopcRRpg6Yfo96W1h6m9vHMe8ukZ8zeOBcQFWqh
	 0XJlIPZT9Qt2BC/mWkXyo1djnZg+kBeALS5b/NKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/123] blk-crypto: fix missing blktrace bio split events
Date: Mon, 27 Oct 2025 19:34:48 +0100
Message-ID: <20251027183446.618591946@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ changed blk_crypto_fallback_split_bio_if_needed() to blk_crypto_split_bio_if_needed() ]
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
 
@@ -231,7 +232,9 @@ static bool blk_crypto_split_bio_if_need
 			bio->bi_status = BLK_STS_RESOURCE;
 			return false;
 		}
+
 		bio_chain(split_bio, bio);
+		trace_block_split(split_bio, bio->bi_iter.bi_sector);
 		submit_bio_noacct(bio);
 		*bio_ptr = split_bio;
 	}



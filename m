Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0CA5695;
	Fri, 17 Oct 2025 14:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713160; cv=none; b=HzgJXk2nM+vze4YoUTbaA02Ha+bl2Zu9CDI1VIwL6lrGyqEMCPH4wBTsoXZBGqisqYoD8dSp9uksgsURWcPwCNQgKJa3qVBgSKTyf8yQTBkCphg8lX7Z0zk91wfBMwaoWkfdVjSHMiFy/p7OrvmYyxB61wZZj8e3+k7qxmDysCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713160; c=relaxed/simple;
	bh=bH3as0UNH5PJOeRDqVnPD2oLwMCitTUXAp2mWuSJ+OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5eMpOBkFKBVp7PRgt+ImHRqamryjywaLqvZf0BnIei+wdEb7oY18PCCarn7Uv0C7pxTPpYbR7m8afKvTaYi0n07YsTLzF8rJzcePSCG5P+FeSx1WxifNqS2g96L2Kcol80H3JGw/LL5i610lw/tx2sYE9hd1EO30dlwZv9IJak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wmrcn+R+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wmrcn+R+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083A5C4CEE7;
	Fri, 17 Oct 2025 14:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713159;
	bh=bH3as0UNH5PJOeRDqVnPD2oLwMCitTUXAp2mWuSJ+OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wmrcn+R+8oeqOUIe5X8F6ekT+MNTcJF9Dj/ydIPMEFsH+KZkOch8TQu9z9/GTWeIE
	 FMaSQbWQ8OLbAf0HGcrvPDmGRWjg3H1CS/B0JrKlxEb+yxyNxHlp1QxVDQ9GUjqcia
	 ZJRiyyAt+yAg+8Pf8feGKJqe0bHNQdTySM+s4M0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 069/168] blk-crypto: fix missing blktrace bio split events
Date: Fri, 17 Oct 2025 16:52:28 +0200
Message-ID: <20251017145131.568184445@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -229,7 +230,9 @@ static bool blk_crypto_fallback_split_bi
 			bio->bi_status = BLK_STS_RESOURCE;
 			return false;
 		}
+
 		bio_chain(split_bio, bio);
+		trace_block_split(split_bio, bio->bi_iter.bi_sector);
 		submit_bio_noacct(bio);
 		*bio_ptr = split_bio;
 	}



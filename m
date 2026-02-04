Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D73E18859B;
	Wed,  4 Feb 2026 15:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218675; cv=none; b=dR3rlaNeZSa7Dl3BVP92VsXvvl81jkgobyirzdxQZqwXneofreIXtTvggL2kDUtECvetQRScZ1PCi3YZkgmaeq2sM3e8CAtJzkaUlujUGp2ByEWxNQ06khAa4Vo3WAOa8Fbx40xYdP0dI2OPd6iBXmPztSjA2FO+2C2Yp+3GnxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218675; c=relaxed/simple;
	bh=rw/gnlC8RB1TksdLUUXTqPKNbHdPi7+YxFbdq5jmXk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtYXsKfU5FFrlqqt2CzDi9iwzNh47XezDhBV+eSDDTsEx/n6M76l9bmI37eSaY+YGTsr5CWJSK7LxHkfh5P5pwLWf0lm4U64klX3zG6yyYXlunqHq8VqeWvjZUie7wWQlAwMDmCBAXr51L+fi2Yf5A3Ua/U3+9qi9fPip5TkSj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iK5FxnUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iK5FxnUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172B3C4CEF7;
	Wed,  4 Feb 2026 15:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218675;
	bh=rw/gnlC8RB1TksdLUUXTqPKNbHdPi7+YxFbdq5jmXk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iK5FxnUsv0j9JO85TL9B+8AIfSTMZMp4yVSHxDN7m4M6E5alFe01f3yOTOxav55It
	 LnA2ODwLzRQVp+lkOQlz5gpL+2wivGrcGyZ6SJOyDhnK7qjIWXb6OLXXB9tij0//Ea
	 7MZFXOf2wG4wWOUczeqQqnXxV7m2gv3GJzGilwI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	Christoph Hellwig <hch@lst.de>,
	Shida Zhang <zhangshida@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 28/87] bcache: fix improper use of bi_end_io
Date: Wed,  4 Feb 2026 15:40:26 +0100
Message-ID: <20260204143847.923976606@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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




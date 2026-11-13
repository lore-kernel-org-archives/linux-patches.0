Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590377;
	b=JxmsjlltP3wYYpJ9YyOmSnwakHWvQAvsKpLgR/2D7gAzqR3XXDAMgKkZyrsm2QkSufc/
	 ii42UwSO0fmcyBoy3Geds+IjCTr1LcTVG33XlxcaXGA1OfgL1qrJVxEFqx+BPKo0VWBhJ
	 Nos8xP1A+tgLHD1B3avzKasWvfnA8Q9RzO62bwK0fP3Tx/XM4JKPGoglwkULqS642HfcA
	 q4YJt7W3vFE0d5pb02GxahSODcN/5qWWKF7iLLArOhOTpj2SSJTrOEJ06++z5+WPAY7EW
	 zUekskjzIUQmpnoJ62aTxF7JXHriKbZ5tTqHIW5VmtK4HoJtXVVyeC1aniuTv97BtZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=70xnU9L+jCaGnZhlwAjZyX2jTlLEAiQ1E2JMl2JRz8Q=;
	b=YV4D2SFY0yqLJ2cjJLETIiJ8WESn8NQfIAPn6hy6va3TZGQOcSSYxuhgVvvM4SdRwVeD
	 byE5j60D3rX58MCUD6A9Q/pSClKNBmq8zyPC/mKt1yum/JWIJzrbuto45e3kQodU3l+eH
	 AkG8kzGVrxX8eRHXMDINH5MHTle/IxWTBx51UMMet+yyOj2hf7SJNJQwl89b0HMVZKxuU
	 k1RvvqvXjxrKCu6Y6/iPocspwCTx67hh+tO40M87IZvKXD5RPIOCqzzDfRCG5bu2pRYgG
	 KnEXMXGCDB3UcUZsf1n8NqagPbdmSKzHndafKq3JiJMiHuxnVDPvvGm0fNy4zXGFXbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FvExOzE0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DD3606B340;
	Fri, 13 Nov 2026 17:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FvExOzE0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBD61F000C4;
	Fri, 13 Nov 2026 17:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590377;
	bh=70xnU9L+jCaGnZhlwAjZyX2jTlLEAiQ1E2JMl2JRz8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FvExOzE0D5wOtZ/wHGLKPJD130DvqEB2pvpXMF1+Gbhm34vP5nYZbSNfQN14Pr2kK
	 0GIt4pbL9Z/xJVLSkiBozVdb18FsqFWbL/QT7oxD6GfLLQCwVdaBnIkwDDDjfD3tDa
	 inDJC9URG3+hb8tw+vLnM8HH+dCp1jgGXWr8FX2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 348/686] blk-mq: end the request if getting a keyslot fails
Date: Fri, 13 Nov 2026 10:48:01 -0500
Message-ID: <20261113153832.715201906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit e67cb6ed40e7f45912b63d7d575f18dfd2ebc98a ]

When blk_crypto_rq_get_keyslot() fails, blk_mq_submit_bio() ends the bio
by hand and frees the request. By then blk_mq_bio_to_request() has done
the IO accounting, which blk_mq_free_request() doesn't undo, so the
in_flight counter never drops and iostat shows a device that is 100%
busy. If the bio went through zone write plugging the zone stays plugged
as well, and every later write to it waits forever.

Use blk_mq_end_request() like the dispatch path does for a request the
driver rejected, after marking it for zone write plugging.

Move the call to blk_zone_write_plug_init_request() before
blk_crypto_rq_get_keyslot() so that it doesn't need to be duplicated.
It doesn't depend on the keyslot.

Fixes: 99dc422335d8 ("block: support to account io_ticks precisely")
Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261029200110.1328103-1-ebiggers@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index cced68a0e3c53..b7347c4462cb3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3223,16 +3223,15 @@ void blk_mq_submit_bio(struct bio *bio)
 
 	blk_mq_bio_to_request(rq, bio, nr_segs);
 
+	if (bio_zone_write_plugging(bio))
+		blk_zone_write_plug_init_request(rq);
+
 	ret = blk_crypto_rq_get_keyslot(rq);
 	if (ret != BLK_STS_OK) {
-		bio_endio_status(bio, ret);
-		blk_mq_free_request(rq);
+		blk_mq_end_request(rq, ret);
 		return;
 	}
 
-	if (bio_zone_write_plugging(bio))
-		blk_zone_write_plug_init_request(rq);
-
 	if (op_is_flush(bio->bi_opf) && blk_insert_flush(rq))
 		return;
 
-- 
2.53.0




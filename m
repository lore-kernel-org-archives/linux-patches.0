Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585662;
	b=u8MEk25Wmi7OJ3EjQMeoeKp5ytPPWrcGKUw4fJF7e8SEigBtc6qi7yMqOtqoqyyKhgKE
	 2kgJW6aj02mvYKNuQ+caOklnG2XjoYMiM/zQ1gy1WqlusxK3JovlBmeWhGghrYq289Mgg
	 3AXXjKYnAK8mEvTDzn47yeMwsH5rr7wVPjPv4W9LXOKy+hN0A9TZBQod5avwlOx5ARQlc
	 Yd5p44b/mQp17ct0zAJIKcRS69qUd6iKo0ZtUYI2oe6p6AxEu/8OabcrK0adj0VNS8YR8
	 xMdkil9xm5+fgXCcKXtcX2vjx4oC5qoOvoM/YTlj1BdeM5IuNrAQ/tTqbysXpbLFy4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=55VpnoZ/trczYprnOb/VswImAn4i5KBYcv98/UhLhfE=;
	b=Gvf+iMuo0TvGhz1wZl9N5EuJJbzKlMs0A0nCK5WOQfr6CX67NQgFxuAEtxhtCSTQuE67
	 7xI7lwGzMMa43WNKZetULfyJ2sWLTleyze86ZBWR7AHigR0Y7wOYk7ZR96Zp+ZbolDCSn
	 tKjpZcik/J2FLYjyOheqpjC2WqbGt90OD/nnaedL5fCGv3R1oqbRxunfXIFZN8c7/oirr
	 JirxngXHA6GKFISv6M/kt9w2CxsjwPIxoBhr34l5DKw8bGkySJp7VyyKPQfD47Cyja8hf
	 0ERjpd2TRDX7mMTv5K9NE6umatKZ2AYMNIvtv1LMfIS4AbFXdWIm3WEbsPtu7ApVtkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVer3Z0E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04600606B2DA;
	Fri, 13 Nov 2026 16:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fVer3Z0E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37C71F000C6;
	Fri, 13 Nov 2026 16:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585661;
	bh=55VpnoZ/trczYprnOb/VswImAn4i5KBYcv98/UhLhfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVer3Z0ERvmWmjNOwlAtQvqwSLXMqVP6QHQoVI7moSYad8X2jU7T/0zCncEjMHrHH
	 Q9brArc0WCy9yvRABQOiQ5Oq4fIY+JRe4SwZ6UCum6yMNxs3zDpBJ1Mu5H7g7k1z4r
	 12KnUFow5MI8QWsrilG7S9vXBxJaCWWRvYUViqCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 274/507] blk-mq: end the request if getting a keyslot fails
Date: Fri, 13 Nov 2026 10:49:38 -0500
Message-ID: <20261113153804.084133470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 5a5dc66fc3b15..6d111c6f0ecd1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3193,16 +3193,15 @@ void blk_mq_submit_bio(struct bio *bio)
 
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




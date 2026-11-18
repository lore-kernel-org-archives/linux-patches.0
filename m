Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038029;
	b=UaPQKrzg8dU2uEYdHQ3teTyrmo0y/hl3uDOKXQh7fImUbnvJjM7bTbcBUPhtsGjJ+LSb
	 Wrk3DL/GU7m/ooW7sal/z4p7jqmsraoN0046SjWDaA/Wzn/evzKyUMCznODRv9Kk4mAQN
	 xQXF5GadTkzcDjxzA6XllQXHbyF+yzNLttfakr96Te3Vm4RBnp9rqJ72ppottJiyf3WkS
	 OP1IvJH9ljzBhSEuuyf2uLq4i3iyX7w02WLNjNhTxBa8L+Y7zQKtDrDKvNF6GGujVmoi7
	 ghK5AQKeiIWfEjkDCHg1fI48d0232Sv+wYzR+AhHpRfaWGxIo+WyEoI9WTBWZnUnTEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Cdk6xHvd71xrmeDD7IBiH8YXvUdAfOVZt8nKYUNySs=;
	b=ZEFbgqAnMAEQUBb8KHvOSgJ2J0gSr/5f3J4076kcY8nmtC1dRBVcg9HVul1cWLsbm3B5
	 Ov3avWguIpvApojC8evRs3jlywK/ef6PoGi8B9vMygDWWrvXwv/Z9bBxba8nma1T01OVN
	 jiqfYpMdgjtDLIEU67Y7sACC/RudqtkDfbukTZtvt1QfAHApHc61sImdZ9iCnxr4NrQPY
	 9CpwTxy0mSGFdZArtiPPzExAoPPak9Th9DOUA0dOoLih6Eo1ma5nuzaaMTaj0RM7quFe5
	 smpnyXnE15XY50K+NpzktvDmI8EnDILzlArfE4U2fKJsB40shcF2/JPOSIbBza1xGbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xTKN/3b1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4964606A320;
	Wed, 18 Nov 2026 21:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xTKN/3b1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381D01F000C5;
	Wed, 18 Nov 2026 21:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038029;
	bh=4Cdk6xHvd71xrmeDD7IBiH8YXvUdAfOVZt8nKYUNySs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xTKN/3b1NWjeXuAPx4I5wuHIxP3qUIfMNkfJ4k+PYx2dFgC1Ag3iki/17s+QBJ4JJ
	 RRHEmTGZXvUoQAlT/7xxbyJFQ4pOifeCZvmpD9JabucOp47yH2vtOhwuS/ErmbgpnC
	 19eRmTnBn7SBwPMBBEcUgvxDx/ZJS+PXZ91Nicbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1599/3318] blk-mq: end the request if getting a keyslot fails
Date: Wed, 18 Nov 2026 15:37:01 +0100
Message-ID: <20261118150409.138360670@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit e67cb6ed40e7f45912b63d7d575f18dfd2ebc98a upstream.

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
[ Backport to 6.6.y: dropped the part related to
  bio_zone_write_plugging(), which doesn't exist on this branch. ]
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index aebcc7fb17865..32b0bb53b8758 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3069,9 +3069,7 @@ void blk_mq_submit_bio(struct bio *bio)
 
 	ret = blk_crypto_rq_get_keyslot(rq);
 	if (ret != BLK_STS_OK) {
-		bio->bi_status = ret;
-		bio_endio(bio);
-		blk_mq_free_request(rq);
+		blk_mq_end_request(rq, ret);
 		return;
 	}
 
-- 
2.53.0




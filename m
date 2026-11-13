Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591308;
	b=z9J1bqBj8caUo0NLE1yNhG9GgNlQnT+8lFwiT4OGHgQpB9hZRz57fCC5hBdPooXA3s7e
	 v6DroSChJSX8VscfNShy4cXj+OkXYF9xSnFAMgaRrcPg5FvUaGLw9kxpsgOkZIgItljWD
	 7n8qyA6ASBKuvuSgSkMpnkQuuLR4Nis4IeidsvFlhhoSOA8+pbPZT+ltFYJtVRqzwOQIm
	 srcrA5+yZW6dWOWAkeqlYVaR2hHnN3Qs/MWJ6scpDDE2STXvfn+TLtsUDTClm5JlQutFB
	 6DNq4OLCrysaJKCtiv+TdCCST+KdGAlVSW6LtPp4HuSYtkJis+nHnNH3kGfuEnb8qxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mAujjRFvY90gcjw6bwbkrZW6VU1bat5uFAsw6mZI0k8=;
	b=K+RllOdhowabpNNsAdNQu57ZRwmC/ZgAvpFOAhlkE9WIKFp6wWNIT2DWDAWAX3QHp45Z
	 ffvhvjaimcSKKzdgew3ddpRvd89BVM2pCuwL+FA8LwAbKca8P8CU5yZSOPKq9IMh1I7eG
	 kK57UAwvUyaoAbTNxbcw2ZdMp0gHWnCjLRcPNrVpFxUgOj/0TxStafPwr1SQBG7GQUajo
	 C4O/fquH6xcvDVF44h+w66rgINy3nFtv+SjnW6PfdTZmgk23Tgim6lWnmoWd0wQ23zyBj
	 PXHUMjr2EpfX5EzZzgvVTZwTNSbBtOjiejbYpfMjiBZjBXGxJ4mqne1/YRr3D/SqP2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kmHNnj8v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7159B606B202;
	Fri, 13 Nov 2026 17:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kmHNnj8v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5721F000C5;
	Fri, 13 Nov 2026 17:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591308;
	bh=mAujjRFvY90gcjw6bwbkrZW6VU1bat5uFAsw6mZI0k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmHNnj8vyGCxRn72YEJsYVFdrr/McQY2LPELE2CbMwUyDQlRopBquOBnv+rr/o1cM
	 o97WowBu/4w4j8Gx7BHDkdY1RwxHwgvU5WFSbfUfApW6jbg/YN6xWxSwSLHcc/y8rU
	 f+cw/3aqT5OX4aKbzXWm6+Tj3814SaRBA95Ejf+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 421/670] blk-mq: end the request if getting a keyslot fails
Date: Fri, 13 Nov 2026 10:49:45 -0500
Message-ID: <20261113153826.005505240@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index e01437e64c740..c5be2e8578a7b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3122,17 +3122,15 @@ void blk_mq_submit_bio(struct bio *bio)
 
 	blk_mq_bio_to_request(rq, bio, nr_segs);
 
+	if (bio_zone_write_plugging(bio))
+		blk_zone_write_plug_init_request(rq);
+
 	ret = blk_crypto_rq_get_keyslot(rq);
 	if (ret != BLK_STS_OK) {
-		bio->bi_status = ret;
-		bio_endio(bio);
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




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042671;
	b=u/9+wBppKfw63ZxeVXm79cIpVoILYgOH/4o3BSE9WXoL1d+0YErz6lem4htH0HtP1XJk
	 ynKeM+Tb32KYChGy8zwY/z8qwx1z7D33PLjl81dWjxOsljFrkyTCpjQ6w4aG24V4PqpI4
	 lGM+r+KOnBtl7ll0/SLJ1PdZQuGYieLVJSNSPMJF7vUlkKx6BeuAE/iGTvioHD/flnCXX
	 pyl+TLBNetJFCbnsUhP+LgWYfYyBDYBQ5YQSDGxDT9LiZIGdgRzbh+XMB+yOtkSlYV6kH
	 84Dgec1tTYMn6z3+7s72W5Wnm2JKhTt6TSWqkULRuvx+b1qJnqtkhAFObxSDIRoOPXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dExZhXhB4pPcoY1ZJuu2g8QiB9+Tv44rG3iX+Zx1KVY=;
	b=aIU0uzFqmXZEJwKE4fl7kEzu9fycZaTF5QMfxLfAs7NFOcww0qemFXhyXOmOyO+7O0fC
	 1i6V9IFRWM6OCNjCne/00TMFKZqgFdEhYXGHxOwQOAFO0m+IsEf67s8zHQu+aoDE/uMeU
	 QW06iIkvQ1vekaZ04U5+xCXD9+mNT266sY9KkHMr0Mab4tQqvNxugmPLo5AvpT38EmoIi
	 oYq2klmrQG5cV2LScHXSbsZMrJXaoyXl9XHAmiRALRZ+zmZu4ZKHSLvmo4m20gA5NRrFO
	 aukuRTbzqwTx5ozNjXFsMN6RiYoVb0rNzJvQLRYbpyGxL/qdf0+IN2gwnRd2a3dCk3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o4wumv6c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833CD606A31C;
	Wed, 18 Nov 2026 22:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o4wumv6c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD841F000C4;
	Wed, 18 Nov 2026 22:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042671;
	bh=dExZhXhB4pPcoY1ZJuu2g8QiB9+Tv44rG3iX+Zx1KVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o4wumv6cSHvb4ltU91iherY8/rLlkoy4pCNYQY/u0HMW4TVP51lNLYHyEJs4RbFMo
	 gQPgE3DNgrc+Cyb5Ej1w1Uzn7ArLuLyice3xvp27B3sn6x4Q4JGOkS/4jo/svsr8AQ
	 QTsjam23WivTRi/0lMbBey8wOS2YEv5abeXwVx5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Dennis Maisenbacher <dennis.maisenbacher@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3255/3318] block: Allow using bio_attempt_back_merge() internally
Date: Wed, 18 Nov 2026 16:04:37 +0100
Message-ID: <20261118150457.284610241@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit dd850ff3eee428b4e1276bd51263dd937643ba19 ]

Remove "static" from the definition of bio_attempt_back_merge() and
declare this function in block/blk.h to allow using it internally from
other block layer files. The definition of enum bio_merge_status is
also moved to block/blk.h.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Tested-by: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20240408014128.205141-6-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 9531230ee1fc ("blk-mq: don't bring back flags of a completed request")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 8 +-------
 block/blk.h       | 8 ++++++++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 889ac59759a26..1aa2085e1cde4 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -978,13 +978,7 @@ static void blk_account_io_merge_bio(struct request *req)
 	part_stat_unlock();
 }
 
-enum bio_merge_status {
-	BIO_MERGE_OK,
-	BIO_MERGE_NONE,
-	BIO_MERGE_FAILED,
-};
-
-static enum bio_merge_status bio_attempt_back_merge(struct request *req,
+enum bio_merge_status bio_attempt_back_merge(struct request *req,
 		struct bio *bio, unsigned int nr_segs)
 {
 	const blk_opf_t ff = bio_failfast(bio);
diff --git a/block/blk.h b/block/blk.h
index 13243d9fb8964..5590a4996c3b0 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -276,6 +276,14 @@ static inline void bio_integrity_free(struct bio *bio)
 unsigned long blk_rq_timeout(unsigned long timeout);
 void blk_add_timer(struct request *req);
 
+enum bio_merge_status {
+	BIO_MERGE_OK,
+	BIO_MERGE_NONE,
+	BIO_MERGE_FAILED,
+};
+
+enum bio_merge_status bio_attempt_back_merge(struct request *req,
+		struct bio *bio, unsigned int nr_segs);
 bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
 		unsigned int nr_segs);
 bool blk_bio_list_merge(struct request_queue *q, struct list_head *list,
-- 
2.53.0




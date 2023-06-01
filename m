Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCB2FBEA
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09ECC433D2;
	Thu,  1 Jun 2023 13:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685626120;
	bh=V5XCCy1Y5T06uGJ0Mn5XJxdSzPZaj3Ua39Jf+spkDnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubRHO8n57ENgQo2O/NVsl9wOJQ2n/IbOsxKhVGX2UpsYB38d7dpddqZUaHb/NIOku
	 4947S9c3EBKsC2GP5aSt7WP3DWisH9hcmS11uKoUSCSo1lJN/Z5FWf7Qjv/OEm44vf
	 vu0OUaAqo7LViPCDeCAKiFbrlZhGcygZkRDTX0Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 38/42] block: fix bio-cache for passthru IO
Date: Thu,  1 Jun 2023 14:21:47 +0100
Message-Id: <20230601131940.761752786@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131939.051934720@linuxfoundation.org>
References: <20230601131939.051934720@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Anuj Gupta <anuj20.g@samsung.com>

commit 46930b7cc7727271c9c27aac1fdc97a8645e2d00 upstream.

commit <8af870aa5b847> ("block: enable bio caching use for passthru IO")
introduced bio-cache for passthru IO. In case when nr_vecs are greater
than BIO_INLINE_VECS, bio and bvecs are allocated from mempool (instead
of percpu cache) and REQ_ALLOC_CACHE is cleared. This causes the side
effect of not freeing bio/bvecs into mempool on completion.

This patch lets the passthru IO fallback to allocation using bio_kmalloc
when nr_vecs are greater than BIO_INLINE_VECS. The corresponding bio
is freed during call to blk_mq_map_bio_put during completion.

Cc: stable@vger.kernel.org # 6.1
fixes <8af870aa5b847> ("block: enable bio caching use for passthru IO")

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Link: https://lore.kernel.org/r/20230523111709.145676-1-anuj20.g@samsung.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-map.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -246,7 +246,7 @@ static struct bio *blk_rq_map_bio_alloc(
 {
 	struct bio *bio;
 
-	if (rq->cmd_flags & REQ_POLLED) {
+	if (rq->cmd_flags & REQ_POLLED && (nr_vecs <= BIO_INLINE_VECS)) {
 		blk_opf_t opf = rq->cmd_flags | REQ_ALLOC_CACHE;
 
 		bio = bio_alloc_bioset(NULL, nr_vecs, opf, gfp_mask,



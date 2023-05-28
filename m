Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4E6569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD5CC433D2;
	Sun, 28 May 2023 19:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302205;
	bh=5R2r5N0I214zWKqjZvNgRMyJSjvoqiBpTHc2vRNluGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p0d87T/TEbeJQx/G9IbiwwEihOjxLuZj17M7kfBZ35DXs87pxS1NG5cgYWMsrtboV
	 NssTk8+hUeTBqw7bIaZQO8jBiOuAfGx2qN7aBQuL4gO8q5MOVTYKC9/+wOdfP8LmHs
	 FQd65wGfs5lkaZEr5DP1EkwnZAq4HILcy1jLuKGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anuj Gupta <anuj20.g@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.3 042/127] block: fix bio-cache for passthru IO
Date: Sun, 28 May 2023 20:10:18 +0100
Message-Id: <20230528190837.716648413@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
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
@@ -247,7 +247,7 @@ static struct bio *blk_rq_map_bio_alloc(
 {
 	struct bio *bio;
 
-	if (rq->cmd_flags & REQ_ALLOC_CACHE) {
+	if (rq->cmd_flags & REQ_ALLOC_CACHE && (nr_vecs <= BIO_INLINE_VECS)) {
 		bio = bio_alloc_bioset(NULL, nr_vecs, rq->cmd_flags, gfp_mask,
 					&fs_bio_set);
 		if (!bio)



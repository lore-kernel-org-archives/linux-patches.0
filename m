Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5A315CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9439AC433D6;
	Tue,  8 Nov 2022 14:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916746;
	bh=e8tBsfk9EYh1neUMVjssmIJU9k1CMFsjsde1Uilgo88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RK4pJg9WoFmgoGSL9lYw4r5v3ylOuVs3YK5dMIbDW8VJqQb79BVkVpUSPCKf6t3gp
	 ReuhqSznjFGNfXyblkg3KSaNjhEaqYDEj0R6DVLB9iW30ucTraWR8nsOMkyt1dJojo
	 cRAauDobhKQu/iomwvEJ7nApyFyETnK2N0XbwWuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 091/197] bio: safeguard REQ_ALLOC_CACHE bio put
Date: Tue,  8 Nov 2022 14:38:49 +0100
Message-Id: <20221108133358.974856207@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit d4347d50407daea6237872281ece64c4bdf1ec99 ]

bio_put() with REQ_ALLOC_CACHE assumes that it's executed not from
an irq context. Let's add a warning if the invariant is not respected,
especially since there is a couple of places removing REQ_POLLED by hand
without also clearing REQ_ALLOC_CACHE.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/558d78313476c4e9c233902efa0092644c3d420a.1666122465.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 77e3b764a078..fc2364cf1775 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -741,7 +741,7 @@ void bio_put(struct bio *bio)
 			return;
 	}
 
-	if (bio->bi_opf & REQ_ALLOC_CACHE) {
+	if ((bio->bi_opf & REQ_ALLOC_CACHE) && !WARN_ON_ONCE(in_interrupt())) {
 		struct bio_alloc_cache *cache;
 
 		bio_uninit(bio);
-- 
2.35.1




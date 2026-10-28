Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209937;
	b=KEY0jIXc7QqiFKVtA2UMSsw98f52cZKLQKTK2XEvUrrbcuqY1HKFI8cbI4+q/s92bIJt
	 Vnwc5BXezgtrwUUZl7AbO3RX6tgtWiRPBmk9a/VvCvKROAUdpWOZJ2oOSrPZEY62L8cWt
	 bq1Ed0bh0FDRlGgzBI6KOKMF+3aqlgbHF11gjuMAvSb+P8A8CUFti1MuZbqnOpWi5wKHP
	 s+JL+tYd48OuAZJcLMBz/AscyXiVKG+ap3XquvGW/5Jd+jLm+GiD7cksy4nYGzILJu/yn
	 jNow4r+zFGSx+a55jpOFpgKbMs95SDWnJPbID4Sv9SlQOxFskRdmjU0pC02kFgivy0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7YDkouNpxIfThqP5nu4QT4EqE/s/Fay3Fg34pdO3tEE=;
	b=Ma5iECdbcsI5mCEdGxeBZjXtbWLK1kWLVmW3TUhMlaxPs7jokoolS+UmQWl/qIeSyWyw
	 S1T/g6EQXZMkDFlVchUMqGNAmH6JzaW66niCwBBkaW31gSgzKgAsoNHcPsBjoN1jP2+Nj
	 GXvyAqshED6CUZrLOs3LBhNa1T9CTfjqlLFiVo3jnmbjoR8xcLAiO4xR2hwfwqeFrGLL9
	 W0M/XPM2n9jtSpDGMnuopEjeyuSe3oXRPG4Y6nMAjX8Fv/XSd6mgJHAXxp8t/NgNRolK1
	 6kenDbbll+jvXmTBCWWISkkiwQnvLXVwGgvuPF6I0QRZyGKpqRtlN4NPBWh/6HokIiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c+sFSURU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155B6606A31C;
	Wed, 28 Oct 2026 17:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c+sFSURU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E331F01825;
	Wed, 28 Oct 2026 17:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209936;
	bh=7YDkouNpxIfThqP5nu4QT4EqE/s/Fay3Fg34pdO3tEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+sFSURUQQOTPr5GUYQvtKZDu2fJ0mYNUPQXynqWfkOI7QMsC9ovtmEoaAQyQA3Nb
	 mEugb5ScCHb73uOcID8+2znktRAuHefZZadRJfViWhlz4DTstt0nY3Y49XCKXMmU36
	 PCL9tHmuv86cXvsgo8KUB34/ekch6vEJ5Ae7VNx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <tom.leiming@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/168] blk-mq: reinsert cached request to the list
Date: Wed, 28 Oct 2026 17:58:58 +0100
Message-ID: <20261028165943.152520205@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b051bb6bf0a231117036aa607cadf55be8e63910 ]

A previous commit removed an optimization out of caution for a scenario
that turns out not to be real: all the "queue_exit" goto's are safe to
reinsert the request into the cached_rq's plug list as they are either
from a non-blocking path, or a successful merge that already holds the
queue reference. This optimization is most needed for small sequential
workloads that successfully merge into larger requests.

Fixes: dc278e9bf2b9 ("blk-mq: pop cached request if it is usable")
Suggested-by: Ming Lei <tom.leiming@gmail.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://patch.msgid.link/20260526153531.2365935-1-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Assisted-by: LLM
[ Backport to 6.6.y: Reinsert with rq_list_add() on each of the three
  target preparation or merge exits; the target has a single cached_rq
  list and no shared queue_exit label. ]
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1ad77737b27d3..e3fb9222c5ee0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3024,16 +3024,16 @@ void blk_mq_submit_bio(struct bio *bio)
 		if (unlikely(bio_may_exceed_limits(bio, &q->limits))) {
 			bio = __bio_split_to_limits(bio, &q->limits, &nr_segs);
 			if (!bio) {
-				blk_mq_free_request(rq);
+				rq_list_add(&plug->cached_rq, rq);
 				return;
 			}
 		}
 		if (!bio_integrity_prep(bio)) {
-			blk_mq_free_request(rq);
+			rq_list_add(&plug->cached_rq, rq);
 			return;
 		}
 		if (blk_mq_attempt_bio_merge(q, bio, nr_segs)) {
-			blk_mq_free_request(rq);
+			rq_list_add(&plug->cached_rq, rq);
 			return;
 		}
 		rq_qos_throttle(rq->q, bio);
-- 
2.53.0




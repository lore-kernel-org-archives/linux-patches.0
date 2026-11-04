Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826944;
	b=0de9KaA1qYT04FDeqSVWwIAsrXQo6kyEVDYbOKroKQcRK4MbQOjTwmEJ9t0SOK5LYyT5
	 y5PRUsuGfD8wOv2N1bEhDJ00cy0YOfK63bIsWwoVlVDeBvauYrhLOuZTlInv+RV8TfQsA
	 U3oodiLYBu5KCCE0t7jR+Dc0Kz/qIDPvCM3lYhLoyR+hKm0rWI4gEronGWvt4aiBjDqhz
	 2JB4E+qCu+SSEFZxYKi+aDwYAiULM39x1ChlxzmvDHUKAkflfTPle4iEbmEjWkBG1eXny
	 XAYksUuak5KEsD6/qEbQ0zE3aMJ7sQCZNvQCDbxbmujdgwzvmvDx5iNdn1EoieI6JuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9YUKl7JT6vKSQIQa3GOqJbCOjm1TMUyedxLsFmObpH4=;
	b=mdhbMHQrZ5YNBeA0DIX5iRNkLU08MZohaxClLaOb0s+ZIFuUoZ9J0mRkF3GTWRs6KftU
	 tGQtpoTYMV9qYdGSJy7//EywY0ooR66e7n4eDormkgi+Vko6zqERwlDSKDDEd5QCOmPgE
	 ssaNF+GP+XOvyAgyKDvklDnwvlNVUP3HC4k4R0bSFpnlRDaD0V5xjdY4ofyGUipUr8j4e
	 CT9VCIfKm20m73uhAfMVBPpxAOPhXyxZfAAvQHxUJTWt7hVrzAq+keTqjOCpn6L3ClEyr
	 NBhIbH7DFBNyoeupJK0XNMf85v5j0qdYK85ODIO2KusASHsr3uTOQ23i3h9gAnYPNtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PMknbMem;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F5F60B5A77;
	Wed,  4 Nov 2026 21:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PMknbMem
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7081F000C1;
	Wed,  4 Nov 2026 21:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826943;
	bh=9YUKl7JT6vKSQIQa3GOqJbCOjm1TMUyedxLsFmObpH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMknbMemXI+W1+SdoZncLa1RpxruVNMSeRtoMmr6ZaD8hSkNmYyzDaq1sD0twyd6y
	 QhV8sRjZTEa/IeSIBwkBv4x/5yO2ISlYMs0OSU2tmA6Eh0W0GA3mmvE6fixtlBnVs0
	 NvYsIMJpWpXBW0/qYENir5XLUnD6xEbTTMbOsd3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 051/547] io_uring/zcrx: fix buffer offsets in areas above 4GB
Date: Wed,  4 Nov 2026 16:03:55 -0500
Message-ID: <20261104211039.752679721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

[ Upstream commit ab4536bf2e5617b04f2d9396f06393c7bbfb071d ]

io_zcrx_queue_cqe() computes the offset of the buffer in its area from
net_iov_idx(), which is an unsigned int, so the shift is done in 32 bits
and only the result is widened to the u64 that goes into the CQE. An area
can be up to 1TB in size. For every niov beyond the first 4GB the CQE
points the application at a buffer 4GB, or a multiple of that, below the
one which has the data. It reads the wrong data, and then returns a
buffer it doesn't own via the refill queue while the real one is never
given back.

Fixes: 11ed914bbf94 ("io_uring/zcrx: add io_recvzc request")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-35-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index cc9df7e64a407..6d7abb1636e7f 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1645,7 +1645,7 @@ static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
 		cqe->flags |= IORING_CQE_F_32;
 
 	area = io_zcrx_iov_to_area(niov);
-	offset = off + (net_iov_idx(niov) << ifq->niov_shift);
+	offset = off + ((u64)net_iov_idx(niov) << ifq->niov_shift);
 	rcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
 	rcqe->off = offset + zcrx_area_id_to_token(area->area_id);
 	rcqe->__pad = 0;
-- 
2.53.0




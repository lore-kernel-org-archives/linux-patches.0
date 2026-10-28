Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209776;
	b=jxQRAMnHGSdoEJp80LN8pU9tImUeertYWHiAuNmjvq3lK++w45+B6J6dPPxJCj6xoD0m
	 +PgW9yWqjXN7mQxC7jnZG8HaAYlg0ymj89bQ07X6vfMfG8nGD/7XD0paXFBiT+gP6fLSa
	 AuIKrFPpxAMbJ8nnrEZuSXnLxjIiSSZmwdv7MFy4LX99trI0UzbAhsawbr2wGXQCAkuvK
	 IMz8qgqj/Z2EyxArZP4BFc/vpeMgcmPSOrQ+SkFnI5CbqmkrpsjgJYod7unJPlQHPSNdR
	 87Yv7apAr0bsB5jzyISD3LoxtG/K2xp8Iz1GUowDFoUZOEfbBMAhrStU4dc5WuvpFHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RDollUOkQ1iEzFJgqpMeEvx0cYwr/KMwBuyIR9S7c3g=;
	b=AS6RiqBkjLsAQKOAch9LO4eHqI/T9k4Hf9lOHZgLalTJdzBLLGl240w+/HZKqF8hXE7N
	 uP9el5VMbjpjJe6QCweF18dO5mZZA0YP5ocEq0oEokMYzO7j5dfr910u5Koc9qAcxgjLN
	 QTixCoo8f7qt8MTGx172LhlzKaQllj6HFCCN94cxGsaUxm4L3/a7sRVQQZWUWoH+oNNZn
	 gfWnKcc6ndjGwFKg1OeNMaYAXB3kR5Y59YDQSkoNte9qJGberkCactEH2qqSm+Mydh4cI
	 dkJIKiYxGVqE2Nq+MKCb0VHKUY23Op5G/MZ01GjChX7ztkSgl3D/qb1w0UtbgatIwLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="n/NdS+YJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8512A606A31E;
	Wed, 28 Oct 2026 17:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n/NdS+YJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7ACD1F01825;
	Wed, 28 Oct 2026 17:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209776;
	bh=RDollUOkQ1iEzFJgqpMeEvx0cYwr/KMwBuyIR9S7c3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n/NdS+YJ/EZlkiWwJeHMxQDH4W90mKGA/2qKjUpRMq2+oRuGBOo2smswCAKJs3vrw
	 mGt0znUFGybQ6QHTPeCXl1JP7UjRXhLuNHMQcC60v2O02dP8bvoYvd8oAufrGTm4lK
	 oMHPg5udfDxVeI/udRN6WtpuR+QrMYXlJdKePkW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 072/109] io_uring/zcrx: fix buffer offsets in areas above 4GB
Date: Wed, 28 Oct 2026 18:00:56 +0100
Message-ID: <20261028165944.051713901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

Commit ab4536bf2e5617b04f2d9396f06393c7bbfb071d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/zcrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -962,7 +962,7 @@ static bool io_zcrx_queue_cqe(struct io_
 		cqe->flags |= IORING_CQE_F_32;
 
 	area = io_zcrx_iov_to_area(niov);
-	offset = off + (net_iov_idx(niov) << ifq->niov_shift);
+	offset = off + ((u64)net_iov_idx(niov) << ifq->niov_shift);
 	rcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
 	rcqe->off = offset + ((u64)area->area_id << IORING_ZCRX_AREA_SHIFT);
 	rcqe->__pad = 0;



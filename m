Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826841;
	b=x4mcFZpXBapktjvvLOmAnhWHxGX2hqz2DhL/8EC1fthinktAa9b5+5M0N7xq9tZ7g1ck
	 uIrWAR/NrIJbmjTl9HF871CSQn2Bf7ttXzPNkk10wdjo50Z+pDw8SzNIG8AzSqUP6iHVF
	 ocxJPDHM4bJcl5GjnfJ9UKQFEV9nQMYXsH9HFbFawY7KMG2GSanRB4eAjimskz0LDzqwU
	 efN/iGK+i2dTlrn1Tf1tZYu3huloTA+aCFm/9IG2+S5aOU8ffUWrbQqX9lAIr0Ro5Bte8
	 JPggGCyXLprFyCLNG6vS+zgBSLQDyk9t+/V5TUzPJlX1K0qt/aVUi/4dg2snUWnwRmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9EaNo/GKA5J5rgjx36DcGi7oKTNOTxrJ8o15oGd0HYU=;
	b=bu3XCsqa/uTMyeBfFR0fPhXjtpc1lYNY5N9L5io6Wv2yqn+KiOwj1dbtIgbbWAIUaLp0
	 aV4qOBsESYSP5HJXbM3Mk5+QuRShlOF1ZogGIrzY1bkquG7zxJxypVNuFh7gyMd0ECPvi
	 ap/ibYM4ByakxSo/dPT9bw+/psxVE2MarSW7uG1gtOl5HffHsmyyKK1efmP0yWaNb9pwI
	 uaxk6vXD98iZMIJyN8nzjfBhARMMbi5DCCH5vn46lHtXUtSHcEFKVkwu76rWLzVvnsINx
	 ZQmW5Jr4xNDymYy5pE9Ue6GVrG894CA0doEaK/2vG1oYEafFwouUI2HXWRGcjcbxYzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJHaq2Op;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649706070407;
	Wed,  4 Nov 2026 21:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJHaq2Op
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D675B1F00919;
	Wed,  4 Nov 2026 21:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826841;
	bh=9EaNo/GKA5J5rgjx36DcGi7oKTNOTxrJ8o15oGd0HYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJHaq2OpKdnEBEwxaEiUKAC27MafJl+x9iA3sSIlARDYoxtVML3gRr4aFlnLZN6Kz
	 j5+Dxzvg/pgRNv+Cc4TGQbFW3ekdk3RlFQKHX3cb04gtjJaA4vV7hy6WCIg4ry4jGn
	 4ZzP7GoRiBBUwlW/0CRIbqYEaftsChXuVUQOv7sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonid Ovchinnikov <teiny.work@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 039/547] io_uring: drop the CQE cache if a refill fails
Date: Wed,  4 Nov 2026 16:03:43 -0500
Message-ID: <20261104211039.440435835@linuxfoundation.org>
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

[ Upstream commit 78f9c9cffef02a290b6e97672aaa9c75df0d21da ]

->cqe_cached and ->cqe_sentinel delimit the CQ entries which can be
handed out without looking at the ring. io_get_cqe_overflow() only calls
io_cqe_cache_refill() if that range is too small. Without
IORING_SETUP_CQE_MIXED too small means empty. With it, a 32b CQE needs
two entries, and one may be left. If the refill then fails, the entry
stays in the cache, and the next 16b CQE gets it without any checks.

That CQE overtakes the 32b one, which went to the overflow list. The test
for IO_CHECK_CQ_OVERFLOW_BIT, which is there to prevent that, is part of
the refill:

  CQ ring with 4 entries, head == 0
  16b CQE, 32b CQE       tail == 3, one entry cached
  32b CQE                no room, the CQE overflows
  16b CQE                written to entry 3, ahead of the 32b CQE

Forget about the rest of the cache when it is refilled.

Fixes: e26dca67fde1 ("io_uring: add support for IORING_SETUP_CQE_MIXED")
Reported-by: Leonid Ovchinnikov <teiny.work@gmail.com>
Closes: https://lore.kernel.org/io-uring/CAECZYD5OMD9vMTzjteFMMP40Dn+SWKj9SFj=43U6uO3XMnxJbw@mail.gmail.com/
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-23-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 19f79e53c4d37..020ea9b01f986 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -735,6 +735,13 @@ bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32)
 	if (!overflow && (ctx->check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)))
 		return false;
 
+	/*
+	 * A single entry may be left if a 32b CQE is asked for. It must not be
+	 * handed out later on if this fails, as the CQE is going to overflow.
+	 */
+	ctx->cqe_cached = NULL;
+	ctx->cqe_sentinel = NULL;
+
 	/*
 	 * Post dummy CQE if a 32b CQE is needed and there's only room for a
 	 * 16b CQE before the ring wraps.
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826843;
	b=XsqiGhYf+Fzd1dfZPR97fWmm093SOH5lyT4+dKIjbNyWQRXVcn+tsHK174Lg4F0sJEoc
	 6PXJhjvzMT1i2K9ksGw9bqLc9kKEkmO07R9yk/u7ghxWiJsVVLVz/5nyrHWrQ1fewE0rD
	 tH55ugy2DAsFhdJVR0GmktJhZVDIOwhPlG9xBP26prbc3qtE27BbQ4g7D91iSuMaVqu/Q
	 oVeQZFo2fozm1uh2U1aorPMxgrZUND48psrwiUW2XlcK2QMpz0uN32ae4aRW5dQMOpiPr
	 GEDRRUxW2CRXTFAPxbM6CXq7pxSRVUybXSuFT1l+WJX3PTxGqEtJoA19ic0COjepNMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sRzXBPtYVTHuKXieW8PW9x/oitygmq53wikczjRgtPk=;
	b=k1VfeL9/PBQxXVy4705RQXr3jQwrREsXUCOIhfE8YOFJN1vZMe7Zc1WWY5knjxtfkN0P
	 tBZY8QRLTZSQmAEHT7I1dY6iVdkVwX5MWMoTZcScxgRKOm79b4yEMboZ5eKgerlI6Z8IX
	 3V0A0Dwkcb3RD4/gHG776h+q2Zq21RzzK4Zl9tFVShgeF9E9cpgCteb/EAxZXb3R+iy8c
	 IWqYEXZnrImYozNu04XzUoce0FWAUplia2NVLe+KYD3wQtddirABRe5TpEw3cOuPCWE9G
	 D8xZIZMGyMhAJ/OlwOvgoXJHMXvjD1DNrNprhk2D/8pVKj029h8Ijd8ejT/oWqzS8Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gj2GArs/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275236070410;
	Wed,  4 Nov 2026 21:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gj2GArs/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68C11F00919;
	Wed,  4 Nov 2026 21:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826843;
	bh=sRzXBPtYVTHuKXieW8PW9x/oitygmq53wikczjRgtPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gj2GArs/3GfliMflz06nqKX6UhzyAql78Nelwx3YNxkojLYTHLaGlnJVT5Lll0tTu
	 mCcnxD1yIh3dH1P2Vgg5hlz3Uo03dlTxoVtx55b5jgjk83hYAM9za+juwgJ0fJ9Uo1
	 +JGtbIpaFDZwgyuVmnzU15sdDy5pLfB8oQRveLII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 040/547] io_uring: dont split 128b SQEs at the SQPOLL cap
Date: Wed,  4 Nov 2026 16:03:44 -0500
Message-ID: <20261104211039.466374913@linuxfoundation.org>
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

[ Upstream commit 79956bb39b4d372eb146955ea159ecb6fba37f5b ]

If an SQPOLL thread serves more than one ring, __io_sq_thread() submits
no more than IORING_SQPOLL_CAP_ENTRIES_VALUE entries per ring and round,
for fairness. On a ring with IORING_SETUP_SQE_MIXED the cap may fall
between the two entries of a 128b SQE. io_init_req() finds that just one
entry is left of what it was asked to submit and fails the request with
-EINVAL, although the second entry is sitting in the SQ ring.

In the next round the second entry is taken for an SQE of its own, so on
top of the failed request the application gets whatever its payload
amounts to when it is read as an SQE.

The application has done nothing wrong, and it can't know where the cap
is going to be applied. For SQPOLL, let the request have its second entry
if the SQ ring holds it, in excess of the number of entries that were to
be submitted.

Fixes: 1cba30bf9fdd ("io_uring: add support for IORING_SETUP_SQE_MIXED")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-24-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 020ea9b01f986..9796283508b83 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1807,17 +1807,27 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		 * A 128b op on a non-128b SQ requires mixed SQE support as
 		 * well as 2 contiguous entries.
 		 */
-		if (!(ctx->flags & IORING_SETUP_SQE_MIXED) || *left < 2 ||
+		if (!(ctx->flags & IORING_SETUP_SQE_MIXED) ||
 		    (unsigned)(sqe - ctx->sq_sqes) >= ctx->sq_entries - 1)
 			return io_init_fail_req(req, -EINVAL);
+		if (*left >= 2) {
+			/*
+			 * A 128b operation on a mixed SQ uses two entries, so
+			 * we have to increment the head and cached refs, and
+			 * decrement what's left.
+			 */
+			current->io_uring->cached_refs++;
+			(*left)--;
+		} else if (!(ctx->flags & IORING_SETUP_SQPOLL) ||
+			   !__io_sqring_entries(ctx)) {
+			return io_init_fail_req(req, -EINVAL);
+		}
 		/*
-		 * A 128b operation on a mixed SQ uses two entries, so we have
-		 * to increment the head and cached refs, and decrement what's
-		 * left.
+		 * else: the SQPOLL thread caps the number of entries it submits
+		 * in one go, which is none of the application's business. Take
+		 * the 2nd entry on top.
 		 */
-		current->io_uring->cached_refs++;
 		ctx->cached_sq_head++;
-		(*left)--;
 	}
 
 	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
-- 
2.53.0




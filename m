Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207249;
	b=Pi7NMS6omaQcOhwU+uohgrGzVypfsJpzQb7CvcLVxdGIfBUmz5DZlLZg8dAMhS5Y97cX
	 VZ/NHt0W5WqTlxJ00deFHx7dfPwmlcTu2kesNDhm0Fo0LTQ3iMxK+JjS2xar0O+Fafae4
	 tbvsROHPZahFy/Cs4VTUpK2TvQZgUCVFwJE/0MSqmtCJukJEZN9VjrIarNv5JyukPA17w
	 pzzVD9fbh4ScgGuqgUIXkBIzBnmqiTGhsNysJOMqKkeaZzm68vVfSnDotER3OCf9GbKeN
	 +kRx4F6jhJxeH84vz2f98iwOeqWmULDDrh9Mr4BvvbnESI3nJ7K6E+ttJlGcswG5fsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TpynhrRuTFWsB22nzofapXjwIk7mKxUjrKxC1AhPBp4=;
	b=klmMKIXn+X2xdZLKnVL/DFoaajBKJPvWIhTh6m+aXEiEHicOIMadqDdpJFO3TAr78OGK
	 hnT9eVKk+2veFLotQrtlB/WRgGf+Lz7C09WbDIUZJ41htgd0b7Od6TD1SbB/UoJnlB2vB
	 vYCEsFhnnrwj7jfKxmSeHswyJZGNWO1QwcqwdW7monHTubXLzAQJRolJbe4UxI9lgPmnW
	 FMDMHzIBPti1kZD4EzFledTP+B39GgzR1NdpeUJutiWZ+OFsOuH/Fpd2J5zBqnNWx/692
	 tj1IUrUVvNd+v4c9g3kIFKDB4QdFcYZPSS1Mxp9oPwZZvHmmr3/TGBol1R1D2X+K35A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2mUuK6aS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758CB606A31A;
	Wed, 28 Oct 2026 17:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2mUuK6aS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FD51F01825;
	Wed, 28 Oct 2026 17:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207249;
	bh=TpynhrRuTFWsB22nzofapXjwIk7mKxUjrKxC1AhPBp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2mUuK6aS6bNIJLVGtBclbI45T50NMzfhy3BHc7+SVgc1iayF86rBlAGTdiuNwqvMd
	 EAmoXhRKHvCQlGSbN2qGjLsdJw/y9h/38iab7wkfM5Kv3VNp58Pzo3QoUHRZy/aXSE
	 s1InsbdYrAzlJDmGdR6UltL1eCybwVKEq+mtdvRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonid Ovchinnikov <teiny.work@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 39/88] io_uring: drop the CQE cache if a refill fails
Date: Wed, 28 Oct 2026 17:59:47 +0100
Message-ID: <20261028165943.031121717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit 78f9c9cffef02a290b6e97672aaa9c75df0d21da upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -739,6 +739,13 @@ bool io_cqe_cache_refill(struct io_ring_
 		return false;
 
 	/*
+	 * A single entry may be left if a 32b CQE is asked for. It must not be
+	 * handed out later on if this fails, as the CQE is going to overflow.
+	 */
+	ctx->cqe_cached = NULL;
+	ctx->cqe_sentinel = NULL;
+
+	/*
 	 * Post dummy CQE if a 32b CQE is needed and there's only room for a
 	 * 16b CQE before the ring wraps.
 	 */



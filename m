Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209748;
	b=Gm4cmB+Jm4w0axdjUfTvRij2YuIiTqS5hSZ70XPlJqQcwUrfjXi1pMOPwmHALdrnqV4A
	 c/EtoHM77i64M2kl0CpKiTsZ2CkeIuyeNGnHdEfhj6nZ3UeOPOMSEg/WdTRfKl7CBhPEA
	 MfpVFfJ6otBEwYdjxalSDhNrmQiMv8GzJqM0+JkptDS2Di9rIHLX0yhorFsK1gNEMbhCx
	 d4VAMZ5MVYFi7ckrEC6fl4gEaYK0WxlUR7F3Ll+zWHj94L6Pya6aJGiFQdcg+bkp6DCK/
	 fszxoSeO9vv/yPPQSRrmjb+QXDBbMo+y6iImoo+DnmwRmocV3K3YpUFuJ8W6EUFJOnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U8SIG8vFuGDAvhHwdGd/U9MKaOTjaDCL+pZYDtV0pyI=;
	b=z9uOEL6j14lRXozwPSuQBZz3T2Yx5HT3tD72ly5VIEe29OwsY0yVjeqxosI/yOW1USsr
	 iz/h14IBQTx5fQc+sUhD3UHp3fTazta6wrAlrH4NhdQYIXnUXYTdo5hZ8bwc67UTRf+Bg
	 eaXHztAmjCtxHQwe3W2OY1wOxzd6HgsxtI3y98elsD0ZI6hVxUE1M94Sp9eCK2opOtMyZ
	 Kuzp6CbnAXnESb4P7M78ULwwELMRvRRgMldOHqUT9+eofayNKMsaCwa9BAV4z1OWs0kK3
	 Kj9Q/HjPbP0KcDiiPOr4L9/7Jpe8LAV6zNv0Mm1ne1y1RzVNaopauuVoSylh7iG/Ayw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HhTjdRKh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2268B606A31D;
	Wed, 28 Oct 2026 17:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HhTjdRKh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B991F01825;
	Wed, 28 Oct 2026 17:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209748;
	bh=U8SIG8vFuGDAvhHwdGd/U9MKaOTjaDCL+pZYDtV0pyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HhTjdRKhoSVDGJxVRWSjbkhSwsiiiKe6xz/2jdUsKTtdqtb315AgWK312B+D6lahF
	 yAbVbwEARqOdf9R/I4zwr0y8cL5HGgEJ/vLDvF+x35U/03ALcS9WDYpd/fL3Qdo9Co
	 w1crWE/3wFJ9wwiIn4CL9HA93Z5uVAmyH3BIXW8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonid Ovchinnikov <teiny.work@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 063/109] io_uring: drop the CQE cache if a refill fails
Date: Wed, 28 Oct 2026 18:00:47 +0100
Message-ID: <20261028165943.842838733@linuxfoundation.org>
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
@@ -781,6 +781,13 @@ bool io_cqe_cache_refill(struct io_ring_
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



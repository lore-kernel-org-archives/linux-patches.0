Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207252;
	b=hUMhnzMKDwucIfwhLlO2WI9CEQzH5uTJ4C4puJ1Uygh8hn2uNh+cCS9PDZIkCB0KFi07
	 hCgoRtaQVdRT26LDby8AKvHN7CABG+6zrB57464Zv+vXAaYDwBhkEljBLqb0n/8FzCoos
	 bQ32vr+9ExXBJuWuIKhhJTAhsN8Rs8w1vVRNW3f6Q+Ut2RSa7AU/IJemapTYr7Oyfvq7v
	 VFA2qS7k65kkRYu4bgD7eYU27MDLFZmmzVWHvdwxm5JOGXY/Kofrn8JXI3Rdedm8t/QBE
	 WBLNU9uzlsqFzp0jKcv63bD/8KbOlvCf3IL2l64q38XrlgibyF4oUi1jquN4PbHLJYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cwEC5Qvfm+Vqwy828TOvFc0OY+bny5U6YER/2/9VEOU=;
	b=v/XkF6+4Ejg5RV5q2IPPjGn9WE5T7LSqGW+48tAuqDdLSTFTGALQ+44jcW5GI2kDkX7R
	 J+hJlTSf28EpbYZM3mEL4/6bCGthKNo8a4nWHmz7ZPhsulAZ+GhBxxFESKbc3KS3wmZqJ
	 +TVaCauU+DShyi+hgXd2K+wcc/Lq/U+Fxz9yK7QyZGeGDye9eBoZ4/JYXggvlDBtTl7ci
	 30EXQtEp462gAlsAq+JML0ZzPuuV6mwalWVi8R5AIMkBta7TZTcMroiaQzaEjZUgjltxd
	 otR0z9DaTlmOA6MiM5+sIrLs4SAng4wbZx1v1a3nRuTJc+GrLCb+rA9eGHWyRoEbvDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XkvQQE8f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACE0606A31C;
	Wed, 28 Oct 2026 17:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XkvQQE8f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F7B1F01825;
	Wed, 28 Oct 2026 17:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207252;
	bh=cwEC5Qvfm+Vqwy828TOvFc0OY+bny5U6YER/2/9VEOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XkvQQE8fSQvjphIqfFr7Bbj8rwGFA0XDwa/ai1FzoCD/p++pq+8w6qKz0hRn6U/1J
	 fe83GvvgOGwrPeoK153JFH2z89M4Yi6STWP/8rG/L2l9VgYophuYQIt95xlXR5eigq
	 iK/ERLk/v1l3BF0s+tiswjjvzNIs1r+UbTwYoghc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 40/88] io_uring: dont split 128b SQEs at the SQPOLL cap
Date: Wed, 28 Oct 2026 17:59:48 +0100
Message-ID: <20261028165943.053931542@linuxfoundation.org>
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

Commit 79956bb39b4d372eb146955ea159ecb6fba37f5b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1778,17 +1778,27 @@ static int io_init_req(struct io_ring_ct
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



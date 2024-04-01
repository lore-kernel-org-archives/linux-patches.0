Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A755163E;
	Mon,  1 Apr 2024 16:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989726; cv=none; b=N8QpY4j5MZFbkghO0GxfOouD7LHkBET8rn3mMQzxdoNeII3L423aQmsYmiQ/kiFLWY7bt7wnIO6dnTQ0v8DCQa6ndozunfWWqf5clEdZWyK3UNG28Ou9flwk1VJaDnXEwoozI+bUuxaCySnaDZ+ZI3KeImbvvZ5gJ6HiK4SrZ1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989726; c=relaxed/simple;
	bh=Svbv/JCjgzU+2qvJyMLiYOoZ2yfB/XB8+7QCp4IH99M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2H5n0/R7lWTjDTJw3zmXZnB1ukVwlFXXVlBdbOvUcDye7cTbOJFpzF7yp+RVeK7VtwIdnk5O63b2FFba1fSVBiv71KIl+KJpuPq8Wi9uH4WFqqiw6pNIpjAaJ9HprMZN8TVYPRy9jxZJfongK6YxsiQSXhvHLY9b/vLHhe1Iuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p6D+dzaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p6D+dzaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E61BC433C7;
	Mon,  1 Apr 2024 16:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989726;
	bh=Svbv/JCjgzU+2qvJyMLiYOoZ2yfB/XB8+7QCp4IH99M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6D+dzaM2d30IrK08FpNX0L9/uiEFoUTZRN7pCqTfyps/nt8qCbSCtJhoeZiYv+JC
	 OwXkSb1tu2IxymJ6Yf/tAxtCB1hkyTdtJftZhSC7St9a2ERCPE9HcLxsh3ohnMhJ2v
	 qAgzmRMHJBdTv2pN4k8EtLPTJ1UUX60QtKzmtC0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/396] io_uring: clean rings on NO_MMAP alloc fail
Date: Mon,  1 Apr 2024 17:43:04 +0200
Message-ID: <20240401152551.940979532@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit cef59d1ea7170ec753182302645a0191c8aa3382 ]

We make a few cancellation judgements based on ctx->rings, so let's
zero it afer deallocation for IORING_SETUP_NO_MMAP just like it's
done with the mmap case. Likely, it's not a real problem, but zeroing
is safer and better tested.

Cc: stable@vger.kernel.org
Fixes: 03d89a2de25bbc ("io_uring: support for user allocated memory for rings/sqes")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/9ff6cdf91429b8a51699c210e1f6af6ea3f8bdcf.1710255382.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index aabb367b24bc0..aed10bae50acb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2750,14 +2750,15 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 	if (!(ctx->flags & IORING_SETUP_NO_MMAP)) {
 		io_mem_free(ctx->rings);
 		io_mem_free(ctx->sq_sqes);
-		ctx->rings = NULL;
-		ctx->sq_sqes = NULL;
 	} else {
 		io_pages_free(&ctx->ring_pages, ctx->n_ring_pages);
 		ctx->n_ring_pages = 0;
 		io_pages_free(&ctx->sqe_pages, ctx->n_sqe_pages);
 		ctx->n_sqe_pages = 0;
 	}
+
+	ctx->rings = NULL;
+	ctx->sq_sqes = NULL;
 }
 
 void *io_mem_alloc(size_t size)
-- 
2.43.0




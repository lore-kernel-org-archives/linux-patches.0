Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D2F17552;
	Mon,  1 Apr 2024 15:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987012; cv=none; b=RiJwmcgIj5Cvgw9Lq1a9zwjbqyYtkEE/YF3sbHQ4GVUBFxyJSwwhPPNJvoCzdJPd+VMXrMs1NiMJSgUWQCro91tDXzBBZq6K9MC7ow7TC/qjSbbO1d801RpYK/KJZK2H9tZKtvWVmPbbx0OFXtV9POMsv4CtlbE1MPyvhGr9Ek4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987012; c=relaxed/simple;
	bh=w5J/NFQcuQLMUIpIuOJtSgy+Yl5pXM3HkBHcV1fYF10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rlaylv3A6qlqifvI+6ZCWsduSTwMtfvYky529Co+QD6LKqOafe9wsepTRMPYHEuaPXUjfg4TGs6nAqiEBB2jr+YXyLIrn7M1Xet2mcBtvk4ohNc5qon/3zWyJXB3l3tZ6djsxzMODV1mEfhqVC5zQ11CabAYa9YTJwP4SjdQYuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q51kR0x2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q51kR0x2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B36FC43390;
	Mon,  1 Apr 2024 15:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987012;
	bh=w5J/NFQcuQLMUIpIuOJtSgy+Yl5pXM3HkBHcV1fYF10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q51kR0x2ZLxvSkyyNaU++wb4+RK+RJMh4c1ELwDd1Xfw5IVqRGbBBVnR2VziMpZzJ
	 J2h4HcDsfH2pYY4UBy61H9PwyCtnFTbrLWPCoPsSR8rMHkvpy0cdC7zo2ku7+xW/uE
	 P13Y0NCCJ/ft9GXJb31nbPwWMwSIv2KGrsAU0paU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 156/399] io_uring: clean rings on NO_MMAP alloc fail
Date: Mon,  1 Apr 2024 17:42:02 +0200
Message-ID: <20240401152553.843265938@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 9f938874c5e13..adf944bb5a2fe 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2776,14 +2776,15 @@ static void io_rings_free(struct io_ring_ctx *ctx)
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




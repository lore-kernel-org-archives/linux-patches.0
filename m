Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A37319E967;
	Tue, 27 May 2025 17:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366013; cv=none; b=sLHsbVCrKOjlHg9aCZe4V2CNUNRjR2hdDfGTf3m6KUpu1ekz+3tJtL2BJZoYdTkSJzJanrr9aTrdfMM30rCwGtRwKMK24DTQtfY4GpqivRYa9THR2TqVnRYujvVFFT0AHvZiqcD1OrWeSNL7Q8UedlYCRe8+xT6xtAD7vJq9KiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366013; c=relaxed/simple;
	bh=tqngkP3nNXuqz8jInRInLJh+e1kN7gZO5t6wjYBW6qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBUcalnI9WCmcPrGdBa3HXE1Sk8/dHg9uiGiFGtLd0a9ifq4h4i6qS+nGmWS4bW4R7fb3yd6yJ5mEEU+yHGkdcnM/ChqlCMGtHz0R4RzXBpHtxyGLfvYhP4k5fEt70Nw/BQ+i2hBgLST/FGR4VLsQICisvJJmn9CyRPlNqtYK8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yTkuunTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yTkuunTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C161C4CEE9;
	Tue, 27 May 2025 17:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366013;
	bh=tqngkP3nNXuqz8jInRInLJh+e1kN7gZO5t6wjYBW6qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yTkuunTLUgKGHN7Gpf6ggcU6FjK9cK/+ahTTeRhPEf/myXTd9eF+T2+rPkyel2S4I
	 AzNkK2B71o/wyA1MFc+IMqrDTVvCLcVZosBmQ2+vg5hZyj4Jhs6bvcNbDCN7Keu68y
	 VEyPbIFgM634p7SYQpHCDuiwLOjLjGCy3sl4JWVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 562/626] io_uring: fix overflow resched cqe reordering
Date: Tue, 27 May 2025 18:27:35 +0200
Message-ID: <20250527162507.806979498@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit a7d755ed9ce9738af3db602eb29d32774a180bc7 ]

Leaving the CQ critical section in the middle of a overflow flushing
can cause cqe reordering since the cache cq pointers are reset and any
new cqe emitters that might get called in between are not going to be
forced into io_cqe_cache_refill().

Fixes: eac2ca2d682f9 ("io_uring: check if we need to reschedule during overflow flush")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/90ba817f1a458f091f355f407de1c911d2b93bbf.1747483784.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 985c87ea09a90..bd3b3f7a6f6ca 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -630,6 +630,7 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
 		 * to care for a non-real case.
 		 */
 		if (need_resched()) {
+			ctx->cqe_sentinel = ctx->cqe_cached;
 			io_cq_unlock_post(ctx);
 			mutex_unlock(&ctx->uring_lock);
 			cond_resched();
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCF01E89C;
	Tue, 27 May 2025 17:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366356; cv=none; b=Dzpi/5teRCo3CgAgYoaC/wXmvPEON7kLCIjOLhMBbLMyfiXZR4j9H9sInUK7bRIbK8na7oofb2EXXRoAcptvFnh42f7634HTU0hzFn1WjCozK45mSGRNODyvCjmhgI1K1O/KfF4vtGD/wziwFrC6/paKtD+6UO/rmINNJfOA0sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366356; c=relaxed/simple;
	bh=a7HtwN8HcgsC0J6ZcRv9W+IxeE376VTibpLP2XhU7hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOQ5c3pebPalHzDZR88NSUukwUQj8ZNEfBFKzdiS5hIKO8nf60OI9owjWEpb2/NtZsnPxsF85lpFB1hjvTrFKGXy6HCy2CXO8by9CIa2PKKRgGw4Dl1d/4RrwVVDRWXQ/GU7KzokwrBC/l3QDx7uFbKMPSCVhBub+Fp4TkSRf7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skwE2tmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skwE2tmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9A0C4CEE9;
	Tue, 27 May 2025 17:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366356;
	bh=a7HtwN8HcgsC0J6ZcRv9W+IxeE376VTibpLP2XhU7hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skwE2tmpkWxX5RfHsS5/U9hSC7ia3CyXEAY+/ATvHPsFOEiA5qvDJnrme8+35D1xg
	 A/OgHrXcGgpYNpEpzQV9WZFd+tWgZtqwT+xRdtEg1yPD43G8VJgfRxnLm7OIqhMs72
	 pmwjkD39mAIUOgOBmNNLAol2LGHXWHoy7Dh1+0GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 041/783] io_uring: dont duplicate flushing in io_req_post_cqe
Date: Tue, 27 May 2025 18:17:18 +0200
Message-ID: <20250527162514.802843164@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 5e16f1a68d28965c12b6fa227a306fef8a680f84 ]

io_req_post_cqe() sets submit_state.cq_flush so that
*flush_completions() can take care of batch commiting CQEs. Don't commit
it twice by using __io_cq_unlock_post().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/41c416660c509cee676b6cad96081274bcb459f3.1745493861.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a60cb9d30cc0d..f1c09e2b53022 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -864,10 +864,15 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	lockdep_assert(!io_wq_current_is_worker());
 	lockdep_assert_held(&ctx->uring_lock);
 
-	__io_cq_lock(ctx);
-	posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
+	if (!ctx->lockless_cq) {
+		spin_lock(&ctx->completion_lock);
+		posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
+		spin_unlock(&ctx->completion_lock);
+	} else {
+		posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
+	}
+
 	ctx->submit_state.cq_flush = true;
-	__io_cq_unlock_post(ctx);
 	return posted;
 }
 
-- 
2.39.5




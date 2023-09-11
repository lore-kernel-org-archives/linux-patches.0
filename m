Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9AF11705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BB7C433C8;
	Mon, 11 Sep 2023 14:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443415;
	bh=sY2tCPx522qtUB3LByl0b9OQzI23estZhuzoKHMwj2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xa1LtoaeL60y54UUyCKL7DIaWSTHjws7UQrc9s37UlAzuW7TS687sB8IRUiX/4FR5
	 DWWQ8PyV5PS6ZQRbkIrT33/dqQ9fYXzhycXuqoR94gkhaOIw7u4HEcL4tmmOA4nctD
	 AAMBXzUjr6nOpsXTBI6yGbjXo6emHVOeh+DAWOJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 370/737] io_uring: fix drain stalls by invalid SQE
Date: Mon, 11 Sep 2023 15:43:49 +0200
Message-ID: <20230911134700.882368429@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit cfdbaa3a291d6fd2cb4a1a70d74e63b4abc2f5ec ]

cq_extra is protected by ->completion_lock, which io_get_sqe() misses.
The bug is harmless as it doesn't happen in real life, requires invalid
SQ index array and racing with submission, and only messes up the
userspace, i.e. stall requests execution but will be cleaned up on
ring destruction.

Fixes: 15641e427070f ("io_uring: don't cache number of dropped SQEs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/66096d54651b1a60534bb2023f2947f09f50ef73.1691538547.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a57bdf336ca8a..d029e578bdfe1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2468,7 +2468,9 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	}
 
 	/* drop invalid entries */
+	spin_lock(&ctx->completion_lock);
 	ctx->cq_extra--;
+	spin_unlock(&ctx->completion_lock);
 	WRITE_ONCE(ctx->rings->sq_dropped,
 		   READ_ONCE(ctx->rings->sq_dropped) + 1);
 	return false;
-- 
2.40.1




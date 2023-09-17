Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDF57469
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45027C433C8;
	Sun, 17 Sep 2023 20:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982194;
	bh=KXOiWVbALbBLx/rXJa9NJpVUkVeBdo+XuSZXRUuu2Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JNMHNVPd6CiwZdaMM6KyOjAknbiHbBTDPX2LttBxkHQcnKhbUmIzMLhRCJX2cOOLA
	 pKiZ2KAVPS0zN3bb/XhRkrgQbvwx1AO0ip4HR6O6mhre8sMtuuOdxfq/jyiARM9t5M
	 wPvOLAbDcXHuManJ//DGjpgwKlkYMqN5Xa8QMHfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 179/511] io_uring: fix drain stalls by invalid SQE
Date: Sun, 17 Sep 2023 21:10:06 +0200
Message-ID: <20230917191118.155091875@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7c98a820c8dd0..e4de493bcff43 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -7531,7 +7531,9 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 		return &ctx->sq_sqes[head];
 
 	/* drop invalid entries */
+	spin_lock(&ctx->completion_lock);
 	ctx->cq_extra--;
+	spin_unlock(&ctx->completion_lock);
 	WRITE_ONCE(ctx->rings->sq_dropped,
 		   READ_ONCE(ctx->rings->sq_dropped) + 1);
 	return NULL;
-- 
2.40.1




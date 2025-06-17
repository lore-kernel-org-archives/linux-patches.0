Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DED2FA622;
	Tue, 17 Jun 2025 16:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179388; cv=none; b=XsZRS0w8hptzoms05KI2l9rEA8etkC4M00CPhVOvMcEj4TRfrNds1fPSzaDMf9L1R5khDxt2smIqowGEz4JBO2e514xsJZQ8gowNaI5p7ZkYVGFg06cy6PUZImlI1nMdaVzhi0+fq/nDY/zH9H4+VSS2IB6FavXRIJHXq/mNKOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179388; c=relaxed/simple;
	bh=AOEsaim+GaWkdGtqHKt9UJaboL7Udg2IlwA41nqH6J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHg7E18ONAhhcOHFepE28Z6nkT52ySShErzMgWJvZ8h6OMMaKTAfb8Sd2XCWmEX6X0S8vlYAW7kUw4T0lq18a1vfDtuMMQ6q+pYtYwbqvHbDVUxaaORWx7GCDCRpbMKLcG+Gi13oH7Fin29/GujCbBMmkr9kqD6z2Enc7cuNn7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1wtdq4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1wtdq4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AE9C4CEE3;
	Tue, 17 Jun 2025 16:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179388;
	bh=AOEsaim+GaWkdGtqHKt9UJaboL7Udg2IlwA41nqH6J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1wtdq4IoY9+nY7kcYFO2h1xhfv7NhRyn3m64HWtmS4aECPwSfuVizaOqHPjtH2cL
	 YdvTyUSmmO0TilCmQUWSJFT4US1bz/cSjI9AcKjAQWUnEQZ8ptPFHuKYBxBwDFMLla
	 lM+jZCEu/ar4VxFsc8N1igfnlPs4HiF3F2sBA0vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 730/780] io_uring: fix spurious drain flushing
Date: Tue, 17 Jun 2025 17:27:18 +0200
Message-ID: <20250617152521.224111538@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit fde04c7e2775feb0746301e0ef86a04d3598c3fe ]

io_queue_deferred() is not tolerant to spurious calls not completing
some requests. You can have an inflight drain-marked request and another
request that came after and got queued into the drain list. Now, if
io_queue_deferred() is called before the first request completes, it'll
check the 2nd req with req_need_defer(), find that there is no drain
flag set, and queue it for execution.

To make io_queue_deferred() work, it should at least check sequences for
the first request, and then we need also need to check if there is
another drain request creating another bubble.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/972bde11b7d4ef25b3f5e3fd34f80e4d2aa345b8.1746788718.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index edda31a15c6e6..9266d4f2016ad 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -537,18 +537,30 @@ void io_req_queue_iowq(struct io_kiocb *req)
 	io_req_task_work_add(req);
 }
 
+static bool io_drain_defer_seq(struct io_kiocb *req, u32 seq)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	return seq + READ_ONCE(ctx->cq_extra) != ctx->cached_cq_tail;
+}
+
 static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
 {
+	bool drain_seen = false, first = true;
+
 	spin_lock(&ctx->completion_lock);
 	while (!list_empty(&ctx->defer_list)) {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
 
-		if (req_need_defer(de->req, de->seq))
+		drain_seen |= de->req->flags & REQ_F_IO_DRAIN;
+		if ((drain_seen || first) && io_drain_defer_seq(de->req, de->seq))
 			break;
+
 		list_del_init(&de->list);
 		io_req_task_queue(de->req);
 		kfree(de);
+		first = false;
 	}
 	spin_unlock(&ctx->completion_lock);
 }
-- 
2.39.5




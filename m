Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA8E2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F08C4339B;
	Wed, 12 Apr 2023 08:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289013;
	bh=4LXR3GzVJNVTrw2a6OWBwyLQ30AyTCXqbV5i6lZaGUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nu7t6orI/fVlPe/L5seL5Px6liDNKMLNawnI0y9ZRtQq2uUVPvFZgm2RGalEKEuAW
	 Cul/+s+IAu/70CXXFTa+WVOeTyxd6pBYRb/AUcu4iw0myKXxkrgrJaj7sixZ8nLgFP
	 4F/ZiJNfxQ803vMCP1+WFAULhCYsWSkZnCbOyxsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Lukowicz <wlukowicz01@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/164] io_uring: fix memory leak when removing provided buffers
Date: Wed, 12 Apr 2023 10:33:45 +0200
Message-Id: <20230412082840.994467329@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wojciech Lukowicz <wlukowicz01@gmail.com>

[ Upstream commit b4a72c0589fdea6259720375426179888969d6a2 ]

When removing provided buffers, io_buffer structs are not being disposed
of, leading to a memory leak. They can't be freed individually, because
they are allocated in page-sized groups. They need to be added to some
free list instead, such as io_buffers_cache. All callers already hold
the lock protecting it, apart from when destroying buffers, so had to
extend the lock there.

Fixes: cc3cec8367cb ("io_uring: speedup provided buffer handling")
Signed-off-by: Wojciech Lukowicz <wlukowicz01@gmail.com>
Link: https://lore.kernel.org/r/20230401195039.404909-2-wlukowicz01@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 +-
 io_uring/kbuf.c     | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ce4969d3e20de..cc35aba1e4957 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2585,8 +2585,8 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_eventfd_unregister(ctx);
 	io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free);
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
-	mutex_unlock(&ctx->uring_lock);
 	io_destroy_buffers(ctx);
+	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
 	if (ctx->submitter_task)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 9a9db1fcdc14d..acc37e5a6d4e1 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -228,11 +228,14 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 		return i;
 	}
 
+	/* protects io_buffers_cache */
+	lockdep_assert_held(&ctx->uring_lock);
+
 	while (!list_empty(&bl->buf_list)) {
 		struct io_buffer *nxt;
 
 		nxt = list_first_entry(&bl->buf_list, struct io_buffer, list);
-		list_del(&nxt->list);
+		list_move(&nxt->list, &ctx->io_buffers_cache);
 		if (++i == nbufs)
 			return i;
 		cond_resched();
-- 
2.39.2




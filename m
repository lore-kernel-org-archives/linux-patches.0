Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E570011706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684F0C433C8;
	Mon, 11 Sep 2023 14:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444239;
	bh=Ie6itZOweboI+AkFSZB6pDUy56/MyV9RVEJbuaBYTY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQPqsMSb5taybjMYwcB4mCVXnRprz8sP3pDE5lEFMvUGr5u/GpXxA3zRPhRcQSuZ7
	 jd6HlEKGCaBT4P5DDE0AejnHL+w/NZNLldmFgLWp50bYnDWOvHN/dQsDC5z4vZ7DZ3
	 R2F4d8j+k/Gs94wnXOeIFlTkkLNBaKDePFnX+1Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.4 659/737] io_uring: fix false positive KASAN warnings
Date: Mon, 11 Sep 2023 15:48:38 +0200
Message-ID: <20230911134708.936064666@linuxfoundation.org>
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

commit 569f5308e54352a12181cc0185f848024c5443e8 upstream.

io_req_local_work_add() peeks into the work list, which can be executed
in the meanwhile. It's completely fine without KASAN as we're in an RCU
read section and it's SLAB_TYPESAFE_BY_RCU. With KASAN though it may
trigger a false positive warning because internal io_uring caches are
sanitised.

Remove sanitisation from the io_uring request cache for now.

Cc: stable@vger.kernel.org
Fixes: 8751d15426a31 ("io_uring: reduce scheduling due to tw")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/c6fbf7a82a341e66a0007c76eefd9d57f2d3ba51.1691541473.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    1 -
 io_uring/io_uring.h |    1 -
 2 files changed, 2 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -231,7 +231,6 @@ static inline void req_fail_link_node(st
 static inline void io_req_add_to_cache(struct io_kiocb *req, struct io_ring_ctx *ctx)
 {
 	wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
-	kasan_poison_object_data(req_cachep, req);
 }
 
 static __cold void io_ring_ctx_ref_free(struct percpu_ref *ref)
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -361,7 +361,6 @@ static inline struct io_kiocb *io_extrac
 	struct io_kiocb *req;
 
 	req = container_of(ctx->submit_state.free_list.next, struct io_kiocb, comp_list);
-	kasan_unpoison_object_data(req_cachep, req);
 	wq_stack_extract(&ctx->submit_state.free_list);
 	return req;
 }



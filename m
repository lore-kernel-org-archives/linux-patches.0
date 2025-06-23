Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652A33597E;
	Mon, 23 Jun 2025 22:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716456; cv=none; b=YtuC3pXZve8iMWm+ZE9RmGjsYp8le4KcgpPgnDaSapPJAVK0UGnvehI41O/pLYZ1WH7nWxPbG3W1WQ/dsxh7A6mYayk9JhDJY+SBsFNGXHG9gVIYU8n0K5OndMcS+CcxabtS0jWi30TZMugDIRuZ9f0lYoc7yXxeHm6TPXUrqPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716456; c=relaxed/simple;
	bh=s5WuLT907lH4PvpM/Ip/DULVHQafPJoiDahFO1MBKFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sw10kaTcLP3I7yjAA9zJsO29gvo/XxadaREMWTmSotQz3NoeBGbSb+YWa1pp3DmefyBUTpJNUTGVXQJ0QEL6tFVgbzujNNJhRn+cK4mVRxjOmcLgPOlvMm9cCNWHg/aeUYZ2O19JuOlgRzgWYzzl9ZWt3mJTt34XB3KLEYmjlIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTN/wv1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTN/wv1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D48C4CEEA;
	Mon, 23 Jun 2025 22:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716456;
	bh=s5WuLT907lH4PvpM/Ip/DULVHQafPJoiDahFO1MBKFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTN/wv1d8renrPvD1fbz9CrY/QtRctL7I32dvIEmwtbkll7jo6MerU3MVS8EQZK0S
	 2DeaL5D41qJb+9mv+TYRqeNlXMLRBpT7xwXBEs+FS74kGpeSSr1B6chJvUUJlXIzVv
	 gKsK6mC2WuxL8pqAQjMqXThP95hVC+BwK7UojlKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+763e12bbf004fb1062e4@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 524/592] io_uring/sqpoll: dont put task_struct on tctx setup failure
Date: Mon, 23 Jun 2025 15:08:02 +0200
Message-ID: <20250623130712.899472658@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit f2320f1dd6f6f82cb2c7aff23a12bab537bdea89 ]

A recent commit moved the error handling of sqpoll thread and tctx
failures into the thread itself, as part of fixing an issue. However, it
missed that tctx allocation may also fail, and that
io_sq_offload_create() does its own error handling for the task_struct
in that case.

Remove the manual task putting in io_sq_offload_create(), as
io_sq_thread() will notice that the tctx did not get setup and hence it
should put itself and exit.

Reported-by: syzbot+763e12bbf004fb1062e4@syzkaller.appspotmail.com
Fixes: ac0b8b327a56 ("io_uring: fix use-after-free of sq->thread in __io_uring_show_fdinfo()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/sqpoll.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 268d2fbe6160c..d3a94cd0f5e65 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -419,7 +419,6 @@ void io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 				struct io_uring_params *p)
 {
-	struct task_struct *task_to_put = NULL;
 	int ret;
 
 	/* Retain compatibility with failing for an invalid attach attempt */
@@ -498,7 +497,7 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 		rcu_assign_pointer(sqd->thread, tsk);
 		mutex_unlock(&sqd->lock);
 
-		task_to_put = get_task_struct(tsk);
+		get_task_struct(tsk);
 		ret = io_uring_alloc_task_context(tsk, ctx);
 		wake_up_new_task(tsk);
 		if (ret)
@@ -513,8 +512,6 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 	complete(&ctx->sq_data->exited);
 err:
 	io_sq_thread_finish(ctx);
-	if (task_to_put)
-		put_task_struct(task_to_put);
 	return ret;
 }
 
-- 
2.39.5




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F57A223C46;
	Thu, 12 Dec 2024 16:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021530; cv=none; b=ZnXiJjGC6jlKXKUSR5jBAPRtBlpVr8K1GctuKNjg93dtn8+tsxUZjozoyqyJHrj4zJiUBLRIviLbed7NoXK38BKrgT4hzAJ6Cq0MX21HZPth+u1tGou8bof4GdVoeT+MWt3G67pTxN/zIQRMj7Xliqo43pxq0txyYcTuT4k4cII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021530; c=relaxed/simple;
	bh=S218KWwRIopZQLsnQe70EIv2wdEwuo+1tNriL78eO9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGRKdwhR4m6kor7yVxyNPd/FOXQccjAH5l8Dh2uORa4BOiw+9FI8nXC01bPwEzMhEU9RvpUprGKPuTuxQIXiR6tK5TfUhy/O7OV8JuMjVQx6yrwE6djB6f+e43URJc734xfSqVfyOt2UAH/hhOrnNkTLrz1/wkrrtXKXEJVbRds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QAzophNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QAzophNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5461EC4CECE;
	Thu, 12 Dec 2024 16:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021529;
	bh=S218KWwRIopZQLsnQe70EIv2wdEwuo+1tNriL78eO9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QAzophNVyTDk36Nzw4HEtbM6BexgJEXAOhjVvrcxzxRsxlBgIxUnb6G1YnGk81FoY
	 p3Yd7m1gpuKF1XyZ3r41PfQhL2yGTZ2BcnCIPEP7yO6eL3fu930Ohakiu0gmx536sq
	 4kVvacmYMgsVzBj0Hp6EgufE9dwqkYi4qKmbywbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 746/772] io_uring: wake up optimisations
Date: Thu, 12 Dec 2024 16:01:31 +0100
Message-ID: <20241212144420.758026993@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 3181e22fb79910c7071e84a43af93ac89e8a7106 upstream.

Flush completions is done either from the submit syscall or by the
task_work, both are in the context of the submitter task, and when it
goes for a single threaded rings like implied by ->task_complete, there
won't be any waiters on ->cq_wait but the master task. That means that
there can be no tasks sleeping on cq_wait while we run
__io_submit_flush_completions() and so waking up can be skipped.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/60ad9768ec74435a0ddaa6eec0ffa7729474f69f.1673274244.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -582,6 +582,16 @@ static inline void __io_cq_unlock_post(s
 	io_cqring_ev_posted(ctx);
 }
 
+static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
+	__releases(ctx->completion_lock)
+{
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_commit_cqring_flush(ctx);
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+		__io_cqring_wake(ctx);
+}
+
 void io_cq_unlock_post(struct io_ring_ctx *ctx)
 {
 	__io_cq_unlock_post(ctx);
@@ -1339,7 +1349,7 @@ static void __io_submit_flush_completion
 		if (!(req->flags & REQ_F_CQE_SKIP))
 			__io_fill_cqe_req(ctx, req);
 	}
-	__io_cq_unlock_post(ctx);
+	__io_cq_unlock_post_flush(ctx);
 
 	io_free_batch_list(ctx, state->compl_reqs.first);
 	INIT_WQ_LIST(&state->compl_reqs);



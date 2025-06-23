Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595A33FD4;
	Mon, 23 Jun 2025 21:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715240; cv=none; b=enAPfnxms2WCfyRvj66LjBFw2HNk+I+FfvhfZAgHRyrLMKwBYqyXE+EXqIxxulKNV5CghDLG2zYoq+cxRzMOX9HyMregNKqbQA/ZcsTdFgZQtL/JvfnFESaE/g1mSUDuxOq5BqE+6kGGpH3xJdH10b3LslERCDowrSfD6daAlzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715240; c=relaxed/simple;
	bh=WLQ8QxJtVhEzx2lSt45gH8My0tM4BaExgMyA/yGiIfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2ra1nclu3klX8I8rA+ezatSh4TlewG2i/KcFuigjfGtR5xgf7GrzBGx/w+WP/9NEiNLU6aOUZY0VA2bC3HXNgvJGfdOlJIQBCLT75Gks8tty2B5GgXqEdwKI1uuzpIguI80ylpjQGcBEwScZaqQAQWxTwVvbIY0yfYJNaVSuio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jUJz1B9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUJz1B9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E621FC4CEEA;
	Mon, 23 Jun 2025 21:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715240;
	bh=WLQ8QxJtVhEzx2lSt45gH8My0tM4BaExgMyA/yGiIfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUJz1B9jvniqpE9kPoeJt8sH+jr6GetsVWBK6B8QiUmBT9CsKgRDpewdAHaRWol6z
	 J8XGLT2gskVLmp0ydPqtDYB2YIRJNlPwT1FxMCbHH5L+tBNzJbeOSQQLdhixb2JpqO
	 rWkctP+AFPnUrC+nSak9bITZQQx5n2gKELQsH+3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Penglei Jiang <superman.xpt@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.15 446/592] io_uring: fix task leak issue in io_wq_create()
Date: Mon, 23 Jun 2025 15:06:44 +0200
Message-ID: <20250623130711.038076423@linuxfoundation.org>
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

From: Penglei Jiang <superman.xpt@gmail.com>

commit 89465d923bda180299e69ee2800aab84ad0ba689 upstream.

Add missing put_task_struct() in the error path

Cc: stable@vger.kernel.org
Fixes: 0f8baa3c9802 ("io-wq: fully initialize wqe before calling cpuhp_state_add_instance_nocalls()")
Signed-off-by: Penglei Jiang <superman.xpt@gmail.com>
Link: https://lore.kernel.org/r/20250615163906.2367-1-superman.xpt@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1236,8 +1236,10 @@ struct io_wq *io_wq_create(unsigned boun
 	atomic_set(&wq->worker_refs, 1);
 	init_completion(&wq->worker_done);
 	ret = cpuhp_state_add_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-	if (ret)
+	if (ret) {
+		put_task_struct(wq->task);
 		goto err;
+	}
 
 	return wq;
 err:



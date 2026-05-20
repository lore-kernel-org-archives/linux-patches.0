Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E423F4DCC;
	Wed, 20 May 2026 17:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297332; cv=none; b=MFbCsFQciujYXYm8UwntMhVXOn4uFWoKa+ftMy9zG7ByL4ksIrhveKedZM+KQPUfDaJfBweLeO3PzcPWqbRpbIqE668GIx+V9B95jZYbT8WV03KzbhP1AGYNP47sGKy8Q3N0046WqKkaHwQUK3qzH1zn0mOvm/UOpoKrKPwN99I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297332; c=relaxed/simple;
	bh=gk95xzrhW1HS+n3nui6aOvQRvfmCvenr8W60NHPsOvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJRtPd7CyjtX5jiyTwqaxjwdbhPUFr7zQsAiK3eyOMO92ycsjdfj3PVwWnW0zLYx08nKdg9WydTX0Or6xw8sy4XDYY4guZQQnE01nqd/mZ/dW+JkVnrnfDIkvCvrfN/p4X9QmA8GHgcnhPX0SL5NtmBpPzsq9Oqz0ITz8Eg+lxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xu4ikFQA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xu4ikFQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396811F000E9;
	Wed, 20 May 2026 17:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297330;
	bh=AL8J+QawhwppXMlPloe8fJNk4EBfUr6aai3Th4STYDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xu4ikFQAeRBwrUFnYG/v+SXYemeOC8boB+qTqgXcJ4boPZHEm/1bi9auaOBBsDMEQ
	 FSr1uAoNlJcio+3zrNUeMzZLl3m69HhqcGJdILR/gRu50YQSn2J89ziILbEm+4/HQz
	 0fsPXewMJCkaXekTQKQx/zRuZTyF+CVYP92sobS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.0 1097/1146] io-wq: check that the predecessor is hashed in io_wq_remove_pending()
Date: Wed, 20 May 2026 18:22:27 +0200
Message-ID: <20260520162213.069088714@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Carlini <nicholas@carlini.com>

commit d6a2d7b04b5a093021a7a0e2e69e9d5237dfa8cc upstream.

io_wq_remove_pending() needs to fix up wq->hash_tail[] if the cancelled
work was the tail of its hash bucket. When doing this, it checks whether
the preceding entry in acct->work_list has the same hash value, but
never checks that the predecessor is hashed at all. io_get_work_hash()
is simply atomic_read(&work->flags) >> IO_WQ_HASH_SHIFT, and the hash
bits are never set for non-hashed work, so it returns 0. Thus, when a
hashed bucket-0 work is cancelled while a non-hashed work is its list
predecessor, the check spuriously passes and a pointer to the non-hashed
io_kiocb is stored in wq->hash_tail[0].

Because non-hashed work is dequeued via the fast path in
io_get_next_work(), which never touches hash_tail[], the stale pointer
is never cleared. Therefore, after the non-hashed io_kiocb completes and
is freed back to req_cachep, wq->hash_tail[0] is a dangling pointer. The
io_wq is per-task (tctx->io_wq) and survives ring open/close, so the
dangling pointer persists for the lifetime of the task; the next hashed
bucket-0 enqueue dereferences it in io_wq_insert_work() and
wq_list_add_after() writes through freed memory.

Add the missing io_wq_is_hashed() check so a non-hashed predecessor
never inherits a hash_tail[] slot.

Cc: stable@vger.kernel.org
Fixes: 204361a77f40 ("io-wq: fix hang after cancelling pending hashed work")
Signed-off-by: Nicholas Carlini <nicholas@carlini.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1124,7 +1124,8 @@ static inline void io_wq_remove_pending(
 	if (io_wq_is_hashed(work) && work == wq->hash_tail[hash]) {
 		if (prev)
 			prev_work = container_of(prev, struct io_wq_work, list);
-		if (prev_work && io_get_work_hash(prev_work) == hash)
+		if (prev_work && io_wq_is_hashed(prev_work) &&
+		    io_get_work_hash(prev_work) == hash)
 			wq->hash_tail[hash] = prev_work;
 		else
 			wq->hash_tail[hash] = NULL;



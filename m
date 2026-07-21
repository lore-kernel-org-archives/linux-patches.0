Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB153B6C17;
	Tue, 21 Jul 2026 22:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673217; cv=none; b=XmbUm/OsC+LAGfZDtRfUUS18HobqbQ0Rq1q7jjdnzUU8JI345ZVN2YyD4EPxuN7Oo+RyQ/0SS6l4jxTkFE+CzESItXr8C/3XclbZrn0OzvBMoDl7Szs0bsgrxyHOvZuwmhRwQtzpY0FhKR0HlYT9NBHeLBKo9H+hR3o7PhAPvZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673217; c=relaxed/simple;
	bh=GguAaybMruDdAQmw1CdK1pDFSPWijLRpBztN6zvX6ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azBQC4ZDe8RAM+T2JolNi41M9gW58ELshWR7DYc6X1gOsHd51oJc/fXXIZX5nfhw5EBQwhhpqayx6+EAKCL09oR3tGc+h1Wv1xjH1QkJ0afCzc5wbH0FKcDuUeyAduIv8nuO8mKRjIXb+HsS15qj/UKx4ZO4IAbr4FDiOVuIT48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ncsrd31; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ncsrd31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD191F000E9;
	Tue, 21 Jul 2026 22:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673216;
	bh=+zdyBdRWxJU5wqr7Jvkkch2am/z8ArrsNR2q+oAo4LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ncsrd31S8MsdshIpo7Ktb8dwNTM5hiPaQJ7OMmzSCOyF3mHcW6KMI6FI+M58UvVa
	 ACo4CONIQPgRc8d/ZH1mNIgimWSlfW8EcYmiKq7G099V1SGKeahwc3zTNyYetYzU/z
	 ZQmX7YUOjxH+f7ZBJ6hKp5MJzj1v5hb5ucY5y/3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 077/699] io_uring/io-wq: re-check IO_WQ_BIT_EXIT for each linked work item
Date: Tue, 21 Jul 2026 17:17:16 +0200
Message-ID: <20260721152357.443947327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit 29bef9934b2521f787bb15dd1985d4c0d12ae02a upstream.

commit 10dc95939817 ("io_uring/io-wq: check IO_WQ_BIT_EXIT inside work
run loop") fixed the obvious case where io_worker_handle_work() took one
exit-bit snapshot before draining pending work, but the fix stops one
level too early.

io_worker_handle_work() now re-checks IO_WQ_BIT_EXIT in its outer work
run loop, yet it still snapshots that bit once before processing a whole
dependent linked-work chain. If io_wq_exit_start() sets IO_WQ_BIT_EXIT
after the first linked item has started, the remaining linked items can
still reuse stale do_kill = false, skip IO_WQ_WORK_CANCEL, and continue
running after exit has begun.

Move the check further inside, so it covers linked items too. Note: this
is a syzbot special as it loves setting up tons of slow linked work on
weird devices like msr that take forever to read, and immediately close
the ring. Exit then takes a long time.

Fixes: 10dc95939817 ("io_uring/io-wq: check IO_WQ_BIT_EXIT inside work run loop")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Link: https://patch.msgid.link/20260527172203.2043962-1-runyu.xiao@seu.edu.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -556,7 +556,6 @@ static void io_worker_handle_work(struct
 	struct io_wq *wq = wqe->wq;
 
 	do {
-		bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 		struct io_wq_work *work;
 get_next:
 		/*
@@ -578,6 +577,7 @@ get_next:
 
 		/* handle a whole dependent link */
 		do {
+			bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 			struct io_wq_work *next_hashed, *linked;
 			unsigned int hash = io_get_work_hash(work);
 



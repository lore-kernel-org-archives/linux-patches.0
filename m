Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B2035C681;
	Tue, 21 Jul 2026 21:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668300; cv=none; b=P5aU8cLp7zc+n3mZ5PKO0gFF9imCbPlmnWWJvnJEcDcBRNVA183xEDldFO11/8tUWaXarmI0aN5c59UL2ELot8cpeLIpaiPHa1G53ndtqCWlk00lZzbRSMVPLyGyBMcbGSyAqoS4aOljCwEEo9onmOst1hQAEX3mHBQd8h9f1vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668300; c=relaxed/simple;
	bh=Sc1xCOVBvv1MC7opRjWpNQ/+rQuLDCloFlCt2c/dM80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9rNxvOzZahRub1o4AVp0+44oUZp3Z9vvKuuXbGhjt/9rPaCrnuWZhLGZeIhOM7rCY2h0zeOjdJg9F/qDBtDKeX3irKtawHbZ4OIjCIhEOmhqmQoz5YDkqiXUL/pD4gvQqzDHKMSLApiJNk3aBuS0WLQcufxjuo6RLQ9B6byCCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFKCN7e/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFKCN7e/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42211F000E9;
	Tue, 21 Jul 2026 21:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668298;
	bh=QcYwqbNgBA47MPw839KwGyg7MSUG5OxBUGRTH6gVvHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFKCN7e/eF/CCDAb6GQ1EO/OFzAQLmdBg5Jl8sHgWygPn93NJRE5Ctp5T2w2fJfGB
	 vc/mAuVZIQwNtVHGEarfMFTpRbZF4WeWSmqE5LR7P3sKBCL4BiiEOx3MJiDbH0snJZ
	 zhMk6zphsFf2X/tppjSHj9LCNJ8e1kPsretHehgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0123/1067] io_uring/io-wq: re-check IO_WQ_BIT_EXIT for each linked work item
Date: Tue, 21 Jul 2026 17:12:04 +0200
Message-ID: <20260721152427.342716277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 
 		/*
@@ -590,6 +589,7 @@ static void io_worker_handle_work(struct
 
 		/* handle a whole dependent link */
 		do {
+			bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 			struct io_wq_work *next_hashed, *linked;
 			unsigned int hash = io_get_work_hash(work);
 



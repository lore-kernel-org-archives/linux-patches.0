Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AFB400984;
	Thu, 16 Jul 2026 13:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209439; cv=none; b=JSGgLvCmPXZkuV4wHxgj3vvXSBwBhJEV1Wg2UtnidlGCHeFKotYEl69rFARsG4FVFlKWe5wI9LtBK+sNu8TdVhqpEEsqO8daHr1FepsQxbsVm0XecfdTHHkqbmC/u8h7kW707Xkfbb164NogoLWR/ZuNFHWER3AdE1RD3DjS2k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209439; c=relaxed/simple;
	bh=8Ub5g93GpZ7MbBpkyWoFKuTTox7k3s7TZYEbmvClokA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gk826OW70QUj2FharMFIPM+Ev1tsu0L8S81On0Tizx8fW+/zQUNQlyImBuNNoVx1aS7i13B4SnfGYT6/A7kuipmJnZti9311egHfcimSLOux6V87F0Q+yPUVDRLyAH5SEcyvaCMsldSYwjwf3f0N+3wFspypovelZcQ3N+o8ksc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sY+Mwn2c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sY+Mwn2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4A81F000E9;
	Thu, 16 Jul 2026 13:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209437;
	bh=pC+jg4xH6q5QD/BZAG2X8ECUjolJG69VqWZmjP5VC/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sY+Mwn2cLIFWMT9reEqvUYbsWM7phUIyx6Cc1XsO/vJ/McSNYIVgrOhGJbBr8HPak
	 N2sDyjO+H6CSjBw/0zEdIDYVpOGaXVPpBJ/2CDG5b3sejzMYiQVdMw+8O3JyI/XDzR
	 sh/d7qhR5sucZ5/MZsKrKkwfNg1cSEBG448KHAck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 185/518] io_uring/io-wq: re-check IO_WQ_BIT_EXIT for each linked work item
Date: Thu, 16 Jul 2026 15:27:33 +0200
Message-ID: <20260716133051.884406112@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -602,7 +602,6 @@ static void io_worker_handle_work(struct
 	struct io_wq *wq = worker->wq;
 
 	do {
-		bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 		struct io_wq_work *work;
 
 		/*
@@ -638,6 +637,7 @@ static void io_worker_handle_work(struct
 
 		/* handle a whole dependent link */
 		do {
+			bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 			struct io_wq_work *next_hashed, *linked;
 			unsigned int work_flags = atomic_read(&work->flags);
 			unsigned int hash = __io_wq_is_hashed(work_flags)



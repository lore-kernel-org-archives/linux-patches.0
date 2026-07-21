Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659CF42CAFB;
	Tue, 21 Jul 2026 20:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665062; cv=none; b=BbLPEwfXOy40FK4+smm6kRY0pxeaUsT6x9X0TgEFr3IUv2Rr1M56goO4iQmhoo8ZUIm5OivIj/zlI1wayzHx7OXgJBP4F9NwQPHaGCC7Uqhz/2XUxdUoyfPIPSSosGzAAnNuZG8sMoHDeorSgVQWTvizWL40BZuSslPhkdHSRV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665062; c=relaxed/simple;
	bh=/dJdXEnCD+sLHSCfp4i5r6Na8YVRqjm2VRTx9PNrDkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6N2ZdX+DYDZfayGtEgJAIJOTTYF3Mw3CWJzuvMW+Qb+dcAMDMZKBOkb3ivUZuEiV5vd3UvxwHol8f6z6feb9+EchtDgjhzhUZxlItAQCE+taM7GookAORMHwTgMszcxf43ASPPQuMxAZDNWxBOPkNFaobLRhi7rdqhK3Zp1t3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekGZTPgL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekGZTPgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC711F000E9;
	Tue, 21 Jul 2026 20:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665061;
	bh=zhHDXKMZW6BSpBgH4o+gQvU6DINg8s0WVhiwFl4djm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ekGZTPgLApkHIgMOq1zFyRcZ2PuBC6HjSER8gxSySD6TEpXTRDsKK8N+8wmMLIAtq
	 G+n8/T3qWfs8AOXFFcaIxwDU0RHot0cwBmysEPODWdo9QXyUB1H9M0tFLeTCv0XXNt
	 aT2Q5gU1LuOoxqX4DwM/KbEJCw9Lw1V+hnGTjNws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 0162/1266] io_uring/io-wq: re-check IO_WQ_BIT_EXIT for each linked work item
Date: Tue, 21 Jul 2026 17:09:59 +0200
Message-ID: <20260721152445.431131509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 	struct io_wq *wq = worker->wq;
 
 	do {
-		bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 		struct io_wq_work *work;
 
 		/*
@@ -592,6 +591,7 @@ static void io_worker_handle_work(struct
 
 		/* handle a whole dependent link */
 		do {
+			bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
 			struct io_wq_work *next_hashed, *linked;
 			unsigned int hash = io_get_work_hash(work);
 



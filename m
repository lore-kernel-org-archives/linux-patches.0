Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F77264A76;
	Tue,  8 Apr 2025 11:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111200; cv=none; b=Jo3l6hHK7s07SQlMA9kQPc/pmG1KzbIbVWKlHiYnRas4c6TFsTLO58bjYY+P+gL72xHigb6nm3trssDSzbNeLIbDVlfg33E+byhuiv9c7D3jDWvHglTnZh9DhqhUSjrDjvuvZ35V0o++Dy+yYhBQuPm+bkYfsjtTydlSu5PxJCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111200; c=relaxed/simple;
	bh=FncX6rWr1O1YN2UQsYUgUXNM0mmqeG05q99Q+NbXbRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7xxoZrCiKnXb4EjoxhcTpGLzOQVLYnRFB+9HPTUgadqi470eyWCc+YmkFRD2pkEHxFOf38W+HaSbJFtJQbiM/WdmP6ZFy8PWoKQpWS4ni8z/b9mug//vUqTIZWEQ6QFz27zSPG/ii6hyJeNRMR3X9YWvcvB7hxMhIYO6qWs6Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQwrNIUq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQwrNIUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904DDC4CEE5;
	Tue,  8 Apr 2025 11:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111200;
	bh=FncX6rWr1O1YN2UQsYUgUXNM0mmqeG05q99Q+NbXbRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQwrNIUqvhX3kBy5VxAbdpBpWXPhHKGybobS1zU0PbWyoenyfni4EXTEVjnXAFJ7W
	 sRpVDFT3aVXXOCYR1VuCZSEwfqyUQtb8TAQKZeZRfXcfJLwmRPi3nz/XintTIIWGVn
	 SCjckbNMf5GXI9wzpsMoQpE3ioAH95Q3TUrNUBVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 346/731] io_uring: fix retry handling off iowq
Date: Tue,  8 Apr 2025 12:44:03 +0200
Message-ID: <20250408104922.323568296@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 3f0cb8de56b9a5c052a9e43fa548856926059810 ]

io_req_complete_post() doesn't handle reissue and if called with a
REQ_F_REISSUE request it might post extra unexpected completions. Fix it
by pushing into flush_completion via task work.

Fixes: d803d123948fe ("io_uring/rw: handle -EAGAIN retry at IO completion time")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/badb3d7e462881e7edbfcc2be6301090b07dbe53.1742829388.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 99b83487c8158..4910ee7ac18aa 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -899,7 +899,7 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
 	 * the submitter task context, IOPOLL protects with uring_lock.
 	 */
-	if (ctx->lockless_cq) {
+	if (ctx->lockless_cq || (req->flags & REQ_F_REISSUE)) {
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
 		return;
-- 
2.39.5




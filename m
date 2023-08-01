Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13FE1F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628A4C433C8;
	Tue,  1 Aug 2023 09:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882132;
	bh=0fphWUmIAEgjndU0B0kMWIB2w+xga0t02yagN6vXelM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TkE/DaFNyR9xzup1YI0VYcO/dm63d392634c8N6iQG/GEB+L0eyycZ8MLhAKuaRUj
	 j+Z3IEaRVw0/RgO3oQizfQVOrevKqdUOhbqodxpBZRG5nygastrl/pMn2omYTCCBfq
	 pSWwHWz8cewXdGC+BfvnCkgSnGKcwOONlEgeHurc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 153/155] io_uring: treat -EAGAIN for REQ_F_NOWAIT as final for io-wq
Date: Tue,  1 Aug 2023 11:21:05 +0200
Message-ID: <20230801091915.596569349@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

commit a9be202269580ca611c6cebac90eaf1795497800 upstream.

io-wq assumes that an issue is blocking, but it may not be if the
request type has asked for a non-blocking attempt. If we get
-EAGAIN for that case, then we need to treat it as a final result
and not retry or arm poll for it.

Cc: stable@vger.kernel.org # 5.10+
Link: https://github.com/axboe/liburing/issues/897
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -7066,6 +7066,14 @@ static void io_wq_submit_work(struct io_
 			 */
 			if (ret != -EAGAIN || !(req->ctx->flags & IORING_SETUP_IOPOLL))
 				break;
+
+			/*
+			 * If REQ_F_NOWAIT is set, then don't wait or retry with
+			 * poll. -EAGAIN is final for that case.
+			 */
+			if (req->flags & REQ_F_NOWAIT)
+				break;
+
 			cond_resched();
 		} while (1);
 	}



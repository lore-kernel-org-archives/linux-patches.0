Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25835168B7
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F284C433CC;
	Wed,  9 Aug 2023 10:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578218;
	bh=2DiyHnhdOhQH1I5L4g/qb6AXmouf9vfRZJoHYHTlc0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfVPR1HWusnbNZFGNJn+xJ9F0OyOaL8tkyE7RRnJ5k+N12Se8UfyfB53+TsZcd9Kx
	 6lUwWIfWb3GWsntbF0+H3Maa3+UujR0JEmjrnEh2eTS53LI2iVKh28TCCQHL2vUIHt
	 IZvvq1ImX/DTuIBZORV73/mHbJCX/u+WYjOd4b7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.4 147/165] io_uring: annotate offset timeout races
Date: Wed,  9 Aug 2023 12:41:18 +0200
Message-ID: <20230809103647.598345210@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

commit 5498bf28d8f2bd63a46ad40f4427518615fb793f upstream.

It's racy to read ->cached_cq_tail without taking proper measures
(usually grabbing ->completion_lock) as timeout requests with CQE
offsets do, however they have never had a good semantics for from
when they start counting. Annotate racy reads with data_race().

Reported-by: syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/4de3685e185832a92a572df2be2c735d2e21a83d.1684506056.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -594,7 +594,7 @@ int io_timeout(struct io_kiocb *req, uns
 		goto add;
 	}
 
-	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	tail = data_race(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
 	timeout->target_seq = tail + off;
 
 	/* Update the last seq here in case io_flush_timeouts() hasn't.



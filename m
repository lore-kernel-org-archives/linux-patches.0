Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C890C168B7
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DE4C433C8;
	Wed,  9 Aug 2023 10:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578577;
	bh=99FFulc56JrjsOEdxJ3eqkAbwiq9JSrJY6rpjMxyMnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2GEKjDaLOZ1oitKbGha6qslQHSZOF4TxoLR521dqOyFfvi9odE3ffnHisxEj0zHA
	 4GZq/Xlsqn9n20crp+6V/RaFfiBPoSqRexk8GeN6Wur0kAmfsjHlmQiCYHN8SdcxKd
	 Xd0fgrqoSi9NZ2ElMkmCIhS9DCfbx6p1d2bS1yZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 110/127] io_uring: annotate offset timeout races
Date: Wed,  9 Aug 2023 12:41:37 +0200
Message-ID: <20230809103640.255389752@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
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
@@ -545,7 +545,7 @@ int io_timeout(struct io_kiocb *req, uns
 		goto add;
 	}
 
-	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	tail = data_race(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
 	timeout->target_seq = tail + off;
 
 	/* Update the last seq here in case io_flush_timeouts() hasn't.



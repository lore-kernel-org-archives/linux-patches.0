Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA5533EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626A5C433EF;
	Mon, 16 Jan 2023 15:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884615;
	bh=migmPbX3mMGucPDxjTgQlmZXd+HjgSoyDqtEbmZYH8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTRs3D7U5QEkkjGSqQm5u1RjTb06JOjXLZ5big6+NBNvpAJSIziG+dxAejAZ1zVdw
	 snk90CFxfHD/BVQEysP/y/Jvbie39AsX6Z/pSUC1Mlh1stzWTgBjoams44jwUVYq0F
	 LnKkjU8yH9MKVfDyZ4dPoAzg4HWTC9cl5Jp9uvAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 043/183] io_uring/fdinfo: include locked hash table in fdinfo output
Date: Mon, 16 Jan 2023 16:49:26 +0100
Message-Id: <20230116154805.202666157@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

commit ea97cbebaf861d99c3e892275147e6fca6d2c1ca upstream.

A previous commit split the hash table for polled requests into two
parts, but didn't get the fdinfo output updated. This means that it's
less useful for debugging, as we may think a given request is not pending
poll.

Fix this up by dumping the locked hash table contents too.

Fixes: 9ca9fb24d5fe ("io_uring: mutex locked poll hashing")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/fdinfo.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -170,12 +170,11 @@ static __cold void __io_uring_show_fdinf
 		xa_for_each(&ctx->personalities, index, cred)
 			io_uring_show_cred(m, index, cred);
 	}
-	if (has_lock)
-		mutex_unlock(&ctx->uring_lock);
 
 	seq_puts(m, "PollList:\n");
 	for (i = 0; i < (1U << ctx->cancel_table.hash_bits); i++) {
 		struct io_hash_bucket *hb = &ctx->cancel_table.hbs[i];
+		struct io_hash_bucket *hbl = &ctx->cancel_table_locked.hbs[i];
 		struct io_kiocb *req;
 
 		spin_lock(&hb->lock);
@@ -183,8 +182,17 @@ static __cold void __io_uring_show_fdinf
 			seq_printf(m, "  op=%d, task_works=%d\n", req->opcode,
 					task_work_pending(req->task));
 		spin_unlock(&hb->lock);
+
+		if (!has_lock)
+			continue;
+		hlist_for_each_entry(req, &hbl->list, hash_node)
+			seq_printf(m, "  op=%d, task_works=%d\n", req->opcode,
+					task_work_pending(req->task));
 	}
 
+	if (has_lock)
+		mutex_unlock(&ctx->uring_lock);
+
 	seq_puts(m, "CqOverflowList:\n");
 	spin_lock(&ctx->completion_lock);
 	list_for_each_entry(ocqe, &ctx->cq_overflow_list, list) {



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5403D7A07;
	Tue, 25 Aug 2026 13:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664576; cv=none; b=KnsumWZO6fq0i1Nwtha+wEqbnKMJvXcCnHVTJLT6KedlrOWCDea74jb786IBuzHmXgblh/wu/lxnDb0LhTnv/hcIZLylbhKkwuv9vKC8IDsGIUI5SyuaRpeFAGhMTmo0HiLbBtcs4hZRNruIRX8F5qV4xTDCQsDf5l66PToHPpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664576; c=relaxed/simple;
	bh=vtP5hlMoKTgpBMotQF7xjPoPHduwrqy0CMXirAiFjps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+xIx4FePZYbNbWYkjRH8Zq/M5ODZysJpaEHUhXkSP0hWMmy+csjx+BTqLIRt0lahz2Igrr7qkHMfoUiR+Jzix6Ocdjc6NC34K3SQgfyTRqWKK6ZGK4doiR81gWc4necsRF9Ni93TCTNK3sJmV8Pvi8COGkaNnkPVpP09dnetW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H62UsKED; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H62UsKED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703E91F000E9;
	Tue, 25 Aug 2026 13:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664575;
	bh=jjFNufQeXwPRcPMgaAXg8+MykDzrO2wHD3j6uwOjKmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H62UsKED6TB8lVKbpgsyXAGWG3PZN0d0RK5dgMC51b2IZ15znpO0riMTQUMDTND4a
	 dViWU+jWH43XttMuGgs1VArJtFIKhI22D++gJFVM484zBp0H1y9BtpNHJe3YAL6/2M
	 uhGiYx89+N1QQMLdIZzWOUJBHe/3eSpdO6pheKyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Woraphat Khiaodaeng <worapat.kd2@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 17/82] io_uring/cmd: fix iovec leak when the async cmd is not recycled
Date: Tue, 25 Aug 2026 15:25:04 +0200
Message-ID: <20260825132542.202678347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Woraphat Khiaodaeng <worapat.kd2@gmail.com>

commit bb34ae5da3365699d53a756f4c96b6ea9f8ba0c1 upstream.

An io_async_cmd carries an iovec array in ->vec.iovec, allocated when the
vec has to grow and kept across recycling through ctx->cmd_cache.  On two
paths nothing frees it and io_clean_op()'s kfree(req->async_data) drops
the io_async_cmd without it.

io_req_uring_cleanup() clears the async data flags only when
io_alloc_cache_put() succeeds, and the cache holds IO_ALLOC_CACHE_MAX ==
128 entries, so once it is full the put fails and the vec is left behind.
An NVMe passthrough workload gets there without doing anything unusual:
nvme_uring_cmd_io() returns -EIOCBQUEUED, so the io_async_cmd stays
attached for the lifetime of the command and the live object count tracks
the queue depth.  Above 128 the puts start failing.

->cleanup is the last chance to free an inherited vec, since
io_req_uring_cleanup() returns early for an io-wq issued command and is
not called at all for one completed without ever being issued.  But
io_clean_op() calls ->cleanup only if REQ_F_NEED_CLEANUP is set, and for
uring_cmd that happens only where the vec has to grow, so a command
reusing a large enough cached vec never sets it.  io_rw_alloc_async() and
io_msg_alloc_async() flag an inherited vec for exactly this reason;
io_uring_cmd_prep() does not.

Flag an inherited vec in io_uring_cmd_prep(), and free the vec when the
cache put fails, as io_req_rw_cleanup() does.

The leak is invisible under KASAN, where io_alloc_cache_vec_kasan() frees
the vec unconditionally.

Fixes: 3a4689ac109f ("io_uring/cmd: add iovec cache for commands")
Cc: stable@vger.kernel.org
Signed-off-by: Woraphat Khiaodaeng <worapat.kd2@gmail.com>
Link: https://patch.msgid.link/20260802073518.419-1-worapat.kd2@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/uring_cmd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -38,6 +38,8 @@ static void io_req_uring_cleanup(struct
 	if (io_alloc_cache_put(&req->ctx->cmd_cache, ac)) {
 		ioucmd->sqe = NULL;
 		io_req_async_data_clear(req, REQ_F_NEED_CLEANUP);
+	} else {
+		io_vec_free(&ac->vec);
 	}
 }
 
@@ -208,6 +210,8 @@ int io_uring_cmd_prep(struct io_kiocb *r
 	ac = io_uring_alloc_async_data(&req->ctx->cmd_cache, req);
 	if (!ac)
 		return -ENOMEM;
+	if (ac->vec.iovec)
+		req->flags |= REQ_F_NEED_CLEANUP;
 	ioucmd->sqe = sqe;
 	return 0;
 }



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDAE33A70A;
	Tue, 25 Aug 2026 13:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664820; cv=none; b=eirBJL49LHl54DWtoPhocLbk2lrlWdTsGw+VXEKKlXODvJG/EgyCCnUUpuat4e6jWssjZBVkyanj9HQgoDO8tlgKvbzT68krLdud9eqBYa3vQNPBAiRwuaxMkuEQmSJObZEdZMfgyYoVv4iFdcNGfrLJ+siVb3K9nJOfV2wFO0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664820; c=relaxed/simple;
	bh=hSfNMIb/WjlTtOw8wi9azcfFUohfHwJvvvgz4NmUmdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ei989WMtCalcsiSzEBi6f/JPYa8QAQSNL5qVpj6ROWCWs9MgNWcqLFFUk76fUy9tOkVx5gSqTDRlgkUMFSzALG6l0i5m1f/ZZvNrtwGPrg46WMYb4VjEi3XABQ2Kz9MoWrtkPY8jGK4ilt8WOVFg1uVavFECvj/2smt3lPiDHCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhzoUdc8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhzoUdc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D251F000E9;
	Tue, 25 Aug 2026 13:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664819;
	bh=3uDUkm6JSDiWtC6J4LrDb0mlOm3OZyLtXXL4cLCi3K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RhzoUdc8W2rh2Xquw7QI8BLI5ateCF4auWAqb/HmzT/3guaQvd4UzFxJX7RYlWv5X
	 hq2J+7xL5GSfjFx5a/qnep+usLzMzDdtmjNTTlehAXTEEjiYWltztAYKf28cV17p5t
	 PY0JsZ2T0jNNJyJXbGOD3ScIsEHYXCCGHXSnXqcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Woraphat Khiaodaeng <worapat.kd2@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 016/101] io_uring/cmd: fix iovec leak when the async cmd is not recycled
Date: Tue, 25 Aug 2026 15:24:54 +0200
Message-ID: <20260825132542.634257116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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



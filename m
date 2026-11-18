Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059955;
	b=ihYJ+4jo3tE2ACEVTyl22oNXEAn07vmnGbzhlqpNglqt8cbZlfA+3PMSUyWav5BqKefS
	 w0pcGsuQSqpuoAQugjkvGQzGhe6xldJqLBvmVf7urqxT08vl7czuw07GAr/4jvABKPT3l
	 EtVgQkyUbpqew9IJFCfH6x4jWKMBoeNvlW4/UcP8gzOLT8VD9e+lxMbkN18IC7r5T++uC
	 GN7YZ5gRlyeNVEV5s6CXM1p0jWm3yNB4lNECmkV5nyUpB2B/RgwtwmTrp2aU7go2XbN+u
	 kk8d5RQgVBtYT4ZMDRbnsBa+1xaMwDtnZ92mKk/b4jg38L2Ilu84h1BP/mOcVahnktg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T5+/DoRK4E9bNCkCwTGjsVHoBe8V56wt31gMhZUcIb8=;
	b=k9e3FLSVVDj3oTe5tvE02mKK5nJLyzgF1AEUr8pHRlaqk3aoPLmltmOdRxb4ZI341mlQ
	 WVGzVYDciKgl1EdASS94XP764yeWD/RlI+tpwBXAHUgwQzPCo3ynhsfrop96tWh38vaDV
	 XFY0/ae82bboD6Ddti85Faeebomhh/bcWxXf9zdd1fVlPQAR+ypGDQlvmsUO3dMwuZ4DX
	 jgNM068xk/AJd3hXzZwKIRG7gqMPQVAop9sWzUBOEGURTeADxuen5sipvqrTRBM/JhPLH
	 ZpkAjW4dPECcm0K51ZlvsrxcWujQvBZ2cKgbxffmK1mGN6trNCH1qtSu4NjAr8GBx8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xgGpcDhP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F6C60A260E;
	Thu, 19 Nov 2026 03:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xgGpcDhP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4E51F000C4;
	Thu, 19 Nov 2026 03:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059954;
	bh=T5+/DoRK4E9bNCkCwTGjsVHoBe8V56wt31gMhZUcIb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xgGpcDhP/O1/wcp2+uNSMSyoLdIH3MAjz8NUUoe+QM8CRPmufRSw5+ej/yhrMoAK8
	 4G8av7IbNhVJNP/gh6pXC+TADytJK3QnUg/daJ3vFcBeIZbvym+f2M3O3hPE+F7vcL
	 V8j0H27zdbhGkfD4/WCYUnkKTBtME4VCBMlGUVTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1027/1848] io_uring/timeout: count cancelled timeouts in cq_timeouts
Date: Wed, 18 Nov 2026 15:51:05 +0100
Message-ID: <20261118150000.298744448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Yongkang <teel4res@gmail.com>

[ Upstream commit 1c8b49851543f41fc8bb18bcd1f15cc93d14b530 ]

io_timeout_cancel() posts the cancelled timeout's -ECANCELED CQE without
advancing ctx->cq_timeouts.  io_timeout_fn() and io_kill_timeout()
advance it for every timeout CQE they post, and io_flush_timeouts()
computes the number of non-timeout completions as

    seq = cached_cq_tail - cq_timeouts

to compare against each off timeout's target_seq.  The cancelled
timeout's CQE is therefore counted as a regular completion, so every
cancellation makes an already armed off timeout fire one completion
early.

A ring with a keep-alive timeout of off=4 completes it after two NOPs
when one off=100 victim is cancelled through IORING_OP_ASYNC_CANCEL, and
before any NOP when two victims are cancelled.  The cancel CQE should
count, but the cancelled timeouts' -ECANCELED CQEs must not: the
expected counts are three and two NOPs respectively.

Advance cq_timeouts when io_timeout_extract() succeeds, under
timeout_lock and before the -ECANCELED completion is queued, matching
io_timeout_fn() and io_kill_timeout().  The -ENOENT and -EALREADY paths
post no new timeout CQE and keep their accounting.  Both the
ASYNC_CANCEL and the TIMEOUT_REMOVE path go through io_timeout_cancel().

Fixes: bfe68a221905 ("io_uring: off timeouts based only on completions")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Link: https://patch.msgid.link/179328314078.648427.13761781546953594668@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ sashal: placed the cq_timeouts increment after the existing IS_ERR(req) early return in io_timeout_cancel() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e2e04a381315f..4926dd03e3fd8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -6117,6 +6117,8 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
+	atomic_set(&ctx->cq_timeouts,
+		   atomic_read(&ctx->cq_timeouts) + 1);
 	req_set_fail(req);
 	io_fill_cqe_req(req, -ECANCELED, 0);
 	io_put_req_deferred(req);
-- 
2.53.0




Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829232;
	b=Ma5QMYggc393JDvsY8T+rJWR1c3b4ZgJnTxrU9aJ9eeHA3/WW2cFmBzH57wfmad25aWE
	 N2Dj7/WbKl30OKci/2xTvn42cTsECjOUN5BXtUaxk7Qie7s2w2AIDyRHKB41a060yzNmf
	 MDZHVBLH++A+m22TA84qXPfhc0Oq0z2xmqEokhq9Px5CWl9RGxZqLIchh+/fC17qhk8Kc
	 zRXDhGkz1FAfcMYUKcmsUxPdnJKxKHYP3n09oF8oqL+bTMANDpMgo4HaVI9Nb/CvesWnw
	 a214suLyZj2KC46MSBycdNimcKTHV3bhOhgxhiQAhthyZM1DeG9YWr+uY4uKY/07fBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HhFjkQRUfnY3NGJ8i//npbyVzhZ83XJxx64G5t29OOQ=;
	b=fHU4Po/pkpkdoAAWoD96Nr/DN2rGgKgKvAbVkCIXvcjpzXQyNF1mk2cXDMLZThx2feEA
	 BWsjm1LTBwglT7cDJVe5eAmR72mq5D5nJBJ49KZnQ2vAYJTAl2VkBrXC3IXvm2cIGQVIY
	 1NbGDPi8e/uRT2XWv3Hf0SF9XC291xBtAnXtBNxSbmf+rx0yyieyzezfSgDYYi9N+QvYA
	 P1Zfb7na0cdut+uQbQrkE/c7vFuQZjl7LN6lKHjg+n6gVTXUc/30xljJ7mOWzQh90pgw0
	 /pGLTnQ49ubQuQl+/YmvEm5OoLOHDWzwS90g4S4DeIpNBS08+QCR4m75P+93CSGgDNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=00k6KdHl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587DF606D80D;
	Wed,  4 Nov 2026 21:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=00k6KdHl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDE51F00919;
	Wed,  4 Nov 2026 21:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829232;
	bh=HhFjkQRUfnY3NGJ8i//npbyVzhZ83XJxx64G5t29OOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=00k6KdHlfRHHObCBL+41xlTJKeMnt+58yDdvaFtV8sbYhn9xj6cyhReVF0XXL0q0g
	 rPUfhI2khc4QZmXnXb2Mgv4im37dFnXa3uBMpE5fJaeq5n4koo2mVtYyiA8JOYZtP7
	 n2xA6E3wT5Zlkdx28oZoT7Htlp3XjsdWkQ0VkVhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Yongkang <teel4res@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 532/547] io_uring/timeout: count cancelled timeouts in cq_timeouts
Date: Wed,  4 Nov 2026 16:11:56 -0500
Message-ID: <20261104211053.507841266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Yongkang <teel4res@gmail.com>

Commit 1c8b49851543f41fc8bb18bcd1f15cc93d14b530 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/timeout.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -370,6 +370,9 @@ int io_timeout_cancel(struct io_ring_ctx
 
 	raw_spin_lock_irq(&ctx->timeout_lock);
 	req = io_timeout_extract(ctx, cd);
+	if (!IS_ERR(req))
+		atomic_set(&ctx->cq_timeouts,
+			   atomic_read(&ctx->cq_timeouts) + 1);
 	raw_spin_unlock_irq(&ctx->timeout_lock);
 
 	if (IS_ERR(req))



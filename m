Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24581A76B2;
	Tue, 30 Jul 2024 17:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360195; cv=none; b=Nx9Zl0Ki/A5cgnQKchy9thVqq6MENLWfZfq6Qk512ooanD2sHX4xLCsiJA6FO74CU8Q7B0lUTm6+/Jd0UtcwSlS7kaDyIC/wXmuzmtkVJkFL2ltHMi4qZtRNBILGmtXGtRvES6INfc/FUBmg6pPU7bJ0uP1mKMKXXVxgKB3uISg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360195; c=relaxed/simple;
	bh=0j9m+tp3qNEd13qkW6eTpPj19NK56NSApdQb16iReS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSTvK4TnR9INSVlLsSxLsqF3EAVcX+9bm7QEzGoS1rfvvZrrHMndN3n/MljJebTcVnGLompXYckGmXnJXyveZoiuDzR3cxT4s8x5U2hwDZNtHFTdwOlGkpIuDVhu8IGsxd25bGOhL1hSXpZ0AV73KbYV567stxvb5q9tjMWoqIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJk18E4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJk18E4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A82C32782;
	Tue, 30 Jul 2024 17:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360194;
	bh=0j9m+tp3qNEd13qkW6eTpPj19NK56NSApdQb16iReS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJk18E4S5I9zmfamFPDhglqDasDE/nipm1sFj2cFMqS/y9qxleZTX3Iz+qL+GfK7E
	 2hq0W8cZa1t0yfvvXwfqObbf9JjPmnMr67cB21yHiIZEtGR7NJ+oo4ulo+wRt/+MbH
	 A1INjm7gPGPQi81qpFoTQyyYwNUWMJ7QREkXmC5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.10 594/809] io_uring: fix lost getsockopt completions
Date: Tue, 30 Jul 2024 17:47:50 +0200
Message-ID: <20240730151748.292162928@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 24dce1c538a7ceac43f2f97aae8dfd4bb93ea9b9 upstream.

There is a report that iowq executed getsockopt never completes. The
reason being that io_uring_cmd_sock() can return a positive result, and
io_uring_cmd() propagates it back to core io_uring, instead of IOU_OK.
In case of io_wq_submit_work(), the request will be dropped without
completing it.

The offending code was introduced by a hack in
a9c3eda7eada9 ("io_uring: fix submission-failure handling for uring-cmd"),
however it was fine until getsockopt was introduced and started
returning positive results.

The right solution is to always return IOU_OK, since
e0b23d9953b0c ("io_uring: optimise ltimeout for inline execution"),
we should be able to do it without problems, however for the sake of
backporting and minimising side effects, let's keep returning negative
return codes and otherwise do IOU_OK.

Link: https://github.com/axboe/liburing/issues/1181
Cc: stable@vger.kernel.org
Fixes: 8e9fad0e70b7b ("io_uring: Add io_uring command support for sockets")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/r/ff349cf0654018189b6077e85feed935f0f8839e.1721149870.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/uring_cmd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -265,7 +265,7 @@ int io_uring_cmd(struct io_kiocb *req, u
 		req_set_fail(req);
 	io_req_uring_cleanup(req, issue_flags);
 	io_req_set_res(req, ret, 0);
-	return ret;
+	return ret < 0 ? ret : IOU_OK;
 }
 
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,



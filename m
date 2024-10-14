Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A53481B3;
	Mon, 14 Oct 2024 15:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919516; cv=none; b=Vccq0qeYr3O0eWxdfKu8nfiZS/WYEocWvbsnahGLRV/tFyKVcIknucXUFkTsrQF1q/20Kymsabt3xWjqKmixR6S63JzfPRYPF24x3z9JPY/0iqyP16ToiktiuGrkMMty+dM/fbvi0MttfUOqh3rdnKu6gixzuV5arkokONI0lGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919516; c=relaxed/simple;
	bh=9jOuBQ++1+doAV/Mr1a9tM30w1ctlCQNuLNgMrfwifU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEz0N/yozHNygaS5wrOB06Hur+zngx9gxHEadtuuhyiG/CDs/uRm4qxEvF6bD0JI7Rom5s6z8kt+EmG5tlxjW/++fKwGrBf87uVHWgqI11ihkV6ZIYLDHRFuWLiinHWVZMmYcRSZ+/yrjanFWEmcY24ukgbM5CxPobAFfLU+Y28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2C+Rprj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2C+Rprj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E37C4CEC7;
	Mon, 14 Oct 2024 15:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919516;
	bh=9jOuBQ++1+doAV/Mr1a9tM30w1ctlCQNuLNgMrfwifU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2C+RprjXluMNVUmD8i0Negtbq6OMwRiaooL5elGRPFLi9aRfWLsFGjv8yWBJFOMK
	 PpT3/WUIUPCuTyCucc5eD+PDyR4B3uKkHxlkxOmXIfaNFKERK/jSJ/UNEOhsVzAGGd
	 sr9p0BMc0yUQWTBQuyiJo2LigBTGXd/hL3dHBLpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 627/798] io_uring/net: harden multishot termination case for recv
Date: Mon, 14 Oct 2024 16:19:41 +0200
Message-ID: <20241014141242.670112178@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit c314094cb4cfa6fc5a17f4881ead2dfebfa717a7 ]

If the recv returns zero, or an error, then it doesn't matter if more
data has already been received for this buffer. A condition like that
should terminate the multishot receive. Rather than pass in the
collected return value, pass in whether to terminate or keep the recv
going separately.

Note that this isn't a bug right now, as the only way to get there is
via setting MSG_WAITALL with multishot receive. And if an application
does that, then -EINVAL is returned anyway. But it seems like an easy
bug to introduce, so let's make it a bit more explicit.

Link: https://github.com/axboe/liburing/issues/1246
Cc: stable@vger.kernel.org
Fixes: b3fdea6ecb55 ("io_uring: multishot recv")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/net.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 48404bd330017..f41acabf7b4a5 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -893,6 +893,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	size_t len = sr->len;
+	bool mshot_finished;
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
@@ -957,6 +958,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	}
 
+	mshot_finished = ret <= 0;
 	if (ret > 0)
 		ret += sr->done_io;
 	else if (sr->done_io)
@@ -968,7 +970,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (msg.msg_inq)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
-	if (!io_recv_finish(req, &ret, cflags, ret <= 0, issue_flags))
+	if (!io_recv_finish(req, &ret, cflags, mshot_finished, issue_flags))
 		goto retry_multishot;
 
 	return ret;
-- 
2.43.0




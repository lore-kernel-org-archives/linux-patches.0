Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C46395AE2;
	Sat, 30 May 2026 16:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159955; cv=none; b=BokGVWLVcsZrAyPafBhf6Ui2U4ebFMi42PVpCOB69Dli8mZ8Dwnr7noJKV+d+vfArb0nqoEEa5d8OSSbHiZMFGdOY+/tS4Vb+XrbwDaSJGKC0jHTafzZeOLfFQ5blAIv0cINaNNlR6Nesfoi7M0oghbqv2dO3HARJ6KlwwBwQWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159955; c=relaxed/simple;
	bh=YtGnqfCs9aJXvYFVFzr5blna7/gM+CTr7DczFf3VKEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFHf0nsyRAlKl4XOrRF95l/NCLQk4g2zVpk1JGan1YJEbYvafkYBFJj7LwvXoZ0CQzHDR8GwlvCmeSYGqixFES5gxB9h+yBA6DqvM9Ncc4yDy6aC6jfg6ve/nJCDJEXHIb6P/RvpRcCXDRwEqvru+gHqGNPslsI3WDvLe+YYr30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SAxw++Vz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SAxw++Vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4A91F00899;
	Sat, 30 May 2026 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159953;
	bh=2XmM8NLOc5/UYy5/87B6Qi9daJ8Ft0xl5zhrffonvfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAxw++Vza55bwrMN7FoUUpK3FtRHzRbAy3TqwjTvoRfgEtJ/dnC12Ztz2GxvMDtSH
	 HcvKXjBcX82zpmz+YjI2Y9rI6+rpulvTZ6aTp3BFo9ose38clM3CDUwUPL7SE6y8zf
	 QBjJvdXfvml74WiQ8F9r0+U9z1y8eetwVSOUwvS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Longxuan Yu <ylong030@ucr.edu>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 206/969] io_uring/poll: fix signed comparison in io_poll_get_ownership()
Date: Sat, 30 May 2026 17:55:30 +0200
Message-ID: <20260530160306.162794621@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longxuan Yu <ylong030@ucr.edu>

commit 326941b22806cbf2df1fbfe902b7908b368cce42 upstream.

io_poll_get_ownership() uses a signed comparison to check whether
poll_refs has reached the threshold for the slowpath:

    if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))

atomic_read() returns int (signed). When IO_POLL_CANCEL_FLAG
(BIT(31)) is set in poll_refs, the value becomes negative in
signed arithmetic, so the >= 128 comparison always evaluates to
false and the slowpath is never taken.

Fix this by casting the atomic_read() result to unsigned int
before the comparison, so that the cancel flag is treated as a
large positive value and correctly triggers the slowpath.

Fixes: a26a35e9019f ("io_uring: make poll refs more robust")
Cc: stable@vger.kernel.org
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Longxuan Yu <ylong030@ucr.edu>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://patch.msgid.link/3a3508b08bcd7f1bc3beff848ae6e1d73d355043.1775965597.git.ylong030@ucr.edu
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -88,7 +88,7 @@ static bool io_poll_get_ownership_slowpa
  */
 static inline bool io_poll_get_ownership(struct io_kiocb *req)
 {
-	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
+	if (unlikely((unsigned int)atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
 		return io_poll_get_ownership_slowpath(req);
 	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
 }



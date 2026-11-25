Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620858;
	b=wNNTaC+2zq3vlLp5fV/qQ3QNjaDo1EW6zybU97pGAkPEGSR9EqgoRRgAtvDS5901GiD8
	 b3m9mj7tOG+0KCdYpK6AKK6PrHgL2n/zZ7HX+/ujHBqhfGMoJwViyKUB5NSpRQ5ZMQS46
	 n+SbNtsgzymNSEthzcpp76nmggzCMjlReAUTHR4pDF9PZzIY2VHjzHz4K5vxqDYR0xVkE
	 /aBwYukjpV+jjyx57CiKf/DsKXyA2/JSqsJjrjYuukRV4j6xmez/cHSlwEl4wR98Q/AKl
	 ST7+SH8oMcxxwX3UUrj1IJf+QfkLISbZ2+grPZh93YOHDf+1exxs9gQiuhh1zVjEygw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qdYTQUONhoQmWnMGCA3YRpFracoBhM6VwEFxnAy2fQg=;
	b=Wd7LGFmYQMDTpWgC2YicQ1mHnTBaIbQmQxg1aFXEuHkWF2IOqvTy0teFewXU0Nr7ZJSq
	 RcUN+UEN9sYwxrCxTSnqOkftCFJV0rRoamNfaCTnNFbobZGLQIm9CZu0uX1X1I2tx6yY2
	 323phWHICrgkgsY7+Eq36WznzaNUeJOapG6vbAQ4foctesc8ojjtQ00cH2aE6EwEWns9V
	 fWhoAbwGhb+E45nyHgt6prsQSo16jB38xyopliqH6M9hKpGu0M7GweF8nrx1ly9da392p
	 dTNZSlTqjRmVV+FJGYoTXm194zDyfreb4BciXFMWC1gO0Or4XAfvw6h2cYe8dqIeDKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGzcTejg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EFD606A326;
	Wed, 25 Nov 2026 15:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vGzcTejg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD4B1F000C6;
	Wed, 25 Nov 2026 15:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620857;
	bh=qdYTQUONhoQmWnMGCA3YRpFracoBhM6VwEFxnAy2fQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGzcTejgO522zulM36OZ8gMt47cog+TVIAp3tWwJJRmvKusyTRcKBw2khwZuhbbJ/
	 SHnM3NfSYHuP+hxdNG4SAnb37YJaNcU8ulBbl+pfwm2hd6tTM1F5yceJQ3SU2wE339
	 iCMewfLethbsdFP8gttLDqVCQueYIAS9bqD1JfyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/990] io_uring: fail soft links on negative IOU_COMPLETE results
Date: Wed, 25 Nov 2026 15:23:31 +0100
Message-ID: <20261125143823.124347092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

Commit 9ed19503a7b34e1ffb2b81236843204c473b0ae0 upstream.

Handlers such as fsync return IOU_COMPLETE with a negative cqe.res.
The old io_req_complete() path called req_set_fail() for res < 0.
After completions moved into the core, that check was dropped,
so IOSQE_IO_LINK dependents kept running after the head failed.

Fixes: 97b388d70b53 ("io_uring: handle completions in the core")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Link: https://patch.msgid.link/20261114041123.109163-1-yangxiuwei@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4a9f3a0fe5062..df5f33a0f937b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1971,9 +1971,11 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	ret = __io_issue_sqe(req, issue_flags, def);
 
 	if (ret == IOU_COMPLETE) {
-		/* not all handlers take care of the internal restart codes */
-		if (unlikely(req->cqe.res <= -ERESTARTSYS))
-			req->cqe.res = io_fixup_restart_res(req->cqe.res);
+		if (unlikely(req->cqe.res < 0)) {
+			if (req->cqe.res <= -ERESTARTSYS)
+				req->cqe.res = io_fixup_restart_res(req->cqe.res);
+			req_set_fail(req);
+		}
 		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
 			io_req_complete_defer(req);
 		else
-- 
2.53.0




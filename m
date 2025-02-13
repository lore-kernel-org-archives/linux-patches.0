Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C0C26B087;
	Thu, 13 Feb 2025 15:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460835; cv=none; b=Jwxi/162+kb4W8zOQWGc6WfzGlHgFHHjnkc0oGz6Od0OUKaGJ2gbWlttcTocPcdYM1I2VIjxb/9CphQvRAlGBgrOjLJjX1h7tFM7vsiymZCXfBmPEAhqiEq06dbJCQxpa8EzbI/STVQrq7sGodG20OZE8jzG5+zBkXyIio2o+2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460835; c=relaxed/simple;
	bh=2Wa+WV9odI9cjdzggh2es6O1KtkCKcIqmxWFw0INmYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GH4hERLusD+2Oxfb82AKqXP7QRLRY5gCv+pLdWDcjij+knahDlQiwuKXbnmdQ7katQudWqEWaVJ/i1erjRFVcNhDjtvV+mStpcGIecdYobX6C6Qyd+nArAxlHFEQ2lfDIkVZ1GecU3xwPUxWYQVpmp98Ua9dInITqJjQoBEIAms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTM2eTlS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTM2eTlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470F4C4CED1;
	Thu, 13 Feb 2025 15:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460835;
	bh=2Wa+WV9odI9cjdzggh2es6O1KtkCKcIqmxWFw0INmYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTM2eTlSnWWQHAg9eaYeS4wXLLRgrQaTcwV852+N8k7Lx3FI5U3DJoOHc+2iu6pWE
	 xeF76get5bc+Vuar+0dt+BoPelU4fYRjYL0/MyGce7QIEc3Qn7YiPdErV1kQXC3Fp2
	 lPFyk8eV47H4DsHA4ZrveyD0syvDXEEWu3WQlnds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Jacob Soo <jacob.soo@starlabs.sg>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 226/273] io_uring: fix multishots with selected buffers
Date: Thu, 13 Feb 2025 15:29:58 +0100
Message-ID: <20250213142416.243802858@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit d63b0e8a628e62ca85a0f7915230186bb92f8bb4 upstream.

We do io_kbuf_recycle() when arming a poll but every iteration of a
multishot can grab more buffers, which is why we need to flush the kbuf
ring state before continuing with waiting.

Cc: stable@vger.kernel.org
Fixes: b3fdea6ecb55c ("io_uring: multishot recv")
Reported-by: Muhammad Ramdhan <ramdhan@starlabs.sg>
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Reported-by: Jacob Soo <jacob.soo@starlabs.sg>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1bfc9990fe435f1fc6152ca9efeba5eb3e68339c.1738025570.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -350,8 +350,10 @@ void io_poll_task_func(struct io_kiocb *
 
 	ret = io_poll_check_events(req, ts);
 	if (ret == IOU_POLL_NO_ACTION) {
+		io_kbuf_recycle(req, 0);
 		return;
 	} else if (ret == IOU_POLL_REQUEUE) {
+		io_kbuf_recycle(req, 0);
 		__io_poll_execute(req, 0);
 		return;
 	}



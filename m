Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826864;
	b=2huxHmF5Z5vHfETcdNVG/wH+4BlSJ4WMe2ngzJYsgLqPTR6qAVpU/c7gm+nXJiMNvnhM
	 c+ltfaD/f1Wkl8CGiCGxgWXEnSsyCWDle6/L3SlUxZ6Jo+wFFOXaI9MMWwgsXljmjKqzz
	 esQotbid2QsB6aPbGmKuqJlLkruKZSgDjVHDILuRqcLOZcJS2N8ft+nZbsZ7xjhBs2KFi
	 1pRGtwINTvDf0NiBFf15kAvvBcP2lfvwiDuJfGpBgvZXwAQ2sn7vSGw4wbfRTBB0AI19Q
	 sDlAC/jngZ57oZO+5Kw69HFcZC0nxkAaRpyRn3BGBjAu0my0trRqbdfQCnW/cJFqYVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s6vHUTz4R4uRKNj/lBYHwUalI2+N7XlxQ78VuWwAMeg=;
	b=egJ8/dSHlJB53auPaamHXPilCWtCMogWBaSe3LZsRhM4ejIq2VM9Xd7g1b7rHhpbk7+u
	 r2HwvZLezx8gMamlfTqpn/2F6HKsNMfMk2zrk9DgPckCFPo4e1m2riIhGuyZrF5DTWOrJ
	 93yAmX92xWQSVoqqB2hYI2aauIOGRhCA+GwIFHYy8br2WJjsfhhe6lIGQs9wI4oM7Zenz
	 ISE7odq0qHZ+HgYGlBNdsKy/uW7l8LsafGHrAytZFm5WG6XrtabHNfyPslW/Fu0ukgyNI
	 lYF8Au/Ei3KG6Fu2YXsOgJh1m3nzGcTfNlMYYostQS2uSjCatiIyEGvpvD0YhxbzYtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bpwcMnWz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1461E607043F;
	Wed,  4 Nov 2026 21:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bpwcMnWz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FCD1F000C1;
	Wed,  4 Nov 2026 21:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826863;
	bh=s6vHUTz4R4uRKNj/lBYHwUalI2+N7XlxQ78VuWwAMeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bpwcMnWztBMd2I4WYfs/X5oEP1wWBWxXR3xZh5oQMAymf+6xqpt5h0ZPP69uLC7+k
	 TeCRTYAtXpQ+YA1vznK/QkjuAR8+y6rrHueO+pXqtDkcZUSW+L5BnmUT30NjjHCBVk
	 dk27HQxXNX7i7UuYv1dcZXcds3fMON7ns8x21MAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 050/547] io_uring/napi: dont busy poll past an expired timeout
Date: Wed,  4 Nov 2026 16:03:54 -0500
Message-ID: <20261104211039.726742485@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 21ed976c12f6b77d7ea028a4fe9a08e69a56179f ]

__io_napi_busy_loop() caps the busy poll time to what is left until the
timeout of the wait. The difference is negative if the timeout has passed
already, which is what an application gets if it uses
IORING_ENTER_ABS_TIMER with a time that isn't in the future any more. The
min_t(u64, ...) turns that into a huge value, so the cap has no effect
and the wait, which should return right away, spins for the full busy
poll time first.

Fixes: d5cce407e4f5 ("io_uring/napi: postpone napi timeout adjustment")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-34-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/napi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 53d7623e4d237..7e698720cd51a 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -378,6 +378,8 @@ void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
 	if (iowq->timeout != KTIME_MAX) {
 		ktime_t dt = ktime_sub(iowq->timeout, io_get_time(ctx));
 
+		/* an absolute timeout may have passed already */
+		dt = max_t(ktime_t, dt, 0);
 		iowq->napi_busy_poll_dt = min_t(u64, iowq->napi_busy_poll_dt, dt);
 	}
 
-- 
2.53.0




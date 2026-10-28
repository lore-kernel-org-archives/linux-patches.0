Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209774;
	b=IKP96xft2+QstWAQqwt+qynVgMUCPUv51WcZpGuLGGyvOsyL4oBK+tiQxwCTGV9Dxn7q
	 gC9UlISLmG2g/ZMqPSuQzjBih52jWPFWEgvevuo7mWeRonVwXHtDu9RnpbtlufV8/woUF
	 F0oQqfoprPbGdcKpO+oR9ZWlxyw/Kj2gr1ENkZRoehIgsrGJ8aXytMEY9DR4Fiu8ZAMwk
	 PTSvjYIH4oJHerW/aUb0EpHLT+OzIqWFt78czMQ86xnXeKRG6gYlVG8q9DlQWlC6bUqn1
	 x65OHgB17bD7Bm1s4tzsqQ7/hK1BLwpbSLI3JJBe12HzHrZ/cnY+S2LKJ8yc3cMzJjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DMyUfFsizat39ho9e3GWfyq7yIzkAL5Yqf42Ul3JRGI=;
	b=cVfyfcWSsfiUppHlo2K8bBPeWS1kgsaYpAW1s2sECsZYFsGimIXdVYkfPtbZR3dhlVpM
	 fGOP7uPTmCUdJP2z+K45VingbOJ9xgluyr6QqHNOed+2OmiRiGF01A2A3QC86L6qDXMAH
	 ti2Rl/glXL/LbcjCx1CWhuUm+BErGpCpw1WA3X8+YY28KgMv6csMah4o42OBsPpeTWlYZ
	 MSg+TKouSTx70+ocVr1gCgcddzQLzyLs3XyC3GOt9RCpTU2kM42xC4vgNNA2c9+CUKkcL
	 Sh5jrQ+2XoBrx1JmtwdwlHTk+AcWS3Fg6w/YhSwAMrMjGP4+Uq1noxrXZgVLVY8Sr3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rcho9sQW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B725F606A324;
	Wed, 28 Oct 2026 17:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rcho9sQW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAA51F01828;
	Wed, 28 Oct 2026 17:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209773;
	bh=DMyUfFsizat39ho9e3GWfyq7yIzkAL5Yqf42Ul3JRGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rcho9sQWOcvHkwZ8lWQzH5s04fiFHmlc72588Kw70SWB6IZg/ZuSm3XtIDhXImJMB
	 oB2Mfh1fS8b10rbieD/lkmiC76kJr80M+tA2bZrOYvDoeRRwWisgtyA1ADbxBnR2wg
	 dNBdqfr6n6ZQpdddFV8JVV3hR81jOaDKV1p3hp4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 071/109] io_uring/napi: dont busy poll past an expired timeout
Date: Wed, 28 Oct 2026 18:00:55 +0100
Message-ID: <20261028165944.028270525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

Commit 21ed976c12f6b77d7ea028a4fe9a08e69a56179f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/napi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -365,6 +365,8 @@ void __io_napi_busy_loop(struct io_ring_
 	if (iowq->timeout != KTIME_MAX) {
 		ktime_t dt = ktime_sub(iowq->timeout, io_get_time(ctx));
 
+		/* an absolute timeout may have passed already */
+		dt = max_t(ktime_t, dt, 0);
 		iowq->napi_busy_poll_dt = min_t(u64, iowq->napi_busy_poll_dt, dt);
 	}
 



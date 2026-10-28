Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209728;
	b=aiUNJw9zsu2UezIz5D2S4HCZefyc7Udvj1dvD7XklXyRBBV00hlVX624uyM4dGZagIf9
	 qx9urfF8qP+UU2XqoD8i4Nc9GZOA4BUBt/0LJrG5dx5R/K1Zubnf+V9qgZRBePrfkDKaB
	 NccskMeKcn2ezJbqanXJYFewP4XmAcfY/6LAiIgn7A6ZDKCptijH1ppuKZ8xHgACezaIg
	 H6EnxG0C5XmMPYJTLp8s2oNd6lsZVN44VxbybBpX+vwD+AIKdWkFq/y9y3iTDpnwg5irZ
	 8QE/1BHorRPeiOOVpeTSYl7gL28WzzzHihi/A0RiiXym8qaaBEQsemYFbuqQQu3K8lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4m7WgUI2qqqCuqtYBMUSV9ZcKHMOjVFtJ+BNzuDFnvQ=;
	b=bwX4dDIrABx7hcVPOG5q6/AU8at+UsYgnauI2HsDvG70QDqZo6APiDredNk9e6D+5lSn
	 p2KCY+Gg412DzjHnJYmeh7fFgUj9ktVaEvwYCqiZ92H/paas1jUMs5OZKqfPyueNaKu3g
	 Y4S/UzfT+2iNQDaVAEjFz8zOVZn/z4mfsxUzi5AjrJ1U/rbFpLLvN8onJpQVrUocIzIzr
	 ekiDzCY55KysqO+z91DuYYYrxtDQ/uq4xD5Iih0v/OA/i0HjQc+nOtOX0kaZhNOpdJCIE
	 zMcpLrI8vrVWmheaLbPBtYs0UIFv8XhZi0JliszxGfCST4fuaC1yBuc1lLivu6U150g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nSWjVmyt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47311606A31E;
	Wed, 28 Oct 2026 17:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nSWjVmyt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992611F01825;
	Wed, 28 Oct 2026 17:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209728;
	bh=4m7WgUI2qqqCuqtYBMUSV9ZcKHMOjVFtJ+BNzuDFnvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nSWjVmytGuQeegw83CSEP8FGcdiskf0UgwzXS7AALtFYx93BUDQeYHBfJcI68dFK7
	 s76blXjiVhyHZO6QQuF3Nws9+N6lReuHM2/Xl/o30/9n1Eitrlshnlr2Wtl1KM5aV+
	 YWDNmO56sK1i9lRAFYpFZ1FYaJ+/xielJqWVZ+EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 057/109] io_uring/cancel: recognize "no timeout" on 32-bit
Date: Wed, 28 Oct 2026 18:00:41 +0100
Message-ID: <20261028165943.703237387@linuxfoundation.org>
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

Commit 3774e4d4c8533da2caae95556c4d635c7c4f45b8 upstream.

IORING_REGISTER_SYNC_CANCEL waits without a limit if both fields of
io_uring_sync_cancel_reg::timeout are -1. io_sync_cancel() compares them
with -1UL. They are of type long long. With a long of 32 bits -1UL is
4294967295, which is what it stays when it is converted for the
comparison, and the fields are never equal to it.

So { -1, -1 } is taken for a timeout. ktime_set() takes the nanoseconds as
an unsigned long, so what becomes of it is -1s + 4294967295ns = 3.29s.

If the request is being run by io-wq and can't be interrupted, the call
returns -ETIME after that time, rather than waiting for the request to be
gone. On i386, with a buffered read from a null_blk device that takes 4s
to complete a request, IOSQE_ASYNC, that is what each call does.

Fixes: 78a861b94959 ("io_uring: add sync cancelation API through io_uring_register()")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-17-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/cancel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -310,7 +310,7 @@ int io_sync_cancel(struct io_ring_ctx *c
 	if (ret != -EALREADY)
 		goto out;
 
-	if (sc.timeout.tv_sec != -1UL || sc.timeout.tv_nsec != -1UL) {
+	if (sc.timeout.tv_sec != -1 || sc.timeout.tv_nsec != -1) {
 		struct timespec64 ts = {
 			.tv_sec		= sc.timeout.tv_sec,
 			.tv_nsec	= sc.timeout.tv_nsec



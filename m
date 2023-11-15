Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5063BB29
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyoqdSQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E95C433C8;
	Wed, 15 Nov 2023 19:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077927;
	bh=OYfagxxlujO5fIqjIenRKEfFPZ5owF//+HOxwM80L4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EyoqdSQZps4nUbIyqq0DAEzkAWEzfyCItyz2InzbosI/B098XJw42JNNeTuijC4sB
	 PAMbab88gOkget4yjndPbW2rXKMr0nN25222vN6S2k3NjyRIEJVmMr5ilz2R2hYcgQ
	 wdVvgmw2cy0C3nk3upbZX1RZb8NaRqPdYPBeIvcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 598/603] io_uring/net: ensure socket is marked connected on connect retry
Date: Wed, 15 Nov 2023 14:19:03 -0500
Message-ID: <20231115191652.471252938@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit f8f9ab2d98116e79d220f1d089df7464ad4e026d upstream.

io_uring does non-blocking connection attempts, which can yield some
unexpected results if a connect request is re-attempted by an an
application. This is equivalent to the following sync syscall sequence:

sock = socket(AF_INET, SOCK_STREAM | SOCK_NONBLOCK, IPPROTO_TCP);
connect(sock, &addr, sizeof(addr);

ret == -1 and errno == EINPROGRESS expected here. Now poll for POLLOUT
on sock, and when that returns, we expect the socket to be connected.
But if we follow that procedure with:

connect(sock, &addr, sizeof(addr));

you'd expect ret == -1 and errno == EISCONN here, but you actually get
ret == 0. If we attempt the connection one more time, then we get EISCON
as expected.

io_uring used to do this, but turns out that bluetooth fails with EBADFD
if you attempt to re-connect. Also looks like EISCONN _could_ occur with
this sequence.

Retain the ->in_progress logic, but work-around a potential EISCONN or
EBADFD error and only in those cases look at the sock_error(). This
should work in general and avoid the odd sequence of a repeated connect
request returning success when the socket is already connected.

This is all a side effect of the socket state being in a CONNECTING
state when we get EINPROGRESS, and only a re-connect or other related
operation will turn that into CONNECTED.

Cc: stable@vger.kernel.org
Fixes: 3fb1bd688172 ("io_uring/net: handle -EINPROGRESS correct for IORING_OP_CONNECT")
Link: https://github.com/axboe/liburing/issues/980
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1461,16 +1461,6 @@ int io_connect(struct io_kiocb *req, uns
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
-	if (connect->in_progress) {
-		struct socket *socket;
-
-		ret = -ENOTSOCK;
-		socket = sock_from_file(req->file);
-		if (socket)
-			ret = sock_error(socket->sk);
-		goto out;
-	}
-
 	if (req_has_async_data(req)) {
 		io = req->async_data;
 	} else {
@@ -1490,9 +1480,7 @@ int io_connect(struct io_kiocb *req, uns
 	    && force_nonblock) {
 		if (ret == -EINPROGRESS) {
 			connect->in_progress = true;
-			return -EAGAIN;
-		}
-		if (ret == -ECONNABORTED) {
+		} else if (ret == -ECONNABORTED) {
 			if (connect->seen_econnaborted)
 				goto out;
 			connect->seen_econnaborted = true;
@@ -1506,6 +1494,16 @@ int io_connect(struct io_kiocb *req, uns
 		memcpy(req->async_data, &__io, sizeof(__io));
 		return -EAGAIN;
 	}
+	if (connect->in_progress) {
+		/*
+		 * At least bluetooth will return -EBADFD on a re-connect
+		 * attempt, and it's (supposedly) also valid to get -EISCONN
+		 * which means the previous result is good. For both of these,
+		 * grab the sock_error() and use that for the completion.
+		 */
+		if (ret == -EBADFD || ret == -EISCONN)
+			ret = sock_error(sock_from_file(req->file)->sk);
+	}
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 out:



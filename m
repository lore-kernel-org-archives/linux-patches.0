Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035633;
	b=Tdz7F5FOiUNyQxAe1FUwrMpl5u0m5hhwOyqh6dQJVzP3f/NzB86XkdNLqVIs8CHduhXR
	 6Uj8wJ1eqyXNSeOZzJdeSf9q14OQxVePTE77og6s790Hh6JpnSSRkbfF3InDKYb2TJRXj
	 dEybQ2YTP/+X+Fn5I26wp60jBpixvldy3Sm53u9Qy1W/s+c+X7Y+aV9xUZvycZ2mN3MRr
	 1dGUSP0Ee9/mYRgjXN8TDYwFy2mdLvR6csqADeH1k6zb5ludjB3OHIriJJMDxfTG+eGR8
	 GQrxcTt/nxg9PHBj78fm4uVA6dYGEcRWBRRMIeqTIl4aoQGWx2/Z5ig2F9UQ/nfGEVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3w5if5zII0rf3V8/p9MGn14PfNttmnvuM/yRlJcXZ8A=;
	b=aUozfVgajsRSC/Y0MwkQtm0Q/swBJZrz5w3KZzJN7imzpXgc6/046g7Q91mHNfzQRTR7
	 wU+s6XwIQKHtxZVZWrSDKPzLA2M/zZFHUqQO55mEmOy7Hnk7a64w7zXW2P4lZO1G7YiJ/
	 NaNcjhSO6B80keMn+2b+P2LnkYcQrNl/bXtApfk/+GE49HzdIpNXOrouH1UeFSjF5EliH
	 cRA2ONM09ETrxJNlP/z8aIjyy1qO2kykcSjqL1wSrPV//9OVMCwNfJKDzizyaFSHiu1Zo
	 hyUP65PfrILjr9FcWtLPy++Izfilt1g1wlx5/noW6MTiGD9ue6Vf8pZOkhpYcCJBGpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NmcKq8ov;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D119E606A31C;
	Wed, 18 Nov 2026 21:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NmcKq8ov
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A4F1F000C4;
	Wed, 18 Nov 2026 21:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035633;
	bh=3w5if5zII0rf3V8/p9MGn14PfNttmnvuM/yRlJcXZ8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NmcKq8ov0/Z5xlRAVWeSndmVEZyHzxujEyjhc9FnoYsDrFdXqs+NjMiDX63+bo58D
	 DPJi9WaEKw181wHfTMHar0WMzPGkJ7Y0jiW9FptBoBUMjpQK1B8ASTxmHxjWMqunfW
	 OK/5+qlOPney947PG9q+5vj4LOc3EnO4lQaG1WHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daan De Meyer <daan@amutable.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 0746/3318] io_uring/net: dont retry a non-blocking connect() that fails with -EAGAIN
Date: Wed, 18 Nov 2026 15:22:48 +0100
Message-ID: <20261118150341.002314015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daan De Meyer <daan@amutable.com>

Commit 71537ed811107c514c0342e98902d489d6d2b7cd upstream.

IORING_OP_CONNECT on an O_NONBLOCK AF_UNIX stream socket retries a
connect that fails with -EAGAIN because the listener's backlog is full.
Polling the client socket doesn't help: an unconnected stream socket
reports EPOLLOUT and EPOLLHUP right away, before the backlog drains. So
io_uring retries the connect until the apoll retry limit is hit, then
punts the request to io-wq. With a full backlog, io_connect() runs 128
times in the submitting task and once more in a new io-wq worker. That
worker stays in the task's thread group, so a later
unshare(CLONE_NEWUSER) fails with -EINVAL.

None of this changes the result. __sys_connect_file() adds the socket's
own O_NONBLOCK to every attempt, so the attempt from io-wq fails with
-EAGAIN as well. That -EAGAIN becomes the CQE result, and connect(2)
returns the same -EAGAIN.

Let's complete the request with -EAGAIN right away when the socket has
O_NONBLOCK set, like connect(2) does. io_accept() already completes
-EAGAIN this way for IORING_ACCEPT_DONTWAIT. -EINPROGRESS still waits
for the connection to complete. A blocking socket still ends up in
io-wq, where the connect sleeps until the listener accepts.

Fixes: f8e85cf255ad ("io_uring: add support for IORING_OP_CONNECT")
Signed-off-by: Daan De Meyer <daan@amutable.com>
Link: https://patch.msgid.link/20261027-b4-io-uring-connect-eagain-v1-1-f4e3aaaa49ee@amutable.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1564,6 +1564,17 @@ int io_connect(struct io_kiocb *req, uns
 			if (connect->seen_econnaborted)
 				goto out;
 			connect->seen_econnaborted = true;
+		} else if (req->file->f_flags & O_NONBLOCK) {
+			/*
+			 * __sys_connect_file() adds O_NONBLOCK from the socket
+			 * to every attempt, so a retry from io-wq fails with
+			 * -EAGAIN as well. A poll on the socket doesn't wait
+			 * until a retry can succeed. For example, an AF_UNIX
+			 * client reports EPOLLOUT right away while the
+			 * listener's backlog is full. Complete the request
+			 * with -EAGAIN, like connect(2) does.
+			 */
+			goto out;
 		}
 		if (req_has_async_data(req))
 			return -EAGAIN;



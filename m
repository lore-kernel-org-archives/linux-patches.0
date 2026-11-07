Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061849;
	b=pYQZPZYswdiNXZ/+f5Iid3oLON+6BQ4qiIvYkN+3YwzFpdvHiecKRiXZpAouqtlWGv7X
	 IIh2lBcIQUX3gPqcTKMSCk56ezcgVHyo6tlGU45lMLr5alxVyGznmMzwQH/olh0FyAoFf
	 43XxlqDPzjw65WWSzVDa9t85apR+/IjHoVLqU854slvYr2lsP4+F0UBguBdDldAcZ1xp9
	 p8tEnlWl64bUdpjgDe2RmvBkdQuNkHmdaMB9srxwRKEJ5IHOsj4yQnuIHa91wUTiymD+H
	 HJRnzEcdfbYBrR2N1Fb/3ELI0RaNrjHKRTlkMUbPv7s3AupYB8iaMl+u+HHa+Gk/EBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d/q9CzYAGAL7x3k2EtZFGSkKrQ1mZdp9YI+CuToSSYQ=;
	b=HC1MJd6S4w7sddbNEU8rk1TlT+N1ralf0tz0YGEf1NjO91e8WBDwn8ep00o3DPE7j8c6
	 9fdd4d50EQZ8E7qny7Ii2zGABqRqzvWT8ciM8WPCjZp9tv/4JQhyBxEmD7NFLOfxaMhgp
	 k5g7Os5LPSeOKgIC7hOBYqOQZcshyde7jLLOgoYNxQDIkNbVJSfG0kIYDc51NFjbjc5yG
	 J4uSdUkKuH/GSsCCtJ3nXl86jXJ1V7yOI43bLGxtN5w8QdamUpjcQTcrXDA816QpigjFr
	 NwwtlMPVTjCR8jTDEFwlLp926XTWb5EhDZlEMdAh4fgBe9fl+bPWWOWN5ndeRQpj8lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h7o7tnd7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A0ED606A32C;
	Sat,  7 Nov 2026 14:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h7o7tnd7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AD91F0089F;
	Sat,  7 Nov 2026 14:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061849;
	bh=d/q9CzYAGAL7x3k2EtZFGSkKrQ1mZdp9YI+CuToSSYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h7o7tnd7Ta6Zit74XFDbtO00xF1OMBZzTlIltFR/yCzS7w2sbQkvFT7oIhBs7sdJY
	 O+iQks23iYULliSjtHGs+p90ebnTCfymgC5Yi7EY2bFMHvxR6jg2e+6S2DjnBgKTbM
	 DYIOrE+BfX0I9m7LqSu4swZ5mJg1H1oHOxkviK8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daan De Meyer <daan@amutable.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 0830/1536] io_uring/net: dont retry a non-blocking connect() that fails with -EAGAIN
Date: Sat,  7 Nov 2026 08:47:26 -0500
Message-ID: <20261107135020.857590239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1811,6 +1811,17 @@ int io_connect(struct io_kiocb *req, uns
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
 		return -EAGAIN;
 	}



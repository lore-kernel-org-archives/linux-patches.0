Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831883;
	b=OWjXcqB0KB9z9iLknZ42LjxXKAZraryahodSFoaZUzXIDO5PS6NoRWnLdbfnzD1sI6gQ
	 djXxvv9UeSKf/KO4F+v1K1bqR8KPx2JB47U6EX76D78RRuzCsdxSPynX0xbaznJdt5h83
	 BYMau7eShJH00iXs5Od42zkQXrZlzbD7JIDhjHcBosbMpL4mWhMm259BXNhpCkr9N6yWt
	 Ps1fh51FyM30Skk5o2iMfcl7UhuxTdVAI73tdaGzj8Bav7hPGLVGSUuvCZeYKX3zD3LVd
	 vDaG3iT2o5tGVYayThmZi7c1MPLuVSjEtnWzRWw6NvC+6WLXMq3ecHlSLVVUQBvdGCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zFh/SHkFkbMvO2kko7NRied7vDgUNGyp165bjVbTvz0=;
	b=cm7jAw8X+E6I540SEkepxyjzrnsD7uRgZQfN1DGSQ+E3siw29R58Nh5HEo7s+nCMHbm2
	 deQBUVUMZ1yZ7BBwHEm7tiI5YxsyNoQZnb5A5ELXQUJjolOWxrjc5j9unSXSfBYy33AZA
	 5owG/ymuwMVZeTbIXMLaJLqw2UWOdlWopNE+rhMDUb9WM7SRz3kjxwg+j8aVQWwKMQhO9
	 OqRcMX/zIT1FaAQyAZMgcKDOiufgJXJGpoFF9SgSoIN+bKjMQocKt796xjKgSVteT2Wxi
	 CJIcOgDCXopT3TV0lDxfncnxnD+4MUqHofMd324iePACa4etQEGbMredy4LMZnBZ/zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D9KlTc1y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A9A606A334;
	Wed,  4 Nov 2026 22:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D9KlTc1y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216BB1F000C1;
	Wed,  4 Nov 2026 22:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831883;
	bh=zFh/SHkFkbMvO2kko7NRied7vDgUNGyp165bjVbTvz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D9KlTc1yX/5WBFNarh8XKPz7eCk7/Ikcgb35rZG1nTnE4p5+0sbUVj7h7i8KJEFbG
	 C9kB+Hv6zV9msxtXPVPef1Jt3mRpyKfVPnEwCsenHSXAjXOsi92V6IeomrrRwY/CBG
	 t+H2dDar0ScVmULxGbq+v3n+/A1qbyGM0shKVUaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daan De Meyer <daan@amutable.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 0973/1005] io_uring/net: dont retry a non-blocking connect() that fails with -EAGAIN
Date: Wed,  4 Nov 2026 16:11:46 -0500
Message-ID: <20261104211110.316884330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -1864,6 +1864,17 @@ int io_connect(struct io_kiocb *req, uns
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



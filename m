Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829275;
	b=HAvwbcHR0u9qo9e25C6ACXhRayS5z3XoI424VTgEkA0cxfsQ+py8aexpwIgy6r10/7PK
	 t8xdtLingS5QXsgi4erTCpoaOMttdfkAZEd8ZGl8VDwiXrYVZ4MIWtFmSuQHM4qh2iQXF
	 ODEPUKWY4WZLRLwsWVjX74AOV/6SbmEuD9tP7hlJ7d3xb/FOlZ8KjFNIH6LoiBwUyLiqD
	 mJTfvjW0i08F7skjh0lE7xKeTNKvb9S8E465QnoOZvfxmYsSGtQfL3krbjJwN6u3lHO2S
	 lZe5ZFovstVhonYiOLqdFK7o41MxI8Jj4VRhptfAcgNnFTCdFi2z+p+Z+Q8aWR72qWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N1xKhwIvldbjdHTWLYsdDL7+a2d8caRKsl4U2hW4RM8=;
	b=3Gdi+C5ZGlEgFcjcGt/F/6d985j6PyivWhX0i5+z3Nk3UCwrLJEbIxRITOmcmaiGwD15
	 Rna04V6zPfAKFcQHmwIHKFA3qTjfsCQEFPlszQUE8pzqbm/dXvwLbswxflF0w2nNKH/EM
	 R1q2QkNqIEghTpx5aoCjdMksiEk+M5l3fFoaI6+ymn1mL0O2MwkXpDY5mCOe6KwZ3kIfM
	 9khx5ofiewTNHlHUzsGmGC7JskcuHIFPdwUvCL54cE8srRuTcRUf1EHnRWZr+jvdv8GDQ
	 dIIbdM5xQpb03f8x2E+R2Db8ccvaN3qnLxl28xh2DP2MxNDdpqn+0YceyVz+PqryeLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GpiUEIwm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD346070AA2;
	Wed,  4 Nov 2026 21:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GpiUEIwm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEB31F000C1;
	Wed,  4 Nov 2026 21:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829275;
	bh=N1xKhwIvldbjdHTWLYsdDL7+a2d8caRKsl4U2hW4RM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GpiUEIwmd1gzsQyI0qch7Vlb9NXbfD+j49iQb9QmsK05YhNJUalD/A3QAA/fhEuyT
	 jwwM8K1nyRsRAiHZXcF30yask1/7u/oiMIcm0jl6h2ZCT37CnasexaLbHC/CC9bDbe
	 5oscs4/kjaR76MFSWeIU7Rgd6UgvrA1Sy/DrJqow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daan De Meyer <daan@amutable.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 522/547] io_uring/net: dont retry a non-blocking connect() that fails with -EAGAIN
Date: Wed,  4 Nov 2026 16:11:46 -0500
Message-ID: <20261104211053.227237617@linuxfoundation.org>
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
@@ -1878,6 +1878,17 @@ int io_connect(struct io_kiocb *req, uns
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



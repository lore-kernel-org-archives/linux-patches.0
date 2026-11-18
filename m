Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044684;
	b=stxtSeN7q9fb3GtaerL4XSzbH+YR/PD5WITgJqv4VLVydD8xAv3GrTp4bD3oX+9bFIrD
	 uScVXaeTNRsg0KAkZ2cYOEJkXMayl3QNlJtKodP8zcVCBCFFRmrR1BKs7pHdPFinu/i+Z
	 TJ0g+gEEuoYJDtUR2GP/VsbrRVBVfsE4PYCYL1DCWNxVcqyqwR3zS/RzvD9/KKFgNkVqk
	 e/vr0wtB8YujL+Sqpe1ybSq4YuWPTjlG6B20x+Ap7OUGm3ha6XEDf4nA/3+4WHlap2Y3C
	 E7wLG78O03fVdopNrzoGKI5zb+lFijswWju+1xNcu+Z3eUAaqZhXNHi0ie4VDvsEl5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sidfqEfHI+U5sF5Wka/GnkHcOBoV3ppBaAkAD/0a6iA=;
	b=pC3ppZmyTKtIpPH/eZenb+9XuMdO+viDmGQDQwqiSvcps7DvIMuhxiPvI3X+tq/Ahoo4
	 7s96ieHAYUQl/r8BqnhPctSFA2DCT8tFRKEMbiSX5zdsyyNg4z5M4GBL2fXLpK1NjR20I
	 wo85lKaQicbEYFsZy/3YaeLjawcobNHooaf6wHxsG2SLGQFJpZf02dsvBZJqH5FTjtzA7
	 /UGj7TK4masF8UrdOoHIQpeQ5CmbL6SUzHnkVV13cfqVKoqVJmyv0R5cVy1H/eX0TTlTo
	 Yp+DAumTyoPldUyQnP3xiWJHwHJapNHw5UTORlqa/3lYR8WHaYgjLCF+QnBNoHkTX2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mKjcHG5y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526BE606A31C;
	Wed, 18 Nov 2026 23:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mKjcHG5y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6941F000C4;
	Wed, 18 Nov 2026 23:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044684;
	bh=sidfqEfHI+U5sF5Wka/GnkHcOBoV3ppBaAkAD/0a6iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mKjcHG5yUIIXQQtQvPWxquEsPOD8616M3qBtyq0o/CPQ02wKKdFTh47dPXFK7pW9o
	 Y/IC3ljSabIbvw8SaOf61AGQS22asZdAISB2IopcRodAo4qBzd4kkbE4nV+USgYQTF
	 69TZMdasITQ/if4yk38hwbQETunekDR8XdjgndJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daan De Meyer <daan@amutable.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 0654/2857] io_uring/net: dont retry a non-blocking connect() that fails with -EAGAIN
Date: Wed, 18 Nov 2026 15:28:08 +0100
Message-ID: <20261118150225.107331788@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1510,6 +1510,17 @@ int io_connect(struct io_kiocb *req, uns
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



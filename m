Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704529;
	b=Sl6IEr3qZJBKM7TUR71P+/AXRlQomT5WMysP4XbtzwYzIbCEYpLG7E3yA1CKwVdYFJt7
	 PzqK/h7WUxnpkyeqUR5GNxAO/542mBsLa/bH5P4cYDdBt63M7mnP75sFTTMaQvU1vBUXZ
	 +kn+XirklEC6lEOqeDZVqUM2Sdv6Idlwn83n/uvQFWZ5yOtqSU++zc7XEXPmtBfiKvLnT
	 3soZiLBfdAeRd49pJITaFwhXGF8+9EFcvOLj23+EtpMZabjXEOKx2J1z6bh7QkZ0lg+9T
	 wH4vfEXWk4TSMdw7esmOz2fXeuYejBt3IOCCXle9PfcB4SojeBykAmj0eI+QWc0vTdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zTya2R2dcD36gWmzaXO0vthTrnDksPSWiOe0yHVtDVk=;
	b=v+jnZyYrcLkk1TgqkGqVN6uCvWYJLNQn3uVd9NPFXmENLVIMNEgVe37Sqc4+hlC/y6A3
	 iS0RRqbqjITOdzEpDlAhwhJ8lerxfqGWPIm5WNMQEi94S6e9Cuw/7yPcTNO7Un/vycOmO
	 TrbKFC63aHX68XYijwam5Mv4WqzZMpJLXH0fY9rOxRUcdewxzyMz/23XkxC+MOstYgD9j
	 u8ANsyDadV6hXrKL1nph+6xjsiYPSeHMU50/SvXDBWjOVUTnJ/hwYQxDHj/4SLI7+RIod
	 nvwq70OIQ04W+KQT760WAskywqIGWs3nNvS1zycylSm5M3kPyX7MFRgHwCyHyrI/Cbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JFgkqv5h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6197606A31C;
	Thu, 26 Nov 2026 14:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JFgkqv5h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F631F000CF;
	Thu, 26 Nov 2026 14:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704529;
	bh=zTya2R2dcD36gWmzaXO0vthTrnDksPSWiOe0yHVtDVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFgkqv5h6wDmE1tEZjSAqVjxzyBQIY6CT0XMXR4u+ol8GJ8uHWL4eeMAqJrKUt+rn
	 lcWMPb3OarFZ3A5eKOsTNGIlzC7mEtJ+kOvgF7x4PcLiCRWryT3J8DGkg8nA9LE/6T
	 Nu4rg/bW0vOAwBKA/O2b7fOeoM3kaJypebYACKPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Lalinsk=C3=BD?= <lukas@lalinsky.com>,
	Jens Axboe <axboe@kernel.dk>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 5.10 157/265] net: leave O_NONBLOCK to the sendmsg and recvmsg syscalls
Date: Thu, 26 Nov 2026 15:38:07 +0100
Message-ID: <20261126143616.061740425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit bdc350ddbcbe4788158019d4d8e8e9345cb16235 upstream.

____sys_sendmsg() and ____sys_recvmsg() turn O_NONBLOCK on the socket
into MSG_DONTWAIT. That is right for the system calls, but io_uring uses
__sys_sendmsg_sock() and __sys_recvmsg_sock() for a blocking attempt
from io-wq as well, after the non-blocking attempts with MSG_DONTWAIT
have failed. On an O_NONBLOCK socket that attempt can't block either and
the request completes with -EAGAIN, unlike IORING_OP_SEND and RECV,
which call sock_sendmsg() and sock_recvmsg() directly and don't look at
O_NONBLOCK at all.

Move the O_NONBLOCK handling to ___sys_sendmsg() and ___sys_recvmsg(),
which the sendmsg, sendmmsg, recvmsg and recvmmsg system calls go
through. The io_uring helpers then pass the flags the caller asked for.

Cc: stable@vger.kernel.org
Fixes: 0fa03c624d8f ("io_uring: add support for sendmsg()")
Fixes: aa1fa28fc73e ("io_uring: add support for recvmsg()")
Link: https://lore.kernel.org/io-uring/a5589b66-9a20-4b1c-a0f1-1b5b31af3667@app.fastmail.com/
Reported-by: Lukáš Lalinský <lukas@lalinsky.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/socket.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/socket.c
+++ b/net/socket.c
@@ -2361,8 +2361,6 @@ static int ____sys_sendmsg(struct socket
 	}
 	msg_sys->msg_flags = flags;
 
-	if (sock->file->f_flags & O_NONBLOCK)
-		msg_sys->msg_flags |= MSG_DONTWAIT;
 	/*
 	 * If this is sendmmsg() and current destination address is same as
 	 * previously succeeded address, omit asking LSM's decision.
@@ -2426,6 +2424,9 @@ static int ___sys_sendmsg(struct socket
 
 	msg_sys->msg_name = &address;
 
+	if (sock->file->f_flags & O_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+
 	err = sendmsg_copy_msghdr(msg_sys, msg, flags, &iov);
 	if (err < 0)
 		return err;
@@ -2589,9 +2590,6 @@ static int ____sys_recvmsg(struct socket
 	/* We assume all kernel code knows the size of sockaddr_storage */
 	msg_sys->msg_namelen = 0;
 
-	if (sock->file->f_flags & O_NONBLOCK)
-		flags |= MSG_DONTWAIT;
-
 	if (unlikely(nosec))
 		err = sock_recvmsg_nosec(sock, msg_sys, flags);
 	else
@@ -2633,6 +2631,9 @@ static int ___sys_recvmsg(struct socket
 	struct sockaddr __user *uaddr;
 	ssize_t err;
 
+	if (sock->file->f_flags & O_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+
 	err = recvmsg_copy_msghdr(msg_sys, msg, flags, &uaddr, &iov);
 	if (err < 0)
 		return err;



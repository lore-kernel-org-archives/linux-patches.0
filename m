Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705405;
	b=iFOPostxf+3ZwRPLXEsieTSKCkEqvVno2GAdetxy/U4FIfffcpAjayzOCTOPwx4Vsfjd
	 AbkTqa89AxRHEzVUENGAqB6z6cJUF/lxHpO7odLGcnsF4fJTtG07HtdMZbJHaQw//d6by
	 8rEWa8mEHA9E4DDSoBbNK6g1E3VHXaHuAmpsyuP1WHTd4QxnfWWSJAzfyslrRrEpXts+X
	 1vAalNkQftlvQ6bOXkxQSd8aO5H6ek7ACddz222z2hOpuaJntsY0M2hhwr7Wo8OxRE014
	 eo2j35ceiiVTL647V/H5+Y6xkudaER8UIULdFAoFFubWCB+u1WMxMdr0Tw5hPsYGLeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jXVrb3pWNNCk6tsTNirIjDw1vqjQ+xuv1RV+rPSB+i4=;
	b=dFFhlBMyLqOOJUE37/N8awo+l4gK0/8ulaLO3Nr/JqymURP7ikYtq073kQbzOnOrpxKk
	 QT1D1QwzC/iEx8TyHnEwuMJrhoU7wOIWWbKhwaMvhrq3y5eC6gA8GlfbFdqwzqlSVMpJ+
	 zXaJhKpoBXU6LxGoR1po46D3abqYsz3TFyn7k5oO5Rxj7W77JBqioVUJBpjZToqDrfvVb
	 /25Cko+aPBnnJ4tzBPe4BGDHx/pIB0dplWzlQuQd/uE7JMdUWEyN4g8+3WZVbyeEO1w2z
	 XPMwiWgIIRHf/WU1pYa3+i4UmVVeFvSC6T0eJkLvRa/LfYtt1pVZmnSVc3QSM053Ynw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z90JH4S+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8966606A31C;
	Thu, 26 Nov 2026 15:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z90JH4S+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DC51F000C0;
	Thu, 26 Nov 2026 15:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705404;
	bh=jXVrb3pWNNCk6tsTNirIjDw1vqjQ+xuv1RV+rPSB+i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z90JH4S+8qaRlAjd6zCxk1Oi/m3/iPZJT7Ypv7l4JSU7XgaQSJbIZpVU3jWaOrcrL
	 DmzrcS1Kyw0KXmpiJbHWOyaVgogueAKfp9OySkxmcq0PO1scAYU9nsDZG/yub5XaeX
	 9VR2njGLZtPBQ5jay4e6lWgQ2GDiuC4NPGj7cf0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Luk=C3=A1=C5=A1=20Lalinsk=C3=BD?= <lukas@lalinsky.com>,
	Jens Axboe <axboe@kernel.dk>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 5.15 188/319] net: leave O_NONBLOCK to the sendmsg and recvmsg syscalls
Date: Thu, 26 Nov 2026 15:39:16 +0100
Message-ID: <20261126144010.989177325@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2428,8 +2428,6 @@ static int ____sys_sendmsg(struct socket
 	}
 	msg_sys->msg_flags = flags;
 
-	if (sock->file->f_flags & O_NONBLOCK)
-		msg_sys->msg_flags |= MSG_DONTWAIT;
 	/*
 	 * If this is sendmmsg() and current destination address is same as
 	 * previously succeeded address, omit asking LSM's decision.
@@ -2493,6 +2491,9 @@ static int ___sys_sendmsg(struct socket
 
 	msg_sys->msg_name = &address;
 
+	if (sock->file->f_flags & O_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+
 	err = sendmsg_copy_msghdr(msg_sys, msg, flags, &iov);
 	if (err < 0)
 		return err;
@@ -2656,9 +2657,6 @@ static int ____sys_recvmsg(struct socket
 	/* We assume all kernel code knows the size of sockaddr_storage */
 	msg_sys->msg_namelen = 0;
 
-	if (sock->file->f_flags & O_NONBLOCK)
-		flags |= MSG_DONTWAIT;
-
 	if (unlikely(nosec))
 		err = sock_recvmsg_nosec(sock, msg_sys, flags);
 	else
@@ -2700,6 +2698,9 @@ static int ___sys_recvmsg(struct socket
 	struct sockaddr __user *uaddr;
 	ssize_t err;
 
+	if (sock->file->f_flags & O_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+
 	err = recvmsg_copy_msghdr(msg_sys, msg, flags, &uaddr, &iov);
 	if (err < 0)
 		return err;



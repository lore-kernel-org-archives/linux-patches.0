Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08244138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0C5C433EF;
	Tue,  3 Jan 2023 08:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733688;
	bh=2svgWQnRQCljcnYMUpb1GOakdrBCW6zvQiSUYdmUG0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBmS60C3ijQsAwumoBWS+gG9nqvAn6Q1iIX37pGZHo+I8Dze6Dh9qMJgkHkAmmP4X
	 iwZVT2KDxx5M++ROtW72jtnCLhs17eciHqCrND3kqyG8rleiVWGKLQEz3XO/nxAtFd
	 75njFfmYOmTqmDTRPXtVy6IL27HOPlvmbiE++bEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 10/63] net: add accept helper not installing fd
Date: Tue,  3 Jan 2023 09:13:40 +0100
Message-Id: <20230103081309.182835010@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit d32f89da7fa8ccc8b3fb8f909d61e42b9bc39329 ]

Introduce and reuse a helper that acts similarly to __sys_accept4_file()
but returns struct file instead of installing file descriptor. Will be
used by io_uring.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Acked-by: David S. Miller <davem@davemloft.net>
Link: https://lore.kernel.org/r/c57b9e8e818d93683a3d24f8ca50ca038d1da8c4.1629888991.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/socket.h |    3 ++
 net/socket.c           |   67 ++++++++++++++++++++++++++-----------------------
 2 files changed, 39 insertions(+), 31 deletions(-)

--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -421,6 +421,9 @@ extern int __sys_accept4_file(struct fil
 			struct sockaddr __user *upeer_sockaddr,
 			 int __user *upeer_addrlen, int flags,
 			 unsigned long nofile);
+extern struct file *do_accept(struct file *file, unsigned file_flags,
+			      struct sockaddr __user *upeer_sockaddr,
+			      int __user *upeer_addrlen, int flags);
 extern int __sys_accept4(int fd, struct sockaddr __user *upeer_sockaddr,
 			 int __user *upeer_addrlen, int flags);
 extern int __sys_socket(int family, int type, int protocol);
--- a/net/socket.c
+++ b/net/socket.c
@@ -1688,30 +1688,22 @@ SYSCALL_DEFINE2(listen, int, fd, int, ba
 	return __sys_listen(fd, backlog);
 }
 
-int __sys_accept4_file(struct file *file, unsigned file_flags,
+struct file *do_accept(struct file *file, unsigned file_flags,
 		       struct sockaddr __user *upeer_sockaddr,
-		       int __user *upeer_addrlen, int flags,
-		       unsigned long nofile)
+		       int __user *upeer_addrlen, int flags)
 {
 	struct socket *sock, *newsock;
 	struct file *newfile;
-	int err, len, newfd;
+	int err, len;
 	struct sockaddr_storage address;
 
-	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
-		return -EINVAL;
-
-	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
-		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
-
 	sock = sock_from_file(file, &err);
 	if (!sock)
-		goto out;
+		return ERR_PTR(err);
 
-	err = -ENFILE;
 	newsock = sock_alloc();
 	if (!newsock)
-		goto out;
+		return ERR_PTR(-ENFILE);
 
 	newsock->type = sock->type;
 	newsock->ops = sock->ops;
@@ -1722,18 +1714,9 @@ int __sys_accept4_file(struct file *file
 	 */
 	__module_get(newsock->ops->owner);
 
-	newfd = __get_unused_fd_flags(flags, nofile);
-	if (unlikely(newfd < 0)) {
-		err = newfd;
-		sock_release(newsock);
-		goto out;
-	}
 	newfile = sock_alloc_file(newsock, flags, sock->sk->sk_prot_creator->name);
-	if (IS_ERR(newfile)) {
-		err = PTR_ERR(newfile);
-		put_unused_fd(newfd);
-		goto out;
-	}
+	if (IS_ERR(newfile))
+		return newfile;
 
 	err = security_socket_accept(sock, newsock);
 	if (err)
@@ -1758,16 +1741,38 @@ int __sys_accept4_file(struct file *file
 	}
 
 	/* File flags are not inherited via accept() unlike another OSes. */
-
-	fd_install(newfd, newfile);
-	err = newfd;
-out:
-	return err;
+	return newfile;
 out_fd:
 	fput(newfile);
-	put_unused_fd(newfd);
-	goto out;
+	return ERR_PTR(err);
+}
+
+int __sys_accept4_file(struct file *file, unsigned file_flags,
+		       struct sockaddr __user *upeer_sockaddr,
+		       int __user *upeer_addrlen, int flags,
+		       unsigned long nofile)
+{
+	struct file *newfile;
+	int newfd;
+
+	if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
+		return -EINVAL;
 
+	if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
+		flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
+
+	newfd = __get_unused_fd_flags(flags, nofile);
+	if (unlikely(newfd < 0))
+		return newfd;
+
+	newfile = do_accept(file, file_flags, upeer_sockaddr, upeer_addrlen,
+			    flags);
+	if (IS_ERR(newfile)) {
+		put_unused_fd(newfd);
+		return PTR_ERR(newfile);
+	}
+	fd_install(newfd, newfile);
+	return newfd;
 }
 
 /*



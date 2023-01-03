Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883E4138D
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 08:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08914C433D2;
	Tue,  3 Jan 2023 08:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672733715;
	bh=hBZ23nNFAh0pqQ9pVR84PsOwqHuYespvPzJBOkAIulQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rETrIIitqOj6Sf8rebJ2wBiKf0hGztS8tTf8hFyh2QV9jKfRoKpREiRF1FGW1TYMG
	 9H6CYvv6AbHyS9B4iC8lHmh5/wo+wGSoO8rXlbMM6Hr1JTo5vCrvf02xX9jo2QmiUo
	 eBxvKjiJPa8ExARuVI2/nCrazLwl7f1dz6xZ9jYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 09/63] net: provide __sys_shutdown_sock() that takes a socket
Date: Tue,  3 Jan 2023 09:13:39 +0100
Message-Id: <20230103081309.123931742@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit b713c195d59332277a31a59c91f755e53b5b302b ]

No functional changes in this patch, needed to provide io_uring support
for shutdown(2).

Cc: netdev@vger.kernel.org
Cc: David S. Miller <davem@davemloft.net>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/socket.h |    1 +
 net/socket.c           |   15 ++++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -436,5 +436,6 @@ extern int __sys_getpeername(int fd, str
 			     int __user *usockaddr_len);
 extern int __sys_socketpair(int family, int type, int protocol,
 			    int __user *usockvec);
+extern int __sys_shutdown_sock(struct socket *sock, int how);
 extern int __sys_shutdown(int fd, int how);
 #endif /* _LINUX_SOCKET_H */
--- a/net/socket.c
+++ b/net/socket.c
@@ -2181,6 +2181,17 @@ SYSCALL_DEFINE5(getsockopt, int, fd, int
  *	Shutdown a socket.
  */
 
+int __sys_shutdown_sock(struct socket *sock, int how)
+{
+	int err;
+
+	err = security_socket_shutdown(sock, how);
+	if (!err)
+		err = sock->ops->shutdown(sock, how);
+
+	return err;
+}
+
 int __sys_shutdown(int fd, int how)
 {
 	int err, fput_needed;
@@ -2188,9 +2199,7 @@ int __sys_shutdown(int fd, int how)
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (sock != NULL) {
-		err = security_socket_shutdown(sock, how);
-		if (!err)
-			err = sock->ops->shutdown(sock, how);
+		err = __sys_shutdown_sock(sock, how);
 		fput_light(sock->file, fput_needed);
 	}
 	return err;



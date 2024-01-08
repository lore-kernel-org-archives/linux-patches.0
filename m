Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A20451C2F;
	Mon,  8 Jan 2024 15:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSL4FHzj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20DEC433C8;
	Mon,  8 Jan 2024 15:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728489;
	bh=Qrl0F15PJPXJyP6Zy4kXgsXmwV9pjSrplwEpFfSlXw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSL4FHzjdSkhksowTjBhosfsDDNE/Qc9H0qb+uUZud4U4Zg6qOmmW0C6CuF8lRq9H
	 2hmYhEUuTzYjv5BWpT+y8PEz/wjvYqL419gS4BVs/4kR580ParXfaNEgacB9PzrTFE
	 Hq0Z9JNBY/N7hKMdQOsQRg9sDQ4x02RovPpfU1K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/150] net: Declare MSG_SPLICE_PAGES internal sendmsg() flag
Date: Mon,  8 Jan 2024 16:35:14 +0100
Message-ID: <20240108153514.142655635@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit b841b901c452d92610f739a36e54978453528876 ]

Declare MSG_SPLICE_PAGES, an internal sendmsg() flag, that hints to a
network protocol that it should splice pages from the source iterator
rather than copying the data if it can.  This flag is added to a list that
is cleared by sendmsg syscalls on entry.

This is intended as a replacement for the ->sendpage() op, allowing a way
to splice in several multipage folios in one go.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
cc: Jens Axboe <axboe@kernel.dk>
cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a0002127cd74 ("udp: move udp->no_check6_tx to udp->udp_flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/socket.h | 3 +++
 io_uring/net.c         | 2 ++
 net/socket.c           | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 1db29aab8f9c3..b3c58042bd254 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -324,6 +324,7 @@ struct ucred {
 					  */
 
 #define MSG_ZEROCOPY	0x4000000	/* Use user data in kernel path */
+#define MSG_SPLICE_PAGES 0x8000000	/* Splice the pages from the iterator in sendmsg() */
 #define MSG_FASTOPEN	0x20000000	/* Send data in TCP SYN */
 #define MSG_CMSG_CLOEXEC 0x40000000	/* Set close_on_exec for file
 					   descriptor received through
@@ -334,6 +335,8 @@ struct ucred {
 #define MSG_CMSG_COMPAT	0		/* We never have 32 bit fixups */
 #endif
 
+/* Flags to be cleared on entry by sendmsg and sendmmsg syscalls */
+#define MSG_INTERNAL_SENDMSG_FLAGS (MSG_SPLICE_PAGES)
 
 /* Setsockoptions(2) level. Thanks to BSD these must match IPPROTO_xxx */
 #define SOL_IP		0
diff --git a/io_uring/net.c b/io_uring/net.c
index 57c626cb4d1a5..67f09a40bcb21 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -389,6 +389,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
+	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
 	msg.msg_flags = flags;
 	ret = sock_sendmsg(sock, &msg);
 	if (ret < min_ret) {
@@ -1137,6 +1138,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 		msg_flags |= MSG_DONTWAIT;
 	if (msg_flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&msg.msg_iter);
+	msg_flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
 
 	msg.msg_flags = msg_flags;
 	msg.msg_ubuf = &io_notif_to_data(zc->notif)->uarg;
diff --git a/net/socket.c b/net/socket.c
index 0104617b440dc..6f39f7b0cc85c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2131,6 +2131,7 @@ int __sys_sendto(int fd, void __user *buff, size_t len, unsigned int flags,
 		msg.msg_name = (struct sockaddr *)&address;
 		msg.msg_namelen = addr_len;
 	}
+	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
 	if (sock->file->f_flags & O_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	msg.msg_flags = flags;
@@ -2482,6 +2483,7 @@ static int ____sys_sendmsg(struct socket *sock, struct msghdr *msg_sys,
 		msg_sys->msg_control = ctl_buf;
 		msg_sys->msg_control_is_user = false;
 	}
+	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
 	msg_sys->msg_flags = flags;
 
 	if (sock->file->f_flags & O_NONBLOCK)
-- 
2.43.0




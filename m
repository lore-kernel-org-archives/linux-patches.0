Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2169C208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EoGPup/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90876C433CC;
	Tue, 31 Oct 2023 17:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774507;
	bh=xrROycKAnd/qnrxWLF0cMljlGK1iYmbbv1hB7B33zvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EoGPup/UL2qoT7S5EhoeLPXLMWRcV5uzscJC2JNvcWuArI8xZHaXJa5Eo6OjG+l7y
	 yf8krrNv4h/kAevN+oC0gkNJze6h0ysVj0US8aVJVyFYKMV92qaFOdveQXmuESsVJ9
	 Dq6fIxqielmBnlDmrZ0zbpUGsnW0HY6+bGXSR6Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Moritz=20Wanzenb=C3=B6ck?= <moritz.wanzenboeck@linbit.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 070/112] net/handshake: fix file ref count in handshake_nl_accept_doit()
Date: Tue, 31 Oct 2023 18:01:11 +0100
Message-ID: <20231031165903.522946684@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moritz Wanzenböck <moritz.wanzenboeck@linbit.com>

[ Upstream commit 7798b59409c345d4a6034a4326bceb9f7e2e8b58 ]

If req->hr_proto->hp_accept() fail, we call fput() twice:
Once in the error path, but also a second time because sock->file
is at that point already associated with the file descriptor. Once
the task exits, as it would probably do after receiving an error
reading from netlink, the fd is closed, calling fput() a second time.

To fix, we move installing the file after the error path for the
hp_accept() call. In the case of errors we simply put the unused fd.
In case of success we can use fd_install() to link the sock->file
to the reserved fd.

Fixes: 7ea9c1ec66bc ("net/handshake: Fix handshake_dup() ref counting")
Signed-off-by: Moritz Wanzenböck <moritz.wanzenboeck@linbit.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://lore.kernel.org/r/20231019125847.276443-1-moritz.wanzenboeck@linbit.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/handshake/netlink.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index d0bc1dd8e65a8..80c7302692c74 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -87,29 +87,6 @@ struct nlmsghdr *handshake_genl_put(struct sk_buff *msg,
 }
 EXPORT_SYMBOL(handshake_genl_put);
 
-/*
- * dup() a kernel socket for use as a user space file descriptor
- * in the current process. The kernel socket must have an
- * instatiated struct file.
- *
- * Implicit argument: "current()"
- */
-static int handshake_dup(struct socket *sock)
-{
-	struct file *file;
-	int newfd;
-
-	file = get_file(sock->file);
-	newfd = get_unused_fd_flags(O_CLOEXEC);
-	if (newfd < 0) {
-		fput(file);
-		return newfd;
-	}
-
-	fd_install(newfd, file);
-	return newfd;
-}
-
 int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net *net = sock_net(skb->sk);
@@ -133,17 +110,20 @@ int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_info *info)
 		goto out_status;
 
 	sock = req->hr_sk->sk_socket;
-	fd = handshake_dup(sock);
+	fd = get_unused_fd_flags(O_CLOEXEC);
 	if (fd < 0) {
 		err = fd;
 		goto out_complete;
 	}
+
 	err = req->hr_proto->hp_accept(req, info, fd);
 	if (err) {
-		fput(sock->file);
+		put_unused_fd(fd);
 		goto out_complete;
 	}
 
+	fd_install(fd, get_file(sock->file));
+
 	trace_handshake_cmd_accept(net, req, req->hr_sk, fd);
 	return 0;
 
-- 
2.42.0




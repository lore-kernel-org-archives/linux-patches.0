Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F5A17BEAD;
	Tue, 10 Sep 2024 10:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964276; cv=none; b=WRc2YjZ+38Dql8Ga1432eflESVSs+cQwZ5L2TzRrwpn42gy8LP7IUdyqdxjmVHSQCyzOmOJKNcE+Pjytl04f0MikJrJTN+fFrtZeQmpE5Z3dIMk3Q4nsmsvHrJMttitRSMuA1r3fA+4f2i/MyD3TnVH3LgHgh70ewhBDXzqcZ00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964276; c=relaxed/simple;
	bh=3YigmSDMyJbYSulWqHX9w+Wt6LnY7khNbIHshW6hRDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdByQD4S5bLXarLvYeOzPisg2eT70X8DHtjqxc5ET+GVq9X5h0ltV9gQDzCg374ZyGSY8QKZR+g6IPHE/0qrMW0DZriW56GwvAx8S0rpd3xol/Sf1QaRh+SJjweUVRPYx9GDuKk2xzZX8xrTYwNDO/+D2xRnV6lZ3W+HB4f1fws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMIotyDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMIotyDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0E2C4CEC3;
	Tue, 10 Sep 2024 10:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964276;
	bh=3YigmSDMyJbYSulWqHX9w+Wt6LnY7khNbIHshW6hRDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMIotyDbeitSWURL9ZxqbrXhR/J3vgYPF9romuQW+ho+mkDcQYzsBe8eLV27ZTvBw
	 iDHbPlxf8K9kDNk0OeZhfWCcpXObuYA7zHlaKxic8z785nJu9X9wd8rGNlvvkcW0LN
	 AhBEZINADnHBeNl4+lX8oQ5FiwYgA5skIijTP6Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 128/269] net/socket: Break down __sys_setsockopt
Date: Tue, 10 Sep 2024 11:31:55 +0200
Message-ID: <20240910092612.742389904@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 1406245c29454ff84919736be83e14cdaba7fec1 ]

Split __sys_setsockopt() into two functions by removing the core
logic into a sub-function (do_sock_setsockopt()). This will avoid
code duplication when doing the same operation in other callers, for
instance.

do_sock_setsockopt() will be called by io_uring setsockopt() command
operation in the following patch.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/r/20231016134750.1381153-4-leitao@debian.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 33f339a1ba54 ("bpf, net: Fix a potential race in do_sock_getsockopt()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h |  2 ++
 net/socket.c       | 39 +++++++++++++++++++++++++--------------
 2 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 5942b5ff4c78..bb010cc53b91 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1875,6 +1875,8 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 		  sockptr_t optval, unsigned int optlen);
 int sock_setsockopt(struct socket *sock, int level, int op,
 		    sockptr_t optval, unsigned int optlen);
+int do_sock_setsockopt(struct socket *sock, bool compat, int level,
+		       int optname, sockptr_t optval, int optlen);
 
 int sk_getsockopt(struct sock *sk, int level, int optname,
 		  sockptr_t optval, sockptr_t optlen);
diff --git a/net/socket.c b/net/socket.c
index f0f087004728..aa563fc0cee4 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2281,31 +2281,21 @@ static bool sock_use_custom_sol_socket(const struct socket *sock)
 	return test_bit(SOCK_CUSTOM_SOCKOPT, &sock->flags);
 }
 
-/*
- *	Set a socket option. Because we don't know the option lengths we have
- *	to pass the user mode parameter for the protocols to sort out.
- */
-int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
-		int optlen)
+int do_sock_setsockopt(struct socket *sock, bool compat, int level,
+		       int optname, sockptr_t optval, int optlen)
 {
-	sockptr_t optval = USER_SOCKPTR(user_optval);
 	const struct proto_ops *ops;
 	char *kernel_optval = NULL;
-	int err, fput_needed;
-	struct socket *sock;
+	int err;
 
 	if (optlen < 0)
 		return -EINVAL;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (!sock)
-		return err;
-
 	err = security_socket_setsockopt(sock, level, optname);
 	if (err)
 		goto out_put;
 
-	if (!in_compat_syscall())
+	if (!compat)
 		err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level, &optname,
 						     optval, &optlen,
 						     &kernel_optval);
@@ -2328,6 +2318,27 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
 					    optlen);
 	kfree(kernel_optval);
 out_put:
+	return err;
+}
+EXPORT_SYMBOL(do_sock_setsockopt);
+
+/* Set a socket option. Because we don't know the option lengths we have
+ * to pass the user mode parameter for the protocols to sort out.
+ */
+int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
+		     int optlen)
+{
+	sockptr_t optval = USER_SOCKPTR(user_optval);
+	bool compat = in_compat_syscall();
+	int err, fput_needed;
+	struct socket *sock;
+
+	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	if (!sock)
+		return err;
+
+	err = do_sock_setsockopt(sock, compat, level, optname, optval, optlen);
+
 	fput_light(sock->file, fput_needed);
 	return err;
 }
-- 
2.43.0




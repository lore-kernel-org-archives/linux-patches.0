Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0665514A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQeMg3NG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD8AC433C9;
	Mon, 23 Oct 2023 11:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059689;
	bh=xBkJaE+Om76tVCcpYMSGsR9Zdh4UgEZW8zB+l6UT/UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQeMg3NGNlKUoTaTX7o2YDqbRgAMrlF/PlxAA5kESEpTvZfWS5fva1SKoid+QdvSL
	 NLvdKPbnhPWIAwbeM06AoTH9uIK8yAN0EF4B1yGNM3TccvZp/7ejUzqOP/ebbtqEEF
	 utPvuxa4+n0sTD4aXzd9sh3JEfnpQ3+GB9qnbvX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/98] net: use indirect calls helpers at the socket layer
Date: Mon, 23 Oct 2023 12:55:51 +0200
Message-ID: <20231023104813.672778736@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>
References: <20231023104813.580375891@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 8c3c447b3cec27cf6f77080f4d157d53b64e9555 ]

This avoids an indirect call per {send,recv}msg syscall in
the common (IPv6 or IPv4 socket) case.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 86a7e0b69bd5 ("net: prevent rewrite of msg_name in sock_sendmsg()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/socket.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index db9d908198f21..dc4d4ecd6cea2 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -90,6 +90,7 @@
 #include <linux/slab.h>
 #include <linux/xattr.h>
 #include <linux/nospec.h>
+#include <linux/indirect_call_wrapper.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -108,6 +109,13 @@
 #include <net/busy_poll.h>
 #include <linux/errqueue.h>
 
+/* proto_ops for ipv4 and ipv6 use the same {recv,send}msg function */
+#if IS_ENABLED(CONFIG_INET)
+#define INDIRECT_CALL_INET4(f, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
+#else
+#define INDIRECT_CALL_INET4(f, f1, ...) f(__VA_ARGS__)
+#endif
+
 #ifdef CONFIG_NET_RX_BUSY_POLL
 unsigned int sysctl_net_busy_read __read_mostly;
 unsigned int sysctl_net_busy_poll __read_mostly;
@@ -645,10 +653,12 @@ EXPORT_SYMBOL(__sock_tx_timestamp);
  *	Sends @msg through @sock, passing through LSM.
  *	Returns the number of bytes sent, or an error code.
  */
-
+INDIRECT_CALLABLE_DECLARE(int inet_sendmsg(struct socket *, struct msghdr *,
+					   size_t));
 static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
 {
-	int ret = sock->ops->sendmsg(sock, msg, msg_data_left(msg));
+	int ret = INDIRECT_CALL_INET4(sock->ops->sendmsg, inet_sendmsg, sock,
+				      msg, msg_data_left(msg));
 	BUG_ON(ret == -EIOCBQUEUED);
 	return ret;
 }
@@ -852,11 +862,13 @@ EXPORT_SYMBOL_GPL(__sock_recv_ts_and_drops);
  *	Receives @msg from @sock, passing through LSM. Returns the total number
  *	of bytes received, or an error.
  */
-
+INDIRECT_CALLABLE_DECLARE(int inet_recvmsg(struct socket *, struct msghdr *,
+					   size_t , int ));
 static inline int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
 				     int flags)
 {
-	return sock->ops->recvmsg(sock, msg, msg_data_left(msg), flags);
+	return INDIRECT_CALL_INET4(sock->ops->recvmsg, inet_recvmsg, sock, msg,
+				   msg_data_left(msg), flags);
 }
 
 int sock_recvmsg(struct socket *sock, struct msghdr *msg, int flags)
-- 
2.40.1




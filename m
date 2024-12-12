Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F7C22C345;
	Thu, 12 Dec 2024 16:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019356; cv=none; b=j/u4BAP/SW7W0NPBv7cni7Tq+7SbVSj6ZdeDPHjPgJhcNjM45zf2NmY8TKdpUHr3PajwigBEuGIbHwRj2N+g7BDcSMHkcigYQU78cxrzg5oG/poD/VGMiyX8fQ8LLWYpiKLFeSqLnc8DqLLNQ/xrxuO0dagl5277JSkWTOeKTgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019356; c=relaxed/simple;
	bh=Xh0OxhXQJdlb1IASOcyr1MWFJaiPX+TiwvfaBOvV4m0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aa8tuAP0zcQ25yebmu1mhqYqzVUkE6lUjm8kenFl9Qdbu0NEhXKlidQeKvoTR6p3QP3x6cKd0E2PKRpWXXQYRcCEmEm/ftQJCOOfShR7Jp80j22M/cV32BrYBGipcKxhxl6IgcMg5/pkQY7NyRxXdtG9csdq+hdh64Y9ECTuzYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIW1vljj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIW1vljj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E889C4CECE;
	Thu, 12 Dec 2024 16:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019355;
	bh=Xh0OxhXQJdlb1IASOcyr1MWFJaiPX+TiwvfaBOvV4m0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wIW1vljjH9abVh4fNp5Jp8ERHeY4c6TFzgWPLiBXMbzsN+KkNJRhB9y27CFUm3Pod
	 KQvVPi4l+z7+25o0aMtqm9X+ICGhILUlDmQr+yjNQMRWsXvrdyd3KCm1sGrsDudcYN
	 5foU6Z+HEmO7ebnPYtCrWrM+tfIY7kPLFkwLL7Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Guillaume Nault <gnault@redhat.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 185/772] sock_diag: add module pointer to "struct sock_diag_handler"
Date: Thu, 12 Dec 2024 15:52:10 +0100
Message-ID: <20241212144357.587999109@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 114b4bb1cc19239b272d52ebbe156053483fe2f8 ]

Following patch is going to use RCU instead of
sock_diag_table_mutex acquisition.

This patch is a preparation, no change of behavior yet.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: eb02688c5c45 ("ipv6: release nexthop on device removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sock_diag.h | 1 +
 net/ipv4/inet_diag.c      | 2 ++
 net/netlink/diag.c        | 1 +
 net/packet/diag.c         | 1 +
 net/smc/smc_diag.c        | 1 +
 net/tipc/diag.c           | 1 +
 net/unix/diag.c           | 1 +
 net/vmw_vsock/diag.c      | 1 +
 net/xdp/xsk_diag.c        | 1 +
 9 files changed, 10 insertions(+)

diff --git a/include/linux/sock_diag.h b/include/linux/sock_diag.h
index 0b9ecd8cf9793..7c07754d711b9 100644
--- a/include/linux/sock_diag.h
+++ b/include/linux/sock_diag.h
@@ -13,6 +13,7 @@ struct nlmsghdr;
 struct sock;
 
 struct sock_diag_handler {
+	struct module *owner;
 	__u8 family;
 	int (*dump)(struct sk_buff *skb, struct nlmsghdr *nlh);
 	int (*get_info)(struct sk_buff *skb, struct sock *sk);
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index e4e1999d93f50..a3d0e18885f59 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -1397,6 +1397,7 @@ int inet_diag_handler_get_info(struct sk_buff *skb, struct sock *sk)
 }
 
 static const struct sock_diag_handler inet_diag_handler = {
+	.owner = THIS_MODULE,
 	.family = AF_INET,
 	.dump = inet_diag_handler_cmd,
 	.get_info = inet_diag_handler_get_info,
@@ -1404,6 +1405,7 @@ static const struct sock_diag_handler inet_diag_handler = {
 };
 
 static const struct sock_diag_handler inet6_diag_handler = {
+	.owner = THIS_MODULE,
 	.family = AF_INET6,
 	.dump = inet_diag_handler_cmd,
 	.get_info = inet_diag_handler_get_info,
diff --git a/net/netlink/diag.c b/net/netlink/diag.c
index 9c4f231be2757..7b15aa5f7bc20 100644
--- a/net/netlink/diag.c
+++ b/net/netlink/diag.c
@@ -241,6 +241,7 @@ static int netlink_diag_handler_dump(struct sk_buff *skb, struct nlmsghdr *h)
 }
 
 static const struct sock_diag_handler netlink_diag_handler = {
+	.owner = THIS_MODULE,
 	.family = AF_NETLINK,
 	.dump = netlink_diag_handler_dump,
 };
diff --git a/net/packet/diag.c b/net/packet/diag.c
index a68a84574c739..057ee37bd0766 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -245,6 +245,7 @@ static int packet_diag_handler_dump(struct sk_buff *skb, struct nlmsghdr *h)
 }
 
 static const struct sock_diag_handler packet_diag_handler = {
+	.owner = THIS_MODULE,
 	.family = AF_PACKET,
 	.dump = packet_diag_handler_dump,
 };
diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
index 7a907186a33ae..2d1cd033398b6 100644
--- a/net/smc/smc_diag.c
+++ b/net/smc/smc_diag.c
@@ -249,6 +249,7 @@ static int smc_diag_handler_dump(struct sk_buff *skb, struct nlmsghdr *h)
 }
 
 static const struct sock_diag_handler smc_diag_handler = {
+	.owner = THIS_MODULE,
 	.family = AF_SMC,
 	.dump = smc_diag_handler_dump,
 };
diff --git a/net/tipc/diag.c b/net/tipc/diag.c
index 73137f4aeb68f..11da9d2ebbf69 100644
--- a/net/tipc/diag.c
+++ b/net/tipc/diag.c
@@ -95,6 +95,7 @@ static int tipc_sock_diag_handler_dump(struct sk_buff *skb,
 }
 
 static const struct sock_diag_handler tipc_sock_diag_handler = {
+	.owner = THIS_MODULE,
 	.family = AF_TIPC,
 	.dump = tipc_sock_diag_handler_dump,
 };
diff --git a/net/unix/diag.c b/net/unix/diag.c
index 1de7500b41b61..a6bd861314df0 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -322,6 +322,7 @@ static int unix_diag_handler_dump(struct sk_buff *skb, struct nlmsghdr *h)
 }
 
 static const struct sock_diag_handler unix_diag_handler = {
+	.owner = THIS_MODULE,
 	.family = AF_UNIX,
 	.dump = unix_diag_handler_dump,
 };
diff --git a/net/vmw_vsock/diag.c b/net/vmw_vsock/diag.c
index a2823b1c5e28b..6efa9eb93336f 100644
--- a/net/vmw_vsock/diag.c
+++ b/net/vmw_vsock/diag.c
@@ -157,6 +157,7 @@ static int vsock_diag_handler_dump(struct sk_buff *skb, struct nlmsghdr *h)
 }
 
 static const struct sock_diag_handler vsock_diag_handler = {
+	.owner = THIS_MODULE,
 	.family = AF_VSOCK,
 	.dump = vsock_diag_handler_dump,
 };
diff --git a/net/xdp/xsk_diag.c b/net/xdp/xsk_diag.c
index 22b36c8143cfd..e1012bfec7207 100644
--- a/net/xdp/xsk_diag.c
+++ b/net/xdp/xsk_diag.c
@@ -194,6 +194,7 @@ static int xsk_diag_handler_dump(struct sk_buff *nlskb, struct nlmsghdr *hdr)
 }
 
 static const struct sock_diag_handler xsk_diag_handler = {
+	.owner = THIS_MODULE,
 	.family = AF_XDP,
 	.dump = xsk_diag_handler_dump,
 };
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7E415B96C;
	Mon, 29 Jan 2024 17:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548127; cv=none; b=h6fNeE1gLFv4H70DAu7oIsV/dCTK48JoeO8ALgrJrJP1lcTOPFLPIEFw/q5FlV7IJRMoUWTeQ+YNB2hM7BqJmqvdL0if+w1qVDHqeOXP7bzqepC+mP71FOpQNux/n09ylQHWm71snR9PF2YC09A+5w7FRWtahtllUfqOMXfpq3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548127; c=relaxed/simple;
	bh=fZ+6iLCO4TgWlfRDO74m3xyJRTi9/eHSeWHXqZEOkFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKTaIkwm14SmVizFkRZRrLzKUflyUtU95WGv7kRucNG2b/r+MugKDknvpUUozjgJ1KkuIfP7wdo0I0KcTabBjIMYY7mavhCmtZGaR8qSi7vy4lBb7wcc65/bVJPmVMPxUp05aGSQLm+F2Qgsa72Xl8dwX74wQ/kdMXPlZWDOYN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkc8gkXt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkc8gkXt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AC7C433C7;
	Mon, 29 Jan 2024 17:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548127;
	bh=fZ+6iLCO4TgWlfRDO74m3xyJRTi9/eHSeWHXqZEOkFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkc8gkXtFrITJai3nbVswIn89wsV91/fI3UeUTyDoND/9Ut/TGgdcWU3tzPDC8yBI
	 PLw0XPcadwRgDEMTul8mrQ41hQK4Y+u1wrNnJ7gTNMupPN8SCz/QggkWDUT32bPlFV
	 PrNdBtvwSybkP/Rha5gqaNECWf/hl+eT+uw7Dq/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 156/346] udp: fix busy polling
Date: Mon, 29 Jan 2024 09:03:07 -0800
Message-ID: <20240129170020.995819337@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a54d51fb2dfb846aedf3751af501e9688db447f5 ]

Generic sk_busy_loop_end() only looks at sk->sk_receive_queue
for presence of packets.

Problem is that for UDP sockets after blamed commit, some packets
could be present in another queue: udp_sk(sk)->reader_queue

In some cases, a busy poller could spin until timeout expiration,
even if some packets are available in udp_sk(sk)->reader_queue.

v3: - make sk_busy_loop_end() nicer (Willem)

v2: - add a READ_ONCE(sk->sk_family) in sk_is_inet() to avoid KCSAN splats.
    - add a sk_is_inet() check in sk_is_udp() (Willem feedback)
    - add a sk_is_inet() check in sk_is_tcp().

Fixes: 2276f58ac589 ("udp: use a separate rx queue for packet reception")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h   |  6 ------
 include/net/inet_sock.h |  5 -----
 include/net/sock.h      | 18 +++++++++++++++++-
 net/core/sock.c         | 11 +++++++++--
 4 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index c953b8c0d2f4..bd4418377bac 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -500,12 +500,6 @@ static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
 	return !!psock->saved_data_ready;
 }
 
-static inline bool sk_is_udp(const struct sock *sk)
-{
-	return sk->sk_type == SOCK_DGRAM &&
-	       sk->sk_protocol == IPPROTO_UDP;
-}
-
 #if IS_ENABLED(CONFIG_NET_SOCK_MSG)
 
 #define BPF_F_STRPARSER	(1UL << 1)
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 74db6d97cae1..8d5fe15b0f6f 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -310,11 +310,6 @@ static inline unsigned long inet_cmsg_flags(const struct inet_sock *inet)
 #define inet_assign_bit(nr, sk, val)		\
 	assign_bit(INET_FLAGS_##nr, &inet_sk(sk)->inet_flags, val)
 
-static inline bool sk_is_inet(struct sock *sk)
-{
-	return sk->sk_family == AF_INET || sk->sk_family == AF_INET6;
-}
-
 /**
  * sk_to_full_sk - Access to a full socket
  * @sk: pointer to a socket
diff --git a/include/net/sock.h b/include/net/sock.h
index 0201136b0b9c..f9a9f61fa122 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2794,9 +2794,25 @@ static inline void skb_setup_tx_timestamp(struct sk_buff *skb, __u16 tsflags)
 			   &skb_shinfo(skb)->tskey);
 }
 
+static inline bool sk_is_inet(const struct sock *sk)
+{
+	int family = READ_ONCE(sk->sk_family);
+
+	return family == AF_INET || family == AF_INET6;
+}
+
 static inline bool sk_is_tcp(const struct sock *sk)
 {
-	return sk->sk_type == SOCK_STREAM && sk->sk_protocol == IPPROTO_TCP;
+	return sk_is_inet(sk) &&
+	       sk->sk_type == SOCK_STREAM &&
+	       sk->sk_protocol == IPPROTO_TCP;
+}
+
+static inline bool sk_is_udp(const struct sock *sk)
+{
+	return sk_is_inet(sk) &&
+	       sk->sk_type == SOCK_DGRAM &&
+	       sk->sk_protocol == IPPROTO_UDP;
 }
 
 static inline bool sk_is_stream_unix(const struct sock *sk)
diff --git a/net/core/sock.c b/net/core/sock.c
index d02534c77413..e5d43a068f8e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -107,6 +107,7 @@
 #include <linux/interrupt.h>
 #include <linux/poll.h>
 #include <linux/tcp.h>
+#include <linux/udp.h>
 #include <linux/init.h>
 #include <linux/highmem.h>
 #include <linux/user_namespace.h>
@@ -4148,8 +4149,14 @@ bool sk_busy_loop_end(void *p, unsigned long start_time)
 {
 	struct sock *sk = p;
 
-	return !skb_queue_empty_lockless(&sk->sk_receive_queue) ||
-	       sk_busy_loop_timeout(sk, start_time);
+	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
+		return true;
+
+	if (sk_is_udp(sk) &&
+	    !skb_queue_empty_lockless(&udp_sk(sk)->reader_queue))
+		return true;
+
+	return sk_busy_loop_timeout(sk, start_time);
 }
 EXPORT_SYMBOL(sk_busy_loop_end);
 #endif /* CONFIG_NET_RX_BUSY_POLL */
-- 
2.43.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE02A15703D;
	Mon, 29 Jan 2024 17:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548307; cv=none; b=QhDvhRutWe6oyy+UvtfUs1WVceUMPLCwQizIKthzldXDbwZUe3lGI/otb1RKsSI7A+AWhKrUQ/5tDBmLUkhiOd82VbB3On8mgFLQQAPqDOP44s+rkSh4QxmUF60sq1dKfQQB0N5Uhp5W2BJ6I6icIRQ+nDNuarrkbresLsmIMWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548307; c=relaxed/simple;
	bh=DTrcmHk3baqMVCFjzAOnvpl6yLAnm91wl/OnO+a5ofk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntQ1wZ9o/fzrFVEpXZM+DSjQCxRNel+OfAKtcliNR7cDCRFImV6FsF26ugCVMSj34gwZnB0BLjBE2KSQ6geaiSA9BhP0KzT0Jz7zsDCq2AEGdaHnmrEG1RU3EIPCafKzWl1Yg9sEefl8hO5MrDcH9sIbzk0CN+o4wqsk5iZHT5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=raCAn+/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="raCAn+/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64BEC433F1;
	Mon, 29 Jan 2024 17:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548306;
	bh=DTrcmHk3baqMVCFjzAOnvpl6yLAnm91wl/OnO+a5ofk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=raCAn+/GHjxinlm8LZqY+H6t03e7Nd7RUt+N9lOYeMnFiUmHcYwfIEI7BHe4zqs5a
	 DulPCysr17yChTpDcMneZimmYEI4D4VKcTvuJlv3DK4ZkQMUI+REgEnyrFWGU7F+kK
	 Pb5ZGObYrwO0S9MI/QporhmR10Me6yb78bV5O2h8=
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
Subject: [PATCH 6.1 083/185] udp: fix busy polling
Date: Mon, 29 Jan 2024 09:04:43 -0800
Message-ID: <20240129170001.267320680@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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
index c2432c2addc8..c98890e21401 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -270,11 +270,6 @@ struct inet_sock {
 #define IP_CMSG_CHECKSUM	BIT(7)
 #define IP_CMSG_RECVFRAGSIZE	BIT(8)
 
-static inline bool sk_is_inet(struct sock *sk)
-{
-	return sk->sk_family == AF_INET || sk->sk_family == AF_INET6;
-}
-
 /**
  * sk_to_full_sk - Access to a full socket
  * @sk: pointer to a socket
diff --git a/include/net/sock.h b/include/net/sock.h
index 6b51e85ae69e..579732d47dfc 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2824,9 +2824,25 @@ static inline void skb_setup_tx_timestamp(struct sk_buff *skb, __u16 tsflags)
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
index c50a14a02edd..c8803b95ea0d 100644
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
@@ -4109,8 +4110,14 @@ bool sk_busy_loop_end(void *p, unsigned long start_time)
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




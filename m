Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3240973722;
	Mon, 29 Jan 2024 17:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548538; cv=none; b=gp6dcCgMC4w8VGHE6YMN9fO8xf2xiCu9WqJGTprFx5dezZFU5ZkQK7/4zHurBkv6RE2hyjJqQjBOpLWj6iCpWu/Aa3YFTKZXHRlcOuDBvBSHGOjK+xu0ySsp/lKhMjAepB3JvnSRBlyjXlgvIZubA7SggO2Z553bLCvY53W/HaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548538; c=relaxed/simple;
	bh=2TQk6OswGj1XiKG0KEQcGnPvMY1CiJXiPLYL/RG+gU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+uzcHqDt/MBo1GfyP4wp8Pk3klyrtowSfj7vcxhw6JjUffehbPAoTgPYiGhRtrVZx71YNH9NdHY2E956NbSJ2YoGvRVY7Ll+k5uDVbo5Ggnt+HHG713PCfEuKNXbsi5oLv1h9V00OtZMLXtY8NUsVOl+qwSFYNtV22o3OMDg+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cU/8DEqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cU/8DEqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2CBC433C7;
	Mon, 29 Jan 2024 17:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548538;
	bh=2TQk6OswGj1XiKG0KEQcGnPvMY1CiJXiPLYL/RG+gU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cU/8DEqEfIe8lPpguJflOwHMpacwqlzHDvdPHy4o1PXTXFjWA9M5hh+DZ67q8JMXE
	 FPKaVuM/N7sWNFqamaxiyGxErGUbgcBCaOA+0ZRq3rq0YIRm4+KQNju2oDbdFU+dz6
	 mwsvBUtPtCmNMdLCDSoBbAQrOIURc1RvCB/GsHns=
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
Subject: [PATCH 6.6 177/331] udp: fix busy polling
Date: Mon, 29 Jan 2024 09:04:01 -0800
Message-ID: <20240129170020.087034986@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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
index 2de0e4d4a027..2790ba58ffe5 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -301,11 +301,6 @@ static inline unsigned long inet_cmsg_flags(const struct inet_sock *inet)
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
index 70a771d96467..e70c903b04f3 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2793,9 +2793,25 @@ static inline void skb_setup_tx_timestamp(struct sk_buff *skb, __u16 tsflags)
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
index 5cd21e699f2d..383e30fe79f4 100644
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
@@ -4136,8 +4137,14 @@ bool sk_busy_loop_end(void *p, unsigned long start_time)
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




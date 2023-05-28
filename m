Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07D9611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C595C433EF;
	Sun, 28 May 2023 19:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301417;
	bh=sKPhx/jHu4zoymasg7Zmc2F7b3BKrPyY0EVLgrfEQfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zF4xILBltO61V5B+QpE4b95u5SHNW1RLfjDsPMO9WHBnUQ2bCy30KbS2Yx6CpZeb/
	 3IK8i0gxRvi12oRv/YEhfAtRBs/d+bmxkeLNfKFQgcfP6a1s4xZbxO9Xn/gEyi/QPq
	 4AJq4+b53MgK8nC7q/Q4N+E18Lsur0bbmj8zt3Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Soheil Hassas Yeganeh <soheil@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 004/132] tcp: reduce POLLOUT events caused by TCP_NOTSENT_LOWAT
Date: Sun, 28 May 2023 20:09:03 +0100
Message-Id: <20230528190833.698687214@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a74f0fa082b76c6a76cba5672f36218518bfdc09 ]

TCP_NOTSENT_LOWAT socket option or sysctl was added in linux-3.12
as a step to enable bigger tcp sndbuf limits.

It works reasonably well, but the following happens :

Once the limit is reached, TCP stack generates
an [E]POLLOUT event for every incoming ACK packet.

This causes a high number of context switches.

This patch implements the strategy David Miller added
in sock_def_write_space() :

 - If TCP socket has a notsent_lowat constraint of X bytes,
   allow sendmsg() to fill up to X bytes, but send [E]POLLOUT
   only if number of notsent bytes is below X/2

This considerably reduces TCP_NOTSENT_LOWAT overhead,
while allowing to keep the pipe full.

Tested:
 100 ms RTT netem testbed between A and B, 100 concurrent TCP_STREAM

A:/# cat /proc/sys/net/ipv4/tcp_wmem
4096	262144	64000000
A:/# super_netperf 100 -H B -l 1000 -- -K bbr &

A:/# grep TCP /proc/net/sockstat
TCP: inuse 203 orphan 0 tw 19 alloc 414 mem 1364904 # This is about 54 MB of memory per flow :/

A:/# vmstat 5 5
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 0  0      0 256220672  13532 694976    0    0    10     0   28   14  0  1 99  0  0
 2  0      0 256320016  13532 698480    0    0   512     0 715901 5927  0 10 90  0  0
 0  0      0 256197232  13532 700992    0    0   735    13 771161 5849  0 11 89  0  0
 1  0      0 256233824  13532 703320    0    0   512    23 719650 6635  0 11 89  0  0
 2  0      0 256226880  13532 705780    0    0   642     4 775650 6009  0 12 88  0  0

A:/# echo 2097152 >/proc/sys/net/ipv4/tcp_notsent_lowat

A:/# grep TCP /proc/net/sockstat
TCP: inuse 203 orphan 0 tw 19 alloc 414 mem 86411 # 3.5 MB per flow

A:/# vmstat 5 5  # check that context switches have not inflated too much.
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 2  0      0 260386512  13592 662148    0    0    10     0   17   14  0  1 99  0  0
 0  0      0 260519680  13592 604184    0    0   512    13 726843 12424  0 10 90  0  0
 1  1      0 260435424  13592 598360    0    0   512    25 764645 12925  0 10 90  0  0
 1  0      0 260855392  13592 578380    0    0   512     7 722943 13624  0 11 88  0  0
 1  0      0 260445008  13592 601176    0    0   614    34 772288 14317  0 10 90  0  0

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e14cadfd80d7 ("tcp: add annotations around sk->sk_shutdown accesses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 20 +++++++++++++++-----
 include/net/tcp.h  |  8 ++++++--
 net/core/stream.c  |  2 +-
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 629cc89b7f0e4..cfbd241935a30 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1130,7 +1130,7 @@ struct proto {
 	unsigned int		inuse_idx;
 #endif
 
-	bool			(*stream_memory_free)(const struct sock *sk);
+	bool			(*stream_memory_free)(const struct sock *sk, int wake);
 	bool			(*stream_memory_read)(const struct sock *sk);
 	/* Memory pressure */
 	void			(*enter_memory_pressure)(struct sock *sk);
@@ -1212,19 +1212,29 @@ static inline void sk_refcnt_debug_release(const struct sock *sk)
 #define sk_refcnt_debug_release(sk) do { } while (0)
 #endif /* SOCK_REFCNT_DEBUG */
 
-static inline bool sk_stream_memory_free(const struct sock *sk)
+static inline bool __sk_stream_memory_free(const struct sock *sk, int wake)
 {
 	if (sk->sk_wmem_queued >= sk->sk_sndbuf)
 		return false;
 
 	return sk->sk_prot->stream_memory_free ?
-		sk->sk_prot->stream_memory_free(sk) : true;
+		sk->sk_prot->stream_memory_free(sk, wake) : true;
 }
 
-static inline bool sk_stream_is_writeable(const struct sock *sk)
+static inline bool sk_stream_memory_free(const struct sock *sk)
+{
+	return __sk_stream_memory_free(sk, 0);
+}
+
+static inline bool __sk_stream_is_writeable(const struct sock *sk, int wake)
 {
 	return sk_stream_wspace(sk) >= sk_stream_min_wspace(sk) &&
-	       sk_stream_memory_free(sk);
+	       __sk_stream_memory_free(sk, wake);
+}
+
+static inline bool sk_stream_is_writeable(const struct sock *sk)
+{
+	return __sk_stream_is_writeable(sk, 0);
 }
 
 static inline int sk_under_cgroup_hierarchy(struct sock *sk,
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9a154fe06c60d..9e37f3912ff19 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1884,12 +1884,16 @@ static inline u32 tcp_notsent_lowat(const struct tcp_sock *tp)
 	return tp->notsent_lowat ?: READ_ONCE(net->ipv4.sysctl_tcp_notsent_lowat);
 }
 
-static inline bool tcp_stream_memory_free(const struct sock *sk)
+/* @wake is one when sk_stream_write_space() calls us.
+ * This sends EPOLLOUT only if notsent_bytes is half the limit.
+ * This mimics the strategy used in sock_def_write_space().
+ */
+static inline bool tcp_stream_memory_free(const struct sock *sk, int wake)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	u32 notsent_bytes = READ_ONCE(tp->write_seq) - tp->snd_nxt;
 
-	return notsent_bytes < tcp_notsent_lowat(tp);
+	return (notsent_bytes << wake) < tcp_notsent_lowat(tp);
 }
 
 #ifdef CONFIG_PROC_FS
diff --git a/net/core/stream.c b/net/core/stream.c
index 23e6669d3f8d2..cd60746877b1e 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -32,7 +32,7 @@ void sk_stream_write_space(struct sock *sk)
 	struct socket *sock = sk->sk_socket;
 	struct socket_wq *wq;
 
-	if (sk_stream_is_writeable(sk) && sock) {
+	if (__sk_stream_is_writeable(sk, 1) && sock) {
 		clear_bit(SOCK_NOSPACE, &sock->flags);
 
 		rcu_read_lock();
-- 
2.39.2




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D9B3064A4;
	Sat, 25 Oct 2025 16:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408933; cv=none; b=BOsmuDyQdIooZJ91QSNeILCepEB5GRgBpTwARoMjJ/PHBr2adud5vinPVsMfK/GELFe8iItisALQSQs5mfCpxaSX/AYlRGaHI+NOjOa/LpynooprNkwXspxIWcXQ4Hj2Yky2Yb/0kW2NCnOUz2Xf9kjCnBgAfAJQN/p0qwqG33g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408933; c=relaxed/simple;
	bh=Y4BzcZ9tcJlc2uDydHrRVqoVntNvpKSQkwr746If3vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tvfUFyCAx0bJ8dtlpA3LyDriRHNyEVS3WdNstug6a1DiIRuexFkoXcWvc6PxSZ+so7nqjUXJgrLNhlKWaKKH3D0XvMwguxX8HXFc8Jk8FYoSA1DKO5hikte3YuWEc02nun8BXCCrN/YhLBeIq6PaQjUv94NCQ1kUDP3Hl/YtBQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qi0n8Wul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qi0n8Wul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B4AC4CEFB;
	Sat, 25 Oct 2025 16:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408933;
	bh=Y4BzcZ9tcJlc2uDydHrRVqoVntNvpKSQkwr746If3vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qi0n8WulKFCQfuHiRucjwOri+DAfcmjy7VYoSuSUZUn/w/nCE2rqI24HnfQyqYN66
	 xs2nE/F6fjsdCT7ic7/0GmrQIh1v1EjERIyxksCyE6VlxKS+jqRlxEQjdEMAmuaHdw
	 kftAXBqSWAVfRVcZ8+c01Jd5kT3oxgd5NJlyPaXUU144TGAvqh5QNafJtoFxYqJGQc
	 rrVfZd6Far1DX/HIaqAEuzCIDditQV8mOZiVL3FdCo7Da+JTADtA7dS7T2zqPKrgzJ
	 MHCY/Xscz/+ga9B4pynflfp3m2QYU4yWhFJT4SO/tma0Syk+NHu3NY9luc77pTRZPl
	 t5B8x1lmnOq0w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Sitnicki <jakub@cloudflare.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	willemb@google.com,
	ncardwell@google.com,
	dsahern@kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] tcp: Update bind bucket state on port release
Date: Sat, 25 Oct 2025 11:56:09 -0400
Message-ID: <20251025160905.3857885-138-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit d57f4b874946e997be52f5ebb5e0e1dad368c16f ]

Today, once an inet_bind_bucket enters a state where fastreuse >= 0 or
fastreuseport >= 0 after a socket is explicitly bound to a port, it remains
in that state until all sockets are removed and the bucket is destroyed.

In this state, the bucket is skipped during ephemeral port selection in
connect(). For applications using a reduced ephemeral port
range (IP_LOCAL_PORT_RANGE socket option), this can cause faster port
exhaustion since blocked buckets are excluded from reuse.

The reason the bucket state isn't updated on port release is unclear.
Possibly a performance trade-off to avoid scanning bucket owners, or just
an oversight.

Fix it by recalculating the bucket state when a socket releases a port. To
limit overhead, each inet_bind2_bucket stores its own (fastreuse,
fastreuseport) state. On port release, only the relevant port-addr bucket
is scanned, and the overall state is derived from these.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250917-update-bind-bucket-state-on-unhash-v5-1-57168b661b47@cloudflare.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – this fixes a real port-exhaustion bug without introducing invasive
redesign, and the risk of regression looks manageable.

- **Bug visibility**: `__inet_hash_connect()` refuses ports whenever
  `fastreuse >= 0 || fastreuseport >= 0`
  (`net/ipv4/inet_hashtables.c:1095-1116`). Once a port bucket hits that
  state because of an explicit bind, it never returns to -1, so future
  auto-`connect()` calls skip the entire bucket even after the binders
  are gone—triggering premature `EADDRNOTAVAIL` for workloads that
  narrow `IP_LOCAL_PORT_RANGE`.
- **Fix mechanics**: Each per-(port,addr) bucket now tracks its own
  fastreuse state (`include/net/inet_hashtables.h:111-112`). Auto-bound
  sockets are tagged via the new `SOCK_CONNECT_BIND` bit
  (`include/net/sock.h:1498-1500`, set in `inet_hash_connect()` at
  `net/ipv4/inet_hashtables.c:1156-1177` and copied into time-wait state
  at `net/ipv4/inet_timewait_sock.c:211`). When such a socket releases
  the port, `inet_bind2_bucket_destroy()` notices that all remaining
  owners are `SOCK_CONNECT_BIND` and flips the per-bucket state back to
  -1 (`net/ipv4/inet_hashtables.c:166-184`), and
  `inet_bind_bucket_destroy()` bubbles that up to the whole port bucket
  (`net/ipv4/inet_hashtables.c:96-113`). This makes the port eligible
  again for the allocator, eliminating the exhaustion scenario
  described.
- **State hygiene**: The commit consistently clears the tag during
  unhash (`net/ipv4/inet_hashtables.c:215-241`) and even handles address
  rebinds (`net/ipv4/inet_hashtables.c:962-999`), so the fastreuse cache
  can be rebuilt accurately without scanning unrelated sockets.
- **Risk check**: Changes are confined to TCP/DCCP bind bookkeeping;
  data structures touched are internal, and the extra scans run only
  while holding the existing locks. No external ABI changes, and there
  are no follow-up fixes in tree, so the patch is self-contained.
  Remaining risk is moderate (core TCP paths), but the logic mirrors
  existing fastreuse handling and should backport cleanly.
- **Next step**: Validate by reproducing a tight `IP_LOCAL_PORT_RANGE`
  workload before/after the backport to confirm the allocator now
  recycles ports as expected.

Given the clear user-visible failure and the contained nature of the
fix, this is a good stable-candidate.

 include/net/inet_connection_sock.h |  5 ++--
 include/net/inet_hashtables.h      |  2 ++
 include/net/inet_timewait_sock.h   |  3 +-
 include/net/sock.h                 |  4 +++
 net/ipv4/inet_connection_sock.c    | 12 +++++---
 net/ipv4/inet_hashtables.c         | 44 +++++++++++++++++++++++++++++-
 net/ipv4/inet_timewait_sock.c      |  1 +
 7 files changed, 63 insertions(+), 8 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 1735db332aab5..072347f164830 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -322,8 +322,9 @@ int inet_csk_listen_start(struct sock *sk);
 void inet_csk_listen_stop(struct sock *sk);
 
 /* update the fast reuse flag when adding a socket */
-void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
-			       struct sock *sk);
+void inet_csk_update_fastreuse(const struct sock *sk,
+			       struct inet_bind_bucket *tb,
+			       struct inet_bind2_bucket *tb2);
 
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
 
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 19dbd9081d5a5..d6676746dabfe 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -108,6 +108,8 @@ struct inet_bind2_bucket {
 	struct hlist_node	bhash_node;
 	/* List of sockets hashed to this bucket */
 	struct hlist_head	owners;
+	signed char		fastreuse;
+	signed char		fastreuseport;
 };
 
 static inline struct net *ib_net(const struct inet_bind_bucket *ib)
diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index 67a3135757809..baafef24318e0 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -70,7 +70,8 @@ struct inet_timewait_sock {
 	unsigned int		tw_transparent  : 1,
 				tw_flowlabel	: 20,
 				tw_usec_ts	: 1,
-				tw_pad		: 2,	/* 2 bits hole */
+				tw_connect_bind	: 1,
+				tw_pad		: 1,	/* 1 bit hole */
 				tw_tos		: 8;
 	u32			tw_txhash;
 	u32			tw_priority;
diff --git a/include/net/sock.h b/include/net/sock.h
index 2e14283c5be1a..57c0df29ee964 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1488,6 +1488,10 @@ static inline int __sk_prot_rehash(struct sock *sk)
 
 #define SOCK_BINDADDR_LOCK	4
 #define SOCK_BINDPORT_LOCK	8
+/**
+ * define SOCK_CONNECT_BIND - &sock->sk_userlocks flag for auto-bind at connect() time
+ */
+#define SOCK_CONNECT_BIND	16
 
 struct socket_alloc {
 	struct socket socket;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 1e2df51427fed..0076c67d9bd41 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -423,7 +423,7 @@ inet_csk_find_open_port(const struct sock *sk, struct inet_bind_bucket **tb_ret,
 }
 
 static inline int sk_reuseport_match(struct inet_bind_bucket *tb,
-				     struct sock *sk)
+				     const struct sock *sk)
 {
 	if (tb->fastreuseport <= 0)
 		return 0;
@@ -453,8 +453,9 @@ static inline int sk_reuseport_match(struct inet_bind_bucket *tb,
 				    ipv6_only_sock(sk), true, false);
 }
 
-void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
-			       struct sock *sk)
+void inet_csk_update_fastreuse(const struct sock *sk,
+			       struct inet_bind_bucket *tb,
+			       struct inet_bind2_bucket *tb2)
 {
 	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
 
@@ -501,6 +502,9 @@ void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
 			tb->fastreuseport = 0;
 		}
 	}
+
+	tb2->fastreuse = tb->fastreuse;
+	tb2->fastreuseport = tb->fastreuseport;
 }
 
 /* Obtain a reference to a local port for the given sock,
@@ -582,7 +586,7 @@ int inet_csk_get_port(struct sock *sk, unsigned short snum)
 	}
 
 success:
-	inet_csk_update_fastreuse(tb, sk);
+	inet_csk_update_fastreuse(sk, tb, tb2);
 
 	if (!inet_csk(sk)->icsk_bind_hash)
 		inet_bind_hash(sk, tb, tb2, port);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index ceeeec9b7290a..4316c127f7896 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -58,6 +58,14 @@ static u32 sk_ehashfn(const struct sock *sk)
 			    sk->sk_daddr, sk->sk_dport);
 }
 
+static bool sk_is_connect_bind(const struct sock *sk)
+{
+	if (sk->sk_state == TCP_TIME_WAIT)
+		return inet_twsk(sk)->tw_connect_bind;
+	else
+		return sk->sk_userlocks & SOCK_CONNECT_BIND;
+}
+
 /*
  * Allocate and initialize a new local port bind bucket.
  * The bindhash mutex for snum's hash chain must be held here.
@@ -87,10 +95,22 @@ struct inet_bind_bucket *inet_bind_bucket_create(struct kmem_cache *cachep,
  */
 void inet_bind_bucket_destroy(struct inet_bind_bucket *tb)
 {
+	const struct inet_bind2_bucket *tb2;
+
 	if (hlist_empty(&tb->bhash2)) {
 		hlist_del_rcu(&tb->node);
 		kfree_rcu(tb, rcu);
+		return;
+	}
+
+	if (tb->fastreuse == -1 && tb->fastreuseport == -1)
+		return;
+	hlist_for_each_entry(tb2, &tb->bhash2, bhash_node) {
+		if (tb2->fastreuse != -1 || tb2->fastreuseport != -1)
+			return;
 	}
+	tb->fastreuse = -1;
+	tb->fastreuseport = -1;
 }
 
 bool inet_bind_bucket_match(const struct inet_bind_bucket *tb, const struct net *net,
@@ -121,6 +141,8 @@ static void inet_bind2_bucket_init(struct inet_bind2_bucket *tb2,
 #else
 	tb2->rcv_saddr = sk->sk_rcv_saddr;
 #endif
+	tb2->fastreuse = 0;
+	tb2->fastreuseport = 0;
 	INIT_HLIST_HEAD(&tb2->owners);
 	hlist_add_head(&tb2->node, &head->chain);
 	hlist_add_head(&tb2->bhash_node, &tb->bhash2);
@@ -143,11 +165,23 @@ struct inet_bind2_bucket *inet_bind2_bucket_create(struct kmem_cache *cachep,
 /* Caller must hold hashbucket lock for this tb with local BH disabled */
 void inet_bind2_bucket_destroy(struct kmem_cache *cachep, struct inet_bind2_bucket *tb)
 {
+	const struct sock *sk;
+
 	if (hlist_empty(&tb->owners)) {
 		__hlist_del(&tb->node);
 		__hlist_del(&tb->bhash_node);
 		kmem_cache_free(cachep, tb);
+		return;
 	}
+
+	if (tb->fastreuse == -1 && tb->fastreuseport == -1)
+		return;
+	sk_for_each_bound(sk, &tb->owners) {
+		if (!sk_is_connect_bind(sk))
+			return;
+	}
+	tb->fastreuse = -1;
+	tb->fastreuseport = -1;
 }
 
 static bool inet_bind2_bucket_addr_match(const struct inet_bind2_bucket *tb2,
@@ -191,6 +225,7 @@ static void __inet_put_port(struct sock *sk)
 	tb = inet_csk(sk)->icsk_bind_hash;
 	inet_csk(sk)->icsk_bind_hash = NULL;
 	inet_sk(sk)->inet_num = 0;
+	sk->sk_userlocks &= ~SOCK_CONNECT_BIND;
 
 	spin_lock(&head2->lock);
 	if (inet_csk(sk)->icsk_bind2_hash) {
@@ -277,7 +312,7 @@ int __inet_inherit_port(const struct sock *sk, struct sock *child)
 		}
 	}
 	if (update_fastreuse)
-		inet_csk_update_fastreuse(tb, child);
+		inet_csk_update_fastreuse(child, tb, tb2);
 	inet_bind_hash(child, tb, tb2, port);
 	spin_unlock(&head2->lock);
 	spin_unlock(&head->lock);
@@ -966,6 +1001,10 @@ static int __inet_bhash2_update_saddr(struct sock *sk, void *saddr, int family,
 	if (!tb2) {
 		tb2 = new_tb2;
 		inet_bind2_bucket_init(tb2, net, head2, inet_csk(sk)->icsk_bind_hash, sk);
+		if (sk_is_connect_bind(sk)) {
+			tb2->fastreuse = -1;
+			tb2->fastreuseport = -1;
+		}
 	}
 	inet_csk(sk)->icsk_bind2_hash = tb2;
 	sk_add_bind_node(sk, &tb2->owners);
@@ -1136,6 +1175,8 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 					       head2, tb, sk);
 		if (!tb2)
 			goto error;
+		tb2->fastreuse = -1;
+		tb2->fastreuseport = -1;
 	}
 
 	/* Here we want to add a little bit of randomness to the next source
@@ -1148,6 +1189,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 
 	/* Head lock still held and bh's disabled */
 	inet_bind_hash(sk, tb, tb2, port);
+	sk->sk_userlocks |= SOCK_CONNECT_BIND;
 
 	if (sk_unhashed(sk)) {
 		inet_sk(sk)->inet_sport = htons(port);
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index 875ff923a8ed0..6fb9efdbee27a 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -206,6 +206,7 @@ struct inet_timewait_sock *inet_twsk_alloc(const struct sock *sk,
 		tw->tw_hash	    = sk->sk_hash;
 		tw->tw_ipv6only	    = 0;
 		tw->tw_transparent  = inet_test_bit(TRANSPARENT, sk);
+		tw->tw_connect_bind = !!(sk->sk_userlocks & SOCK_CONNECT_BIND);
 		tw->tw_prot	    = sk->sk_prot_creator;
 		atomic64_set(&tw->tw_cookie, atomic64_read(&sk->sk_cookie));
 		twsk_net_set(tw, sock_net(sk));
-- 
2.51.0


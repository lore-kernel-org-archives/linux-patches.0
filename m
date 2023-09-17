Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9D17461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCCBC433C8;
	Sun, 17 Sep 2023 20:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981274;
	bh=ma9l2Z63pVzispQw9EBBWnEpB9nvwLT+yW3bw5H9bOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjFhE330u67+Cj3mYZ5JsgrXIlOA01ss03CP5pcn7A04qKUO+waoXZRkoAl92iOU7
	 LuzPLc1EuDMv4xkLV+LLMfN9SaGyzp+1T69a92YLPXGrasoAp2x4rSHSFbjfrdTRP2
	 Mpn+lLGIyCR+FSlNvWjbXLK1X465rX+lYvHsV8uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/219] net: annotate data-races around sk->sk_forward_alloc
Date: Sun, 17 Sep 2023 21:13:45 +0200
Message-ID: <20230917191044.512526487@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

[ Upstream commit 5e6300e7b3a4ab5b72a82079753868e91fbf9efc ]

Every time sk->sk_forward_alloc is read locklessly,
add a READ_ONCE().

Add sk_forward_alloc_add() helper to centralize updates,
to reduce number of WRITE_ONCE().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h    | 12 +++++++++---
 net/core/sock.c       |  8 ++++----
 net/ipv4/tcp_output.c |  2 +-
 net/ipv4/udp.c        |  6 +++---
 net/mptcp/protocol.c  |  6 +++---
 5 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index d1f936ed97556..fe695e8bfe289 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1049,6 +1049,12 @@ static inline void sk_wmem_queued_add(struct sock *sk, int val)
 	WRITE_ONCE(sk->sk_wmem_queued, sk->sk_wmem_queued + val);
 }
 
+static inline void sk_forward_alloc_add(struct sock *sk, int val)
+{
+	/* Paired with lockless reads of sk->sk_forward_alloc */
+	WRITE_ONCE(sk->sk_forward_alloc, sk->sk_forward_alloc + val);
+}
+
 void sk_stream_write_space(struct sock *sk);
 
 /* OOB backlog add */
@@ -1401,7 +1407,7 @@ static inline int sk_forward_alloc_get(const struct sock *sk)
 	if (sk->sk_prot->forward_alloc_get)
 		return sk->sk_prot->forward_alloc_get(sk);
 #endif
-	return sk->sk_forward_alloc;
+	return READ_ONCE(sk->sk_forward_alloc);
 }
 
 static inline bool __sk_stream_memory_free(const struct sock *sk, int wake)
@@ -1697,14 +1703,14 @@ static inline void sk_mem_charge(struct sock *sk, int size)
 {
 	if (!sk_has_account(sk))
 		return;
-	sk->sk_forward_alloc -= size;
+	sk_forward_alloc_add(sk, -size);
 }
 
 static inline void sk_mem_uncharge(struct sock *sk, int size)
 {
 	if (!sk_has_account(sk))
 		return;
-	sk->sk_forward_alloc += size;
+	sk_forward_alloc_add(sk, size);
 	sk_mem_reclaim(sk);
 }
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 6ff58fa5f41ed..aa628c6314f64 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1034,7 +1034,7 @@ static int sock_reserve_memory(struct sock *sk, int bytes)
 		mem_cgroup_uncharge_skmem(sk->sk_memcg, pages);
 		return -ENOMEM;
 	}
-	sk->sk_forward_alloc += pages << PAGE_SHIFT;
+	sk_forward_alloc_add(sk, pages << PAGE_SHIFT);
 
 	WRITE_ONCE(sk->sk_reserved_mem,
 		   sk->sk_reserved_mem + (pages << PAGE_SHIFT));
@@ -3082,10 +3082,10 @@ int __sk_mem_schedule(struct sock *sk, int size, int kind)
 {
 	int ret, amt = sk_mem_pages(size);
 
-	sk->sk_forward_alloc += amt << PAGE_SHIFT;
+	sk_forward_alloc_add(sk, amt << PAGE_SHIFT);
 	ret = __sk_mem_raise_allocated(sk, size, amt, kind);
 	if (!ret)
-		sk->sk_forward_alloc -= amt << PAGE_SHIFT;
+		sk_forward_alloc_add(sk, -(amt << PAGE_SHIFT));
 	return ret;
 }
 EXPORT_SYMBOL(__sk_mem_schedule);
@@ -3117,7 +3117,7 @@ void __sk_mem_reduce_allocated(struct sock *sk, int amount)
 void __sk_mem_reclaim(struct sock *sk, int amount)
 {
 	amount >>= PAGE_SHIFT;
-	sk->sk_forward_alloc -= amount << PAGE_SHIFT;
+	sk_forward_alloc_add(sk, -(amount << PAGE_SHIFT));
 	__sk_mem_reduce_allocated(sk, amount);
 }
 EXPORT_SYMBOL(__sk_mem_reclaim);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 26bd039f9296f..dc3166e56169f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3380,7 +3380,7 @@ void sk_forced_mem_schedule(struct sock *sk, int size)
 	if (delta <= 0)
 		return;
 	amt = sk_mem_pages(delta);
-	sk->sk_forward_alloc += amt << PAGE_SHIFT;
+	sk_forward_alloc_add(sk, amt << PAGE_SHIFT);
 	sk_memory_allocated_add(sk, amt);
 
 	if (mem_cgroup_sockets_enabled && sk->sk_memcg)
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 42c1f7d9a980a..b2aa7777521f6 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1474,9 +1474,9 @@ static void udp_rmem_release(struct sock *sk, int size, int partial,
 		spin_lock(&sk_queue->lock);
 
 
-	sk->sk_forward_alloc += size;
+	sk_forward_alloc_add(sk, size);
 	amt = (sk->sk_forward_alloc - partial) & ~(PAGE_SIZE - 1);
-	sk->sk_forward_alloc -= amt;
+	sk_forward_alloc_add(sk, -amt);
 
 	if (amt)
 		__sk_mem_reduce_allocated(sk, amt >> PAGE_SHIFT);
@@ -1582,7 +1582,7 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 		sk->sk_forward_alloc += delta;
 	}
 
-	sk->sk_forward_alloc -= size;
+	sk_forward_alloc_add(sk, -size);
 
 	/* no need to setup a destructor, we will explicitly release the
 	 * forward allocated memory on dequeue
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 61fefa1a82db2..573db9c2bc1cd 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1802,7 +1802,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		}
 
 		/* data successfully copied into the write queue */
-		sk->sk_forward_alloc -= total_ts;
+		sk_forward_alloc_add(sk, -total_ts);
 		copied += psize;
 		dfrag->data_len += psize;
 		frag_truesize += psize;
@@ -3278,7 +3278,7 @@ void mptcp_destroy_common(struct mptcp_sock *msk, unsigned int flags)
 	/* move all the rx fwd alloc into the sk_mem_reclaim_final in
 	 * inet_sock_destruct() will dispose it
 	 */
-	sk->sk_forward_alloc += msk->rmem_fwd_alloc;
+	sk_forward_alloc_add(sk, msk->rmem_fwd_alloc);
 	msk->rmem_fwd_alloc = 0;
 	mptcp_token_destroy(msk);
 	mptcp_pm_free_anno_list(msk);
@@ -3562,7 +3562,7 @@ static void mptcp_shutdown(struct sock *sk, int how)
 
 static int mptcp_forward_alloc_get(const struct sock *sk)
 {
-	return sk->sk_forward_alloc + mptcp_sk(sk)->rmem_fwd_alloc;
+	return READ_ONCE(sk->sk_forward_alloc) + mptcp_sk(sk)->rmem_fwd_alloc;
 }
 
 static int mptcp_ioctl_outq(const struct mptcp_sock *msk, u64 v)
-- 
2.40.1




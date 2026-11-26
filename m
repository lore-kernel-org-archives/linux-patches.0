Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704434;
	b=x3Ev+4HBgE752tEfwvo+7vcMfj6Cet57+fic8XaA4bPlA4qMLlG0pN/a/tPFU5ETu7DO
	 1jQ5gFWI6Vrt15IDYcX9BD74ktsblaUtJV5T4iIEWc1UrJPtgKlCt8ytJY1F33Yl++bbh
	 nFFB0lGB4QdqsGcAdxSBqE0o/LVbDQ8hkV88wqJbD8Dc7iJB++jKre6lhTgU7ch8VM9mT
	 aIoaAcY1N96XdPNNWXJxXlEIUxb28AVqhOUeNFb+za2Luiz7vNOZAPCahsqDCnNTW89Hr
	 zYm4NODM14+4LmEMUzgjAtxhtWVFZijwHPps6X6uADtTTEtKtVtnU80qK7UpmzDjSQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XkDOM8XIt9EX1qT2Uny5m2vaqYpQDK31f5lXMenoJhA=;
	b=WOTXEd4Rag/AgzdpaoLBUqpFlgUSwiuSH8v+OyuzrwT1bf7dvpd8eUSoKOWvEKHOOSft
	 38rfkt1VB6Zlo1ssRTnBmJjr+Pofe3z5J+hFnDYBHFrpkDstb2rqA7ck8v18DoWMpGXBe
	 kzEexsay/Ih+VtOwikmnNuO+7u+MzC0cLFYO9DCx1g4qoFlQctbaAMsSCuXGh+HDbQ81P
	 PfBvC1e+0NXAzF+1+/56yRwrmX045Gr9E0zSjMM1vpgDEIMjWZjO/DJgjs/dImFQxGoFa
	 /Vtah9Xy37/Kt7wB8tFioNSriDXFHjD+IuLcqlX9nOMUM7XLFEawJiB4MFUfmhoTl6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S4xkHAji;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0B6606A31C;
	Thu, 26 Nov 2026 14:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S4xkHAji
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC9B1F000C0;
	Thu, 26 Nov 2026 14:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704434;
	bh=XkDOM8XIt9EX1qT2Uny5m2vaqYpQDK31f5lXMenoJhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4xkHAjiHr37laMtZjVgPGw7qcyc38XzYzP/A9ie0pvYzocOHf/sLjz6SmtzXn0Sq
	 6sm46+CaRrKym0uQhUC+LRiJ36dT3Ejh86AG/Ij3Z9QedsksNciD4dONpPenKidiGf
	 zLMYMf3oK2g++suqF8zHKhh7UB2pZGBIRBBjx19g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yajun Deng <yajun.deng@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/265] neigh: introduce neigh_confirm() helper function
Date: Thu, 26 Nov 2026 15:37:33 +0100
Message-ID: <20261126143613.620669171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yajun Deng <yajun.deng@linux.dev>

[ Upstream commit 1e84dc6b7bbfc4d1dd846decece4611b7e035772 ]

Add neigh_confirm() for the confirmed member in struct neighbour,
it can be called as an independent unit by other functions.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: c78b47704934 ("net: require a full socket in sock_confirm_neigh()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/arp.h       |  8 +-------
 include/net/ndisc.h     | 16 ++--------------
 include/net/neighbour.h | 11 +++++++++++
 include/net/sock.h      |  5 +----
 4 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/include/net/arp.h b/include/net/arp.h
index 4a23a97195f33..d7ef4ec71dfeb 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -53,13 +53,7 @@ static inline void __ipv4_confirm_neigh(struct net_device *dev, u32 key)
 
 	rcu_read_lock_bh();
 	n = __ipv4_neigh_lookup_noref(dev, key);
-	if (n) {
-		unsigned long now = jiffies;
-
-		/* avoid dirtying neighbour */
-		if (READ_ONCE(n->confirmed) != now)
-			WRITE_ONCE(n->confirmed, now);
-	}
+	neigh_confirm(n);
 	rcu_read_unlock_bh();
 }
 
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index e97ef508664f4..8f137404714ba 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -411,13 +411,7 @@ static inline void __ipv6_confirm_neigh(struct net_device *dev,
 
 	rcu_read_lock_bh();
 	n = __ipv6_neigh_lookup_noref(dev, pkey);
-	if (n) {
-		unsigned long now = jiffies;
-
-		/* avoid dirtying neighbour */
-		if (READ_ONCE(n->confirmed) != now)
-			WRITE_ONCE(n->confirmed, now);
-	}
+	neigh_confirm(n);
 	rcu_read_unlock_bh();
 }
 
@@ -428,13 +422,7 @@ static inline void __ipv6_confirm_neigh_stub(struct net_device *dev,
 
 	rcu_read_lock_bh();
 	n = __ipv6_neigh_lookup_noref_stub(dev, pkey);
-	if (n) {
-		unsigned long now = jiffies;
-
-		/* avoid dirtying neighbour */
-		if (READ_ONCE(n->confirmed) != now)
-			WRITE_ONCE(n->confirmed, now);
-	}
+	neigh_confirm(n);
 	rcu_read_unlock_bh();
 }
 
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 0e9d33e4439ec..1dbd543d8378f 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -305,6 +305,17 @@ static inline struct neighbour *__neigh_lookup_noref(struct neigh_table *tbl,
 	return ___neigh_lookup_noref(tbl, tbl->key_eq, tbl->hash, pkey, dev);
 }
 
+static inline void neigh_confirm(struct neighbour *n)
+{
+	if (n) {
+		unsigned long now = jiffies;
+
+		/* avoid dirtying neighbour */
+		if (READ_ONCE(n->confirmed) != now)
+			WRITE_ONCE(n->confirmed, now);
+	}
+}
+
 void neigh_table_init(int index, struct neigh_table *tbl);
 int neigh_table_clear(int index, struct neigh_table *tbl);
 struct neighbour *neigh_lookup(struct neigh_table *tbl, const void *pkey,
diff --git a/include/net/sock.h b/include/net/sock.h
index 4081cae7172b0..0598dcd65f2ca 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2135,13 +2135,10 @@ static inline void sock_confirm_neigh(struct sk_buff *skb, struct neighbour *n)
 {
 	if (skb_get_dst_pending_confirm(skb)) {
 		struct sock *sk = skb->sk;
-		unsigned long now = jiffies;
 
-		/* avoid dirtying neighbour */
-		if (READ_ONCE(n->confirmed) != now)
-			WRITE_ONCE(n->confirmed, now);
 		if (sk && READ_ONCE(sk->sk_dst_pending_confirm))
 			WRITE_ONCE(sk->sk_dst_pending_confirm, 0);
+		neigh_confirm(n);
 	}
 }
 
-- 
2.53.0




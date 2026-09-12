Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CCA4BEE32;
	Sat, 12 Sep 2026 11:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212077; cv=none; b=PUTHxQ+NAi1eWufVbhF9QdgRxnZZGQMeRjBY794V4aCQm/DoieocqUt23gd+I10g7qA+YPOSPZp4s2TzR5BDpNUXu3Gc67oOyXBgII89zQ5ox75MJjQGE/jlmIwHlAPHIvzxa4KOfN3smhdtlIw7PvaUCGXG834ko+T1QqLCD30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212077; c=relaxed/simple;
	bh=6GGz/TNywr8XkALKI/bnOIzb20tZECCC0A2/9mt/s54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmRwCikH5FNcSDkhXMaE8bpz7GG8RCVYFSur7vWRSouaBWcT+jMfZR5KYDVppMfUsQZvw4+YNjFRBxS78p/YRCRHbVieDVSB2uVzeAllu9TJm/Es4nHyzAoaNHYe6F4kpeUS+r+09PVqmlgzMl9ZbACYwpRU5UZMOQy1emrpFXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hiLKp4u1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hiLKp4u1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D84F1F000FF;
	Sat, 12 Sep 2026 11:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212075;
	bh=Tj6SD6O+K4EpMRaKe+48yHGbbNB5BgpcCIZGbDm+VnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hiLKp4u1zACYcQOZSEHFdCQEPM2S3qqI7+/kc3sV7lgOzDhc2y3gcPsKLGpnahNze
	 DNOUTzTwR2lunoxNr878Ciqb4k6EUFyLapiLHz76+gThsbjh02EqOE8escdMSRxAt2
	 wrVDAEzKs9b3yuM8fg6szv1Sr9lRZOxfBaOswQ9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Blunt <michaelbblunt@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1361/1518] inetpeer: randomize RB-tree node comparison using SipHash
Date: Sat, 12 Sep 2026 08:58:50 +0200
Message-ID: <20260912065654.321977127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2ee66e9487172fcd189bc52a767c30dad7141c09 ]

The inetpeer rate limiting system stores peer entries in a Red-Black tree
keyed deterministically on the remote IP address. Because tree lookups walk
the RB-tree using standard lexicographical comparisons (inetpeer_addr_cmp),
an off-path adversary can predict the exact topology of the tree and the
sequence of nodes traversed during lookups (the gc_stack candidate list).

By combining deterministic tree traversal with aggressive garbage collection
(triggered when tree size exceeds inet_peer_threshold), an attacker can
selectively force the eviction of targeted inet_peer nodes. When an evicted
node is subsequently re-created upon receiving a new packet, its rate-limiting
token bucket (rate_tokens, rate_last) is reset to full capacity. This creates
a side-channel primitive allowing off-path attackers to bypass IP-keyed ICMP
rate limits and infer open UDP ports (similar to SAD DNS style attacks).

Mitigate this by randomizing the RB-tree node comparison logic using SipHash
with a secret key (inetpeer_hash_key) initialized via net_get_random_once().
Nodes are ordered in the tree by SipHash(addr, key) rather than raw IP
addresses. Because the secret key is unknown to external entities, the tree
layout and lookup traversal paths are unpredictable to off-path adversaries,
breaking the deterministic eviction gadget.

Cache the computed 64-bit SipHash (hash) in struct inet_peer and compute the
target hash (dhash) once at the beginning of inet_getpeer() to avoid recomputing
SipHash at every step of the RB-tree walk.

Fixes: b145425f269a ("inetpeer: remove AVL implementation in favor of RB tree")
Reported-by: Michael Blunt <michaelbblunt@gmail.com>
Suggested-by: Michael Blunt <michaelbblunt@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260818151213.3953963-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inetpeer.h |  4 ++++
 net/ipv4/inetpeer.c    | 38 +++++++++++++++++++++++++++++++++++---
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/include/net/inetpeer.h b/include/net/inetpeer.h
index f475757daafba..414e9adf4c511 100644
--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -35,6 +35,7 @@ struct inetpeer_addr {
 
 struct inet_peer {
 	struct rb_node		rb_node;
+	u64			hash;
 	struct inetpeer_addr	daddr;
 
 	u32			metrics[RTAX_MAX];
@@ -125,6 +126,9 @@ static inline int inetpeer_addr_cmp(const struct inetpeer_addr *a,
 {
 	int i, n;
 
+	if (a->family != b->family)
+		return a->family < b->family ? -1 : 1;
+
 	if (a->family == AF_INET)
 		n = sizeof(a->a4) / sizeof(u32);
 	else
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index 7b1e0a2d69066..17933ac5b4280 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -22,6 +22,7 @@
 #include <net/ip.h>
 #include <net/inetpeer.h>
 #include <net/secure_seq.h>
+#include <linux/siphash.h>
 
 /*
  *  Theory of operations.
@@ -53,6 +54,34 @@
  */
 
 static struct kmem_cache *peer_cachep __ro_after_init;
+static siphash_aligned_key_t inetpeer_hash_key __read_mostly;
+
+static u64 inetpeer_addr_hash(const struct inetpeer_addr *a)
+{
+	net_get_random_once(&inetpeer_hash_key, sizeof(inetpeer_hash_key));
+
+	if (a->family == AF_INET)
+		return siphash_2u32((__force u32)a->a4.addr, a->a4.vif,
+				    &inetpeer_hash_key);
+
+	return siphash_4u32((__force u32)a->a6.s6_addr32[0],
+			    (__force u32)a->a6.s6_addr32[1],
+			    (__force u32)a->a6.s6_addr32[2],
+			    (__force u32)a->a6.s6_addr32[3],
+			    &inetpeer_hash_key);
+}
+
+static int inetpeer_entry_cmp(u64 dhash,
+			      const struct inetpeer_addr *daddr,
+			      const struct inet_peer *p)
+{
+	if (dhash < p->hash)
+		return -1;
+	if (dhash > p->hash)
+		return 1;
+
+	return inetpeer_addr_cmp(daddr, &p->daddr);
+}
 
 void inet_peer_base_init(struct inet_peer_base *bp)
 {
@@ -86,6 +115,7 @@ void __init inet_initpeers(void)
 
 /* Called with rcu_read_lock() or base->lock held */
 static struct inet_peer *lookup(const struct inetpeer_addr *daddr,
+				u64 dhash,
 				struct inet_peer_base *base,
 				unsigned int seq,
 				struct inet_peer *gc_stack[],
@@ -107,7 +137,7 @@ static struct inet_peer *lookup(const struct inetpeer_addr *daddr,
 			break;
 		parent = next;
 		p = rb_entry(parent, struct inet_peer, rb_node);
-		cmp = inetpeer_addr_cmp(daddr, &p->daddr);
+		cmp = inetpeer_entry_cmp(dhash, daddr, p);
 		if (cmp == 0) {
 			now = jiffies;
 			if (READ_ONCE(p->dtime) != now)
@@ -172,6 +202,7 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *base,
 			       const struct inetpeer_addr *daddr)
 {
 	struct inet_peer *p, *gc_stack[PEER_MAX_GC];
+	u64 dhash = inetpeer_addr_hash(daddr);
 	struct rb_node **pp, *parent;
 	unsigned int gc_cnt, seq;
 
@@ -179,7 +210,7 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *base,
 	 * Because of a concurrent writer, we might not find an existing entry.
 	 */
 	seq = read_seqbegin(&base->lock);
-	p = lookup(daddr, base, seq, NULL, &gc_cnt, &parent, &pp);
+	p = lookup(daddr, dhash, base, seq, NULL, &gc_cnt, &parent, &pp);
 
 	if (p)
 		return p;
@@ -191,11 +222,12 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *base,
 	write_seqlock_bh(&base->lock);
 
 	gc_cnt = 0;
-	p = lookup(daddr, base, seq, gc_stack, &gc_cnt, &parent, &pp);
+	p = lookup(daddr, dhash, base, seq, gc_stack, &gc_cnt, &parent, &pp);
 	if (!p) {
 		p = kmem_cache_alloc(peer_cachep, GFP_ATOMIC);
 		if (p) {
 			p->daddr = *daddr;
+			p->hash = dhash;
 			p->dtime = (__u32)jiffies;
 			refcount_set(&p->refcnt, 1);
 			atomic_set(&p->rid, 0);
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B85A347FED
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302482; cv=none; b=syeBDwFfXPqIQXYGd/5AOqNMC/Sy6+k4uSJDx0jHnt/9NVw3936s1J3+dD+l0uxY+IskxpEcDWmbbn52KofZTfA1UwIUyyVLJ+5Zs8d5mFuiDTp3ysYoIDeEiyBT92GevTOmNrZZaHDF+4zw7YFgjNAzVxNlkhx24iulRwLepXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302482; c=relaxed/simple;
	bh=GqelLZskd55U/JbZzmr0Y1WJWONzaWHNH5YYYdGj1Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaGeirj1bgfeyBptiP+kwUcQ78Xizea3Bq4VDP2OP9vvdJOgzgM3s6SLbDo65HJ7hx28CNaYcfVkt4LhWvIs8UhmkUDZnpKn0ljI1KDei19gZWKB2SyUL5RUNIfg3KpJD76PiE9hXIpp9g9HRHMWvATPUADtPdKKpE7IQW9XC5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=paQTs+LY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="paQTs+LY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890A6C19423;
	Sat, 28 Feb 2026 18:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302482;
	bh=GqelLZskd55U/JbZzmr0Y1WJWONzaWHNH5YYYdGj1Vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=paQTs+LYylRSOCDEp8IUTBnf2bzUcieBF90qhUX4xtoGsfgpydIW+pjYe8ffOxPPn
	 pZADHlyk+IJtzfy7zkFd256n19rTDIQa33pIKzLYI7UBVll6s/bRyscQBtUKEEC6yS
	 CsJDBHpG3f6MWAve45yBXSC1ssiRSHJ/pQFKO8JYFmQ575ySI7baxkj+hI8uNIrx+e
	 ZLRQHfmIJ8t+yqfHPw79DOqJlNOs74+zNuc5ZdIN8m+oodjjZYdFzieTZu0edbH1RT
	 ksjoLPuZnGwaYYs+SfmoDCkWWl/kF5fnaVYFcOXnPnL6AQ1MUW2KRa1YdDVNsEutMp
	 t8nCyXtupBt+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 229/232] ping: Convert hlist_nulls to plain hlist.
Date: Sat, 28 Feb 2026 13:11:22 -0500
Message-ID: <20260228181127.1592657-229-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit f1b5dfe63f6a9eb17948cbaee4da4b66f51ac794 ]

Since introduced in commit c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP
socket kind"), ping socket does not use SLAB_TYPESAFE_BY_RCU nor check
nulls marker in loops.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ad5dfde2a573 ("ping: annotate data-races in ping_lookup()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ping.c | 41 +++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index cadf743ab4f52..aae5ad6303a97 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -49,13 +49,8 @@
 #include <net/transp_v6.h>
 #endif
 
-#define ping_portaddr_for_each_entry(__sk, node, list) \
-	hlist_nulls_for_each_entry(__sk, node, list, sk_nulls_node)
-#define ping_portaddr_for_each_entry_rcu(__sk, node, list) \
-	hlist_nulls_for_each_entry_rcu(__sk, node, list, sk_nulls_node)
-
 struct ping_table {
-	struct hlist_nulls_head	hash[PING_HTABLE_SIZE];
+	struct hlist_head	hash[PING_HTABLE_SIZE];
 	spinlock_t		lock;
 };
 
@@ -74,17 +69,16 @@ static inline u32 ping_hashfn(const struct net *net, u32 num, u32 mask)
 }
 EXPORT_SYMBOL_GPL(ping_hash);
 
-static inline struct hlist_nulls_head *ping_hashslot(struct ping_table *table,
-					     struct net *net, unsigned int num)
+static inline struct hlist_head *ping_hashslot(struct ping_table *table,
+					       struct net *net, unsigned int num)
 {
 	return &table->hash[ping_hashfn(net, num, PING_HTABLE_MASK)];
 }
 
 int ping_get_port(struct sock *sk, unsigned short ident)
 {
-	struct hlist_nulls_node *node;
-	struct hlist_nulls_head *hlist;
 	struct inet_sock *isk, *isk2;
+	struct hlist_head *hlist;
 	struct sock *sk2 = NULL;
 
 	isk = inet_sk(sk);
@@ -98,7 +92,7 @@ int ping_get_port(struct sock *sk, unsigned short ident)
 				result++; /* avoid zero */
 			hlist = ping_hashslot(&ping_table, sock_net(sk),
 					    result);
-			ping_portaddr_for_each_entry(sk2, node, hlist) {
+			sk_for_each(sk2, hlist) {
 				isk2 = inet_sk(sk2);
 
 				if (isk2->inet_num == result)
@@ -115,7 +109,7 @@ int ping_get_port(struct sock *sk, unsigned short ident)
 			goto fail;
 	} else {
 		hlist = ping_hashslot(&ping_table, sock_net(sk), ident);
-		ping_portaddr_for_each_entry(sk2, node, hlist) {
+		sk_for_each(sk2, hlist) {
 			isk2 = inet_sk(sk2);
 
 			/* BUG? Why is this reuse and not reuseaddr? ping.c
@@ -133,9 +127,8 @@ int ping_get_port(struct sock *sk, unsigned short ident)
 	isk->inet_num = ident;
 	if (sk_unhashed(sk)) {
 		pr_debug("was not hashed\n");
-		sock_hold(sk);
+		sk_add_node_rcu(sk, hlist);
 		sock_set_flag(sk, SOCK_RCU_FREE);
-		hlist_nulls_add_head_rcu(&sk->sk_nulls_node, hlist);
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 	}
 	spin_unlock(&ping_table.lock);
@@ -161,9 +154,7 @@ void ping_unhash(struct sock *sk)
 
 	pr_debug("ping_unhash(isk=%p,isk->num=%u)\n", isk, isk->inet_num);
 	spin_lock(&ping_table.lock);
-	if (sk_hashed(sk)) {
-		hlist_nulls_del_init_rcu(&sk->sk_nulls_node);
-		sock_put(sk);
+	if (sk_del_node_init_rcu(sk)) {
 		isk->inet_num = 0;
 		isk->inet_sport = 0;
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
@@ -175,10 +166,9 @@ EXPORT_SYMBOL_GPL(ping_unhash);
 /* Called under rcu_read_lock() */
 static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 {
-	struct hlist_nulls_head *hslot = ping_hashslot(&ping_table, net, ident);
+	struct hlist_head *hslot = ping_hashslot(&ping_table, net, ident);
 	struct sock *sk = NULL;
 	struct inet_sock *isk;
-	struct hlist_nulls_node *hnode;
 	int dif, sdif;
 
 	if (skb->protocol == htons(ETH_P_IP)) {
@@ -197,7 +187,7 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 		return NULL;
 	}
 
-	ping_portaddr_for_each_entry_rcu(sk, hnode, hslot) {
+	sk_for_each_rcu(sk, hslot) {
 		isk = inet_sk(sk);
 
 		pr_debug("iterate\n");
@@ -1043,15 +1033,14 @@ static struct sock *ping_get_first(struct seq_file *seq, int start)
 
 	for (state->bucket = start; state->bucket < PING_HTABLE_SIZE;
 	     ++state->bucket) {
-		struct hlist_nulls_node *node;
-		struct hlist_nulls_head *hslot;
+		struct hlist_head *hslot;
 
 		hslot = &ping_table.hash[state->bucket];
 
-		if (hlist_nulls_empty(hslot))
+		if (hlist_empty(hslot))
 			continue;
 
-		sk_nulls_for_each(sk, node, hslot) {
+		sk_for_each(sk, hslot) {
 			if (net_eq(sock_net(sk), net) &&
 			    sk->sk_family == state->family)
 				goto found;
@@ -1068,7 +1057,7 @@ static struct sock *ping_get_next(struct seq_file *seq, struct sock *sk)
 	struct net *net = seq_file_net(seq);
 
 	do {
-		sk = sk_nulls_next(sk);
+		sk = sk_next(sk);
 	} while (sk && (!net_eq(sock_net(sk), net)));
 
 	if (!sk)
@@ -1204,6 +1193,6 @@ void __init ping_init(void)
 	int i;
 
 	for (i = 0; i < PING_HTABLE_SIZE; i++)
-		INIT_HLIST_NULLS_HEAD(&ping_table.hash[i], i);
+		INIT_HLIST_HEAD(&ping_table.hash[i]);
 	spin_lock_init(&ping_table.lock);
 }
-- 
2.51.0


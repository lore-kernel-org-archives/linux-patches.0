Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA921AC893;
	Thu, 15 Aug 2024 14:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732782; cv=none; b=TSBre87iOkNok8+zmnsA/dWVY1tYEpwbW41WElfA9CnvBY+BdDT3xbwGDxIXGqQBzc8HRM78o0bp/W3ra7gA4P+0tGmPhxfTo++aMNSp2lFtl80CMI9/soE14aSyIPavzMfifj6YNIdtcLkjdA428XS+GjMA/eXfAEStCWXw/Kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732782; c=relaxed/simple;
	bh=da8OqpmxebvErS/z4GDthfXL34i3N+CLZkvWRaYUPCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqOgjos5GeDJuRNIsltvdH4AhU0VcakUVgA0nZvcV9CFDZazfT/UM/i2EgpfNFrcPXSSLMyvciB8XnV9lP1xk7Sm7A2z8XiOwLQkT4oB/pBpFfmVPu1CZapK8C4qi96KbqPi5AVDH31e9IoNYRH2GTnBtybIIKpGqGpE9bRQuy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5EyLNN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5EyLNN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87C9C32786;
	Thu, 15 Aug 2024 14:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732782;
	bh=da8OqpmxebvErS/z4GDthfXL34i3N+CLZkvWRaYUPCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5EyLNN0/aQRj+u4lwEyOwkS//dDq3KkwJIdXMWfGi4jNayjnnGqkvV043yzMZvPR
	 Y7CqFlz4k6IXq9LkI0DU4Wi6yNqyCwWAAwc8CNRiBt2QQkOrbyEJ4fK4laaTTajqhX
	 K7kezZVycnGIVMWQISHl+35XBlsMzIHAl1dbuCi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 253/352] sctp: move hlist_node and hashent out of sctp_ep_common
Date: Thu, 15 Aug 2024 15:25:19 +0200
Message-ID: <20240815131929.216608428@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 3d3b2f57d4447e6e9f4096ad01d0e4129f7bc7e9 ]

Struct sctp_ep_common is included in both asoc and ep, but hlist_node
and hashent are only needed by ep after asoc_hashtable was dropped by
Commit b5eff7128366 ("sctp: drop the old assoc hashtable of sctp").

So it is better to move hlist_node and hashent from sctp_ep_common to
sctp_endpoint, and it saves some space for each asoc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9ab0faa7f9ff ("sctp: Fix null-ptr-deref in reuseport_add_sock().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sctp/sctp.h    |  4 ++--
 include/net/sctp/structs.h |  8 ++++----
 net/sctp/input.c           | 27 ++++++++++-----------------
 net/sctp/proc.c            | 10 ++++------
 net/sctp/socket.c          |  6 +++---
 5 files changed, 23 insertions(+), 32 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 33475d061823e..6d89a7f3f6a4c 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -506,8 +506,8 @@ static inline int sctp_ep_hashfn(struct net *net, __u16 lport)
 	return (net_hash_mix(net) + lport) & (sctp_ep_hashsize - 1);
 }
 
-#define sctp_for_each_hentry(epb, head) \
-	hlist_for_each_entry(epb, head, node)
+#define sctp_for_each_hentry(ep, head) \
+	hlist_for_each_entry(ep, head, node)
 
 /* Is a socket of this style? */
 #define sctp_style(sk, style) __sctp_style((sk), (SCTP_SOCKET_##style))
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index be59e8df0bffc..108eb62cdc2c5 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1218,10 +1218,6 @@ enum sctp_endpoint_type {
  */
 
 struct sctp_ep_common {
-	/* Fields to help us manage our entries in the hash tables. */
-	struct hlist_node node;
-	int hashent;
-
 	/* Runtime type information.  What kind of endpoint is this? */
 	enum sctp_endpoint_type type;
 
@@ -1273,6 +1269,10 @@ struct sctp_endpoint {
 	/* Common substructure for endpoint and association. */
 	struct sctp_ep_common base;
 
+	/* Fields to help us manage our entries in the hash tables. */
+	struct hlist_node node;
+	int hashent;
+
 	/* Associations: A list of current associations and mappings
 	 *	      to the data consumers for each association. This
 	 *	      may be in the form of a hash table or other
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 8f3aab6a4458b..17df756418eae 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -723,23 +723,21 @@ static int __sctp_hash_endpoint(struct sctp_endpoint *ep)
 	struct sock *sk = ep->base.sk;
 	struct net *net = sock_net(sk);
 	struct sctp_hashbucket *head;
-	struct sctp_ep_common *epb;
 
-	epb = &ep->base;
-	epb->hashent = sctp_ep_hashfn(net, epb->bind_addr.port);
-	head = &sctp_ep_hashtable[epb->hashent];
+	ep->hashent = sctp_ep_hashfn(net, ep->base.bind_addr.port);
+	head = &sctp_ep_hashtable[ep->hashent];
 
 	if (sk->sk_reuseport) {
 		bool any = sctp_is_ep_boundall(sk);
-		struct sctp_ep_common *epb2;
+		struct sctp_endpoint *ep2;
 		struct list_head *list;
 		int cnt = 0, err = 1;
 
 		list_for_each(list, &ep->base.bind_addr.address_list)
 			cnt++;
 
-		sctp_for_each_hentry(epb2, &head->chain) {
-			struct sock *sk2 = epb2->sk;
+		sctp_for_each_hentry(ep2, &head->chain) {
+			struct sock *sk2 = ep2->base.sk;
 
 			if (!net_eq(sock_net(sk2), net) || sk2 == sk ||
 			    !uid_eq(sock_i_uid(sk2), sock_i_uid(sk)) ||
@@ -766,7 +764,7 @@ static int __sctp_hash_endpoint(struct sctp_endpoint *ep)
 	}
 
 	write_lock(&head->lock);
-	hlist_add_head(&epb->node, &head->chain);
+	hlist_add_head(&ep->node, &head->chain);
 	write_unlock(&head->lock);
 	return 0;
 }
@@ -788,19 +786,16 @@ static void __sctp_unhash_endpoint(struct sctp_endpoint *ep)
 {
 	struct sock *sk = ep->base.sk;
 	struct sctp_hashbucket *head;
-	struct sctp_ep_common *epb;
 
-	epb = &ep->base;
+	ep->hashent = sctp_ep_hashfn(sock_net(sk), ep->base.bind_addr.port);
 
-	epb->hashent = sctp_ep_hashfn(sock_net(sk), epb->bind_addr.port);
-
-	head = &sctp_ep_hashtable[epb->hashent];
+	head = &sctp_ep_hashtable[ep->hashent];
 
 	if (rcu_access_pointer(sk->sk_reuseport_cb))
 		reuseport_detach_sock(sk);
 
 	write_lock(&head->lock);
-	hlist_del_init(&epb->node);
+	hlist_del_init(&ep->node);
 	write_unlock(&head->lock);
 }
 
@@ -833,7 +828,6 @@ static struct sctp_endpoint *__sctp_rcv_lookup_endpoint(
 					const union sctp_addr *paddr)
 {
 	struct sctp_hashbucket *head;
-	struct sctp_ep_common *epb;
 	struct sctp_endpoint *ep;
 	struct sock *sk;
 	__be16 lport;
@@ -843,8 +837,7 @@ static struct sctp_endpoint *__sctp_rcv_lookup_endpoint(
 	hash = sctp_ep_hashfn(net, ntohs(lport));
 	head = &sctp_ep_hashtable[hash];
 	read_lock(&head->lock);
-	sctp_for_each_hentry(epb, &head->chain) {
-		ep = sctp_ep(epb);
+	sctp_for_each_hentry(ep, &head->chain) {
 		if (sctp_endpoint_is_match(ep, net, laddr))
 			goto hit;
 	}
diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index 963b94517ec20..ec00ee75d59a6 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -161,7 +161,6 @@ static void *sctp_eps_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 static int sctp_eps_seq_show(struct seq_file *seq, void *v)
 {
 	struct sctp_hashbucket *head;
-	struct sctp_ep_common *epb;
 	struct sctp_endpoint *ep;
 	struct sock *sk;
 	int    hash = *(loff_t *)v;
@@ -171,18 +170,17 @@ static int sctp_eps_seq_show(struct seq_file *seq, void *v)
 
 	head = &sctp_ep_hashtable[hash];
 	read_lock_bh(&head->lock);
-	sctp_for_each_hentry(epb, &head->chain) {
-		ep = sctp_ep(epb);
-		sk = epb->sk;
+	sctp_for_each_hentry(ep, &head->chain) {
+		sk = ep->base.sk;
 		if (!net_eq(sock_net(sk), seq_file_net(seq)))
 			continue;
 		seq_printf(seq, "%8pK %8pK %-3d %-3d %-4d %-5d %5u %5lu ", ep, sk,
 			   sctp_sk(sk)->type, sk->sk_state, hash,
-			   epb->bind_addr.port,
+			   ep->base.bind_addr.port,
 			   from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
 			   sock_i_ino(sk));
 
-		sctp_seq_dump_local_addrs(seq, epb);
+		sctp_seq_dump_local_addrs(seq, &ep->base);
 		seq_printf(seq, "\n");
 	}
 	read_unlock_bh(&head->lock);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 79cf4cda2cf6d..5053d813e91cf 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5193,14 +5193,14 @@ int sctp_for_each_endpoint(int (*cb)(struct sctp_endpoint *, void *),
 			   void *p) {
 	int err = 0;
 	int hash = 0;
-	struct sctp_ep_common *epb;
+	struct sctp_endpoint *ep;
 	struct sctp_hashbucket *head;
 
 	for (head = sctp_ep_hashtable; hash < sctp_ep_hashsize;
 	     hash++, head++) {
 		read_lock_bh(&head->lock);
-		sctp_for_each_hentry(epb, &head->chain) {
-			err = cb(sctp_ep(epb), p);
+		sctp_for_each_hentry(ep, &head->chain) {
+			err = cb(ep, p);
 			if (err)
 				break;
 		}
-- 
2.43.0




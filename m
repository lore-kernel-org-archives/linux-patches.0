Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDDF3DAAA8;
	Tue, 25 Aug 2026 13:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665415; cv=none; b=kGkSC4iT+i3gZ+eEjWbOfnYiHy/8oLCdTrgh3aagfwy1m2YaIop1LYqPcTV69DyZgkAPPftaie+3qUK9PBdom/eX/LG7Wh36F002cAGRRdaDJeL64HvUi468sWzn3BYddTaX49vi6fp1ZpY63fYLOqzy6pgq4rELjsmbqZDtj44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665415; c=relaxed/simple;
	bh=Vrj0V/wta6OFk20qnPZu7D7rNCxb2NHL4tFtwbGJq5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AP16gnQHwM48txLG1bTw1Gh7wwG36RE1A6QFFmr7tB/Zr8lkDxTQMmd7dYrBjvH8nhSrfuKkMoCysrsXhr2me33A4dmtWSnXYiGOFR/g3FWbJpwXktQHroN2RRj2RFfeBLFSXDyVf+qM3o+8abddXj74yVrlz77TF8u/Fz7Ycto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cWLajNAN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cWLajNAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6739A1F000E9;
	Tue, 25 Aug 2026 13:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665414;
	bh=70UK9Glz1VvQ//R6+Vm/X6MKklzTztKkx2g8v8BUTXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cWLajNANpUfB16WzH6ZKKi8V1Frg68oHNQx9pdLbH53ZzuU9q+J85GJ9KmdwlLA66
	 BQThfVZL4RwTrCuBN9DXDQPdJSD5yMs5DGJt4+SSFD3qnq682oVKB9hwnNHWGJuG9P
	 g6jBwiQ09Vr2jted/gMzmb5M0LEp0nbqlMtTAmXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 09/77] inet: frags: add inet_frag_putn() helper
Date: Tue, 25 Aug 2026 15:25:31 +0200
Message-ID: <20260825132541.918787004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ae2d90355aa5592b0e99c8bbb4c3fa1d8e205f1b ]

inet_frag_putn() can release multiple references
in one step.

Use it in inet_frags_free_cb().

Replace inet_frag_put(X) with inet_frag_putn(X, 1)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250312082250.1803501-2-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 653d7ddf6cba ("inet: frags: publish queues before arming timer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/inet_frag.h                 |    4 ++--
 include/net/ipv6_frag.h                 |    3 ++-
 net/ieee802154/6lowpan/reassembly.c     |    7 ++++---
 net/ipv4/inet_fragment.c                |    3 +--
 net/ipv4/ip_fragment.c                  |    2 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c |    3 ++-
 net/ipv6/reassembly.c                   |    4 ++--
 7 files changed, 14 insertions(+), 12 deletions(-)

--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -133,9 +133,9 @@ struct inet_frag_queue *inet_frag_find(s
 void inet_frag_queue_flush(struct inet_frag_queue *q,
 			   enum skb_drop_reason reason);
 
-static inline void inet_frag_put(struct inet_frag_queue *q)
+static inline void inet_frag_putn(struct inet_frag_queue *q, int refs)
 {
-	if (refcount_dec_and_test(&q->refcnt))
+	if (refs && refcount_sub_and_test(refs, &q->refcnt))
 		inet_frag_destroy(q);
 }
 
--- a/include/net/ipv6_frag.h
+++ b/include/net/ipv6_frag.h
@@ -66,6 +66,7 @@ ip6frag_expire_frag_queue(struct net *ne
 {
 	struct net_device *dev = NULL;
 	struct sk_buff *head;
+	int refs = 1;
 
 	rcu_read_lock();
 	spin_lock(&fq->q.lock);
@@ -112,7 +113,7 @@ out:
 	spin_unlock(&fq->q.lock);
 out_rcu_unlock:
 	rcu_read_unlock();
-	inet_frag_put(&fq->q);
+	inet_frag_putn(&fq->q, refs);
 }
 
 /* Check if the upper layer header is truncated in the first fragment. */
--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -45,6 +45,7 @@ static void lowpan_frag_expire(struct ti
 {
 	struct inet_frag_queue *frag = from_timer(frag, t, timer);
 	struct frag_queue *fq;
+	int refs = 1;
 
 	fq = container_of(frag, struct frag_queue, q);
 
@@ -56,7 +57,7 @@ static void lowpan_frag_expire(struct ti
 	inet_frag_kill(&fq->q);
 out:
 	spin_unlock(&fq->q.lock);
-	inet_frag_put(&fq->q);
+	inet_frag_putn(&fq->q, refs);
 }
 
 static inline struct lowpan_frag_queue *
@@ -302,13 +303,13 @@ int lowpan_frag_rcv(struct sk_buff *skb,
 
 	fq = fq_find(net, cb, &hdr.source, &hdr.dest);
 	if (fq != NULL) {
-		int ret;
+		int ret, refs = 1;
 
 		spin_lock(&fq->q.lock);
 		ret = lowpan_frag_queue(fq, skb, frag_type);
 		spin_unlock(&fq->q.lock);
 
-		inet_frag_put(&fq->q);
+		inet_frag_putn(&fq->q, refs);
 		return ret;
 	}
 
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -145,8 +145,7 @@ static void inet_frags_free_cb(void *ptr
 	}
 	spin_unlock_bh(&fq->lock);
 
-	if (refcount_sub_and_test(count, &fq->refcnt))
-		inet_frag_destroy(fq);
+	inet_frag_putn(fq, count);
 }
 
 static LLIST_HEAD(fqdir_free_list);
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -112,7 +112,7 @@ static void ip4_frag_free(struct inet_fr
 
 static void ipq_put(struct ipq *ipq)
 {
-	inet_frag_put(&ipq->q);
+	inet_frag_putn(&ipq->q, 1);
 }
 
 /* Kill ipq entry. It is not destroyed immediately,
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -448,6 +448,7 @@ int nf_ct_frag6_gather(struct net *net,
 	struct frag_hdr *fhdr;
 	struct frag_queue *fq;
 	struct ipv6hdr *hdr;
+	int refs = 1;
 	u8 prevhdr;
 
 	/* Jumbo payload inhibits frag. header */
@@ -490,7 +491,7 @@ int nf_ct_frag6_gather(struct net *net,
 	}
 
 	spin_unlock_bh(&fq->q.lock);
-	inet_frag_put(&fq->q);
+	inet_frag_putn(&fq->q, refs);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_ct_frag6_gather);
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -380,7 +380,7 @@ static int ipv6_frag_rcv(struct sk_buff
 	fq = fq_find(net, fhdr->identification, hdr, iif);
 	if (fq) {
 		u32 prob_offset = 0;
-		int ret;
+		int ret, refs = 1;
 
 		spin_lock(&fq->q.lock);
 
@@ -389,7 +389,7 @@ static int ipv6_frag_rcv(struct sk_buff
 				     &prob_offset);
 
 		spin_unlock(&fq->q.lock);
-		inet_frag_put(&fq->q);
+		inet_frag_putn(&fq->q, refs);
 		if (prob_offset) {
 			__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
 					IPSTATS_MIB_INHDRERRORS);



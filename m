Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5A7392C21;
	Tue, 25 Aug 2026 13:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665641; cv=none; b=uNGKmigqzM1cj8GADNPAOwNmIcscUm5P53tKjCx9mrX669l+rPXbrb46ka/V6eku9n0xwxWavePoyN4pQr3HOdjBar+2Q8Zl6wOLmiGPG25pJBgD/g8AK+J1foqQs9HiGQptbZyvwzAnW/QpPxDLbKm/wglauJQH7RusRJcXCHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665641; c=relaxed/simple;
	bh=ulvKbANJDgtakwXvea6xtWSZzjVHDx95B8aqHwRBts0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbANLdWKp1i4V8KhQJ95QULnz+kYXJahn/n9nTcBlja+Id2Tig5H7Fdy5dOe4EDO0K4u/9xeYe4VoVRiEmvUopvO48hSLG20g6Gi4+LsRurLl1SENzh69kWQ0n57Owkx6CpOXylmmTGxwKy8u6gptghiVhXvQG1L1Sy6nmj5Id8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zcSaKYUV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zcSaKYUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CB51F000E9;
	Tue, 25 Aug 2026 13:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665640;
	bh=cmdwfLk0T5S2NgGU8qvLVIbm+hKn9tuclZIRR6AtoU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zcSaKYUVaY8BDPJcBUN+186NvRl/S/DCJIPFtPCecZQOIY2wMQ1GQVcU8PVApouDr
	 /vy4U34RNos9NU126tnDNNCARGZasKITyDTQmxOa685hD4azxUNKUCq3VvBHFOe555
	 ecijn7JmbJN3PQGvymFrvd+2i1j8As4BiAm7HYsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 17/87] inet: frags: save a pair of atomic operations in reassembly
Date: Tue, 25 Aug 2026 15:25:40 +0200
Message-ID: <20260825132542.500640434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ca0359df45a55a9eb4d6dc09a481064abf78320f ]

As mentioned in commit 648700f76b03 ("inet: frags:
use rhashtables for reassembly units"):

  A followup patch will even remove the refcount hold/release
  left from prior implementation and save a couple of atomic
  operations.

This patch implements this idea, seven years later.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250312082250.1803501-5-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 653d7ddf6cba ("inet: frags: publish queues before arming timer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/6lowpan/reassembly.c     |    5 ++++-
 net/ipv4/inet_fragment.c                |   18 ++++++++----------
 net/ipv4/ip_fragment.c                  |    5 ++++-
 net/ipv6/netfilter/nf_conntrack_reasm.c |    5 ++++-
 net/ipv6/reassembly.c                   |    9 ++++-----
 5 files changed, 24 insertions(+), 18 deletions(-)

--- a/net/ieee802154/6lowpan/reassembly.c
+++ b/net/ieee802154/6lowpan/reassembly.c
@@ -304,17 +304,20 @@ int lowpan_frag_rcv(struct sk_buff *skb,
 		goto err;
 	}
 
+	rcu_read_lock();
 	fq = fq_find(net, cb, &hdr.source, &hdr.dest);
 	if (fq != NULL) {
-		int ret, refs = 1;
+		int ret, refs = 0;
 
 		spin_lock(&fq->q.lock);
 		ret = lowpan_frag_queue(fq, skb, frag_type, &refs);
 		spin_unlock(&fq->q.lock);
 
+		rcu_read_unlock();
 		inet_frag_putn(&fq->q, refs);
 		return ret;
 	}
+	rcu_read_unlock();
 
 err:
 	kfree_skb(skb);
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -375,7 +375,8 @@ static struct inet_frag_queue *inet_frag
 
 	timer_setup(&q->timer, f->frag_expire, 0);
 	spin_lock_init(&q->lock);
-	refcount_set(&q->refcnt, 3);
+	/* One reference for the timer, one for the hash table. */
+	refcount_set(&q->refcnt, 2);
 
 	return q;
 }
@@ -397,7 +398,11 @@ static struct inet_frag_queue *inet_frag
 	*prev = rhashtable_lookup_get_insert_key(&fqdir->rhashtable, &q->key,
 						 &q->node, f->rhash_params);
 	if (*prev) {
-		int refs = 2;
+		/* We could not insert in the hash table,
+		 * we need to cancel what inet_frag_alloc()
+		 * anticipated.
+		 */
+		int refs = 1;
 
 		q->flags |= INET_FRAG_COMPLETE;
 		inet_frag_kill(q, &refs);
@@ -407,7 +412,6 @@ static struct inet_frag_queue *inet_frag
 	return q;
 }
 
-/* TODO : call from rcu_read_lock() and no longer use refcount_inc_not_zero() */
 struct inet_frag_queue *inet_frag_find(struct fqdir *fqdir, void *key)
 {
 	/* This pairs with WRITE_ONCE() in fqdir_pre_exit(). */
@@ -417,17 +421,11 @@ struct inet_frag_queue *inet_frag_find(s
 	if (!high_thresh || frag_mem_limit(fqdir) > high_thresh)
 		return NULL;
 
-	rcu_read_lock();
-
 	prev = rhashtable_lookup(&fqdir->rhashtable, key, fqdir->f->rhash_params);
 	if (!prev)
 		fq = inet_frag_create(fqdir, key, &prev);
-	if (!IS_ERR_OR_NULL(prev)) {
+	if (!IS_ERR_OR_NULL(prev))
 		fq = prev;
-		if (!refcount_inc_not_zero(&fq->refcnt))
-			fq = NULL;
-	}
-	rcu_read_unlock();
 	return fq;
 }
 EXPORT_SYMBOL(inet_frag_find);
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -477,18 +477,21 @@ int ip_defrag(struct net *net, struct sk
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMREQDS);
 
 	/* Lookup (or create) queue header */
+	rcu_read_lock();
 	qp = ip_find(net, ip_hdr(skb), user, vif);
 	if (qp) {
-		int ret, refs = 1;
+		int ret, refs = 0;
 
 		spin_lock(&qp->q.lock);
 
 		ret = ip_frag_queue(qp, skb, &refs);
 
 		spin_unlock(&qp->q.lock);
+		rcu_read_unlock();
 		inet_frag_putn(&qp->q, refs);
 		return ret;
 	}
+	rcu_read_unlock();
 
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMFAILS);
 	kfree_skb(skb);
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -452,7 +452,7 @@ int nf_ct_frag6_gather(struct net *net,
 	struct frag_hdr *fhdr;
 	struct frag_queue *fq;
 	struct ipv6hdr *hdr;
-	int refs = 1;
+	int refs = 0;
 	u8 prevhdr;
 
 	/* Jumbo payload inhibits frag. header */
@@ -479,9 +479,11 @@ int nf_ct_frag6_gather(struct net *net,
 	hdr = ipv6_hdr(skb);
 	fhdr = (struct frag_hdr *)skb_transport_header(skb);
 
+	rcu_read_lock();
 	fq = fq_find(net, fhdr->identification, user, hdr,
 		     skb->dev ? skb->dev->ifindex : 0);
 	if (fq == NULL) {
+		rcu_read_unlock();
 		pr_debug("Can't find and can't create new queue\n");
 		return -ENOMEM;
 	}
@@ -495,6 +497,7 @@ int nf_ct_frag6_gather(struct net *net,
 	}
 
 	spin_unlock_bh(&fq->q.lock);
+	rcu_read_unlock();
 	inet_frag_putn(&fq->q, refs);
 	return ret;
 }
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -305,9 +305,7 @@ static int ip6_frag_reasm(struct frag_qu
 	skb_postpush_rcsum(skb, skb_network_header(skb),
 			   skb_network_header_len(skb));
 
-	rcu_read_lock();
 	__IP6_INC_STATS(net, __in6_dev_stats_get(dev, skb), IPSTATS_MIB_REASMOKS);
-	rcu_read_unlock();
 	fq->q.rb_fragments = RB_ROOT;
 	fq->q.fragments_tail = NULL;
 	fq->q.last_run_head = NULL;
@@ -319,9 +317,7 @@ out_oversize:
 out_oom:
 	net_dbg_ratelimited("ip6_frag_reasm: no memory for reassembly\n");
 out_fail:
-	rcu_read_lock();
 	__IP6_INC_STATS(net, __in6_dev_stats_get(dev, skb), IPSTATS_MIB_REASMFAILS);
-	rcu_read_unlock();
 	inet_frag_kill(&fq->q, refs);
 	return -1;
 }
@@ -379,10 +375,11 @@ static int ipv6_frag_rcv(struct sk_buff
 	}
 
 	iif = skb->dev ? skb->dev->ifindex : 0;
+	rcu_read_lock();
 	fq = fq_find(net, fhdr->identification, hdr, iif);
 	if (fq) {
 		u32 prob_offset = 0;
-		int ret, refs = 1;
+		int ret, refs = 0;
 
 		spin_lock(&fq->q.lock);
 
@@ -391,6 +388,7 @@ static int ipv6_frag_rcv(struct sk_buff
 				     &prob_offset, &refs);
 
 		spin_unlock(&fq->q.lock);
+		rcu_read_unlock();
 		inet_frag_putn(&fq->q, refs);
 		if (prob_offset) {
 			__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
@@ -400,6 +398,7 @@ static int ipv6_frag_rcv(struct sk_buff
 		}
 		return ret;
 	}
+	rcu_read_unlock();
 
 	__IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)), IPSTATS_MIB_REASMFAILS);
 	kfree_skb(skb);



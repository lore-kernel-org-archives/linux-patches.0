Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4F4345CAE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301812; cv=none; b=dxSTC8pMlnXSr9GAW53xuuMHMw9edJ3AzoKDQmuEJcxrNsfPaKsSXcJfg3+FUiHjhbwXXW9vqDlUCrxQInMS/BjCMbg+aqTNk2aCNJlmIsnE46PI8EN7EfQtubWqRwkalWrqOrRm1JxKnuWVngIIIBgjbwyZlZTOQBOM8kBphtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301812; c=relaxed/simple;
	bh=aJeBWwVQgfqj15JgZntN4GPS09InVLmu0Rz4jzS8a8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUOUEXP8VxVFHvBl8TFs5Kq44xKtMoVZgeV6cmjusotljz4upwR28dA3+TLrP6HzKraEOTCtEYgv4QUztazGeWDThFl4+IseUpyO3hCiBJ+l5wU8I4X/Q6fyS6n9/PCTQfep9fydG4geeijG9OwjZdr/9In92jg10WrfBHQQlvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F6Z/YPOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F6Z/YPOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AC7C19424;
	Sat, 28 Feb 2026 18:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301811;
	bh=aJeBWwVQgfqj15JgZntN4GPS09InVLmu0Rz4jzS8a8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6Z/YPORE6DGUW6Tt4oZfb9n4k22cvwUIdDDJKVisnI4MhhK4hMDHPu+yuw/i1LJz
	 3ArTRdcpwh1Bkh0u9wekEybpmDmmln8R6MADZEoXBN/MSq4Am5Wfb7uVMZWE7y4po2
	 5C9PQQsP46Bw5IFWdzwhRD3awgvgp7HJi9EHlm0YZBrxgN1G+Xjkm3wHNKjgCn8W30
	 KP6NU53nMLgjw1IfokSW6hxfFX0Cyxf8mAgjri9iWLPiO3cdueC9FbBVkvx52Z4nqE
	 4ngaZD/7suvvURuofQ0LwFhlZeAv9dyTespFfC+6viAiCrFCiM7EYs+IW/jVS9elTk
	 qpXgXcOXtRrgA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Florian Westphal <fw@strlen.de>,
	Ulrich Weber <ulrich.weber@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 225/385] netfilter: nfnetlink_queue: do shared-unconfirmed check before segmentation
Date: Sat, 28 Feb 2026 12:57:27 -0500
Message-ID: <20260228180011.1568201-225-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 207b3ebacb6113acaaec0d171d5307032c690004 ]

Ulrich reports a regression with nfqueue:

If an application did not set the 'F_GSO' capability flag and a gso
packet with an unconfirmed nf_conn entry is received all packets are
now dropped instead of queued, because the check happens after
skb_gso_segment().  In that case, we did have exclusive ownership
of the skb and its associated conntrack entry.  The elevated use
count is due to skb_clone happening via skb_gso_segment().

Move the check so that its peformed vs. the aggregated packet.

Then, annotate the individual segments except the first one so we
can do a 2nd check at reinject time.

For the normal case, where userspace does in-order reinjects, this avoids
packet drops: first reinjected segment continues traversal and confirms
entry, remaining segments observe the confirmed entry.

While at it, simplify nf_ct_drop_unconfirmed(): We only care about
unconfirmed entries with a refcnt > 1, there is no need to special-case
dying entries.

This only happens with UDP.  With TCP, the only unconfirmed packet will
be the TCP SYN, those aren't aggregated by GRO.

Next patch adds a udpgro test case to cover this scenario.

Reported-by: Ulrich Weber <ulrich.weber@gmail.com>
Fixes: 7d8dc1c7be8d ("netfilter: nf_queue: drop packets with cloned unconfirmed conntracks")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_queue.h |   1 +
 net/netfilter/nfnetlink_queue.c  | 123 +++++++++++++++++++------------
 2 files changed, 75 insertions(+), 49 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index e6803831d6af5..45eb26b2e95b3 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -21,6 +21,7 @@ struct nf_queue_entry {
 	struct net_device	*physout;
 #endif
 	struct nf_hook_state	state;
+	bool			nf_ct_is_unconfirmed;
 	u16			size; /* sizeof(entry) + saved route keys */
 	u16			queue_num;
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index fb074e95a767d..af35dbc19864a 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -438,6 +438,34 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	nf_queue_entry_free(entry);
 }
 
+/* return true if the entry has an unconfirmed conntrack attached that isn't owned by us
+ * exclusively.
+ */
+static bool nf_ct_drop_unconfirmed(const struct nf_queue_entry *entry, bool *is_unconfirmed)
+{
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	struct nf_conn *ct = (void *)skb_nfct(entry->skb);
+
+	if (!ct || nf_ct_is_confirmed(ct))
+		return false;
+
+	if (is_unconfirmed)
+		*is_unconfirmed = true;
+
+	/* in some cases skb_clone() can occur after initial conntrack
+	 * pickup, but conntrack assumes exclusive skb->_nfct ownership for
+	 * unconfirmed entries.
+	 *
+	 * This happens for br_netfilter and with ip multicast routing.
+	 * This can't be solved with serialization here because one clone
+	 * could have been queued for local delivery or could be transmitted
+	 * in parallel on another CPU.
+	 */
+	return refcount_read(&ct->ct_general.use) > 1;
+#endif
+	return false;
+}
+
 static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
 	const struct nf_ct_hook *ct_hook;
@@ -465,6 +493,24 @@ static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 			break;
 		}
 	}
+
+	if (verdict != NF_DROP && entry->nf_ct_is_unconfirmed) {
+		/* If first queued segment was already reinjected then
+		 * there is a good chance the ct entry is now confirmed.
+		 *
+		 * Handle the rare cases:
+		 *  - out-of-order verdict
+		 *  - threaded userspace reinjecting in parallel
+		 *  - first segment was dropped
+		 *
+		 * In all of those cases we can't handle this packet
+		 * because we can't be sure that another CPU won't modify
+		 * nf_conn->ext in parallel which isn't allowed.
+		 */
+		if (nf_ct_drop_unconfirmed(entry, NULL))
+			verdict = NF_DROP;
+	}
+
 	nf_reinject(entry, verdict);
 }
 
@@ -892,49 +938,6 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	return NULL;
 }
 
-static bool nf_ct_drop_unconfirmed(const struct nf_queue_entry *entry)
-{
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	static const unsigned long flags = IPS_CONFIRMED | IPS_DYING;
-	struct nf_conn *ct = (void *)skb_nfct(entry->skb);
-	unsigned long status;
-	unsigned int use;
-
-	if (!ct)
-		return false;
-
-	status = READ_ONCE(ct->status);
-	if ((status & flags) == IPS_DYING)
-		return true;
-
-	if (status & IPS_CONFIRMED)
-		return false;
-
-	/* in some cases skb_clone() can occur after initial conntrack
-	 * pickup, but conntrack assumes exclusive skb->_nfct ownership for
-	 * unconfirmed entries.
-	 *
-	 * This happens for br_netfilter and with ip multicast routing.
-	 * We can't be solved with serialization here because one clone could
-	 * have been queued for local delivery.
-	 */
-	use = refcount_read(&ct->ct_general.use);
-	if (likely(use == 1))
-		return false;
-
-	/* Can't decrement further? Exclusive ownership. */
-	if (!refcount_dec_not_one(&ct->ct_general.use))
-		return false;
-
-	skb_set_nfct(entry->skb, 0);
-	/* No nf_ct_put(): we already decremented .use and it cannot
-	 * drop down to 0.
-	 */
-	return true;
-#endif
-	return false;
-}
-
 static int
 __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 			struct nf_queue_entry *entry)
@@ -951,9 +954,6 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 	}
 	spin_lock_bh(&queue->lock);
 
-	if (nf_ct_drop_unconfirmed(entry))
-		goto err_out_free_nskb;
-
 	if (queue->queue_total >= queue->queue_maxlen)
 		goto err_out_queue_drop;
 
@@ -996,7 +996,6 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 		else
 			net_warn_ratelimited("nf_queue: hash insert failed: %d\n", err);
 	}
-err_out_free_nskb:
 	kfree_skb(nskb);
 err_out_unlock:
 	spin_unlock_bh(&queue->lock);
@@ -1075,9 +1074,10 @@ __nfqnl_enqueue_packet_gso(struct net *net, struct nfqnl_instance *queue,
 static int
 nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 {
-	unsigned int queued;
-	struct nfqnl_instance *queue;
 	struct sk_buff *skb, *segs, *nskb;
+	bool ct_is_unconfirmed = false;
+	struct nfqnl_instance *queue;
+	unsigned int queued;
 	int err = -ENOBUFS;
 	struct net *net = entry->state.net;
 	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
@@ -1101,6 +1101,15 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		break;
 	}
 
+	/* Check if someone already holds another reference to
+	 * unconfirmed ct.  If so, we cannot queue the skb:
+	 * concurrent modifications of nf_conn->ext are not
+	 * allowed and we can't know if another CPU isn't
+	 * processing the same nf_conn entry in parallel.
+	 */
+	if (nf_ct_drop_unconfirmed(entry, &ct_is_unconfirmed))
+		return -EINVAL;
+
 	if (!skb_is_gso(skb) || ((queue->flags & NFQA_CFG_F_GSO) && !skb_is_gso_sctp(skb)))
 		return __nfqnl_enqueue_packet(net, queue, entry);
 
@@ -1114,7 +1123,23 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 		goto out_err;
 	queued = 0;
 	err = 0;
+
 	skb_list_walk_safe(segs, segs, nskb) {
+		if (ct_is_unconfirmed && queued > 0) {
+			/* skb_gso_segment() increments the ct refcount.
+			 * This is a problem for unconfirmed (not in hash)
+			 * entries, those can race when reinjections happen
+			 * in parallel.
+			 *
+			 * Annotate this for all queued entries except the
+			 * first one.
+			 *
+			 * As long as the first one is reinjected first it
+			 * will do the confirmation for us.
+			 */
+			entry->nf_ct_is_unconfirmed = ct_is_unconfirmed;
+		}
+
 		if (err == 0)
 			err = __nfqnl_enqueue_packet_gso(net, queue,
 							segs, entry);
-- 
2.51.0


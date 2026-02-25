Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B462C11CD;
	Wed, 25 Feb 2026 06:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002571; cv=none; b=X1eNQe49CWAVINdDxoFNSRvOdCCotoQT862a9LmqNHhgkYPj930KkPN3Ad8F92WjatA7VtjaIOPcHR6pZSi6F9Rst3bIpM+iCg9bVkaKI0NKtabM4Rt6gvLxsC4VbG3pgxozTLy9DTG2Xg0wnJiH8GwTkFtsaps5thr0FjbluXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002571; c=relaxed/simple;
	bh=+rB13NVatJUV5B8tv4A9SBnzYzoKXIVg9xhsLqHXN5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpDa9XyW+3pHan/KrTi/cA31DqX+hVunXd81+HOc47CDVcUsolR85kv8lavH29aWvn2/4mBaFadCBEju4LoylISGI7DoNVasTWkiCuQXhlUhO3yR0XQEhUpuoHGYm99g8FxaMIsM4Ou4H8OYyMp1IFPjKj2kTMa6zt9jG5cu/rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjQCHXm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjQCHXm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E651C19425;
	Wed, 25 Feb 2026 06:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002571;
	bh=+rB13NVatJUV5B8tv4A9SBnzYzoKXIVg9xhsLqHXN5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjQCHXm6T1/ZoKmikhlgHvz6HMm6YV1a4rzdxGL3I3slAPiW5DYDEkf3j8oA9v03j
	 ivnZDLWn4F0iOtfiyKPoRwjVmEzGBdhrr85fFGwO/qS0mgkL48SU69fM36N7rcdCfS
	 VPyzAvbD+kLtbdEt7lC5j0sQXQrmBdgjzR/agWFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulrich Weber <ulrich.weber@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 305/641] netfilter: nfnetlink_queue: do shared-unconfirmed check before segmentation
Date: Tue, 24 Feb 2026 17:20:31 -0800
Message-ID: <20260225012356.129628588@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 336e3ad18e72d..34548213f2f14 100644
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
 
@@ -894,49 +940,6 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -953,9 +956,6 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 	}
 	spin_lock_bh(&queue->lock);
 
-	if (nf_ct_drop_unconfirmed(entry))
-		goto err_out_free_nskb;
-
 	if (queue->queue_total >= queue->queue_maxlen)
 		goto err_out_queue_drop;
 
@@ -998,7 +998,6 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 		else
 			net_warn_ratelimited("nf_queue: hash insert failed: %d\n", err);
 	}
-err_out_free_nskb:
 	kfree_skb(nskb);
 err_out_unlock:
 	spin_unlock_bh(&queue->lock);
@@ -1077,9 +1076,10 @@ __nfqnl_enqueue_packet_gso(struct net *net, struct nfqnl_instance *queue,
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
@@ -1103,6 +1103,15 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
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
 
@@ -1116,7 +1125,23 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
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




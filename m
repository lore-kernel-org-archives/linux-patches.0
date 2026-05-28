Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BFF2459DD;
	Thu, 28 May 2026 20:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001207; cv=none; b=h14fGRoyZJAviujVYR3GEhYUPNqZBTuUej2aeWChpNJ7UCefBkAKNYYN72bQ76P4zyKFojSsXsJTuRjprrwTdhI8LVbf4ncJ0KhbfJKsOytNWrpBV/TmK5QEAL6qNBtx0XJTCWzCHerZjvPwMO0ji6B1lzWLzAJXgqn2bM144+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001207; c=relaxed/simple;
	bh=0PbYREHYDmshUC/D+nHme0TLSq+keC4ACJ9x9xdnYvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvZHwhc/432DF5T1pcBwQLanU6x2lnngoXTiC1d9n1/wiANlbNhs5XMIjMzCu1g48/6Dv2H1EIZhgh1J5nB3s/alARIvx2I4JNcj+xFEA39k0+xXTQtNRcDSVbN9R4K+mwhvJxQFg3BeQHrG4vMHdAX6/GqDebYAyAhIEqmH20M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BRAyPEDj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BRAyPEDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249741F000E9;
	Thu, 28 May 2026 20:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001206;
	bh=p+hqb8iZWGMtlvkFriD61w/w5mn3ya6LkQ16AMxEBTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRAyPEDjJvAnj+YHvoHpPuNmMEVUyOs0YqRWVsG2M2LdldqpkJeQlSbBWstsV26MU
	 aLyo8kUDHsiz+fUwFJ+qk3jU6WtlQq2wVblNo0f2Su3CUj5ja/BxwRZyeKIDFRzR9v
	 ppG8wJtBeaoi3w++XvLE3l1RD1j2goRLp6Ub5x0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Haoze Xie <royenheart@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 045/186] netfilter: nf_queue: hold bridge skb->dev while queued
Date: Thu, 28 May 2026 21:48:45 +0200
Message-ID: <20260528194930.183198855@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: Haoze Xie <royenheart@gmail.com>

commit e196115ec330a18de415bdb9f5071aa9f08e53ce upstream.

br_pass_frame_up() rewrites skb->dev from the ingress port to the bridge
master before queueing bridge LOCAL_IN packets. NFQUEUE only holds
references on state.in/out and bridge physdevs, so a queued bridge
packet can retain a freed bridge master in skb->dev until reinjection.

When the verdict is reinjected later, br_netif_receive_skb() re-enters
the receive path with skb->dev still pointing at the freed bridge master,
triggering a use-after-free.

Store skb->dev in the queue entry, hold a reference on it for the queue
lifetime, and use the saved device when dropping queued packets during
NETDEV_DOWN handling.

Fixes: ac2863445686 ("netfilter: bridge: add nf_afinfo to enable queuing to userspace")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Haoze Xie <royenheart@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_queue.h |    1 +
 net/netfilter/nf_queue.c         |    4 +++-
 net/netfilter/nfnetlink_queue.c  |    2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -12,6 +12,7 @@
 struct nf_queue_entry {
 	struct list_head	list;
 	struct sk_buff		*skb;
+	struct net_device	*skb_dev;
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -60,6 +60,7 @@ static void nf_queue_entry_release_refs(
 	struct nf_hook_state *state = &entry->state;
 
 	/* Release those devices we held, or Alexey will kill me. */
+	dev_put(entry->skb_dev);
 	dev_put(state->in);
 	dev_put(state->out);
 	if (state->sk)
@@ -101,6 +102,7 @@ bool nf_queue_entry_get_refs(struct nf_q
 	if (state->sk && !refcount_inc_not_zero(&state->sk->sk_refcnt))
 		return false;
 
+	dev_hold(entry->skb_dev);
 	dev_hold(state->in);
 	dev_hold(state->out);
 
@@ -201,11 +203,11 @@ static int __nf_queue(struct sk_buff *sk
 
 	*entry = (struct nf_queue_entry) {
 		.skb	= skb,
+		.skb_dev = skb->dev,
 		.state	= *state,
 		.hook_index = index,
 		.size	= sizeof(*entry) + route_key_size,
 	};
-
 	__nf_queue_entry_init_physdevs(entry);
 
 	if (!nf_queue_entry_get_refs(entry)) {
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -972,6 +972,8 @@ dev_cmp(struct nf_queue_entry *entry, un
 	if (physinif == ifindex || physoutif == ifindex)
 		return 1;
 #endif
+	if (entry->skb_dev && entry->skb_dev->ifindex == ifindex)
+		return 1;
 	if (entry->state.in)
 		if (entry->state.in->ifindex == ifindex)
 			return 1;



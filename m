Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0B4274FDC;
	Sat, 30 May 2026 18:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164992; cv=none; b=ZctOtoyCV2X12bYFmPrDVIQsflIzty/EWxFYmfzXWEYApW2EpZvSh/OC1Gp5kaVflVUi/ygy6DPNQS4YqFG5RcOUUIujJ4FCs6iQFLE3GvQTqP8T8xFvDoIu91i9cY0HohePFc9DvrL/sbrhZzypumMiP+ZIZzM7ve6mHQq3ba0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164992; c=relaxed/simple;
	bh=uC9eEmGEAIPCcoIRt2+r2Skg2ttW4qqNf/fMpyh0XWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/E5ia+WtvDJ9touDoid6bAf+e2L/pjcO6UuyGfWVeiKcGF8Gli7gLKFr74JqED/2fKeOcGhKAzU5UvKwfA2pS4gU5XwXyETUSnnkVNW7LUebQOZjGkcPfzso5ATrdX4aX24D0C2oJaGBNNPIM/ZBc8PH0/5hk2OyN9Uz3vfVwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoXSOUaR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoXSOUaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2A31F00893;
	Sat, 30 May 2026 18:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164991;
	bh=5cbZDdTXrooktq1ONXj4AKV7zSd3Ky+55KNG3x+N58w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HoXSOUaRqHuXxQznryZL3rhMxHFtrMLW0Yr18A+qquS5a1tCrUs84dH6mnfJFxLXO
	 pMPAQCVXK5QDrU77XT81a369ts8g9cFwDVTBeEBulHu/0NUP/Zt3ADbpCylgh1X8fK
	 QOSZmZ8hHassgIzDk7EnSb8tU2XEKXhEBkwqXrUE=
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
Subject: [PATCH 5.15 688/776] netfilter: nf_queue: hold bridge skb->dev while queued
Date: Sat, 30 May 2026 18:06:42 +0200
Message-ID: <20260530160257.635952439@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -103,6 +104,7 @@ bool nf_queue_entry_get_refs(struct nf_q
 	if (state->sk && !refcount_inc_not_zero(&state->sk->sk_refcnt))
 		return false;
 
+	dev_hold(entry->skb_dev);
 	dev_hold(state->in);
 	dev_hold(state->out);
 
@@ -203,11 +205,11 @@ static int __nf_queue(struct sk_buff *sk
 
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
@@ -944,6 +944,8 @@ dev_cmp(struct nf_queue_entry *entry, un
 	if (physinif == ifindex || physoutif == ifindex)
 		return 1;
 #endif
+	if (entry->skb_dev && entry->skb_dev->ifindex == ifindex)
+		return 1;
 	if (entry->state.in)
 		if (entry->state.in->ifindex == ifindex)
 			return 1;



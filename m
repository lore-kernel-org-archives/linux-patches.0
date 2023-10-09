Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EB319464
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVQ1hjsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021E8C43391;
	Mon,  9 Oct 2023 13:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857119;
	bh=TeTV9nkuaN906CaqNvWreNtgtfVz6qU3ihuNVr/LhwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVQ1hjsAGWjf5Z5I3CYiHVwqMF6HnfX6b+LqbfkW04heQ+w7l8mdtrKWXFxhM7eNz
	 A/WpfxnzyyRiGU0kR3SoiYQVnlptJIyIC3Net3xFkWzfHsVJiIwG3nlEZL08ayB8O3
	 J92u5qF0TuRzomzl6/VMYtkIiTSyPYqUDHtrsq/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 103/163] neighbour: fix data-races around n->output
Date: Mon,  9 Oct 2023 15:01:07 +0200
Message-ID: <20231009130126.873256885@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5baa0433a15eadd729625004c37463acb982eca7 ]

n->output field can be read locklessly, while a writer
might change the pointer concurrently.

Add missing annotations to prevent load-store tearing.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/neighbour.h         |  2 +-
 net/bridge/br_netfilter_hooks.c |  2 +-
 net/core/neighbour.c            | 10 +++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index f6a8ecc6b1fa7..ccc4a0f8b4ad8 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -541,7 +541,7 @@ static inline int neigh_output(struct neighbour *n, struct sk_buff *skb,
 	    READ_ONCE(hh->hh_len))
 		return neigh_hh_output(hh, skb);
 
-	return n->output(n, skb);
+	return READ_ONCE(n->output)(n, skb);
 }
 
 static inline struct neighbour *
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 1a801fab9543e..0be889905c2b6 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -294,7 +294,7 @@ int br_nf_pre_routing_finish_bridge(struct net *net, struct sock *sk, struct sk_
 			/* tell br_dev_xmit to continue with forwarding */
 			nf_bridge->bridged_dnat = 1;
 			/* FIXME Need to refragment */
-			ret = neigh->output(neigh, skb);
+			ret = READ_ONCE(neigh->output)(neigh, skb);
 		}
 		neigh_release(neigh);
 		return ret;
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index b57d3ea3ccc9e..f16ec0e8a0348 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -410,7 +410,7 @@ static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
 				 */
 				__skb_queue_purge(&n->arp_queue);
 				n->arp_queue_len_bytes = 0;
-				n->output = neigh_blackhole;
+				WRITE_ONCE(n->output, neigh_blackhole);
 				if (n->nud_state & NUD_VALID)
 					n->nud_state = NUD_NOARP;
 				else
@@ -920,7 +920,7 @@ static void neigh_suspect(struct neighbour *neigh)
 {
 	neigh_dbg(2, "neigh %p is suspected\n", neigh);
 
-	neigh->output = neigh->ops->output;
+	WRITE_ONCE(neigh->output, neigh->ops->output);
 }
 
 /* Neighbour state is OK;
@@ -932,7 +932,7 @@ static void neigh_connect(struct neighbour *neigh)
 {
 	neigh_dbg(2, "neigh %p is connected\n", neigh);
 
-	neigh->output = neigh->ops->connected_output;
+	WRITE_ONCE(neigh->output, neigh->ops->connected_output);
 }
 
 static void neigh_periodic_work(struct work_struct *work)
@@ -1449,7 +1449,7 @@ static int __neigh_update(struct neighbour *neigh, const u8 *lladdr,
 				if (n2)
 					n1 = n2;
 			}
-			n1->output(n1, skb);
+			READ_ONCE(n1->output)(n1, skb);
 			if (n2)
 				neigh_release(n2);
 			rcu_read_unlock();
@@ -3155,7 +3155,7 @@ int neigh_xmit(int index, struct net_device *dev,
 			rcu_read_unlock();
 			goto out_kfree_skb;
 		}
-		err = neigh->output(neigh, skb);
+		err = READ_ONCE(neigh->output)(neigh, skb);
 		rcu_read_unlock();
 	}
 	else if (index == NEIGH_LINK_TABLE) {
-- 
2.40.1




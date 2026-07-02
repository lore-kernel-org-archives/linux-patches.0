Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C63414DE5;
	Thu,  2 Jul 2026 16:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009433; cv=none; b=SEock9FhN06c8gIcCvHfTw7QtqY6z3idJP55R1vlOZFlIXxx2PXeUFSpDjqrMBTfGc+pMK7Rn9D3AquKvCv3YV549gOO1QR7q4rQIhsAJxr+eHtbpQxKp7uosBhfATVQvOYXWvioNb6O1SYGN3kBpOvokjeASa++dNkF6zMM7g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009433; c=relaxed/simple;
	bh=aofA1hjVITO0VUPIaAwPNmQ+isboBcx4+cgpGSbGJ9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5V9y58aE0EMQ3ezdtA9DbQ7lvISTSTytifnufiVonw26jTUGiGeqdAty2QIixE7EJDEWfHrVAC9n4gxprtC2Ho5CD5V5POl2Jpq83YuUCVUKD9ZronckxCJOVjRZj8Q/nQhBgb3qXxrkmbO5CqJThK0f8q7vphumz8I8rxrTPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tpbVfkJt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tpbVfkJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C8A1F000E9;
	Thu,  2 Jul 2026 16:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009426;
	bh=B9CK0rEbxwsN36GUflIBSR9ChcdlRQTG0FVMV7IlaDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tpbVfkJtrgUIrXciW6xwpFlpwb0FhhRk+cwB8ljlgloHKjC870MwKG092Z4wcx9Wc
	 DeYYMDftnwPH3SWlcKpkKq57fEt73DnFaIg75hA49v/TinbS+/JGrqi9klnGqjgICk
	 bj4/e8cRmJk2JSgGh2ypqhV1H7Q9Ou2yIFffTa4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 45/96] batman-adv: frag: ensure fragment is writable before modifying TTL
Date: Thu,  2 Jul 2026 18:19:37 +0200
Message-ID: <20260702155109.931718595@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit b7293c6e8c15b2db77809b25cf8389e35331b27a upstream.

Before batman-adv is allowed to write to an skb, it either has to have its
own copy of the skb or use skb_cow() to ensure that the data part is not
shared. But batadv_frag_skb_fwd() modifies the TTL even when it is shared.

Adding a skb_cow() right before this operation avoids this and can at the
same time prepare it for the modifications required to forward the
fragment.

Cc: stable@kernel.org
Fixes: 610bfc6bc99b ("batman-adv: Receive fragmented packets and merge")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/fragmentation.c | 15 ++++++++++++++-
 net/batman-adv/fragmentation.h |  3 ++-
 net/batman-adv/routing.c       |  3 +--
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 724e06e3e799f4..95c88bbdbcbee0 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -386,6 +386,8 @@ bool batadv_frag_skb_buffer(struct sk_buff **skb,
  * @skb: skb to forward
  * @recv_if: interface that the skb is received on
  * @orig_node_src: originator that the skb is received from
+ * @rx_result: set to NET_RX_SUCCESS when the fragment was forwarded and
+ *  NET_RX_DROP when it was dropped; only valid when true is returned
  *
  * Look up the next-hop of the fragments payload and check if the merged packet
  * will exceed the MTU towards the next-hop. If so, the fragment is forwarded
@@ -395,7 +397,8 @@ bool batadv_frag_skb_buffer(struct sk_buff **skb,
  */
 bool batadv_frag_skb_fwd(struct sk_buff *skb,
 			 struct batadv_hard_iface *recv_if,
-			 struct batadv_orig_node *orig_node_src)
+			 struct batadv_orig_node *orig_node_src,
+			 int *rx_result)
 {
 	struct batadv_priv *bat_priv = netdev_priv(recv_if->soft_iface);
 	struct batadv_orig_node *orig_node_dst;
@@ -418,12 +421,22 @@ bool batadv_frag_skb_fwd(struct sk_buff *skb,
 	 */
 	total_size = ntohs(packet->total_size);
 	if (total_size > neigh_node->if_incoming->net_dev->mtu) {
+		if (skb_cow(skb, ETH_HLEN) < 0) {
+			kfree_skb(skb);
+			*rx_result = NET_RX_DROP;
+			ret = true;
+			goto out;
+		}
+
+		packet = (struct batadv_frag_packet *)skb->data;
+
 		batadv_inc_counter(bat_priv, BATADV_CNT_FRAG_FWD);
 		batadv_add_counter(bat_priv, BATADV_CNT_FRAG_FWD_BYTES,
 				   skb->len + ETH_HLEN);
 
 		packet->ttl--;
 		batadv_send_unicast_skb(skb, neigh_node);
+		*rx_result = NET_RX_SUCCESS;
 		ret = true;
 	}
 
diff --git a/net/batman-adv/fragmentation.h b/net/batman-adv/fragmentation.h
index 881ef328b6cd7e..aba6eecb7d0e76 100644
--- a/net/batman-adv/fragmentation.h
+++ b/net/batman-adv/fragmentation.h
@@ -19,7 +19,8 @@ void batadv_frag_purge_orig(struct batadv_orig_node *orig,
 			    bool (*check_cb)(struct batadv_frag_table_entry *));
 bool batadv_frag_skb_fwd(struct sk_buff *skb,
 			 struct batadv_hard_iface *recv_if,
-			 struct batadv_orig_node *orig_node_src);
+			 struct batadv_orig_node *orig_node_src,
+			 int *rx_result);
 bool batadv_frag_skb_buffer(struct sk_buff **skb,
 			    struct batadv_orig_node *orig_node);
 int batadv_frag_send_packet(struct sk_buff *skb,
diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index 9e5c71e406ffc6..f6df66a534c41e 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1143,10 +1143,9 @@ int batadv_recv_frag_packet(struct sk_buff *skb,
 
 	/* Route the fragment if it is not for us and too big to be merged. */
 	if (!batadv_is_my_mac(bat_priv, frag_packet->dest) &&
-	    batadv_frag_skb_fwd(skb, recv_if, orig_node_src)) {
+	    batadv_frag_skb_fwd(skb, recv_if, orig_node_src, &ret)) {
 		/* skb was consumed */
 		skb = NULL;
-		ret = NET_RX_SUCCESS;
 		goto put_orig_node;
 	}
 
-- 
2.53.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C03535E55D;
	Thu,  2 Jul 2026 16:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010098; cv=none; b=m+xKllf6cYnynFlynE2nzwnyilMmHCsMqVUEhARpZ/gQYGyYm+v8M2/qdKDLvZL3NzRb1AXIcQEKMvGUE8Zu93xZ98d5KUv0nquXufi8amQfACwFVvWl6or+iF72Y0Cr+QcRtrrET0tI/IOT9xCOuFNodCmueTbblxj9hk+nWlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010098; c=relaxed/simple;
	bh=WzdU1dBsa/MNpygvjUx0vPU84cZKUaBeNcsJkOf0Bak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiLfS4Utc4eMn50SOX5kkdKe81FIKd14w9tq+F67F+GTc2h8BgO5NC9Da2X9/CHJhl/vip9Ug2SRdNvRwU/VNzZZw+L15ssHXQgQlT3EZq8jnB+JhReeZKRzQAf0tRQeaUjFa2vBIxdVPfVu5rYtroeI0aj11wMJAMhprHdSmYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3wd7sdJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3wd7sdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878881F00A3A;
	Thu,  2 Jul 2026 16:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010096;
	bh=HLzD68sDlZguNnc7FvvPReQ7MHm4HbYpRUAvJKRrYkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3wd7sdJJjcziIBKLwnkDu0R36PquWxwX8uw6E/ixyjayVUK9jchidrqBf3gg/VtI
	 Zx9a3XHJPjHrg+3L0Ppy3B2l/JKGurV+Gw4QCN9xWMaeQnnMYN4nIRmIUv02IeUEPB
	 UfV50eJCE+LGqekwC0IUzTMf7E+ZBpzgdvua2yUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/129] batman-adv: frag: avoid underflow of TTL
Date: Thu,  2 Jul 2026 18:19:43 +0200
Message-ID: <20260702155113.469334346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 493d9d2528e1a09b090e4b37f0f553def7bd5ce9 upstream.

Packets with a TTL are using it to limit the amount of time this packet can
be forwarded. But for batadv_frag_packet, the TTL was always only reduced
but it was never evaluated. It could even underflow without any effect.

Check the TTL in batadv_frag_skb_fwd() before attempting to prepare it for
forwarding. This keeps it in sync with the not fragmented unicast packet.

Cc: stable@kernel.org
Fixes: 610bfc6bc99b ("batman-adv: Receive fragmented packets and merge")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/fragmentation.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index fbf030c57ac04d..0138b0953e10b5 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -420,6 +420,13 @@ bool batadv_frag_skb_fwd(struct sk_buff *skb,
 	 */
 	total_size = ntohs(packet->total_size);
 	if (total_size > neigh_node->if_incoming->net_dev->mtu) {
+		if (packet->ttl < 2) {
+			kfree_skb(skb);
+			*rx_result = NET_RX_DROP;
+			ret = true;
+			goto out;
+		}
+
 		if (skb_cow(skb, ETH_HLEN) < 0) {
 			kfree_skb(skb);
 			*rx_result = NET_RX_DROP;
-- 
2.53.0




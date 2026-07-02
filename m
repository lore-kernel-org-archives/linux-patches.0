Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3569C49550B;
	Thu,  2 Jul 2026 16:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010515; cv=none; b=ZDZXRz5ULCO0dejoRFOnZcGXvHAm5SND/0VdJlFd9YcpUNjiLgPLfzZryrHtULLH9wmLJOJJFS2PLcp2qKcqvhcVLLtB6fHeXD06U6I+W2WPikF5QKaKU0EKjT4aRHpYrNFR83R4VpMUVCxc0Id9wUUZEkslnJjjS6jFrixPr4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010515; c=relaxed/simple;
	bh=pWh5smbEj9rthiSZFTbOX7UQ/GUTe6qpajAZgBYG6Us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dn70lc3vRcJkxkiwxkmRxG67BVTiA1n8ijU5dBoFka3aWj/YFVdGEFgIRBf/SY1zJHGF7YBhCGEQopNJsC5qqVl0PIwG2Yo0S/1g2Q2Di0m27gRpiFLETZc+ExuPwzbVcG2b1S8UrFyiJR8RMnYy0JNDtDXKkW7eGcMvQMdDKnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQZa5Zzn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQZa5Zzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C78E1F000E9;
	Thu,  2 Jul 2026 16:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010514;
	bh=pA2MfYoeQ76EQgvHSe51QqtEl9KbV7VEOmOV9DwIXoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQZa5ZznEKXxGzBg0BX8nwwNlgkB/5J5+y7xMEjZ4Jf9GpSJegWfEikkcnAwrLeRl
	 WqcD5wqRhWnhcuFoFdiRZdd0Z35p6QH7sjSbH2CrrfrMqnOOW4YTGEPISWwNmu8YU9
	 vYXdi0U1f4HQOvQ97M+jfTZYRFiY7nLRWcEmiUG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/204] batman-adv: fix (m|b)cast csum after decrementing TTL
Date: Thu,  2 Jul 2026 18:19:28 +0200
Message-ID: <20260702155120.986410587@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit e728bbdf32660c8f32b8f5e8d09427a2c131ad60 upstream.

The broadcast and multicast packets can be received at the same time by the
local system and forwarded to other nodes. Both are simply decrementing the
TTL at the beginning of the receive path - independent of chosen paths
(receive/forward). But such a modification of the data conflicts with the
hw csum. This is not a problem when the packet is directly forwarded but
can cause errors in the local receive path.

Such a problem can then trigger a "hw csum failure". The receiver path must
therefore ensure that the csum is fixed for each modification of the
payload before batadv_interface_rx() is reached.

Since all batman-adv packet types with a ttl have it as u8 at offset 2, a
helper can be used for all of them. But it is only used at the moment for
batadv_bcast_packet and batadv_mcast_packet because they are the only ones
which deliver the packet locally but unconditionally modify the TTL.

Cc: stable@kernel.org
Fixes: 3f69339068f9 ("batman-adv: bcast: queue per interface, if needed")
Fixes: 07afe1ba288c ("batman-adv: mcast: implement multicast packet reception and forwarding")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/routing.c | 58 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index 32a40c1c115c6a..85bc2d284a7798 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -8,6 +8,7 @@
 #include "main.h"
 
 #include <linux/atomic.h>
+#include <linux/build_bug.h>
 #include <linux/byteorder/generic.h>
 #include <linux/compiler.h>
 #include <linux/errno.h>
@@ -205,6 +206,59 @@ bool batadv_check_management_packet(struct sk_buff *skb,
 	return true;
 }
 
+/**
+ * batadv_skb_decrement_ttl() - decrement ttl in a batman-adv header, csum-safe
+ * @skb: the received packet with @skb->data pointing to the batman-adv header
+ *
+ * Supports the following packet types, all of which carry the TTL at offset 2:
+ *
+ * - batadv_ogm_packet
+ * - batadv_ogm2_packet
+ * - batadv_icmp_header
+ * - batadv_icmp_packet
+ * - batadv_icmp_tp_packet
+ * - batadv_icmp_packet_rr
+ * - batadv_unicast_packet
+ * - batadv_frag_packet
+ * - batadv_bcast_packet
+ * - batadv_mcast_packet
+ * - batadv_coded_packet
+ * - batadv_unicast_tvlv_packet
+ *
+ * Return: true if the packet may be forwarded (ttl decremented),
+ *  false if it must be dropped (ttl would expire)
+ */
+static bool batadv_skb_decrement_ttl(struct sk_buff *skb)
+{
+	static const size_t ttl_offset = 2;
+	u8 *ttl_pos;
+
+	BUILD_BUG_ON(offsetof(struct batadv_ogm_packet, ttl) != ttl_offset);
+	BUILD_BUG_ON(offsetof(struct batadv_ogm2_packet, ttl) != ttl_offset);
+	BUILD_BUG_ON(offsetof(struct batadv_icmp_header, ttl) != ttl_offset);
+	BUILD_BUG_ON(offsetof(struct batadv_icmp_packet, ttl) != ttl_offset);
+	BUILD_BUG_ON(offsetof(struct batadv_icmp_tp_packet, ttl) != ttl_offset);
+	BUILD_BUG_ON(offsetof(struct batadv_icmp_packet_rr, ttl) != ttl_offset);
+	BUILD_BUG_ON(offsetof(struct batadv_unicast_packet, ttl) != ttl_offset);
+	BUILD_BUG_ON(offsetof(struct batadv_frag_packet, ttl) != ttl_offset);
+	BUILD_BUG_ON(offsetof(struct batadv_bcast_packet, ttl) != ttl_offset);
+	BUILD_BUG_ON(offsetof(struct batadv_mcast_packet, ttl) != ttl_offset);
+	BUILD_BUG_ON(offsetof(struct batadv_coded_packet, ttl) != ttl_offset);
+	BUILD_BUG_ON(offsetof(struct batadv_unicast_tvlv_packet, ttl) != ttl_offset);
+
+	ttl_pos = skb->data + ttl_offset;
+
+	/* would expire on this hop -> drop, leave header + csum untouched */
+	if (*ttl_pos < 2)
+		return false;
+
+	skb_postpull_rcsum(skb, ttl_pos, 1);
+	(*ttl_pos)--;
+	skb_postpush_rcsum(skb, ttl_pos, 1);
+
+	return true;
+}
+
 /**
  * batadv_recv_my_icmp_packet() - receive an icmp packet locally
  * @bat_priv: the bat priv with all the soft interface information
@@ -1204,7 +1258,7 @@ int batadv_recv_bcast_packet(struct sk_buff *skb,
 
 	bcast_packet = (struct batadv_bcast_packet *)skb->data;
 
-	if (bcast_packet->ttl-- < 2)
+	if (!batadv_skb_decrement_ttl(skb))
 		goto free_skb;
 
 	orig_node = batadv_orig_hash_find(bat_priv, bcast_packet->orig);
@@ -1311,7 +1365,7 @@ int batadv_recv_mcast_packet(struct sk_buff *skb,
 		goto free_skb;
 
 	mcast_packet = (struct batadv_mcast_packet *)skb->data;
-	if (mcast_packet->ttl-- < 2)
+	if (!batadv_skb_decrement_ttl(skb))
 		goto free_skb;
 
 	tvlv_buff = (unsigned char *)(skb->data + hdr_size);
-- 
2.53.0




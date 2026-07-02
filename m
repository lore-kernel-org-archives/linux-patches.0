Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E521F26F46F;
	Thu,  2 Jul 2026 16:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011481; cv=none; b=Urex/FzjZX8Yc/IPj0sYC/5qmAYx3rOLPwd3IR7uI86ppxCydBlX+xYPtj6JQc+rIAbgGAMiSXqp3Fv350oRIhmp4yBoa5znZWHvW3i/awPKDBeQ2t64gmy7vkUKRx8KL760Enu1AGGL4qJqoSwAUw99+TBm7Vgxea52iAv8cag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011481; c=relaxed/simple;
	bh=bxFV1+SQqNw4FDzk6XnlJ7zdU/cjJeAj9GZKtf0JkLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUUIuIYqeNtRKZxdcV9Tn5haAwjmi9FwirjRAi8B7fyboJcsFvuu6wdZl8mdrfFUN32eJwpCTgAYxyOlHBuXznJ9ymegVdy5McDLlc9JRPwaoyLVzUtZzCIy1ytoC+lOJmX16zlXtT7k2HBWTOqalW/jBZgH/CP+l0cM9PeLEdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DlIMEMkI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DlIMEMkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF381F000E9;
	Thu,  2 Jul 2026 16:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011480;
	bh=aEgi6KOJxuXur3HD3PPoLFD4lUEgehBybt3T8B0cks0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DlIMEMkIm/enaDrH/jAAPNl5K0qkwFhJSohukojqVYA9q9IeR4prIRxC7E52IRgku
	 4yKNs/ZTpkpiLGCIORD1PersERDRdq7fNg+A5YzgMWgUii88GNrKfuQhf0BjrwhHEn
	 K9EUcGNfHfAH2WcrT4c9rdI1l4zdMmqcpxRXif7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 017/120] batman-adv: frag: avoid underflow of TTL
Date: Thu,  2 Jul 2026 18:20:13 +0200
Message-ID: <20260702155113.318551460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5c2a7629e4e09d..9a5927ecc4746f 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -415,6 +415,13 @@ bool batadv_frag_skb_fwd(struct sk_buff *skb,
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




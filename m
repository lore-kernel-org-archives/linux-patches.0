Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6605E349CF2;
	Thu,  2 Jul 2026 16:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009570; cv=none; b=O7JHVzsBPyMUcGIaL8g6sWBbUTCjj1gZ5/4wMkm4obtPU75pnVITy86f+ziLxGTai3OxiGrTbjiSfsvEGywRE3ipLGFaqlxH0xHybYoz8N/bwKYBXM/Lz4RJIAyYH0x2+JBB0rUPl+QTuHf7MxfxsXoyUc4bCPfXpbElAloKtTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009570; c=relaxed/simple;
	bh=1eUTaeNiwWoPPmi3WWo23QnxBGuf/5JJQ3L59RoKf6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsaXkycm041v9CQdgT5JSFBX7sAFLh0AGrWnI6wMiAJ8b81YW6WKGnSVwVPRaQ0znQ5LPDu0Ndg0WRgaNrjKEt4LRzLZmIYdiF9Zo6rrwrbDdorgyeWOA0amea7jn97XhQhIAJj80sjv+jUCZQcaRzFn6LZKseONnjRahhYyJUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QuGjLAsH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QuGjLAsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8CE1F000E9;
	Thu,  2 Jul 2026 16:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009568;
	bh=VWI96jFTa4lsa9bzdXyGmkpJNwM5jUlMrHkliS8zIE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QuGjLAsHEjoFpZwnRlOxs84IlJg5HaEoK1juyc5LBQ9fUIk2dbzOc2K9zaRTmMtK7
	 ZJRxdqrrOR3S30hXxzZarObu5Yeie1msGuxaUgu+S6ellF7RwLMHXpyfRi11iB5lms
	 yChlB34vdyVdeiYTbmLb2KyXrJKnao02HYGimm54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 46/96] batman-adv: frag: avoid underflow of TTL
Date: Thu,  2 Jul 2026 18:19:38 +0200
Message-ID: <20260702155109.951616022@linuxfoundation.org>
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
index 95c88bbdbcbee0..43dfe86f07a9b1 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -421,6 +421,13 @@ bool batadv_frag_skb_fwd(struct sk_buff *skb,
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




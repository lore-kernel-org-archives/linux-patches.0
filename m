Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F018C315D33;
	Thu,  2 Jul 2026 16:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010564; cv=none; b=qKgTfwyjksLkKlTKQmcb34IQpVkdMooqdpOJD41Z4iABRM/T94RFz9kCQ7eM2qUe07u2z1cvNB0DqLJCLQ1BiZtWZmO3F5pS4cMT8S+t+igaWgmx8sCJRxGgQW4Qk2pmJnv8RqLveEoDtE4qApsSbgKYMQyZHSoUt5x789uFm74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010564; c=relaxed/simple;
	bh=Bd2FCdihhLvDZDyd4U7yU2vJCQ4aH2lEeyv4CNiTBVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIGjR0g76vvOn021oj5byn/ssd5i6feT5bhIWbaV984zorw3OlQblp5Fny+azEOdEONIlTWrH6w49zfQbu+V/MW0eEmnVYjiFk3ojcJ4DT9S1UOM/Nfi0YKdnQ+c9SJa7uroqGSGqtuYexFxzxjyyTBaDLprwJxqI3Vl1VU9uk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUp0cKxA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUp0cKxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EE31F000E9;
	Thu,  2 Jul 2026 16:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010563;
	bh=IcepAp++jg8CnpIkFM2u6ziSZoSP7OWvH16VEnfOilk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MUp0cKxAHJBgHuE1rda+uchvmzvohwt4Bnr8o1z1C+qZcrq7c6xoWFNNApMf+DsyM
	 Z4pUyCtQv4UizqBJKvlF6e+WJacbgoZ1SuSAH+ePmXRXO/uspFPOLMT1GUwyz8w/27
	 KWLLKSknpaD95/b/aQXhdyJ/zap084A864abc1LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/204] batman-adv: frag: avoid underflow of TTL
Date: Thu,  2 Jul 2026 18:19:30 +0200
Message-ID: <20260702155121.028170700@linuxfoundation.org>
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
index f6714405b0f948..375c9499121346 100644
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




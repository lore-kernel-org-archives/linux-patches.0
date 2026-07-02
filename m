Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9234B26F46F;
	Thu,  2 Jul 2026 16:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011208; cv=none; b=BQVs76ivS07Vdzj1Tcc70GA1kQBTVxug0eGMsgNZekL0OeWXNSMDDLa+CPxcw05XOahl7P8sntfEdx+iOEHypo8p2HPkztgh0gyVX5h3xbKZcYm4EdwPXKRDoEbfYkvYzlhG/dxaXoRFuFJJ+XX6vZgdxd+Z7pqBASh3CrMRSJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011208; c=relaxed/simple;
	bh=tuc0o2bqUDuG1hVMWHoAn5I0r/L3cT3umShTTvraBYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7pdgYq6Xj3gn/wHONjZDoIGQhdmWgrEK54krCFULeyu3uZgXhJosAOibYOE9Gl+gFqhuimq0rayLe95tnBASO6fZn37ytSlljwaph++JS96vs3ZDmmEa6uii5n9Utg1p411xKfirWmro7bTJIZjRZyJfXsVhsQqCqbUZ7rrCx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s9jH8vE0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s9jH8vE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EE81F000E9;
	Thu,  2 Jul 2026 16:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011207;
	bh=vI+6KJs8ZgzDsLzgrFVLvy9G8dOKgyvZLyKNxRx+G9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s9jH8vE0Z3An1CuJ0QhXKoU8Tqhqcskz1wnA7sEi4Bjjees6e8EQJTMhcYLpkRZQR
	 +jQSW0dSZq+I1O1PiH4gPAswUBsHG0CF4RHnek9tAx18lhBMVuvuMbfWpzNgKisT+Z
	 lUhlgGywOW7eme9lFNNlKX2fVmbR3r843KEPDYPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 021/108] batman-adv: frag: avoid underflow of TTL
Date: Thu,  2 Jul 2026 18:20:18 +0200
Message-ID: <20260702155112.548911921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
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
index ffa5d4b0740959..4779741e7273ea 100644
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




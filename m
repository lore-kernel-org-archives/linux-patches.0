Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FDD354AE3;
	Fri,  7 Aug 2026 15:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117513; cv=none; b=CZxeO1/UVcoaKUpRzgwAhBZRF67hXStCVXbGy0IWzeA9MLpWHJ7NRCx5BBMFFjvOv93Ha3Fv5fTRAeiZ4umlvhU54NYmaPHHCZXsq+0fzh5It3bEAqDV4+zxp/8p2ql+vROwjTcUs/h94VSoYsUSRATXqZCFkQslcaLz0jjcjjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117513; c=relaxed/simple;
	bh=8wSgA6JKhdFrr9yYOxYxfCC2+lhgEB85ftgwMm4sekw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRHIk7ac0BAb2GAR6rJG+mb4HkakbK9/T9ROPxr1Sj9xtiYzO0GqURNOuSFx58n1TssD22dJRm9IiChIvDqI4I3eUZxRawRExNrXsNYHdbKX4Fd2ech+cywIg0D5lqxFg7MSYrkcQ55FEpf0txrOABdJVb1qsmYAKDxh0WMa0w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cLw4NDih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cLw4NDih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89981F000E9;
	Fri,  7 Aug 2026 15:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117512;
	bh=d/x12fezSijydpEtfaSLQHmaN28OqzAFhVUZxyGIhCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cLw4NDih62kxWpCVGt7yEgC+FBDidE2m+GcD0w4irGplicSklN55uBKRu6rdVlbH3
	 yMn+1rWDkUotcI03TO4V1+POIdw46cYhLNayj+ltFhF/eubvvBMfAZabHEr+4kSdvY
	 b0XI1Coar9rgOhzscn5KDJdygR28/sDjygr3jBRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 308/438] vxlan: use neigh_ha_snapshot() in route_shortcircuit()
Date: Fri,  7 Aug 2026 16:38:24 +0200
Message-ID: <20260807143434.538099866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 8eca411347e1d38964f9ed2c8d3b6ab0e7e4473d upstream.

The neighbour hardware address n->ha can be updated asynchronously by the
neighbour subsystem, protected by n->ha_lock seqlock. Reading n->ha without
holding the seqlock loop can lead to torn reads or reading a partially updated
MAC address.

Use neigh_ha_snapshot() in route_shortcircuit() to safely copy n->ha under
read_seqbegin()/read_seqretry() lock protection before using it.

Note that arp_reduce() and neigh_reduce() seem to have the same issue
left for future patches.

Fixes: e4f67addf158 ("add DOVE extensions for VXLAN")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260723144249.759100-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2160,9 +2160,11 @@ static bool route_shortcircuit(struct ne
 	}
 
 	if (n) {
+		u8 haddr[ETH_ALEN];
 		bool diff;
 
-		diff = !ether_addr_equal(eth_hdr(skb)->h_dest, n->ha);
+		neigh_ha_snapshot(haddr, n, dev);
+		diff = !ether_addr_equal_unaligned(eth_hdr(skb)->h_dest, haddr);
 		if (diff) {
 			if (skb_cow_head(skb, 0)) {
 				neigh_release(n);
@@ -2170,7 +2172,7 @@ static bool route_shortcircuit(struct ne
 			}
 			memcpy(eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
 				dev->addr_len);
-			memcpy(eth_hdr(skb)->h_dest, n->ha, dev->addr_len);
+			memcpy(eth_hdr(skb)->h_dest, haddr, dev->addr_len);
 		}
 		neigh_release(n);
 		return diff;



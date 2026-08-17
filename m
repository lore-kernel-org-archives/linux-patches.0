Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CEE3EC83A;
	Mon, 17 Aug 2026 15:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980001; cv=none; b=ZYl8AJ/0DzCb5QYG/QrGi5O6i3B+/pvDKr00arhJSGxartHYpI526YjKK3yX2KvKZmxQP+vFv1JLDXqE3PAqxk2R8sSWSavdSDgFymGrFMoVP8Vuhmq0VJR7tFDXhmlz5H8cUeuxL5RAaHmGNC13SHbqvCFdd3Aqo+0ECzzt9L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980001; c=relaxed/simple;
	bh=0kwNu5CnR5zCeHYPRriV8z2HirUgV51SC9SNtKnr04w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWfXy8VSKLnigsUsAJSpch0BiyG8jl4pTSEW7hq6Xj+XSrWbHThei2LFhRBiHTvcsfCY6+oZRanp1UxoIVuv/A0L+cfPiOKaAPQiAcWW7gG/uWLL8UQ72eTS2ZmVrZDoK34NYlCHwJIG0DSuDYZFsTfQvnGMPGDoKztIgRhBAEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vaE8qyUa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vaE8qyUa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE201F000E9;
	Mon, 17 Aug 2026 15:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979999;
	bh=uDVeRzbfPFp69zk3QDjGPUsJwLvDRZO4BkpcVKGBjiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vaE8qyUatGPhCX0nQyFQ0wyVwWnzr0zxRkP6AqBOvc+Yf8xjusf59x4A0pAG4ugBl
	 PXlkgDh8RERw3/hkgz4t/U3L0m90NuVQCuDMHM4G1Fdsl8FShhSZDeiRCdyqpD+Z4O
	 7C8LrhW2iJPVfmDPCo0PaSFumS8/sMR0Xs7nA6Xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 421/609] vxlan: use neigh_ha_snapshot() in route_shortcircuit()
Date: Mon, 17 Aug 2026 15:31:57 +0200
Message-ID: <20260817132558.205093798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
@@ -2204,9 +2204,11 @@ static bool route_shortcircuit(struct ne
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
@@ -2214,7 +2216,7 @@ static bool route_shortcircuit(struct ne
 			}
 			memcpy(eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
 				dev->addr_len);
-			memcpy(eth_hdr(skb)->h_dest, n->ha, dev->addr_len);
+			memcpy(eth_hdr(skb)->h_dest, haddr, dev->addr_len);
 		}
 		neigh_release(n);
 		return diff;



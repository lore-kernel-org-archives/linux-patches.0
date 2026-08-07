Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC869314A95;
	Fri,  7 Aug 2026 15:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115353; cv=none; b=L7pa19n46HIhHXQxQ0IrvhQrQ0zCOh/sop1h53fYy3nRbze+mS6LdiGyp//v9QebJYn3Hb3KbS2SIDg9Nx0WhAc4+Ln3zLpesRrdah5rhlpbc3OwPGPTwVHH02LD06At+5l1P+8IwI2ArrbPFl0pKQFM2305KsMdQgNvFEZQ4XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115353; c=relaxed/simple;
	bh=+iqlPWYEk6HDR4HkYJLcgFpsrGfKinX4JfmQraGkV/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saLKRO2lKt/BCYVM9o8wpS4nN4HJJ1yEFkdRG9pm4NXWcF7V9oWWfBudjssi0fb90ElPSGBrKGkZ2cj1DQychQaIEd6cJgbdbkOIY5OPSR2GbtYvbwsKEUH4/sSXIpU0qzyuf2RFcP70TRXDmXw3QpoJBuHLqlpJFPcF1FHpMTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Svu30zMo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Svu30zMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456561F000E9;
	Fri,  7 Aug 2026 15:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115351;
	bh=9FgtM1jhK8LJ6uylPi+6RKdw2d2q2tZfFN9I5hX0wG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Svu30zMooCVuwoSvfZpkpeQgatlQf66G07ubgUE+7/zXPlZNdjp6ClPeSLLi8ulkS
	 1/zXdBDfpoREUUE9TRw8hayFSjwQhhEcvT/39twOU+DQJnpjudBaQp8D59PBfH7XWZ
	 +lhN6szDvZXQgKpmLIwrHZnfD3+PN7iOAoKN1IYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 247/396] vxlan: use neigh_ha_snapshot() in route_shortcircuit()
Date: Fri,  7 Aug 2026 16:36:47 +0200
Message-ID: <20260807143429.580586873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -2163,9 +2163,11 @@ static bool route_shortcircuit(struct ne
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
@@ -2173,7 +2175,7 @@ static bool route_shortcircuit(struct ne
 			}
 			memcpy(eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
 				dev->addr_len);
-			memcpy(eth_hdr(skb)->h_dest, n->ha, dev->addr_len);
+			memcpy(eth_hdr(skb)->h_dest, haddr, dev->addr_len);
 		}
 		neigh_release(n);
 		return diff;



Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE9133C1AD;
	Fri,  7 Aug 2026 15:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116165; cv=none; b=HNMRSiu5d9Ajc4vUT8mfs70svnRjMfMZ205u6nMPaLE4x4s4p0NGt1dtNnKZgvHJQw7xgsLyIUYsgGV6xU+zcKrVztxztTrqrXwH/knBfpb2Ef9xWzdP3ktbP3cy+6pMCAZiLp7RaV+TbhIynIkVc07xKC3eWx0D5IXjOvCQsP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116165; c=relaxed/simple;
	bh=BJBy8Pyl71nFQxYQHihZs8TS2ThOJaIbIVr1xCZwaQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABbdxyCUbnOAWdaZ1pioPbImRusmRfOEk5dpcWe4UyOlm4eLPe1Hs0aBr1g79zqwpbAoo3+kpEPYJJ0tPNW28oN+4sfzjIOt63k+Q5nMr+yPcgBb3cV3ixc+q3fx1OfERV2hXM0jJ5y1KbwlHpwj0UlEx2fCxsZD7CRc/gcH+q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCfFu7nw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCfFu7nw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936E11F000E9;
	Fri,  7 Aug 2026 15:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116164;
	bh=QU7gYWIpWxAiYRDAGZbLp41TvASNX1G+hozkuceeYi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tCfFu7nwl2WvPHsQ27RbZr3+seH2M4RAKmxQfLieeBDRXDt0kbkj9YmiPdSCDfxAy
	 fIMGRiR/Hqnp0O9/WaTaddlFrFp24KPctohspdOWWUlzlR4TODa+DQS7PhPOi9MDP9
	 YFpNmoA2HTK0fA/E29UY3UpYeKpOqVIL1UeeQnUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 135/261] vxlan: unclone skb head before modifying eth header in route_shortcircuit()
Date: Fri,  7 Aug 2026 16:38:12 +0200
Message-ID: <20260807143418.278409756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 760d36e737f2b3867762f42af36c663f55babcc4 upstream.

When route_shortcircuit() performs L3 short-circuit routing, it modifies
the Ethernet header of the skb in-place:
    memcpy(eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest, dev->addr_len);
    memcpy(eth_hdr(skb)->h_dest, n->ha, dev->addr_len);

If the incoming skb is cloned (for example by packet sockets, tcpdump, or
dev_queue_xmit), modifying the Ethernet header without uncloning can corrupt
the packet header for other readers holding a reference to the cloned skb.

Ensure the skb header is writable and unshared by calling skb_cow_head(skb, 0)
prior to updating the Ethernet header. If skb_cow_head() fails, abort short-circuiting
and return false to allow standard packet processing fallback.

Fixes: e4f67addf158 ("add DOVE extensions for VXLAN")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260723144249.759100-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2163,6 +2163,10 @@ static bool route_shortcircuit(struct ne
 
 		diff = !ether_addr_equal(eth_hdr(skb)->h_dest, n->ha);
 		if (diff) {
+			if (skb_cow_head(skb, 0)) {
+				neigh_release(n);
+				return false;
+			}
 			memcpy(eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
 				dev->addr_len);
 			memcpy(eth_hdr(skb)->h_dest, n->ha, dev->addr_len);



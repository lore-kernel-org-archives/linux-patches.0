Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B143C40F734;
	Mon, 17 Aug 2026 14:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977421; cv=none; b=U3IZJcUIQsZ7FYydbW9ZwgaDp472ekluy6l3z0vYOSp6gjPxDU4Vcyv73145dJL4iEkok2QpExYyumiSkIhc1bMZfKP2wey/Esv6lshO1fQE4fdrbz2xWX/Bid5NBMlPI3XgSJI2gUCudPyhodq7uzmKw/rieTROSxzeAY/8VJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977421; c=relaxed/simple;
	bh=v/KraeRBu8a1NBq5VrWgLwtX2H8N86Xmy7nvory2898=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZD2CX/XbOO19vCRFftuGRyfjtkYix11lQnfGY0WFc+8qzYNogcGYHKLaj5VBr8yAc7obwycZdGlS05du2EAsQ/1sU06gykNRPeiU7jF5xUPbdZwpXj2VF0OzQ8eRmmYm7xiUe7M4M4XL4yDcnMtawUWWwYOVbYS/FVtgBMY3jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjA4Eu/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjA4Eu/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A541F000E9;
	Mon, 17 Aug 2026 14:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977420;
	bh=kNlqk9CJYdhLbbAlg69GhxFkXaBt6NyWL/EdYiQbzT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jjA4Eu/qz0iPL5YwtpuY/aAXkdC0sPZ0sF/X07uzal+LmtYY1Khp5u33W0WfTCCn1
	 hg2NqIJW3k/Qh4QU9Q7jSTKMGOBx/FcXXKsEmAyT7UI/+6pD6hJPyeWQbc8Sx7Hyzq
	 MH2yvu0MeX3YwpG9b77xNzZmK1GxVEu8Da0D7N60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 324/456] vxlan: unclone skb head before modifying eth header in route_shortcircuit()
Date: Mon, 17 Aug 2026 15:31:54 +0200
Message-ID: <20260817132552.345222104@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2292,6 +2292,10 @@ static bool route_shortcircuit(struct ne
 
 		diff = !ether_addr_equal(eth_hdr(skb)->h_dest, n->ha);
 		if (diff) {
+			if (skb_cow_head(skb, 0)) {
+				neigh_release(n);
+				return false;
+			}
 			memcpy(eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
 				dev->addr_len);
 			memcpy(eth_hdr(skb)->h_dest, n->ha, dev->addr_len);



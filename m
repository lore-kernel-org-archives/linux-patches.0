Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3A443B3E3;
	Mon, 17 Aug 2026 14:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976148; cv=none; b=QmGhk8I02Zfbctv1pwoV9Co+yu4O6B3aAMkgF3oqa8CSNVUa8BA5XtTiusytsplxDh+Y1xFBmGPUghla2avmwEcfeFJHR4kNr8s89RhkqypZDDZnDeG2OWP1AaMhym6nNVd60PoiiUJsSvN7Zyf601oPP5wP3M3eBsu1vTlFtHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976148; c=relaxed/simple;
	bh=vJ+aAIP025Xr2KsYX3aY+6pu4Md/GI9sjX4imxTYsPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntI0vddb4Y9lY+6We/5lg/v4Yga0KD76qLgagfc+xVpMPC1N8/yNSpHdwmFKySpaNPpCCluqYeeD6bZwYeEhk+54ohLmLNx4jzOosnmVKR+NMhVeZpSy0FO+QvVd4QR7F1G0XNfWhz3Qi8lLhxZ/jl8SunQqbxnHp8m2lTQneaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cq0waes2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cq0waes2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ADA1F00A3A;
	Mon, 17 Aug 2026 14:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976147;
	bh=+/N5NRyuSpuk/MDTCgN2d1PC/+Uy+P0bRIoE7j4KS/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cq0waes2RzTbA6B3u7OsMkStXWBIi5L8lyZsBNCth60n2yaIthsr5BRzSf5KW/1UT
	 OpQ71hmfeRwZUoA9yUS7eJZmm5ouEoWs5N1Nl1LvJZjBGcygBLWSkxh0COkTf38TSu
	 yeH5CFYwJr3NHZ78YqlwND6u5yFn4rpnRaceE27k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 272/389] vxlan: unclone skb head before modifying eth header in route_shortcircuit()
Date: Mon, 17 Aug 2026 15:31:51 +0200
Message-ID: <20260817132549.785711673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
@@ -2291,6 +2291,10 @@ static bool route_shortcircuit(struct ne
 
 		diff = !ether_addr_equal(eth_hdr(skb)->h_dest, n->ha);
 		if (diff) {
+			if (skb_cow_head(skb, 0)) {
+				neigh_release(n);
+				return false;
+			}
 			memcpy(eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
 				dev->addr_len);
 			memcpy(eth_hdr(skb)->h_dest, n->ha, dev->addr_len);



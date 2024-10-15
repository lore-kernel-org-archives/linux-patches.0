Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE131F4FBD;
	Tue, 15 Oct 2024 12:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994413; cv=none; b=h4b//zhv0n21GhgKsnYEZhfxWQylSDPkmezieL2qEjnYe4qmMOSo++BT7S6/Li9hUFnzL8AYXOvOzatNSSHpOQDCa8z0ZJCfWo4Y1SUsQIaZJ4N9SdFoO8nIUhOPPTD5CdmB/YBotGoK4uS6bZzIz1o8VDzu/mBE9URdSmH7OP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994413; c=relaxed/simple;
	bh=EaM5lpq3zzbyus5bIfvJ5rkcYliUysf4YCuAqKL959M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbgemkRNkivwC2tZbS7dalWxGxdRVU5OH4C/eEhT7Gx07LkcoFG6DP2QXWbAH3jC1zP+FUFAGRojhrSglEpEaSGTPnWklVd1iWo9+njV7toSf+3DaSH/G7qj83jjJaXIFkEPeSbvmWcvvLBSu58Ia5pUufjNfPsVpOZu7KCjoX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJt+HtdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJt+HtdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B32C4CEC6;
	Tue, 15 Oct 2024 12:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994413;
	bh=EaM5lpq3zzbyus5bIfvJ5rkcYliUysf4YCuAqKL959M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJt+HtdFVz6wO0XjiFfEZcMnj71yrosgkSrLmWKRcWHva0JnUyNYbBg4oFY2w1vaM
	 EwDatvBNdWJJnp5n2tgy7PGWPS5CIG3yRYs7lrpY7f3e/AH1QRwOnjxbzyya+TsQnJ
	 wDnw+p/ieg4gej/LjBR9uePHFgzl6ODtplwZRGfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <jishi@redhat.com>,
	Antoine Tenart <atenart@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 686/691] net: vrf: determine the dst using the original ifindex for multicast
Date: Tue, 15 Oct 2024 13:30:34 +0200
Message-ID: <20241015112507.547795078@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Antoine Tenart <atenart@kernel.org>

commit f2575c8f404911da83f25b688e12afcf4273e640 upstream.

Multicast packets received on an interface bound to a VRF are marked as
belonging to the VRF and the skb device is updated to point to the VRF
device itself. This was fine even when a route was associated to a
device as when performing a fib table lookup 'oif' in fib6_table_lookup
(coming from 'skb->dev->ifindex' in ip6_route_input) was set to 0 when
FLOWI_FLAG_SKIP_NH_OIF was set.

With commit 40867d74c374 ("net: Add l3mdev index to flow struct and
avoid oif reset for port devices") this is not longer true and multicast
traffic is not received on the original interface.

Instead of adding back a similar check in fib6_table_lookup determine
the dst using the original ifindex for multicast VRF traffic. To make
things consistent across the function do the above for all strict
packets, which was the logic before commit 6f12fa775530 ("vrf: mark skb
for multicast or link-local as enslaved to VRF"). Note that reverting to
this behavior should be fine as the change was about marking packets
belonging to the VRF, not about their dst.

Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20221220171825.1172237-1-atenart@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vrf.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1384,8 +1384,8 @@ static struct sk_buff *vrf_ip6_rcv(struc
 
 	/* loopback, multicast & non-ND link-local traffic; do not push through
 	 * packet taps again. Reset pkt_type for upper layers to process skb.
-	 * For strict packets with a source LLA, determine the dst using the
-	 * original ifindex.
+	 * For non-loopback strict packets, determine the dst using the original
+	 * ifindex.
 	 */
 	if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
 		skb->dev = vrf_dev;
@@ -1394,7 +1394,7 @@ static struct sk_buff *vrf_ip6_rcv(struc
 
 		if (skb->pkt_type == PACKET_LOOPBACK)
 			skb->pkt_type = PACKET_HOST;
-		else if (ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL)
+		else
 			vrf_ip6_input_dst(skb, vrf_dev, orig_iif);
 
 		goto out;



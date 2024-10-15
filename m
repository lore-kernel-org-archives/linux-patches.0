Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410FE1B2183;
	Tue, 15 Oct 2024 13:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998565; cv=none; b=EJZdhLxRjad8FXnu4gzin9PrKGZVNuOBHIxdaK92UvqB7ruCkvSVkOeFcVJ04SNuKOLfxXxI1DtlxfG2626ZEeJxKDfhN7vNbc3LgdFzvnP2/K62NH02KZWBaAEJfBD4hl7Vcs6xlE7qfCFm9ej7u1NQLi/jfVAXpWcjwiaHI1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998565; c=relaxed/simple;
	bh=lLgzSOscctCHgZ6mDn+BlhBETU6lNfRg9YI3EtQgSXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AypKg255UEE66i5TYcURlZ/dtgIxIrdihiSJP3eEH0mAuywYEpQkyJQDjbs6fmt+dHiHwtvtkvq9o6BrFBUF+tBk6ZsmhrLrxaPEo3qkzLhQLnMxJMi087cuBLiWKCNNtM8oY1PtKij79louIS2ZWEd5H29v/tGv+l0zJCIY1G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5tCr1nf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5tCr1nf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B665AC4CEC6;
	Tue, 15 Oct 2024 13:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998565;
	bh=lLgzSOscctCHgZ6mDn+BlhBETU6lNfRg9YI3EtQgSXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5tCr1nfCrxnERnGTdZ9n0yUBBJ0i1pCGWKnfUaLJ1jKY0+gmepDevO/H07S8ouOF
	 M+RKKvk/2tzn7jkXac0Mpt44yz5K1SC/wfFOqhbnGLig/lGgG/Smmh7BZGdj0644QH
	 hdTZghy2Zv67Uln8SzCsSigKOgrN4/qaXh7YCSy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <jishi@redhat.com>,
	Antoine Tenart <atenart@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 515/518] net: vrf: determine the dst using the original ifindex for multicast
Date: Tue, 15 Oct 2024 14:46:59 +0200
Message-ID: <20241015123936.866342636@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1336,8 +1336,8 @@ static struct sk_buff *vrf_ip6_rcv(struc
 
 	/* loopback, multicast & non-ND link-local traffic; do not push through
 	 * packet taps again. Reset pkt_type for upper layers to process skb.
-	 * For strict packets with a source LLA, determine the dst using the
-	 * original ifindex.
+	 * For non-loopback strict packets, determine the dst using the original
+	 * ifindex.
 	 */
 	if (skb->pkt_type == PACKET_LOOPBACK || (need_strict && !is_ndisc)) {
 		skb->dev = vrf_dev;
@@ -1346,7 +1346,7 @@ static struct sk_buff *vrf_ip6_rcv(struc
 
 		if (skb->pkt_type == PACKET_LOOPBACK)
 			skb->pkt_type = PACKET_HOST;
-		else if (ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL)
+		else
 			vrf_ip6_input_dst(skb, vrf_dev, orig_iif);
 
 		goto out;



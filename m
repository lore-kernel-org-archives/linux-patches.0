Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1689441CB50;
	Fri,  4 Sep 2026 06:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502387; cv=none; b=cEgMvUBZkvFCg1DrzJf6mVwrl8CS2vyXhDypqCjBe4/FackDiLO3dXhfOMvZCmtzy5nqRmmk/zZhHLJCpS6YJJICnleU54YezmlJTwzgZ3ZDW4nliRta9GrSmEkuyk6iU7CoV9zSkwWJlD2/A71tVaTuE/fLEyS2AZApyo3pyt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502387; c=relaxed/simple;
	bh=0i5xD6+8YwXmqgz9Cl3ayJ7LWWiS+MYMjOV7jjSNNC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u37aPFFu39xkTw8ECXScEgXQWevgAMsJ4wSGzA578MckX+DxQ/z0VpOhYl2bizrAVlJgxw+lLkcvln1355PKMDafLJszADdJRnmogKciv/q9Rd0TWuCjwS0yudUCe7WIDcRdfHf1u/fvC/+cfwiUjqrM8bMIEtXHJyA3sqxMphA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjJIpH9p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjJIpH9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0B11F00A3D;
	Fri,  4 Sep 2026 06:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502385;
	bh=Ib7UxRjTRSPi+jnEdgEtlryvgu2GBLPGLnTJbmZ48VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xjJIpH9p7xvv7hzg5EriNSVLa0yHp5bbcJgBQuy24EoARteFh/k44xmpY/ejtcpj/
	 nnCJIWa6cTwbceSgVtVP5wNBAirbNZ7fDLx0xkRJSSq2ON6DG8Y41VF2iGlZuNe4rL
	 jLuLwh4YjD094EASqXVycdgqMVKRZsA9l5DNodhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 190/403] ip6_tunnel: use skb_cow_head() in ip6_tnl_xmit()
Date: Fri,  4 Sep 2026 06:59:53 +0200
Message-ID: <20260904045739.178369679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

commit 87f21b59ddc618eff9670c174842964ad65fdade upstream.

ip6_tnl_xmit() may need to expand headroom before it can push the
outer IPv6 and optional encap headers. It currently does that with
skb_realloc_headroom(), copies skb->sk ownership, consumes the original
skb, and then continues processing with the replacement skb kept only in
its local variable.

That is safe only if the helper cannot fail afterwards. But this helper
still has post-reallocation error exits. collect_md tunnels reject
non-NONE encap after the replacement, and ip6_tnl_encap() can also fail
later. In those cases the helper returns an error to its callers while
the caller still only has the original skb pointer.

Both ip6_tnl_start_xmit() and the IPv6 GRE paths free the caller skb on
error, so they can end up freeing an skb that ip6_tnl_xmit() already
consumed.

Use skb_cow_head() instead. It provides the required headroom and
writability without privately replacing the caller-owned skb, so later
error returns cannot leave callers with a stale pointer.

The Ethernet users, ip6gretap and ip6erspan, clear IFF_TX_SKB_SHARING
and already call skb_cow_head() before entering ip6_tnl_xmit(). They do
not rely on the removed skb_shared() reallocation. This also makes the
IPv6 tunnel path consistent with ip_tunnel_xmit().

Fixes: 058214a4d1df ("ip6_tun: Add infrastructure for doing encapsulation")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Link: https://patch.msgid.link/30807a062ccc5c9c8a5ec2c5eb805ef279c50bdd.1786452593.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_tunnel.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1228,19 +1228,8 @@ route_lookup:
 	 */
 	max_headroom += LL_RESERVED_SPACE(tdev);
 
-	if (skb_headroom(skb) < max_headroom || skb_shared(skb) ||
-	    (skb_cloned(skb) && !skb_clone_writable(skb, 0))) {
-		struct sk_buff *new_skb;
-
-		new_skb = skb_realloc_headroom(skb, max_headroom);
-		if (!new_skb)
-			goto tx_err_dst_release;
-
-		if (skb->sk)
-			skb_set_owner_w(new_skb, skb->sk);
-		consume_skb(skb);
-		skb = new_skb;
-	}
+	if (skb_cow_head(skb, max_headroom))
+		goto tx_err_dst_release;
 
 	if (t->parms.collect_md) {
 		if (t->encap.type != TUNNEL_ENCAP_NONE)



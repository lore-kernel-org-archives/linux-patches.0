Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F5A2AEEB;
	Sat, 12 Sep 2026 15:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227131; cv=none; b=SohJdzwODOI6z8/w+NMRo4dHb35QlQRZSkpemlfPYXqHASzDKatzpk6Muku0kuiu5BN0E/I8MyslUssKSsu5zVH34a2XhP7ShxlkpG+CuiF6iJ8sii9N8CU6uwe6NGcUd1sEhNvF653z8h0v42ITNyhqzCxTOITfAnJXepK50FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227131; c=relaxed/simple;
	bh=xxdrFsoMs5jPDzyX3qvDS0ZvW7bG+fc9rAdyO7o/MSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kr4a2HWQCzdeGwkR7BVExeBEFy7GWnJUIzHnWEEEpE6SFmFzacAA14RW4E0hO+Ym1u20H2SnilDvaf0qIo8anoIueQcbAa51bXjcyfHekjjzrEoTMrIRBS3Bl5wt3npU1DxVQ+r0/neaTy1A52hJvdjM0tdFToi3SYb5zz5mWyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5DIyOyD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5DIyOyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120D81F000FF;
	Sat, 12 Sep 2026 15:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227130;
	bh=t1+GI4Jy2gXCUCNFOGi/eU8cHtbss2siRf+CLX+Jdqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X5DIyOyDP2HAm8OaCDlyRg3LaJRy/DiZxRqMhA+n8cfCvfxKLubo4UrwFlCx2ezJN
	 FmL1PY5Ow8xhLifjCJ26yQ/RAM5KI71s+y0KPFqg8+IlIYFKmQ4a+/bkpE4CzxbJCe
	 ZOi+10By/G7Avuh3XjxLUEM9Ce3qMc4l9cezLs8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 0119/1191] ip6_gre: fix hardware header length for NBMA tunnels
Date: Sat, 12 Sep 2026 08:47:27 +0200
Message-ID: <20260912065550.862336543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

commit 505b6d296c486ef7d1274f279d4c43a172f63224 upstream.

ip6gre_tnl_link_config_route() accumulates the lower device's hardware
header length into dev->hard_header_len whenever header_ops is set. This
is incorrect for both users of header_ops.

ip6gretap and ip6erspan have a fixed Ethernet hardware header length.
For an NBMA ip6gre tunnel, ip6gre_header() creates only the GRE header,
the optional FOU or GUE header, and the outer IPv6 header. The lower
device header is headroom needed later, not part of the tunnel device's
hardware header.

Keep the lower device header in needed_headroom. Set hard_header_len to
the tunnel header length only for ARPHRD_IP6GRE devices with header_ops,
and leave the fixed Ethernet header length unchanged for tap and erspan
devices.

Fixes: 832ba596494b ("net: ip6_gre: set dev->hard_header_len when using header_ops")
Cc: stable@vger.kernel.org
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/64b46542bbe1701f07702aaa50273e2a87903db5.1786542637.git.zhilinz@nebusec.ai
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_gre.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1173,13 +1173,8 @@ static void ip6gre_tnl_link_config_route
 			return;
 
 		if (rt->dst.dev) {
-			unsigned short dst_len = rt->dst.dev->hard_header_len +
-						 t_hlen;
-
-			if (t->dev->header_ops)
-				dev->hard_header_len = dst_len;
-			else
-				dev->needed_headroom = dst_len;
+			dev->needed_headroom = rt->dst.dev->hard_header_len +
+					       t_hlen;
 
 			if (set_mtu) {
 				int mtu = rt->dst.dev->mtu - t_hlen;
@@ -1207,8 +1202,8 @@ static int ip6gre_calc_hlen(struct ip6_t
 
 	t_hlen = tunnel->hlen + sizeof(struct ipv6hdr);
 
-	if (tunnel->dev->header_ops)
-		tunnel->dev->hard_header_len = LL_MAX_HEADER + t_hlen;
+	if (tunnel->dev->header_ops && tunnel->dev->type == ARPHRD_IP6GRE)
+		tunnel->dev->hard_header_len = t_hlen;
 	else
 		tunnel->dev->needed_headroom = LL_MAX_HEADER + t_hlen;
 



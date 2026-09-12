Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A562A344DBD;
	Sat, 12 Sep 2026 17:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232877; cv=none; b=sMLOCP3LxgRtNLnVo07RRLTMdtpu1rc9kG4AeTyjPlPeTW2HllUzZFQSfSdSDdewMd7LUph+JbAV2UAmwUtuS97D1zth1QZoH7/eH3X72vYFWifH3GbnnE0FFlbOYo0hPct1ynzmprzJSRJ5O6kByzgYSWWzchP4GroNHt2qDek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232877; c=relaxed/simple;
	bh=URf7SuEJfX1kvyz4ihI/jJHjzKYvNXwrx5uJ1lVOaVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTrT9+hpr1hEBJ7IUpcfkcPpy3Zgm+AMygqy++XVNXmScxxxOQrDWOOVBmH4T6Zrm8zMrYpJ4zBzQ17jG7QH3vXUx4cpJ05grq3SRWY1enStja0E+toFhRBAqHwSR9BQUEBS2LSrLUG4Sbeom+Dmd/YoCBeaMjbH+ZGJH8pJwN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZVER3vG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZVER3vG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0CB1F000FF;
	Sat, 12 Sep 2026 17:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232876;
	bh=gusTSeWs4Z8fX/CCxU5hvWh3t9vk1EBIJO4e+8dA8QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZVER3vG1wZ/XbrNi0mGl0hq0oZuxIpUzauCkXm2i8VdHzfA2m04Nx713EALciNZ5
	 fwMeMs3Cn31v37F+ugXcWEO8N+Bfm4U7PEJ6ybKEQ6aDJax3i/UKnw1pOQYLF3lmV8
	 WMIDPxd7tLygmoFcJ+QwsayNc4cON/MhNbqRzvME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 100/935] ip6_gre: fix hardware header length for NBMA tunnels
Date: Sat, 12 Sep 2026 08:52:10 +0200
Message-ID: <20260912065529.115460207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
@@ -1151,13 +1151,8 @@ static void ip6gre_tnl_link_config_route
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
@@ -1185,8 +1180,8 @@ static int ip6gre_calc_hlen(struct ip6_t
 
 	t_hlen = tunnel->hlen + sizeof(struct ipv6hdr);
 
-	if (tunnel->dev->header_ops)
-		tunnel->dev->hard_header_len = LL_MAX_HEADER + t_hlen;
+	if (tunnel->dev->header_ops && tunnel->dev->type == ARPHRD_IP6GRE)
+		tunnel->dev->hard_header_len = t_hlen;
 	else
 		tunnel->dev->needed_headroom = LL_MAX_HEADER + t_hlen;
 



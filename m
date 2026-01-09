Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48671335561;
	Fri,  9 Jan 2026 11:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959791; cv=none; b=nn1cAml2AGzf+GSIAaBQwerRxKpjUfqDz0mlnK60DkpXTSQ2HjCz0a2DHnRCafWhH5i8nxSHybjauuHITd5u5pGh0F/0UblNDDjSEOGApw984tk6ey2ge94vllZnShha13o5r38Zo+NuGn5EcI9Ufbzhb46QHm/kJ3/7dQ2VuEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959791; c=relaxed/simple;
	bh=4NYoMnBG2lHhaOYipHZBAPteiswGp7z/lvPOy4ocaMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRH4dzN2p8nH2218sBHCt6toYVZQGXuRM3ee7WjCrM4Hw5ZYlscjJ7QNMfbBPKDS6OjoLADcs9p1fl8yUxgNEZX3ZGmJe/RU6mKj22Zbv0IF/BveYYoTNYxH6JLYOaK7FnisQfHkLI3TD/86u0K4GwONh0ZQrXkbHs5ojBQ8xE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNNf3T5E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNNf3T5E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D3AC4CEF1;
	Fri,  9 Jan 2026 11:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959791;
	bh=4NYoMnBG2lHhaOYipHZBAPteiswGp7z/lvPOy4ocaMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNNf3T5E+VLrNxn/P9rTEmklpZaDi6aF3N4bK7pwf2bC571dnaeDAC6mZs9Wo271Q
	 iPrXou0ZCfzizM0nJl2K2MkKBRalTS6VEsfkEy4ZpAR3KImWcLigzEf/WeHnB8Ji8N
	 Hj80Mlbch/uPB5S8HRuf0Z6dHwk84SUhkm+79meY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Garri Djavadyan <g.djavadyan@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 175/737] ipv6: clear RA flags when adding a static route
Date: Fri,  9 Jan 2026 12:35:14 +0100
Message-ID: <20260109112140.574945818@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit f72514b3c5698e4b900b25345e09f9ed33123de6 ]

When an IPv6 Router Advertisement (RA) is received for a prefix, the
kernel creates the corresponding on-link route with flags RTF_ADDRCONF
and RTF_PREFIX_RT configured and RTF_EXPIRES if lifetime is set.

If later a user configures a static IPv6 address on the same prefix the
kernel clears the RTF_EXPIRES flag but it doesn't clear the RTF_ADDRCONF
and RTF_PREFIX_RT. When the next RA for that prefix is received, the
kernel sees the route as RA-learned and wrongly configures back the
lifetime. This is problematic because if the route expires, the static
address won't have the corresponding on-link route.

This fix clears the RTF_ADDRCONF and RTF_PREFIX_RT flags preventing that
the lifetime is configured when the next RA arrives. If the static
address is deleted, the route becomes RA-learned again.

Fixes: 14ef37b6d00e ("ipv6: fix route lookup in addrconf_prefix_rcv()")
Reported-by: Garri Djavadyan <g.djavadyan@gmail.com>
Closes: https://lore.kernel.org/netdev/ba807d39aca5b4dcf395cc11dca61a130a52cfd3.camel@gmail.com/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20251115095939.6967-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index ab84e2dd682f8..646ff1276aff2 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1136,6 +1136,10 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 					fib6_set_expires(iter, rt->expires);
 					fib6_add_gc_list(iter);
 				}
+				if (!(rt->fib6_flags & (RTF_ADDRCONF | RTF_PREFIX_RT))) {
+					iter->fib6_flags &= ~RTF_ADDRCONF;
+					iter->fib6_flags &= ~RTF_PREFIX_RT;
+				}
 
 				if (rt->fib6_pmtu)
 					fib6_metric_set(iter, RTAX_MTU,
-- 
2.51.0




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C19D343D79;
	Tue, 16 Dec 2025 11:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884402; cv=none; b=tHKLmGfKK4n3pBDRJNykaXmO5YeuV52jArnLlrZycDnEH07/hq1pB3LmHrxvUpbAa/zmRYKSvsiaMidkyxq69BAuFt/Jbgf0tAseukDXcf5Ju+aB8C8lMqRjcBXDVPMVWTuwsdHWsvdy6bNkNM++efnUrtsrhD3LpjH0XhozayU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884402; c=relaxed/simple;
	bh=rKtC7eqXwPEa8+Yic44D3DJyho9L8ZKfZjEBTxzYuqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmxIzsZXma/PB7kiMo9GBowj7U2jdiB+H42IiKgIpY5Cb1R6V0Ce0oAriM9FeNz9Ck+P0DIfZWWe6qWCuIJuXYLRvPSN90yyrW942Mi+JEOPxU9/OvMenM2/e/8pYfGochKOunIneboi94g9nPwdCS4v/pa4rzGnD76DeW6CZR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vw26n1KK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vw26n1KK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0F1C4CEF5;
	Tue, 16 Dec 2025 11:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884402;
	bh=rKtC7eqXwPEa8+Yic44D3DJyho9L8ZKfZjEBTxzYuqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vw26n1KKFGcXzznkpEr92IMd4Qr6M632E+QICnXlcd+Q75HPOziX9GLVIBvWeuG9l
	 uFNYVQAYu97KZ9HZwAu0hmDVmeFBPX/VKojXzUXarxwjqL1c7iT4XKAEEgSW3kLE7e
	 qPSwzSOZSML4qu+hdZcRSNATGByMyVAy7dnWWRtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Garri Djavadyan <g.djavadyan@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/354] ipv6: clear RA flags when adding a static route
Date: Tue, 16 Dec 2025 12:12:30 +0100
Message-ID: <20251216111327.542259250@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index aa1046fbf28e5..ebfe2b9b11b7e 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1138,6 +1138,10 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
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




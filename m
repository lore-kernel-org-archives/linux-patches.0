Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABB7415F1A;
	Tue, 21 Jul 2026 19:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663023; cv=none; b=DtQrAatgl3zb+NbvkmGimSMk+Xnmy9vg3AMfgE0oBrRIu3ysb4oALFoUNiV0lO4mXULeVR7uLSbFn7P3UF/TRpA0X2RdAKG3GVSS586LaGkkrxGAB11RJmOWi2CfFLVsP2JtHnCUaJByVEv6+uBXw6h4aHpj/T+5bsQ7LVfUZ4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663023; c=relaxed/simple;
	bh=8mAWMNp5BWu4lJfoq60gCRkQ99B3VrQ17ETKRen+FI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMh0GJTXmk4uttSdIm/04pt4e3ydcK0UR2PdB5LLneIDlXyv6d7S0xiRQNP3+lZmDsTVtJz3WtDtKg+LiGJOh/uTq+i2DWs7SAVt5ff1Idr3NIhNZ5Qu37Z1EHru2AHrAIg45zl8RGWdUwGbWk1pv4b7paSErO43zFpsoddZZKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9oQ0//J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9oQ0//J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E2C1F000E9;
	Tue, 21 Jul 2026 19:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663022;
	bh=7gM7+2Tovm5qcxVWd4zAz5jwRtCUoB6x7RR9cMAUnAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l9oQ0//JuLqMPAMCgRrGVqK0zniL0xD1Bs4lDEtFuskUPr4nQ1QRP7CHNX2/zWuFs
	 Sa2lJdt3OK3VvP8K7woFo3VisjCjZqEINAjUhEwgvPXiQhyUz0igQoVn2ivYEP9r/T
	 PxADhQFwRG3QlqzeGJ/XoZjtJ/nl6BZKmebqtgsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0666/1276] ipv6: fix missing notification for ignore_routes_with_linkdown
Date: Tue, 21 Jul 2026 17:18:29 +0200
Message-ID: <20260721152501.008660825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

[ Upstream commit 17dc3b245de45b1f2012e3a48ec51889f544e67b ]

When changing the ignore_routes_with_linkdown sysctl for a specific
interface, the RTM_NEWNETCONF netlink notification was not being emitted
to userspace. Fix this by emitting the notification when needed.

In addition, fix bogus return value for successful "all" and specific
interface write operation leading to a wrong reset of the position
pointer.

Fixes: 35103d11173b ("net: ipv6 sysctl option to ignore routes when nexthop link is down")
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260622130857.5115-7-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index d957a6ce3305cc..9fe7851029e252 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -948,11 +948,7 @@ static int addrconf_fixup_linkdown(const struct ctl_table *table, int *p, int ne
 						     NETCONFA_IGNORE_ROUTES_WITH_LINKDOWN,
 						     NETCONFA_IFINDEX_DEFAULT,
 						     net->ipv6.devconf_dflt);
-		rtnl_net_unlock(net);
-		return 0;
-	}
-
-	if (p == &net->ipv6.devconf_all->ignore_routes_with_linkdown) {
+	} else if (p == &net->ipv6.devconf_all->ignore_routes_with_linkdown) {
 		WRITE_ONCE(net->ipv6.devconf_dflt->ignore_routes_with_linkdown, newf);
 		addrconf_linkdown_change(net, newf);
 		if ((!newf) ^ (!old))
@@ -961,11 +957,21 @@ static int addrconf_fixup_linkdown(const struct ctl_table *table, int *p, int ne
 						     NETCONFA_IGNORE_ROUTES_WITH_LINKDOWN,
 						     NETCONFA_IFINDEX_ALL,
 						     net->ipv6.devconf_all);
+	} else {
+		if (!newf ^ !old) {
+			struct inet6_dev *idev = table->extra1;
+
+			inet6_netconf_notify_devconf(net,
+						     RTM_NEWNETCONF,
+						     NETCONFA_IGNORE_ROUTES_WITH_LINKDOWN,
+						     idev->dev->ifindex,
+						     &idev->cnf);
+		}
 	}
 
 	rtnl_net_unlock(net);
 
-	return 1;
+	return 0;
 }
 
 #endif
-- 
2.53.0




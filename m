Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC39444607D;
	Tue, 21 Jul 2026 19:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661188; cv=none; b=PPq+/L1cyPToAuZI3X5zGEvN4UZCwrBW6nqQeLjPMUSKR7jultXuVSuDGyPK3dwch++ox9dCD1ME1ZXvZ33pB3C3Dgqnmw97n7BQLR/eJwJqE4pMR1ops3E3CRr81jVsfuNGoLsQarleZRMPVb6aGU1+gIvC1gTjsbRfAnx130I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661188; c=relaxed/simple;
	bh=Gl1jvrR1tIcymi5PpTlfE+W4Nkydbae1gstt1SJsYXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eI6mF3XC8AcjXPY0UAEM3VqYjxkCYtIhK6o/BfBlrYY1H7hjuM602fovScVsBmiHCQSv/TanIpOUeO2/PwJxI/MjzgUfbWvLix1Bacc/uegsijQc41UeMr6mENp61RBKb/+0j+KYvF6GhPdll1YTSHp1m5eZCwu+J9uQOwMah08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSbHms3v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSbHms3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE021F000E9;
	Tue, 21 Jul 2026 19:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661187;
	bh=kqfH+xvAIos64dn+F1AF6ggKYFjJjIHHtWNE/Qv0X8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qSbHms3vtloKC6BdqWgDmvRR28xDYSSIfpuCQz/huk65Y68Jr1n2OePzqDW6UOuf9
	 9tuR6MxDlZ3mXP443WwS5nxQBVWClD5XkjD9PxrLg9hhEZbgJn0PCgbS0TmIsEpv0j
	 TDvSefZIwg4S3G2SKtVUy5Ne6ba6OAjGuzz9toVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1264/2077] ipv6: fix missing notification for ignore_routes_with_linkdown
Date: Tue, 21 Jul 2026 17:15:37 +0200
Message-ID: <20260721152622.628927442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 400cde904737cb..defa4277e783f9 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -955,11 +955,7 @@ static int addrconf_fixup_linkdown(const struct ctl_table *table, int *p, int ne
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
@@ -968,11 +964,21 @@ static int addrconf_fixup_linkdown(const struct ctl_table *table, int *p, int ne
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




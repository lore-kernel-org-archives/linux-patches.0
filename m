Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141951FCCFB;
	Fri,  6 Dec 2024 15:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497826; cv=none; b=u/uPWdfMFJmVOjW8+fAM2HJOFJ6YzMVFQHU0x0cTrPUGD/mb9YKZ4CCF0KuGWgukIzt0CGyK++FfldujlpCMdXbAsYW3DbuYkgpwPeMWC4++u1b2h1+6PNU6UbOscifbibwqqi4ePjEEvLVGnKYgs3lfwZ8vvSZAzjPPyoFBVXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497826; c=relaxed/simple;
	bh=fgZ/QKD6PFv25OboB/mYiKRjJ/F2jH7rjP0OLCSoxF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eqX3kOMGN4+BbveWjGcJf/JkbGcxKEySCUCUveNVo71vsZ9S3jTxkfXaE8aBMQm3TeQkF2jPUlpxbXWvh+/vE8oZYxfY1YRsbL3OZdrftjczse5y3dEaXQndzmGBYr9thmR/oBsyP6BYssbG7Oj/JbolnU/t20EfD/wlBflI/kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hxy7l+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hxy7l+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F46C4CEE0;
	Fri,  6 Dec 2024 15:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497825;
	bh=fgZ/QKD6PFv25OboB/mYiKRjJ/F2jH7rjP0OLCSoxF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1hxy7l+gFIVSEAYSai514sAEiYFFvdIt5AHvnXPOATEUEA/YeZEZuhf0zuOGuOSJC
	 KCUxn5zpqLq5HQPOSnSDjj0vFKDt2kUJrXnjr+LUB5djMyO1aEVWY7T4+eQVQs7nFR
	 VTdxqxEfA2yjwY2QHM8mJXXaCjUr7rT2D2SaB8Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 404/676] net/ipv6: delete temporary address if mngtmpaddr is removed or unmanaged
Date: Fri,  6 Dec 2024 15:33:43 +0100
Message-ID: <20241206143709.128491354@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 00b5b7aab9e422d00d5a9d03d7e0760a76b5d57f ]

RFC8981 section 3.4 says that existing temporary addresses must have their
lifetimes adjusted so that no temporary addresses should ever remain "valid"
or "preferred" longer than the incoming SLAAC Prefix Information. This would
strongly imply in Linux's case that if the "mngtmpaddr" address is deleted or
un-flagged as such, its corresponding temporary addresses must be cleared out
right away.

But now the temporary address is renewed even after ‘mngtmpaddr’ is removed
or becomes unmanaged as manage_tempaddrs() set temporary addresses
prefered/valid time to 0, and later in addrconf_verify_rtnl() all checkings
failed to remove the addresses. Fix this by deleting the temporary address
directly for these situations.

Fixes: 778964f2fdf0 ("ipv6/addrconf: fix timing bug in tempaddr regen")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index a9358c796a815..8360939acf85a 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2535,6 +2535,24 @@ static struct inet6_dev *addrconf_add_dev(struct net_device *dev)
 	return idev;
 }
 
+static void delete_tempaddrs(struct inet6_dev *idev,
+			     struct inet6_ifaddr *ifp)
+{
+	struct inet6_ifaddr *ift, *tmp;
+
+	write_lock_bh(&idev->lock);
+	list_for_each_entry_safe(ift, tmp, &idev->tempaddr_list, tmp_list) {
+		if (ift->ifpub != ifp)
+			continue;
+
+		in6_ifa_hold(ift);
+		write_unlock_bh(&idev->lock);
+		ipv6_del_addr(ift);
+		write_lock_bh(&idev->lock);
+	}
+	write_unlock_bh(&idev->lock);
+}
+
 static void manage_tempaddrs(struct inet6_dev *idev,
 			     struct inet6_ifaddr *ifp,
 			     __u32 valid_lft, __u32 prefered_lft,
@@ -3076,11 +3094,12 @@ static int inet6_addr_del(struct net *net, int ifindex, u32 ifa_flags,
 			in6_ifa_hold(ifp);
 			read_unlock_bh(&idev->lock);
 
-			if (!(ifp->flags & IFA_F_TEMPORARY) &&
-			    (ifa_flags & IFA_F_MANAGETEMPADDR))
-				manage_tempaddrs(idev, ifp, 0, 0, false,
-						 jiffies);
 			ipv6_del_addr(ifp);
+
+			if (!(ifp->flags & IFA_F_TEMPORARY) &&
+			    (ifp->flags & IFA_F_MANAGETEMPADDR))
+				delete_tempaddrs(idev, ifp);
+
 			addrconf_verify_rtnl(net);
 			if (ipv6_addr_is_multicast(pfx)) {
 				ipv6_mc_config(net->ipv6.mc_autojoin_sk,
@@ -4891,14 +4910,12 @@ static int inet6_addr_modify(struct net *net, struct inet6_ifaddr *ifp,
 	}
 
 	if (was_managetempaddr || ifp->flags & IFA_F_MANAGETEMPADDR) {
-		if (was_managetempaddr &&
-		    !(ifp->flags & IFA_F_MANAGETEMPADDR)) {
-			cfg->valid_lft = 0;
-			cfg->preferred_lft = 0;
-		}
-		manage_tempaddrs(ifp->idev, ifp, cfg->valid_lft,
-				 cfg->preferred_lft, !was_managetempaddr,
-				 jiffies);
+		if (was_managetempaddr && !(ifp->flags & IFA_F_MANAGETEMPADDR))
+			delete_tempaddrs(ifp->idev, ifp);
+		else
+			manage_tempaddrs(ifp->idev, ifp, cfg->valid_lft,
+					 cfg->preferred_lft, !was_managetempaddr,
+					 jiffies);
 	}
 
 	addrconf_verify_rtnl(net);
-- 
2.43.0




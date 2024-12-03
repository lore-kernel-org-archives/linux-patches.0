Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DB61F472A;
	Tue,  3 Dec 2024 15:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239442; cv=none; b=kESKOmcYxnPyx/rfRa9Z2nA2YomJkJqPszpQDlXk6lawnBGf1wABGCaaJnumrgPzhYZ0F3SUaZsNCtTyGa672mascJEYGZJ6rV5cbcFph+M398i/VOBphZdMVu10mlwiCXPqsfHILZD0abNvUHU0QhxwcvI0R7MwFF+vt0QRcW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239442; c=relaxed/simple;
	bh=EpInqofDpp66MH3ONkg0t9l7MxkP8imqtJa0YzcjuuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l2B4o2MiyKKAKQ5/DbVdrqk6J83Lt8OPa0rkk8AXBzqrPxu3SuGhOTicXDwVmb06e12RTIHK+l70hwVS9ke7ls/VA1rg6uYJvpqYGTmgorSivMmX8Spkv4D/v8kvsk6TEewWmjBRtmsK7apmqTO2udZ1kIceYq45MLrhVMmnu9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgkCLuWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgkCLuWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB5BC4CECF;
	Tue,  3 Dec 2024 15:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239442;
	bh=EpInqofDpp66MH3ONkg0t9l7MxkP8imqtJa0YzcjuuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zgkCLuWsh+iuCwZGgWAavRHQZzshlcJI7SE+ocNQScrhDtL79n2zwaHnt6D9dZj1s
	 JY40jj+pwb0s+JWQfqV7p8ojTNUngmzME4SfnDsOrbhwjg0YlgI0z14MDNRZkLtDyh
	 TJ0YRSzhx6R+z2a3MS6+VonXgIKcLnYypTTmYDj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 574/817] net/ipv6: delete temporary address if mngtmpaddr is removed or unmanaged
Date: Tue,  3 Dec 2024 15:42:26 +0100
Message-ID: <20241203144018.318747718@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index f70d8757af1a4..acf190723b1ea 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2570,6 +2570,24 @@ static struct inet6_dev *addrconf_add_dev(struct net_device *dev)
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
@@ -3122,11 +3140,12 @@ static int inet6_addr_del(struct net *net, int ifindex, u32 ifa_flags,
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
@@ -4950,14 +4969,12 @@ static int inet6_addr_modify(struct net *net, struct inet6_ifaddr *ifp,
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




Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1729B4CDEC;
	Mon, 14 Oct 2024 14:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917132; cv=none; b=q7kTTvg5VRruGIPBdV0J7LfRmqHFwUcH2Z70FbOdZZAb8hjKHz4OAGpWFLA8Koly15dloGyTv09gL6Ci0i2XV42rJ8pq1/YPeBdZ/nrkguVt7Vh1Q0KlG+iqRLhCpPif/0iNyITfFbhpTbRLlTvlnckh2dA8fiQGAEbtfG3M+rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917132; c=relaxed/simple;
	bh=XekIE4Z7b9gVcb/RaN0LVRcNGjQ5VcEjVn5+iK3fROY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOEt/kcmGqyw20+asnqoUwQqyWtc0zq0hy227P4tvmUz16VIQRpspTLmy4+vmbZAHDe5aBeh0bVBD5uZn//Jx/uMZNxwU1AvwqaaKiL+lT+/ff5UFWI4anviZMilaZz3E162Qw39jRGVvIfrq2u6gHUxQnpo4mItVSr/pvozEOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtdtpjJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtdtpjJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7215CC4CEC3;
	Mon, 14 Oct 2024 14:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917131;
	bh=XekIE4Z7b9gVcb/RaN0LVRcNGjQ5VcEjVn5+iK3fROY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtdtpjJDmucHDxWanNoEwync1H1+QBls0lug1sA5Xafo7GYdLaDe7RIVfps0Z31Dd
	 vZij1cujA/eq9xLW9YhkucpPa1nK3tmfn/zKkiTtPD8hzYSVRVFZAroM4ejrk9I0HG
	 uGgB0VIB5D+da/TRcw/HLVW0Qdx1NOwWocX9OMm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Remi Denis-Courmont <courmisch@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/213] phonet: no longer hold RTNL in route_dumpit()
Date: Mon, 14 Oct 2024 16:21:06 +0200
Message-ID: <20241014141049.216872420@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 58a4ff5d77b187086eb12d41d613749420947f19 ]

route_dumpit() already relies on RCU, RTNL is not needed.

Also change return value at the end of a dump.
This allows NLMSG_DONE to be appended to the current
skb at the end of a dump, saving a couple of recvmsg()
system calls.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Remi Denis-Courmont <courmisch@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240507121748.416287-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b5e837c86041 ("phonet: Handle error of rtnl_register_module().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/phonet/pn_netlink.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/phonet/pn_netlink.c b/net/phonet/pn_netlink.c
index dd4c7e9a634fb..7008d402499d5 100644
--- a/net/phonet/pn_netlink.c
+++ b/net/phonet/pn_netlink.c
@@ -178,7 +178,7 @@ static int fill_route(struct sk_buff *skb, struct net_device *dev, u8 dst,
 	rtm->rtm_type = RTN_UNICAST;
 	rtm->rtm_flags = 0;
 	if (nla_put_u8(skb, RTA_DST, dst) ||
-	    nla_put_u32(skb, RTA_OIF, dev->ifindex))
+	    nla_put_u32(skb, RTA_OIF, READ_ONCE(dev->ifindex)))
 		goto nla_put_failure;
 	nlmsg_end(skb, nlh);
 	return 0;
@@ -263,6 +263,7 @@ static int route_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 static int route_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	struct net *net = sock_net(skb->sk);
+	int err = 0;
 	u8 addr;
 
 	rcu_read_lock();
@@ -272,16 +273,16 @@ static int route_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
 		if (!dev)
 			continue;
 
-		if (fill_route(skb, dev, addr << 2, NETLINK_CB(cb->skb).portid,
-			       cb->nlh->nlmsg_seq, RTM_NEWROUTE) < 0)
-			goto out;
+		err = fill_route(skb, dev, addr << 2,
+				 NETLINK_CB(cb->skb).portid,
+				 cb->nlh->nlmsg_seq, RTM_NEWROUTE);
+		if (err < 0)
+			break;
 	}
-
-out:
 	rcu_read_unlock();
 	cb->args[0] = addr;
 
-	return skb->len;
+	return err;
 }
 
 int __init phonet_netlink_register(void)
@@ -301,6 +302,6 @@ int __init phonet_netlink_register(void)
 	rtnl_register_module(THIS_MODULE, PF_PHONET, RTM_DELROUTE,
 			     route_doit, NULL, 0);
 	rtnl_register_module(THIS_MODULE, PF_PHONET, RTM_GETROUTE,
-			     NULL, route_dumpit, 0);
+			     NULL, route_dumpit, RTNL_FLAG_DUMP_UNLOCKED);
 	return 0;
 }
-- 
2.43.0



